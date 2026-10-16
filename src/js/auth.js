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
  let turmaPorCodigo = null;   // a turma que o código digitado resolveu

  // ── Elementos da tela ─────────────────────────
  const form = document.getElementById('login-form');
  const alertEl = document.getElementById('form-alert');
  const emailInput = document.getElementById('email');
  const passInput = document.getElementById('password');
  const submitBtn = document.getElementById('submit-btn');
  const btnLabel = document.getElementById('btn-label');
  const btnSpin = document.getElementById('btn-spin');

  const toggleBtn = document.getElementById('toggle-pass');
  const eyeOpen = document.getElementById('eye-open');
  const eyeClosed = document.getElementById('eye-closed');

  const boxRole = document.getElementById('box-role');
  const boxNome = document.getElementById('box-nome');
  const boxAluno = document.getElementById('box-aluno');
  const boxProfessor = document.getElementById('box-professor');
  const nomeInput = document.getElementById('nome');
  const radioPerfis = document.querySelectorAll('input[name="tipo"]');

  const idadeInput = document.getElementById('idade');
  const idadeHint = document.getElementById('idade-hint');
  const modoCodigo = document.getElementById('modo-codigo');
  const codigoInput = document.getElementById('codigo-turma');
  const codigoHint = document.getElementById('codigo-hint');


  const forgotRow = document.getElementById('forgot-row');
  const forgotBtn = document.getElementById('forgot-btn');
  const registerBtn = document.getElementById('register-btn');
  const toggleText = document.getElementById('toggle-text');
  const logoSub = document.getElementById('logo-sub');

  (async () => {
    const conta = await AUTH.contaAtual();
    if (!conta) return;

    const tipoSalvo = AUTH.tipoLembrado();
    if (tipoSalvo) {
      window.location.href = destinoDoTipo(tipoSalvo).pagina;
      return;
    }

    const destino = await destinoDepoisDeEntrar();
    window.location.href = destino.pagina;
  })();

  // ── Mostrar / esconder a senha ────────────────
  if (toggleBtn && passInput) {
    toggleBtn.addEventListener('click', () => {
      const visivel = passInput.type === 'text';
      passInput.type = visivel ? 'password' : 'text';
      if (eyeOpen) eyeOpen.style.display = visivel ? '' : 'none';
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

  // Nome diferente de AUTH.perfilAtual() de propósito: essa aqui só lê o
  // rádio marcado na tela (síncrona), não consulta o banco.
  function tipoSelecionado() {
    const marcado = document.querySelector('input[name="tipo"]:checked');
    return marcado ? marcado.value : 'ALUNO';
  }

  function textoDoBotao() {
    if (isLogin) return 'Entrar no Jogo';
    return tipoSelecionado() === 'PROFESSOR' ? 'Cadastrar Professor' : 'Cadastrar Aluno';
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

  // ── Código da turma ───────────────────────────
  //
  // Havia dois modos aqui, e um botão para alternar: o código, ou
  // escolher escola e turma em duas listas encadeadas. Ficou o código.
  //
  // A lista dependia de alguém ter cadastrado a escola com o nome
  // certo, e o cadastro aceitava qualquer nome de qualquer pessoa —
  // em poucos dias de teste o banco já tinha "Harvard College". O
  // código resolve a turma numa chamada só, não depende de lista
  // nenhuma, e é o que o professor já entrega para a sala.

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
      setHint(codigoHint, `Turma ${turma.nome}`, 'ok');
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

    const tipo = tipoSelecionado();
    const base = { nome, email: email.trim(), password: senha, tipo };

    // O PROFESSOR não tem mais nada a preencher além do comum: ele
    // cria as turmas depois, no painel.
    if (tipo === 'PROFESSOR') return { dados: base };

    // ALUNO
    const r = validarIdade(idadeInput ? idadeInput.value : '');
    if (!r.ok) return { erro: r.msg };

    if (!turmaPorCodigo) return { erro: 'Digite um código de turma válido.' };
    const turmaId = turmaPorCodigo.id;

    // A turma é o único vínculo: não há mais escola para enviar.
    return { dados: { ...base, idade: r.idade, turma_id: turmaId } };
  }

  // ── Alternar entre Login e Cadastro ───────────
  function irParaCadastro() {
    if (logoSub) logoSub.textContent = 'Crie sua conta para começar';
    if (boxRole) boxRole.classList.remove('hidden');
    if (boxNome) boxNome.classList.remove('hidden');
    if (forgotRow) forgotRow.classList.add('hidden');
    if (toggleText) toggleText.textContent = 'Já tem uma conta?';
    if (registerBtn) registerBtn.textContent = 'Fazer login';

    alternarPerfil();
  }

  function irParaLogin() {
    if (logoSub) logoSub.textContent = 'Sua missão de saúde começa aqui';
    if (boxRole) boxRole.classList.add('hidden');
    if (boxNome) boxNome.classList.add('hidden');
    if (boxAluno) boxAluno.classList.add('hidden');
    if (boxProfessor) boxProfessor.classList.add('hidden');
    if (forgotRow) forgotRow.classList.remove('hidden');
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
    const ehAluno = tipoSelecionado() === 'ALUNO';
    if (boxAluno) boxAluno.classList.toggle('hidden', !ehAluno);
    if (boxProfessor) boxProfessor.classList.toggle('hidden', ehAluno);
    if (btnLabel) btnLabel.textContent = textoDoBotao();
  }


  // O aluno passa pelo menu inicial antes do mapa; o professor vai direto
  // para o painel. Quem muda o destino do aluno muda aqui — esta função é
  // usada pelo login, pelo cadastro e pela entrada automática.
  function destinoDoTipo(tipo) {
    return (tipo === 'PROFESSOR' || tipo === 'ADMIN')
      ? { pagina: 'dashboard.html', saudacao: 'Bem-vindo, Mestre! ' }
      : { pagina: 'loading.html', saudacao: 'Bem-vindo, Herói! ' };
  }

  async function destinoDepoisDeEntrar(tipoDeclarado = null) {
    let tipo = tipoDeclarado;

    try {
      const perfil = await AUTH.perfilAtual();
      if (perfil && perfil.tipo) tipo = perfil.tipo;
    } catch (_) { /* fica com o tipo declarado */ }

    AUTH.lembrarTipo(tipo);
    return destinoDoTipo(tipo);
  }

  // ── Envio do formulário ───────────────────────
  if (form) {
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      hideAlert();

      const email = emailInput ? emailInput.value.trim() : '';
      const senha = passInput ? passInput.value : '';

      const erroCredenciais = validarCredenciais(email, senha);
      if (erroCredenciais) { showAlert(erroCredenciais, 'error'); return; }

      // No cadastro, valida tudo ANTES de travar o botão.
      let dadosCadastro = null;
      if (!isLogin) {
        const { erro, dados } = montarCadastro(email, senha);
        if (erro) { showAlert(erro, 'error'); return; }

        // Última chance de pegar o e-mail escrito errado. Quem passa
        // daqui com "@gmai.com" fica com uma conta que nunca recupera
        // a senha. A resposta vem do cache do servidor quando o campo
        // já foi conferido ao sair dele, então quase nunca custa nada.
        if (!(await conferirEmailDigitado())) {
          showAlert('Confira o e-mail antes de criar a conta.', 'error');
          if (emailInput) emailInput.focus();
          return;
        }

        dadosCadastro = dados;
      }

      setLoading(true);

      try {
        if (isLogin) {
          if (typeof AUTH !== 'undefined' && typeof AUTH.login === 'function') {
            const r = await AUTH.login(email, senha);
            if (r.ok) {
              const destino = await destinoDepoisDeEntrar();
              showAlert(destino.saudacao, 'success');
              setTimeout(() => { window.location.href = destino.pagina; }, 1100);
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
              const destino = await destinoDepoisDeEntrar(dadosCadastro.tipo);
              showAlert(`Conta criada! ${destino.saudacao}`, 'success');
              setTimeout(() => { window.location.href = destino.pagina; }, 1100);
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

  const EMAIL_OK = /^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i;

  // ── O e-mail digitado é real? ─────────────────
  //
  // Só no cadastro, e só ao sair do campo: conferir a cada tecla seria
  // uma consulta de DNS por letra digitada.
  //
  // Uma conta criada com o e-mail errado é uma conta que nunca vai
  // conseguir recuperar a senha — e o aluno só descobre no dia em que
  // precisar. Por isso o aviso aparece agora, enquanto dá para corrigir.
  //
  // O que este aviso NÃO promete: que a caixa existe. Ele pega o
  // domínio escrito errado ("@gmai.com"), que é o engano comum.
  const emailHint = document.getElementById('email-hint');
  let emailReprovado = '';   // o último endereço que o servidor recusou

  function avisoDeEmail(texto, ruim) {
    if (!emailHint) return;
    emailHint.textContent = texto || '';
    emailHint.classList.toggle('hidden', !texto);
    emailHint.style.color = ruim ? '#ff8080' : 'rgba(107,223,184,0.9)';
  }

  async function conferirEmailDigitado() {
    const email = emailInput ? emailInput.value.trim() : '';

    if (isLogin || !email) { avisoDeEmail(''); return true; }
    if (!EMAIL_OK.test(email)) {
      avisoDeEmail('Esse e-mail não parece completo.', true);
      emailReprovado = email;
      return false;
    }

    try {
      const r = await API.conferirEmail(email);
      if (r && r.ok === false) {
        emailReprovado = email;
        avisoDeEmail(r.motivo || 'Confira o e-mail.', true);
        return false;
      }
      emailReprovado = '';
      avisoDeEmail('E-mail válido.', false);
      return true;
    } catch (_) {
      // Servidor fora do ar não pode impedir ninguém de se cadastrar.
      emailReprovado = '';
      avisoDeEmail('');
      return true;
    }
  }

  if (emailInput) {
    emailInput.addEventListener('blur', conferirEmailDigitado);
    emailInput.addEventListener('input', () => {
      if (emailInput.value.trim() !== emailReprovado) avisoDeEmail('');
    });
  }

  // ═══════════════════════════════════════════════
  //  ESQUECI MINHA SENHA
  //
  //  Duas telas dentro do mesmo cartão, no lugar do formulário de
  //  login: os cinco quadradinhos do código e, depois, a nova senha.
  //
  //  Nada é decidido aqui. O código é conferido pelo servidor, o prazo
  //  é do servidor e o limite de tentativas também — este arquivo só
  //  mostra a resposta. Qualquer verificação escrita deste lado seria
  //  enfeite, porque está ao alcance de quem abrir o console.
  // ═══════════════════════════════════════════════

  const SENHA_MIN = 6;

  const painelRec   = document.getElementById('recuperar');
  const passoCodigo = document.getElementById('rec-passo-codigo');
  const passoSenha  = document.getElementById('rec-passo-senha');
  const recVoltar   = document.getElementById('rec-voltar');
  const recEmailEl  = document.getElementById('rec-email');
  const codeRow     = document.getElementById('code-row');
  const caixas      = codeRow ? Array.from(codeRow.querySelectorAll('.code-box')) : [];
  const btnConferir = document.getElementById('rec-conferir');
  const btnReenviar = document.getElementById('rec-reenviar');
  const btnAlterar  = document.getElementById('rec-alterar');
  const recSenha    = document.getElementById('rec-senha');
  const recSenha2   = document.getElementById('rec-senha2');
  const loginDivider = document.getElementById('login-divider');
  const registerRow  = document.querySelector('.register-row');

  // O e-mail e o ticket vivem aqui enquanto a recuperação está aberta.
  // O ticket é o que a última chamada apresenta: sem ele, o servidor
  // recusa a troca de senha mesmo que o código já tenha sido acertado.
  let recEmail = '';
  let recTicket = '';
  let contagemReenvio = 0;

  /** Liga e desliga o giro de um dos botões da recuperação. */
  function travar(botao, rotulo, ligado, textoNormal, textoOcupado) {
    if (!botao) return;
    botao.disabled = ligado;
    if (rotulo) rotulo.textContent = ligado ? textoOcupado : textoNormal;
    const spin = botao.querySelector('.spin');
    if (spin) spin.style.display = ligado ? 'block' : 'none';
  }

  function mostrarPasso(qual) {
    if (passoCodigo) passoCodigo.classList.toggle('hidden', qual !== 'codigo');
    if (passoSenha)  passoSenha.classList.toggle('hidden', qual !== 'senha');
  }

  function abrirRecuperacao(email) {
    recEmail = email;
    recTicket = '';
    if (recEmailEl) recEmailEl.textContent = email;
    if (logoSub) logoSub.textContent = 'Vamos recuperar o seu acesso';

    if (form) form.classList.add('hidden');
    if (loginDivider) loginDivider.classList.add('hidden');
    if (registerRow) registerRow.classList.add('hidden');
    if (painelRec) painelRec.classList.remove('hidden');

    limparCaixas();
    mostrarPasso('codigo');
    if (caixas[0]) caixas[0].focus();
  }

  function fecharRecuperacao() {
    recEmail = '';
    recTicket = '';
    if (painelRec) painelRec.classList.add('hidden');
    if (form) form.classList.remove('hidden');
    if (loginDivider) loginDivider.classList.remove('hidden');
    if (registerRow) registerRow.classList.remove('hidden');

    limparCaixas();
    if (recSenha) recSenha.value = '';
    if (recSenha2) recSenha2.value = '';

    isLogin = true;
    irParaLogin();
    hideAlert();
  }

  // ── Os cinco quadradinhos ─────────────────────

  function limparCaixas() {
    caixas.forEach((c) => { c.value = ''; c.classList.remove('cheia'); });
  }

  function codigoDigitado() {
    return caixas.map((c) => c.value).join('');
  }

  /** Só letra maiúscula e número entram — o resto some ao digitar. */
  function limpar(texto) {
    return String(texto || '').toUpperCase().replace(/[^A-Z0-9]/g, '');
  }

  function tremer() {
    if (!codeRow) return;
    codeRow.classList.remove('errou');
    void codeRow.offsetWidth;          // reinicia a animação
    codeRow.classList.add('errou');
    setTimeout(() => codeRow.classList.remove('errou'), 450);
  }

  /** Espalha um código inteiro pelas caixas, venha de onde vier. */
  function preencher(texto, apartirDe = 0) {
    const limpo = limpar(texto);
    let i = apartirDe;
    for (const letra of limpo) {
      if (i >= caixas.length) break;
      caixas[i].value = letra;
      caixas[i].classList.add('cheia');
      i++;
    }
    const proxima = Math.min(i, caixas.length - 1);
    if (caixas[proxima]) caixas[proxima].focus();
    return i;
  }

  caixas.forEach((caixa, i) => {
    caixa.addEventListener('input', () => {
      const bruto = limpar(caixa.value);

      // Teclado de celular às vezes entrega mais de um caractere de uma
      // vez, e o autopreenchimento entrega o código inteiro.
      if (bruto.length > 1) {
        caixa.value = '';
        if (preencher(bruto, i) === caixas.length) conferirCodigo();
        return;
      }

      caixa.value = bruto;
      caixa.classList.toggle('cheia', bruto !== '');

      if (bruto && i < caixas.length - 1) caixas[i + 1].focus();

      // Completou as cinco: confere sozinho, sem pedir clique.
      if (bruto && i === caixas.length - 1 && codigoDigitado().length === caixas.length) {
        conferirCodigo();
      }
    });

    caixa.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && !caixa.value && i > 0) {
        e.preventDefault();
        caixas[i - 1].value = '';
        caixas[i - 1].classList.remove('cheia');
        caixas[i - 1].focus();
      }
      if (e.key === 'ArrowLeft' && i > 0) { e.preventDefault(); caixas[i - 1].focus(); }
      if (e.key === 'ArrowRight' && i < caixas.length - 1) { e.preventDefault(); caixas[i + 1].focus(); }
      if (e.key === 'Enter') { e.preventDefault(); conferirCodigo(); }
    });

    // Colar o código do e-mail tem que funcionar em qualquer caixa.
    caixa.addEventListener('paste', (e) => {
      e.preventDefault();
      const colado = (e.clipboardData || window.clipboardData).getData('text');
      if (preencher(colado, i) === caixas.length) conferirCodigo();
    });

    caixa.addEventListener('focus', () => caixa.select());
  });

  // ── Pedir o código ────────────────────────────

  async function pedirCodigo() {
    try {
      const r = await API.pedirCodigoDeSenha(recEmail || (emailInput ? emailInput.value.trim() : ''));
      showAlert(r?.message || 'Código enviado.', 'success');
      return true;
    } catch (erro) {
      showAlert(erro.message || 'Não foi possível enviar o código.', 'error');
      return false;
    }
  }

  if (forgotBtn) {
    forgotBtn.addEventListener('click', async (e) => {
      e.preventDefault();
      const email = emailInput ? emailInput.value.trim() : '';

      if (!EMAIL_OK.test(email)) {
        showAlert('Digite seu e-mail primeiro para recuperar a senha.', 'error');
        if (emailInput) emailInput.focus();
        return;
      }

      const textoOriginal = forgotBtn.textContent;
      forgotBtn.disabled = true;
      forgotBtn.textContent = 'Enviando código...';

      recEmail = email;
      const foi = await pedirCodigo();

      forgotBtn.disabled = false;
      forgotBtn.textContent = textoOriginal;

      if (foi) abrirRecuperacao(email);
      else recEmail = '';
    });
  }

  // Um reenvio não pode virar metralhadora: o servidor exige 60s entre
  // dois pedidos, e o botão mostra essa espera em vez de deixar a
  // pessoa clicar e tomar erro.
  if (btnReenviar) {
    btnReenviar.addEventListener('click', async () => {
      if (contagemReenvio) return;
      if (!(await pedirCodigo())) return;

      limparCaixas();
      if (caixas[0]) caixas[0].focus();

      let faltam = 60;
      btnReenviar.disabled = true;
      btnReenviar.textContent = 'Enviar outro código (' + faltam + 's)';

      contagemReenvio = setInterval(() => {
        faltam--;
        if (faltam <= 0) {
          clearInterval(contagemReenvio);
          contagemReenvio = 0;
          btnReenviar.disabled = false;
          btnReenviar.textContent = 'Enviar outro código';
          return;
        }
        btnReenviar.textContent = 'Enviar outro código (' + faltam + 's)';
      }, 1000);
    });
  }

  // ── Conferir o código ─────────────────────────

  async function conferirCodigo() {
    const codigo = codigoDigitado();
    const rotulo = document.getElementById('rec-conferir-label');

    if (codigo.length !== caixas.length) {
      showAlert('Digite os 5 caracteres do código.', 'error');
      tremer();
      return;
    }

    travar(btnConferir, rotulo, true, 'Confirmar código', 'Conferindo...');
    try {
      const r = await API.conferirCodigoDeSenha(recEmail, codigo);
      recTicket = r?.ticket || '';
      hideAlert();
      mostrarPasso('senha');
      if (recSenha) recSenha.focus();
    } catch (erro) {
      showAlert(erro.message || 'Código incorreto.', 'error');
      tremer();
      limparCaixas();
      if (caixas[0]) caixas[0].focus();
    } finally {
      travar(btnConferir, rotulo, false, 'Confirmar código', '');
    }
  }

  if (btnConferir) btnConferir.addEventListener('click', conferirCodigo);

  // ── Trocar a senha ────────────────────────────

  async function alterarSenha() {
    const senha  = recSenha ? recSenha.value : '';
    const senha2 = recSenha2 ? recSenha2.value : '';
    const rotulo = document.getElementById('rec-alterar-label');

    if (senha.length < SENHA_MIN) {
      showAlert('A senha precisa de pelo menos ' + SENHA_MIN + ' caracteres.', 'error');
      if (recSenha) recSenha.focus();
      return;
    }
    if (senha !== senha2) {
      showAlert('As duas senhas não são iguais.', 'error');
      if (recSenha2) { recSenha2.focus(); recSenha2.select(); }
      return;
    }

    travar(btnAlterar, rotulo, true, 'Alterar', 'Alterando...');
    try {
      const r = await API.trocarSenhaComTicket(recEmail, recTicket, senha);
      const email = recEmail;
      fecharRecuperacao();
      if (emailInput) emailInput.value = email;
      if (passInput) passInput.focus();
      showAlert(r?.message || 'Senha alterada! Agora é só entrar com ela.', 'success');
    } catch (erro) {
      showAlert(erro.message || 'Não foi possível alterar a senha.', 'error');
    } finally {
      travar(btnAlterar, rotulo, false, 'Alterar', '');
    }
  }

  if (btnAlterar) btnAlterar.addEventListener('click', alterarSenha);

  if (recSenha2) {
    recSenha2.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') { e.preventDefault(); alterarSenha(); }
    });
  }

  // ── A setinha de voltar ───────────────────────
  //
  // Volta um passo de cada vez, e não direto para o login: quem errou a
  // senha nova não deveria ter que pedir um código novo por causa disso.
  if (recVoltar) {
    recVoltar.addEventListener('click', () => {
      hideAlert();
      const naSenha = passoSenha && !passoSenha.classList.contains('hidden');

      if (naSenha) {
        recTicket = '';
        if (recSenha) recSenha.value = '';
        if (recSenha2) recSenha2.value = '';
        limparCaixas();
        mostrarPasso('codigo');
        if (caixas[0]) caixas[0].focus();
        return;
      }

      fecharRecuperacao();
    });
  }
});
