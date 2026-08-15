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

    if (m.includes('invalid login credentials'))  return 'E-mail ou senha incorretos.';
    if (m.includes('email not confirmed'))        return 'Esta conta ainda não foi confirmada por e-mail.';
    if (m.includes('user already registered'))    return 'Já existe uma conta com este e-mail.';
    if (m.includes('password should be at least'))return 'A senha é curta demais.';
    if (m.includes('duplicate key') && m.includes('escolas')) return 'Já existe uma escola com esse nome.';
    if (m.includes('violates check constraint'))  return 'Algum dado está fora do permitido. Confira a idade.';
    if (m.includes('violates foreign key'))       return 'A turma ou escola escolhida não existe mais.';
    if (m.includes('row-level security'))         return 'O banco recusou a operação por segurança.';
    if (m.includes('failed to fetch'))            return 'Sem conexão com o servidor. Verifique sua internet.';

    return mensagem || 'Não foi possível completar a operação.';
  }

  // ── Cadastro ───────────────────────────────────
  /**
   * Cria a conta e o cadastro do jogo, nesta ordem:
   *   1. o Supabase cria a conta e devolve um identificador
   *   2. se for professor criando escola nova, a escola é criada
   *   3. a linha da pessoa entra na tabela usuarios, usando aquele identificador
   *
   * Recebe o objeto montado pelo auth.js e devolve { ok, message }.
   */
  async function register(dados) {
    // 1. A conta
    const conta = await SUPA.auth.signUp({
      email: dados.email,
      password: dados.password
    });

    if (conta.error) {
      return { ok: false, message: traduzir(conta.error.message) };
    }

    // Sem sessão aqui significa que o Supabase está exigindo confirmação
    // por e-mail. Como os e-mails dos alunos são institucionais e podem
    // não receber mensagem, isso trava o cadastro.
    if (!conta.data.session) {
      return {
        ok: false,
        message: 'Conta criada, mas falta confirmar o e-mail. ' +
                 'Desligue "Confirm email" no painel do Supabase.'
      };
    }

    const identificador = conta.data.user.id;

    // 2. A escola nova, quando o professor pediu para criar uma
    let escolaId = dados.escola_id ?? null;

    if (dados.tipo === 'PROFESSOR' && dados.escola_nome) {
      const nova = await SUPA
        .from('escolas')
        .insert({ nome: dados.escola_nome })
        .select('id')
        .single();

      if (nova.error) {
        return { ok: false, message: traduzir(nova.error.message) };
      }
      escolaId = nova.data.id;
    }

    // 3. O cadastro no jogo
    const perfil = {
      id: identificador,       // o mesmo identificador da conta — é o que liga os dois
      nome: dados.nome,
      tipo: dados.tipo
    };

    if (dados.tipo === 'ALUNO') {
      perfil.idade    = dados.idade;
      perfil.turma_id = dados.turma_id;
      // escola_id fica em branco: a escola do aluno se descobre pela turma
    } else {
      perfil.escola_id = escolaId;
    }

    const gravou = await SUPA.from('usuarios').insert(perfil);

    if (gravou.error) {
      return { ok: false, message: traduzir(gravou.error.message) };
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

  // ── Sair ───────────────────────────────────────
  async function logout() {
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

  return { register, login, logout, contaAtual, perfilAtual, exigirLogin, traduzir };
})();
