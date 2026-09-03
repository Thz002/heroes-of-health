/**
 * server/rotas/professor.js — o painel do professor
 *
 * Estas rotas existem porque o RLS sozinho não dava conta: o professor
 * precisa ler linhas que não são dele (o progresso dos alunos), e cada
 * exceção dessas no banco é uma policy a mais para revisar. Do lado de
 * cá a regra fica em um lugar só: "é aluno de uma turma minha?".
 */

const express = require('express');
const { admin } = require('../supabase');
const { autenticar, exigirTipo } = require('../middleware/autenticar');

const rotas = express.Router();
rotas.use(autenticar, exigirTipo('PROFESSOR', 'ADMIN'));

/** Confere se a turma pertence a quem está pedindo. ADMIN passa direto. */
async function turmaEhMinha(usuario, turmaId) {
  if (usuario.tipo === 'ADMIN') return true;

  const { data } = await admin
    .from('turmas')
    .select('id')
    .eq('id', turmaId)
    .eq('professor_id', usuario.id)
    .maybeSingle();

  return Boolean(data);
}

// Mesma lista de cores do seletor em dashboard.html, e o check espelhado
// no banco (db/setup.sql). Quem manda a cor é o navegador, então ela
// precisa ser conferida contra uma lista fechada antes de gravar.
const CORES_VALIDAS = ['#14b8a6', '#3b82f6', '#f9c74f', '#f472b6', '#a78bfa', '#fb923c'];

// O jogo atende dos 7 aos 18 anos, então a lista vai do Fundamental ao
// 3º do Médio. Os rótulos do Médio levam "EM" para não se confundirem
// com o 1º/2º/3º do Fundamental, e são curtos de propósito: a coluna
// turmas.ano_escolar é varchar(10) (db/setup.sql).
const ANOS_VALIDOS = [
  '1º ano', '2º ano', '3º ano', '4º ano', '5º ano',
  '6º ano', '7º ano', '8º ano', '9º ano',
  '1º ano EM', '2º ano EM', '3º ano EM'
];

// Quantos alunos cabem numa turma, para o "x/10" do card. Fixo por
// enquanto — se um dia precisar variar por turma, vira coluna no banco.
const LIMITE_ALUNOS_POR_TURMA = 10;

// ── As turmas do professor, com o código para entregar à sala ────────
rotas.get('/turmas', async (req, res) => {
  const { data, error } = await admin
    .from('turmas')
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .eq('professor_id', req.usuario.id)
    .order('nome');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar suas turmas.' });

  const ids = data.map(t => t.id);
  const contagem = new Map(ids.map(id => [id, 0]));

  if (ids.length > 0) {
    const alunos = await admin
      .from('usuarios')
      .select('turma_id')
      .in('turma_id', ids)
      .eq('tipo', 'ALUNO');

    for (const a of alunos.data || []) {
      contagem.set(a.turma_id, (contagem.get(a.turma_id) || 0) + 1);
    }
  }

  res.json(data.map(t => ({
    ...t,
    total_alunos: contagem.get(t.id) || 0,
    limite_alunos: LIMITE_ALUNOS_POR_TURMA
  })));
});

// ── Criar turma ──────────────────────────────────────────────────────
rotas.post('/turmas', async (req, res) => {
  const nome = String(req.body?.nome || '').trim();

  if (nome.length < 2) {
    return res.status(400).json({ message: 'Dê um nome à turma. Ex: 7º Ano B' });
  }
  if (!req.usuario.escola_id) {
    return res.status(400).json({ message: 'Seu cadastro não tem escola. Avise o administrador.' });
  }

  // Cor e ano vêm do navegador, então são conferidos contra uma lista
  // fechada antes de gravar — o mesmo dado inválido também cairia no
  // check do banco, mas é melhor barrar aqui com uma mensagem clara.
  const cor = CORES_VALIDAS.includes(req.body?.cor) ? req.body.cor : CORES_VALIDAS[0];
  const ano_escolar = ANOS_VALIDOS.includes(req.body?.ano_escolar) ? req.body.ano_escolar : null;

  // O código é gerado aqui, e não no navegador: ele é a credencial que
  // deixa um aluno entrar na turma, então quem o inventa tem que ser o
  // lado confiável.
  const codigo = gerarCodigo(nome);

  const { data, error } = await admin
    .from('turmas')
    .insert({
      nome,
      escola_id: req.usuario.escola_id,
      professor_id: req.usuario.id,
      codigo,
      cor,
      ano_escolar
    })
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .single();

  if (error) {
    if (error.message.includes('duplicate') || error.code === '23505') {
      return res.status(409).json({ message: 'Você já tem uma turma com esse nome nesta escola.' });
    }
    return res.status(500).json({ message: 'Não foi possível criar a turma.' });
  }

  res.status(201).json({ ...data, total_alunos: 0, limite_alunos: LIMITE_ALUNOS_POR_TURMA });
});

