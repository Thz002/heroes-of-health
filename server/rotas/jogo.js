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
//
// Cada cenário vem com a lista de ÁREAS que ele alimenta (Saúde,
// Vacinação, ...). É o que o painel lateral do mapa usa para desenhar,
// no hover, as barras de progresso do aluno naquele lugar.
//
// A lista NÃO é filtrada pela idade de quem pergunta, ao contrário de
// /meu-mapa: aqui a pergunta é "o que este lugar ensina?", e não "o que
// eu posso jogar agora?". Filtrar por faixa etária deixaria o painel
// vazio nos lugares cujo conteúdo ainda só existe para outra idade.
rotas.get('/cenarios', async (req, res) => {
  const cenarios = await admin
    .from('cenarios')
    .select('id, slug, nome, descricao')
    .order('id');

  if (cenarios.error) {
    return res.status(500).json({ message: 'Não foi possível carregar o mapa.' });
  }

  // Três consultas soltas em vez de um join aninhado: missao_areas não
  // tem ligação direta com cenarios — a ponte entre as duas é missoes.
  const [missoes, vinculos, areas] = await Promise.all([
    admin.from('missoes').select('id, cenario_id'),
    admin.from('missao_areas').select('missao_id, area_nome'),
    admin.from('areas').select('nome, ordem').order('ordem')
  ]);

  if (missoes.error || vinculos.error || areas.error) {
    return res.status(500).json({ message: 'Não foi possível carregar as áreas do mapa.' });
  }

  const cenarioDaMissao = new Map((missoes.data || []).map(m => [m.id, m.cenario_id]));
  const ordemDaArea     = new Map((areas.data || []).map(a => [a.nome, a.ordem]));

  // Set por cenário: a mesma área costuma aparecer em várias missões do
  // mesmo lugar, e não pode virar barra repetida na tela.
  const areasPorCenario = new Map();
  for (const v of vinculos.data || []) {
    const cenarioId = cenarioDaMissao.get(v.missao_id);
    if (!cenarioId) continue;
    if (!areasPorCenario.has(cenarioId)) areasPorCenario.set(cenarioId, new Set());
    areasPorCenario.get(cenarioId).add(v.area_nome);
  }

  // Sai na ordem canônica das 8 barras (areas.ordem), não na ordem em
  // que o conteúdo foi cadastrado — assim Saúde vem sempre antes de
  // Felicidade, em qualquer lugar do mapa.
  res.json((cenarios.data || []).map(c => ({
    ...c,
    areas: [...(areasPorCenario.get(c.id) || [])]
      .sort((a, b) => (ordemDaArea.get(a) ?? 99) - (ordemDaArea.get(b) ?? 99))
  })));
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
    .select('id, titulo, descricao, tempo_limite_segundos, created_at')
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

  // As que a pessoa já acertou saem da vez. Sem isto, quem fecha a aba no
  // meio recomeça do zero — e o "faltam 4" do card do mapa não bateria
  // com o que a tela mostra. A ordem sorteada é preservada: a fila é a
  // mesma para a turma inteira, só sem o que cada um já resolveu.
  const acertadas = await admin
    .from('respostas_alunos').select('questao_id')
    .eq('usuario_id', req.usuario.id).eq('acertou', true)
    .eq('quiz_id', quizId).in('questao_id', ids);

  const jaFoi = new Set((acertadas.data || []).map(r => r.questao_id));
  const pendentes = ordenadas.filter(q => !jaFoi.has(q.id));

  res.json({
    ...quiz.data,
    questoes: pendentes,
    restantes: pendentes.length,
    total: ordenadas.length
  });
});


