/**
 * server/email.js — o envio de e-mail do jogo
 *
 * Hoje serve a uma coisa só: mandar o código de recuperação de senha.
 *
 * Fala SMTP, não a API de um serviço específico. Isso é de propósito:
 * trocar o Gmail por Brevo, Mailgun ou o servidor da faculdade passa a
 * ser mexer no .env, sem tocar em código.
 *
 * SEM CONFIGURAÇÃO, O SERVIDOR NÃO QUEBRA. Ele escreve o código no
 * próprio terminal e avisa, bem alto, que ninguém recebeu e-mail nenhum.
 * É o que deixa a tela inteira testável antes de a conta de envio
 * existir — e é também por isso que o aviso é escandaloso: um código de
 * recuperação no log é uma chave de porta deixada embaixo do tapete.
 */

require('dotenv').config();

const nodemailer = require('nodemailer');

const SERVIDOR = process.env.SMTP_HOST;
const PORTA    = Number(process.env.SMTP_PORT || 587);
const USUARIO  = process.env.SMTP_USER;
const SENHA    = process.env.SMTP_PASS;
const REMETENTE = process.env.SMTP_FROM || USUARIO;

const configurado = Boolean(SERVIDOR && USUARIO && SENHA);

// A conexão é criada uma vez e reaproveitada. Abrir SMTP a cada e-mail
// custa um handshake TLS inteiro, e o Gmail reclama de quem faz isso.
const transporte = configurado
  ? nodemailer.createTransport({
      host: SERVIDOR,
      port: PORTA,
      secure: PORTA === 465,   // 465 é TLS direto; 587 começa limpo e sobe com STARTTLS
      auth: { user: USUARIO, pass: SENHA },
    })
  : null;

if (!configurado) {
  console.warn(
    '\n[aviso] Envio de e-mail desligado: faltam SMTP_HOST, SMTP_USER ou SMTP_PASS no .env.\n' +
    '        A recuperação de senha continua funcionando, mas o código vai\n' +
    '        aparecer AQUI no terminal em vez de chegar na caixa de entrada.\n' +
    '        Isso serve para desenvolver. Nunca suba assim.\n'
  );
}


/**
 * O corpo do e-mail com o código.
 *
 * Duas versões no mesmo envio: uma em HTML e uma em texto puro. Não é
 * capricho — cliente de e-mail de escola costuma bloquear HTML, e sem a
 * versão em texto o aluno abriria uma mensagem vazia.
 *
 * O código aparece em letras grandes e espaçadas porque vai ser copiado
 * à mão, olhando de uma tela para a outra.
 */
function corpoDoCodigo(codigo) {
  const texto =
    `Seu código para criar uma nova senha no Heróis da Saúde é:\n\n` +
    `    ${codigo}\n\n` +
    `Ele vale por 10 minutos.\n\n` +
    `Se não foi você que pediu, pode ignorar esta mensagem — ` +
    `sua senha continua a mesma.\n`;

  const html = `
<div style="font-family:Segoe UI,Arial,sans-serif;max-width:420px;margin:0 auto;padding:24px">
  <h1 style="font-size:18px;color:#1f7a68;margin:0 0 4px">Heróis da Saúde</h1>
  <p style="font-size:14px;color:#444;margin:0 0 20px">Recuperação de senha</p>

  <p style="font-size:14px;color:#222;margin:0 0 12px">
    Use o código abaixo para criar uma nova senha:
  </p>

  <p style="font-size:30px;font-weight:700;letter-spacing:9px;
            color:#1f7a68;background:#eefaf6;border-radius:12px;
            padding:16px;text-align:center;margin:0 0 16px">${codigo}</p>

  <p style="font-size:13px;color:#666;margin:0 0 4px">Ele vale por 10 minutos.</p>
  <p style="font-size:13px;color:#666;margin:0">
    Se não foi você que pediu, pode ignorar esta mensagem — sua senha continua a mesma.
  </p>
</div>`;

  return { texto, html };
}


/**
 * Manda o código. Devolve `true` quando saiu de verdade.
 *
 * Quem chama não deve mudar a resposta ao usuário por causa deste
 * retorno: a tela diz a mesma frase tendo o e-mail saído ou não. O
 * retorno serve para o log do servidor, e para o modo sem SMTP.
 */
async function enviarCodigo(email, codigo) {
  if (!configurado) {
    console.warn(
      `\n  ┌─ SMTP DESLIGADO — nenhum e-mail foi enviado ────────────\n` +
      `  │  para:   ${email}\n` +
      `  │  código: ${codigo}\n` +
      `  └─────────────────────────────────────────────────────────\n`
    );
    return false;
  }

  const { texto, html } = corpoDoCodigo(codigo);

  await transporte.sendMail({
    from: `"Heróis da Saúde" <${REMETENTE}>`,
    to: email,
    subject: `${codigo} é o seu código de recuperação`,
    text: texto,
    html,
  });

  return true;
}


