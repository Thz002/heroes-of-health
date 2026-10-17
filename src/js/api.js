/** api.js — global `API`. Fala direto com o Supabase só no que é público;
    o resto (regras do jogo) vai pelo servidor Express. */

const API = (() => {
  // Mesma origem quando servido pelo Express; localhost:3000 no fallback por file://.
  const BASE_URL = (window.location.protocol === 'file:')
    ? 'http://localhost:3000/api'
    : '/api';

  const DEFAULT_TIMEOUT = 12000; // ms

  // ── Helpers internos ───────────────────────
  function buildError(status, message, data = null) {
    const err = new Error(message);
    err.status = status;
    err.data   = data;
    err.offline = status === 0;
    return err;
  }

  /** Chama o servidor com o token. Sem fallback: erro aparece como erro. */
  async function request(method, endpoint, body = null, options = {}) {
    const url = endpoint.startsWith('http') ? endpoint : `${BASE_URL}${endpoint}`;

    const headers = { 'Content-Type': 'application/json', ...(options.headers || {}) };

    const token = (typeof AUTH !== 'undefined') ? await AUTH.tokenAtual() : '';
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const controller = new AbortController();
    const timeoutId = setTimeout(
      () => controller.abort(),
      options.timeout ?? DEFAULT_TIMEOUT
    );

    const init = { method, headers, signal: controller.signal };
    if (body !== null) init.body = JSON.stringify(body);

    try {
      const res = await fetch(url, init);
      clearTimeout(timeoutId);

      if (res.status === 204) return null;

      let data;
      try { data = await res.json(); } catch (_) { data = null; }

      if (!res.ok) {
        throw buildError(res.status, data?.message ?? `Erro ${res.status}`, data);
      }
      return data;
    } catch (err) {
      clearTimeout(timeoutId);

      if (err.name === 'AbortError') {
        throw buildError(0, 'A requisição demorou muito. Verifique sua conexão.');
      }
      if (err.status) throw err;

      throw buildError(0, 'O servidor do jogo não está respondendo. Ele foi iniciado? (npm run dev)');
    }
  }

  const get   = (e, o = {})    => request('GET',    e, null, o);
  const post  = (e, b, o = {}) => request('POST',   e, b,    o);
  const patch = (e, b, o = {}) => request('PATCH',  e, b,    o);
  const del   = (e, o = {})    => request('DELETE', e, null, o);

  // ── Escolas e turmas (direto no Supabase, sem login) ──

  /** true quando o supabase.js foi carregado antes deste arquivo */
  function temSupabase() {
    return typeof SUPA !== 'undefined' && SUPA !== null;
  }



  /** Turma pelo código (RPC). Devolve null se não existir. */
  async function getTurmaPorCodigo(codigo) {
    const limpo = String(codigo || '').trim().toUpperCase();
    if (!limpo) return null;
    if (!temSupabase()) throw buildError(0, 'Supabase não está carregado.');

    const { data, error } = await SUPA
      .rpc('buscar_turma_por_codigo', { p_codigo: limpo });

    if (error) throw buildError(500, error.message, error);
    if (!data || data.length === 0) return null;

    return {
      id: data[0].id,
      nome: data[0].nome,
      escola_id: data[0].escola_id,
      escola_nome: data[0].escola_nome || ''
    };
  }

  // ── O jogo (pelo servidor) ──

  /** Os pontos do bairro que aparecem no mapa */
  const getCenarios = () => get('/cenarios');

  /** Envia a resposta (quizId obrigatório). Devolve { acertou, explicacao, pontos }, nunca a letra certa. */
  const responder = (questaoId, resposta, quizId) =>
    post('/responder', { questao_id: questaoId, resposta, quiz_id: quizId });

  /** Missões ativas: { quizzes, total_pendente }. */
  const getMeuMapa = () => get('/meu-mapa');

  /** As tarefas que o professor passou para a turma deste aluno */
  const getMeusQuizzes = () => get('/meus-quizzes');

  /** As questões congeladas de um quiz — mesma ordem para a turma toda */
  const getQuestoesDoQuiz = (quizId) => get(`/quizzes/${quizId}/questoes`);

  /** As 8 barras do aluno. */
  const getMeuProgresso = () => get('/meu-progresso');

  /** Cabeçalho de "Meu progresso": { turma, posicao, estatisticas }. */
  const getMeuResumo = () => get('/meu-resumo');

  /** Turma do aluno: { turma, colegas, posicao }. */
  const getMinhaTurma = () => get('/minha-turma');

  /** Entra numa turma (só quem não tem; senão 409). */
  const entrarNaTurma = (turmaId) => post('/minha-turma', { turma_id: turmaId });

  /** Marca a presença de hoje. Devolve XP, nível, sequência e insígnias novas. */
  const marcarPresenca = () => post('/presenca');

  /** A estante inteira — o que já foi conquistado e o que falta */
  const getMinhaEstante = () => get('/minha-estante');

  /** Segredos do mapa: { descobertas: [{ codigo, nome, imagem, conquistada }] }. */
  const getMinhasDescobertas = () => get('/minhas-descobertas');

  /** Registra um segredo achado. Devolve { insignias_novas, xp?, nivel? }. */
  const descobrir = (codigo) => post('/descobrir', { codigo });

  /** Muda nome e foto. */
  const salvarMeuPerfil = ({ nome, avatar_url }) => {
    const mudancas = {};
    if (nome !== undefined) mudancas.nome = nome;
    if (avatar_url !== undefined) mudancas.avatar_url = avatar_url;
    return patch('/meu-perfil', mudancas);
  };

  // ── Professor ──────────────────────────────
  const getMinhasTurmas = () => get('/professor/turmas');
  /** Cria um quiz: modo 'auto' (sorteio) ou 'manual' (questao_ids). */
  const criarQuiz = ({ turma_id, titulo, descricao, modo, cenarios, areas, qtd_questoes, questao_ids, tempo_limite_segundos }) =>
    post('/professor/quizzes', {
      turma_id, titulo, descricao, modo, cenarios, areas, qtd_questoes, questao_ids, tempo_limite_segundos
    });

  /** Questões para o quiz: origem 'sistema' (sem gabarito) ou 'minhas'; filtros opcionais. */
  const getQuestoesProfessor = ({ origem = 'sistema', nivel, cenarios = [], areas = [] } = {}) => {
    const p = new URLSearchParams({ origem });
    if (nivel) p.set('nivel', nivel);
    if (cenarios.length) p.set('cenarios', cenarios.join(','));
    if (areas.length) p.set('areas', areas.join(','));
    return get(`/professor/questoes?${p}`);
  };

  /** Cria uma questão do professor (o dono vem do login). */
  const criarQuestao = ({ cenario, nivel_etario, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao, areas }) =>
    post('/professor/questoes', {
      cenario, nivel_etario, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao, areas
    });

  /** Só apaga a própria, e só se nenhum aluno respondeu nem está em quiz. */
  const excluirQuestao = (questaoId) => del(`/professor/questoes/${questaoId}`);

  const getQuizzesDaTurma = (turmaId) => get(`/professor/quizzes?turma_id=${turmaId}`);

  /** Histórico de quizzes do professor, com nome e cor da turma. */
  const getQuizzesCriados = () => get('/professor/quizzes');

  /** Turmas ordenadas por desempenho. */
  const getRankingDasTurmas = () => get('/professor/ranking');

  const excluirQuiz = (quizId) => del(`/professor/quizzes/${quizId}`);
  const criarTurma      = ({ nome, cor, ano_escolar }) =>
    post('/professor/turmas', { nome, cor, ano_escolar });
  const getAlunosDaTurma = (turmaId) => get(`/professor/turmas/${turmaId}/alunos`);

  /** Muda nome, cor e/ou ano de uma turma. */
  const editarTurma = (turmaId, mudancas) =>
    patch(`/professor/turmas/${turmaId}`, mudancas);

  /** Desfaz uma turma (os alunos ficam sem turma). */
  const excluirTurma = (turmaId) => del(`/professor/turmas/${turmaId}`);

  // ── Esqueci minha senha (pelo servidor, sem token) ──

  /** Confere formato e domínio do e-mail. Devolve { ok, motivo }. */
  async function conferirEmail(email) {
    return post('/auth/conferir-email', { email });
  }

  /** Pede o envio de um código de 5 caracteres para o e-mail. */
  async function pedirCodigoDeSenha(email) {
    return post('/auth/recuperar', { email });
  }

  /** Confere o código. Devolve { ticket } — o passe para a tela seguinte. */
  async function conferirCodigoDeSenha(email, codigo) {
    return post('/auth/conferir-codigo', { email, codigo });
  }

  /** Grava a nova senha. Só funciona com o ticket que a conferência deu. */
  async function trocarSenhaComTicket(email, ticket, senha) {
    return post('/auth/nova-senha', { email, ticket, senha });
  }

  // ── Painel do admin (pelo servidor) ──

  const adminResumo      = ()   => get('/admin/resumo');
  const adminProfessores = ()   => get('/admin/professores');
  const adminPatentes    = ()   => get('/admin/patentes');

  /** Busca por nome, por e-mail (com @) ou pelo id que o Supabase mostra. */
  const adminUsuarios = (q = '', tipo = '') => {
    const p = new URLSearchParams();
    if (q) p.set('q', q);
    if (tipo) p.set('tipo', tipo);
    const cauda = p.toString();
    return get('/admin/usuarios' + (cauda ? `?${cauda}` : ''));
  };

  const adminUsuario        = (id)         => get(`/admin/usuarios/${id}`);
  const adminAjustarXp      = (id, pontos, motivo) => post(`/admin/usuarios/${id}/xp`, { pontos, motivo });
  const adminDefinirNivel   = (id, nivel)  => post(`/admin/usuarios/${id}/nivel`, { nivel });
  const adminAlterar        = (id, campos) => patch(`/admin/usuarios/${id}`, campos);
  const adminRecuperarSenha = (id)         => post(`/admin/usuarios/${id}/recuperar-senha`, {});
  const adminApagar         = (id)         => del(`/admin/usuarios/${id}`);
  const adminDefinirSenha   = (id, senha)  => post(`/admin/usuarios/${id}/senha`, { senha });
  const adminSalvarPatentes = (tipo, faixas) => request('PUT', '/admin/patentes', { tipo, faixas });

  return {
    get, post, patch, delete: del,

    // Painel da equipe (ADMIN)
    adminResumo, adminProfessores, adminUsuarios, adminUsuario,
    adminAjustarXp, adminDefinirNivel, adminAlterar,
    adminRecuperarSenha, adminDefinirSenha, adminApagar,
    adminPatentes, adminSalvarPatentes,

    // Escolas e turmas (direto no Supabase)
    getTurmaPorCodigo,

    // Recuperação de senha (pelo servidor, sem login)
    conferirEmail,
    pedirCodigoDeSenha,
    conferirCodigoDeSenha,
    trocarSenhaComTicket,

    // Jogo (pelo servidor)
    getCenarios,
    responder,
    getMeuProgresso,
    getMeuResumo,
    getMinhaTurma,
    entrarNaTurma,
    marcarPresenca,
    getMinhaEstante,
    getMinhasDescobertas,
    descobrir,
    salvarMeuPerfil,
    getMeuMapa,
    getMeusQuizzes,
    getQuestoesDoQuiz,

    // Professor (pelo servidor)
    getMinhasTurmas,
    criarTurma,
    criarQuiz,
    getQuestoesProfessor,
    criarQuestao,
    excluirQuestao,
    getQuizzesDaTurma,
    getQuizzesCriados,
    getRankingDasTurmas,
    excluirQuiz,
    editarTurma,
    getAlunosDaTurma,
    excluirTurma,
  };
})();