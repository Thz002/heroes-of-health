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


  // O relógio da tarefa da professora
  const cronometroBox = document.getElementById('missao-cronometro');
  const tempoEl = document.getElementById('missao-tempo');
  const barraTempo = document.getElementById('quiz-tempo-barra');

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

  // Segundos por pergunta, escolhidos pela professora ao criar o quiz.
  // 0 = sem limite.
  let tempoLimite = 0;
  let sobrandoSeg = 0;
  let relogio = null;   // o setInterval em andamento

  let quizAtual = null;
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

    // Só se joga dentro de uma missão, que é o quiz passado pelo
    // professor: ?quiz=7. O mapa manda junto o lugar e a casa clicados
    // (?cenario=casa&casa=3), que servem só para escolher a foto.
    const params = new URLSearchParams(window.location.search);
    const idQuiz = Number(params.get('quiz'));
    const slug = params.get('cenario');
    const casa = Number(params.get('casa'));

    if (!idQuiz) {
      window.location.href = 'mapa.html';
      return;
    }

    if (slug) mostrarFoto(slug, casa);

    try {
      await carregarQuiz(idQuiz, !slug);
    } catch (err) {
      mostrarAviso('Não foi possível carregar', err.message);
    }
  }

  // A lista já foi sorteada e congelada quando o professor criou o quiz,
  // então aqui não há sorteio — só se pula o que esta pessoa já acertou,
  // para quem parou no meio continuar de onde estava.
  async function carregarQuiz(id, fotoDoQuiz) {
    const r = await API.getQuestoesDoQuiz(id);

    quizAtual = { id: r.id, titulo: r.titulo, descricao: r.descricao };
    // Aberto pela lista, sem lugar clicado: a foto é a do primeiro lugar
    // que o quiz cobre.
    if (fotoDoQuiz && r.cenarios && r.cenarios.length) mostrarFoto(r.cenarios[0], 0);

    // O tempo vem do quiz, não da tela: foi o professor que escolheu, e
    // vale igual para a turma inteira.
    tempoLimite = Number(r.tempo_limite_segundos) || 0;

    rodada = r.questoes || [];
    sobrando = r.restantes || 0;
    indice = 0;
    acertos = 0;
    ganhos = {};

    if (!rodada.length) {
      return mostrarAviso(
        'Missão concluída!',
        `Você já acertou as ${r.total} questões que o professor passou. Bom trabalho!`);
    }

    aviso.hidden = true;
    fim.hidden = true;
    topo.hidden = false;
    titulo.textContent = r.titulo;
    descricao.textContent = r.descricao || 'Missão do professor para a sua turma.';
    document.title = `${r.titulo} - Heróis da Saúde`;

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
      b.addEventListener('click', () => escolher(b, letra));
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

    // A marcada e não confirmada não vale: o tempo acabou antes.
    opcoes.querySelectorAll('.quiz-option--selecionada')
      .forEach(b => b.classList.remove('quiz-option--selecionada'));
    escolhida = null;
    btnConfirmar.disabled = true;
    btnConfirmar.textContent = 'Tempo esgotado';

    explicacao.textContent =
      'Sem problema: esta pergunta volta numa próxima rodada, e nada foi descontado.';
    pontosEl.textContent = 'O tempo desta pergunta acabou.';

    btnContinuar.hidden = false;
    btnContinuar.textContent = indice + 1 < rodada.length ? 'Próxima questão' : 'Ver resultado';
    retorno.hidden = false;
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
    pararRelogio();          // respondeu: o relógio desta pergunta morre aqui
    travarOpcoes(true);

    try {
      const r = await API.responder(questao.id, letra, quizAtual.id);

      // A barra de nível sobe AGORA, no acerto, e não só na próxima
      // troca de página. É o feedback que faltava: o aluno via o XP
      // parado e não ligava o número ao que acabou de fazer.
      if (r.nivel && window.NIVEL) window.NIVEL.atualizar(r.nivel, r.xp);

      // Terminou o questionário com esta resposta, ou ganhou insígnia:
      // o aviso de recompensa aparece no canto, por cima do quiz.
      if (window.comemorarGanho) {
        window.comemorarGanho({
          conclusao: r.conclusao,
          insignias_novas: r.insignias_novas
        });
      }

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

        // Errou mas pode tentar outra alternativa — o relógio volta a
        // correr de onde parou. O tempo é da pergunta, não da tentativa.
        retomarRelogio();
      }

    } catch (err) {
      travarOpcoes(false);
      atualizarConfirmar();
      retomarRelogio();
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

  /* As cores das oito áreas.
   *
   * A tabela `areas` não guarda cor, e inventar uma no servidor seria
   * decisão de banco para um assunto de tela. Ficam aqui, perto de quem
   * desenha. Nenhuma é vermelha de propósito: barra baixa neste jogo
   * não é erro, é assunto que a pessoa ainda não jogou. */
  const CORES = {
    'Saúde':       '#2ec4a9',
    'Educação':    '#5b9bd5',
    'Vacinação':   '#9b8ad4',
    'Vetores':     '#e8914a',
    'Limpeza':     '#4fc3d9',
    'Alimentação': '#7cc451',
    'Exercícios':  '#e2715f',
    'Felicidade':  '#f9c74f'
  };

  // Menor pedaço que ainda se enxerga numa barra, em % dela.
  const PISO = 3;

  async function mostrarFim() {
    pararRelogio();
    quiz.hidden = true;
    topo.hidden = true;
    fim.hidden = false;

    fimPlacar.textContent =
      `Você acertou ${acertos} de ${rodada.length} nesta rodada.`;

    const linhas = Object.entries(ganhos);
    fimBarras.innerHTML = '';

    btnMais.hidden = sobrando <= 0;
    if (!linhas.length) return;

    // O progresso DEPOIS da rodada. O "antes" se descobre tirando o que
    // acabou de ser ganho — assim a barra mostra de onde a pessoa saiu e
    // até onde chegou, em vez de só o número final.
    let areas = [];
    try { areas = await API.getMeuProgresso(); } catch (_) { /* cai no modo simples */ }

    const porNome = new Map(areas.map(a => [a.area, a]));

    for (const [area, pts] of linhas.sort((a, b) => b[1] - a[1])) {
      fimBarras.appendChild(montarGanho(area, pts, porNome.get(area)));
    }

    // Um quadro depois, para o navegador desenhar as barras no tamanho
    // antigo primeiro. Sem esta espera a largura final já entraria
    // pronta e não haveria crescimento para ver.
    requestAnimationFrame(() => requestAnimationFrame(() => {
      fimBarras.querySelectorAll('.ganho__novo').forEach(el => {
        el.style.width = el.dataset.largura;
      });
    }));
  }

  function montarGanho(area, pontos, dados) {
    const bloco = document.createElement('div');
    bloco.className = 'ganho';
    bloco.style.setProperty('--cor', CORES[area] || 'var(--primary)');

    bloco.innerHTML = `
      <div class="ganho__topo">
        <span class="ganho__area"></span>
        <span class="ganho__pts"></span>
      </div>
      <span class="ganho__barra"><i class="ganho__antes"></i><i class="ganho__novo"></i></span>
      <span class="ganho__nota"></span>`;

    bloco.querySelector('.ganho__area').textContent = area;
    bloco.querySelector('.ganho__pts').textContent = `+${pontos}`;

    // `pontos_possiveis` é a régua: tudo o que ESTE aluno pode somar na
    // área com as missões dele. Não confundir com a meta global da
    // tabela `areas`, que é o conteúdo do jogo inteiro — a régua do
    // aluno é a que faz a barra dele significar alguma coisa.
    const alvo = dados?.pontos_possiveis || 0;
    const agora = dados?.pontos ?? pontos;

    // Sem régua (área sem missão para este aluno) não há barra honesta a
    // desenhar: mostra só os pontos ganhos.
    if (!alvo) {
      bloco.querySelector('.ganho__barra').hidden = true;
      bloco.querySelector('.ganho__nota').textContent = `${agora} pontos`;
      return bloco;
    }

    const antes = Math.max(0, agora - pontos);
    const pctAntes = Math.min(100, (antes / alvo) * 100);
    const pctNovo = Math.min(100 - pctAntes, (pontos / alvo) * 100);

    bloco.querySelector('.ganho__antes').style.width = `${pctAntes}%`;

    // O pedaço novo nasce com largura zero e cresce — é ele o feedback.
    // O piso existe porque um ganho de 0,4% seria meio pixel: a pessoa
    // acertou e não veria nada se mexer.
    const novo = bloco.querySelector('.ganho__novo');
    novo.dataset.largura = `${pontos > 0 ? Math.max(PISO, pctNovo) : 0}%`;
    novo.style.width = '0%';

    bloco.querySelector('.ganho__nota').textContent =
      `${agora.toLocaleString('pt-BR')} de ${alvo.toLocaleString('pt-BR')} pontos`;

    return bloco;
  }

  btnMais.addEventListener('click', async () => {
    try {
      await carregarQuiz(quizAtual.id, false);
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

  // O botão Sair agora é desenhado pelo navbar.js, que também o liga.
  // O listener que existia aqui virou código morto quando esta página
  // passou a usar <nav data-navbar>.
})();