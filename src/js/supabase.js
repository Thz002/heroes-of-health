/**
 * supabase.js — Heróis da Saúde
 *
 * A conexão única com o Supabase. Todo o resto do site fala com o banco
 * através daqui.
 *
 * Deve ser carregado ANTES de api.js e auth.js.
 * Expõe dois objetos globais:
 *   SUPA  -> a conexão com o banco
 *   AUTH  -> cadastro, login, logout e quem está logado
 */

// =====================================================================
//  CONFIGURAÇÃO
//
//  A chave abaixo é a "publishable" — ela foi feita para ficar visível no
//  navegador, e é normal que apareça no repositório. Ela não dá permissão
//  nenhuma sozinha: quem decide o que cada pessoa pode ver são as regras
//  de segurança escritas dentro do banco.
//
//  A chave que começa com "sb_secret_" NUNCA pode vir para cá.
// =====================================================================

const SUPABASE_URL = "https://xmdmzmuhorlrptifgfhz.supabase.co";
const SUPABASE_KEY = "sb_publishable_CF0Sre41ZkH_a05rEko5SA_lvr740Yd";

// A biblioteca do Supabase se apresenta como "supabase" no navegador.
// Guardamos a conexão em SUPA para não confundir uma coisa com a outra.
const SUPA = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);


const AUTH = (() => {

  // ── Tradução das mensagens de erro ─────────────
  // O Supabase responde em inglês. Aqui viram frases que fazem sentido
  // para quem está usando o site.
  function traduzir(mensagem) {
    const m = (mensagem || '').toLowerCase();

    if (m.includes('invalid login credentials')) return 'E-mail ou senha incorretos.';
    if (m.includes('email not confirmed')) return 'Esta conta ainda não foi confirmada por e-mail.';
    if (m.includes('user already registered')) return 'Já existe uma conta com este e-mail.';
    if (m.includes('password should be at least')) return 'A senha é curta demais.';
    if (m.includes('duplicate key') && m.includes('escolas')) return 'Já existe uma escola com esse nome.';
    if (m.includes('violates check constraint')) return 'Algum dado está fora do permitido. Confira a idade.';
    if (m.includes('violates foreign key')) return 'A turma ou escola escolhida não existe mais.';
    if (m.includes('row-level security')) return 'O banco recusou a operação por segurança.';
    if (m.includes('failed to fetch')) return 'Sem conexão com o servidor. Verifique sua internet.';

    return mensagem || 'Não foi possível completar a operação.';
  }

  // ── Cadastro ───────────────────────────────────
  /**
   * Cria a conta. UMA chamada só.
   *
   * Antes eram três escritas separadas: criar a conta, criar a escola, e
   * inserir a linha em `usuarios`. Como não formavam uma transação, quando
   * a terceira falhava sobrava uma conta que fazia login mas que o jogo
   * não conhecia — o usuário aparecia na aba "Users" do Supabase e não
   * aparecia na tabela `usuarios`.
   *
   * Agora os dados do perfil viajam junto, dentro de `options.data`, e
   * quem cria a linha em `usuarios` é um gatilho no banco (migração 03,
   * função `criar_perfil_do_novo_usuario`). Se algo falhar, falha tudo
   * junto e não sobra conta órfã.
   *
   * Recebe o objeto montado pelo auth.js e devolve { ok, message }.
   */
  async function register(dados) {
    // Tudo aqui é lido pelo gatilho, do lado do banco. E é lá que os
    // valores são conferidos: o que vem do navegador é informação que a
    // própria pessoa controla, então 'ADMIN' é rebaixado para 'ALUNO'.
    const perfil = {
      nome: dados.nome,
      tipo: dados.tipo
    };

    if (dados.tipo === 'ALUNO') {
      perfil.idade = String(dados.idade ?? '');
      perfil.turma_id = String(dados.turma_id ?? '');
    } else {
      if (dados.escola_id) perfil.escola_id = String(dados.escola_id);
      if (dados.escola_nome) perfil.escola_nome = dados.escola_nome;
    }

    const conta = await SUPA.auth.signUp({
      email: dados.email,
      password: dados.password,
      options: { data: perfil }
    });

    if (conta.error) {
      return { ok: false, message: traduzir(conta.error.message) };
    }

    // O perfil já existe neste ponto — o gatilho rodou dentro da mesma
    // transação que criou a conta. Sem sessão significa apenas que o
    // Supabase está exigindo confirmação por e-mail antes de deixar
    // entrar. Os e-mails escolares muitas vezes não recebem a mensagem.
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

  // ── Tipo lembrado (atalho de velocidade) ───────
  // Guardar ALUNO/PROFESSOR junto da sessão evita uma consulta ao banco
  // só para decidir para qual página mandar quem já estava logado.
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

    const r = await SUPA
      .from('usuarios')
      .select('id, nome, tipo, idade, escola_id, turma_id')
      .eq('id', conta.id)
      .maybeSingle();

    if (r.error) return null;
    return r.data;
  }

  /** Manda para a tela de login quem não estiver logado. Usar nas telas do jogo. */
  async function exigirLogin(destino = 'index.html') {
    const conta = await contaAtual();
    if (!conta) window.location.href = destino;
    return conta;
  }

  /**
   * O token da sessão atual, ou string vazia.
   *
   * É o crachá que o api.js manda ao servidor Express. Quem o emitiu foi
   * o Supabase Auth, e é o Supabase que o servidor consulta para saber se
   * ele vale — o servidor não guarda senha nem inventa sessão própria.
   */
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
