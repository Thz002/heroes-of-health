/**
 * api.js — Heróis da Saúde
 * Camada de comunicação HTTP com o backend.
 * Expõe o objeto global `API`.
 */

const API = (() => {
  // ── Configuração ───────────────────────────
  const BASE_URL = (
    window.location.hostname === 'localhost' ||
    window.location.hostname === '127.0.0.1'
  )
    ? 'http://localhost:3000/api'
    : '/api';

  const DEFAULT_TIMEOUT = 12000; // ms

  // ── Helpers internos ───────────────────────
  function getToken() {
    return localStorage.getItem('herois_token') || '';
  }

  function buildHeaders(extra = {}) {
    const headers = { 'Content-Type': 'application/json', ...extra };
    const token = getToken();
    if (token) headers['Authorization'] = `Bearer ${token}`;
    return headers;
  }

  function buildError(status, message, data = null) {
    const err = new Error(message);
    err.status = status;
    err.data   = data;
    err.offline = status === 0;
    return err;
  }

  async function request(method, endpoint, body = null, options = {}) {
    const url = endpoint.startsWith('http') ? endpoint : `${BASE_URL}${endpoint}`;
    const controller = new AbortController();
    const timeoutId = setTimeout(
      () => controller.abort(),
      options.timeout ?? DEFAULT_TIMEOUT
    );

    const init = {
      method,
      headers: buildHeaders(options.headers),
      signal: controller.signal,
    };

    if (body !== null) {
      init.body = JSON.stringify(body);
    }

    try {
      const res = await fetch(url, init);
      clearTimeout(timeoutId);

      // Sem conteúdo (204)
      if (res.status === 204) return null;

      let data;
      try { data = await res.json(); } catch (_) { data = null; }

      if (!res.ok) {
        throw buildError(
          res.status,
          data?.message ?? `Erro ${res.status}`,
          data
        );
      }

      return data;
    } catch (err) {
      clearTimeout(timeoutId);

      if (err.name === 'AbortError') {
        throw buildError(0, 'A requisição demorou muito. Verifique sua conexão.');
      }
      if (err.status) throw err; // já formatado

      // Sem internet / CORS / servidor offline
      const offlineErr = buildError(0, 'Sem conexão com o servidor.');
      offlineErr.offline = true;
      throw offlineErr;
    }
  }

  // ── Métodos públicos ───────────────────────
  function get(endpoint, options = {}) {
    return request('GET', endpoint, null, options);
  }

  function post(endpoint, body, options = {}) {
    return request('POST', endpoint, body, options);
  }

  function put(endpoint, body, options = {}) {
    return request('PUT', endpoint, body, options);
  }

  function patch(endpoint, body, options = {}) {
    return request('PATCH', endpoint, body, options);
  }

  function del(endpoint, options = {}) {
    return request('DELETE', endpoint, null, options);
  }

  // ── Endpoints do jogo ──────────────────────

  /** Busca todos os pontos de saúde no mapa */
  async function getHealthPoints() {
    try {
      return await get('/health-points');
    } catch (_) {
      // dados mock para modo offline
      return MOCK.healthPoints;
    }
  }

  /** Busca missões disponíveis para o usuário */
  async function getMissions(userId) {
    try {
      return await get(`/missions?userId=${userId}`);
    } catch (_) {
      return MOCK.missions;
    }
  }

  /** Envia resposta de quiz */
  async function submitQuizAnswer(userId, questionId, answerId) {
    try {
      return await post('/quiz/answer', { userId, questionId, answerId });
    } catch (_) {
      // fallback local — valida na camada de quiz
      return null;
    }
  }

  /** Atualiza XP e nível do usuário */
  async function updateUserXP(userId, xpGained) {
    try {
      return await patch(`/users/${userId}/xp`, { xp: xpGained });
    } catch (_) {
      // atualiza local
      const stored = localStorage.getItem('herois_user');
      if (stored) {
        const user = JSON.parse(stored);
        user.xp = (user.xp || 0) + xpGained;
        user.level = Math.floor(user.xp / 100) + 1;
        localStorage.setItem('herois_user', JSON.stringify(user));
        return user;
      }
      return null;
    }
  }

  /** Busca ranking de jogadores */
  async function getRanking(limit = 10) {
    try {
      return await get(`/ranking?limit=${limit}`);
    } catch (_) {
      return MOCK.ranking;
    }
  }

  /** Busca perguntas do quiz por categoria */
  async function getQuizQuestions(category = 'geral', limit = 5) {
    try {
      return await get(`/quiz/questions?category=${category}&limit=${limit}`);
    } catch (_) {
      return MOCK.questions.filter(q => category === 'geral' || q.category === category).slice(0, limit);
    }
  }

  // ── Escolas e Turmas ───────────────────────
  //
  // Estas quatro funções falam DIRETO com o Supabase, e não com o servidor
  // REST das funções acima (que ainda não existe).
  //
  // Repare que elas NÃO caem nos dados de mentira quando dá erro. Isso é de
  // propósito: se o banco falhar, você precisa VER o erro. Um fallback aqui
  // faria toda falha parecer sucesso, que é o pior tipo de bug para achar.

  /** true quando o supabase.js foi carregado antes deste arquivo */
  function temSupabase() {
    return typeof SUPA !== 'undefined' && SUPA !== null;
  }

  /** Lista todas as escolas cadastradas, para preencher a lista suspensa */
  async function getEscolas() {
    if (!temSupabase()) return MOCK.escolas;

    const { data, error } = await SUPA
      .from('escolas')
      .select('id, nome')
      .order('nome');

    if (error) throw buildError(500, error.message, error);
    return data;
  }

  /**
   * Lista as turmas de UMA escola. É o segundo passo da cascata: o aluno
   * escolhe a escola e só então as turmas dela são carregadas.
   */
  async function getTurmasPorEscola(escolaId) {
    if (!escolaId) return [];
    if (!temSupabase()) {
      return MOCK.turmas.filter(t => String(t.escola_id) === String(escolaId));
    }

    const { data, error } = await SUPA
      .from('turmas')
      .select('id, nome')
      .eq('escola_id', escolaId)
      .order('nome');

    if (error) throw buildError(500, error.message, error);
    return data;
  }

  /**
   * Descobre a turma a partir do código curto (ex: '7B-K3M9').
   * Devolve null quando o código não existe.
   */
  async function getTurmaPorCodigo(codigo) {
    const limpo = String(codigo || '').trim().toUpperCase();
    if (!limpo) return null;

    if (!temSupabase()) {
      const t = MOCK.turmas.find(x => x.codigo === limpo);
      if (!t) return null;
      const e = MOCK.escolas.find(x => x.id === t.escola_id);
      return { ...t, escola_nome: e ? e.nome : '' };
    }

    // "escolas ( nome )" traz junto o nome da escola dona da turma,
    // numa consulta só, para poder mostrar "7º Ano B — Colégio Santa Maria".
    const { data, error } = await SUPA
      .from('turmas')
      .select('id, nome, escola_id, escolas ( nome )')
      .eq('codigo', limpo)
      .maybeSingle();

    if (error) throw buildError(500, error.message, error);
    if (!data) return null;

    return {
      id: data.id,
      nome: data.nome,
      escola_id: data.escola_id,
      escola_nome: data.escolas ? data.escolas.nome : ''
    };
  }

  /** Cria uma escola nova. Exige estar logado (ver regras de segurança do banco). */
  async function criarEscola(nome) {
    const limpo = String(nome || '').trim();
    if (!temSupabase()) throw buildError(0, 'Supabase não está carregado.');

    const { data, error } = await SUPA
      .from('escolas')
      .insert({ nome: limpo })
      .select('id, nome')
      .single();

    if (error) throw buildError(500, error.message, error);
    return data;
  }

  // ── Dados mock (modo offline) ──────────────
  const MOCK = {
    escolas: [
      { id: 1, nome: 'Colégio Santa Maria' },
      { id: 2, nome: 'E. E. Professor Aníbal Machado' },
      { id: 3, nome: 'PUC Minas — Coração Eucarístico' },
    ],

    turmas: [
      { id: 1, escola_id: 1, nome: '6º Ano A',              codigo: '6A-P2LT' },
      { id: 2, escola_id: 1, nome: '7º Ano B',              codigo: '7B-K3M9' },
      { id: 3, escola_id: 2, nome: '8º Ano C',              codigo: '8C-W7QX' },
      { id: 4, escola_id: 3, nome: '1º Ano — Ensino Médio', codigo: '1EM-Z4RB' },
    ],

    healthPoints: [
      { id: 1, name: 'UBS Centro',          lat: -23.5505, lng: -46.6333, type: 'ubs',      xp: 30 },
      { id: 2, name: 'Hospital das Clínicas', lat: -23.5576, lng: -46.6709, type: 'hospital', xp: 80 },
      { id: 3, name: 'Farmácia Popular',     lat: -23.5489, lng: -46.6388, type: 'farmacia', xp: 20 },
      { id: 4, name: 'CAPS Norte',           lat: -23.5202, lng: -46.6299, type: 'caps',     xp: 50 },
      { id: 5, name: 'Pronto Socorro Leste', lat: -23.5678, lng: -46.5899, type: 'ps',       xp: 60 },
    ],

    missions: [
      { id: 1, title: 'Primeiros Socorros',   description: 'Aprenda RCP e salvamento básico.',     xp: 100, category: 'emergencia', completed: false },
      { id: 2, title: 'Nutrição Saudável',    description: 'Identifique grupos alimentares.',        xp: 80,  category: 'nutricao',   completed: false },
      { id: 3, title: 'Higiene Pessoal',      description: 'Práticas de saúde diárias.',            xp: 60,  category: 'higiene',     completed: true  },
      { id: 4, title: 'Doenças Infecciosas',  description: 'Como prevenir e reconhecer infecções.', xp: 120, category: 'doencas',    completed: false },
    ],

    ranking: [
      { position: 1, name: 'Ana Clara',    xp: 1840, level: 19 },
      { position: 2, name: 'Bruno Melo',   xp: 1620, level: 17 },
      { position: 3, name: 'Carla Souza',  xp: 1490, level: 15 },
      { position: 4, name: 'Diego Alves',  xp: 1320, level: 14 },
      { position: 5, name: 'Elena Costa',  xp: 1200, level: 13 },
    ],

    questions: [
      {
        id: 1, category: 'geral',
        question: 'Qual o primeiro passo no atendimento de uma vítima inconsciente?',
        options: [
          { id: 'a', text: 'Verificar se o local é seguro' },
          { id: 'b', text: 'Iniciar massagem cardíaca imediatamente' },
          { id: 'c', text: 'Ligar para familiares' },
          { id: 'd', text: 'Dar água à vítima' },
        ],
        correct: 'a',
        explanation: 'A segurança do socorrista é prioridade. Verifique o ambiente antes de se aproximar.',
        xp: 20,
      },
      {
        id: 2, category: 'nutricao',
        question: 'Quantos copos de água são recomendados por dia para um adulto?',
        options: [
          { id: 'a', text: '4 a 5 copos' },
          { id: 'b', text: '6 a 8 copos' },
          { id: 'c', text: '8 a 10 copos' },
          { id: 'd', text: 'Mais de 12 copos' },
        ],
        correct: 'c',
        explanation: 'A OMS recomenda entre 8 e 10 copos (2 a 2,5 litros) de água por dia para adultos saudáveis.',
        xp: 15,
      },
      {
        id: 3, category: 'geral',
        question: 'Qual dessas doenças é transmitida pelo mosquito Aedes aegypti?',
        options: [
          { id: 'a', text: 'Gripe' },
          { id: 'b', text: 'Cólera' },
          { id: 'c', text: 'Dengue' },
          { id: 'd', text: 'Tuberculose' },
        ],
        correct: 'c',
        explanation: 'O Aedes aegypti transmite dengue, zika e chikungunya. Elimine água parada para prevenir.',
        xp: 20,
      },
      {
        id: 4, category: 'higiene',
        question: 'Quantos segundos deve durar a lavagem correta das mãos?',
        options: [
          { id: 'a', text: '5 segundos' },
          { id: 'b', text: '10 segundos' },
          { id: 'c', text: '20 a 30 segundos' },
          { id: 'd', text: '60 segundos' },
        ],
        correct: 'c',
        explanation: 'A lavagem deve durar de 20 a 30 segundos, cobrindo palmas, dorso, dedos e unhas.',
        xp: 15,
      },
      {
        id: 5, category: 'emergencia',
        question: 'O que fazer em caso de engasgo em adulto consciente?',
        options: [
          { id: 'a', text: 'Dar tapas nas costas e aplicar manobra de Heimlich' },
          { id: 'b', text: 'Oferecer água imediatamente' },
          { id: 'c', text: 'Pedir para a pessoa tossir e não intervir' },
          { id: 'd', text: 'Deitar a pessoa no chão' },
        ],
        correct: 'a',
        explanation: 'A manobra de Heimlich (compressões abdominais) associada a tapas nas costas é o protocolo correto.',
        xp: 25,
      },
    ],
  };

  // ── API pública ─────────────────────────────
  return {
    get,
    post,
    put,
    patch,
    delete: del,

    // Endpoints
    getHealthPoints,
    getMissions,
    submitQuizAnswer,
    updateUserXP,
    getRanking,
    getQuizQuestions,

    // Escolas e turmas
    getEscolas,
    getTurmasPorEscola,
    getTurmaPorCodigo,
    criarEscola,

    // Dados mock acessíveis externamente
    MOCK,
  };
})();
