/**
 * navbar.js — uma barra só, desenhada aqui
 *
 * O professor e o aluno usam as mesmas páginas de estrutura, mas não têm
 * o que fazer nos mesmos lugares: "Turmas" e "Quizes" são do professor,
 * "Mapa" e "Meu progresso" são do aluno.
 *
 * O PROBLEMA QUE ISTO RESOLVE: a barra estava copiada dentro de seis
 * arquivos HTML. Acrescentar um link era editar seis lugares, e eles já
 * tinham saído de sincronia — o mapa apontava "Turmas" para missao.html
 * e "Quizes" para o próprio mapa. Agora a lista mora em um lugar só,
 * aqui embaixo, e a página só declara onde a barra entra:
 *
 *     <nav class="nav_bar" data-navbar></nav>
 *
 * PÁGINAS ANTIGAS CONTINUAM FUNCIONANDO. Sem o data-navbar, este arquivo
 * faz o que sempre fez: apaga os <li data-perfil="..."> que não são de
 * quem está logado. Assim dá para migrar uma página de cada vez.
 *
 * Carregado DEPOIS de supabase.js (usa AUTH) e antes do script da página.
 */
(() => {
  'use strict';

  /* ── O MENU ─────────────────────────────────────────────────────────
     A lista inteira do projeto. Para mudar a barra, é este pedaço.

     `perfil` diz para quem o item existe. ADMIN é a equipe do projeto e
     vê tudo, sem precisar ser citado.

     O professor NÃO tem Mapa: o mapa é a tela de jogar, e ele não joga.
     O aluno NÃO tem Ranking: ranking.html é a classificação das TURMAS,
     coisa de professor — a posição do aluno entre os colegas dele fica
     dentro de "Meu progresso", que é onde ela faz sentido.
     ───────────────────────────────────────────────────────────────── */
  const MENU = [
    { texto: 'Turmas',        href: 'dashboard.html', perfil: ['PROFESSOR'] },
    { texto: 'Quizes',        href: 'quizzes.html',   perfil: ['PROFESSOR'] },
    { texto: 'Ranking',       href: 'ranking.html',   perfil: ['PROFESSOR'] },

    { texto: 'Mapa',          href: 'mapa.html',        perfil: ['ALUNO'] },
    { texto: 'Minha turma',   href: 'minha-turma.html', perfil: ['ALUNO'] },
    { texto: 'Meu progresso', href: 'progresso.html',   perfil: ['ALUNO'] }
  ];

  const LOGO = `<svg width="18" height="18" viewBox="0 0 24 24" fill="#fff" aria-hidden="true">
      <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
    </svg>`;

  iniciar();

  async function iniciar() {
    const alvo = document.querySelector('[data-navbar]');
    const antigos = document.querySelectorAll('[data-perfil]');

    // Nada a fazer nesta página (o login, por exemplo).
    if (!alvo && !antigos.length) return;

    // Em dúvida, não esconde nada: uma barra cheia demais é um incômodo,
    // uma barra vazia é a pessoa achando que o sistema quebrou.
    const tipo = String(await descobrirTipo() || '').trim().toUpperCase();

    if (alvo) {
      desenhar(alvo, tipo);

      // Só quem desenhou o botão é que o liga. Nas páginas do modo
      // antigo o botão veio do HTML e o script da própria página já
      // cuidou dele — ligar de novo aqui faria o clique sair duas vezes.
      ligarSair();
    } else if (tipo) {
      filtrarOAntigo(antigos, tipo);
    }

    if (tipo === 'ALUNO') mostrarXp();
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

    // O XP nasce escondido: só aparece depois que o servidor disser o
    // número. Um "0 XP" piscando antes da resposta faria quem já jogou
    // achar que perdeu o progresso.
    nav.innerHTML = `
      <div class="topLine">
        <div class="navbar__inner">
          <div class="navbar__logo">
            <div class="navbar__logo-dot">${LOGO}</div>
            HERÓIS DA SAÚDE
          </div>

          <div class="navbar__acoes">
            <ul class="navbar__links">${links}</ul>
            <div class="xp-badge" id="nav-xp" hidden></div>
            <button type="button" id="logout-btn" class="btn-logout">Sair</button>
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

  /**
   * O botão "Sair" era repetido em cada script de página, e em duas
   * delas tinha sido esquecido. Agora quem desenha o botão também é
   * quem o liga.
   *
   * A página ainda pode ligar o seu: o addEventListener empilha, e sair
   * duas vezes dá no mesmo que sair uma.
   */
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

  /**
   * O XP que aparece na barra. Antes era "480 XP" escrito à mão dentro
   * do mapa.html — um número que não era de ninguém.
   *
   * Falhou? O selo continua escondido. A barra de navegação não é lugar
   * de mensagem de erro: a tela de progresso é que vai dizer o que houve.
   */
  async function mostrarXp() {
    const selo = document.getElementById('nav-xp');
    if (!selo || !window.API || !API.getMeuResumo) return;

    try {
      const { estatisticas } = await API.getMeuResumo();
      const xp = estatisticas?.xp ?? 0;

      selo.textContent = `⭐ ${xp.toLocaleString('pt-BR')} XP`;
      selo.hidden = false;
    } catch (_) { /* sem XP na barra; a tela de progresso explica */ }
  }

  /**
   * O tipo lembrado no navegador responde na hora e evita a barra
   * "piscar" com os itens errados enquanto o banco responde. Se não
   * houver nada lembrado, aí sim pergunta ao banco.
   */
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
