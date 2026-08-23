/**
 * api.js — Heróis da Saúde
 *
 * A camada de dados da tela. Expõe o objeto global `API`.
 *
 * Ela fala com DOIS lugares diferentes, e saber qual é qual importa:
 *
 *   1. DIRETO COM O SUPABASE — só o que é público ou inofensivo:
 *      a lista de escolas e de turmas, que o aluno precisa ver ANTES de
 *      ter conta.
 *
 *   2. COM O SERVIDOR EXPRESS — tudo que envolve regra de jogo:
 *      corrigir resposta, pontuar, painel do professor. Essas decisões
 *      não podem acontecer aqui, porque tudo neste arquivo está ao
 *      alcance de quem abrir o console do navegador.
 *
 * Depende de supabase.js, carregado antes (objetos SUPA e AUTH).
 */

const API = (() => {
  // ── Configuração ───────────────────────────
  //
  // Quando a página é servida pelo próprio Express (http://localhost:3000/pages/...
  // ou pelo IP da máquina na rede local), a API está na mesma origem — um
  // caminho relativo funciona em qualquer host, sem hardcoded.
  //
  // O fallback fixo em localhost:3000 só entra em jogo se a página ainda
  // for aberta direto por file:// (Origin: null), onde não existe origem
  // própria para montar um caminho relativo.
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

  /**
   * Chama o servidor Express, já com o crachá da sessão.
   *
   * Repare que NÃO existe fallback para dado de mentira aqui. É de
   * propósito: se o servidor estiver fora do ar, quem chamou precisa
   * VER o erro. Um fallback faria toda falha parecer sucesso, que é o
   * pior tipo de bug para achar.
   */
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

  // =====================================================================
  //  ESCOLAS E TURMAS — direto com o Supabase
  //
  //  Precisam funcionar SEM conta: o aluno escolhe a escola antes de se
  //  cadastrar. Por isso não passam pelo servidor, que exige login.
  // =====================================================================

  /** true quando o supabase.js foi carregado antes deste arquivo */
  function temSupabase() {
    return typeof SUPA !== 'undefined' && SUPA !== null;
  }

  /** Lista todas as escolas cadastradas, para preencher a lista suspensa */
  async function getEscolas() {
    if (!temSupabase()) throw buildError(0, 'Supabase não está carregado.');

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
   *
   * O select pede só id e nome. A coluna `codigo` nem poderia ser pedida:
   * a migração 03 tirou a permissão de leitura dela, porque com ela
   * aberta qualquer visitante listava os códigos de todas as turmas.
   */
  async function getTurmasPorEscola(escolaId) {
    if (!escolaId) return [];
    if (!temSupabase()) throw buildError(0, 'Supabase não está carregado.');

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
   *
   * Passa por uma função do banco em vez de um select comum: assim a
   * pergunta é fechada — manda-se um código e recebe-se uma turma, sem
   * poder varrer a tabela atrás de todos os códigos.
   */
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

  // =====================================================================
  //  O JOGO — pelo servidor Express
  // =====================================================================

  /** Os pontos do bairro que aparecem no mapa */
  const getCenarios = () => get('/cenarios');

  /** As missões de um cenário, já filtradas pela idade do aluno */
  const getMissoes = (slug) => get(`/cenarios/${encodeURIComponent(slug)}/missoes`);

  /** As questões de uma missão — SEM a resposta correta, que fica no servidor */
  const getQuestoes = (missaoId) => get(`/missoes/${missaoId}/questoes`);

  /**
   * Envia uma resposta e recebe { acertou, explicacao, pontos }.
   *
   * Quem confere é o servidor. A `explicacao` volta mesmo quando a pessoa
   * erra — mas a letra certa nunca volta: a ideia é que ela tente de novo
   * com o conteúdo em mãos, não que copie a resposta.
   */
  const responder = (questaoId, resposta) =>
    post('/responder', { questao_id: questaoId, resposta });

  /** As 8 barras do aluno, sempre as 8, mesmo as zeradas */
  const getMeuProgresso = () => get('/meu-progresso');

  // ── Professor ──────────────────────────────
  const getMinhasTurmas = () => get('/professor/turmas');
  const criarTurma      = ({ nome, cor, ano_escolar }) =>
    post('/professor/turmas', { nome, cor, ano_escolar });
  const getAlunosDaTurma = (turmaId) => get(`/professor/turmas/${turmaId}/alunos`);

  // ── API pública ─────────────────────────────
  return {
    get, post, patch, delete: del,

    // Escolas e turmas (direto no Supabase)
    getEscolas,
    getTurmasPorEscola,
    getTurmaPorCodigo,

    // Jogo (pelo servidor)
    getCenarios,
    getMissoes,
    getQuestoes,
    responder,
    getMeuProgresso,

    // Professor (pelo servidor)
    getMinhasTurmas,
    criarTurma,
    getAlunosDaTurma,
  };
})();
