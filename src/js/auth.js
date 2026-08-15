/**
 * auth.js — Heróis da Saúde
 * Login e cadastro (aluno / professor) na tela index.html.
 * Depende do objeto global `API` (src/js/api.js), carregado antes deste arquivo.
 */

document.addEventListener("DOMContentLoaded", () => {
  let isLogin = true;

  // Faixa etária atendida pelo jogo. Fora dela o aluno não teria nenhuma
  // missão compatível, porque missoes.nivel_etario só cobre 7–18 anos.
  const IDADE_MIN = 7;
  const IDADE_MAX = 18;

  // ── Referências aos elementos do DOM ──
  const mainForm = document.getElementById('main-form');
  const boxRole = document.getElementById('box-role');
  const boxNome = document.getElementById('box-nome');
  const boxAluno = document.getElementById('box-aluno');
  const boxProfessor = document.getElementById('box-professor');
  const forgotRow = document.getElementById('forgot-row');
  const btnLabel = document.getElementById('btn-label');
  const toggleText = document.getElementById('toggle-text');
  const toggleModeBtn = document.getElementById('toggle-mode-btn');
  const logoSub = document.getElementById('logo-sub');
  const xpBadge = document.getElementById('xp-badge');
  const radioPerfis = document.querySelectorAll('input[name="tipo"]');
  const passInput = document.getElementById('password');
  const alertEl = document.getElementById('form-alert');

  // Campos de aluno
  const idadeInput = document.getElementById('idade');
  const idadeHint = document.getElementById('idade-hint');
  const selectEscolaAluno = document.getElementById('escola-aluno');
  const selectTurma = document.getElementById('turma');
  const modoSelecao = document.getElementById('modo-selecao');
  const modoCodigo = document.getElementById('modo-codigo');
  const codigoInput = document.getElementById('codigo-turma');
  const codigoHint = document.getElementById('codigo-hint');
  const btnModoTurma = document.getElementById('btn-modo-turma');

  // Campos de professor
  const selectEscolaProf = document.getElementById('escola');
  const boxNovaEscola = document.getElementById('box-nova-escola');
  const novaEscolaInput = document.getElementById('nova-escola');

  // ── Estado do vínculo com a turma ──
  let usandoCodigo = false;      // false = cascata escola->turma, true = código
  let escolasCarregadas = false;
  let turmaPorCodigo = null;     // turma resolvida a partir do código digitado

  // Criar dinamicamente o ícone de olho e spinner no HTML se não existirem,
  // garantindo compatibilidade com as funções de toggle e loading.
  if (passInput && !document.getElementById('toggle-pass')) {
    const wrap = passInput.parentElement;
    wrap.style.position = 'relative';
    const toggleBtn = document.createElement('button');
    toggleBtn.type = 'button';
    toggleBtn.id = 'toggle-pass';
    toggleBtn.className = 'input-toggle';
    toggleBtn.setAttribute('aria-label', 'Mostrar senha');
    toggleBtn.innerHTML = `
      <svg id="eye-open" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
      <svg id="eye-closed" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>
    `;
    wrap.appendChild(toggleBtn);
  }

  const submitBtn = document.getElementById('submit-btn');
  if (submitBtn && !document.getElementById('btn-spin')) {
    const spin = document.createElement('span');
    spin.id = 'btn-spin';
    spin.className = 'spinner';
    spin.style.display = 'none';
    spin.style.marginLeft = '8px';
    submitBtn.appendChild(spin);
  }

  // ── Toggle senha ──
  const toggleBtn = document.getElementById('toggle-pass');
  const eyeOpen = document.getElementById('eye-open');
  const eyeClosed = document.getElementById('eye-closed');

  if (toggleBtn && passInput) {
    toggleBtn.addEventListener('click', () => {
      const visible = passInput.type === 'text';
      passInput.type = visible ? 'password' : 'text';
      if (eyeOpen) eyeOpen.style.display = visible ? '' : 'none';
      if (eyeClosed) eyeClosed.style.display = visible ? 'none' : '';
      toggleBtn.setAttribute('aria-label', visible ? 'Mostrar senha' : 'Ocultar senha');
    });
  }

  // ── Alertas ──
  function showAlert(message, type) {
    if (!alertEl) return;
    alertEl.textContent = message;
    alertEl.className = `alert ${type === 'success' ? 'alert--success' : 'alert--error'}`;
    alertEl.style.display = 'flex';
    if (type === 'success') {
      setTimeout(hideAlert, 3500);
    }
  }

  function hideAlert() {
    if (!alertEl) return;
    alertEl.style.display = 'none';
  }

  // ── Loading state ──
  function setLoading(on) {
    if (!submitBtn) return;
    const label = document.getElementById('btn-label');
    const spin = document.getElementById('btn-spin');
    submitBtn.disabled = on;
    if (label) {
      label.textContent = on
        ? (isLogin ? 'Entrando...' : 'Cadastrando...')
        : (isLogin ? 'Entrar no Jogo' : (perfilAtual() === 'PROFESSOR' ? 'Cadastrar Professor' : 'Cadastrar Aluno'));
    }
    if (spin) spin.style.display = on ? 'inline-block' : 'none';
  }

  function perfilAtual() {
    const marcado = document.querySelector('input[name="tipo"]:checked');
    return marcado ? marcado.value : 'ALUNO';
  }

  // ── Validação de idade ─────────────────────
  /**
   * A idade é digitada livremente; a regra de negócio (7–18) mora aqui e
   * precisa ser repetida no servidor — o `min`/`max` do HTML é só conveniência.
   */
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

  /** Faixa de missões liberada pela idade (missoes.nivel_etario) */
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
      if (!bruto) return setHint(idadeHint, '');

      const r = validarIdade(bruto);
      if (!r.ok) return setHint(idadeHint, r.msg, 'err');

      const { nivel, faixa } = nivelEtario(r.idade);
      setHint(idadeHint, `Nível ${nivel} — missões de ${faixa}.`, 'ok');
    });
  }

  // ── Cascata Escola → Turma ─────────────────

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

  /** Carrega a lista de escolas uma única vez, ao abrir o cadastro. */
  async function carregarEscolas() {
    if (escolasCarregadas) return;
    try {
      const escolas = await API.getEscolas();

      preencherSelect(selectEscolaAluno, escolas, 'Selecione a escola');
      preencherSelect(selectEscolaProf, escolas, 'Selecione a escola');

      // Só o professor pode cadastrar uma escola nova.
      if (selectEscolaProf) {
        const optNova = document.createElement('option');
        optNova.value = 'novo';
        optNova.textContent = '+ Cadastrar Nova Escola';
        selectEscolaProf.appendChild(optNova);
      }

      escolasCarregadas = true;
    } catch (_) {
      preencherSelect(selectEscolaAluno, [], 'Não foi possível carregar as escolas');
      preencherSelect(selectEscolaProf, [], 'Não foi possível carregar as escolas');
    }
  }

  /**
   * Segundo passo da cascata: as turmas só existem no contexto de uma escola
   * (turmas.escola_id é FK obrigatória), por isso o select nasce desabilitado.
   */
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
      // Trocar de escola invalida a turma escolhida antes — sem isso o form
      // enviaria um turma_id que pertence a outra escola.
      carregarTurmas(selectEscolaAluno.value);
    });
  }

  // ── Escola nova (professor) ────────────────
  if (selectEscolaProf) {
    selectEscolaProf.addEventListener('change', () => {
      const criandoNova = selectEscolaProf.value === 'novo';
      if (boxNovaEscola) boxNovaEscola.classList.toggle('hidden', !criandoNova);
      if (criandoNova && novaEscolaInput) novaEscolaInput.focus();
    });
  }

  // ── Vínculo por código da turma ────────────

  /** Alterna entre "escolher escola e turma" e "digitar o código". */
  function alternarModoTurma() {
    usandoCodigo = !usandoCodigo;
    turmaPorCodigo = null;

    if (modoSelecao) modoSelecao.classList.toggle('hidden', usandoCodigo);
    if (modoCodigo) modoCodigo.classList.toggle('hidden', !usandoCodigo);
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

  /** Resolve o código em uma turma real e mostra escola + turma para confirmação. */
  async function resolverCodigo() {
    if (!codigoInput) return;
    const codigo = codigoInput.value.trim().toUpperCase();
    turmaPorCodigo = null;

    if (!codigo) return setHint(codigoHint, 'Peça o código ao seu professor.');

    setHint(codigoHint, 'Procurando turma...');
    try {
      const turma = await API.getTurmaPorCodigo(codigo);
      if (!turma) return setHint(codigoHint, 'Código não encontrado. Confira com seu professor.', 'err');

      turmaPorCodigo = turma;
      const escola = turma.escola_nome ? ` — ${turma.escola_nome}` : '';
      setHint(codigoHint, `Turma ${turma.nome}${escola}`, 'ok');
    } catch (_) {
      setHint(codigoHint, 'Não foi possível verificar o código agora.', 'err');
    }
  }

  if (codigoInput) {
    let debounce;
    codigoInput.addEventListener('input', () => {
      turmaPorCodigo = null;
      clearTimeout(debounce);
      debounce = setTimeout(resolverCodigo, 450);
    });
    codigoInput.addEventListener('blur', () => {
      clearTimeout(debounce);
      resolverCodigo();
    });
  }

  // ── Validação geral ────────────────────────
  function validarCredenciais(email, password) {
    if (!email.trim()) return 'Informe seu e-mail.';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'E-mail inválido.';
    if (!password) return 'Informe sua senha.';
    if (password.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    return null;
  }

  /** Monta o payload de cadastro ou devolve a primeira mensagem de erro. */
  function montarCadastro(nome, email, password) {
    if (!nome || !nome.trim()) return { erro: 'Informe seu nome completo.' };

    const tipo = perfilAtual();
    const base = { nome: nome.trim(), email: email.trim(), password, tipo };

    if (tipo === 'PROFESSOR') {
      const escola = selectEscolaProf ? selectEscolaProf.value : '';
      if (!escola) return { erro: 'Selecione a escola onde você atua.' };

      if (escola === 'novo') {
        const nomeEscola = novaEscolaInput ? novaEscolaInput.value.trim() : '';
        if (nomeEscola.length < 3) return { erro: 'Informe o nome da nova escola.' };
        // A escola é criada pelo servidor na mesma transação do cadastro:
        // criar antes deixaria escolas órfãs se o cadastro falhasse depois.
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

    // escola_id não vai no payload do aluno: é derivável por turma_id -> turmas.escola_id.
    return { dados: { ...base, idade: r.idade, turma_id: turmaId } };
  }

  // ── Alternância Login / Cadastro ───────────
  if (toggleModeBtn) {
    toggleModeBtn.addEventListener('click', (e) => {
      e.preventDefault();
      isLogin = !isLogin;
      hideAlert();

      if (!isLogin) {
        logoSub.innerText = "Crie sua conta para começar";
        boxRole.classList.remove('hidden');
        boxNome.classList.remove('hidden');
        forgotRow.classList.add('hidden');
        xpBadge.classList.add('hidden');

        toggleText.innerText = "Já tem uma conta?";
        toggleModeBtn.innerText = "Fazer login";

        carregarEscolas();
        alternarPerfil();
      } else {
        logoSub.innerText = "Sua missão de saúde começa aqui";
        boxRole.classList.add('hidden');
        boxNome.classList.add('hidden');
        boxAluno.classList.add('hidden');
        boxProfessor.classList.add('hidden');
        forgotRow.classList.remove('hidden');
        xpBadge.classList.remove('hidden');

        btnLabel.innerText = "Entrar no Jogo";
        toggleText.innerText = "Novo herói?";
        toggleModeBtn.innerText = "Criar conta gratuita";
      }
    });
  }

  radioPerfis.forEach(radio => radio.addEventListener('change', alternarPerfil));

  function alternarPerfil() {
    if (isLogin) return;
    const ehAluno = perfilAtual() === 'ALUNO';
    boxAluno.classList.toggle('hidden', !ehAluno);
    boxProfessor.classList.toggle('hidden', ehAluno);
    btnLabel.innerText = ehAluno ? "Cadastrar Aluno" : "Cadastrar Professor";
  }

  // ── Submit Unificado (Login & Cadastro) ──
  if (mainForm) {
    mainForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      hideAlert();

      const email = document.getElementById('email').value;
      const password = document.getElementById('password').value;
      const nomeInput = document.getElementById('nome');
      const nome = nomeInput ? nomeInput.value : '';

      const erroCredenciais = validarCredenciais(email, password);
      if (erroCredenciais) {
        showAlert(erroCredenciais, 'error');
        return;
      }

      let dadosCadastro = null;
      if (!isLogin) {
        const { erro, dados } = montarCadastro(nome, email, password);
        if (erro) {
          showAlert(erro, 'error');
          return;
        }
        dadosCadastro = dados;
      }

      setLoading(true);

      try {
        if (isLogin) {
          if (typeof AUTH !== 'undefined' && typeof AUTH.login === 'function') {
            const result = await AUTH.login(email, password);
            if (result.ok) {
              showAlert('Bem-vindo, Herói! 🎉', 'success');
              setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
            } else {
              showAlert(result.message || 'E-mail ou senha incorretos.', 'error');
            }
          } else {
            await new Promise(r => setTimeout(r, 1200));
            showAlert('Bem-vindo, Herói! 🎉', 'success');
            setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
          }
        } else {
          if (typeof AUTH !== 'undefined' && typeof AUTH.register === 'function') {
            const result = await AUTH.register(dadosCadastro);
            if (result.ok) {
              showAlert('Conta criada com sucesso! Redirecionando...', 'success');
              setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
            } else {
              showAlert(result.message || 'Erro ao realizar cadastro.', 'error');
            }
          } else {
            await new Promise(r => setTimeout(r, 1400));
            showAlert('Conta criada com sucesso! Bem-vindo ao jogo! 🚀', 'success');
            setTimeout(() => { window.location.href = 'mapa.html'; }, 1100);
          }
        }
      } catch (_) {
        showAlert('Erro ao conectar. Verifique sua internet.', 'error');
      } finally {
        setLoading(false);
      }
    });
  }

  // ── Esqueci senha ──
  const forgotBtn = document.querySelector('#forgot-row .forgot-link');
  if (forgotBtn) {
    forgotBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const email = document.getElementById('email').value.trim();
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        showAlert('Digite seu e-mail primeiro para recuperar a senha.', 'error');
        document.getElementById('email').focus();
        return;
      }
      showAlert(`Link de recuperação enviado para ${email}!`, 'success');
    });
  }
});
