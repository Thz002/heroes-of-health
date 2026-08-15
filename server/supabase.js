/**
 * server/supabase.js — a conexão privilegiada com o banco
 *
 * Este arquivo é o ÚNICO lugar do projeto onde a chave secreta pode
 * aparecer. Ela lê o banco inteiro e passa por cima do RLS — é isso que
 * permite ao servidor enxergar `questoes.resposta_correta`, que o
 * navegador nunca pode ver.
 *
 * Se este arquivo (ou o .env) vazar, o banco inteiro vaza junto.
 */

require('dotenv').config();

const { createClient } = require('@supabase/supabase-js');

const URL     = process.env.SUPABASE_URL;
const SEGREDO = process.env.SUPABASE_SERVICE_KEY;

if (!URL || !SEGREDO) {
  console.error(
    '\n[erro] Faltam variáveis no .env.\n' +
    '       O servidor precisa de SUPABASE_URL e SUPABASE_SERVICE_KEY.\n' +
    '       Copie o .env.example e preencha com os valores do painel:\n' +
    '       Project Settings -> API Keys -> service_role (sb_secret_...)\n'
  );
  process.exit(1);
}

if (!SEGREDO.startsWith('sb_secret_') && !SEGREDO.startsWith('eyJ')) {
  console.error(
    '\n[erro] SUPABASE_SERVICE_KEY não parece a chave secreta.\n' +
    '       A chave publishable (sb_publishable_...) não serve aqui: ela\n' +
    '       obedece ao RLS e não enxerga a resposta correta das questões.\n'
  );
  process.exit(1);
}

/**
 * Cliente administrativo. Ignora o RLS por completo.
 *
 * `persistSession: false` porque o servidor não é uma pessoa: ele não
 * tem uma sessão só dele, atende muita gente ao mesmo tempo.
 */
const admin = createClient(URL, SEGREDO, {
  auth: { persistSession: false, autoRefreshToken: false }
});

module.exports = { admin };
