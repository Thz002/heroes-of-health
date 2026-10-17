/** supabase.js — conexão com o Supabase. Carregue antes de api.js e auth.js.
    Globais: SUPA (cliente) e AUTH (cadastro, login, logout, sessão). */

// Chave publishable: feita para ficar visível. A sb_secret_ nunca vem para cá.

const SUPABASE_URL = "https://xmdmzmuhorlrptifgfhz.supabase.co";
const SUPABASE_KEY = "sb_publishable_CF0Sre41ZkH_a05rEko5SA_lvr740Yd";

// A biblioteca do Supabase se apresenta como "supabase" no navegador.
// Guardamos a conexão em SUPA para não confundir uma coisa com a outra.
const SUPA = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);


const AUTH = (() => {

  // Traduz as mensagens de erro do Supabase.
  function traduzir(mensagem) {
    const m = (mensagem || '').toLowerCase();

    if (m.includes('invalid login credentials')) return 'E-mail ou senha incorretos.';
    if (m.includes('email not confirmed')) return 'Esta conta ainda não foi confirmada por e-mail.';
    if (m.includes('user already registered')) return 'Já existe uma conta com este e-mail.';
    if (m.includes('password should be at least')) return 'A senha é curta demais.';
    if (m.includes('violates check constraint')) return 'Algum dado está fora do permitido. Confira a idade.';
    if (m.includes('violates foreign key')) return 'A turma escolhida não existe mais.';
    if (m.includes('row-level security')) return 'O banco recusou a operação por segurança.';
    if (m.includes('failed to fetch')) return 'Sem conexão com o servidor. Verifique sua internet.';

    return mensagem || 'Não foi possível completar a operação.';
  }

  // ── Cadastro ───────────────────────────────────
  /** Cria a conta numa chamada só; o perfil é criado por um gatilho no banco. Devolve { ok, message }. */
  async function register(dados) {
    // Lido pelo gatilho, que confere os valores (ADMIN vira ALUNO).
    const perfil = {
      nome: dados.nome,
      tipo: dados.tipo
    };

    if (dados.tipo === 'ALUNO') {
      perfil.idade = String(dados.idade ?? '');
      perfil.turma_id = String(dados.turma_id ?? '');
    } else {
    }

    const conta = await SUPA.auth.signUp({
      email: dados.email,
      password: dados.password,
      options: { data: perfil }
    });

    if (conta.error) {
      return { ok: false, message: traduzir(conta.error.message) };
    }

    // Sem sessão: o Supabase está exigindo confirmação por e-mail.
    if (!conta.data.session) {
      return {
        ok: false,
        message: 'Conta criada! Falta confirmar o e-mail para entrar. ' +
          'Se o e-mail não chegar, peça ao professor para desligar ' +
          '"Confirm email" no painel do Supabase.'
      };
    }

    return { ok: true };
  }

  // ── Login ──────────────────────────────────────
  async function login(email, senha) {
    const r = await SUPA.auth.signInWithPassword({ email, password: senha });

    if (r.error) {
      return { ok: false, message: traduzir(r.error.message) };
    }
    return { ok: true };
  }

  // Tipo lembrado no navegador (decide o destino sem consultar o banco).
  const CHAVE_TIPO = 'herois_tipo';

  function lembrarTipo(tipo) {
    if (tipo) localStorage.setItem(CHAVE_TIPO, tipo);
  }

  function tipoLembrado() {
    return localStorage.getItem(CHAVE_TIPO);
  }

  // ── Sair ───────────────────────────────────────
  async function logout() {
    localStorage.removeItem(CHAVE_TIPO);
    await SUPA.auth.signOut();
  }

  // ── Quem está logado ───────────────────────────
  /** Devolve a conta logada, ou null. Não precisa de senha: o Supabase lembra. */
  async function contaAtual() {
    const r = await SUPA.auth.getSession();
    return r.data.session ? r.data.session.user : null;
  }

  /** Devolve a linha da tabela usuarios de quem está logado, ou null. */
  async function perfilAtual() {
    const conta = await contaAtual();
    if (!conta) return null;

    // avatar_url é buscada à parte (fallback para bancos sem a coluna).
    const COLUNAS = 'id, nome, tipo, idade, turma_id';

    let r = await SUPA
      .from('usuarios')
      .select(COLUNAS + ', avatar_url')
      .eq('id', conta.id)
      .maybeSingle();

    if (r.error && /avatar_url/.test(r.error.message || '')) {
      r = await SUPA
        .from('usuarios')
        .select(COLUNAS)
        .eq('id', conta.id)
        .maybeSingle();
    }

    if (r.error) return null;
    return r.data;
  }

  /** Manda para a tela de login quem não estiver logado. Usar nas telas do jogo. */
  async function exigirLogin(destino = 'index.html') {
    const conta = await contaAtual();
    if (!conta) window.location.href = destino;
    return conta;
  }

  /** Token da sessão (vai no Authorization das chamadas ao servidor). */
  async function tokenAtual() {
    const r = await SUPA.auth.getSession();
    return r.data.session ? r.data.session.access_token : '';
  }

  return {
    register, login, logout,
    contaAtual, perfilAtual, exigirLogin, tokenAtual, traduzir,
    lembrarTipo, tipoLembrado
  };
})();
