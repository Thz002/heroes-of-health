/** Rotas do aluno jogando: correção, pontuação e progresso ficam no servidor. */

const express = require('express');
const { admin } = require('../supabase');
const { autenticar } = require('../middleware/autenticar');
const { falhou } = require('../erros');
const { lerTudo } = require('../lerTudo');
const { CRIADOR_SISTEMA } = require('../conteudo');
const PROG = require('../progressao');

const { XP_POR_QUESTAO, acertosUnicosPorAluno } = PROG;

const rotas = express.Router();
rotas.use(autenticar);

/** Repete a consulta sem `descricao` se a coluna ainda não existir no banco. */
async function comOuSemDescricao(montar) {
  const r = await montar(true);
  if (r.error && /descricao/.test(r.error.message || '')) return montar(false);
  return r;
}

// ── Cenários do mapa ── com as áreas que cada um alimenta (sem filtro de idade).
rotas.get('/cenarios', async (req, res) => {
  const cenarios = await admin
    .from('cenarios')
    .select('id, slug, nome, descricao')
    .order('id');

  if (cenarios.error) {
    return falhou(res, 500, 'Não foi possível carregar o mapa.', cenarios.error, 'GET /cenarios');
  }

  // Só questões do sistema; lerTudo porque passa de 1000 linhas.
  const [questoes, vinculos, areas] = await Promise.all([
    lerTudo(() => admin.from('questoes').select('id, cenario_id')
      .eq('criado_por', CRIADOR_SISTEMA).order('id')),
    lerTudo(() => admin.from('questoes_areas').select('questao_id, area_nome')
      .order('questao_id').order('area_nome')),
    admin.from('areas').select('nome, ordem').order('ordem')
  ]);

  const erro = questoes.error || vinculos.error || areas.error;
  if (erro) {
    return falhou(res, 500, 'Não foi possível carregar as áreas do mapa.', erro, 'GET /cenarios');
  }

  const cenarioDaQuestao = new Map(questoes.data.map(q => [q.id, q.cenario_id]));
  const ordemDaArea      = new Map((areas.data || []).map(a => [a.nome, a.ordem]));

  // Set por cenário: a mesma área aparece em muitas questões do mesmo
  // lugar, e não pode virar barra repetida na tela.
  const areasPorCenario = new Map();
  for (const v of vinculos.data) {
    const cenarioId = cenarioDaQuestao.get(v.questao_id);
    if (!cenarioId) continue;
    if (!areasPorCenario.has(cenarioId)) areasPorCenario.set(cenarioId, new Set());
    areasPorCenario.get(cenarioId).add(v.area_nome);
  }

  // Áreas na ordem das 8 barras.
  res.json((cenarios.data || []).map(c => ({
    ...c,
    areas: [...(areasPorCenario.get(c.id) || [])]
      .sort((a, b) => (ordemDaArea.get(a) ?? 99) - (ordemDaArea.get(b) ?? 99))
  })));
});

