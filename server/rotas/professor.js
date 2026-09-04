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

const QTD_MIN = 3;
const QTD_MAX = 30;
function nivelDoAnoEscolar(ano) {
  if (!ano) return null;
  if (ano.includes('EM')) return 3;             // 1º a 3º do Médio

  const numero = parseInt(ano, 10);             // '6º ano' -> 6
  if (!Number.isInteger(numero)) return null;
  if (numero >= 6 && numero <= 9) return 2;     // Fundamental II
  if (numero >= 1 && numero <= 5) return 1;     // Fundamental I
  return null;
}

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

rotas.post('/quizzes', async (req, res) => {
  const turmaId = Number(req.body?.turma_id);
  const titulo = String(req.body?.titulo || '').trim();

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }
  if (titulo.length < 2) {
    return res.status(400).json({ message: 'Dê um título ao quiz. Ex: Revisão de Dengue' });
  }
  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const cenarios = Array.isArray(req.body?.cenarios) ? req.body.cenarios : [];
  if (cenarios.length === 0) {
    return res.status(400).json({ message: 'Escolha pelo menos um cenário de onde tirar as perguntas.' });
  }

  const areas = Array.isArray(req.body?.areas) ? req.body.areas : [];

  let qtd = Number(req.body?.qtd_questoes);
  if (!Number.isInteger(qtd)) qtd = 10;
  qtd = Math.min(QTD_MAX, Math.max(QTD_MIN, qtd));

  let tempo = Number(req.body?.tempo_limite_segundos);
  if (!Number.isInteger(tempo) || tempo <= 0) tempo = 20;


  const turma = await admin
    .from('turmas').select('ano_escolar').eq('id', turmaId).maybeSingle();

  const nivel = nivelDoAnoEscolar(turma.data?.ano_escolar);
  if (!nivel) {
    return res.status(400).json({
      message: 'Defina o ano escolar da turma antes de criar o quiz.'
    });
  }

  const missoes = await admin
    .from('missoes')
    .select('id, cenarios!inner(slug)')
    .eq('nivel_etario', nivel)
    .in('cenarios.slug', cenarios);

  if (missoes.error) {
    return res.status(500).json({ message: 'Não foi possível procurar as perguntas.' });
  }

  let idsMissoes = (missoes.data || []).map(m => m.id);

  if (areas.length > 0 && idsMissoes.length > 0) {
    const comArea = await admin
      .from('missao_areas').select('missao_id')
      .in('missao_id', idsMissoes).in('area_nome', areas);

    const permitidas = new Set((comArea.data || []).map(r => r.missao_id));
    idsMissoes = idsMissoes.filter(id => permitidas.has(id));
  }

  if (idsMissoes.length === 0) {
    return res.status(400).json({
      message: 'Não há perguntas para essa combinação de cenário, área e ano da turma.'
    });
  }

  const questoes = await admin
    .from('questoes').select('id').in('missao_id', idsMissoes);

  if (questoes.error) {
    return res.status(500).json({ message: 'Não foi possível procurar as perguntas.' });
  }

  const bolo = (questoes.data || []).map(q => q.id);
  for (let i = bolo.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [bolo[i], bolo[j]] = [bolo[j], bolo[i]];
  }
  const sorteadas = bolo.slice(0, qtd);

  if (sorteadas.length === 0) {
    return res.status(400).json({ message: 'Não há perguntas para essa combinação.' });
  }
  const criado = await admin
    .from('quizzes_professores')
    .insert({
      turma_id: turmaId,
      professor_id: req.usuario.id,
      titulo,
      tempo_limite_segundos: tempo,
      nivel_etario: nivel,
      cenarios,
      areas,
      qtd_pedida: qtd
    })
    .select('id, turma_id, titulo, tempo_limite_segundos, nivel_etario, cenarios, areas, qtd_pedida, created_at')
    .single();

  if (criado.error) {
    return res.status(500).json({ message: 'Não foi possível criar o quiz.' });
  }
  const vinculo = await admin.from('quiz_questoes').insert(
    sorteadas.map((questaoId, i) => ({
      quiz_id: criado.data.id, questao_id: questaoId, ordem: i + 1
    }))
  );

  if (vinculo.error) {
    await admin.from('quizzes_professores').delete().eq('id', criado.data.id);
    return res.status(500).json({ message: 'Não foi possível sortear as perguntas do quiz.' });
  }

  res.status(201).json({ ...criado.data, total_questoes: sorteadas.length });
});


rotas.get('/quizzes', async (req, res) => {
  const turmaId = Number(req.query.turma_id);

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }
  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const { data, error } = await admin
    .from('quizzes_professores')
    .select('id, titulo, tempo_limite_segundos, nivel_etario, cenarios, areas, qtd_pedida, created_at')
    .eq('turma_id', turmaId)
    .order('created_at', { ascending: false });

  if (error) return res.status(500).json({ message: 'Não foi possível carregar os quizzes.' });

  const ids = data.map(q => q.id);
  const contagem = new Map(ids.map(id => [id, 0]));

  if (ids.length > 0) {
    const vinculos = await admin.from('quiz_questoes').select('quiz_id').in('quiz_id', ids);
    for (const v of vinculos.data || []) {
      contagem.set(v.quiz_id, (contagem.get(v.quiz_id) || 0) + 1);
    }
  }

  res.json(data.map(q => ({ ...q, total_questoes: contagem.get(q.id) || 0 })));
});


rotas.delete('/quizzes/:id', async (req, res) => {
  const quizId = Number(req.params.id);

  if (!Number.isInteger(quizId)) {
    return res.status(400).json({ message: 'Quiz inválido.' });
  }

  const dono = await admin
    .from('quizzes_professores').select('id')
    .eq('id', quizId).eq('professor_id', req.usuario.id).maybeSingle();

  if (!dono.data && req.usuario.tipo !== 'ADMIN') {
    return res.status(403).json({ message: 'Esse quiz não é seu.' });
  }

  const { error } = await admin.from('quizzes_professores').delete().eq('id', quizId);
  if (error) return res.status(500).json({ message: 'Não foi possível desfazer o quiz.' });

  res.status(204).end();
});

module.exports = rotas;
