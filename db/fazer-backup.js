/**
 * db/fazer-backup.js — copia o banco inteiro para uma pasta local
 *
 *   npm run backup
 *
 * O plano gratuito do Supabase não guarda backup nenhum. Este script é o
 * backup: lê todas as tabelas do schema public com a chave secreta (a
 * mesma do servidor, vinda do .env) e grava, em backups/<data-hora>/:
 *
 *   <tabela>.json     os dados crus, uma lista de linhas por tabela
 *   auth_usuarios.json as contas de login (e-mail, datas, metadados)
 *   restaurar.sql     os mesmos dados como INSERTs, para colar no
 *                     SQL Editor e devolver tudo ao banco
 *
 * ⚠️ A pasta backups/ tem nome, idade e e-mail de alunos. Ela está no
 * .gitignore e NUNCA deve ir para o GitHub nem ser mandada por aí.
 *
 * O que ele NÃO salva:
 *   - senhas: o Supabase não entrega o hash nem para a chave secreta.
 *     Se o projeto inteiro for perdido, cada pessoa cria a conta de novo;
 *     o auth_usuarios.json diz quem eram e com que id.
 *   - a ESTRUTURA (tabelas, policies, funções): essa já está no git,
 *     em db/setup.sql. O restaurar.sql só devolve dados, e espera o
 *     banco com a mesma estrutura de quando o backup foi feito.
 *
 * Só lê. Não altera nada no banco.
 */

const fs = require('fs');
const path = require('path');
const { admin } = require('../server/supabase');

// Na ordem em que o restaurar.sql precisa inserir: quem é referenciado
// vem antes de quem referencia. Tabelas que não existirem neste banco
// são puladas — assim o mesmo script serve antes e depois da migração
// que troca missoes/missao_areas por questoes_areas.
//
// `ordem` é a coluna usada para paginar: sem ordem fixa, a página 2
// poderia repetir ou pular linhas da página 1. Tabela de chave composta
// passa a lista inteira das colunas da chave.
const TABELAS = [
  { nome: 'escolas',             ordem: 'id' },
  { nome: 'turmas',              ordem: 'id' },
  { nome: 'usuarios',            ordem: 'id' },
  { nome: 'cenarios',            ordem: 'id' },
  { nome: 'missoes',             ordem: 'id' },
  { nome: 'questoes',            ordem: 'id' },
  { nome: 'areas',               ordem: 'nome' },
  { nome: 'missao_areas',        ordem: 'missao_id' },
  { nome: 'questoes_areas',      ordem: 'questao_id' },
  { nome: 'progresso_areas',     ordem: 'id' },
  { nome: 'pacientes_virtuais',  ordem: 'id' },
  { nome: 'quizzes_professores', ordem: 'id' },
  { nome: 'quiz_questoes',       ordem: 'quiz_id' },
  { nome: 'respostas_alunos',    ordem: 'id' },
  // A progressão (XP diário e insígnias). Ficaram de fora da lista quando
  // as tabelas nasceram — e insignias_usuarios é justamente o dado que o
  // jogo promete nunca recalcular, ou seja, o que não dá para refazer.
  { nome: 'xp_diario',           ordem: ['usuario_id', 'dia'] },
  { nome: 'insignias',           ordem: 'codigo' },
  { nome: 'insignias_usuarios',  ordem: ['usuario_id', 'insignia_codigo'] },
];

const POR_PAGINA = 1000;   // o máximo que o PostgREST devolve por vez
const POR_INSERT = 200;    // linhas por INSERT no restaurar.sql

async function lerTabela(nome, ordem) {
  const linhas = [];

  for (let de = 0; ; de += POR_PAGINA) {
    let consulta = admin.from(nome).select('*');
    for (const coluna of [].concat(ordem)) consulta = consulta.order(coluna);

    const { data, error } = await consulta.range(de, de + POR_PAGINA - 1);

    if (error) {
      // Tabela que não existe neste banco: pula, não é erro.
      if (error.code === '42P01' || error.code === 'PGRST205') return null;
      throw new Error(`${nome}: ${error.message}`);
    }

    linhas.push(...data);
    if (data.length < POR_PAGINA) return linhas;
  }
}

async function lerContas() {
  const contas = [];

  for (let pagina = 1; ; pagina++) {
    const { data, error } = await admin.auth.admin.listUsers({ page: pagina, perPage: 1000 });
    if (error) throw new Error(`auth.users: ${error.message}`);

    contas.push(...data.users.map(u => ({
      id: u.id,
      email: u.email,
      created_at: u.created_at,
      last_sign_in_at: u.last_sign_in_at,
      user_metadata: u.user_metadata,
    })));

    if (data.users.length < 1000) return contas;
  }
}

