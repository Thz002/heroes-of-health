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

  const LETRAS = ['A', 'B', 'C', 'D'];

  let missao = null;
  let rodada = [];        
  let indice = 0;         
  let sobrando = 0;       
  let acertos = 0;
  let ganhos = {};      

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    const slug = new URLSearchParams(window.location.search).get('cenario');
    if (!slug) {
      window.location.href = 'mapa.html';
      return;
    }

    try {
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

  async function carregarRodada() {
    const r = await API.getQuestoes(missao.id);

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
  }

  async function responder(botao, questao, letra) {
    travarOpcoes(true);

    try {
      const r = await API.responder(questao.id, letra);

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