/* =====================================================================
 *  O ENDEREÇO EXISTE?
 *
 *  Até onde dá para saber, e onde para.
 *
 *    1. FORMATO       — "joao@@escola" não é endereço. Barato e certeiro.
 *    2. O DOMÍNIO     — "gmai.com" existe e recebe e-mail? É o que esta
 *                       parte faz, perguntando ao DNS quem são os
 *                       servidores de e-mail daquele domínio (registro
 *                       MX). Pega quase todo erro de digitação real:
 *                       gmai.com, hotmal.com, @outloo.com.
 *    3. A CAIXA       — "joao.silva@gmail.com" existe mesmo?
 *                       NÃO DÁ PARA SABER, e é importante não fingir
 *                       que dá. Gmail e Outlook respondem "talvez" a
 *                       qualquer pergunta sobre caixa, de propósito,
 *                       justamente para ninguém sair varrendo endereços.
 *                       Quem insiste em perguntar vira IP bloqueado.
 *
 *  Quem prova o passo 3 é o código chegando. Por isso o jogo confere o
 *  que dá para conferir e deixa o e-mail fazer o resto.
 * ===================================================================== */

const dns = require('dns').promises;

// O DNS é rápido, mas não de graça, e a escola inteira usa dois ou três
// domínios. Guardar a resposta por uma hora evita repetir a pergunta a
// cada cadastro.
const UMA_HORA = 3_600_000;
const lembrados = new Map();   // domínio -> { recebe, quando }

const FORMATO = /^[^\s@]+@([^\s@.]+\.[^\s@]{2,})$/i;

// Quanto tempo esperar o DNS antes de desistir e deixar passar. Melhor
// um cadastro a mais do que um aluno preso na tela porque a rede da
// escola está lenta.
const PACIENCIA_MS = 3000;

// A diferença que decide tudo: "este domínio NÃO EXISTE" é resposta,
// e vale recusar. "não consegui perguntar" é problema nosso, e recusar
// por causa dele seria barrar gente de e-mail bom. Nesta máquina, por
// exemplo, consultar MX direto dá ECONNREFUSED — se isso reprovasse,
// ninguém se cadastraria.
const NAO_EXISTE = new Set(['ENOTFOUND', 'NXDOMAIN']);

function comPrazo(promessa) {
  return Promise.race([
    promessa,
    new Promise((_, rejeitar) =>
      setTimeout(() => rejeitar(Object.assign(new Error('dns lento'), { code: 'ETIMEOUT' })),
                 PACIENCIA_MS)),
  ]);
}

/**
 * O domínio recebe e-mail?
 *
 * Três perguntas, em ordem de força:
 *   1. tem servidor de e-mail (registro MX)?  -> recebe
 *   2. o domínio ao menos existe?             -> provavelmente recebe
 *   3. o DNS disse que não existe?            -> não recebe
 *
 * Qualquer outra falha é tratada como "não sei", e "não sei" deixa passar.
 */
async function dominioRecebeEmail(dominio) {
  try {
    const mx = await comPrazo(dns.resolveMx(dominio));
    if (Array.isArray(mx) && mx.length) return true;
  } catch (erro) {
    if (NAO_EXISTE.has(erro.code)) return false;
    // ENODATA, ECONNREFUSED, ETIMEOUT, SERVFAIL: seguimos para o plano B.
  }

  // Plano B: `lookup` usa o resolvedor do sistema operacional, que
  // costuma funcionar mesmo onde a consulta direta por MX é barrada.
  // Domínio sem MX mas com site também recebe e-mail, de vez em quando.
  try {
    await comPrazo(dns.lookup(dominio));
    return true;
  } catch (erro) {
    if (NAO_EXISTE.has(erro.code)) return false;
  }

  console.warn(`  · não consegui conferir o domínio "${dominio}" no DNS; deixando passar.`);
  return true;
}

/**
 * Confere o endereço até onde é possível.
 *
 * Devolve { ok, motivo }, onde `motivo` é a frase que a tela mostra.
 * Nunca diz se a CAIXA existe — isso ninguém sabe de fora.
 */
async function conferirEndereco(email) {
  const limpo = String(email || '').trim().toLowerCase();
  const m = FORMATO.exec(limpo);

  if (!m) {
    return { ok: false, motivo: 'Esse e-mail não parece completo. Confira se tem @ e o final, como .com.' };
  }

  const dominio = m[1];
  const guardado = lembrados.get(dominio);
  const recebe = (guardado && Date.now() - guardado.quando < UMA_HORA)
    ? guardado.recebe
    : await dominioRecebeEmail(dominio);

  lembrados.set(dominio, { recebe, quando: Date.now() });

  return recebe
    ? { ok: true }
    : { ok: false, motivo: `Não encontramos o site "${dominio}". Confira se escreveu certo.` };
}


module.exports = { enviarCodigo, configurado, conferirEndereco };
