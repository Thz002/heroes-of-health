/** quizzes.js — quizzes e perguntas do professor (quizzes.html), em duas abas.
    "+ Criar quiz" e "+ Criar pergunta" abrem os mesmos modais do painel. */
(() => {
  'use strict';

  const lista = document.getElementById('lista-quizzes');
  const vazio = document.getElementById('empty-quizzes');
  const total = document.getElementById('quizzes-total');
  const totalRotulo = document.getElementById('quizzes-total-rotulo');
  const subtitulo = document.getElementById('quizzes-subtitulo');

  const abas = document.getElementById('abas-pagina');
  const vistaQuizzes = document.getElementById('vista-quizzes');
  const vistaPerguntas = document.getElementById('vista-perguntas');
  const listaQuestoes = document.getElementById('lista-questoes');
  const vazioQuestoes = document.getElementById('empty-questoes');
  const btnNovaQuestao = document.getElementById('btn-nova-questao');
  const btnNovoQuiz = document.getElementById('btn-novo-quiz');

  const modalApagar = document.getElementById('modal-apagar');
  const apagarTitulo = document.getElementById('apagar-titulo');
  const apagarTexto = document.getElementById('apagar-texto');
  const apagarErro = document.getElementById('apagar-erro');
  const apagarFechar = document.getElementById('apagar-fechar');
  const apagarNao = document.getElementById('apagar-nao');
  const apagarSim = document.getElementById('apagar-sim');

  // Nome e ícone dos lugares, e as cores das áreas: os mesmos do mapa,
  // guardados num lugar só (questoes-ui.js).
  const { LUGARES, AREAS } = QUESTOES_UI;

  const COR_PADRAO = '#14b8a6';

  const SUBTITULOS = {
    quizzes: 'Tudo o que você já passou para as suas turmas.',
    perguntas: 'As perguntas que você escreveu. Só você as vê.'
  };

  let vista = 'quizzes';
  let totalQuizzes = 0;
  let questoes = null;          // null = ainda não carregou

  // O que o modal de confirmação vai apagar, e como.
  let confirmacao = null;

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Aluno volta para o jogo.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'ALUNO') {
      window.location.href = 'mapa.html';
      return;
    }

    trocarVista(window.location.hash === '#perguntas' ? 'perguntas' : 'quizzes');
    await carregar();
  }

  /* ── Abas ── */

  abas.addEventListener('click', (e) => {
    const aba = e.target.closest('.aba');
    if (aba) trocarVista(aba.dataset.vista);
  });

  function trocarVista(nova) {
    vista = nova === 'perguntas' ? 'perguntas' : 'quizzes';

    abas.querySelectorAll('.aba').forEach(a => {
      const ativa = a.dataset.vista === vista;
      a.classList.toggle('aba--ativa', ativa);
      a.setAttribute('aria-selected', String(ativa));
    });

    vistaQuizzes.hidden = vista !== 'quizzes';
    vistaPerguntas.hidden = vista !== 'perguntas';

    // replaceState não enche o histórico.
    history.replaceState(null, '', vista === 'perguntas' ? '#perguntas' : window.location.pathname);

    if (vista === 'perguntas' && questoes === null) carregarQuestoes();
    atualizarCabecalho();
  }

  function atualizarCabecalho() {
    if (vista === 'perguntas') {
      const n = questoes ? questoes.length : 0;
      if (total) total.textContent = n;
      if (totalRotulo) totalRotulo.textContent = n === 1 ? 'pergunta criada' : 'perguntas criadas';
      if (subtitulo) subtitulo.textContent = SUBTITULOS.perguntas;
    } else {
      if (total) total.textContent = totalQuizzes;
      if (totalRotulo) totalRotulo.textContent = 'quizes criados';
      if (subtitulo) {
        subtitulo.textContent = totalQuizzes > 0 ? 'Do mais recente para o mais antigo.' : SUBTITULOS.quizzes;
      }
    }
  }

  /* ── Meus quizzes ── */

  async function carregar() {
    try {
      const quizes = await API.getQuizzesCriados();

      lista.innerHTML = '';
      quizes.forEach((q, i) => lista.appendChild(montarLinha(q, i)));

      totalQuizzes = quizes.length;
      if (vazio) vazio.hidden = quizes.length > 0;
      atualizarCabecalho();

    } catch (err) {
      // Sem invenção: se não deu para carregar, a tela diz isso.
      mostrarFalha(lista, err.message);
      if (vazio) vazio.hidden = true;
    }
  }

  function montarLinha(q, ordem) {
    const slugs = Array.isArray(q.cenarios) ? q.cenarios : [];
    const principal = LUGARES[slugs[0]] || { nome: 'Bairro inteiro', imagem: 'UBS.png' };

    const linha = document.createElement('article');
    linha.className = 'quiz-linha';
    linha.dataset.id = q.id;
    linha.style.setProperty('--cor', q.turma_cor || COR_PADRAO);
    linha.style.setProperty('--i', ordem);

    linha.innerHTML = `
      <span class="quiz-linha__icone">
        <img alt="" loading="lazy">
      </span>

      <div class="quiz-linha__meio">
        <h4 class="quiz-linha__titulo">
          <span class="quiz-linha__nome"></span>
          <span class="quiz-linha__lugar"></span>
          <span class="quiz-linha__turma"></span>
        </h4>
        <div class="quiz-linha__tags"></div>
      </div>

      <div class="quiz-linha__numeros">
        <span class="quiz-linha__perguntas"></span>
        <span class="quiz-linha__tempo"></span>
      </div>

      <button type="button" class="quiz-linha__apagar" title="Apagar este quiz" aria-label="Apagar">&times;</button>
    `;

    linha.querySelector('img').src = `../imgs/${principal.imagem}`;

    // textContent: texto escrito por pessoas.
    linha.querySelector('.quiz-linha__nome').textContent = q.titulo;
    linha.querySelector('.quiz-linha__lugar').textContent =
      `— ${principal.nome}${slugs.length > 1 ? ` +${slugs.length - 1}` : ''}`;

    const turma = linha.querySelector('.quiz-linha__turma');
    turma.textContent = q.turma_nome ? `· ${q.turma_nome}` : '';

    // ── As etiquetas de área ────────────────────────────────────────
    const caixaTags = linha.querySelector('.quiz-linha__tags');
    const areas = Array.isArray(q.areas) ? q.areas : [];

    if (areas.length === 0) {
      const tag = document.createElement('span');
      tag.className = 'quiz-tag quiz-tag--vazia';
      tag.textContent = 'sem área definida';
      caixaTags.appendChild(tag);
    } else {
      areas.forEach(nome => caixaTags.appendChild(montarTag(nome)));
    }

    // ── Os números da direita ───────────────────────────────────────
    const perguntas = q.total_questoes ?? 0;
    linha.querySelector('.quiz-linha__perguntas').textContent =
      `${perguntas} ${perguntas === 1 ? 'pergunta' : 'perguntas'}`;

    // Avisa quando o sorteio trouxe menos que o pedido.
    if (q.qtd_pedida && perguntas < q.qtd_pedida) {
      linha.querySelector('.quiz-linha__perguntas').title =
        `Você pediu ${q.qtd_pedida}, mas só havia ${perguntas} disponíveis.`;
      linha.querySelector('.quiz-linha__perguntas').classList.add('quiz-linha__perguntas--menos');
    }

    linha.querySelector('.quiz-linha__tempo').textContent =
      `${formatarTempo(q.tempo_limite_segundos)} por pergunta`;

    linha.querySelector('.quiz-linha__apagar')
      .addEventListener('click', () => confirmarApagarQuiz(q));

    return linha;
  }

  function montarTag(nome) {
    const tag = document.createElement('span');
    tag.className = 'quiz-tag';
    tag.style.setProperty('--tag-cor', AREAS[nome] || '#6bdfb8');
    tag.textContent = nome;
    return tag;
  }

  /** 20 -> "20s"; 60 -> "1 min"; 90 -> "1min30s" */
  function formatarTempo(segundos) {
    const s = Number(segundos);
    if (!Number.isFinite(s) || s <= 0) return 'sem limite';

    if (s < 60) return `${s}s`;

    const minutos = Math.floor(s / 60);
    const resto = s % 60;
    return resto ? `${minutos}min${resto}s` : `${minutos} min`;
  }

  /* ── Minhas perguntas ── */

  async function carregarQuestoes() {
    try {
      questoes = await API.getQuestoesProfessor({ origem: 'minhas' });
      desenharQuestoes();
    } catch (err) {
      questoes = null;   // tenta de novo na próxima vez que a aba abrir
      mostrarFalha(listaQuestoes, err.message);
      if (vazioQuestoes) vazioQuestoes.hidden = true;
    }
  }

  function desenharQuestoes() {
    listaQuestoes.replaceChildren(...questoes.map((q, i) => {
      const cartao = QUESTOES_UI.cartaoQuestao(q, { aoApagar: confirmarApagarQuestao });
      cartao.style.setProperty('--i', i);
      return cartao;
    }));

    if (vazioQuestoes) vazioQuestoes.hidden = questoes.length > 0;
    atualizarCabecalho();
  }

  // Mesmo modal de criar quiz, com seletor de turma.
  btnNovoQuiz.addEventListener('click', () => {
    QUIZ_MODAL.abrir({
      aoCriar: () => {
        trocarVista('quizzes');
        carregar();
      }
    });
  });

  // Mesmo modal de nova pergunta.
  btnNovaQuestao.addEventListener('click', () => {
    QUESTOES_UI.abrirCriacao({
      aoCriar: (q) => {
        // A nova pergunta entra no topo da lista.
        if (questoes !== null) questoes.unshift(q);
        trocarVista('perguntas');
        if (questoes !== null) desenharQuestoes();
      }
    });
  });

  /* ── Apagar (confirmação para as duas abas) ── */

  function confirmarApagarQuiz(q) {
    abrirConfirmacao({
      titulo: 'Apagar quiz',
      nome: q.titulo,
      antes: 'O quiz ',
      depois: ' some da lista da turma. O que os alunos já responderam continua guardado — o que se perde é a tarefa em si.',
      acao: () => API.excluirQuiz(q.id),
      depoisDeApagar: () => {
        removerComAnimacao(lista.querySelector(`.quiz-linha[data-id="${q.id}"]`), () => {
          totalQuizzes = lista.querySelectorAll('.quiz-linha').length;
          if (vazio) vazio.hidden = totalQuizzes > 0;
          atualizarCabecalho();
        });
      }
    });
  }

  function confirmarApagarQuestao(q) {
    const curto = q.enunciado.length > 80 ? `${q.enunciado.slice(0, 80)}…` : q.enunciado;

    abrirConfirmacao({
      titulo: 'Apagar pergunta',
      nome: `“${curto}”`,
      antes: 'A pergunta ',
      depois: ' será apagada para sempre. Só dá para apagar enquanto nenhum aluno a respondeu e ela não está em nenhum quiz.',
      acao: () => API.excluirQuestao(q.id),
      depoisDeApagar: () => {
        questoes = questoes.filter(x => x.id !== q.id);
        removerComAnimacao(listaQuestoes.querySelector(`.questao-card[data-id="${q.id}"]`), () => {
          if (vazioQuestoes) vazioQuestoes.hidden = questoes.length > 0;
          atualizarCabecalho();
        });
      }
    });
  }

  function abrirConfirmacao(c) {
    confirmacao = c;

    if (apagarTitulo) apagarTitulo.textContent = c.titulo;

    const negrito = document.createElement('strong');
    negrito.textContent = c.nome;
    apagarTexto.replaceChildren(
      document.createTextNode(c.antes),
      negrito,
      document.createTextNode(c.depois)
    );

    apagarErro.hidden = true;
    modalApagar.hidden = false;
    apagarNao.focus();
  }

  function fecharApagar() {
    modalApagar.hidden = true;
    confirmacao = null;
  }

  apagarFechar.addEventListener('click', fecharApagar);
  apagarNao.addEventListener('click', fecharApagar);
  modalApagar.addEventListener('click', (e) => {
    if (e.target === modalApagar) fecharApagar();
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !modalApagar.hidden) fecharApagar();
  });

  apagarSim.addEventListener('click', async () => {
    if (!confirmacao) return;

    const alvo = confirmacao;

    apagarSim.disabled = true;
    apagarSim.textContent = 'Apagando...';

    try {
      await alvo.acao();
      alvo.depoisDeApagar();
      fecharApagar();

    } catch (err) {
      apagarErro.textContent = err.message;
      apagarErro.hidden = false;

    } finally {
      apagarSim.disabled = false;
      apagarSim.textContent = 'Apagar';
    }
  });

  /* ── Detalhes de tela ── */

  function removerComAnimacao(elemento, depois) {
    if (!elemento) return depois();
    elemento.classList.add('saindo');
    setTimeout(() => {
      elemento.remove();
      depois();
    }, 280);
  }

  function mostrarFalha(caixa, mensagem) {
    caixa.innerHTML = '';
    const aviso = document.createElement('p');
    aviso.className = 'turmas-erro';
    aviso.textContent = mensagem;
    caixa.appendChild(aviso);
  }

})();
