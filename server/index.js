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
 */

const express = require('express');

const rotasJogo      = require('./rotas/jogo');
const rotasProfessor = require('./rotas/professor');

const app   = express();
const PORTA = process.env.PORT || 3000;

app.use(express.json({ limit: '100kb' }));

// ── CORS ─────────────────────────────────────────────────────────────
// As páginas abrem por file://, e nesse caso o navegador manda
// `Origin: null`. Por isso a liberação aqui é ampla.
//
// ⚠️ ANTES DE PUBLICAR: trocar por uma lista fechada de endereços.
// Do jeito que está, qualquer site conseguiria chamar estas rotas com o
// token de um aluno logado.
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', req.headers.origin || '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');

  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});

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
  console.log(`  http://localhost:${PORTA}/api/saude\n`);
});
