/**
 * server/rotas/recuperacao.js — esqueci minha senha
 *
 * Três passos, três rotas, e nenhum deles confia no passo anterior ter
 * acontecido no navegador:
 *
 *   1. POST /api/auth/recuperar        { email }            -> manda o código
 *   2. POST /api/auth/conferir-codigo  { email, codigo }    -> devolve um ticket
 *   3. POST /api/auth/nova-senha       { email, ticket, senha }
 *
 * POR QUE TUDO AQUI E NADA NO NAVEGADOR: trocar senha é tomar conta.
 * Se o navegador decidisse "o código bate", bastaria abrir o console e
 * responder que bate. O código, o prazo, as tentativas e a troca em si
 * acontecem deste lado, com a chave secreta.
 *
 * ESTAS ROTAS NÃO PASSAM PELO `autenticar`. Não podem: quem esqueceu a
 * senha não consegue entrar, então não tem token. É a única parte da
 * API aberta a quem não está logado — e por isso é a que mais precisa
 * de limite de tentativa e de prazo curto.
 */

const crypto = require('crypto');
const express = require('express');

const { admin } = require('../supabase');
const { falhou } = require('../erros');
const { enviarCodigo, conferirEndereco } = require('../email');

const rotas = express.Router();

// ── As regras do código ──────────────────────────────────────────────

// Letras maiúsculas e números. 36^5 = 60.466.176 combinações.
//
// Um aviso para quem for mexer: `O` e `0`, `I` e `1` são o mesmo rabisco
// em muitas fontes, e o código vai ser copiado à mão de um e-mail para
// a tela. Tirar esses quatro do alfabeto deixaria 32 símbolos e ainda
// 33 milhões de combinações. Está assim porque foi o pedido; é uma
// linha para mudar.
const ALFABETO = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const TAMANHO  = 5;

const VALIDADE_MIN  = 10;   // o código morre em 10 minutos
const TICKET_MIN    = 10;   // o ticket da terceira tela, idem
const MAX_TENTATIVAS = 5;   // erros antes de o código ser queimado
const MAX_POR_HORA   = 5;   // pedidos de código por e-mail, por hora
const ESPERA_SEG     = 60;  // intervalo mínimo entre dois pedidos

const SENHA_MIN = 6;        // o mesmo mínimo que o Supabase exige no cadastro

// A frase é SEMPRE esta, exista a conta ou não. É o que impede que a
// tela vire um detector de quem estuda na escola: sem isso, qualquer
// pessoa testaria e-mails um a um e saberia quais estão cadastrados.
const RESPOSTA_NEUTRA =
  'Se existir uma conta com esse e-mail, o código acabou de ser enviado.';


// ── Ferramentas ──────────────────────────────────────────────────────

/**
 * O código em si. `randomInt` do módulo crypto, e não Math.random():
 * Math.random() é previsível o bastante para alguém reconstruir a
 * sequência a partir de alguns códigos observados.
 */
function sortearCodigo() {
  let codigo = '';
  for (let i = 0; i < TAMANHO; i++) {
    codigo += ALFABETO[crypto.randomInt(ALFABETO.length)];
  }
  return codigo;
}

/**
 * Guardamos o hash, nunca o código.
 *
 * SHA-256 puro basta aqui, e não é o mesmo caso de uma senha: uma senha
 * vive anos e costuma ser palavra de dicionário; este código tem 60
 * milhões de possibilidades, morre em 10 minutos e só aceita 5 palpites.
 * Não há o que uma tabela de hashes prontos resolva.
 */
function embaralhar(texto) {
  return crypto.createHash('sha256').update(String(texto)).digest('hex');
}

/** Comparação em tempo constante: sem ela, o tempo de resposta conta
 *  quantos caracteres iniciais o palpite acertou. */
function iguais(a, b) {
  const x = Buffer.from(String(a));
  const y = Buffer.from(String(b));
  return x.length === y.length && crypto.timingSafeEqual(x, y);
}

function normalizarEmail(valor) {
  return String(valor || '').trim().toLowerCase();
}

// Formato, só. Não diz que a caixa existe — nada diz, de fora. Quem
// prova que o endereço é real é o código chegando nele.
const FORMATO_EMAIL = /^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i;

function daquiA(minutos) {
  return new Date(Date.now() + minutos * 60_000).toISOString();
}


// ── 0. O e-mail é real? ──────────────────────────────────────────────
//
// Usada pela tela de CADASTRO, antes de criar a conta. Vale a pena
// gastar uma consulta de DNS aqui: uma conta criada com o e-mail
// escrito errado é uma conta que nunca vai conseguir recuperar a senha,
// e o aluno só descobre isso no dia em que precisar.
//
// Repare no que ela NÃO responde: se já existe conta com esse e-mail.
// Essa pergunta é respondida no cadastro, quando a pessoa está de fato
// criando a conta — aqui viraria um jeito de varrer endereços.
rotas.post('/conferir-email', async (req, res) => {
  const email = normalizarEmail(req.body?.email);

  if (!FORMATO_EMAIL.test(email)) {
    return res.json({ ok: false, motivo: 'Esse e-mail não parece completo.' });
  }

  try {
    res.json(await conferirEndereco(email));
  } catch (erro) {
    // A conferência é um favor, não um portão. Se ela mesma quebrar, o
    // cadastro segue — barrar alguém por causa de um bug nosso é pior.
    console.error('  ✖ conferir-email:', erro.message);
    res.json({ ok: true });
  }
});