// ── Responder ── só dentro de um quiz do professor.
rotas.post('/responder', async (req, res) => {
  const questaoId = Number(req.body?.questao_id);
  const resposta  = String(req.body?.resposta || '').trim().toUpperCase();

  // A E é do nível 3, no formato do ENEM.
  if (!questaoId || !['A', 'B', 'C', 'D', 'E'].includes(resposta)) {
    return res.status(400).json({ message: 'Resposta inválida.' });
  }

  const quizId = Number(req.body?.quiz_id);
  if (!Number.isInteger(quizId) || quizId <= 0) {
    return res.status(400).json({ message: 'Responda pelas missões do seu professor.' });
  }

  // O quiz tem de ser da turma (ou do professor que o criou) e conter a questão.
  const [quiz, vinculo] = await Promise.all([
    admin.from('quizzes_professores').select('turma_id, professor_id').eq('id', quizId).maybeSingle(),
    admin.from('quiz_questoes').select('questao_id')
      .eq('quiz_id', quizId).eq('questao_id', questaoId).maybeSingle()
  ]);

  const meu = quiz.data && (
    quiz.data.turma_id === req.usuario.turma_id
    || quiz.data.professor_id === req.usuario.id
    || req.usuario.tipo === 'ADMIN');

  if (!meu || !vinculo.data) {
    return res.status(403).json({ message: 'Essa questão não faz parte de uma missão sua.' });
  }

  // Fallback para bancos sem explicacao_erro.
  const CAMPOS = 'id, resposta_correta, explicacao';

  let questao = await admin
    .from('questoes')
    .select(CAMPOS + ', explicacao_erro')
    .eq('id', questaoId)
    .maybeSingle();

  if (questao.error && /explicacao_erro/.test(questao.error.message || '')) {
    questao = await admin.from('questoes').select(CAMPOS).eq('id', questaoId).maybeSingle();
  }

  if (questao.error || !questao.data) {
    return res.status(404).json({ message: 'Essa questão não existe.' });
  }

  const acertou = resposta === questao.data.resposta_correta;

  const gravou = await admin.from('respostas_alunos').insert({
    usuario_id: req.usuario.id,
    questao_id: questaoId,
    acertou,
    quiz_id: quizId
  });

  if (gravou.error) {
    return falhou(res, 500, 'Não foi possível registrar sua resposta.', gravou.error, 'POST /responder');
  }

  let pontosGanhos = [];

  if (acertou) {
    // Pontua só no primeiro acerto de cada questão.
    const jaAcertou = await admin
      .from('respostas_alunos')
      .select('id')
      .eq('usuario_id', req.usuario.id)
      .eq('questao_id', questaoId)
      .eq('acertou', true)
      .limit(2);

    const primeiraVez = !jaAcertou.error && (jaAcertou.data || []).length <= 1;

    if (primeiraVez) {
      // Quais barras esta questão alimenta, e quanto.
      const areas = await admin
        .from('questoes_areas')
        .select('area_nome, pontos')
        .eq('questao_id', questaoId);

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

  // Barras que o acerto mexeu, para o aviso de progresso (só quizzes da própria turma).
  let barras = [];

  if (pontosGanhos.length && quiz.data.turma_id === req.usuario.turma_id) {
    const prog = await admin.rpc('progresso_do_aluno', { p_usuario: req.usuario.id });

    if (!prog.error) {
      const ganho = new Map(pontosGanhos.map(p => [p.area, p.pontos]));

      barras = (prog.data || [])
        .filter(a => ganho.has(a.area))
        .map(a => ({
          area: a.area,
          ganhou: ganho.get(a.area),
          pontos: Number(a.pontos_ganhos) || 0,
          possiveis: Number(a.pontos_possiveis) || 0
        }));
    }
  }

  // Terminou o quiz com esta resposta? É o marco que premia os dois.
  const conclusao = acertou ? await PROG.registrarConclusao(req.usuario, quizId) : null;

  // XP e nível depois da resposta.
  const retrato = await PROG.xpDoAluno(req.usuario.id);

  const novas = retrato.erro ? [] : await PROG.conquistar(
    req.usuario.id, 'ALUNO',
    await PROG.medirAluno(req.usuario.id, req.usuario.turma_id, retrato));

  const xp = (retrato.total || 0) + novas.reduce((s, i) => s + (i.xp || 0), 0);

  // Nunca devolve a letra certa.
  res.json({
    acertou,
    // Explicação de acerto ou de erro (sem a de erro, usa a de acerto).
    explicacao: (acertou ? questao.data.explicacao
                         : questao.data.explicacao_erro || questao.data.explicacao),
    pontos: pontosGanhos,
    barras,
    conclusao,
    xp,
    nivel: PROG.nivelDoXp(xp, 'ALUNO'),
    insignias_novas: PROG.paraAviso(novas)
  });
});
rotas.get('/meus-quizzes', async (req, res) => {
  if (!req.usuario.turma_id) return res.json([]);   // ainda sem turma

  const { data, error } = await comOuSemDescricao(com => admin
    .from('quizzes_professores')
    .select('id, titulo, ' + (com ? 'descricao, ' : '') + 'tempo_limite_segundos, created_at')
    .eq('turma_id', req.usuario.turma_id)
    .order('created_at', { ascending: false }));

  if (error) return falhou(res, 500, 'Não foi possível carregar suas tarefas.', error, 'GET /meus-quizzes');
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
    .select('id, titulo, turma_id, professor_id, tempo_limite_segundos, cenarios')
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
    return falhou(res, 500, 'Não foi possível carregar o quiz.', vinculos.error, 'GET /quizzes/:id/questoes');
  }

  const ids = (vinculos.data || []).map(v => v.questao_id);
  if (!ids.length) return res.json({ ...quiz.data, questoes: [] });

  const questoes = await admin
    .from('questoes')
    .select('id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e')
    .in('id', ids);

  if (questoes.error) {
    return falhou(res, 500, 'Não foi possível carregar as questões.', questoes.error, 'GET /quizzes/:id/questoes');
  }

  const porId = new Map((questoes.data || []).map(q => [q.id, q]));
  const ordenadas = ids.map(id => porId.get(id)).filter(Boolean);

  // Tira da fila as que a pessoa já acertou, mantendo a ordem.
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


// ── Missões ativas ── quizzes da turma com perguntas pendentes.
rotas.get('/meu-mapa', async (req, res) => {
  if (!req.usuario.turma_id) return res.json({ quizzes: [], total_pendente: 0 });

  const quizzes = await comOuSemDescricao(com => admin
    .from('quizzes_professores')
    .select('id, titulo, ' + (com ? 'descricao, ' : '') + 'cenarios, tempo_limite_segundos, created_at')
    .eq('turma_id', req.usuario.turma_id)
    .order('created_at', { ascending: false }));

  if (quizzes.error) {
    return falhou(res, 500, 'Não foi possível carregar suas missões.', quizzes.error, 'GET /meu-mapa');
  }

  const idsQuiz = quizzes.data.map(q => q.id);
  if (!idsQuiz.length) return res.json({ quizzes: [], total_pendente: 0 });

  const [vinculos, feitas] = await Promise.all([
    admin.from('quiz_questoes').select('quiz_id, questao_id').in('quiz_id', idsQuiz),
    admin.from('respostas_alunos').select('quiz_id, questao_id')
      .eq('usuario_id', req.usuario.id).eq('acertou', true).in('quiz_id', idsQuiz)
  ]);

  const erro = vinculos.error || feitas.error;
  if (erro) return falhou(res, 500, 'Não foi possível carregar suas missões.', erro, 'GET /meu-mapa');

  const total = new Map();
  for (const v of vinculos.data) total.set(v.quiz_id, (total.get(v.quiz_id) || 0) + 1);

  // Conta questões distintas acertadas.
  const prontas = new Map();
  for (const f of feitas.data) {
    if (!prontas.has(f.quiz_id)) prontas.set(f.quiz_id, new Set());
    prontas.get(f.quiz_id).add(f.questao_id);
  }

  // Mais recente primeiro: é a tarefa que o professor acabou de passar.
  const pendentes = [];
  for (const q of quizzes.data) {
    const t = total.get(q.id) || 0;
    const p = (prontas.get(q.id) || new Set()).size;
    if (t === 0 || p >= t) continue;              // vazio ou já concluído

    pendentes.push({
      id: q.id,
      titulo: q.titulo,
      descricao: q.descricao || null,
      cenarios: q.cenarios || [],
      restantes: t - p,
      total: t,
      tempo_limite_segundos: q.tempo_limite_segundos
    });
  }

  res.json({ quizzes: pendentes, total_pendente: pendentes.length });
});


// ── As 8 barras do aluno ── (progresso_do_aluno() no banco). porcentagem arredondada para baixo.
rotas.get('/meu-progresso', async (req, res) => {
  const { data, error } = await admin.rpc('progresso_do_aluno', { p_usuario: req.usuario.id });

  if (error) return falhou(res, 500, 'Não foi possível carregar seu progresso.', error, 'GET /meu-progresso');

  res.json((data || []).map(a => {
    const pontos = Number(a.pontos_ganhos) || 0;
    const possiveis = Number(a.pontos_possiveis) || 0;

    return {
      area: a.area,
      pontos,
      pontos_possiveis: possiveis,
      porcentagem: possiveis ? Math.floor((pontos * 100) / possiveis) : 0,
      sem_missoes: possiveis === 0
    };
  }));
});

/* ── GET /meu-resumo ── turma, posição e os números da tela de progresso. */

/** Turma do aluno, colegas e posição (usado por /meu-resumo e /minha-turma).
    Devolve { erro } ou { turma: null }. */
async function turmaComColegas(eu, turmaId) {
  const turma = await admin
    .from('turmas')
    .select('id, nome, cor, ano_escolar, professor_id')
    .eq('id', turmaId)
    .maybeSingle();

  if (turma.error) return { erro: turma.error };
  if (!turma.data) return { turma: null, colegas: [], posicao: null };

  const [professor, matriculados] = await Promise.all([
    admin.from('usuarios').select('id, nome, avatar_url').eq('id', turma.data.professor_id).maybeSingle(),
    admin.from('usuarios').select('id, nome, tipo, avatar_url')
      .eq('turma_id', turmaId).in('tipo', ['ALUNO', 'ADMIN'])
  ]);

  if (matriculados.error) return { erro: matriculados.error };

  const membros = matriculados.data || [];
  const alunos = membros.filter(m => m.tipo === 'ALUNO');

  // Professor da turma, com foto e patente.
  let dadosProfessor = null;

  if (professor.data) {
    const dele = await PROG.xpDoProfessor(professor.data.id);

    dadosProfessor = {
      nome: professor.data.nome,
      avatar_url: professor.data.avatar_url || null,
      xp: dele.erro ? 0 : dele.total,
      nivel: dele.erro ? null : dele.nivel,
      conclusoes: dele.erro ? 0 : dele.conclusoes,
      taxa_media: dele.erro ? null : dele.taxa_media
    };
  }

  const dados = {
    id: turma.data.id,
    nome: turma.data.nome,
    cor: turma.data.cor || null,
    ano_escolar: turma.data.ano_escolar || null,
    professor: dadosProfessor?.nome || null,
    professor_perfil: dadosProfessor,

    // Quantos ALUNOS: é o tamanho da turma, e conta de equipe não
    // aumenta turma nenhuma.
    total_alunos: alunos.length
  };

  if (!membros.length) return { turma: dados, colegas: [], posicao: null };

  // XP completo de cada um. A conta de equipe entra pela régua de
  // aluno, que é a mesma que o jogo usa para ela.
  const porPessoa = await PROG.xpDeVarios(membros.map(m => m.id));

  const colegas = membros.map(m => {
    const xp = porPessoa.get(m.id) || 0;
    const equipe = m.tipo !== 'ALUNO';

    return {
      nome: m.nome,
      avatar_url: m.avatar_url || null,
      xp,
      nivel: PROG.nivelDoXp(xp, 'ALUNO'),
      equipe,
      eu: m.id === eu
    };
  }).sort((a, b) =>
    // A equipe aparece — ela existe e joga —, mas nunca disputa: vai
    // para o fim da lista com qualquer pontuação. Entre os alunos, o
    // XP manda, e o nome desempata.
    Number(a.equipe) - Number(b.equipe) ||
    b.xp - a.xp ||
    a.nome.localeCompare(b.nome, 'pt-BR')
  );

  // A posição é uma disputa entre alunos. Quem é da equipe não tem
  // lugar no pódio, e também não empurra ninguém para baixo: a conta
  // só olha para os outros alunos.
  const souAluno = membros.some(m => m.id === eu && m.tipo === 'ALUNO');
  if (!souAluno) return { turma: dados, colegas, posicao: null };

  const meuXp = porPessoa.get(eu) || 0;
  const naFrente = colegas.filter(c => !c.eu && !c.equipe && c.xp > meuXp).length;

  return { turma: dados, colegas, posicao: { lugar: naFrente + 1, total: alunos.length } };
}

rotas.get('/meu-resumo', async (req, res) => {
  const eu = req.usuario.id;
  const turmaId = req.usuario.turma_id;

  // ── Os quatro números ──────────────────────────────────────────────
  const minhas = await lerTudo(() => admin
    .from('respostas_alunos')
    .select('questao_id, acertou, data_resposta, quiz_id')
    .eq('usuario_id', eu)
    .order('id'));

  if (minhas.error) {
    return falhou(res, 500, 'Não foi possível carregar seu resumo.', minhas.error, 'GET /meu-resumo');
  }

  const respostas = minhas.data.length;
  const certas = minhas.data.filter(r => r.acertou);
  const distintas = new Set(certas.map(r => r.questao_id));

  // Professor: XP vem de xpDoProfessor().
  const retrato = req.usuario.tipo === 'PROFESSOR'
    ? await PROG.xpDoProfessor(eu)
    : await PROG.xpDoAluno(eu, minhas.data);

  if (retrato.erro) {
    return falhou(res, 500, 'Não foi possível carregar seu resumo.', retrato.erro, 'GET /meu-resumo');
  }

  const estatisticas = {
    respostas,
    acertos: certas.length,
    // null e não zero: "ainda não respondi nada" não é "fui mal".
    taxa: respostas ? Math.round((certas.length / respostas) * 100) : null,
    acertos_unicos: distintas.size,

    // XP total e as partes de cada fonte.
    xp: retrato.total,
    xp_de_questoes: retrato.de_questoes,
    xp_de_dias: retrato.de_dias,
    xp_de_insignias: retrato.de_insignias,
    xp_de_conclusoes: retrato.de_conclusoes,
    nivel: retrato.nivel,

    conclusoes: retrato.conclusoes,

    // Só para o professor.
    quizzes_criados: retrato.quizzes_criados,
    acertos_da_turma: retrato.acertos_da_turma,
    taxa_media: retrato.taxa_media,

    missoes_concluidas: 0,
    missoes_totais: 0,

    dias_jogados: retrato.dias_jogados,
    streak_dias: retrato.streak_dias,
    jogou_hoje: retrato.jogou_hoje
  };

  // Sem turma o aluno ainda joga, mas não tem colegas nem missões.
  if (!turmaId) {
    return res.json({ turma: null, posicao: null, estatisticas });
  }

  // ── Missões concluídas ─────────────────────────────────────────────
  const quizzes = await admin
    .from('quizzes_professores')
    .select('id')
    .eq('turma_id', turmaId);

  if (quizzes.error) {
    return falhou(res, 500, 'Não foi possível carregar suas missões.', quizzes.error, 'GET /meu-resumo');
  }

  const idsQuiz = quizzes.data.map(q => q.id);

  if (idsQuiz.length) {
    const vinculos = await lerTudo(() => admin
      .from('quiz_questoes')
      .select('quiz_id, questao_id')
      .in('quiz_id', idsQuiz)
      .order('quiz_id').order('questao_id'));

    if (vinculos.error) {
      return falhou(res, 500, 'Não foi possível carregar suas missões.', vinculos.error, 'GET /meu-resumo');
    }

    const total = new Map();
    for (const v of vinculos.data) total.set(v.quiz_id, (total.get(v.quiz_id) || 0) + 1);

    // Questões distintas acertadas no quiz.
    const prontas = new Map();
    for (const r of certas) {
      if (!r.quiz_id) continue;
      if (!prontas.has(r.quiz_id)) prontas.set(r.quiz_id, new Set());
      prontas.get(r.quiz_id).add(r.questao_id);
    }

    // Quiz sem questões não conta.
    const valem = idsQuiz.filter(id => (total.get(id) || 0) > 0);

    estatisticas.missoes_totais = valem.length;
    estatisticas.missoes_concluidas = valem
      .filter(id => (prontas.get(id) || new Set()).size >= total.get(id)).length;
  }

  // ── A turma e a posição ────────────────────────────────────────────
  const daTurma = await turmaComColegas(eu, turmaId);

  if (daTurma.erro) {
    return falhou(res, 500, 'Não foi possível carregar sua turma.', daTurma.erro, 'GET /meu-resumo');
  }

  // Os colegas ficam de fora desta rota.
  res.json({
    turma: daTurma.turma,
    posicao: daTurma.posicao,
    estatisticas
  });
});

/* ── GET /minha-turma ── a turma do aluno e os colegas (sem taxa de acerto). */

rotas.get('/minha-turma', async (req, res) => {
  if (!req.usuario.turma_id) {
    return res.json({ turma: null, colegas: [], posicao: null });
  }

  const daTurma = await turmaComColegas(req.usuario.id, req.usuario.turma_id);

  if (daTurma.erro) {
    return falhou(res, 500, 'Não foi possível carregar sua turma.', daTurma.erro, 'GET /minha-turma');
  }

  res.json(daTurma);
});

/* ── POST /minha-turma ── entra numa turma, só quem ainda não tem.
   "turma_id is null" no próprio update evita corrida. */

rotas.post('/minha-turma', async (req, res) => {
  // ALUNO e ADMIN. O admin entra para JOGAR — é assim que a equipe
  // testa o jogo pelo lado de quem joga, respondendo os quizes que o
  // professor manda. Ele não aparece na lista de colegas nem no
  // ranking da turma, porque `turmaComColegas` só conta ALUNO, e isso
  // é de propósito: conta de teste não pode mexer na classificação que
  // o professor usa para avaliar.
  //
  // PROFESSOR continua de fora: a turma dele é a que ele criou, e está
  // em `turmas.professor_id`. Deixá-lo também matriculado como aluno
  // daria duas verdades sobre o mesmo vínculo.
  if (req.usuario.tipo === 'PROFESSOR') {
    return res.status(403).json({
      message: 'Professor não entra em turma como aluno — as suas turmas estão no painel.',
    });
  }
  if (req.usuario.turma_id) {
    return res.status(409).json({ message: 'Você já está numa turma. Para trocar, fale com seu professor.' });
  }

  const turmaId = Number(req.body?.turma_id);
  if (!Number.isInteger(turmaId) || turmaId <= 0) {
    return res.status(400).json({ message: 'Escolha uma turma.' });
  }

  const turma = await admin.from('turmas').select('id').eq('id', turmaId).maybeSingle();
  if (turma.error) {
    return falhou(res, 500, 'Não foi possível entrar na turma.', turma.error, 'POST /minha-turma');
  }
  if (!turma.data) {
    return res.status(404).json({ message: 'Essa turma não existe mais. Confira com seu professor.' });
  }

  const gravou = await admin
    .from('usuarios')
    .update({ turma_id: turmaId })
    .eq('id', req.usuario.id)
    .is('turma_id', null)
    .select('id');

  if (gravou.error) {
    return falhou(res, 500, 'Não foi possível entrar na turma.', gravou.error, 'POST /minha-turma');
  }
  if (!gravou.data.length) {
    return res.status(409).json({ message: 'Você já está numa turma. Para trocar, fale com seu professor.' });
  }

  const daTurma = await turmaComColegas(req.usuario.id, turmaId);
  if (daTurma.erro) {
    return falhou(res, 500, 'Você entrou na turma, mas não foi possível carregá-la agora.', daTurma.erro, 'POST /minha-turma');
  }

  res.json(daTurma);
});

/* ── DELETE /minha-turma ── sai da turma.

   NADA de progresso se perde: XP, acertos, insígnias e paciente
   virtual são todos presos ao usuario_id, e nenhum deles olha para
   turma_id. O que muda é o que depende da turma — a posição no
   ranking dela e os quizes que o professor manda — e esses voltam
   inteiros se a pessoa entrar de novo na mesma turma.

   Quem sai é a própria pessoa. Tirar um aluno da turma à revelia é
   coisa de professor ou de admin, e tem lugar próprio no painel. */

rotas.delete('/minha-turma', async (req, res) => {
  if (!req.usuario.turma_id) {
    return res.status(409).json({ message: 'Você não está em nenhuma turma.' });
  }

  const saiu = await admin
    .from('usuarios')
    .update({ turma_id: null })
    .eq('id', req.usuario.id)
    .eq('turma_id', req.usuario.turma_id)    // evita corrida com uma troca simultânea
    .select('id');

  if (saiu.error) {
    return falhou(res, 500, 'Não foi possível sair da turma.', saiu.error, 'DELETE /minha-turma');
  }
  if (!saiu.data.length) {
    return res.status(409).json({ message: 'Sua turma mudou enquanto isso. Recarregue a página.' });
  }

  console.log(`  · ${req.usuario.nome} saiu da turma ${req.usuario.turma_id}`);
  res.json({ message: 'Você saiu da turma. Seu progresso continua todo aí.' });
});


/* ── POST /presenca ── marca o dia (o banco recusa o segundo do mesmo dia). */

rotas.post('/presenca', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo;

  const presenca = await PROG.marcarPresenca(eu);

  if (presenca.erro) {
    return falhou(res, 500, 'Não foi possível registrar sua entrada.', presenca.erro, 'POST /presenca');
  }

  // Mede a sequência depois de marcar o dia.
  const retrato = sou === 'PROFESSOR'
    ? await PROG.xpDoProfessor(eu)
    : await PROG.xpDoAluno(eu);

  if (retrato.erro) {
    return falhou(res, 500, 'Não foi possível calcular seu progresso.', retrato.erro, 'POST /presenca');
  }

  const medidas = sou === 'PROFESSOR'
    ? retrato.medidas
    : await PROG.medirAluno(eu, req.usuario.turma_id, retrato);

  const novas = await PROG.conquistar(eu, sou === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO', medidas);

  // Soma o XP das insígnias recém-ganhas.
  const xp = retrato.total + novas.reduce((s, i) => s + (i.xp || 0), 0);

  res.json({
    ganhou_hoje: presenca.ganhou,
    pontos_do_dia: presenca.pontos,
    dia: presenca.dia,
    xp,
    nivel: PROG.nivelDoXp(xp, sou),
    streak_dias: retrato.streak_dias,
    dias_jogados: retrato.dias_jogados,
    insignias_novas: PROG.paraAviso(novas)
  });
});


/* ── Segredos do mapa ── GET /minhas-descobertas e POST /descobrir (só insígnias DESCOBERTA). */

rotas.get('/minhas-descobertas', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';

  const [bruto1, bruto2] = await Promise.all([
    admin.from('insignias').select('codigo, nome, imagem')
      .eq('regra', 'DESCOBERTA').eq('publico', sou).order('ordem'),
    admin.from('insignias_usuarios').select('insignia_codigo').eq('usuario_id', eu)
  ]);

  const catalogo = PROG.ouVazio(bruto1);
  const minhas = PROG.ouVazio(bruto2);

  if (catalogo.error || minhas.error) {
    return falhou(res, 500, 'Não foi possível carregar os segredos do mapa.',
      catalogo.error || minhas.error, 'GET /minhas-descobertas');
  }

  const tenho = new Set((minhas.data || []).map(i => i.insignia_codigo));

  res.json({
    descobertas: (catalogo.data || []).map(i => ({
      codigo: i.codigo,
      nome: i.nome,
      imagem: i.imagem || null,
      conquistada: tenho.has(i.codigo)
    }))
  });
});

rotas.post('/descobrir', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';
  const codigo = req.body && req.body.codigo;

  if (typeof codigo !== 'string' || !codigo || codigo.length > 40) {
    return res.status(400).json({ message: 'Segredo inválido.' });
  }

  const r = await PROG.descobrir(eu, sou, codigo);

  if (r.erro && r.erro.naoExiste) {
    return res.status(404).json({ message: 'Esse segredo não existe.' });
  }
  if (r.erro) {
    return falhou(res, 500, 'Não foi possível registrar a descoberta.', r.erro, 'POST /descobrir');
  }

  // Já tinha: nada a comemorar, e o XP não mudou.
  if (!r.nova) return res.json({ insignias_novas: [] });

  // A insígnia já está gravada, então o total recontado já a inclui.
  const retrato = sou === 'PROFESSOR'
    ? await PROG.xpDoProfessor(eu)
    : await PROG.xpDoAluno(eu);

  res.json({
    insignias_novas: PROG.paraAviso([r.nova]),
    ...(retrato.erro ? {} : { xp: retrato.total, nivel: PROG.nivelDoXp(retrato.total, sou) })
  });
});


/* ── GET /minha-estante ── o catálogo inteiro; degraus do mesmo grupo viram uma peça. */

/** Peça de um grupo de degraus, com o próximo e a escada inteira. */
function pecaDoGrupo(degraus) {
  const escada = [...degraus].sort((a, b) => a.alvo - b.alvo);

  let feitos = 0;
  escada.forEach((d, n) => { if (d.conquistada) feitos = n + 1; });

  const mostrado = escada[Math.max(feitos - 1, 0)];
  const seguinte = feitos > 0 ? escada[feitos] : null;

  return {
    ...mostrado,
    degraus: escada.length,
    degraus_feitos: feitos,
    proximo: seguinte
      ? { nome: seguinte.nome, alvo: seguinte.alvo, progresso: seguinte.progresso, porcentagem: seguinte.porcentagem }
      : null,
    escada: escada.map(d => ({
      nome: d.nome, alvo: d.alvo, xp: d.xp, imagem: d.imagem,
      conquistada: d.conquistada, conquistada_em: d.conquistada_em
    }))
  };
}

rotas.get('/minha-estante', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';

  // Banco sem as tabelas: estante vazia em vez de erro.
  const [bruto1, bruto2] = await Promise.all([
    admin.from('insignias')
      .select('codigo, nome, descricao, regra, alvo, xp, imagem, ordem, cenario_slug, grupo')
      .eq('publico', sou).order('ordem'),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em').eq('usuario_id', eu)
  ]);

  const catalogo = PROG.ouVazio(bruto1);
  const minhas = PROG.ouVazio(bruto2);

  if (catalogo.error) {
    return falhou(res, 500, 'Não foi possível abrir sua estante.', catalogo.error, 'GET /minha-estante');
  }
  if (minhas.error) {
    return falhou(res, 500, 'Não foi possível abrir sua estante.', minhas.error, 'GET /minha-estante');
  }

  const quando = new Map((minhas.data || []).map(i => [i.insignia_codigo, i.conquistada_em]));

  const retrato = sou === 'PROFESSOR'
    ? await PROG.xpDoProfessor(eu)
    : await PROG.xpDoAluno(eu);

  if (retrato.erro) {
    return falhou(res, 500, 'Não foi possível abrir sua estante.', retrato.erro, 'GET /minha-estante');
  }

  const medidas = sou === 'PROFESSOR'
    ? retrato.medidas
    : await PROG.medirAluno(eu, req.usuario.turma_id, retrato);

  const degraus = (catalogo.data || []).map(i => {
    const tenho = quando.has(i.codigo);
    const agora = PROG.medidaDe(medidas, i) ?? 0;

    return {
      codigo: i.codigo,
      nome: i.nome,
      descricao: i.descricao,
      xp: i.xp,
      imagem: i.imagem || null,
      regra: i.regra,
      alvo: i.alvo,
      grupo: i.grupo || null,
      conquistada: tenho,
      conquistada_em: quando.get(i.codigo) || null,
      // Nunca passa do alvo.
      progresso: Math.min(agora, i.alvo),
      porcentagem: Math.min(100, Math.round((agora / i.alvo) * 100))
    };
  });

  const porGrupo = new Map();
  for (const d of degraus) {
    if (!d.grupo) continue;
    if (!porGrupo.has(d.grupo)) porGrupo.set(d.grupo, []);
    porGrupo.get(d.grupo).push(d);
  }

  // A peça de um grupo ocupa o lugar do primeiro degrau.
  const insignias = [];
  for (const d of degraus) {
    if (!d.grupo) insignias.push(d);
    else if (porGrupo.get(d.grupo)[0] === d) insignias.push(pecaDoGrupo(porGrupo.get(d.grupo)));
  }

  res.json({
    publico: sou,
    conquistadas: degraus.filter(i => i.conquistada).length,
    total: degraus.length,
    xp: retrato.total,
    nivel: retrato.nivel,
    insignias
  });
});


