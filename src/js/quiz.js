(() => {
  'use strict';

  const topo = document.getElementById('missao-topo');
  const titulo = document.getElementById('missao-titulo');
  const descricao = document.getElementById('missao-descricao');
  const passo = document.getElementById('missao-passo');
  const restantes = document.getElementById('missao-restantes');

  const aviso = document.getElementById('missao-aviso');
  const avisoTitulo = document.getElementById('aviso-titulo');
  const avisoTexto = document.getElementById('aviso-texto');
  const avisoAcoes = document.getElementById('aviso-acoes');

  const quiz = document.getElementById('quiz');
  const enunciado = document.getElementById('quiz-enunciado');
  const opcoes = document.getElementById('quiz-opcoes');
  const retorno = document.getElementById('quiz-retorno');
  const explicacao = document.getElementById('quiz-explicacao');
  const pontosEl = document.getElementById('quiz-pontos');
  const btnContinuar = document.getElementById('quiz-continuar');

  const fim = document.getElementById('fim');
  const fimPlacar = document.getElementById('fim-placar');
  const fimBarras = document.getElementById('fim-barras');
  const btnMais = document.getElementById('fim-continuar');

  const btnSair = document.getElementById('logout-btn');

  // O relógio da tarefa da professora
  const cronometroBox = document.getElementById('missao-cronometro');
  const tempoEl = document.getElementById('missao-tempo');
  const barraTempo = document.getElementById('quiz-tempo-barra');

  const LETRAS = ['A', 'B', 'C', 'D'];

  // Segundos por pergunta, escolhidos pela professora ao criar o quiz.
  // 0 = sem limite, que é o caso da exploração livre pelo mapa.
  let tempoLimite = 0;
  let sobrandoSeg = 0;
  let relogio = null;   // o setInterval em andamento

  let missao = null;
  let quizAtual = null;   // null = exploração livre pelo mapa
  let rodada = [];        
  let indice = 0;         
  let sobrando = 0;       
  let acertos = 0;
  let ganhos = {};      

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Dois modos, decididos pela URL:
    //   ?quiz=7      -> tarefa da professora, com a lista já congelada
    //   ?cenario=ubs -> exploração livre, sorteando uma rodada do lugar
    const params = new URLSearchParams(window.location.search);
    const idQuiz = Number(params.get('quiz'));
    const slug = params.get('cenario');

    if (!idQuiz && !slug) {
      window.location.href = 'mapa.html';
      return;
    }

    try {
      if (idQuiz) {
        await carregarQuiz(idQuiz);
        return;
      }

      // O servidor já devolve só as missões da faixa etária desta pessoa.
      const missoes = await API.getMissoes(slug);

      if (!missoes.length) {
        return mostrarAviso(
          'Nada por aqui ainda',
          'Este ponto do mapa ainda não tem missão para a sua idade. Tente outro lugar!');
      }

      missao = missoes[0];
      await carregarRodada();

    } catch (err) {
      if (err.status === 404) {
        return mostrarAviso(
          'Só de passagem',
          'Este lugar do bairro ainda não tem missão. Volte ao mapa e procure um ponto com tarefa.');
      }
      mostrarAviso('Não foi possível carregar', err.message);
    }
  }

  // A tarefa da professora: a lista já foi sorteada e congelada quando
  // ela criou o quiz, então aqui não há sorteio — só se pula o que esta
  // pessoa já acertou, para quem parou no meio continuar de onde estava.
  async function carregarQuiz(id) {
    const r = await API.getQuestoesDoQuiz(id);

    quizAtual = { id: r.id, titulo: r.titulo, descricao: r.descricao };

    // O tempo vem do quiz, não da tela: foi a professora que escolheu, e
    // vale igual para a turma inteira.
    tempoLimite = Number(r.tempo_limite_segundos) || 0;

    rodada = r.questoes || [];
    sobrando = r.restantes || 0;
    indice = 0;
    acertos = 0;
    ganhos = {};

    if (!rodada.length) {
      return mostrarAviso(
        'Tarefa concluída!',
        `Você já acertou as ${r.total} questões que a professora passou. Bom trabalho!`);
    }

    aviso.hidden = true;
    fim.hidden = true;
    topo.hidden = false;
    titulo.textContent = r.titulo;
    descricao.textContent = r.descricao || 'Tarefa da professora para a sua turma.';
    document.title = `${r.titulo} - Heróis da Saúde`;

    mostrarQuestao();
  }

  async function carregarRodada() {
    const r = await API.getQuestoes(missao.id);

    // Exploração livre: sem professora, sem relógio.
    tempoLimite = 0;

    rodada = r.questoes || [];
    sobrando = r.restantes || 0;
    indice = 0;
    acertos = 0;
    ganhos = {};

    if (!rodada.length) {
      return mostrarAviso(
        'Você já concluiu tudo aqui!',
        `Acertou todas as ${r.total} questões deste lugar. Procure outro ponto do mapa.`);
    }

    aviso.hidden = true;
    fim.hidden = true;
    topo.hidden = false;
    titulo.textContent = missao.titulo;
    descricao.textContent = missao.descricao || '';

    mostrarQuestao();
  }

  function mostrarQuestao() {
    const q = rodada[indice];

    passo.textContent = `${indice + 1}/${rodada.length}`;
    restantes.textContent = sobrando;

    enunciado.textContent = q.enunciado;
    retorno.hidden = true;
    quiz.hidden = false;
    btnContinuar.hidden = false;   // a resposta errada esconde; aqui volta

    opcoes.innerHTML = '';
    LETRAS.forEach((letra) => {
      const texto = q['opcao_' + letra.toLowerCase()];
      if (!texto) return;

      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'quiz-option';
      b.dataset.letra = letra;
      b.textContent = `${letra}) ${texto}`;
      b.addEventListener('click', () => responder(b, q, letra));
      opcoes.appendChild(b);
    });

    comecarRelogio();
  }

  /* ═══════════════════════════════════════════════════════════════════
     O RELÓGIO DA PERGUNTA

     Só existe em tarefa da professora. O tempo é o mesmo para todas as
     perguntas do quiz — foi escolhido uma vez, na criação, e vale para a
     turma inteira.

     Quando acaba, a pergunta NÃO conta como erro: ela simplesmente fica
     sem resposta e volta numa próxima rodada. Marcar erro por demora
     puniria quem leu devagar, e o jogo não é sobre isso.
     ═══════════════════════════════════════════════════════════════════ */

  function comecarRelogio() {
    pararRelogio();

    if (!tempoLimite) {
      if (cronometroBox) cronometroBox.hidden = true;
      if (barraTempo) barraTempo.hidden = true;
      return;
    }

    sobrandoSeg = tempoLimite;

    if (cronometroBox) cronometroBox.hidden = false;
    if (barraTempo) barraTempo.hidden = false;

    pintarRelogio();

    relogio = setInterval(() => {
      sobrandoSeg--;
      pintarRelogio();

      if (sobrandoSeg <= 0) esgotou();
    }, 1000);
  }

  function pararRelogio() {
    if (relogio) clearInterval(relogio);
    relogio = null;
  }

  /** Continua de onde parou, sem reiniciar a contagem. */
  function retomarRelogio() {
    if (!tempoLimite || relogio || sobrandoSeg <= 0) return;

    relogio = setInterval(() => {
      sobrandoSeg--;
      pintarRelogio();

      if (sobrandoSeg <= 0) esgotou();
    }, 1000);
  }

  function pintarRelogio() {
    if (tempoEl) tempoEl.textContent = `${Math.max(0, sobrandoSeg)}s`;

    if (barraTempo) {
      const fatia = Math.max(0, sobrandoSeg) / tempoLimite;
      barraTempo.querySelector('i').style.width = `${fatia * 100}%`;
      // Os últimos 5 segundos ficam vermelhos: é o aviso de que acabou.
      barraTempo.classList.toggle('quiz-tempo--acabando', sobrandoSeg <= 5);
    }

    if (cronometroBox) {
      cronometroBox.classList.toggle('dado--acabando', sobrandoSeg <= 5);
    }
  }

  function esgotou() {
    pararRelogio();
    travarOpcoes(true);

    explicacao.textContent =
      'Sem problema: esta pergunta volta numa próxima rodada, e nada foi descontado.';
    pontosEl.textContent = 'O tempo desta pergunta acabou.';

    btnContinuar.hidden = false;
    btnContinuar.textContent = indice + 1 < rodada.length ? 'Próxima questão' : 'Ver resultado';
    retorno.hidden = false;
  }

  async function responder(botao, questao, letra) {
    pararRelogio();          // respondeu: o relógio desta pergunta morre aqui
    travarOpcoes(true);

    try {
      const r = await API.responder(questao.id, letra, quizAtual ? quizAtual.id : null);

      if (r.acertou) {
        botao.classList.add('quiz-option--correct');
        acertos++;
        (r.pontos || []).forEach(p => {
          ganhos[p.area] = (ganhos[p.area] || 0) + p.pontos;
        });
        sobrando = Math.max(0, sobrando - 1);
        restantes.textContent = sobrando;

        explicacao.textContent = r.explicacao || '';
        pontosEl.textContent = resumirPontos(r.pontos);
        btnContinuar.textContent = indice + 1 < rodada.length ? 'Próxima questão' : 'Ver resultado';
        retorno.hidden = false;

      } else {
        botao.classList.add('quiz-option--wrong');
        botao.disabled = true;

        explicacao.textContent = r.explicacao || '';
        pontosEl.textContent = 'Essa não era. Leia a dica e tente outra alternativa.';
        retorno.hidden = false;
        btnContinuar.hidden = true;

        travarOpcoes(false);
        botao.disabled = true;

        // Errou mas pode tentar outra alternativa — o relógio volta a
        // correr de onde parou. O tempo é da pergunta, não da tentativa.
        retomarRelogio();
      }

    } catch (err) {
      travarOpcoes(false);
      pontosEl.textContent = err.message;
      retorno.hidden = false;
      btnContinuar.hidden = true;
    }
  }

  function travarOpcoes(travar) {
    opcoes.querySelectorAll('.quiz-option').forEach(b => { b.disabled = travar; });
  }

  function resumirPontos(pontos) {
    if (!pontos || !pontos.length) return 'Boa! Você acertou.';
    return 'Boa! ' + pontos.map(p => `+${p.pontos} em ${p.area}`).join(', ') + '.';
  }

  btnContinuar.addEventListener('click', () => {
    indice++;
    btnContinuar.hidden = false;

    if (indice < rodada.length) {
      mostrarQuestao();
    } else {
      mostrarFim();
    }
  });

  function mostrarFim() {
    pararRelogio();
    quiz.hidden = true;
    topo.hidden = true;
    fim.hidden = false;

    fimPlacar.textContent =
      `Você acertou ${acertos} de ${rodada.length} nesta rodada.`;

    const linhas = Object.entries(ganhos);
    fimBarras.innerHTML = '';
    if (linhas.length) {
      linhas.forEach(([area, pts]) => {
        const p = document.createElement('p');
        p.style.fontSize = '14.5px';
        p.textContent = `+${pts} pontos em ${area}`;
        fimBarras.appendChild(p);
      });
    }

    btnMais.hidden = sobrando <= 0;
  }

  btnMais.addEventListener('click', async () => {
    try {
      await carregarRodada();
    } catch (err) {
      mostrarAviso('Não foi possível carregar', err.message);
    }
  });

  function mostrarAviso(tit, txt) {
    pararRelogio();
    topo.hidden = true;
    quiz.hidden = true;
    fim.hidden = true;
    aviso.hidden = false;
    avisoTitulo.textContent = tit;
    avisoTexto.textContent = txt;
    avisoAcoes.hidden = false;
  }

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });
})();
