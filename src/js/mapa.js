// mapa.js — mapa interativo do bairro (src/pages/mapa.html)
// A base do mapa (Mapa01.png) só tem ruas, córrego e rio — nenhuma
// construção. Todo prédio/casa é uma imagem recortada, posicionada por
// cima com coordenadas medidas manualmente sobre Mapa02.jpg (o mapa
// original, com as construções desenhadas, usado só como referência de
// posicionamento), 1408x768px. Ajuste x/y/w/h abaixo conforme necessário
// para refinar o alinhamento visual.

(function () {
  const MAPA_W = 1408;
  const MAPA_H = 768;

  // Descrição de cada tipo de cenário, baseada em documento-de-concepcao.md (seção 9).
  const CENARIOS = {
    parque: {
      nome: "Parque",
      imagem: "Parque.png",
      descricao: "Áreas arborizadas para caminhadas, com missões de limpeza e reforço da separação correta do lixo.",
      interior: "Parque.png",
    },
    escola: {
      nome: "Escola",
      imagem: "Escola.png",
      descricao: "Calendário anual de campanhas educativas, reforçando a integração entre saúde e educação.",
      interior: "Escola.jpg",
    },
    farmacia: {
      nome: "Farmácia",
      imagem: "Farmacia.jpg",
      descricao: "Calendário anual de campanhas de saúde, avisos de cobertura vacinal e atividades que relacionam vacinas às doenças que elas previnem.",
      interior: "Farmacia.jpeg",
    },
    upa: {
      nome: "UPA",
      imagem: "UPA.png",
      descricao: "Casos urgentes que exigem atendimento rápido, ensinando o jogador a identificar prioridades em situações de emergência.",
      interior: "UPA.jpg",
    },
    ubs: {
      nome: "UBS",
      imagem: "UBS.png",
      descricao: "Centro de referência do bairro, onde o jogador acompanha consultas, campanhas e o cuidado contínuo do seu paciente virtual.",
      interior: "UBS.jpg",
    },
    banca: {
      nome: "Banca de jornal",
      imagem: "Banca.png",
      descricao: "Charges educativas, avisos de campanhas de vacinação e um espaço dedicado a identificar fake news sobre saúde.",
      interior: "Banca.jpg",
    },
    praca: {
      nome: "Pracinha",
      imagem: "Praca.jpg",
      descricao: "Ginástica ao ar livre, cuidados com insolação em dias quentes, rodas de conversa e dias de aferição de pressão arterial.",
      interior: "Praca.jpg",
    },
    mercado: {
      nome: "Mercado",
      imagem: "Mercado.png",
      descricao: "Missões sobre alimentação saudável, leitura de rótulos, segurança alimentar, conservação e higiene dos alimentos.",
      interior: "Mercado.jpg",
    },
    creche: {
      nome: "Creche",
      imagem: "Creche.png",
      descricao: "Missões voltadas ao cuidado infantil, desenvolvimento na primeira infância e prevenção de doenças comuns nessa fase.",
      interior: "Creche.jpg",
    },
    igreja: {
      nome: "Centro religioso",
      imagem: "Igreja.png",
      descricao: "Espaço de acolhimento para temas de saúde mental, com foco em escuta e combate ao estigma.",
      interior: "Igreja.jpg",
    },
    quadra: {
      nome: "Campo de lazer",
      imagem: "Quadra.png",
      descricao: "Atividades físicas coletivas em quadras, incentivando exercício e convivência comunitária.",
      interior: "Quadra.jpg",
    },
    "terreno-baldio": {
      nome: "Terreno baldio",
      imagem: "Baldio.png",
      descricao: "Representa o lixão do bairro; missões de conscientização sobre descarte irregular de lixo e seus riscos à saúde.",
      interior: "Baldio.jpg",
    },
    corrego: {
      nome: "Córrego",
      imagem: "Corrego.png",
      descricao: "O jogador aprende a reportar às autoridades civis situações de risco, como surtos de doenças ligadas à água contaminada.",
      interior: "Corrego.png",
    },
    rio: {
      nome: "Rio",
      imagem: "Rio.png",
      descricao: "Missões de educação ambiental e mutirões de limpeza, ligando meio ambiente e saúde pública.",
      interior: "Rio.png",
    },
    ruas: {
      nome: "Rua",
      imagem: "Ruas.png",
      descricao: "Missões de caminhada e separação de lixo por cor, reforçando hábitos sustentáveis no dia a dia.",
      // Uma foto só para todas as ruas clicáveis do mapa.
      interior: "Ruas.jpg",
    },
    casa: {
      nome: "Casa",
      imagem: "Casa.png",
      descricao: "Visitas do ACS a moradores diferentes, cada um com uma história e um problema de saúde distinto a ser identificado e resolvido.",
      // Interior padrão da casa. Hoje todas as casas do mapa têm foto
      // própria; isto existe para a próxima casa desenhada não abrir o
      // modal com o aviso de "em breve" enquanto a foto dela não vem.
      interior: "Casa.jpeg",
    },
  };

  // Retângulos (x, y, largura, altura) em pixels sobre a imagem original 1408x768.
  const HOTSPOTS = [
    { tipo: "parque", x: 490, y: 0, w: 429, h: 128, tooltipPos: "bottom" },
    { tipo: "escola", x: 775, y: 100, w: 190, h: 150 },
    { tipo: "farmacia", x: 438, y: 153, w: 110, h: 80 },
    { tipo: "upa", x: 555, y: 133, w: 110, h: 110 },
    { tipo: "ubs", x: 447, y: 250, w: 100, h: 102 },
    { tipo: "banca", x: 865, y: 274, w: 100, h: 90 },
    { tipo: "praca", x: 605, y: 303, w: 200, h: 187 },
    { tipo: "mercado", x: 860, y: 387, w: 129, h: 120 },
    { tipo: "creche", x: 760, y: 520, w: 122, h: 90 },
    { tipo: "igreja", x: 1138, y: 458, w: 90, h: 157 },
    { tipo: "quadra", x: 1034, y: 300, w: 230, h: 210 },
    { tipo: "terreno-baldio", x: 1038, y: 162, w: 218, h: 180 },
    { tipo: "corrego", x: 166, y: 0, w: 114, h: 680, tooltipPos: "right" },
    { tipo: "rio", x: 205, y: 697, w: 1200, h: 80 },

    { tipo: "ruas", imagemHotspot: "Ruas01.jpg", x: 279, y: 624, w: 1036, h: 67 },
    { tipo: "ruas", imagemHotspot: "Ruas02.jpg", x: 93, y: 126, w: 58, h: 555, tooltipPos: "right" },
    { tipo: "ruas", imagemHotspot: "Ruas03.png", x: 237, y: 353, w: 317, h: 68 },
    { tipo: "ruas", imagemHotspot: "Ruas04.png", x: 376, y: 181, w: 59, h: 175 },
    { tipo: "ruas", imagemHotspot: "Ruas05.png", x: 240, y: 126, w: 1080, h: 50 },
    { tipo: "ruas", imagemHotspot: "Ruas06.png", x: 855, y: 362, w: 135, h: 60 },
    { tipo: "ruas", imagemHotspot: "Ruas08.png", x: 550, y: 253, w: 55, h: 285 },
    { tipo: "ruas", imagemHotspot: "Ruas09.png", x: 802, y: 253, w: 53, h: 285 },
    { tipo: "ruas", imagemHotspot: "Ruas10.png", x: 855, y: 254, w: 135, h: 60 },
    { tipo: "ruas", imagemHotspot: "Ruas11.png", x: 986, y: 183, w: 55, h: 441   },
    { tipo: "ruas", imagemHotspot: "Ruas12.png", x: 1256, y: 180, w: 60, h: 450 },
    { tipo: "ruas", imagemHotspot: "Ruas13.png", x: 1310, y: 362, w: 100, h: 61 },
    { tipo: "ruas", imagemHotspot: "Ruas14.png", x: 626, y: 490, w: 158, h: 125 },
    { tipo: "ruas", imagemHotspot: "Ruas15.png", x: 610, y: 175, w: 190, h: 128 },


    // Cada casa aponta para o seu interior: o recorte da fachada e a foto
    // de dentro são a mesma casa (Casa03.png -> Casa03.jpg). Hoje todas
    // têm a sua; uma casa nova sem foto cai no padrão de CENARIOS.casa.
    // `casa` é o número da casa, que vai na URL da missão e escolhe a
    // família mostrada lá (familia03.png). As laterais continuam a
    // contagem depois da Casa16: CasaLateral01 = 17 ... CasaLateral04 = 20.
    // As laterais abrem o rótulo para dentro do mapa: "Casa da família
    // Nascimento", centralizado em cima delas, sairia pela borda.
    { tipo: "casa", casa: 1, imagem: "Casa.png", x: 253, y: 230, w: 125, h: 126, interior: "Casa.jpeg" },
    { tipo: "casa", casa: 3, imagem: "Casa03.png", x:465, y: 387, w: 85, h: 110, interior: "Casa03.jpg" },
    { tipo: "casa", casa: 13, imagem: "Casa013.png", x: 372, y: 390, w: 85, h: 105, interior: "Casa13.jpg" },
    { tipo: "casa", casa: 6, imagem: "Casa06.png", x: 930, y: 25, w: 98, h: 93, tooltipPos: "bottom", interior: "Casa06.jpg" },
    { tipo: "casa", casa: 7, imagem: "Casa07.png", x: 1039, y: 20, w: 110, h: 80, tooltipPos: "bottom", interior: "Casa07.jpg" },
    { tipo: "casa", casa: 14, imagem: "Casa014.png", x: 480, y: 512, w: 75, h: 100, interior: "Casa14.jpg" },
    { tipo: "casa", casa: 9, imagem: "Casa09.png", x: 385, y: 10, w: 90, h: 100, tooltipPos: "bottom", interior: "Casa09.jpg" },
    { tipo: "casa", casa: 10, imagem: "Casa010.png", x: 350, y: 514, w: 125, h: 100, interior: "Casa10.jpg" },
    { tipo: "casa", casa: 11, imagem: "Casa011.png", x: 253, y: 387, w: 110, h: 115, interior: "Casa11.jpg" },
    { tipo: "casa", casa: 8, imagem: "Casa08.png", x: 548, y: 500, w: 110, h: 115, interior: "Casa08.jpg" },
    { tipo: "casa", casa: 12, imagem: "Casa012.png", x: 880, y: 502, w: 110, h: 110, interior: "Casa12.jpg" },
    { tipo: "casa", casa: 2, imagem: "Casa02.png", x: 253, y: 139, w: 127, h: 107, interior: "Casa02.jpeg" },
    { tipo: "casa", casa: 15, imagem: "Casa015.png", x: 238, y: 20, w: 145, h: 100, tooltipPos: "bottom", interior: "Casa15.jpg" },
    { tipo: "casa", casa: 5, imagem: "Casa05.png", x: 80, y: 20, w: 80, h: 90, interior: "Casa05.jpg" },
    { tipo: "casa", casa: 4, imagem: "Casa04.png", x: 1041, y: 515, w: 85, h: 105, tooltipPos: "bottom", interior: "Casa04.jpg" },
    { tipo: "casa", casa: 16, imagem: "Casa016.png", x: 1182, y: 8, w: 150, h: 100, tooltipPos: "bottom", interior: "Casa16.jpg" },

    { tipo: "casa", casa: 19, imagem: "CasaLateral03.png", x: 15, y: 200, w: 68, h: 112, tooltipPos: "right", interior: "CasaLateral03.jpg" },
    { tipo: "casa", casa: 17, imagem: "CasaLateral01.png", x: 15, y: 442, w: 80, h: 105, tooltipPos: "right", interior: "CasaLateral01.jpg" },
    { tipo: "casa", casa: 18, imagem: "CasaLateral02.png", x: 1335, y: 200, w: 70, h: 112, tooltipPos: "left", interior: "CasaLateral02.jpg" },
    { tipo: "casa", casa: 20, imagem: "CasaLateral04.png", x: 1335, y: 430, w: 73, h: 113, tooltipPos: "left", interior: "CasaLateral04.jpg" },
  ];

  // ── Objetos clicáveis dentro da foto do interior ──────────────────
  //
  // A mesma ideia dos HOTSPOTS, só que dentro do modal: um recorte
  // (src/imgs/Interiores/) posicionado exatamente por cima do objeto
  // desenhado na foto, que acende no hover. A chave é o arquivo da foto,
  // porque as coordenadas são dela: x/y/w/h em pixels sobre a foto
  // original (`largura` x `altura`). O modal corta a foto (object-fit:
  // cover); a camada dos objetos é cortada igual (ver mapa.css), então os
  // percentuais continuam batendo em qualquer tamanho de tela.
  //
  // `acao` diz o que o clique faz:
  //   link   -> abre o endereço numa aba nova (o mapa continua aberto)
  //   hqs    -> o modal vira o visor das HQs, uma por vez (HQS abaixo)
  //   imagem -> o modal vira o visor de uma imagem só
  // `segredo` é o código da insígnia (regra DESCOBERTA, db/insignias.sql)
  // que achar o objeto dá — ver SEGREDOS mais abaixo.
  const OBJETOS_DO_INTERIOR = {
    "Banca.jpg": {
      largura: 1408,
      altura: 768,
      itens: [
        // A foto da banca não tem mais a TV nem os jornais desenhados: os
        // recortes são o único desenho deles, apoiados no balcão.
        { nome: "Ler as HQs", imagem: "jornais.png", x: 321, y: 419, w: 251, h: 91,
          acao: { tipo: "hqs", segredo: "segredo-hqs" } },
        { nome: "Assistir vídeos sobre saúde", imagem: "televisão.png", x: 953, y: 359, w: 124, h: 132,
          acao: { tipo: "link", url: "https://videosaude.icict.fiocruz.br/", segredo: "segredo-tv" } },
      ],
    },
    "Farmacia.jpeg": {
      largura: 1024,
      altura: 559,
      itens: [
        { nome: "Ver o calendário", imagem: "calendário.jpg", x: 364, y: 159, w: 50, h: 52,
          acao: { tipo: "imagem", titulo: "Calendário das cores", imagem: "calendario-cores.jpeg",
                  segredo: "segredo-calendario" } },
      ],
    },
  };

  // As HQs da banca (src/imgs/hqs/), na ordem de leitura. O servidor não
  // lista pastas, então uma HQ nova entra aqui à mão. (A 3 é mesmo
  // "hq-03", com hífen.)
  const HQS = [
    "hq01.jpeg", "hq02.jpeg", "hq-03.jpeg", "hq04.jpeg", "hq05.jpeg", "hq06.jpeg",
    "hq07.jpeg", "hq08.jpeg", "hq09.jpeg", "hq10.jpeg", "hq11.jpeg", "hq12.jpeg",
  ];

  // ── Os segredos e as dicas ────────────────────────────────────────
  //
  // Cada objeto acima dá uma insígnia da regra DESCOBERTA a quem o acha
  // (POST /api/descobrir), e chegar à última HQ dá mais uma. Enquanto a
  // pessoa não tiver a insígnia, abrir o lugar mostra uma DICA no canto
  // da tela — no cartão das conquistas —, que sugere onde clicar sem
  // dizer.
  //
  // Cada lista interna é uma CORRENTE: aparece a dica do primeiro elo
  // ainda não conquistado. É o que deixa a dica das HQs mudar de
  // "procure" para "termine de ler" e só sumir com a última página.
  // Os códigos são os de db/insignias.sql; trocar lá exige trocar aqui.
  const HQS_TODAS = "segredo-hqs-todas";

  const DICAS = {
    banca: [
      [{ codigo: "segredo-tv", titulo: "Notícia no ar",
         texto: "O jornaleiro jura que as melhores notícias de saúde não estão no papel… estão no ar." }],
      [{ codigo: "segredo-hqs", titulo: "Nem tudo é manchete",
         texto: "Nem toda história desta banca é notícia — algumas falam por balões." },
       { codigo: HQS_TODAS, titulo: "Continua…",
         texto: "Tem história nesta banca que você ainda não terminou. Quem chega à última página ganha mais que um final feliz." }],
    ],
    farmacia: [
      [{ codigo: "segredo-calendario", titulo: "O tempo na parede",
         texto: "Nesta farmácia o tempo passa na parede — e cada mês veste uma cor diferente. Sabe por quê?" }],
    ],
  };


  // ── As 8 barras da saúde ──────────────────────────────────────────
  //
  // Cor e ícone de cada área. As CHAVES são exatamente os nomes da
  // tabela `areas` do banco — é por elas que o progresso do aluno é
  // casado com a área que o cenário alimenta. Mudar um nome aqui sem
  // mudar lá quebra o casamento em silêncio (a barra some da lista).
  const AREAS_VISUAL = {
    "Saúde":       { icone: "❤️", cor: "#f87171" },
    "Educação":    { icone: "📚", cor: "#6b8eff" },
    "Vacinação":   { icone: "💉", cor: "#a78bfa" },
    "Vetores":     { icone: "🦟", cor: "#f9c74f" },
    "Limpeza":     { icone: "🧹", cor: "#38bdf8" },
    "Alimentação": { icone: "🥗", cor: "#4ade80" },
    "Exercícios":  { icone: "🏃", cor: "#fb923c" },
    "Felicidade":  { icone: "😊", cor: "#f472b6" },
  };

  const hotspotsLayer = document.getElementById("mapa-hotspots");
  const sidebarEmpty = document.getElementById("mapa-sidebar-empty");
  const sidebarContent = document.getElementById("mapa-sidebar-content");
  const sidebarThumb = document.getElementById("mapa-sidebar-thumb");
  const sidebarNome = document.getElementById("mapa-sidebar-nome");
  const sidebarSub = document.getElementById("mapa-sidebar-sub");
  const sidebarAreas = document.getElementById("mapa-sidebar-areas");
  const btnSair = document.getElementById("logout-btn");

  const modal = document.getElementById("cenario-modal");
  const modalThumb = document.getElementById("cenario-modal-thumb");
  const modalNome = document.getElementById("cenario-modal-nome");
  const modalDesc = document.getElementById("cenario-modal-desc");
  const modalInterior = document.getElementById("cenario-modal-interior");
  const modalEmBreve = document.getElementById("cenario-modal-em-breve");
  const modalFamilia = document.getElementById("cenario-modal-familia");
  const modalPlay = document.getElementById("cenario-modal-play");
  const modalMissoes = document.getElementById("cenario-modal-missoes");
  const modalClose = document.getElementById("cenario-modal-close");
  const modalObjetos = document.getElementById("cenario-modal-objetos");

  const visor = document.getElementById("cenario-visor");
  const visorImg = document.getElementById("cenario-visor-img");
  const visorAnterior = document.getElementById("cenario-visor-anterior");
  const visorProxima = document.getElementById("cenario-visor-proxima");
  const visorContador = document.getElementById("cenario-visor-contador");
  const visorVoltar = document.getElementById("cenario-visor-voltar");
  const visorClose = document.getElementById("cenario-visor-close");

  /* ═══════════════════════════════════════════════════════════════════
     PROGRESSO POR ÁREA

     Duas chamadas, uma vez só, no carregamento da página:

       API.getCenarios()     -> quais áreas cada lugar do bairro alimenta
       API.getMeuProgresso() -> quanto este aluno já tem em cada área

     O hover não busca nada: ele só cruza os dois mapas já em memória.
     Fosse uma chamada por passada de mouse, atravessar o bairro
     dispararia dezenas de requisições e a barra piscaria a cada
     movimento do cursor.

     Enquanto a resposta não chega, `areasPorSlug` fica null — e é isso
     que distingue "ainda carregando" de "este lugar não pontua nada".
     ═══════════════════════════════════════════════════════════════════ */

  let areasPorSlug = null;      // slug do cenário -> ["Saúde", "Limpeza", ...]
  let progressoPorArea = null;  // nome da área    -> { pontos, pontos_possiveis, porcentagem, sem_missoes }
  let semTurma = false;         // sem turma, as barras não têm régua (ver desenharAreas)
  let erroAreas = "";
  let hotspotAtual = null;      // o ponto que a lateral está mostrando agora
  let hotspotDoModal = null;    // o ponto que o modal está mostrando agora
  let missaoEscolhida = null;   // o quiz escolhido na lista do modal

  // slug do cenário -> as missões (quizzes do professor) pendentes que
  // cobrem aquele lugar, a mais recente primeiro. null = ainda não chegou.
  let quizzesPorSlug = null;

  async function carregarAreas() {
    try {
      const [cenarios, progresso, perfil] = await Promise.all([
        API.getCenarios(),
        API.getMeuProgresso(),
        perfilPromessa,
      ]);

      areasPorSlug = new Map((cenarios || []).map(c => [c.slug, c.areas || []]));
      progressoPorArea = new Map((progresso || []).map(p => [p.area, p]));
      semTurma = Boolean(perfil && perfil.tipo === "ALUNO" && !perfil.turma_id);

      if (perfil && !semTurma) mostrarAvisoDeNovas(perfil.id, progresso || []);
    } catch (err) {
      erroAreas = err.message;
    }

    // O mouse pode já estar parado sobre um ponto quando a resposta
    // chega — sem isto a lateral ficaria presa no "carregando", e o botão
    // do modal aberto junto com ela.
    if (hotspotAtual) mostrarCenario(hotspotAtual);
  }

  /**
   * As áreas de um lugar. Devolve null enquanto o servidor não respondeu
   * (ou quando a busca falhou), e [] para um ponto do mapa que ainda não
   * virou cenário no banco — banca, igreja, rio e ruas são cenário só
   * visual por enquanto.
   */
  function areasDoCenario(tipo) {
    if (!areasPorSlug) return null;
    return areasPorSlug.get(tipo) || [];
  }

  /** Um lugar só é jogável se alguma missão pendente do aluno o cobrir. */
  function quizzesDoLugar(tipo) {
    return (quizzesPorSlug && quizzesPorSlug.get(tipo)) || [];
  }

  function avisoDeArea(texto) {
    const p = document.createElement("p");
    p.className = "mapa-areas__aviso";
    p.textContent = texto;
    return p;
  }

  /** Desenha as barras de progresso dentro de um container. */
  function desenharAreas(container, areas) {
    if (!container) return;
    container.innerHTML = "";

    if (areas === null) {
      container.appendChild(avisoDeArea(erroAreas || "Carregando seu progresso…"));
      return;
    }

    if (!areas.length) {
      container.appendChild(avisoDeArea(
        "Este lugar ainda não distribui pontos — o conteúdo dele está a caminho."
      ));
      return;
    }

    // A régua das barras são as missões da turma. Sem turma, ela seria só
    // o que o aluno já acertou — e tudo apareceria em 100%.
    if (semTurma) {
      container.appendChild(avisoDeArea(
        "Entre numa turma (em Minha turma) para ver aqui o seu progresso nas missões."
      ));
      return;
    }

    for (const nome of areas) {
      const visual = AREAS_VISUAL[nome] || { icone: "•", cor: "#6bdfb8" };
      const registro = progressoPorArea ? progressoPorArea.get(nome) : null;
      const pct = Math.round(registro ? registro.porcentagem || 0 : 0);
      // Nenhuma missão do aluno vale ponto nesta área: "0%" soaria como
      // fracasso, quando na verdade ainda não chegou tarefa dela.
      const semMissoes = !registro || registro.sem_missoes;

      const el = document.createElement("div");
      el.className = "mapa-area";
      el.style.setProperty("--cor-area", visual.cor);
      el.innerHTML = `
        <div class="mapa-area__topo">
          <span class="mapa-area__nome">
            <span class="mapa-area__icone"></span><span class="mapa-area__label"></span>
          </span>
          <span class="mapa-area__pct"></span>
        </div>
        <div class="progress-track mapa-area__track">
          <div class="progress-bar mapa-area__bar"></div>
        </div>
      `;

      el.querySelector(".mapa-area__icone").textContent = visual.icone;
      el.querySelector(".mapa-area__label").textContent = nome;
      el.querySelector(".mapa-area__pct").textContent = semMissoes ? "sem missões" : `${pct}%`;
      if (semMissoes) el.classList.add("mapa-area--sem-missoes");
      else el.title = `${registro.pontos} de ${registro.pontos_possiveis} pontos das suas missões`;
      el.querySelector(".mapa-area__bar").style.width = `${pct}%`;

      container.appendChild(el);
    }
  }

  // O nome de um ponto do mapa. As casas levam o sobrenome de quem mora
  // nelas (familias.js); os outros lugares, o nome do tipo.
  function nomeDoPonto(h) {
    const familia = h.tipo === "casa" && window.FAMILIAS && FAMILIAS[h.casa];
    return familia ? `Casa da família ${familia}` : CENARIOS[h.tipo].nome;
  }

  // ── Painel lateral: o que o hover mostra ──────────────────────────
  function mostrarCenario(h) {
    const cenario = CENARIOS[h.tipo];
    if (!cenario) return;

    hotspotAtual = h;
    sidebarThumb.src = `../imgs/${h.imagem || cenario.imagem}`;
    sidebarThumb.alt = nomeDoPonto(h);
    sidebarNome.textContent = nomeDoPonto(h);
    sidebarSub.textContent = "Seu progresso nas áreas deste lugar";

    desenharAreas(sidebarAreas, areasDoCenario(h.tipo));

    sidebarEmpty.hidden = true;
    sidebarContent.hidden = false;
  }

  function limparSidebar() {
    hotspotAtual = null;
    sidebarEmpty.hidden = false;
    sidebarContent.hidden = true;
  }

  // ── Modal: o que o clique abre ────────────────────────────────────

  /** Já respondeu alguma pergunta desta missão? Então é "continuar". */
  function missaoComecada(quiz) {
    return quiz.total - quiz.restantes > 0;
  }

  /**
   * O botão aparece sempre — sem missão escolhida ele mostra a versão
   * cinza, bloqueada, em vez de sumir: o botão faltando fazia o aluno
   * achar que o modal tinha carregado errado.
   *
   * Só se joga dentro de uma missão (quiz do professor), e o aluno
   * escolhe qual na lista ao lado. Até escolher, o botão fica travado;
   * escolhida uma que já tem resposta, ele vira "Continuar".
   *
   * Enquanto as missões não chegaram, todo lugar parece sem missão; dizer
   * "sem missões" aí seria mentira, então o carregamento tem o seu próprio
   * rótulo.
   */
  function atualizarBotaoJogar(h) {
    if (!modalPlay) return;

    const carregando = quizzesPorSlug === null;
    const temMissoes = quizzesDoLugar(h.tipo).length > 0;
    const quiz = missaoEscolhida;

    modalPlay.disabled = !quiz;
    modalPlay.classList.toggle("mapa-modal__play--bloqueado", !quiz);
    modalPlay.textContent = quiz
      ? (missaoComecada(quiz) ? "Continuar" : "Jogar")
      : carregando
        ? "Carregando missões…"
        : temMissoes
          ? "Jogar"
          : "Sem missões disponíveis";
    modalPlay.dataset.cenario = h.tipo;
    if (quiz) modalPlay.dataset.quiz = quiz.id;
    else delete modalPlay.dataset.quiz;
    // Qual casa foi clicada: a tela da missão usa o número para mostrar o
    // interior daquela casa e a família que mora nela.
    if (h.casa) modalPlay.dataset.casa = h.casa;
    else delete modalPlay.dataset.casa;
  }

  function escolherMissao(quiz, card) {
    missaoEscolhida = quiz;
    modalMissoes.querySelectorAll(".mission-item").forEach(el => {
      const escolhido = el === card;
      el.classList.toggle("is-escolhida", escolhido);
      el.setAttribute("aria-checked", String(escolhido));
    });
    if (hotspotDoModal) atualizarBotaoJogar(hotspotDoModal);
  }

  /**
   * A lista de missões do lugar, embaixo da foto, ao lado do botão.
   * Mesmo card da lista de "Missões ativas", só que clicar nele escolhe em
   * vez de jogar — quem leva para a missão é o botão. Fica separada de
   * `abrirModal` porque `carregarMissoes` chama só isto (e o botão) quando
   * a resposta chega com o modal já aberto — remontar o modal inteiro
   * recarregaria a família e voltaria a rolagem ao topo no meio da leitura.
   */
  function desenharMissoesDoModal(h) {
    if (!modalMissoes) return;
    modalMissoes.innerHTML = "";

    const quizzes = quizzesDoLugar(h.tipo);
    // A escolha só sobrevive se a missão ainda estiver na lista.
    if (missaoEscolhida && !quizzes.some(q => q.id === missaoEscolhida.id)) {
      missaoEscolhida = null;
    }

    if (!quizzes.length) {
      const aviso = document.createElement("p");
      aviso.className = "missoes-aviso";
      aviso.textContent = quizzesPorSlug === null
        ? "Carregando missões…"
        : "Nenhuma missão disponível neste lugar por enquanto.";
      modalMissoes.appendChild(aviso);
      return;
    }

    const cenario = CENARIOS[h.tipo] || {};
    // A miniatura é a do ponto clicado (cada casa tem a sua fachada), não
    // a do primeiro lugar que o quiz cobre, como na lista de baixo.
    const imagem = h.imagem || cenario.imagem;

    for (const quiz of quizzes) {
      const card = montarCard(quiz, imagem);
      const escolhido = Boolean(missaoEscolhida && missaoEscolhida.id === quiz.id);
      card.classList.add("mission-item--escolher");
      card.classList.toggle("is-escolhida", escolhido);
      card.setAttribute("role", "radio");
      card.setAttribute("aria-checked", String(escolhido));
      card.tabIndex = 0;

      card.addEventListener("click", () => escolherMissao(quiz, card));
      card.addEventListener("keydown", (e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          escolherMissao(quiz, card);
        }
      });

      modalMissoes.appendChild(card);
    }
  }

  /**
   * Numa casa, a família que mora nela fica no centro da foto — a mesma
   * figura (familia03.png para a casa 3) que a tela da missão mostra.
   * Os outros lugares não têm morador.
   */
  function mostrarFamilia(h) {
    if (!modalFamilia) return;
    // Esconde já: a figura da casa anterior não pode piscar sobre a nova
    // foto enquanto a próxima carrega. E solta o onload antigo, senão uma
    // família ainda carregando apareceria por cima de um lugar sem morador.
    modalFamilia.hidden = true;
    modalFamilia.onload = modalFamilia.onerror = null;
    if (h.tipo !== "casa" || !h.casa) return;

    const sobrenome = window.FAMILIAS && FAMILIAS[h.casa];
    modalFamilia.alt = sobrenome ? `Família ${sobrenome}` : "Família que mora nesta casa";
    modalFamilia.onload = () => { modalFamilia.hidden = false; };
    // Sem a imagem, fica só o interior — nada de ícone de imagem quebrada.
    modalFamilia.onerror = () => { modalFamilia.hidden = true; };
    modalFamilia.src = `../imgs/familias/familia${String(h.casa).padStart(2, "0")}.png`;
  }

  /**
   * Os objetos clicáveis da foto (OBJETOS_DO_INTERIOR). A maioria dos
   * lugares não tem nenhum e a camada fica vazia. A proporção da foto vai
   * para o CSS, que a usa para cortar a camada igual à foto.
   */
  function montarObjetos(interior) {
    if (!modalObjetos) return;
    modalObjetos.innerHTML = "";

    const cena = interior && OBJETOS_DO_INTERIOR[interior];
    if (!cena) return;

    modalObjetos.style.setProperty("--proporcao", cena.largura / cena.altura);

    for (const item of cena.itens) {
      const el = document.createElement("button");
      el.type = "button";
      el.className = "mapa-objeto";
      el.style.left = (item.x / cena.largura) * 100 + "%";
      el.style.top = (item.y / cena.altura) * 100 + "%";
      el.style.width = (item.w / cena.largura) * 100 + "%";
      el.style.height = (item.h / cena.altura) * 100 + "%";
      el.setAttribute("aria-label", item.nome);

      const img = document.createElement("img");
      img.src = `../imgs/Interiores/${item.imagem}`;
      img.alt = "";
      img.draggable = false;
      el.appendChild(img);

      const label = document.createElement("span");
      label.className = "mapa-objeto__label";
      label.textContent = item.nome;
      el.appendChild(label);

      el.addEventListener("click", () => usarObjeto(item.acao));
      modalObjetos.appendChild(el);
    }
  }

  function usarObjeto(acao) {
    // As dicas saem: o segredo foi achado, e no visor elas cobririam a HQ.
    if (typeof CONQUISTA_AVISO !== "undefined") CONQUISTA_AVISO.dicas([]);
    if (acao.segredo) descobrirSegredo(acao.segredo);

    if (acao.tipo === "link") {
      // Aba nova: o aluno volta para o mapa do jeito que deixou.
      window.open(acao.url, "_blank", "noopener");
    } else if (acao.tipo === "hqs") {
      abrirVisor();
      mostrarHq(0);
    } else if (acao.tipo === "imagem") {
      abrirVisor();
      visorImg.src = `../imgs/Interiores/${acao.imagem}`;
      visorImg.alt = acao.titulo;
    }
  }

  /* ── Visor: o modal vira só uma imagem (as HQs ou o calendário) ──
     A classe no card esconde a foto e as missões (sem apagar nada) e tira
     a moldura do modal, deixando só a imagem, quase na tela toda — por
     isso "Voltar" só desfaz a classe. */

  const modalCard = modal?.querySelector(".mapa-modal");
  const visorQuadro = visor?.querySelector(".mapa-visor__quadro");

  // O quadro toma a proporção de cada imagem que chega (as HQs não são
  // todas iguais, e o calendário é em pé) — é o que deixa os controles
  // dentro da imagem, e não numa faixa vazia ao lado dela.
  visorImg?.addEventListener("load", () => {
    if (!visorImg.naturalHeight) return;
    visorQuadro.style.setProperty("--proporcao", visorImg.naturalWidth / visorImg.naturalHeight);
    visorQuadro.classList.remove("is-carregando");
  });

  let hqAtual = null;   // índice em HQS; null = o visor não está nas HQs

  /* ── Os segredos: o que a pessoa já achou ──
     Uma chamada só, no carregamento: código -> { imagem, conquistada },
     das insígnias DESCOBERTA do catálogo. null enquanto não chegou (ou
     se falhou) — aí não aparece dica nem se registra achado: sem a
     lista, não dá para saber se a insígnia existe neste banco. */

  let segredos = null;
  const descobrindo = new Set();   // pedidos em andamento, contra o clique duplo

  async function carregarSegredos() {
    try {
      const r = await API.getMinhasDescobertas();
      segredos = new Map((r.descobertas || []).map(d => [d.codigo, d]));
    } catch (err) {
      console.warn("[mapa] Não foi possível carregar os segredos do mapa:", err.message);
    }
  }

  function jaAchou(codigo) {
    const s = segredos && segredos.get(codigo);
    return !s || s.conquistada;
  }

  /** As dicas do lugar, no canto da tela: um cartão por corrente pendente. */
  function mostrarDicas(tipo) {
    if (typeof CONQUISTA_AVISO === "undefined") return;

    const lista = [];
    for (const corrente of DICAS[tipo] || []) {
      // Corrente cuja insígnia final não existe neste banco (o
      // insignias.sql novo ainda não rodou): sem prêmio, sem dica.
      if (!segredos || !segredos.has(corrente[corrente.length - 1].codigo)) continue;

      const elo = corrente.find(d => !jaAchou(d.codigo));
      if (elo) lista.push({ ...elo, imagem: segredos.get(elo.codigo).imagem });
    }

    // Lista vazia também limpa as dicas de um lugar aberto antes.
    CONQUISTA_AVISO.dicas(lista);
  }

  /** Achou um segredo: grava, e comemora se a insígnia é nova. */
  async function descobrirSegredo(codigo) {
    if (jaAchou(codigo) || descobrindo.has(codigo)) return;
    descobrindo.add(codigo);

    try {
      const r = await API.descobrir(codigo);
      segredos.get(codigo).conquistada = true;
      if (r.nivel && window.NIVEL) window.NIVEL.atualizar(r.nivel, r.xp);
      if (typeof CONQUISTA_AVISO !== "undefined") CONQUISTA_AVISO.mostrar(r.insignias_novas);
    } catch (err) {
      // Fica para a próxima vez que a pessoa achar: a dica continua.
      console.warn("[mapa] Não foi possível registrar o segredo:", err.message);
    } finally {
      descobrindo.delete(codigo);
    }
  }

  function abrirVisor() {
    if (!visor) return;
    hqAtual = null;
    // As setas e o contador são só das HQs; mostrarHq os acende.
    visorAnterior.hidden = visorProxima.hidden = visorContador.hidden = true;
    visorQuadro.classList.add("is-carregando");
    visor.hidden = false;
    modalCard?.classList.add("mapa-modal--visor");
    visorVoltar.focus();
  }

  function fecharVisor() {
    if (!visor || visor.hidden) return false;
    visor.hidden = true;
    modalCard?.classList.remove("mapa-modal--visor");
    hqAtual = null;
    // Sem o src antigo, a próxima abertura não pisca a imagem anterior.
    visorImg.removeAttribute("src");
    return true;
  }

  /** Carrossel parado: só troca de HQ quando o aluno clica numa seta. */
  function mostrarHq(i) {
    if (i < 0 || i >= HQS.length) return;
    hqAtual = i;
    visorImg.src = `../imgs/hqs/${HQS[i]}`;
    visorImg.alt = `HQ ${i + 1} de ${HQS.length}`;

    visorAnterior.hidden = visorProxima.hidden = visorContador.hidden = false;
    visorAnterior.disabled = i === 0;
    visorProxima.disabled = i === HQS.length - 1;
    visorContador.textContent = `HQ ${i + 1} de ${HQS.length}`;
    // Seta que acabou de travar no fim (ou no começo) perderia o foco do
    // teclado para a página; ele passa para a outra.
    if (document.activeElement && document.activeElement.disabled) {
      (visorAnterior.disabled ? visorProxima : visorAnterior).focus();
    }

    // Já baixa a próxima, para o clique trocar sem esperar.
    if (i + 1 < HQS.length) new Image().src = `../imgs/hqs/${HQS[i + 1]}`;
    // Uma por clique, em ordem: quem chegou à última passou por todas.
    else descobrirSegredo(HQS_TODAS);
  }

  visorAnterior?.addEventListener("click", () => mostrarHq(hqAtual - 1));
  visorProxima?.addEventListener("click", () => mostrarHq(hqAtual + 1));
  visorVoltar?.addEventListener("click", () => {
    fecharVisor();
    modalClose?.focus();
  });
  visorClose?.addEventListener("click", () => fecharModal());

  function abrirModal(h) {
    const cenario = CENARIOS[h.tipo];
    if (!cenario || !modal) return;

    hotspotDoModal = h;
    modalThumb.src = `../imgs/${h.imagem || cenario.imagem}`;
    modalThumb.alt = nomeDoPonto(h);
    modalNome.textContent = nomeDoPonto(h);
    modalDesc.textContent = cenario.descricao;

    // A foto do interior vem do hotspot quando ele tem a sua (cada casa
    // do bairro tem um morador e uma sala diferentes) e, na falta dela,
    // da do tipo de lugar. Só a rua fica sem foto e cai no aviso.
    const interior = h.interior || cenario.interior;
    modalInterior.hidden = !interior;
    modalEmBreve.hidden = Boolean(interior);
    // Trocar o src só quando há imagem: apagá-lo faria o navegador pedir a
    // própria página como imagem e o alt ficaria piscando por trás do aviso.
    if (interior) {
      modalInterior.src = `../imgs/Interiores/${interior}`;
      modalInterior.alt = `Interior — ${nomeDoPonto(h)}`;
    }
    mostrarFamilia(h);
    montarObjetos(interior);
    fecharVisor();
    mostrarDicas(h.tipo);

    missaoEscolhida = null;
    desenharMissoesDoModal(h);
    atualizarBotaoJogar(h);

    // O modal tem tamanho fixo; o que rola é a lista de missões, para o
    // lado. Sem isto um segundo lugar abriria rolado até onde o anterior
    // ficou, com as primeiras missões fora de vista.
    if (modalMissoes) modalMissoes.scrollLeft = 0;

    modal.classList.add("open");
    document.body.classList.add("modal-aberto");
    if (modalClose) modalClose.focus();
  }

  function fecharModal() {
    if (!modal) return;
    modal.classList.remove("open");
    document.body.classList.remove("modal-aberto");
    fecharVisor();
  }

  modalClose?.addEventListener("click", fecharModal);

  // Só o clique no fundo fecha. Comparar o alvo com o próprio overlay é o
  // que impede um clique dentro do card de fechar o modal por borbulhamento.
  modal?.addEventListener("click", (e) => {
    if (e.target === modal) fecharModal();
  });

  // Com o visor aberto, o Esc volta para o lugar em vez de fechar tudo, e
  // as setas do teclado passam as HQs.
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      if (fecharVisor()) modalClose?.focus();
      else fecharModal();
    } else if (hqAtual !== null && e.key === "ArrowLeft") {
      mostrarHq(hqAtual - 1);
    } else if (hqAtual !== null && e.key === "ArrowRight") {
      mostrarHq(hqAtual + 1);
    }
  });

  modalPlay?.addEventListener("click", () => {
    const { quiz, cenario: tipo, casa } = modalPlay.dataset;
    if (!quiz || modalPlay.disabled) return;
    // O lugar e a casa vão junto só para a tela da missão escolher a foto.
    window.location.href = `missao.html?quiz=${encodeURIComponent(quiz)}`
      + `&cenario=${encodeURIComponent(tipo)}`
      + (casa ? `&casa=${encodeURIComponent(casa)}` : "");
  });

  function montarHotspots() {
    const frag = document.createDocumentFragment();

    HOTSPOTS.forEach((h) => {
      const cenario = CENARIOS[h.tipo];
      const el = document.createElement("div");
      el.className = "mapa-hotspot";
      if (h.tooltipPos === "bottom") el.classList.add("mapa-hotspot--label-bottom");
      if (h.tooltipPos === "right") el.classList.add("mapa-hotspot--label-right");
      if (h.tooltipPos === "left") el.classList.add("mapa-hotspot--label-left");
      el.style.left = (h.x / MAPA_W) * 100 + "%";
      el.style.top = (h.y / MAPA_H) * 100 + "%";
      el.style.width = (h.w / MAPA_W) * 100 + "%";
      el.style.height = (h.h / MAPA_H) * 100 + "%";
      el.dataset.tipo = h.tipo;

      const img = document.createElement("img");
      img.src = `../imgs/${h.imagemHotspot || h.imagem || cenario.imagem}`;
      img.alt = nomeDoPonto(h);
      img.draggable = false;
      el.appendChild(img);

      const label = document.createElement("span");
      label.className = "mapa-hotspot__label";
      label.textContent = nomeDoPonto(h);
      el.appendChild(label);

      el.addEventListener("mouseenter", () => {
        el.classList.add("is-active");
        mostrarCenario(h);
      });
      el.addEventListener("mouseleave", () => {
        el.classList.remove("is-active");
      });
      el.addEventListener("click", () => {
        mostrarCenario(h);
        abrirModal(h);
      });

      frag.appendChild(el);
    });

    hotspotsLayer.appendChild(frag);
  }

  if (hotspotsLayer) montarHotspots();

  document.getElementById("mapa-viewport")?.addEventListener("mouseleave", limparSidebar);
  AUTH.exigirLogin();

  // O perfil diz se o aluno tem turma (sem turma não há régua para as
  // barras, nem missões) e dá o id para o aviso de "novas missões". Uma
  // promessa só, usada pelas duas buscas abaixo.
  const perfilPromessa = AUTH.perfilAtual().catch(() => null);

  carregarAreas();
  carregarSegredos();


  /* ═══════════════════════════════════════════════════════════════════
     MISSÕES ATIVAS — a lista embaixo do mapa

     "Missão" é o nome que o aluno vê para o quiz que o professor passou
     para a turma. Uma chamada só (API.getMeuMapa) devolve as que ainda
     têm pergunta para responder — quiz concluído não vem, então esta
     lista nunca precisa filtrar: o que chega, aparece.

     A mesma resposta acende o botão "Jogar" dos lugares do mapa: um
     lugar é jogável quando alguma missão pendente o cobre.

     Cada card usa a IMAGEM do primeiro lugar que o quiz cobre, a mesma
     do mapa — é o que amarra a lista ao bairro.
     ═══════════════════════════════════════════════════════════════════ */

  const listaMissoes = document.getElementById("missions-list");
  const contadorMissoes = document.getElementById("missoes-contador");

  // Cada acerto vale 10 pontos em cada barra que a questão alimenta.
  // Fixo por enquanto; quando a curva de progressão for definida com a
  // equipe de Medicina, este número sai daqui.
  const PONTOS_POR_ACERTO = 10;

  carregarMissoes();

  async function carregarMissoes() {
    let quizzes = [];
    let erro = "";
    let perfil = null;

    try {
      const [r, p] = await Promise.all([API.getMeuMapa(), perfilPromessa]);
      quizzes = r.quizzes || [];
      perfil = p;
    } catch (err) {
      erro = err.message;
    }

    // Um quiz aparece em cada lugar que cobre. A resposta já vem da mais
    // recente para a mais antiga, e essa ordem se mantém por lugar.
    quizzesPorSlug = new Map();
    for (const quiz of quizzes) {
      for (const slug of quiz.cenarios || []) {
        if (!quizzesPorSlug.has(slug)) quizzesPorSlug.set(slug, []);
        quizzesPorSlug.get(slug).push(quiz);
      }
    }

    // O modal pode já estar aberto, preso no "Carregando missões…".
    if (hotspotDoModal) {
      desenharMissoesDoModal(hotspotDoModal);
      atualizarBotaoJogar(hotspotDoModal);
    }

    if (!listaMissoes) return;

    if (erro) {
      listaMissoes.innerHTML = "";
      if (contadorMissoes) contadorMissoes.textContent = "";

      const aviso = document.createElement("p");
      aviso.className = "missoes-aviso";
      aviso.textContent = erro;
      listaMissoes.appendChild(aviso);
      return;
    }

    desenharMissoes(quizzes, Boolean(perfil && perfil.tipo === "ALUNO" && !perfil.turma_id));
  }

  function desenharMissoes(quizzes, alunoSemTurma = false) {
    listaMissoes.innerHTML = "";

    // É pela turma que as missões chegam. Sem ela, a lista vazia não é
    // "espere o professor" — é "escolha a sua turma".
    if (alunoSemTurma) {
      if (contadorMissoes) contadorMissoes.textContent = "sem turma";

      const vazio = document.createElement("p");
      vazio.className = "missoes-aviso";
      vazio.append("Você ainda não está numa turma — é por ela que as missões chegam. ");
      const link = document.createElement("a");
      link.href = "minha-turma.html";
      link.textContent = "Escolher minha turma";
      vazio.appendChild(link);
      listaMissoes.appendChild(vazio);
      return;
    }

    if (!quizzes.length) {
      if (contadorMissoes) contadorMissoes.textContent = "nenhuma agora";

      const vazio = document.createElement("p");
      vazio.className = "missoes-aviso";
      vazio.textContent =
        "Nenhuma missão por enquanto. Quando o professor passar uma nova, ela aparece aqui!";
      listaMissoes.appendChild(vazio);
      return;
    }

    for (const quiz of quizzes) {
      const card = montarCard(quiz);
      card.addEventListener("click", () => abrirMissaoNoModal(quiz));
      listaMissoes.appendChild(card);
    }

    if (contadorMissoes) {
      contadorMissoes.textContent =
        quizzes.length === 1 ? "1 disponível" : `${quizzes.length} disponíveis`;
    }
  }

  /**
   * Clique num card de "Missões ativas": abre o modal do lugar que a
   * missão cobre, já com ela escolhida. Lugar com vários pontos no mapa
   * (as casas, as ruas) sorteia um — cada casa tem a sua família, então o
   * sorteio é o que varia quem o aluno vai visitar.
   */
  function abrirMissaoNoModal(quiz) {
    const slug = (quiz.cenarios || []).find(s => HOTSPOTS.some(h => h.tipo === s));
    // Missão de um lugar que não está desenhado no mapa: sem modal para
    // abrir, vai direto para ela.
    if (!slug) {
      window.location.href = `missao.html?quiz=${encodeURIComponent(quiz.id)}`;
      return;
    }

    const pontos = HOTSPOTS.filter(h => h.tipo === slug);
    abrirModal(pontos[Math.floor(Math.random() * pontos.length)]);

    const card = [...modalMissoes.querySelectorAll(".mission-item")]
      .find(el => el.dataset.quiz === String(quiz.id));
    if (!card) return;
    escolherMissao(quiz, card);
    card.scrollIntoView({ block: "nearest" });
  }

  /**
   * "Novas missões chegaram!", acima da lista. A régua das barras cresceu
   * desde a última vez que o aluno dispensou o aviso (novas-missoes.js).
   */
  function mostrarAvisoDeNovas(usuarioId, progresso) {
    if (!listaMissoes || typeof NOVAS_MISSOES === "undefined") return;

    const { novas, dispensar } = NOVAS_MISSOES.conferir(usuarioId, progresso);
    if (!novas.length) return;

    listaMissoes.before(NOVAS_MISSOES.montarAviso({ novas, dispensar }));
  }

  /**
   * O card de uma missão (quiz do professor). Sem ação de clique — quem
   * usa decide: a lista de baixo abre o modal do lugar, o modal só escolhe.
   * `imagem` troca a miniatura (o modal usa a do ponto clicado).
   */
  function montarCard(quiz, imagem) {
    const slug = (quiz.cenarios || [])[0];
    const cenario = CENARIOS[slug] || {};

    const feitas = Math.max(0, quiz.total - quiz.restantes);
    const pct = quiz.total ? Math.round((feitas / quiz.total) * 100) : 0;

    const el = document.createElement("div");
    el.className = "mission-item mission-item--tarefa";
    el.dataset.quiz = quiz.id;

    el.innerHTML = `
      <div class="mission-icon">
        <img alt="" draggable="false">
      </div>
      <div class="mission-info">
        <div class="mission-name"></div>
        <div class="mission-desc"></div>
        <div style="margin-top:6px;">
          <div class="progress-track" style="height:4px;">
            <div class="progress-bar"></div>
          </div>
        </div>
      </div>
      <div style="text-align:right;">
        <div class="mission-xp"></div>
        <div class="mission-pct"></div>
      </div>
    `;

    const img = el.querySelector(".mission-icon img");
    img.src = `../imgs/${imagem || cenario.imagem || "UBS.png"}`;
    img.alt = cenario.nome || "";

    el.querySelector(".mission-name").textContent = quiz.titulo;
    el.querySelector(".mission-desc").textContent =
      quiz.descricao || "Missão do professor para a sua turma.";

    el.querySelector(".progress-bar").style.width = `${pct}%`;
    el.querySelector(".mission-xp").textContent = `+${quiz.restantes * PONTOS_POR_ACERTO} XP`;
    el.querySelector(".mission-pct").textContent =
      feitas === 0 ? "Nova" : `${pct}%`;

    return el;
  }

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });
  // ── Zoom e pan ──────────────────────────────────────────
  const viewport = document.getElementById("mapa-viewport");
  const canvas = document.getElementById("mapa-canvas");
  const zoomInBtn = document.getElementById("zoom-in");
  const zoomOutBtn = document.getElementById("zoom-out");
  const zoomResetBtn = document.getElementById("zoom-reset");

  const ZOOM_MIN = 1;
  const ZOOM_MAX = 3.5;
  const ZOOM_STEP = 0.35;

  let zoom = 1;
  let panX = 0;
  let panY = 0;
  let dragging = false;
  let dragStartX = 0;
  let dragStartY = 0;
  let panStartX = 0;
  let panStartY = 0;

  function clampPan() {
    if (!viewport) return;
    const rect = viewport.getBoundingClientRect();
    const maxX = Math.max(0, (rect.width * zoom - rect.width) / 2);
    const maxY = Math.max(0, (rect.height * zoom - rect.height) / 2);
    panX = Math.min(maxX, Math.max(-maxX, panX));
    panY = Math.min(maxY, Math.max(-maxY, panY));
  }

  function aplicarTransform() {
    if (!canvas) return;
    clampPan();
    // Arredonda o deslocamento: translate em pixel fracionado faz o navegador
    // reamostrar o mapa inteiro em subpixel e o desenho sai borrado.
    canvas.style.transform = `translate(${Math.round(panX)}px, ${Math.round(panY)}px) scale(${zoom})`;
    if (zoomResetBtn) zoomResetBtn.textContent = Math.round(zoom * 100) + "%";
    if (viewport) viewport.style.cursor = zoom > 1 ? "grab" : "default";
  }

  function setZoom(novoZoom) {
    zoom = Math.min(ZOOM_MAX, Math.max(ZOOM_MIN, novoZoom));
    if (zoom === ZOOM_MIN) {
      panX = 0;
      panY = 0;
    }
    aplicarTransform();
  }

  zoomInBtn?.addEventListener("click", () => setZoom(zoom + ZOOM_STEP));
  zoomOutBtn?.addEventListener("click", () => setZoom(zoom - ZOOM_STEP));
  zoomResetBtn?.addEventListener("click", () => setZoom(ZOOM_MIN));

  viewport?.addEventListener(
    "wheel",
    (e) => {
      e.preventDefault();
      setZoom(zoom + (e.deltaY < 0 ? ZOOM_STEP : -ZOOM_STEP));
    },
    { passive: false }
  );

  // O navegador tenta arrastar/selecionar a imagem sob o cursor; isso pinta o
  // recorte de azul e cancela o pan no meio do movimento.
  viewport?.addEventListener("dragstart", (e) => e.preventDefault());
  viewport?.addEventListener("selectstart", (e) => {
    if (dragging) e.preventDefault();
  });

  viewport?.addEventListener("pointerdown", (e) => {
    if (zoom <= ZOOM_MIN) return;
    e.preventDefault();
    dragging = true;
    dragStartX = e.clientX;
    dragStartY = e.clientY;
    panStartX = panX;
    panStartY = panY;
    viewport.classList.add("is-panning");
    viewport.setPointerCapture(e.pointerId);
  });

  viewport?.addEventListener("pointermove", (e) => {
    if (!dragging) return;
    panX = panStartX + (e.clientX - dragStartX);
    panY = panStartY + (e.clientY - dragStartY);
    aplicarTransform();
  });

  function pararDrag(e) {
    dragging = false;
    viewport?.classList.remove("is-panning");
  }

  viewport?.addEventListener("pointerup", pararDrag);
  viewport?.addEventListener("pointercancel", pararDrag);

  aplicarTransform();
})();
