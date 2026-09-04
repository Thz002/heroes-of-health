/**
 * server/rotas/jogo.js — as rotas que o aluno usa jogando
 *
 * O motivo deste arquivo existir: enquanto a correção da resposta
 * acontecia no navegador, ela não valia nada. O aluno lia
 * `resposta_correta` pelo console e escrevia a própria pontuação com um
 * update. Aqui a regra do jogo fica do lado de cá, fora do alcance dele.
 */

const express = require('express');
const { admin } = require('../supabase');
const { autenticar } = require('../middleware/autenticar');

const rotas = express.Router();
rotas.use(autenticar);

const QUESTOES_POR_RODADA = 10;

function nivelDaIdade(idade) {
  if (!idade) return null;
  if (idade <= 10) return 1;
  if (idade <= 14) return 2;
  return 3;
}

// ── Cenários do mapa ─────────────────────────────────────────────────
rotas.get('/cenarios', async (req, res) => {
  const { data, error } = await admin
    .from('cenarios')
    .select('id, slug, nome, descricao')
    .order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar o mapa.' });
  res.json(data);
});

// ── Missões de um cenário, já filtradas pela idade ───────────────────
rotas.get('/cenarios/:slug/missoes', async (req, res) => {
  const cenario = await admin
    .from('cenarios')
    .select('id')
    .eq('slug', req.params.slug)
    .maybeSingle();

  if (cenario.error || !cenario.data) {
    return res.status(404).json({ message: 'Esse lugar não existe no mapa.' });
  }

  let consulta = admin
    .from('missoes')
    .select('id, titulo, descricao, nivel_etario, eh_especial')
    .eq('cenario_id', cenario.data.id);

  // O filtro etário é regra de negócio: uma missão de imunologia não
  // aparece para quem tem 8 anos. Aplicado aqui, e não na tela, para
  // que não dependa do navegador cooperar.
  const nivel = nivelDaIdade(req.usuario.idade);
  if (nivel) consulta = consulta.eq('nivel_etario', nivel);

  const { data, error } = await consulta.order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar as missões.' });
  res.json(data);
});

// ── Questões de uma missão ───────────────────────────────────────────
//
// Repare no select: `resposta_correta` e `explicacao` NÃO estão nele.
// As duas ficam no servidor até a pessoa responder. É o conserto do
// vazamento de gabarito descrito em docs/banco-de-dados.md (§4, item 4).
rotas.get('/missoes/:id/questoes', async (req, res) => {
  const missaoId = Number(req.params.id);

  if (!Number.isInteger(missaoId) || missaoId <= 0) {
    return res.status(400).json({ message: 'Missão inválida.' });
  }

  const { data, error } = await admin
    .from('questoes')
    .select('id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d')
    .eq('missao_id', missaoId)
    .order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar as questões.' });
  const acertadas = await admin
    .from('respostas_alunos')
    .select('questao_id')
    .eq('usuario_id', req.usuario.id)
    .eq('acertou', true)
    .in('questao_id', data.map(q => q.id));

  if (acertadas.error) {
    return res.status(500).json({ message: 'Não foi possível carregar seu progresso.' });
  }

  const jaFoi = new Set((acertadas.data || []).map(r => r.questao_id));
  const pendentes = data.filter(q => !jaFoi.has(q.id));

  
  for (let i = pendentes.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [pendentes[i], pendentes[j]] = [pendentes[j], pendentes[i]];
  }

  res.json({
    questoes: pendentes.slice(0, QUESTOES_POR_RODADA),
    restantes: pendentes.length,
    total: data.length
  });
});