// ── 1. Pedir o código ────────────────────────────────────────────────

rotas.post('/recuperar', async (req, res) => {
  const email = normalizarEmail(req.body?.email);

  if (!FORMATO_EMAIL.test(email)) {
    return res.status(400).json({ message: 'Digite um e-mail válido.' });
  }

  // O domínio existe e recebe e-mail? Dizer isso não revela nada sobre
  // contas — "gmai.com não existe" é verdade para qualquer visitante.
  // E sem isto a pessoa ficaria esperando um código que saiu para um
  // endereço impossível.
  const endereco = await conferirEndereco(email);
  if (!endereco.ok) {
    return res.status(400).json({ message: endereco.motivo });
  }

  // Freio de abuso. Vem do banco e não da memória do processo: reiniciar
  // o servidor não pode zerar o limite de quem está martelando a rota.
  const umaHora = new Date(Date.now() - 3_600_000).toISOString();
  const recentes = await admin
    .from('codigos_recuperacao')
    .select('criado_em')
    .eq('email', email)
    .gte('criado_em', umaHora)
    .order('criado_em', { ascending: false });

  if (recentes.error) {
    return falhou(res, 500, 'Não foi possível enviar o código agora.',
                  recentes.error, 'POST /auth/recuperar');
  }

  const pedidos = recentes.data || [];

  if (pedidos.length >= MAX_POR_HORA) {
    return res.status(429).json({
      message: 'Muitos pedidos de código para este e-mail. Tente de novo daqui a uma hora.',
    });
  }

  if (pedidos.length) {
    const desdeOUltimo = (Date.now() - new Date(pedidos[0].criado_em).getTime()) / 1000;
    if (desdeOUltimo < ESPERA_SEG) {
      return res.status(429).json({
        message: `Aguarde ${Math.ceil(ESPERA_SEG - desdeOUltimo)} segundos para pedir outro código.`,
      });
    }
  }

  // A conta existe? A resposta ao usuário não muda — mas sem conta não
  // há para quem mandar, e gerar o código seria desperdício.
  const conta = await admin.rpc('conta_por_email', { p_email: email });

  if (conta.error) {
    return falhou(res, 500, 'Não foi possível enviar o código agora.',
                  conta.error, 'POST /auth/recuperar (conta_por_email)');
  }

  if (!conta.data) {
    console.log(`  · recuperação pedida para e-mail sem conta: ${email}`);
    return res.json({ message: RESPOSTA_NEUTRA });
  }

  // Faxina. A tabela só cresce, e nenhuma linha vencida serve para
  // nada: nem para conferir código, nem para o limite da última hora.
  // Vai de carona num pedido que já está mexendo nela.
  const ontem = new Date(Date.now() - 86_400_000).toISOString();
  await admin.from('codigos_recuperacao').delete().lt('criado_em', ontem);

  // Códigos antigos do mesmo e-mail morrem agora. Dois códigos vivos ao
  // mesmo tempo dobram a chance de alguém acertar um deles no chute.
  await admin
    .from('codigos_recuperacao')
    .update({ usado_em: new Date().toISOString() })
    .eq('email', email)
    .is('usado_em', null);

  const codigo = sortearCodigo();

  const gravou = await admin.from('codigos_recuperacao').insert({
    email,
    codigo_hash: embaralhar(codigo),
    expira_em: daquiA(VALIDADE_MIN),
  });

  if (gravou.error) {
    return falhou(res, 500, 'Não foi possível enviar o código agora.',
                  gravou.error, 'POST /auth/recuperar (insert)');
  }

  try {
    await enviarCodigo(email, codigo);
  } catch (erro) {
    // O e-mail não saiu, mas o código está gravado. Dizer "deu erro" aqui
    // revelaria que a conta existe — quem não tem conta recebeu a frase
    // neutra alguns passos acima. O detalhe fica no terminal.
    console.error('  ✖ falha ao enviar e-mail de recuperação:', erro.message);
  }

  res.json({ message: RESPOSTA_NEUTRA, validade_minutos: VALIDADE_MIN });
});


// ── 2. Conferir o código ─────────────────────────────────────────────

