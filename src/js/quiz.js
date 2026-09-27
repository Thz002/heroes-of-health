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
  const btnConfirmar = document.getElementById('quiz-confirmar');

  const foto = document.getElementById('missao-foto');
  const fotoInterior = document.getElementById('missao-interior');
  const fotoFamilia = document.getElementById('missao-familia');

  const fim = document.getElementById('fim');
  const fimPlacar = document.getElementById('fim-placar');
  const fimBarras = document.getElementById('fim-barras');
  const btnMais = document.getElementById('fim-continuar');

  const btnSair = document.getElementById('logout-btn');

  const LETRAS = ['A', 'B', 'C', 'D'];

  // Foto de dentro de cada lugar — as mesmas de src/imgs/Interiores que o
  // modal do mapa mostra (CENARIOS[tipo].interior em mapa.js). Mudou lá,
  // muda aqui.
  const INTERIORES = {
    parque: 'Parque.png',
    escola: 'Escola.jpg',
    farmacia: 'Farmacia.jpeg',
    upa: 'UPA.jpg',
    ubs: 'UBS.jpg',
    banca: 'Banca.jpg',
    praca: 'Praca.jpg',
    mercado: 'Mercado.jpg',
    creche: 'Creche.jpg',
    igreja: 'Igreja.jpg',
    quadra: 'Quadra.jpg',
    'terreno-baldio': 'Baldio.jpg',
    corrego: 'Corrego.png',
    rio: 'Rio.png',
    ruas: 'Ruas.jpg',
    casa: 'Casa.jpeg',
  };

  // Cada casa tem o seu interior, pelo número que o mapa manda em
  // ?casa= (o campo `casa` dos HOTSPOTS em mapa.js). O mesmo número
  // escolhe a família: casa 3 -> familia03.png.
  const INTERIORES_CASAS = {
    1: 'Casa.jpeg', 2: 'Casa02.jpeg', 3: 'Casa03.jpg', 4: 'Casa04.jpg',
    5: 'Casa05.jpg', 6: 'Casa06.jpg', 7: 'Casa07.jpg', 8: 'Casa08.jpg',
    9: 'Casa09.jpg', 10: 'Casa10.jpg', 11: 'Casa11.jpg', 12: 'Casa12.jpg',
    13: 'Casa13.jpg', 14: 'Casa14.jpg', 15: 'Casa15.jpg', 16: 'Casa16.jpg',
    17: 'CasaLateral01.jpg', 18: 'CasaLateral02.jpg',
    19: 'CasaLateral03.jpg', 20: 'CasaLateral04.jpg',
  };

  let missao = null;
  let quizAtual = null;   // null = exploração livre pelo mapa
  let rodada = [];        
  let indice = 0;         
  let sobrando = 0;       
  let acertos = 0;
  let ganhos = {};      
  let escolhida = null;   // { botao, letra } — marcada, ainda não confirmada

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
    const casa = Number(params.get('casa'));

    if (!idQuiz && !slug) {
      window.location.href = 'mapa.html';
      return;
    }

    if (slug) mostrarFoto(slug, casa);

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
    // Um quiz pode cobrir vários lugares; a foto é a do primeiro.
    if (r.cenarios && r.cenarios.length) mostrarFoto(r.cenarios[0], 0);
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
    escolhida = null;
    atualizarConfirmar();
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
      b.addEventListener('click', () => escolher(b, letra));
      opcoes.appendChild(b);
    });
  }

  // Clicar numa alternativa só a marca; quem responde é o "Confirmar".
  function escolher(botao, letra) {
    opcoes.querySelectorAll('.quiz-option--selecionada')
      .forEach(b => b.classList.remove('quiz-option--selecionada'));
    botao.classList.add('quiz-option--selecionada');
    escolhida = { botao, letra };
    atualizarConfirmar();
  }

  function atualizarConfirmar() {
    btnConfirmar.disabled = !escolhida;
    btnConfirmar.textContent = escolhida ? 'Confirmar resposta' : 'Escolha uma alternativa';
  }

  btnConfirmar.addEventListener('click', () => {
    if (!escolhida) return;
    const { botao, letra } = escolhida;
    escolhida = null;
    botao.classList.remove('quiz-option--selecionada');
    btnConfirmar.disabled = true;
    responder(botao, rodada[indice], letra);
  });

  async function responder(botao, questao, letra) {
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
        btnConfirmar.textContent = 'Resposta confirmada';

      } else {
        botao.classList.add('quiz-option--wrong');
        botao.disabled = true;

        explicacao.textContent = r.explicacao || '';
        pontosEl.textContent = 'Essa não era. Leia a dica e tente outra alternativa.';
        retorno.hidden = false;
        btnContinuar.hidden = true;

        travarOpcoes(false);
        botao.disabled = true;   
        atualizarConfirmar();
      }

    } catch (err) {
      travarOpcoes(false);
      atualizarConfirmar();
      pontosEl.textContent = err.message;
      retorno.hidden = false;
      btnContinuar.hidden = true;
    }
  }

  function travarOpcoes(travar) {
    opcoes.querySelectorAll('.quiz-option').forEach(b => { b.disabled = travar; });
  }

  // A foto quadrada da lateral. Numa casa conhecida, o interior fica
  // desfocado ao fundo e a família daquela casa aparece na frente.
  function mostrarFoto(slug, casa) {
    const interiorCasa = slug === 'casa' ? INTERIORES_CASAS[casa] : null;
    const interior = interiorCasa || INTERIORES[slug];
    if (!interior) return;

    fotoInterior.src = `../imgs/Interiores/${interior}`;
    fotoInterior.hidden = false;

    foto.classList.toggle('missao-lateral__foto--casa', Boolean(interiorCasa));
    if (interiorCasa) {
      fotoFamilia.src = `../imgs/familias/familia${String(casa).padStart(2, '0')}.png`;
      fotoFamilia.alt = 'Família que mora nesta casa';
      fotoFamilia.hidden = false;
      // Sem a imagem da família, volta a mostrar o interior nítido.
      fotoFamilia.onerror = () => {
        fotoFamilia.hidden = true;
        foto.classList.remove('missao-lateral__foto--casa');
      };
    }
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
