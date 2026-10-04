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
const { falhou } = require('../erros');
const { lerTudo } = require('../lerTudo');
const PROG = require('../progressao');

const { XP_POR_QUESTAO, acertosUnicosPorAluno } = PROG;

const rotas = express.Router();
rotas.use(autenticar);

/**
 * Ponte enquanto a coluna `descricao` de quizzes_professores não existir
 * em todo banco. Roda a consulta; se o Postgres reclamar dessa coluna,
 * roda de novo sem ela.
 *
 * É temporário. Some quando todos os bancos rodarem:
 *   alter table quizzes_professores add column if not exists descricao varchar(200);
 *
 * A descrição é a frase que o aluno lê no card — perder a frase é bem
 * menos grave do que a tela inteira de tarefas parar de carregar.
 */
async function comOuSemDescricao(montar) {
  const r = await montar(true);
  if (r.error && /descricao/.test(r.error.message || '')) return montar(false);
  return r;
}

// ── Cenários do mapa ─────────────────────────────────────────────────
//
// Cada cenário vem com a lista de ÁREAS que ele alimenta (Saúde,
// Vacinação, ...). É o que o painel lateral do mapa usa para desenhar,
// no hover, as barras de progresso do aluno naquele lugar.
//
// A lista NÃO é filtrada pela idade de quem pergunta: aqui a pergunta é
// "o que este lugar ensina?", e não "o que eu posso jogar agora?".
// Filtrar por faixa etária deixaria o painel vazio nos lugares cujo
// conteúdo ainda só existe para outra idade.
rotas.get('/cenarios', async (req, res) => {
  const cenarios = await admin
    .from('cenarios')
    .select('id, slug, nome, descricao')
    .order('id');

  if (cenarios.error) {
    return falhou(res, 500, 'Não foi possível carregar o mapa.', cenarios.error, 'GET /cenarios');
  }

  // Três consultas soltas em vez de um join aninhado: questoes_areas não
  // tem ligação direta com cenarios — a ponte entre as duas é questoes.
  // As duas primeiras passam de mil linhas fácil; daí o lerTudo.
  const [questoes, vinculos, areas] = await Promise.all([
    lerTudo(() => admin.from('questoes').select('id, cenario_id').order('id')),
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

  // Sai na ordem canônica das 8 barras (areas.ordem), não na ordem em
  // que o conteúdo foi cadastrado — assim Saúde vem sempre antes de
  // Felicidade, em qualquer lugar do mapa.
  res.json((cenarios.data || []).map(c => ({
    ...c,
    areas: [...(areasPorCenario.get(c.id) || [])]
      .sort((a, b) => (ordemDaArea.get(a) ?? 99) - (ordemDaArea.get(b) ?? 99))
  })));
});

// ── Responder uma questão de um quiz ─────────────────────────────────
//
// Só existe resposta DENTRO de um quiz do professor. Quando havia
// exploração livre pelo mapa, qualquer questão do banco podia ser
// respondida; sem ela, aceitar uma questão avulsa deixaria o aluno
// pontuar, pelo console, em perguntas que ninguém passou para ele —
// bastava tentar as quatro letras em cada uma.
rotas.post('/responder', async (req, res) => {
  const questaoId = Number(req.body?.questao_id);
  const resposta  = String(req.body?.resposta || '').trim().toUpperCase();

  if (!questaoId || !['A', 'B', 'C', 'D'].includes(resposta)) {
    return res.status(400).json({ message: 'Resposta inválida.' });
  }

  const quizId = Number(req.body?.quiz_id);
  if (!Number.isInteger(quizId) || quizId <= 0) {
    return res.status(400).json({ message: 'Responda pelas missões do seu professor.' });
  }

  // O quiz tem de ser da turma de quem responde (ou do professor que o
  // criou, testando a própria tarefa), e a questão tem de estar nele.
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

  const questao = await admin
    .from('questoes')
    .select('id, resposta_correta, explicacao')
    .eq('id', questaoId)
    .maybeSingle();

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

  // Terminou o quiz com esta resposta? É o marco que premia os dois.
  const conclusao = acertou ? await PROG.registrarConclusao(req.usuario, quizId) : null;

  // O XP e o nível DEPOIS desta resposta, para a barra subir na hora em
  // vez de só na próxima troca de página. É o pedido de "progressão
  // notável": o número tem de se mexer no momento do acerto.
  const retrato = await PROG.xpDoAluno(req.usuario.id);

  const novas = retrato.erro ? [] : await PROG.conquistar(
    req.usuario.id, 'ALUNO',
    await PROG.medirAluno(req.usuario.id, req.usuario.turma_id, retrato));

  const xp = (retrato.total || 0) + novas.reduce((s, i) => s + (i.xp || 0), 0);

  // O que volta para a tela. Mesmo errando, a pessoa recebe a explicação
  // — mas NUNCA a letra certa: a ideia é que ela tente de novo com o
  // conteúdo em mãos, e não que copie a resposta.
  res.json({
    acertou,
    explicacao: questao.data.explicacao,
    pontos: pontosGanhos,
    conclusao,
    xp,
    nivel: PROG.nivelDoXp(xp, 'ALUNO'),
    insignias_novas: novas.map(i => ({
      codigo: i.codigo, nome: i.nome, descricao: i.descricao, xp: i.xp, imagem: i.imagem
    }))
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
    .select('id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d')
    .in('id', ids);

  if (questoes.error) {
    return falhou(res, 500, 'Não foi possível carregar as questões.', questoes.error, 'GET /quizzes/:id/questoes');
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


// ── As missões ativas deste aluno ────────────────────────────────────
//
// "Missão" é o nome que o aluno vê para o quiz que o professor passou.
// Esta rota devolve os quizzes da turma que ainda têm pergunta para
// responder — é a lista embaixo do mapa, e é por ela que o mapa sabe
// quais lugares têm o botão "Jogar" aceso.
//
// Um quiz guarda uma LISTA de cenários, então ele não mora num lugar
// só: aparece em cada ponto que cobre. Responder num deles conta nos
// outros — é a mesma tarefa vista de janelas diferentes.
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

  // Conta QUESTÕES acertadas, não acertos: a mesma questão acertada duas
  // vezes (numa segunda rodada) não pode contar em dobro.
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


// ── As 8 barras do aluno ─────────────────────────────────────────────
rotas.get('/meu-progresso', async (req, res) => {
  const { data, error } = await admin
    .from('areas')
    .select('nome, ordem, meta')
    .order('ordem');

  if (error) return falhou(res, 500, 'Não foi possível carregar seu progresso.', error, 'GET /meu-progresso');

  const progresso = await admin
    .from('progresso_areas')
    .select('area_nome, pontos, porcentagem')
    .eq('usuario_id', req.usuario.id);

  const porArea = new Map((progresso.data || []).map(p => [p.area_nome, p]));

  // Devolve sempre as 8, mesmo as que ainda estão zeradas, para a tela
  // poder desenhar todas as barras desde o primeiro acesso.
  // A meta vai junto para a tela poder mostrar "620 de 1400" em vez de
  // uma porcentagem solta. Meta 0 = área ainda sem conteúdo nenhum, e a
  // tela deve dizer isso em vez de desenhar uma barra eternamente vazia.
  res.json(data.map(a => ({
    area:        a.nome,
    pontos:      porArea.get(a.nome)?.pontos ?? 0,
    porcentagem: porArea.get(a.nome)?.porcentagem ?? 0,
    meta:        a.meta ?? 0,
    sem_conteudo: (a.meta ?? 0) <= 0
  })));
});

/* ═══════════════════════════════════════════════════════════════════
   O RESUMO DO ALUNO  —  GET /meu-resumo

   Tudo o que a tela "Meu progresso" mostra acima das barras: a turma em
   que a pessoa está, a posição dela entre os colegas, e os quatro
   números do topo.

   Por que numa rota só e não em quatro: os quatro números saem TODOS da
   mesma leitura de respostas_alunos. Buscar a mesma tabela quatro vezes
   para contar coisas diferentes dela seria quatro viagens ao banco para
   responder uma pergunta só — "como eu estou indo?".

   O XP e o nível NÃO são calculados aqui: vêm de server/progressao.js,
   que é o único lugar do projeto que sabe quanto cada coisa vale. Esta
   rota só pergunta e repassa.
   ═══════════════════════════════════════════════════════════════════ */

/**
 * A turma do aluno, quem mais está nela e em que lugar ele fica.
 *
 * Serve as duas rotas: /meu-resumo usa só a turma e a posição, e
 * /minha-turma usa a lista inteira. Ficava duplicado, e duplicado é
 * onde as duas telas começam a discordar sobre quem está em primeiro.
 *
 * Devolve { erro } quando o banco falhar, { turma: null } quando a
 * turma sumiu — são coisas diferentes e a rota trata cada uma.
 */
async function turmaComColegas(eu, turmaId) {
  const turma = await admin
    .from('turmas')
    .select('id, nome, cor, ano_escolar, escola_id, professor_id')
    .eq('id', turmaId)
    .maybeSingle();

  if (turma.error) return { erro: turma.error };
  if (!turma.data) return { turma: null, colegas: [], posicao: null };

  const [escola, professor, matriculados] = await Promise.all([
    admin.from('escolas').select('nome').eq('id', turma.data.escola_id).maybeSingle(),
    admin.from('usuarios').select('nome').eq('id', turma.data.professor_id).maybeSingle(),
    admin.from('usuarios').select('id, nome').eq('turma_id', turmaId).eq('tipo', 'ALUNO')
  ]);

  if (matriculados.error) return { erro: matriculados.error };

  const alunos = matriculados.data || [];

  const dados = {
    id: turma.data.id,
    nome: turma.data.nome,
    cor: turma.data.cor || null,
    ano_escolar: turma.data.ano_escolar || null,
    escola: escola.data?.nome || null,
    professor: professor.data?.nome || null,
    total_alunos: alunos.length
  };

  if (!alunos.length) return { turma: dados, colegas: [], posicao: null };

  const respostas = await lerTudo(() => admin
    .from('respostas_alunos')
    .select('usuario_id, questao_id')
    .eq('acertou', true)
    .in('usuario_id', alunos.map(a => a.id))
    .order('usuario_id').order('questao_id'));

  if (respostas.error) return { erro: respostas.error };

  const porAluno = acertosUnicosPorAluno(respostas.data);

  // O XP é a MESMA régua da tela de progresso: 10 por questão distinta
  // acertada. Se cada tela calculasse do seu jeito, o aluno veria dois
  // números diferentes para a mesma coisa e não confiaria em nenhum.
  const colegas = alunos.map(a => ({
    nome: a.nome,
    xp: (porAluno.get(a.id)?.size || 0) * XP_POR_QUESTAO,
    eu: a.id === eu
  })).sort((a, b) => b.xp - a.xp || a.nome.localeCompare(b.nome, 'pt-BR'));

  // Empate é a MESMA posição: dois alunos com o mesmo XP são os dois
  // segundos. Contar quantos estão à frente dá isso de graça.
  const meuXp = (porAluno.get(eu)?.size || 0) * XP_POR_QUESTAO;
  const naFrente = colegas.filter(c => !c.eu && c.xp > meuXp).length;

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

  // O professor também passa por aqui (a tela de perfil é a mesma), e o
  // XP dele NÃO sai de respostas_alunos — ele não responde pergunta
  // nenhuma. Sem este desvio, esta rota devolvia 0 XP para um professor
  // que a barra, pela /presenca, mostrava com 156: dois números para a
  // mesma coisa, que é o jeito mais rápido de ninguém confiar em nenhum.
  //
  // As respostas já estão lidas: passar a lista evita que o módulo de
  // progressão vá buscar a mesma coisa de novo.
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

    // O XP agora soma três fontes: questões, dias de presença e
    // insígnias. `de_questoes`/`de_dias`/`de_insignias` vão junto para a
    // tela poder explicar de onde veio, em vez de mostrar um total que
    // a pessoa não sabe como cresceu.
    xp: retrato.total,
    xp_de_questoes: retrato.de_questoes,
    xp_de_dias: retrato.de_dias,
    xp_de_insignias: retrato.de_insignias,
    xp_de_conclusoes: retrato.de_conclusoes,
    nivel: retrato.nivel,

    conclusoes: retrato.conclusoes,

    // Só o professor tem estes. Para o aluno vêm undefined e somem do
    // JSON — a tela dele não pergunta por eles.
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

    // Mesma conta do mapa: questões distintas acertadas dentro daquele
    // quiz. Acertar de novo numa segunda rodada não conta duas vezes.
    const prontas = new Map();
    for (const r of certas) {
      if (!r.quiz_id) continue;
      if (!prontas.has(r.quiz_id)) prontas.set(r.quiz_id, new Set());
      prontas.get(r.quiz_id).add(r.questao_id);
    }

    // Um quiz sem questão nenhuma não é missão: não entra nem como
    // pendente nem como concluída.
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

  // Repare que os COLEGAS ficam de fora daqui. Esta rota responde "como
  // eu estou indo?", e para isso "3º de 24" basta — quem são os outros
  // dois da frente é assunto da tela da turma, não desta.
  res.json({
    turma: daTurma.turma,
    posicao: daTurma.posicao,
    estatisticas
  });
});

/* ═══════════════════════════════════════════════════════════════════
   A TURMA DO ALUNO  —  GET /minha-turma

   O que o aluno vê sobre a turma dele: nome, ano, escola, professor, e
   quem mais está lá dentro.

   Por que não dá para reaproveitar turma.html (a tela do professor):
   aquela página pede `?id=` na URL e chama rotas de /professor, que
   recusam quem não é dono da turma. O aluno também não deve escolher
   turma por parâmetro de URL — a dele sai da conta, e só ela.

   O QUE ESTA ROTA NÃO DEVOLVE: taxa de acerto de colega. A lista sai
   por XP, que é um número que só sobe — dá para ficar em último e ainda
   assim ter "40 XP", que é algo que a pessoa conquistou. Uma coluna de
   "45% de acerto" ao lado do nome de uma criança de 8 anos, exposta
   para a turma toda, é outra coisa.
   ═══════════════════════════════════════════════════════════════════ */

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

/* ═══════════════════════════════════════════════════════════════════
   A PRESENÇA DO DIA  —  POST /presenca

   O prêmio diário precisava de um gatilho, e o login não serve: quem
   faz o login é o Supabase, direto do navegador, sem passar por aqui.
   Além disso quem fica dias com a aba aberta nunca "loga" de novo.

   Então o gatilho é a primeira vez que a pessoa aparece no servidor em
   cada sessão do navegador. O banco é que decide se vale prêmio: a
   chave (usuario_id, dia) recusa o segundo do mesmo dia. Chamar demais
   é inofensivo — e é por isso que o navegador pode chamar sem medo.

   É POST e não GET porque esta rota ESCREVE. Um GET que grava é a
   receita para o navegador repetir a chamada sozinho ao recarregar.
   ═══════════════════════════════════════════════════════════════════ */

rotas.post('/presenca', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo;

  const presenca = await PROG.marcarPresenca(eu);

  if (presenca.erro) {
    return falhou(res, 500, 'Não foi possível registrar sua entrada.', presenca.erro, 'POST /presenca');
  }

  // Depois de marcar, e não antes: o dia de hoje já tem de estar contado
  // quando a sequência for medida, senão a insígnia de 7 dias só sairia
  // na visita seguinte.
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

  // Uma insígnia dá XP, então o total mudou depois de conquistá-la. Sem
  // recontar, a tela comemoraria a insígnia e mostraria o XP de antes.
  const xp = retrato.total + novas.reduce((s, i) => s + (i.xp || 0), 0);

  res.json({
    ganhou_hoje: presenca.ganhou,
    pontos_do_dia: presenca.pontos,
    dia: presenca.dia,
    xp,
    nivel: PROG.nivelDoXp(xp, sou),
    streak_dias: retrato.streak_dias,
    dias_jogados: retrato.dias_jogados,
    insignias_novas: novas.map(i => ({
      codigo: i.codigo, nome: i.nome, descricao: i.descricao, xp: i.xp, imagem: i.imagem
    }))
  });
});


/* ═══════════════════════════════════════════════════════════════════
   A ESTANTE  —  GET /minha-estante

   Devolve o catálogo INTEIRO, não só o que a pessoa já tem. É o que
   transforma a prateleira vazia em objetivo: o aluno vê a silhueta da
   próxima insígnia e sabe que faltam 12 acertos para ela.

   O professor recebe a estante dele, que hoje está vazia porque as
   regras ainda não foram combinadas. A tela trata isso como estado
   normal — a estante existe, as peças é que não.
   ═══════════════════════════════════════════════════════════════════ */

rotas.get('/minha-estante', async (req, res) => {
  const eu = req.usuario.id;
  const sou = req.usuario.tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';

  // ouVazio: num banco que ainda não rodou o setup.sql novo, a estante
  // volta vazia em vez de dar erro. A tela já sabe desenhar prateleira
  // sem peça — é o estado do professor hoje.
  const [bruto1, bruto2] = await Promise.all([
    admin.from('insignias')
      .select('codigo, nome, descricao, regra, alvo, xp, imagem, ordem')
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

  const insignias = (catalogo.data || []).map(i => {
    const tenho = quando.has(i.codigo);
    const agora = medidas[i.regra] ?? 0;

    return {
      codigo: i.codigo,
      nome: i.nome,
      descricao: i.descricao,
      xp: i.xp,
      imagem: i.imagem || null,
      regra: i.regra,
      alvo: i.alvo,
      conquistada: tenho,
      conquistada_em: quando.get(i.codigo) || null,
      // Quanto falta, para a insígnia bloqueada virar objetivo e não
      // enigma. Nunca passa do alvo: "62 de 50" não faz sentido.
      progresso: Math.min(agora, i.alvo),
      porcentagem: Math.min(100, Math.round((agora / i.alvo) * 100))
    };
  });

  res.json({
    publico: sou,
    conquistadas: insignias.filter(i => i.conquistada).length,
    total: insignias.length,
    xp: retrato.total,
    nivel: retrato.nivel,
    insignias
  });
});


/* ═══════════════════════════════════════════════════════════════════
   EDITAR O PRÓPRIO PERFIL  —  PATCH /meu-perfil

   Só nome e foto. `tipo`, `idade` e `turma_id` ficam de fora de
   propósito: os três decidem o que a pessoa VÊ e PODE no jogo — a idade
   escolhe as questões, o tipo abre o painel do professor, a turma traz
   as tarefas. Deixá-los editáveis aqui seria entregar as três chaves
   para quem está do lado de fora.
   ═══════════════════════════════════════════════════════════════════ */

const NOME_MAX = 100;

/* A foto chega de dois jeitos, e os dois são aceitos:

     https://...              um endereço que a pessoa colou
     data:image/jpeg;base64,  a imagem inteira, escolhida do computador

   O segundo existe para não depender de o aluno ter a foto publicada em
   algum lugar da internet — e para não precisar de bucket no Supabase
   Storage, que é infraestrutura a mais para um círculo de 34 pixels.

   O limite de 120 KB não é chute: a tela reduz a imagem para 192×192
   antes de enviar, o que dá uns 15 KB em base64. 120 KB aceita uma foto
   bem mais pesada que isso e ainda assim impede que alguém grave um
   arquivo de megabytes numa coluna lida em toda navegação. */
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
      // Imagem escolhida do computador, já reduzida pelo navegador.
      //
      // A expressão confere o tipo E o alfabeto do base64. Isso importa:
      // "data:image/svg+xml" é tecnicamente uma imagem e pode conter
      // <script> — fora da lista de propósito. Os três formatos aceitos
      // são todos de pixel, sem código dentro.
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
      // Só https: um endereço http numa página https não carrega, e
      // javascript: dentro de um src é porta de entrada para script de
      // terceiro na tela de todo mundo que vir o avatar.
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
    // A coluna da foto pode não existir ainda no banco de quem não rodou
    // o setup.sql mais novo. Dizer isso é melhor do que "erro interno".
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
