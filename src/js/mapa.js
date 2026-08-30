// mapa.js — mapa interativo do bairro (src/pages/mapa.html)
// Coordenadas dos elementos foram medidas manualmente sobre Mapa03.jpg
// (1408x768px) e são uma primeira aproximação — ajuste x/y/w/h abaixo
// conforme necessário para refinar o alinhamento visual.

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
    baldio: {
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
      nome: "Ruas",
      imagem: "Ruas.png.jpg",
      descricao: "Missões de caminhada e separação de lixo por cor, reforçando hábitos sustentáveis no dia a dia.",
    },
    casa: {
      nome: "Casa",
      imagem: "Casa.png",
      descricao: "Visitas do ACS a moradores diferentes, cada um com uma história e um problema de saúde distinto a ser identificado e resolvido.",
      semOverlay: true,
    },
  };

  // Retângulos (x, y, largura, altura) em pixels sobre a imagem original 1408x768.
  const HOTSPOTS = [
    { tipo: "parque", x: 495, y: 0, w: 410, h: 120 },
    { tipo: "escola", x: 783, y: 110, w: 182, h: 150 },
    { tipo: "farmacia", x: 438, y: 153, w: 112, h: 92 },
    { tipo: "upa", x: 562, y: 150, w: 92, h: 95 },
    { tipo: "ubs", x: 438, y: 250, w: 122, h: 102 },
    { tipo: "banca", x: 857, y: 277, w: 113, h: 84 },
    { tipo: "praca", x: 597, y: 282, w: 206, h: 210 },
    { tipo: "mercado", x: 857, y: 387, w: 129, h: 97 },
    { tipo: "creche", x: 733, y: 512, w: 173, h: 99 },
    { tipo: "igreja", x: 1112, y: 458, w: 140, h: 157 },
    { tipo: "quadra", x: 1034, y: 332, w: 212, h: 127 },
    { tipo: "baldio", x: 1034, y: 162, w: 212, h: 170 },
    { tipo: "corrego", x: 176, y: 0, w: 88, h: 725 },
    { tipo: "rio", x: 0, y: 684, w: 1408, h: 84 },
    { tipo: "ruas", x: 272, y: 628, w: 1042, h: 50 },

    // Casas (múltiplas instâncias do mesmo cenário espalhadas pelo bairro)
    { tipo: "casa", x: 53, y: 8, w: 100, h: 110 },
    { tipo: "casa", x: 268, y: 22, w: 107, h: 106 },
    { tipo: "casa", x: 388, y: 22, w: 94, h: 106 },
    { tipo: "casa", x: 933, y: 12, w: 84, h: 106 },
    { tipo: "casa", x: 1038, y: 22, w: 84, h: 106 },
    { tipo: "casa", x: 1193, y: 12, w: 100, h: 100 },
    { tipo: "casa", x: 0, y: 210, w: 68, h: 112 },
    { tipo: "casa", x: 1338, y: 210, w: 70, h: 112 },
    { tipo: "casa", x: 1338, y: 445, w: 70, h: 112 },
    { tipo: "casa", x: 268, y: 172, w: 107, h: 92 },
    { tipo: "casa", x: 268, y: 260, w: 107, h: 92 },
    { tipo: "casa", x: 268, y: 392, w: 104, h: 90 },
    { tipo: "casa", x: 388, y: 392, w: 94, h: 90 },
    { tipo: "casa", x: 488, y: 392, w: 100, h: 90 },
    { tipo: "casa", x: 905, y: 510, w: 82, h: 100 },
    { tipo: "casa", x: 268, y: 512, w: 104, h: 100 },
    { tipo: "casa", x: 388, y: 512, w: 94, h: 100 },
    { tipo: "casa", x: 602, y: 512, w: 66, h: 100 },
  ];

  const hotspotsLayer = document.getElementById("mapa-hotspots");
  const sidebarEmpty = document.getElementById("mapa-sidebar-empty");
  const sidebarContent = document.getElementById("mapa-sidebar-content");
  const sidebarThumb = document.getElementById("mapa-sidebar-thumb");
  const sidebarNome = document.getElementById("mapa-sidebar-nome");
  const sidebarDesc = document.getElementById("mapa-sidebar-desc");
  const sidebarPlay = document.getElementById("mapa-sidebar-play");

  function mostrarCenario(tipo) {
    const cenario = CENARIOS[tipo];
    if (!cenario) return;
    sidebarThumb.src = `../imgs/${cenario.imagem}`;
    sidebarThumb.alt = cenario.nome;
    sidebarNome.textContent = cenario.nome;
    sidebarDesc.textContent = cenario.descricao;
    sidebarPlay.dataset.cenario = tipo;
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
      el.className = "mapa-hotspot" + (cenario.semOverlay ? " mapa-hotspot--zone" : "");
      el.style.left = (h.x / MAPA_W) * 100 + "%";
      el.style.top = (h.y / MAPA_H) * 100 + "%";
      el.style.width = (h.w / MAPA_W) * 100 + "%";
      el.style.height = (h.h / MAPA_H) * 100 + "%";
      el.dataset.tipo = h.tipo;

      if (!cenario.semOverlay) {
        const img = document.createElement("img");
        img.src = `../imgs/${cenario.imagem}`;
        img.alt = cenario.nome;
        img.draggable = false;
        el.appendChild(img);
      }

      const label = document.createElement("span");
      label.className = "mapa-hotspot__label";
      label.textContent = cenario.nome;
      el.appendChild(label);

      el.addEventListener("mouseenter", () => {
        el.classList.add("is-active");
        mostrarCenario(h.tipo);
      });
      el.addEventListener("mouseleave", () => {
        el.classList.remove("is-active");
      });
      el.addEventListener("click", () => {
        mostrarCenario(h.tipo);
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
    canvas.style.transform = `translate(${panX}px, ${panY}px) scale(${zoom})`;
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

  viewport?.addEventListener("pointerdown", (e) => {
    if (zoom <= ZOOM_MIN) return;
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
