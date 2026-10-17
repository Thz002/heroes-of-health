/** Recuperação de senha em 3 passos (código -> ticket -> nova senha). Sem `autenticar`. */

const crypto = require('crypto');
const express = require('express');

const { admin } = require('../supabase');
const { falhou } = require('../erros');
const { enviarCodigo, conferirEndereco } = require('../email');

const rotas = express.Router();

// ── As regras do código ──────────────────────────────────────────────

// Alfabeto do código: 36^5 combinações.
const ALFABETO = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const TAMANHO  = 5;

const VALIDADE_MIN  = 10;   // o código morre em 10 minutos
const TICKET_MIN    = 10;   // o ticket da terceira tela, idem
const MAX_TENTATIVAS = 5;   // erros antes de o código ser queimado
const MAX_POR_HORA   = 5;   // pedidos de código por e-mail, por hora
const ESPERA_SEG     = 60;  // intervalo mínimo entre dois pedidos

const SENHA_MIN = 6;        // o mesmo mínimo que o Supabase exige no cadastro

// Mesma resposta exista ou não a conta.
const RESPOSTA_NEUTRA =
  'Se existir uma conta com esse e-mail, o código acabou de ser enviado.';


// ── Ferramentas ──────────────────────────────────────────────────────

/** Código com crypto.randomInt (Math.random é previsível). */
function sortearCodigo() {
  let codigo = '';
  for (let i = 0; i < TAMANHO; i++) {
    codigo += ALFABETO[crypto.randomInt(ALFABETO.length)];
  }
  return codigo;
}

/** Guarda só o hash SHA-256 do código. */
function embaralhar(texto) {
  return crypto.createHash('sha256').update(String(texto)).digest('hex');
}

/** Comparação em tempo constante. */
function iguais(a, b) {
  const x = Buffer.from(String(a));
  const y = Buffer.from(String(b));
  return x.length === y.length && crypto.timingSafeEqual(x, y);
}

function normalizarEmail(valor) {
  return String(valor || '').trim().toLowerCase();
}

// Só o formato do e-mail.
const FORMATO_EMAIL = /^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i;

function daquiA(minutos) {
  return new Date(Date.now() + minutos * 60_000).toISOString();
}


/** Sorteia o código, grava o hash e envia o e-mail (também usada pelo painel do admin). */
async function criarEEnviarCodigo(email) {
  // Invalida os códigos anteriores do mesmo e-mail.
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

  if (gravou.error) throw new Error(gravou.error.message);

  await enviarCodigo(email, codigo);
  return true;
}


// ── 0. POST /conferir-email ── formato e domínio, antes do cadastro (não diz se a conta existe).
rotas.post('/conferir-email', async (req, res) => {
  const email = normalizarEmail(req.body?.email);

  if (!FORMATO_EMAIL.test(email)) {
    return res.json({ ok: false, motivo: 'Esse e-mail não parece completo.' });
  }

  try {
    res.json(await conferirEndereco(email));
  } catch (erro) {
    // Se a conferência quebrar, o cadastro segue.
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

  // O domínio recebe e-mail?
  const endereco = await conferirEndereco(email);
  if (!endereco.ok) {
    return res.status(400).json({ message: endereco.motivo });
  }

  // Limite de pedidos por hora (guardado no banco).
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

  // Sem conta, não gera código (a resposta é a mesma).
  const conta = await admin.rpc('conta_por_email', { p_email: email });

  if (conta.error) {
    return falhou(res, 500, 'Não foi possível enviar o código agora.',
                  conta.error, 'POST /auth/recuperar (conta_por_email)');
  }

  if (!conta.data) {
    console.log(`  · recuperação pedida para e-mail sem conta: ${email}`);
    return res.json({ message: RESPOSTA_NEUTRA });
  }

  // Apaga códigos com mais de um dia.
  const ontem = new Date(Date.now() - 86_400_000).toISOString();
  await admin.from('codigos_recuperacao').delete().lt('criado_em', ontem);

  try {
    await criarEEnviarCodigo(email);
  } catch (erro) {
    // Falha de envio não muda a resposta (não revela se a conta existe).
    console.error('  ✖ recuperação:', erro.message);
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

  // Mesma mensagem para código inexistente, vencido ou errado.
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

  // Acertou: gera o ticket exigido pela troca de senha.
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

  // Invalida o código depois da troca.
  await admin.from('codigos_recuperacao')
    .update({ usado_em: agora, ticket_hash: null }).eq('id', linha.id);

  console.log(`  · senha alterada por recuperação: ${email}`);

  res.json({ message: 'Senha alterada! Agora é só entrar com ela.' });
});


/* Exporta também criarEEnviarCodigo para o painel do admin. */
module.exports = rotas;
module.exports.criarEEnviarCodigo = criarEEnviarCodigo;