// ── Valor JS -> literal SQL ──────────────────────────────────────────
// Texto, data e array saem entre aspas simples sem tipo: o Postgres
// converte sozinho para o tipo da coluna (timestamptz, text[], ...).
function aspas(texto) {
  return "'" + String(texto).replace(/'/g, "''") + "'";
}

function literal(valor) {
  if (valor === null || valor === undefined) return 'null';
  if (typeof valor === 'boolean') return valor ? 'true' : 'false';
  if (typeof valor === 'number') return String(valor);
  if (Array.isArray(valor)) {
    // Formato de array do Postgres: {"a","b"}. Aspas e barras de dentro
    // são escapadas com barra invertida — é a regra do literal de array,
    // diferente da do texto comum.
    const itens = valor.map(v => v === null
      ? 'NULL'
      : '"' + String(v).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"');
    return aspas('{' + itens.join(',') + '}');
  }
  if (typeof valor === 'object') return aspas(JSON.stringify(valor));
  return aspas(valor);
}

function inserts(nome, linhas, ajustar = l => l) {
  if (!linhas.length) return [`-- ${nome}: vazia`];

  const colunas = Object.keys(linhas[0]);
  // Colunas "generated always as identity" recusam id explícito sem isto.
  const comIdentidade = colunas.includes('id') && typeof linhas[0].id === 'number';
  const saida = [`-- ${nome}: ${linhas.length} linha(s)`];

  for (let i = 0; i < linhas.length; i += POR_INSERT) {
    const bloco = linhas.slice(i, i + POR_INSERT).map(ajustar);
    saida.push(
      `insert into public.${nome} (${colunas.join(', ')})` +
      (comIdentidade ? ' overriding system value' : '') + ' values\n' +
      bloco.map(l => '  (' + colunas.map(c => literal(l[c])).join(', ') + ')').join(',\n') +
      '\non conflict do nothing;'
    );
  }

  // O contador do id continua de onde o backup parou — sem isto, o
  // próximo cadastro tentaria o id 1 e bateria num que já existe.
  if (comIdentidade) {
    saida.push(
      `select setval(pg_get_serial_sequence('public.${nome}', 'id'), ` +
      `(select coalesce(max(id), 1) from public.${nome}));`
    );
  }

  return saida;
}

function montarSql(dados, quando) {
  const L = [
    '-- =====================================================================',
    `--  Backup do banco Heróis da Saúde — ${quando}`,
    '--',
    '--  Devolve os DADOS. A estrutura tem de existir antes, igual à do',
    '--  momento do backup: rode o db/setup.sql daquela época (git log).',
    '--',
    '--  As contas de login (auth.users) NÃO voltam por aqui. usuarios',
    '--  referencia auth.users, então a linha de quem não tem conta no',
    '--  banco é recusada. Veja auth_usuarios.json, ao lado deste arquivo.',
    '--',
    '--  "on conflict do nothing": o que já existe fica como está.',
    '-- =====================================================================',
    '',
    'begin;',
    '',
  ];

  for (const { nome } of TABELAS) {
    const linhas = dados[nome];
    if (!linhas) continue;

    if (nome === 'turmas') {
      // turmas e usuarios apontam uma para a outra (turmas.professor_id
      // e usuarios.turma_id). A turma entra sem o professor, e ele é
      // devolvido depois que os usuarios existirem.
      L.push(...inserts(nome, linhas, l => ({ ...l, professor_id: null })), '');
      continue;
    }

    L.push(...inserts(nome, linhas), '');

    if (nome === 'usuarios' && dados.turmas) {
      const comProfessor = dados.turmas.filter(t => t.professor_id);
      if (comProfessor.length) {
        L.push('-- turmas: devolvendo o professor de cada uma');
        for (const t of comProfessor) {
          L.push(`update public.turmas set professor_id = ${literal(t.professor_id)} where id = ${t.id};`);
        }
        L.push('');
      }
    }
  }

  L.push('commit;', '');
  return L.join('\n');
}

async function main() {
  const agora = new Date();
  const quando = agora.toISOString().replace('T', ' ').slice(0, 19) + ' UTC';
  const pasta = path.join(__dirname, '..', 'backups',
    agora.toISOString().slice(0, 19).replace(/[:T]/g, '-'));

  fs.mkdirSync(pasta, { recursive: true });

  const dados = {};
  for (const { nome, ordem } of TABELAS) {
    const linhas = await lerTabela(nome, ordem);
    if (linhas === null) {
      console.log(`  ${nome.padEnd(20)} (não existe neste banco — pulada)`);
      continue;
    }
    dados[nome] = linhas;
    fs.writeFileSync(path.join(pasta, `${nome}.json`), JSON.stringify(linhas, null, 2));
    console.log(`  ${nome.padEnd(20)} ${linhas.length} linha(s)`);
  }

  const contas = await lerContas();
  fs.writeFileSync(path.join(pasta, 'auth_usuarios.json'), JSON.stringify(contas, null, 2));
  console.log(`  ${'auth.users'.padEnd(20)} ${contas.length} conta(s)`);

  fs.writeFileSync(path.join(pasta, 'restaurar.sql'), montarSql(dados, quando));

  console.log(`\nBackup salvo em ${path.relative(process.cwd(), pasta)}`);
}

main().catch(err => {
  console.error('\n[erro] O backup não terminou:', err.message);
  process.exit(1);
});
