(() => {
  'use strict';


  const btnNova = document.getElementById('btn-nova-turma');
  const modal = document.getElementById('modal-turma');
  const btnFechar = document.getElementById('btn-fechar');
  const btnCancelar = document.getElementById('btn-cancelar');
  const btnSalvar = document.getElementById('btn-salvar');
  const inNome = document.getElementById('in-nome');
  const inAno = document.getElementById('in-ano');
  const seletorCores = document.getElementById('seletor-cores');
  const boxErro = document.getElementById('modal-erro');
  const lista = document.getElementById('lista-turmas');
  const vazio = document.getElementById('empty-turmas');
  const nomeUsuario = document.getElementById('user-name');
  const linhaData = document.getElementById('welcome-message');
  const btnSair = document.getElementById('logout-btn');

  // Menu que abre ao clicar num card
  const menu = document.getElementById('menu-turma');
  const menuNome = document.getElementById('menu-turma-nome');

  // Modal de criar quiz
  const modalQuiz = document.getElementById('modal-quiz');
  const quizTurma = document.getElementById('quiz-turma');
  const quizNome = document.getElementById('quiz-nome');
  const quizQtd = document.getElementById('quiz-qtd');
  const quizTempo = document.getElementById('quiz-tempo');
  const quizErro = document.getElementById('quiz-erro');
  const quizResumo = document.getElementById('quiz-resumo');
  const quizFechar = document.getElementById('quiz-fechar');
  const quizCancelar = document.getElementById('quiz-cancelar');
  const quizSalvar = document.getElementById('quiz-salvar');

  // Modal de confirmar o "desfazer turma"
  const modalConfirma = document.getElementById('modal-confirma');
  const confirmaTexto = document.getElementById('confirma-texto');
  const confirmaErro = document.getElementById('confirma-erro');
  const confirmaFechar = document.getElementById('confirma-fechar');
  const confirmaNao = document.getElementById('confirma-nao');
  const confirmaSim = document.getElementById('confirma-sim');

  const COR_PADRAO = '#14b8a6'
  const LIMITE_PADRAO = 10;

  // Qual turma o menu está mirando no momento. Guardar o objeto inteiro
  // (e não só o id) evita ter que buscar a turma de novo a cada ação.
  let turmaDoMenu = null;

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    mostrarData();

    const perfil = await AUTH.perfilAtual();
    if (perfil && nomeUsuario) nomeUsuario.textContent = perfil.nome;

    await carregarTurmas();
  }

  function mostrarData() {
    if (!linhaData) return;
    const opts = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
    linhaData.textContent = new Date().toLocaleDateString('pt-BR', opts);
  }

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  })


  btnNova.addEventListener('click', abrirModal);
  btnFechar.addEventListener('click', fecharModal);
  btnCancelar.addEventListener('click', fecharModal);

  modal.addEventListener('click', (e) => {
    if (e.target === modal) fecharModal();
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !modal.hidden) fecharModal();
  });

  function abrirModal() {
    limparFormulario();
    modal.hidden = false;
    inNome.focus();
  }

  function fecharModal() {
    modal.hidden = true;
  }

  function limparFormulario() {
    inNome.value = '';
    inAno.selectedIndex = 0;
    esconderErro();

    seletorCores.querySelectorAll('.cor').forEach((b, i) => {
      b.classList.toggle('cor--ativa', i === 0);
    });
  }

  seletorCores.addEventListener('click', (e) => {
    const bolinha = e.target.closest('.cor');
    if (!bolinha) return;

    seletorCores.querySelectorAll('.cor').forEach(b => b.classList.remove('cor--ativa'));
    bolinha.classList.add('cor--ativa');
  });

  function corEscolhida() {
    const ativa = seletorCores.querySelector('.cor--ativa');
    return ativa ? ativa.dataset.cor : COR_PADRAO;
  }

 
  btnSalvar.addEventListener('click', salvarTurma);

  //Aqui vou fazer o save de turmas

  async function salvarTurma() {
    const nome = inNome.value.trim();

   
    if (nome.length < 2) {
      return mostrarErro('Dê um nome à turma. Ex: 7º Ano B');
    }

    esconderErro();

    btnSalvar.disabled = true;
    btnSalvar.textContent = 'Criando...';

    try {
      const turma = await API.criarTurma({
        nome,
        cor: corEscolhida(),
        ano_escolar: inAno.value
      });

      lista.appendChild(montarCard(turma, lista.children.length));
      atualizarVazio();
      fecharModal();

    } catch (err) {
      mostrarErro(err.message);

    } finally {
      btnSalvar.disabled = false;
      btnSalvar.textContent = 'Criar turma';
    }
  }

  function mostrarErro(msg) {
    if (!boxErro) { alert(msg); return; }
    boxErro.textContent = msg;
    boxErro.hidden = false;
  }
  function esconderErro() {
    if (!boxErro) return;
    boxErro.textContent = '';
    boxErro.hidden = true;
  }

  async function carregarTurmas() {
    try {
      const turmas = await API.getMinhasTurmas();

      lista.innerHTML = '';
      turmas.forEach((t, i) => lista.appendChild(montarCard(t, i)));
      atualizarVazio();

    } catch (err) {
      lista.innerHTML = '';
      const aviso = document.createElement('p');
      aviso.className = 'turmas-erro';
      aviso.textContent = err.message;
      lista.appendChild(aviso);
      if (vazio) vazio.hidden = true;
    }
  }

  function atualizarVazio() {
    if (!vazio) return;
    vazio.hidden = lista.children.length > 0;
  }

  function montarCard(t, ordem = 0) { // - >  verificar a origem da variável
    const card = document.createElement('article');
    card.className = 'turma-card';
    card.dataset.id = t.id;

    card.style.setProperty('--cor', t.cor || COR_PADRAO);
    // O --i faz cada card entrar um pouquinho depois do anterior (CSS).
    card.style.setProperty('--i', ordem);

    // A turma inteira fica pendurada no card. Assim o menu sabe o nome,
    // a cor e quantos alunos tem sem precisar consultar de novo.
    card.__turma = t;

    card.innerHTML = `
      <span class="turma-card__tarja"></span>
      <div class="turma-card__corpo">
        <div class="turma-card__topo">
          <div class="turma-card__info">
            <h4 class="turma-card__nome"></h4>
            <p  class="turma-card__ano"></p>
          </div>
          <span class="turma-card__pistas" aria-hidden="true">&#8942;</span>
        </div>
        <div class="turma-card__rodape">
          <span class="turma-card__alunos"></span>
          <button type="button" class="turma-card__codigo" title="Clique para copiar o código">
            <span class="turma-card__codigo-txt"></span>
          </button>
        </div>
      </div>
    `;

    card.querySelector('.turma-card__nome').textContent = t.nome;
    card.querySelector('.turma-card__ano').textContent = t.ano_escolar || '';
    card.querySelector('.turma-card__alunos').textContent =
      `${t.total_alunos ?? 0}/${t.limite_alunos ?? LIMITE_PADRAO}`;

    const botaoCodigo = card.querySelector('.turma-card__codigo');
    botaoCodigo.querySelector('.turma-card__codigo-txt').textContent = t.codigo || '—';
    botaoCodigo.addEventListener('click', (e) => {
      // Sem isto o clique subiria até o card e abriria o menu junto.
      e.stopPropagation();
      copiarCodigo(botaoCodigo, t.codigo);
    });

    card.addEventListener('click', () => abrirMenu(card));

    return card;

  }

  async function copiarCodigo(botao, codigo) {
    if (!codigo) return;

    const alvo = botao.querySelector('.turma-card__codigo-txt');
    if (!alvo) return;
    const original = alvo.textContent;


    try {
      await navigator.clipboard.writeText(codigo);    //--analisar o navigator
    } catch (_) {
      copiarNaMarra(codigo);
    }

    alvo.textContent = 'Copiado';
    botao.classList.add('copiado');     //analisar class list

    setTimeout(() => {   //analisar o Timeout
      alvo.textContent = original;
      botao.classList.remove('copiado');
    }, 1200);

  }

  function copiarNaMarra(texto) {
    const campo = document.createElement('textarea');
    campo.value = texto;
    campo.setAttribute('readonly', '');
    campo.style.position = 'fixed';
    campo.style.opacity = '0';
    document.body.appendChild(campo);
    campo.select();
    document.execCommand('copy');
    campo.remove();
  }

  /* ═══════════════════════════════════════════════════════════════════
     MENU DO CARD

     Existe UM menu na página, e ele é reaproveitado: ao clicar num card,
     o JS escreve o nome da turma nele e o posiciona ali embaixo. Um menu
     por card daria 30 menus escondidos numa tela com 30 turmas.
     ═══════════════════════════════════════════════════════════════════ */

  let turmaDoQuiz = null;
  let turmaParaExcluir = null;

  function abrirMenu(card) {
    const turma = card.__turma;
    if (!turma) return;

    // Clicar de novo no mesmo card fecha, como um interruptor.
    if (!menu.hidden && turmaDoMenu && turmaDoMenu.id === turma.id) {
      return fecharMenu();
    }

    fecharMenu();

    turmaDoMenu = turma;
    card.classList.add('menu-aberto');
    menuNome.textContent = turma.nome;

    // Precisa estar visível ANTES de medir: um elemento escondido tem
    // largura e altura zero, e a conta de posição sairia errada.
    menu.hidden = false;
    posicionarMenu(card);
  }

  function fecharMenu() {
    menu.hidden = true;
    turmaDoMenu = null;
    document.querySelectorAll('.turma-card.menu-aberto')
      .forEach(c => c.classList.remove('menu-aberto'));
  }

  /**
   * Encosta o menu embaixo do card.
   *
   * As contas somam scrollX/scrollY porque getBoundingClientRect() mede
   * a partir da JANELA, e o menu é posicionado a partir da PÁGINA. Sem
   * essa soma, o menu erra o lugar assim que a página está rolada.
   */
  function posicionarMenu(card) {
    const alvo = card.getBoundingClientRect();
    const cx = menu.getBoundingClientRect();

    let x = alvo.left + window.scrollX;
    let y = alvo.bottom + window.scrollY + 6;

    // Não deixa escapar pela direita.
    const limiteX = window.scrollX + window.innerWidth - cx.width - 12;
    if (x > limiteX) x = limiteX;

    // Se não couber embaixo, abre para cima.
    const limiteY = window.scrollY + window.innerHeight - cx.height - 12;
    if (y > limiteY) y = alvo.top + window.scrollY - cx.height - 6;

    menu.style.left = `${Math.max(12, x)}px`;
    menu.style.top = `${Math.max(12, y)}px`;
  }

  // Clique em qualquer outro lugar fecha o menu. O card é exceção: ele
  // já tem o próprio tratamento, que abre e fecha.
  document.addEventListener('click', (e) => {
    if (menu.hidden) return;
    if (menu.contains(e.target)) return;
    if (e.target.closest('.turma-card')) return;
    fecharMenu();
  });

  // Rolar ou redimensionar deixaria o menu solto longe do card.
  window.addEventListener('resize', fecharMenu);
  window.addEventListener('scroll', fecharMenu, { passive: true });

  // Um escutador só para os três itens: qual foi clicado está no data-acao.
  menu.addEventListener('click', (e) => {
    const item = e.target.closest('.menu-turma__item');
    if (!item || !turmaDoMenu) return;

    const turma = turmaDoMenu;
    fecharMenu();

    if (item.dataset.acao === 'info') return irParaInformacoes(turma);
    if (item.dataset.acao === 'quiz') return abrirQuiz(turma);
    if (item.dataset.acao === 'excluir') return pedirConfirmacao(turma);
  });

  function irParaInformacoes(turma) {
    window.location.href = `turma.html?id=${encodeURIComponent(turma.id)}`;
  }


  /* ═══════════════════════════════════════════════════════════════════
     CRIAR QUIZ

     A tela está pronta; a rota no servidor ainda não (Tópico 2). Por
     isso o botão NÃO diz "quiz criado" — ele mostra exatamente o que
     será enviado quando o servidor existir. Fingir sucesso é o tipo de
     bug mais caro de achar depois.
     ═══════════════════════════════════════════════════════════════════ */

  function abrirQuiz(turma) {
    turmaDoQuiz = turma;

    quizTurma.textContent = `para a turma ${turma.nome}`;
    quizNome.value = '';
    quizQtd.value = 10;
    quizTempo.value = '20';

    quizErro.hidden = true;
    quizResumo.hidden = true;

    // Nível volta para o 1; cenários e áreas voltam todos desmarcados.
    marcarSomenteOPrimeiro('quiz-nivel');
    desmarcarTudo('quiz-cenarios');
    desmarcarTudo('quiz-areas');

    modalQuiz.hidden = false;
    quizNome.focus();
  }

  function fecharQuiz() {
    modalQuiz.hidden = true;
    turmaDoQuiz = null;
  }

  quizFechar.addEventListener('click', fecharQuiz);
  quizCancelar.addEventListener('click', fecharQuiz);
  modalQuiz.addEventListener('click', (e) => {
    if (e.target === modalQuiz) fecharQuiz();
  });

  // Ligar e desligar as etiquetas. Um escutador só para todas: o grupo
  // diz, no data-escolha, se aceita "uma" (igual a um rádio) ou "varias".
  modalQuiz.addEventListener('click', (e) => {
    const chip = e.target.closest('.chip');
    if (!chip) return;

    const grupo = chip.parentElement;

    if (grupo.dataset.escolha === 'uma') {
      grupo.querySelectorAll('.chip').forEach(c => c.classList.remove('chip--ativo'));
      chip.classList.add('chip--ativo');
    } else {
      chip.classList.toggle('chip--ativo');
    }
  });

  quizSalvar.addEventListener('click', () => {
    const titulo = quizNome.value.trim();

    if (titulo.length < 2) {
      return avisar(quizErro, 'Dê um título ao quiz. Ex: Revisão de Dengue');
    }

    const cenarios = valoresMarcados('quiz-cenarios');
    if (cenarios.length === 0) {
      return avisar(quizErro, 'Escolha pelo menos um cenário de onde tirar as perguntas.');
    }

    quizErro.hidden = true;

    const config = {
      turma_id: turmaDoQuiz ? turmaDoQuiz.id : null,
      titulo,
      nivel_etario: Number(valoresMarcados('quiz-nivel')[0] || 1),
      cenarios,
      areas: valoresMarcados('quiz-areas'),
      qtd_questoes: Number(quizQtd.value),
      tempo_limite_segundos: Number(quizTempo.value)
    };

    quizResumo.hidden = false;
    quizResumo.textContent =
      'Ainda não existe rota no servidor para salvar quiz.\n' +
      'Quando existir, será enviado exatamente isto:\n\n' +
      JSON.stringify(config, null, 2);
  });

  function valoresMarcados(idGrupo) {
    const grupo = document.getElementById(idGrupo);
    if (!grupo) return [];

    return Array.from(grupo.querySelectorAll('.chip--ativo'))
      .map(c => c.dataset.valor);
  }

  function marcarSomenteOPrimeiro(idGrupo) {
    const grupo = document.getElementById(idGrupo);
    if (!grupo) return;

    grupo.querySelectorAll('.chip').forEach((c, i) => {
      c.classList.toggle('chip--ativo', i === 0);
    });
  }

  function desmarcarTudo(idGrupo) {
    const grupo = document.getElementById(idGrupo);
    if (!grupo) return;
    grupo.querySelectorAll('.chip').forEach(c => c.classList.remove('chip--ativo'));
  }


  /* ═══════════════════════════════════════════════════════════════════
     DESFAZER TURMA

     É o único botão desta tela sem volta, então passa por uma pergunta
     antes. O aluno NÃO é apagado junto: ele só fica sem turma, e o
     progresso dele continua inteiro.
     ═══════════════════════════════════════════════════════════════════ */

  function pedirConfirmacao(turma) {
    turmaParaExcluir = turma;

    const alunos = turma.total_alunos ?? 0;
    const recado = alunos > 0
      ? ` será desfeita. Os ${alunos} aluno(s) dela ficam sem turma, mas nada do que já fizeram é apagado — podem entrar em outra turma com um código novo.`
      : ' será desfeita. Ela ainda não tem nenhum aluno.';

    const negrito = document.createElement('strong');
    negrito.textContent = turma.nome;

    confirmaTexto.replaceChildren(
      document.createTextNode('A turma '),
      negrito,
      document.createTextNode(recado)
    );

    confirmaErro.hidden = true;
    modalConfirma.hidden = false;
    confirmaNao.focus();
  }

  function fecharConfirma() {
    modalConfirma.hidden = true;
    turmaParaExcluir = null;
  }

  confirmaFechar.addEventListener('click', fecharConfirma);
  confirmaNao.addEventListener('click', fecharConfirma);
  modalConfirma.addEventListener('click', (e) => {
    if (e.target === modalConfirma) fecharConfirma();
  });

  confirmaSim.addEventListener('click', async () => {
    if (!turmaParaExcluir) return;

    const turma = turmaParaExcluir;

    confirmaSim.disabled = true;
    confirmaSim.textContent = 'Desfazendo...';

    try {
      await API.excluirTurma(turma.id);

      const card = lista.querySelector(`.turma-card[data-id="${turma.id}"]`);

      if (card) {
        // Sai encolhendo em vez de sumir de uma vez: o professor vê qual
        // card foi embora.
        card.classList.add('saindo');
        setTimeout(() => {
          card.remove();
          atualizarVazio();
        }, 280);
      }

      fecharConfirma();

    } catch (err) {
      avisar(confirmaErro, err.message);

    } finally {
      confirmaSim.disabled = false;
      confirmaSim.textContent = 'Desfazer';
    }
  });


  /* ═══════════════════════════════════════════════════════════════════
     DETALHES DE TELA
     ═══════════════════════════════════════════════════════════════════ */

  /** Escreve uma mensagem numa caixinha de aviso e a revela. */
  function avisar(caixa, mensagem) {
    if (!caixa) { alert(mensagem); return; }
    caixa.textContent = mensagem;
    caixa.hidden = false;
  }

  // Esc fecha o que estiver aberto, do mais "de cima" para o mais "de baixo".
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;

    if (!menu.hidden) return fecharMenu();
    if (!modalQuiz.hidden) return fecharQuiz();
    if (!modalConfirma.hidden) return fecharConfirma();
  });

  // ── O fundo acompanha o mouse, de leve ────────────────────────────
  //
  // O requestAnimationFrame existe para não recalcular a cada pixel do
  // mouse: o navegador dispara mousemove dezenas de vezes por segundo, e
  // sem essa trava a página engasga. O blob-3 fica de fora porque ele já
  // tem uma animação própria de transform — as duas brigariam.
  const blobsQueSeguem = document.querySelectorAll('.blob-1, .blob-2');
  let aguardandoQuadro = false;

  document.addEventListener('mousemove', (e) => {
    if (aguardandoQuadro) return;
    aguardandoQuadro = true;

    requestAnimationFrame(() => {
      const x = (e.clientX / window.innerWidth) - 0.5;
      const y = (e.clientY / window.innerHeight) - 0.5;

      blobsQueSeguem.forEach((b, i) => {
        const forca = (i + 1) * 16;
        b.style.transform = `translate(${x * forca}px, ${y * forca}px)`;
      });

      aguardandoQuadro = false;
    });
  });
})();