/* ── PATCH /meu-perfil ── só nome e foto. */

const NOME_MAX = 100;

/* Foto: https:// ou data:image (até 120 KB; a tela reduz para 192×192). */
const URL_MAX = 500;
const FOTO_MAX = 120 * 1024;
const FOTO_EMBUTIDA = /^data:image\/(jpeg|png|webp);base64,[A-Za-z0-9+/]+=*$/;

rotas.patch('/meu-perfil', async (req, res) => {
  const mudancas = {};

  if (req.body?.nome !== undefined) {
    const nome = String(req.body.nome).trim().replace(/\s+/g, ' ');

    if (nome.length < 2 || nome.length > NOME_MAX) {
      return res.status(400).json({ message: `O nome precisa ter de 2 a ${NOME_MAX} letras.` });
    }
    mudancas.nome = nome;
  }

  if (req.body?.avatar_url !== undefined) {
    const foto = String(req.body.avatar_url || '').trim();

    if (!foto) {
      mudancas.avatar_url = null;          // tirar a foto é uma escolha válida

    } else if (foto.startsWith('data:')) {
      // Só png, jpeg ou webp em base64 (svg fica de fora: pode ter script).
      if (foto.length > FOTO_MAX) {
        return res.status(400).json({ message: 'Essa imagem é pesada demais. Tente outra.' });
      }
      if (!FOTO_EMBUTIDA.test(foto)) {
        return res.status(400).json({ message: 'Esse arquivo não parece uma imagem JPEG, PNG ou WEBP.' });
      }
      mudancas.avatar_url = foto;

    } else if (foto.length > URL_MAX) {
      return res.status(400).json({ message: 'O endereço da imagem é longo demais.' });

    } else if (!/^https:\/\//i.test(foto)) {
      // Só https.
      return res.status(400).json({ message: 'O endereço da imagem precisa começar com https://' });

    } else {
      mudancas.avatar_url = foto;
    }
  }

  if (!Object.keys(mudancas).length) {
    return res.status(400).json({ message: 'Nada para mudar.' });
  }

  const r = await admin
    .from('usuarios')
    .update(mudancas)
    .eq('id', req.usuario.id)
    .select('id, nome, tipo, idade, avatar_url')
    .single();

  if (r.error) {
    // Banco sem a coluna avatar_url.
    if (/avatar_url/.test(r.error.message || '')) {
      console.warn('  ⚠ usuarios.avatar_url não existe neste banco.\n' +
                   '    Rode: alter table usuarios add column if not exists avatar_url text;');
      return falhou(res, 500, 'A foto de perfil ainda não está disponível neste banco.', r.error, 'PATCH /meu-perfil');
    }
    return falhou(res, 500, 'Não foi possível salvar seu perfil.', r.error, 'PATCH /meu-perfil');
  }

  res.json(r.data);
});

module.exports = rotas;
