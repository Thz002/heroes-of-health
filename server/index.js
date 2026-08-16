/**
 * server/index.js — Heróis da Saúde, o servidor
 *
 * O modelo é HÍBRIDO, e vale entender a divisão antes de mexer aqui:
 *
 *   - O LOGIN não passa por este servidor. O navegador fala direto com
 *     o Supabase Auth, como sempre fez, e recebe um token.
 *
 *   - O JOGO passa. Corrigir resposta, pontuar, montar o painel do
 *     professor — tudo isso acontece aqui, porque são decisões que não
 *     podem ficar na mão de quem joga.
 *
 * O RLS do banco continua ligado e continua sendo necessário: enquanto o
 * navegador falar com o Supabase para qualquer coisa, a chave publishable
 * continua utilizável direto. Servidor não substitui RLS; somam-se.
 *
 * Este mesmo processo também serve o front-end (pasta src/), então abrir
 * http://localhost:3000 já leva direto para a tela de login — não é mais
 * necessário abrir o HTML por file://. Ver "Servir o front-end" abaixo.
 */

const express = require('express');
const path    = require('path');

const rotasJogo      = require('./rotas/jogo');
const rotasProfessor = require('./rotas/professor');

const app   = express();
const PORTA = process.env.PORT || 3000;

app.use(express.json({ limit: '100kb' }));

// ── CORS ─────────────────────────────────────────────────────────────
// Agora que o próprio Express serve o front-end, a página e a API vivem
// na mesma origem — a maioria das chamadas nem passa por CORS. Esta
// lista existe só para quem ainda abre o HTML direto por file://
// (Origin: null) durante o desenvolvimento.
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

// ── Servir o front-end ──────────────────────────────────────────────
// src/pages/index.html -> http://localhost:3000/pages/index.html
// src/js/api.js         -> http://localhost:3000/js/api.js
// src/css/style.css     -> http://localhost:3000/css/style.css
//
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

app.use('/api', rotasJogo);
app.use('/api/professor', rotasProfessor);

app.use((req, res) => {
  res.status(404).json({ message: `Rota não encontrada: ${req.method} ${req.path}` });
});

// O Express 5 entrega erros de rota async para cá automaticamente.
// A mensagem de verdade fica no log do servidor; o navegador recebe só
// o aviso genérico, para não vazar detalhe interno do banco.
app.use((erro, _req, res, _next) => {
  console.error('[erro]', erro);
  res.status(500).json({ message: 'Algo deu errado no servidor.' });
});

app.listen(PORTA, () => {
  console.log(`\n  Heróis da Saúde — servidor no ar`);
  console.log(`  http://localhost:${PORTA}\n`);
});
