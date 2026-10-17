/** Envio de e-mail por SMTP (código de recuperação). Sem configuração, mostra o código no terminal. */

require('dotenv').config();

const nodemailer = require('nodemailer');

const SERVIDOR = process.env.SMTP_HOST;
const PORTA    = Number(process.env.SMTP_PORT || 587);
const USUARIO  = process.env.SMTP_USER;
const SENHA    = process.env.SMTP_PASS;
const REMETENTE = process.env.SMTP_FROM || USUARIO;

const configurado = Boolean(SERVIDOR && USUARIO && SENHA);

// Conexão SMTP reaproveitada.
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


/** Corpo do e-mail com o código, em HTML e texto puro. */
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


/** Envia o código. true = enviado (a resposta ao usuário não muda). */
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


/* Validação de e-mail: formato e domínio (MX). Se a caixa existe, só o código chegando prova. */

const dns = require('dns').promises;

// Cache de domínios consultados (1 hora).
const UMA_HORA = 3_600_000;
const lembrados = new Map();   // domínio -> { recebe, quando }

const FORMATO = /^[^\s@]+@([^\s@.]+\.[^\s@]{2,})$/i;

// Tempo máximo de espera do DNS.
const PACIENCIA_MS = 3000;

// Só recusa quando o DNS diz que o domínio não existe; falha de consulta deixa passar.
const NAO_EXISTE = new Set(['ENOTFOUND', 'NXDOMAIN']);

function comPrazo(promessa) {
  return Promise.race([
    promessa,
    new Promise((_, rejeitar) =>
      setTimeout(() => rejeitar(Object.assign(new Error('dns lento'), { code: 'ETIMEOUT' })),
                 PACIENCIA_MS)),
  ]);
}

/** O domínio recebe e-mail? MX, depois existência; na dúvida, deixa passar. */
async function dominioRecebeEmail(dominio) {
  try {
    const mx = await comPrazo(dns.resolveMx(dominio));
    if (Array.isArray(mx) && mx.length) return true;
  } catch (erro) {
    if (NAO_EXISTE.has(erro.code)) return false;
    // ENODATA, ECONNREFUSED, ETIMEOUT, SERVFAIL: seguimos para o plano B.
  }

  // Plano B: resolvedor do sistema operacional.
  try {
    await comPrazo(dns.lookup(dominio));
    return true;
  } catch (erro) {
    if (NAO_EXISTE.has(erro.code)) return false;
  }

  console.warn(`  · não consegui conferir o domínio "${dominio}" no DNS; deixando passar.`);
  return true;
}

/** Confere formato e domínio. Devolve { ok, motivo }. */
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
