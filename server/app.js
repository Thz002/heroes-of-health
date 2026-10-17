/** O app Express do jogo: API (game logic, com a chave secreta) e o front-end de src/.
    Exportado sem listen: server/index.js o liga localmente; no Vercel, api/index.js. */

const express = require('express');
const path    = require('path');

const { admin } = require('./supabase');
const rotasJogo       = require('./rotas/jogo');
const rotasProfessor  = require('./rotas/professor');
const rotasRecuperacao = require('./rotas/recuperacao');
const rotasAdmin       = require('./rotas/admin');

const app   = express();
const PORTA = process.env.PORT || 3000;

app.use(express.json({ limit: '100kb' }));

// CORS: só é usado no fallback por file:// (Origin: null).
const ORIGENS_PERMITIDAS = new Set([
  `http://localhost:${PORTA}`,
  `http://127.0.0.1:${PORTA}`,
  'null', // páginas abertas via file://, modo antigo/fallback
]);

app.use((req, res, next) => {
  const origem = req.headers.origin;
  if (origem && ORIGENS_PERMITIDAS.has(origem)) {
    res.header('Access-Control-Allow-Origin', origem);
  }
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');

  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});

// ── Servir o front-end (só localmente; no Vercel quem serve src/ é a CDN) ──
// A lib do Supabase é servida à parte, só o pacote UMD (e não o
// node_modules inteiro, que não deve ficar público).
app.use(express.static(path.join(__dirname, '..', 'src')));
app.use('/vendor', express.static(
  path.join(__dirname, '..', 'node_modules', '@supabase', 'supabase-js', 'dist', 'umd')
));

app.get('/', (_req, res) => res.redirect('/pages/index.html'));

// ── Rotas ────────────────────────────────────────────────────────────
app.get('/api/saude', (_req, res) => {
  res.json({ ok: true, servico: 'herois-da-saude', hora: new Date().toISOString() });
});

// Chamada diária do Cron do Vercel: uma consulta leve mantém o Supabase
// grátis ativo. Só responde com o CRON_SECRET (o Vercel o manda sozinho).
app.get('/api/manter-vivo', async (req, res) => {
  const segredo = process.env.CRON_SECRET;
  if (!segredo || req.headers.authorization !== `Bearer ${segredo}`) {
    return res.status(401).json({ message: 'Não autorizado.' });
  }

  const r = await admin.from('areas').select('nome').limit(1);
  if (r.error) {
    console.error('[manter-vivo]', r.error.message);
    return res.status(500).json({ ok: false });
  }
  res.json({ ok: true, hora: new Date().toISOString() });
});

// Esqueci minha senha: única parte da API aberta a quem não está logado.
app.use('/api/auth', rotasRecuperacao);

app.use('/api', rotasJogo);
app.use('/api/professor', rotasProfessor);

// Painel do admin (a rota inteira exige tipo ADMIN).
app.use('/api/admin', rotasAdmin);

app.use((req, res) => {
  res.status(404).json({ message: `Rota não encontrada: ${req.method} ${req.path}` });
});

// Erros das rotas async: detalhe no log, mensagem genérica para o navegador.
app.use((erro, _req, res, _next) => {
  console.error('[erro]', erro);
  res.status(500).json({ message: 'Algo deu errado no servidor.' });
});

module.exports = app;
