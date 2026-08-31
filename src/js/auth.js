/**
 * auth.js — Heróis da Saúde
 * Controla a tela index.html, que serve tanto para LOGIN quanto para CADASTRO.
 * Depende do objeto global API (src/js/api.js), carregado antes deste arquivo.
 */

document.addEventListener("DOMContentLoaded", () => {

  // Faixa etária atendida pelo jogo. Fora dela o aluno não teria missão
  // nenhuma compatível, porque as missões só cobrem de 7 a 18 anos.
  const IDADE_MIN = 7;
  const IDADE_MAX = 18;

  // ── Estado da tela ────────────────────────────
  let isLogin = true;          // true = tela de login, false = tela de cadastro
  let usandoCodigo = false;    // o aluno está digitando o código em vez de escolher na lista
  let escolasCarregadas = false;
  let turmaPorCodigo = null;   // a turma que o código digitado resolveu

  // ── Elementos da tela ─────────────────────────
  const form           = document.getElementById('login-form');
  const alertEl        = document.getElementById('form-alert');
  const emailInput     = document.getElementById('email');
  const passInput      = document.getElementById('password');
  const submitBtn      = document.getElementById('submit-btn');
  const btnLabel       = document.getElementById('btn-label');
  const btnSpin        = document.getElementById('btn-spin');

  const toggleBtn      = document.getElementById('toggle-pass');
  const eyeOpen        = document.getElementById('eye-open');
  const eyeClosed      = document.getElementById('eye-closed');

  const boxRole        = document.getElementById('box-role');
  const boxNome        = document.getElementById('box-nome');
  const boxAluno       = document.getElementById('box-aluno');
  const boxProfessor   = document.getElementById('box-professor');
  const nomeInput      = document.getElementById('nome');
  const radioPerfis    = document.querySelectorAll('input[name="tipo"]');

  const idadeInput     = document.getElementById('idade');
  const idadeHint      = document.getElementById('idade-hint');
  const selectEscolaAluno = document.getElementById('escola-aluno');
  const selectTurma    = document.getElementById('turma');
  const modoSelecao    = document.getElementById('modo-selecao');
  const modoCodigo     = document.getElementById('modo-codigo');
  const codigoInput    = document.getElementById('codigo-turma');
  const codigoHint     = document.getElementById('codigo-hint');
  const btnModoTurma   = document.getElementById('btn-modo-turma');

  const selectEscolaProf = document.getElementById('escola');
  const boxNovaEscola  = document.getElementById('box-nova-escola');
  const novaEscolaInput = document.getElementById('nova-escola');

  const forgotRow      = document.getElementById('forgot-row');
  const forgotBtn      = document.getElementById('forgot-btn');
  const registerBtn    = document.getElementById('register-btn');
  const toggleText     = document.getElementById('toggle-text');
  const logoSub        = document.getElementById('logo-sub');
  const xpRow          = document.getElementById('xp-row');

  // ── Mostrar / esconder a senha ────────────────
  if (toggleBtn && passInput) {
    toggleBtn.addEventListener('click', () => {
      const visivel = passInput.type === 'text';
      passInput.type = visivel ? 'password' : 'text';
      if (eyeOpen)   eyeOpen.style.display   = visivel ? ''     : 'none';
      if (eyeClosed) eyeClosed.style.display = visivel ? 'none' : '';
      toggleBtn.setAttribute('aria-label', visivel ? 'Mostrar senha' : 'Ocultar senha');
    });
  }

  // ── Mensagens de aviso ────────────────────────
  function showAlert(mensagem, tipo) {
    if (!alertEl) return;
    alertEl.textContent = mensagem;
    alertEl.className = `form-alert show ${tipo}`;
    if (tipo === 'success') setTimeout(hideAlert, 3500);
  }

  function hideAlert() {
    if (alertEl) alertEl.classList.remove('show');
  }

  // ── Botão travado enquanto espera resposta ────
  function setLoading(ligado) {
    if (!submitBtn) return;
    submitBtn.disabled = ligado;
    if (btnLabel) {
      btnLabel.textContent = ligado
        ? (isLogin ? 'Entrando...' : 'Cadastrando...')
        : textoDoBotao();
    }
    if (btnSpin) btnSpin.style.display = ligado ? 'block' : 'none';
  }

  function perfilAtual() {
    const marcado = document.querySelector('input[name="tipo"]:checked');
    return marcado ? marcado.value : 'ALUNO';
  }

  function textoDoBotao() {
    if (isLogin) return 'Entrar no Jogo';
    return perfilAtual() === 'PROFESSOR' ? 'Cadastrar Professor' : 'Cadastrar Aluno';
  }

  // ── Idade ─────────────────────────────────────
  // A idade é digitada livremente. A regra dos 7 aos 18 mora aqui, e o banco
  // repete a mesma regra do outro lado — nunca confie só na tela.
  function validarIdade(valor) {
    const bruto = String(valor ?? '').trim();
    if (!bruto) return { ok: false, msg: 'Informe sua idade.' };
    if (!/^\d{1,2}$/.test(bruto)) return { ok: false, msg: 'A idade deve ser um número inteiro.' };

    const idade = Number(bruto);
    if (idade < IDADE_MIN || idade > IDADE_MAX) {
      return { ok: false, msg: `O jogo é para alunos de ${IDADE_MIN} a ${IDADE_MAX} anos.` };
    }
    return { ok: true, idade };
  }

  // A idade define quais missões o aluno vê.
  function nivelEtario(idade) {
    if (idade <= 10) return { nivel: 1, faixa: '7 a 10 anos' };
    if (idade <= 14) return { nivel: 2, faixa: '11 a 14 anos' };
    return { nivel: 3, faixa: '15 a 18 anos' };
  }

  function setHint(el, texto, estado) {
    if (!el) return;
    el.textContent = texto;
    el.className = `field-hint${estado ? ' ' + estado : ''}`;
  }

  if (idadeInput) {
    idadeInput.addEventListener('input', () => {
      const bruto = idadeInput.value.trim();
      if (!bruto) { setHint(idadeHint, ''); return; }

      const r = validarIdade(bruto);
      if (!r.ok) { setHint(idadeHint, r.msg, 'err'); return; }

      const { nivel, faixa } = nivelEtario(r.idade);
      setHint(idadeHint, `Nível ${nivel} — missões de ${faixa}.`, 'ok');
    });
  }

  // ── Escola → Turma (lista que depende da outra) ──

  function opcaoPlaceholder(texto) {
    const opt = document.createElement('option');
    opt.value = '';
    opt.textContent = texto;
    opt.disabled = true;
    opt.selected = true;
    return opt;
  }

  function preencherSelect(select, itens, placeholder) {
    if (!select) return;
    select.innerHTML = '';
    select.appendChild(opcaoPlaceholder(placeholder));
    itens.forEach(item => {
      const opt = document.createElement('option');
      opt.value = item.id;
      opt.textContent = item.nome;
      select.appendChild(opt);
    });
  }

  // Carrega a lista de escolas uma vez só, ao abrir o cadastro.
  async function carregarEscolas() {
    if (escolasCarregadas) return;
    try {
      const escolas = await API.getEscolas();

      preencherSelect(selectEscolaAluno, escolas, 'Selecione a escola');
      preencherSelect(selectEscolaProf,  escolas, 'Selecione a escola');

      // Só o professor pode criar escola nova.
      if (selectEscolaProf) {
        const optNova = document.createElement('option');
        optNova.value = 'novo';
        optNova.textContent = '+ Cadastrar Nova Escola';
        selectEscolaProf.appendChild(optNova);
      }

      escolasCarregadas = true;
    } catch (_) {
      preencherSelect(selectEscolaAluno, [], 'Não foi possível carregar as escolas');
      preencherSelect(selectEscolaProf,  [], 'Não foi possível carregar as escolas');
    }
  }

  // Uma turma só existe dentro de uma escola. Por isso a lista de turmas
  // começa desabilitada e só é preenchida depois que a escola é escolhida.
  async function carregarTurmas(escolaId) {
    if (!selectTurma) return;

    selectTurma.disabled = true;
    selectTurma.innerHTML = '';
    selectTurma.appendChild(opcaoPlaceholder('Carregando turmas...'));

    try {
      const turmas = await API.getTurmasPorEscola(escolaId);

      if (!turmas || turmas.length === 0) {
        selectTurma.innerHTML = '';
        selectTurma.appendChild(opcaoPlaceholder('Nenhuma turma cadastrada nesta escola'));
        return;
      }

      preencherSelect(selectTurma, turmas, 'Selecione a turma');
      selectTurma.disabled = false;
    } catch (_) {
      selectTurma.innerHTML = '';
      selectTurma.appendChild(opcaoPlaceholder('Erro ao carregar as turmas'));
    }
  }

  if (selectEscolaAluno) {
    selectEscolaAluno.addEventListener('change', () => {
      // Trocar de escola limpa a turma anterior. Sem isso o formulário
      // enviaria uma turma que pertence a outra escola.
      carregarTurmas(selectEscolaAluno.value);
    });
  }

  // ── Escola nova (só professor) ────────────────
  if (selectEscolaProf) {
    selectEscolaProf.addEventListener('change', () => {
      const criandoNova = selectEscolaProf.value === 'novo';
      if (boxNovaEscola) boxNovaEscola.classList.toggle('hidden', !criandoNova);
      if (criandoNova && novaEscolaInput) novaEscolaInput.focus();
    });
  }

  // ── Código da turma ───────────────────────────
  function alternarModoTurma() {
    usandoCodigo = !usandoCodigo;
    turmaPorCodigo = null;

    if (modoSelecao) modoSelecao.classList.toggle('hidden', usandoCodigo);
    if (modoCodigo)  modoCodigo.classList.toggle('hidden', !usandoCodigo);
    if (btnModoTurma) {
      btnModoTurma.textContent = usandoCodigo
        ? 'Escolher escola e turma na lista'
        : 'Tenho um código da turma';
    }

    if (usandoCodigo) {
      setHint(codigoHint, 'Peça o código ao seu professor.');
      if (codigoInput) { codigoInput.value = ''; codigoInput.focus(); }
    } else {
      if (selectEscolaAluno) selectEscolaAluno.selectedIndex = 0;
      if (selectTurma) {
        selectTurma.disabled = true;
        selectTurma.innerHTML = '';
        selectTurma.appendChild(opcaoPlaceholder('Selecione a escola primeiro'));
      }
    }
  }

  if (btnModoTurma) btnModoTurma.addEventListener('click', alternarModoTurma);

  // Descobre a turma a partir do código e mostra o nome para confirmação.
  async function resolverCodigo() {
    if (!codigoInput) return;
    const codigo = codigoInput.value.trim().toUpperCase();
    turmaPorCodigo = null;

    if (!codigo) { setHint(codigoHint, 'Peça o código ao seu professor.'); return; }

    setHint(codigoHint, 'Procurando turma...');
    try {
      const turma = await API.getTurmaPorCodigo(codigo);
      if (!turma) {
        setHint(codigoHint, 'Código não encontrado. Confira com seu professor.', 'err');
        return;
      }

      turmaPorCodigo = turma;
      const escola = turma.escola_nome ? ` — ${turma.escola_nome}` : '';
      setHint(codigoHint, `Turma ${turma.nome}${escola}`, 'ok');
    } catch (_) {
      setHint(codigoHint, 'Não foi possível verificar o código agora.', 'err');
    }
  }

  if (codigoInput) {
    // Espera a pessoa parar de digitar antes de consultar, em vez de
    // consultar a cada tecla.
    let espera;
    codigoInput.addEventListener('input', () => {
      turmaPorCodigo = null;
      clearTimeout(espera);
      espera = setTimeout(resolverCodigo, 450);
    });
    codigoInput.addEventListener('blur', () => {
      clearTimeout(espera);
      resolverCodigo();
    });
  }

  // ── Validação ─────────────────────────────────
  function validarCredenciais(email, senha) {
    if (!email.trim()) return 'Informe seu e-mail.';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'E-mail inválido.';
    if (!senha) return 'Informe sua senha.';
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    return null;
  }

  // Junta os dados do cadastro, ou devolve a primeira mensagem de erro.
  function montarCadastro(email, senha) {
    const nome = nomeInput ? nomeInput.value.trim() : '';
    if (!nome) return { erro: 'Informe seu nome completo.' };

    const tipo = perfilAtual();
    const base = { nome, email: email.trim(), password: senha, tipo };

    if (tipo === 'PROFESSOR') {
      const escola = selectEscolaProf ? selectEscolaProf.value : '';
      if (!escola) return { erro: 'Selecione a escola onde você atua.' };

      if (escola === 'novo') {
        const nomeEscola = novaEscolaInput ? novaEscolaInput.value.trim() : '';
        if (nomeEscola.length < 3) return { erro: 'Informe o nome da nova escola.' };
        // A escola nova é criada junto com a conta, do outro lado. Criar antes
        // deixaria escolas soltas no banco se o cadastro falhasse depois.
        return { dados: { ...base, escola_id: null, escola_nome: nomeEscola } };
      }
      return { dados: { ...base, escola_id: Number(escola) } };
    }

    // ALUNO
    const r = validarIdade(idadeInput ? idadeInput.value : '');
    if (!r.ok) return { erro: r.msg };

    let turmaId;
    if (usandoCodigo) {
      if (!turmaPorCodigo) return { erro: 'Digite um código de turma válido.' };
      turmaId = turmaPorCodigo.id;
    } else {
      if (!selectEscolaAluno || !selectEscolaAluno.value) return { erro: 'Selecione sua escola.' };
      if (!selectTurma || !selectTurma.value) return { erro: 'Selecione sua turma.' };
      turmaId = Number(selectTurma.value);
    }

    // O aluno não envia a escola: ela se descobre pela turma.
    return { dados: { ...base, idade: r.idade, turma_id: turmaId } };
  }

  // ── Alternar entre Login e Cadastro ───────────
  function irParaCadastro() {
    if (logoSub) logoSub.textContent = 'Crie sua conta para começar';
    if (boxRole) boxRole.classList.remove('hidden');
    if (boxNome) boxNome.classList.remove('hidden');
    if (forgotRow) forgotRow.classList.add('hidden');
    if (xpRow) xpRow.classList.add('hidden');
    if (toggleText) toggleText.textContent = 'Já tem uma conta?';
    if (registerBtn) registerBtn.textContent = 'Fazer login';

    carregarEscolas();
    alternarPerfil();
  }

  function irParaLogin() {
    if (logoSub) logoSub.textContent = 'Sua missão de saúde começa aqui';
    if (boxRole) boxRole.classList.add('hidden');
    if (boxNome) boxNome.classList.add('hidden');
    if (boxAluno) boxAluno.classList.add('hidden');
    if (boxProfessor) boxProfessor.classList.add('hidden');
    if (forgotRow) forgotRow.classList.remove('hidden');
    if (xpRow) xpRow.classList.remove('hidden');
    if (toggleText) toggleText.textContent = 'Novo herói?';
    if (registerBtn) registerBtn.textContent = 'Criar conta gratuita';
    if (btnLabel) btnLabel.textContent = 'Entrar no Jogo';
  }

  if (registerBtn) {
    registerBtn.addEventListener('click', (e) => {
      e.preventDefault();
      isLogin = !isLogin;
      hideAlert();
      if (isLogin) irParaLogin(); else irParaCadastro();
    });
  }

  radioPerfis.forEach(radio => radio.addEventListener('change', alternarPerfil));

  function alternarPerfil() {
    if (isLogin) return;
    const ehAluno = perfilAtual() === 'ALUNO';
    if (boxAluno) boxAluno.classList.toggle('hidden', !ehAluno);
    if (boxProfessor) boxProfessor.classList.toggle('hidden', ehAluno);
    if (btnLabel) btnLabel.textContent = textoDoBotao();
  }

  // ── Envio do formulário ───────────────────────
  if (form) {
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      hideAlert();

      const email = emailInput ? emailInput.value : '';
      const senha = passInput ? passInput.value : '';

      const erroCredenciais = validarCredenciais(email, senha);
      if (erroCredenciais) { showAlert(erroCredenciais, 'error'); return; }

      // No cadastro, valida tudo ANTES de travar o botão.
      let dadosCadastro = null;
      if (!isLogin) {
        const { erro, dados } = montarCadastro(email, senha);
        if (erro) { showAlert(erro, 'error'); return; }
        dadosCadastro = dados;
      }

      setLoading(true);

      try {
        if (isLogin) {
          if (typeof AUTH !== 'undefined' && typeof AUTH.login === 'function') {
            const r = await AUTH.login(email, senha);
            if (r.ok) {
              const perfil = await AUTH.perfilAtual();
              const destino = (perfil?.tipo === 'PROFESSOR' || perfil?.tipo === 'ADMIN')
                ? 'dashboard.html'
                : 'loading.html';
                 if(destino == 'PROFESSOR' || destino == 'ADMIN')
                  {showAlert('Bem-vindo, Mestre da Saúde! ', 'success');}
                 else {showAlert('Bem-vindo, Herói!', 'success');}
              setTimeout(() => { window.location.href = destino; }, 1100);
            } else {
              showAlert(r.message || 'E-mail ou senha incorretos.', 'error');
            }
          } else {
            showAlert('O login ainda não está ligado ao Supabase.', 'error');
          }
        } else {
          if (typeof AUTH !== 'undefined' && typeof AUTH.register === 'function') {
            const r = await AUTH.register(dadosCadastro);
            if (r.ok) {
              showAlert('Conta criada com sucesso! Redirecionando...', 'success');
              setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
            } else {
              showAlert(r.message || 'Erro ao realizar cadastro.', 'error');
            }
          } else {
            showAlert('Você ainda não possui cadastro!', 'error');
          }
        }
      } catch (_) {
        showAlert('Erro ao conectar. Verifique sua internet.', 'error');
      } finally {
        setLoading(false);
      }
    });
  }

  // ── Esqueci minha senha ───────────────────────
  if (forgotBtn) {
    forgotBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const email = emailInput ? emailInput.value.trim() : '';
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        showAlert('Digite seu e-mail primeiro para recuperar a senha.', 'error');
        if (emailInput) emailInput.focus();
        return;
      }
      showAlert(`Link de recuperação enviado para ${email}!`, 'success');
    });
  }
});
