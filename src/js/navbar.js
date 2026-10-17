/** navbar.js — desenha a barra de navegação em <nav data-navbar> conforme o tipo de usuário.
    Carregado depois de supabase.js e antes do script da página. */
(() => {
  'use strict';

  /* ── Menu ── `perfil` diz para quem o item existe (ADMIN vê tudo). */
  const MENU = [
    { texto: 'Turmas',        href: 'dashboard.html', perfil: ['PROFESSOR'] },
    { texto: 'Quizes',        href: 'quizzes.html',   perfil: ['PROFESSOR'] },
    { texto: 'Ranking',       href: 'ranking.html',   perfil: ['PROFESSOR'] },

    { texto: 'Mapa',          href: 'mapa.html',        perfil: ['ALUNO'] },
    { texto: 'Minha turma',   href: 'minha-turma.html', perfil: ['ALUNO'] },
    { texto: 'Meu progresso', href: 'progresso.html',   perfil: ['ALUNO'] },

    // O único item que o ADMIN vê por ser citado, e não por ver tudo.
    { texto: 'Equipe',        href: 'admin.html',       perfil: ['ADMIN'] }
  ];

  const LOGO = `<svg width="18" height="18" viewBox="0 0 24 24" fill="#fff" aria-hidden="true">
      <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
    </svg>`;

  /* ── Canto do perfil ── avatar (foto ou iniciais) e o menu com "Sair". */
  const ROTULO_TIPO = { ALUNO: 'Aluno', PROFESSOR: 'Professor', ADMIN: 'Equipe' };

  /* ── Etiqueta de patente ── global window.PATENTE; a cor vem de nivel.faixa. */
  window.PATENTE = {
    /** A classe da faixa, ou '' quando o servidor é antigo e não a manda. */
    classe(nivel) {
      const n = nivel && Number(nivel.faixa);
      return n >= 1 && n <= 10 ? ` patente-tag--${n}` : '';
    },

    /** Transforma um <span> em etiqueta (mantém a classe original). */
    pintar(elemento, nivel, mini) {
      if (!elemento) return;
      const base = this.base(elemento);

      if (!nivel || !nivel.patente) { elemento.textContent = ''; elemento.hidden = true; return; }

      elemento.className =
        `${base} patente-tag${mini ? ' patente-tag--mini' : ''}${this.classe(nivel)}`.trim();
      elemento.textContent = nivel.patente;
      elemento.title = `Nível ${nivel.nivel} de ${nivel.total_de_niveis || 100}`;
      elemento.hidden = false;
    },

    /** Só a cor, sem o chip. */
    tingir(elemento, nivel) {
      if (!elemento) return;
      const base = this.base(elemento);
      const n = nivel && Number(nivel.faixa);

      elemento.className = n >= 1 && n <= 10 ? `${base} patente-cor--${n}` : base;
      elemento.textContent = (nivel && nivel.patente) || '';
    },

    /** A classe que o elemento tinha antes de nós, guardada na primeira vez. */
    base(elemento) {
      if (elemento.dataset.classeBase === undefined) {
        elemento.dataset.classeBase = (elemento.className || '')
          .split(/\s+/).filter(c => c && !/^patente-(tag|cor)/.test(c)).join(' ');
      }
      return elemento.dataset.classeBase;
    },

    /** O mesmo, em texto, para quem monta HTML por template. */
    html(nivel, mini) {
      if (!nivel || !nivel.patente) return '';
      const nome = String(nivel.patente).replace(/[&<>"']/g,
        c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
      return `<span class="patente-tag${mini ? ' patente-tag--mini' : ''}${this.classe(nivel)}">${nome}</span>`;
    }
  };

  const ICONES = {
    perfil: '<path d="M12 12a4 4 0 100-8 4 4 0 000 8z"/><path d="M4 20c0-3.3 3.6-5.5 8-5.5s8 2.2 8 5.5"/>',
    troferu: '<path d="M8 4h8v5a4 4 0 01-8 0V4z"/><path d="M8 6H5v1a3 3 0 003 3M16 6h3v1a3 3 0 01-3 3"/><path d="M10 17h4M12 13v4M9 20h6"/>',
    livro: '<path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>',
    sair: '<path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><path d="M16 17l5-5-5-5M21 12H9"/>'
  };

  const icone = (nome) =>
    `<svg class="perfil__icone" viewBox="0 0 24 24" fill="none" stroke="currentColor"
       stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"
       aria-hidden="true">${ICONES[nome]}</svg>`;

  const PERFIL = `
    <div class="perfil">
      <button type="button" class="perfil__botao" id="perfil-botao"
              aria-haspopup="true" aria-expanded="false" aria-label="Sua conta">
        <span class="perfil__avatar" id="perfil-avatar"></span>
        <svg class="perfil__seta" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2.2" stroke-linecap="round" aria-hidden="true">
          <path d="M6 9l6 6 6-6"/>
        </svg>
      </button>

      <div class="perfil__menu" id="perfil-menu" hidden>
        <div class="perfil__cabeca">
          <span class="perfil__avatar perfil__avatar--menu" id="perfil-avatar-menu"></span>
          <span class="perfil__cabeca-texto">
            <span class="perfil__nome" id="perfil-nome">…</span>
            <span class="perfil__tipo" id="perfil-tipo"></span>
          </span>
        </div>

        <ul class="perfil__lista">
          <li>
            <a href="perfil.html" class="perfil__item">
              ${icone('perfil')}<span>Meu perfil</span>
            </a>
          </li>
          <li>
            <a href="conquistas.html" class="perfil__item">
              ${icone('troferu')}<span>Minhas conquistas</span>
            </a>
          </li>
          <li>
            <!-- A bibliografia das questoes. Fica aqui, e nao na barra
                 de links, porque ela esta em toda pagina do jogo e a
                 barra ja tem sete itens para o ADMIN. -->
            <a href="referencias.html" class="perfil__item">
              ${icone('livro')}<span>Referências</span>
            </a>
          </li>
          <li>
            <button type="button" class="perfil__item perfil__item--sair" id="logout-btn">
              ${icone('sair')}<span>Sair</span>
            </button>
          </li>
        </ul>
      </div>
    </div>`;

  iniciar();

  async function iniciar() {
    const alvo = document.querySelector('[data-navbar]');
    const antigos = document.querySelectorAll('[data-perfil]');

    // Nada a fazer nesta página (o login, por exemplo).
    if (!alvo && !antigos.length) return;

    // Na dúvida, não esconde nada.
    const tipo = String(await descobrirTipo() || '').trim().toUpperCase();

    if (alvo) {
      desenhar(alvo, tipo);

      // Só liga o "Sair" que esta barra desenhou.
      ligarSair();
      ligarMenuDoPerfil();
      preencherPerfil();
    } else if (tipo) {
      filtrarOAntigo(antigos, tipo);
    }

    // Aluno e professor têm barra de nível.
    if (tipo) mostrarProgresso();
  }

  /** Menu do perfil: fecha pelo botão, clique fora ou Esc. */
  function ligarMenuDoPerfil() {
    const botao = document.getElementById('perfil-botao');
    const menu = document.getElementById('perfil-menu');
    if (!botao || !menu) return;

    const fechar = () => {
      menu.hidden = true;
      botao.setAttribute('aria-expanded', 'false');
    };

    botao.addEventListener('click', (ev) => {
      ev.stopPropagation();          // senão o clique que abre já fecha
      const abrindo = menu.hidden;
      menu.hidden = !abrindo;
      botao.setAttribute('aria-expanded', String(abrindo));
    });

    // Clique dentro do menu não fecha — a pessoa pode estar só mirando.
    menu.addEventListener('click', (ev) => ev.stopPropagation());

    document.addEventListener('click', fechar);
    document.addEventListener('keydown', (ev) => {
      if (ev.key !== 'Escape' || menu.hidden) return;
      fechar();
      botao.focus();                 // o foco volta para onde estava
    });
  }

  /** Nome e avatar de quem está logado (depois da barra desenhada). */
  async function preencherPerfil() {
    const avatar = document.getElementById('perfil-avatar');
    if (!avatar) return;

    let perfil = null;
    try { perfil = await AUTH.perfilAtual(); } catch (_) { /* segue com o genérico */ }
    if (!perfil) return;

    // Avatar do botão e o de dentro do menu.
    desenharAvatar(avatar, perfil.nome, perfil.avatar_url);
    desenharAvatar(document.getElementById('perfil-avatar-menu'), perfil.nome, perfil.avatar_url);

    const nome = document.getElementById('perfil-nome');
    const tipo = document.getElementById('perfil-tipo');

    // textContent: nome é texto escrito por pessoa, nunca código.
    if (nome) nome.textContent = perfil.nome || 'Minha conta';
    if (tipo) tipo.textContent = ROTULO_TIPO[perfil.tipo] || '';
  }

  /** Foto ou iniciais (exposto em window.AVATAR). */
  function desenharAvatar(alvo, nome, url) {
    if (!alvo) return;

    alvo.innerHTML = '';
    alvo.classList.remove('perfil__avatar--foto');

    if (!url) {
      alvo.textContent = iniciais(nome);
      return;
    }

    const img = document.createElement('img');
    img.src = url;
    img.alt = '';

    // Imagem quebrada: volta às iniciais.
    img.onerror = () => {
      alvo.innerHTML = '';
      alvo.classList.remove('perfil__avatar--foto');
      alvo.textContent = iniciais(nome);
    };

    alvo.classList.add('perfil__avatar--foto');
    alvo.appendChild(img);
  }

  window.AVATAR = { desenhar: desenharAvatar, iniciais };

  /** "Ana Clara Souza" -> "AS". Uma letra só quando não há sobrenome. */
  function iniciais(nome) {
    const partes = String(nome || '').trim().split(/\s+/).filter(Boolean);
    if (!partes.length) return '?';
    if (partes.length === 1) return partes[0].charAt(0).toUpperCase();
    return (partes[0].charAt(0) + partes[partes.length - 1].charAt(0)).toUpperCase();
  }

  /** ADMIN vê tudo; sem tipo conhecido, também — melhor demais que de menos. */
  function podeVer(item, tipo) {
    return !tipo || tipo === 'ADMIN' || item.perfil.includes(tipo);
  }

  function desenhar(nav, tipo) {
    const aqui = (location.pathname.split('/').pop() || 'index.html').toLowerCase();

    const links = MENU.filter(i => podeVer(i, tipo)).map(i => {
      const atual = i.href.toLowerCase() === aqui;
      const classe = atual ? ' class="navbar__ativo active"' : '';
      const marca = atual ? ' aria-current="page"' : '';
      return `<li><a href="${i.href}"${classe}${marca}>${i.texto}</a></li>`;
    }).join('');

    // A barra de nível nasce escondida até o servidor responder.
    nav.innerHTML = `
      <div class="topLine">
        <div class="navbar__inner">
          <div class="navbar__logo">
            <div class="navbar__logo-dot">${LOGO}</div>
            HERÓIS DA SAÚDE
          </div>

          <div class="navbar__acoes">
            <ul class="navbar__links">${links}</ul>

            <!-- A patente em cima e, embaixo, "Nv. 5" ao lado da
                 barra. O XP por extenso fica no title e na tela "Meu
                 progresso"; cada ganho aparece como "+10 XP" logo
                 abaixo (mostrarGanho). -->
            <div class="nivel-nav" data-nivel hidden></div>

            ${PERFIL}
          </div>
        </div>
      </div>`;
  }

  /** O jeito antigo: a barra já está escrita no HTML, aqui só se apaga. */
  function filtrarOAntigo(itens, tipo) {
    itens.forEach(item => {
      const permitidos = item.dataset.perfil.trim().toUpperCase().split(/\s+/);
      if (tipo !== 'ADMIN' && !permitidos.includes(tipo)) item.remove();
    });
  }

  /** Liga o botão "Sair". */
  function ligarSair() {
    const botao = document.getElementById('logout-btn');
    if (!botao || botao.dataset.ligado) return;

    botao.dataset.ligado = '1';
    botao.addEventListener('click', async () => {
      botao.disabled = true;
      try { await AUTH.logout(); } catch (_) { /* sair sempre leva ao login */ }
      window.location.href = 'index.html';
    });
  }

  /* ── Barra de nível ── em qualquer <div data-nivel>; window.NIVEL.atualizar() redesenha. */

  let ultimoNivel = null;

  window.NIVEL = {
    atualizar(nivel, xp) {
      if (!nivel) return;
      ultimoNivel = { nivel, xp };

      // Ignora os data-nivel dos modais (nível etário).
      document.querySelectorAll('[data-nivel]:not(.modal [data-nivel])')
        .forEach(el => desenharNivel(el, nivel, xp));

      anunciarGanho(xp);
    },

    atual: () => ultimoNivel
  };

  /* ── "+N XP" ── compara com o último XP visto (localStorage, por conta); só sobe. */

  const CHAVE_XP = 'herois_xp_visto:';

  async function anunciarGanho(xp) {
    if (typeof xp !== 'number') return;

    let conta = null;
    try { conta = await AUTH.contaAtual(); } catch (_) { return; }
    if (!conta) return;

    let guardado = null;
    try { guardado = localStorage.getItem(CHAVE_XP + conta.id); } catch (_) { return; }

    // Primeira vez neste navegador: só guarda.
    const visto = guardado === null ? NaN : Number(guardado);
    const conhecido = Number.isFinite(visto);

    if (conhecido && xp > visto) mostrarGanho(xp - visto);

    if (!conhecido || xp > visto) {
      try { localStorage.setItem(CHAVE_XP + conta.id, String(xp)); } catch (_) { /* segue sem lembrar */ }
    }
  }

  /** O número que sobe e some, junto da barra da navbar. */
  function mostrarGanho(ganho) {
    document.querySelectorAll('.nivel-nav:not([hidden])').forEach(el => {
      const numero = document.createElement('span');
      numero.className = 'nivelzinho__ganho';
      numero.textContent = `+${ganho.toLocaleString('pt-BR')} XP`;
      numero.setAttribute('aria-hidden', 'true');   // o leitor de tela já ouve o aviso do quiz
      el.appendChild(numero);

      // Reinicia a animação de brilho.
      el.classList.remove('nivelzinho--ganhou');
      void el.offsetWidth;
      el.classList.add('nivelzinho--ganhou');

      const sumir = () => numero.remove();
      numero.addEventListener('animationend', sumir, { once: true });
      setTimeout(sumir, 2600);   // quem desligou as animações não recebe animationend
    });
  }

  function desenharNivel(el, nivel, xp) {
    el.classList.add('nivelzinho');

    // A barra nasce escondida até o servidor responder.
    el.hidden = false;

    // title explica a barra da navbar.
    el.title = nivel.maximo
      ? `${nivel.patente} — nível máximo`
      : `${nivel.patente} · faltam ${nivel.faltam} XP para o nível ${nivel.nivel + 1}`;

    const feito = (xp ?? 0) - nivel.xp_do_nivel;
    const trecho = nivel.maximo ? 0 : nivel.xp_do_proximo - nivel.xp_do_nivel;

    // Montada uma vez e depois só atualizada (para a transição aparecer).
    if (!el.querySelector('.nivelzinho__barra')) {
      el.innerHTML = `
        <div class="nivelzinho__topo">
          <span class="nivelzinho__patente"></span>
          <span class="nivelzinho__nv"></span>
        </div>
        <div class="nivelzinho__linha">
          <span class="nivelzinho__nv-curto"></span>
          <span class="nivelzinho__barra"><i></i></span>
        </div>
        <span class="nivelzinho__nota"></span>`;
    }

    window.PATENTE.tingir(el.querySelector('.nivelzinho__patente'), nivel);
    el.querySelector('.nivelzinho__nv').textContent =
      `Nível ${nivel.nivel}/${nivel.total_de_niveis || 100}`;
    el.querySelector('.nivelzinho__nv-curto').textContent = `Nv. ${nivel.nivel}`;

    encherBarra(el, nivel);

    // Dois números concretos em vez de uma porcentagem: "190 de 300 XP"
    // diz o que falta fazer, "63%" não.
    el.querySelector('.nivelzinho__nota').textContent = nivel.maximo
      ? `${(xp ?? 0).toLocaleString('pt-BR')} XP · nível máximo`
      : `${feito.toLocaleString('pt-BR')} de ${trecho.toLocaleString('pt-BR')} XP` +
        (nivel.proxima_patente ? ` · depois: ${nivel.proxima_patente}` : '');
  }

  /** Leva o traço à porcentagem nova; ao subir de nível, enche até o fim e recomeça do zero. */
  function encherBarra(el, nivel) {
    const traco = el.querySelector('.nivelzinho__barra i');
    const antes = Number(el.dataset.nivelDesenhado) || 0;
    el.dataset.nivelDesenhado = nivel.nivel;
    traco.dataset.alvo = nivel.porcentagem;

    if (traco.dataset.subindo) return;   // a subida em curso usa o alvo novo

    if (!antes || nivel.nivel <= antes) {
      traco.style.width = `${nivel.porcentagem}%`;
      return;
    }

    traco.dataset.subindo = '1';
    traco.style.width = '100%';

    setTimeout(() => {
      traco.style.transition = 'none';
      traco.style.width = '0%';
      void traco.offsetWidth;           // o navegador precisa ver o zero
      traco.style.transition = '';
      traco.style.width = `${traco.dataset.alvo}%`;
      delete traco.dataset.subindo;
    }, 950);
  }

  /** Marca a presença do dia e mostra nível e XP. Se falhar, a barra fica escondida. */
  async function mostrarProgresso() {
    // typeof: `const API` não vira window.API.
    if (typeof API === 'undefined' || !API.marcarPresenca) {
      console.warn('[navbar] API.marcarPresenca não existe — o api.js foi carregado antes deste arquivo?');
      return;
    }

    try {
      const r = await API.marcarPresenca();

      // Preenche a barrinha da navbar E toda <div data-nivel> da página.
      window.NIVEL.atualizar(r.nivel, r.xp);

      // Insígnias de sequência e as novas do catálogo.
      if (typeof CONQUISTA_AVISO !== 'undefined') CONQUISTA_AVISO.mostrar(r.insignias_novas);

      if (!r.nivel) {
        console.warn('[navbar] /presenca respondeu sem "nivel"; a barrinha fica escondida.', r);
      }

    } catch (erro) {
      // Erro vai para o console; a barra continua escondida.
      console.warn(
        `[navbar] não deu para carregar seu XP (${erro.status || 'sem resposta'}): ${erro.message}`
      );
    }
  }

  /** Usa o tipo lembrado no navegador; senão, pergunta ao banco. */
  async function descobrirTipo() {
    const lembrado = AUTH.tipoLembrado && AUTH.tipoLembrado();
    if (lembrado) return lembrado;

    try {
      const perfil = await AUTH.perfilAtual();
      if (perfil && perfil.tipo) {
        if (AUTH.lembrarTipo) AUTH.lembrarTipo(perfil.tipo);
        return perfil.tipo;
      }
    } catch (_) { /* sem sessão: a própria página cuida do redirecionamento */ }

    return null;
  }
})();