/** Monta um código curto tipo '7B-K3M9'. Sem letras que confundem (O/0, I/1). */
function gerarCodigo(nomeTurma) {
  const LETRAS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  const prefixo = nomeTurma
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, '')
    .slice(0, 3) || 'T';

  let sufixo = '';
  for (let i = 0; i < 4; i++) {
    sufixo += LETRAS[Math.floor(Math.random() * LETRAS.length)];
  }

  return `${prefixo}-${sufixo}`;
}

// ── Editar nome, cor e ano da turma ──────────────────────────────────
// Só esses três campos. O código, a escola e o dono da turma ficam de
// fora de propósito: o código é credencial de entrada e trocá-lo
// deixaria a sala inteira sem conseguir entrar.
rotas.patch('/turmas/:id', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const mudancas = {};

  if (req.body?.nome !== undefined) {
    const nome = String(req.body.nome).trim();
    if (nome.length < 2) {
      return res.status(400).json({ message: 'Dê um nome à turma. Ex: 7º Ano B' });
    }
    mudancas.nome = nome;
  }

  // Ao contrário do POST, aqui um valor fora da lista é recusado em vez
  // de virar o padrão: numa edição, gravar calado uma cor diferente da
  // pedida esconderia o erro de quem chamou.
  if (req.body?.cor !== undefined) {
    if (!CORES_VALIDAS.includes(req.body.cor)) {
      return res.status(400).json({ message: 'Essa cor não está na lista.' });
    }
    mudancas.cor = req.body.cor;
  }

  if (req.body?.ano_escolar !== undefined) {
    const ano = req.body.ano_escolar;
    if (ano !== null && !ANOS_VALIDOS.includes(ano)) {
      return res.status(400).json({ message: 'Esse ano escolar não está na lista.' });
    }
    mudancas.ano_escolar = ano;
  }

  if (Object.keys(mudancas).length === 0) {
    return res.status(400).json({ message: 'Nada para alterar.' });
  }

  const { data, error } = await admin
    .from('turmas')
    .update(mudancas)
    .eq('id', turmaId)
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .single();

  if (error) {
    if (error.message.includes('duplicate') || error.code === '23505') {
      return res.status(409).json({ message: 'Você já tem uma turma com esse nome nesta escola.' });
    }
    return res.status(500).json({ message: 'Não foi possível salvar as mudanças.' });
  }

  // O card mostra "x/10", então a resposta precisa devolver a contagem
  // junto — do contrário a tela teria que buscar a lista inteira de novo.
  const { count } = await admin
    .from('usuarios')
    .select('id', { count: 'exact', head: true })
    .eq('turma_id', turmaId)
    .eq('tipo', 'ALUNO');

  res.json({ ...data, total_alunos: count || 0, limite_alunos: LIMITE_ALUNOS_POR_TURMA });
});

rotas.delete('/turmas/:id', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const { error } = await admin.from('turmas').delete().eq('id', turmaId);

  if (error) {
    return res.status(500).json({ message: 'Não foi possível desfazer a turma.' });
  }

  res.status(204).end();
});

// ── Os alunos de uma turma, com o desempenho de cada um ──────────────
rotas.get('/turmas/:id/alunos', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const alunos = await admin
    .from('usuarios')
    .select('id, nome, idade')
    .eq('turma_id', turmaId)
    .eq('tipo', 'ALUNO')
    .order('nome');

  if (alunos.error) {
    return res.status(500).json({ message: 'Não foi possível carregar a turma.' });
  }

  const ids = alunos.data.map(a => a.id);
  if (ids.length === 0) return res.json([]);

  const respostas = await admin
    .from('respostas_alunos')
    .select('usuario_id, acertou')
    .in('usuario_id', ids);

  const resumo = new Map(ids.map(id => [id, { total: 0, acertos: 0 }]));
  for (const r of respostas.data || []) {
    const item = resumo.get(r.usuario_id);
    item.total += 1;
    if (r.acertou) item.acertos += 1;
  }

  res.json(alunos.data.map(a => {
    const { total, acertos } = resumo.get(a.id);
    return {
      id: a.id,
      nome: a.nome,
      idade: a.idade,
      respostas: total,
      acertos,
      // Sem respostas ainda, aproveitamento é null e não zero — zero
      // pareceria "foi mal", quando na verdade é "ainda não começou".
      aproveitamento: total ? Math.round((acertos / total) * 100) : null
    };
  }));
});

module.exports = rotas;
