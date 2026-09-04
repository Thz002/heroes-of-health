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
    },
    escola: {
      nome: "Escola",
      imagem: "Escola.png",
      descricao: "Calendário anual de campanhas educativas, reforçando a integração entre saúde e educação.",
    },
    farmacia: {
      nome: "Farmácia",
      imagem: "Farmacia.jpg",
      descricao: "Calendário anual de campanhas de saúde, avisos de cobertura vacinal e atividades que relacionam vacinas às doenças que elas previnem.",
    },
    upa: {
      nome: "UPA",
      imagem: "UPA.png",
      descricao: "Casos urgentes que exigem atendimento rápido, ensinando o jogador a identificar prioridades em situações de emergência.",
    },
    ubs: {
      nome: "UBS",
      imagem: "UBS.png",
      descricao: "Centro de referência do bairro, onde o jogador acompanha consultas, campanhas e o cuidado contínuo do seu paciente virtual.",
    },
    banca: {
      nome: "Banca de jornal",
      imagem: "Banca.png",
      descricao: "Charges educativas, avisos de campanhas de vacinação e um espaço dedicado a identificar fake news sobre saúde.",
    },
    praca: {
      nome: "Pracinha",
      imagem: "Praca.jpg",
      descricao: "Ginástica ao ar livre, cuidados com insolação em dias quentes, rodas de conversa e dias de aferição de pressão arterial.",
    },
    mercado: {
      nome: "Mercado",
      imagem: "Mercado.png",
      descricao: "Missões sobre alimentação saudável, leitura de rótulos, segurança alimentar, conservação e higiene dos alimentos.",
    },
    creche: {
      nome: "Creche",
      imagem: "Creche.png",
      descricao: "Missões voltadas ao cuidado infantil, desenvolvimento na primeira infância e prevenção de doenças comuns nessa fase.",
    },
    igreja: {
      nome: "Centro religioso",
      imagem: "Igreja.png",
      descricao: "Espaço de acolhimento para temas de saúde mental, com foco em escuta e combate ao estigma.",
    },
    quadra: {
      nome: "Campo de lazer",
      imagem: "Quadra.png",
      descricao: "Atividades físicas coletivas em quadras, incentivando exercício e convivência comunitária.",
    },
    "terreno-baldio": {
      nome: "Terreno baldio",
      imagem: "Baldio.png",
      descricao: "Representa o lixão do bairro; missões de conscientização sobre descarte irregular de lixo e seus riscos à saúde.",
    },
    corrego: {
      nome: "Córrego",
      imagem: "Corrego.png",
      descricao: "O jogador aprende a reportar às autoridades civis situações de risco, como surtos de doenças ligadas à água contaminada.",
    },
    rio: {
      nome: "Rio",
      imagem: "Rio.png",
      descricao: "Missões de educação ambiental e mutirões de limpeza, ligando meio ambiente e saúde pública.",
    },
    ruas: {
      nome: "Rua",
      imagem: "Ruas.png",
      descricao: "Missões de caminhada e separação de lixo por cor, reforçando hábitos sustentáveis no dia a dia.",
    },
    casa: {
      nome: "Casa",
      imagem: "Casa.png",
      descricao: "Visitas do ACS a moradores diferentes, cada um com uma história e um problema de saúde distinto a ser identificado e resolvido.",
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

    { tipo: "ruas", imagemHotspot: "Ruas01.jpg", x: 278, y: 122, w: 1036, h: 41 },
    { tipo: "ruas", imagemHotspot: "Ruas02.jpg", x: 93, y: 126, w: 58, h: 555, tooltipPos: "right" },
    { tipo: "ruas", imagemHotspot: "Ruas03.png", x: 470, y: 623, w: 272, h: 61 },
    { tipo: "ruas", imagemHotspot: "Ruas04.png", x: 988, y: 575, w: 50, h: 156 },
    { tipo: "ruas", imagemHotspot: "Ruas05.png", x: 395, y: 126, w: 920, h: 50 },
    { tipo: "ruas", imagemHotspot: "Ruas06.png", x: 980, y: 622, w: 64, h: 63 },
    { tipo: "ruas", imagemHotspot: "Ruas08.png", x: 376, y: 125, w: 63, h: 259 },
    { tipo: "ruas", imagemHotspot: "Ruas09.png", x: 786, y: 253, w: 63, h: 260 },
    { tipo: "ruas", imagemHotspot: "Ruas10.png", x: 982, y: 617, w: 59, h: 73 },
    { tipo: "ruas", imagemHotspot: "Ruas11.png", x: 986, y: 202, w: 52, h: 392 },
    { tipo: "ruas", imagemHotspot: "Ruas12.png", x: 1256, y: 128, w: 52, h: 400 },
    { tipo: "ruas", imagemHotspot: "Ruas13.png", x: 1256, y: 650, w: 80, h: 51 },
    { tipo: "ruas", imagemHotspot: "Ruas14.png", x: 552, y: 256, w: 66, h: 63 },
    { tipo: "ruas", imagemHotspot: "Ruas15.png", x: 1256, y: 592, w: 123, h: 96 },


    { tipo: "casa", imagem: "Casa.png", x: 253, y: 230, w: 125, h: 126},
    { tipo: "casa", imagem: "Casa03.png", x:465, y: 387, w: 85, h: 110 },
    { tipo: "casa", imagem: "Casa013.png", x: 372, y: 390, w: 85, h: 105 },
    { tipo: "casa", imagem: "Casa06.png", x: 930, y: 25, w: 98, h: 93, tooltipPos: "bottom" },
    { tipo: "casa", imagem: "Casa07.png", x: 1039, y: 20, w: 110, h: 80, tooltipPos: "bottom" },
    { tipo: "casa", imagem: "Casa014.png", x: 480, y: 512, w: 75, h: 100 },
    { tipo: "casa", imagem: "Casa09.png", x: 385, y: 10, w: 90, h: 100, tooltipPos: "bottom" },
    { tipo: "casa", imagem: "Casa010.png", x: 350, y: 514, w: 125, h: 100 },
    { tipo: "casa", imagem: "Casa011.png", x: 253, y: 387, w: 110, h: 115 },
    { tipo: "casa", imagem: "Casa08.png", x: 548, y: 500, w: 110, h: 115 },
    { tipo: "casa", imagem: "Casa012.png", x: 880, y: 502, w: 110, h: 110 },
    { tipo: "casa", imagem: "Casa02.png", x: 253, y: 139, w: 127, h: 107 },
    { tipo: "casa", imagem: "Casa015.png", x: 238, y: 20, w: 145, h: 100, tooltipPos: "bottom" },
    { tipo: "casa", imagem: "Casa05.png", x: 80, y: 20, w: 80, h: 90 },
    { tipo: "casa", imagem: "Casa04.png", x: 1041, y: 515, w: 85, h: 105, tooltipPos: "bottom" },
    { tipo: "casa", imagem: "Casa016.png", x: 1182, y: 8, w: 150, h: 100, tooltipPos: "bottom" },

    { tipo: "casa", imagem: "CasaLateral03.png", x: 15, y: 200, w: 68, h: 112 },
    { tipo: "casa", imagem: "CasaLateral01.png", x: 15, y: 442, w: 80, h: 105 },
    { tipo: "casa", imagem: "CasaLateral02.png", x: 1335, y: 200, w: 70, h: 112 },
    { tipo: "casa", imagem: "CasaLateral04.png", x: 1335, y: 430, w: 73, h: 113 },
  ];

  const hotspotsLayer = document.getElementById("mapa-hotspots");
  const sidebarEmpty = document.getElementById("mapa-sidebar-empty");
  const sidebarContent = document.getElementById("mapa-sidebar-content");
  const sidebarThumb = document.getElementById("mapa-sidebar-thumb");
  const sidebarNome = document.getElementById("mapa-sidebar-nome");
  const sidebarDesc = document.getElementById("mapa-sidebar-desc");
  const sidebarPlay = document.getElementById("mapa-sidebar-play");
  const btnSair = document.getElementById("logout-btn");

  function mostrarCenario(h) {
    const cenario = CENARIOS[h.tipo];
    if (!cenario) return;
    sidebarThumb.src = `../imgs/${h.imagem || cenario.imagem}`;
    sidebarThumb.alt = cenario.nome;
    sidebarNome.textContent = cenario.nome;
    sidebarDesc.textContent = cenario.descricao;
    sidebarPlay.dataset.cenario = h.tipo;
    sidebarEmpty.hidden = true;
    sidebarContent.hidden = false;
  }

  function limparSidebar() {
    sidebarEmpty.hidden = false;
    sidebarContent.hidden = true;
  }

  function montarHotspots() {
    const frag = document.createDocumentFragment();

    HOTSPOTS.forEach((h) => {
      const cenario = CENARIOS[h.tipo];
      const el = document.createElement("div");
      el.className = "mapa-hotspot";
      if (h.tooltipPos === "bottom") el.classList.add("mapa-hotspot--label-bottom");
      if (h.tooltipPos === "right") el.classList.add("mapa-hotspot--label-right");
      el.style.left = (h.x / MAPA_W) * 100 + "%";
      el.style.top = (h.y / MAPA_H) * 100 + "%";
      el.style.width = (h.w / MAPA_W) * 100 + "%";
      el.style.height = (h.h / MAPA_H) * 100 + "%";
      el.dataset.tipo = h.tipo;

      const img = document.createElement("img");
      img.src = `../imgs/${h.imagemHotspot || h.imagem || cenario.imagem}`;
      img.alt = cenario.nome;
      img.draggable = false;
      el.appendChild(img);

      const label = document.createElement("span");
      label.className = "mapa-hotspot__label";
      label.textContent = cenario.nome;
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
      });

      frag.appendChild(el);
    });

    hotspotsLayer.appendChild(frag);
  }

  if (hotspotsLayer) montarHotspots();

  if (sidebarPlay) {
    sidebarPlay.addEventListener("click", () => {
      const tipo = sidebarPlay.dataset.cenario;
      if (!tipo) return;
      window.location.href = `missao.html?cenario=${encodeURIComponent(tipo)}`;
    });
  }

  document.getElementById("mapa-viewport")?.addEventListener("mouseleave", limparSidebar);
  AUTH.exigirLogin();

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