rotas.post('/conferir-codigo', async (req, res) => {
  const email  = normalizarEmail(req.body?.email);
  const codigo = String(req.body?.codigo || '').trim().toUpperCase();

  if (!FORMATO_EMAIL.test(email) || codigo.length !== TAMANHO) {
    return res.status(400).json({ message: 'Código inválido.' });
  }

  const agora = new Date().toISOString();

  const busca = await admin
    .from('codigos_recuperacao')
    .select('id, codigo_hash, tentativas, expira_em')
    .eq('email', email)
    .is('usado_em', null)
    .gt('expira_em', agora)
    .order('criado_em', { ascending: false })
    .limit(1)
    .maybeSingle();

  if (busca.error) {
    return falhou(res, 500, 'Não foi possível conferir o código.',
                  busca.error, 'POST /auth/conferir-codigo');
  }

  // Uma frase só para "não existe", "venceu" e "errado". Separá-las
  // contaria a quem está tentando em que parte ele chegou.
  const recusar = () =>
    res.status(400).json({ message: 'Código incorreto ou vencido. Peça um novo.' });

  const linha = busca.data;
  if (!linha) return recusar();

  if (linha.tentativas >= MAX_TENTATIVAS) {
    await admin.from('codigos_recuperacao')
      .update({ usado_em: agora }).eq('id', linha.id);
    return recusar();
  }

  if (!iguais(embaralhar(codigo), linha.codigo_hash)) {
    await admin.from('codigos_recuperacao')
      .update({ tentativas: linha.tentativas + 1 }).eq('id', linha.id);

    const restam = MAX_TENTATIVAS - (linha.tentativas + 1);
    return res.status(400).json({
      message: restam > 0
        ? `Código incorreto. ${restam} ${restam === 1 ? 'tentativa restante' : 'tentativas restantes'}.`
        : 'Código incorreto. Peça um novo código.',
    });
  }

  // Acertou. O código continua aberto (usado_em segue nulo) porque a
  // troca de senha ainda não aconteceu — se o aluno fechar a aba agora,
  // o mesmo código ainda serve dentro do prazo. O que muda é que existe
  // um ticket, e é ele que a próxima rota exige.
  const ticket = crypto.randomBytes(32).toString('hex');

  const marcou = await admin
    .from('codigos_recuperacao')
    .update({
      ticket_hash: embaralhar(ticket),
      ticket_expira_em: daquiA(TICKET_MIN),
      tentativas: 0,
    })
    .eq('id', linha.id);

  if (marcou.error) {
    return falhou(res, 500, 'Não foi possível conferir o código.',
                  marcou.error, 'POST /auth/conferir-codigo (ticket)');
  }

  res.json({ ticket, validade_minutos: TICKET_MIN });
});


// ── 3. Trocar a senha ────────────────────────────────────────────────

rotas.post('/nova-senha', async (req, res) => {
  const email  = normalizarEmail(req.body?.email);
  const ticket = String(req.body?.ticket || '');
  const senha  = String(req.body?.senha || '');

  if (!FORMATO_EMAIL.test(email) || !ticket) {
    return res.status(400).json({ message: 'Sessão de recuperação vencida. Comece de novo.' });
  }

  if (senha.length < SENHA_MIN) {
    return res.status(400).json({
      message: `A senha precisa de pelo menos ${SENHA_MIN} caracteres.`,
    });
  }

  const agora = new Date().toISOString();

  const busca = await admin
    .from('codigos_recuperacao')
    .select('id, ticket_hash, ticket_expira_em')
    .eq('email', email)
    .is('usado_em', null)
    .not('ticket_hash', 'is', null)
    .gt('ticket_expira_em', agora)
    .order('criado_em', { ascending: false })
    .limit(1)
    .maybeSingle();

  if (busca.error) {
    return falhou(res, 500, 'Não foi possível alterar a senha.',
                  busca.error, 'POST /auth/nova-senha');
  }

  const linha = busca.data;
  if (!linha || !iguais(embaralhar(ticket), linha.ticket_hash)) {
    return res.status(400).json({ message: 'Sessão de recuperação vencida. Comece de novo.' });
  }

  const conta = await admin.rpc('conta_por_email', { p_email: email });

  if (conta.error || !conta.data) {
    return falhou(res, 500, 'Não foi possível alterar a senha.',
                  conta.error, 'POST /auth/nova-senha (conta_por_email)');
  }

  const trocou = await admin.auth.admin.updateUserById(conta.data, { password: senha });

  if (trocou.error) {
    return falhou(res, 400,
      trocou.error.message?.includes('should be at least')
        ? `A senha precisa de pelo menos ${SENHA_MIN} caracteres.`
        : 'Não foi possível alterar a senha.',
      trocou.error, 'POST /auth/nova-senha (updateUserById)');
  }

  // Queima o código. Daqui em diante aquele papel no e-mail não vale
  // mais nada, mesmo dentro dos 10 minutos.
  await admin.from('codigos_recuperacao')
    .update({ usado_em: agora, ticket_hash: null }).eq('id', linha.id);

  console.log(`  · senha alterada por recuperação: ${email}`);

  res.json({ message: 'Senha alterada! Agora é só entrar com ela.' });
});


module.exports = rotas;