// ── O bairro inteiro, do ponto de vista deste aluno ──────────────────
//
// UMA chamada devolve o estado de todos os lugares. O mapa tem 48 pontos
// clicáveis; perguntar um a um seriam 48 requisições para desenhar uma
// tela só.
//
// Devolve apenas os lugares que TÊM algo para fazer — quem não aparece
// aqui, ou não tem conteúdo para a idade da pessoa, ou já foi concluído.
rotas.get('/meu-mapa', async (req, res) => {
  const nivel = nivelDaIdade(req.usuario.idade);

  // 1. As missões da faixa etária desta pessoa, com o cenário junto.
  let consulta = admin
    .from('missoes')
    .select('id, titulo, descricao, nivel_etario, cenarios!inner(slug, nome)');
  if (nivel) consulta = consulta.eq('nivel_etario', nivel);

  const missoes = await consulta;
  if (missoes.error) {
    return res.status(500).json({ message: 'Não foi possível carregar o mapa.' });
  }

  const idsMissoes = (missoes.data || []).map(m => m.id);
  if (!idsMissoes.length) return res.json({ lugares: [], total_pendente: 0 });

  // 2. Tudo o que falta buscar, em consultas únicas — nada dentro de laço.
  const [questoes, areas, acertos] = await Promise.all([
    admin.from('questoes').select('id, missao_id').in('missao_id', idsMissoes),
    admin.from('missao_areas').select('missao_id, area_nome').in('missao_id', idsMissoes),
    admin.from('respostas_alunos').select('questao_id')
      .eq('usuario_id', req.usuario.id).eq('acertou', true)
  ]);

  const jaAcertou = new Set((acertos.data || []).map(r => r.questao_id));

  const porMissao = new Map(idsMissoes.map(id => [id, { total: 0, restantes: 0 }]));
  for (const q of questoes.data || []) {
    const c = porMissao.get(q.missao_id);
    if (!c) continue;
    c.total++;
    if (!jaAcertou.has(q.id)) c.restantes++;
  }

  const areasPorMissao = new Map();
  for (const a of areas.data || []) {
    if (!areasPorMissao.has(a.missao_id)) areasPorMissao.set(a.missao_id, []);
    areasPorMissao.get(a.missao_id).push(a.area_nome);
  }

  // 3. As tarefas do professor, se a pessoa estiver numa turma.
  //
  // Um quiz guarda uma LISTA de cenários, então ele não mora num lugar
  // só: aparece em cada ponto que cobre. Responder num deles conta nos
  // outros — é a mesma tarefa vista de janelas diferentes.
  const quizzesPorSlug = new Map();

  if (req.usuario.turma_id) {
    const quizzes = await admin
      .from('quizzes_professores')
      .select('id, titulo, descricao, cenarios, tempo_limite_segundos')
      .eq('turma_id', req.usuario.turma_id);

    const idsQuiz = (quizzes.data || []).map(q => q.id);

    if (idsQuiz.length) {
      const [vinculos, feitas] = await Promise.all([
        admin.from('quiz_questoes').select('quiz_id, questao_id').in('quiz_id', idsQuiz),
        admin.from('respostas_alunos').select('quiz_id, questao_id')
          .eq('usuario_id', req.usuario.id).eq('acertou', true).in('quiz_id', idsQuiz)
      ]);

      const total = new Map();
      for (const v of vinculos.data || []) total.set(v.quiz_id, (total.get(v.quiz_id) || 0) + 1);

      const prontas = new Map();
      for (const f of feitas.data || []) prontas.set(f.quiz_id, (prontas.get(f.quiz_id) || 0) + 1);

      for (const q of quizzes.data || []) {
        const t = total.get(q.id) || 0;
        const p = prontas.get(q.id) || 0;
        if (t === 0 || p >= t) continue;              // vazio ou já concluído

        for (const slug of (q.cenarios || [])) {
          if (!quizzesPorSlug.has(slug)) quizzesPorSlug.set(slug, []);
          quizzesPorSlug.get(slug).push({
            id: q.id, titulo: q.titulo, descricao: q.descricao,
            restantes: t - p, total: t,
            tempo_limite_segundos: q.tempo_limite_segundos
          });
        }
      }
    }
  }

  // 4. Junta por lugar, escondendo o que não tem nada a fazer.
  const lugares = (missoes.data || []).map(m => {
    const c = porMissao.get(m.id) || { total: 0, restantes: 0 };
    const quizzes = quizzesPorSlug.get(m.cenarios.slug) || [];

    return {
      slug: m.cenarios.slug,
      nome: m.cenarios.nome,
      missao_id: m.id,
      titulo: m.titulo,
      descricao: m.descricao,
      restantes: c.restantes,
      total: c.total,
      areas: areasPorMissao.get(m.id) || [],
      quizzes
    };
  }).filter(l => l.restantes > 0 || l.quizzes.length > 0);

  // Tarefa do professor na frente: é dever, não passeio.
  lugares.sort((a, b) => (b.quizzes.length - a.quizzes.length) || (b.restantes - a.restantes));

  res.json({ lugares, total_pendente: lugares.length });
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