rotas.post('/responder', async (req, res) => {
  const questaoId = Number(req.body?.questao_id);
  const resposta  = String(req.body?.resposta || '').trim().toUpperCase();

  if (!questaoId || !['A', 'B', 'C', 'D'].includes(resposta)) {
    return res.status(400).json({ message: 'Resposta inválida.' });
  }

  const questao = await admin
    .from('questoes')
    .select('id, missao_id, resposta_correta, explicacao')
    .eq('id', questaoId)
    .maybeSingle();

  if (questao.error || !questao.data) {
    return res.status(404).json({ message: 'Essa questão não existe.' });
  }

  const acertou = resposta === questao.data.resposta_correta;
  let quizId = Number(req.body?.quiz_id);
  if (!Number.isInteger(quizId) || quizId <= 0) {
    quizId = null;
  } else {
    const quiz = await admin
      .from('quizzes_professores').select('turma_id').eq('id', quizId).maybeSingle();
    if (!quiz.data || quiz.data.turma_id !== req.usuario.turma_id) quizId = null;
  }

  const gravou = await admin.from('respostas_alunos').insert({
    usuario_id: req.usuario.id,
    questao_id: questaoId,
    acertou,
    quiz_id: quizId
  });

  if (gravou.error) {
    return res.status(500).json({ message: 'Não foi possível registrar sua resposta.' });
  }

  let pontosGanhos = [];

  if (acertou) {
    // Pontua só no PRIMEIRO acerto de cada questão. Sem isso, bastava
    // responder a mesma pergunta certa dez vezes para encher as barras.
    const jaAcertou = await admin
      .from('respostas_alunos')
      .select('id')
      .eq('usuario_id', req.usuario.id)
      .eq('questao_id', questaoId)
      .eq('acertou', true)
      .limit(2);

    const primeiraVez = !jaAcertou.error && (jaAcertou.data || []).length <= 1;

    if (primeiraVez) {
      // Quais barras esta missão alimenta, e quanto. A tabela
      // missao_areas foi criada na migração 03 justamente para isto.
      const areas = await admin
        .from('missao_areas')
        .select('area_nome, pontos')
        .eq('missao_id', questao.data.missao_id);

      for (const area of areas.data || []) {
        const r = await admin.rpc('somar_pontos', {
          p_usuario: req.usuario.id,
          p_area:    area.area_nome,
          p_pontos:  area.pontos
        });
        if (!r.error) pontosGanhos.push({ area: area.area_nome, pontos: area.pontos });
      }
    }
  }

  // O que volta para a tela. Mesmo errando, a pessoa recebe a explicação
  // — mas NUNCA a letra certa: a ideia é que ela tente de novo com o
  // conteúdo em mãos, e não que copie a resposta.
  res.json({
    acertou,
    explicacao: questao.data.explicacao,
    pontos: pontosGanhos
  });
});
rotas.get('/meus-quizzes', async (req, res) => {
  if (!req.usuario.turma_id) return res.json([]);   // ainda sem turma

  const { data, error } = await admin
    .from('quizzes_professores')
    .select('id, titulo, tempo_limite_segundos, created_at')
    .eq('turma_id', req.usuario.turma_id)
    .order('created_at', { ascending: false });

  if (error) return res.status(500).json({ message: 'Não foi possível carregar suas tarefas.' });
  if (!data.length) return res.json([]);

  const ids = data.map(q => q.id);

  const vinculos = await admin.from('quiz_questoes').select('quiz_id, questao_id').in('quiz_id', ids);
  const respondidas = await admin
    .from('respostas_alunos').select('quiz_id, questao_id')
    .eq('usuario_id', req.usuario.id).eq('acertou', true).in('quiz_id', ids);

  const total = new Map();
  for (const v of vinculos.data || []) {
    total.set(v.quiz_id, (total.get(v.quiz_id) || 0) + 1);
  }
  const feitas = new Map();
  for (const r of respondidas.data || []) {
    feitas.set(r.quiz_id, (feitas.get(r.quiz_id) || 0) + 1);
  }

  res.json(data.map(q => {
    const t = total.get(q.id) || 0;
    const f = feitas.get(q.id) || 0;
    return { ...q, total_questoes: t, acertadas: f, concluido: t > 0 && f >= t };
  }));
});


rotas.get('/quizzes/:id/questoes', async (req, res) => {
  const quizId = Number(req.params.id);

  if (!Number.isInteger(quizId) || quizId <= 0) {
    return res.status(400).json({ message: 'Quiz inválido.' });
  }

  const quiz = await admin
    .from('quizzes_professores')
    .select('id, titulo, turma_id, professor_id, tempo_limite_segundos')
    .eq('id', quizId).maybeSingle();

  if (!quiz.data) return res.status(404).json({ message: 'Esse quiz não existe.' });

  const meu = quiz.data.turma_id === req.usuario.turma_id
    || quiz.data.professor_id === req.usuario.id
    || req.usuario.tipo === 'ADMIN';

  if (!meu) return res.status(403).json({ message: 'Esse quiz não é da sua turma.' });

  const vinculos = await admin
    .from('quiz_questoes').select('questao_id, ordem')
    .eq('quiz_id', quizId).order('ordem');

  if (vinculos.error) {
    return res.status(500).json({ message: 'Não foi possível carregar o quiz.' });
  }

  const ids = (vinculos.data || []).map(v => v.questao_id);
  if (!ids.length) return res.json({ ...quiz.data, questoes: [] });

  const questoes = await admin
    .from('questoes')
    .select('id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d')
    .in('id', ids);

  if (questoes.error) {
    return res.status(500).json({ message: 'Não foi possível carregar as questões.' });
  }

  const porId = new Map((questoes.data || []).map(q => [q.id, q]));
  const ordenadas = ids.map(id => porId.get(id)).filter(Boolean);

  res.json({ ...quiz.data, questoes: ordenadas });
});


// ── As 8 barras do aluno ─────────────────────────────────────────────
rotas.get('/meu-progresso', async (req, res) => {
  const { data, error } = await admin
    .from('areas')
    .select('nome, ordem')
    .order('ordem');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar seu progresso.' });

  const progresso = await admin
    .from('progresso_areas')
    .select('area_nome, pontos, porcentagem')
    .eq('usuario_id', req.usuario.id);

  const porArea = new Map((progresso.data || []).map(p => [p.area_nome, p]));

  // Devolve sempre as 8, mesmo as que ainda estão zeradas, para a tela
  // poder desenhar todas as barras desde o primeiro acesso.
  res.json(data.map(a => ({
    area:        a.nome,
    pontos:      porArea.get(a.nome)?.pontos ?? 0,
    porcentagem: porArea.get(a.nome)?.porcentagem ?? 0
  })));
});

module.exports = rotas;
