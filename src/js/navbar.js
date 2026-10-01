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

  /* ── O CANTO DO PERFIL ───────────────────────────────────────────────
     Substituiu o botão "Sair" solto. O Sair continua existindo, mas
     dentro do menu — tirar a conta é a ação mais destrutiva da barra e
     não devia ser a mais fácil de acertar com o dedo.

     O avatar começa com as INICIAIS. A tabela usuarios ainda não tem
     coluna de foto, então a foto de verdade não existe em lugar nenhum
     do sistema; a marcação já espera por ela (`avatar_url`) e troca
     sozinha no dia em que a coluna aparecer.
     ────────────────────────────────────────────────────────────────── */
  const ROTULO_TIPO = { ALUNO: 'Aluno', PROFESSOR: 'Professor', ADMIN: 'Equipe' };

  const ICONES = {
    perfil: '<path d="M12 12a4 4 0 100-8 4 4 0 000 8z"/><path d="M4 20c0-3.3 3.6-5.5 8-5.5s8 2.2 8 5.5"/>',
    troferu: '<path d="M8 4h8v5a4 4 0 01-8 0V4z"/><path d="M8 6H5v1a3 3 0 003 3M16 6h3v1a3 3 0 01-3 3"/><path d="M10 17h4M12 13v4M9 20h6"/>',
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
          <span class="perfil__nome" id="perfil-nome">…</span>
          <span class="perfil__tipo" id="perfil-tipo"></span>
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

    // Em dúvida, não esconde nada: uma barra cheia demais é um incômodo,
    // uma barra vazia é a pessoa achando que o sistema quebrou.
    const tipo = String(await descobrirTipo() || '').trim().toUpperCase();

    if (alvo) {
      desenhar(alvo, tipo);

      // Só quem desenhou o botão é que o liga. Nas páginas do modo
      // antigo o botão veio do HTML e o script da própria página já
      // cuidou dele — ligar de novo aqui faria o clique sair duas vezes.
      ligarSair();
      ligarMenuDoPerfil();
      preencherPerfil();
    } else if (tipo) {
      filtrarOAntigo(antigos, tipo);
    }

    // O professor também tem XP agora — o dele sobe com os quizzes que
    // passa e com os acertos da turma. Só quem não tem conta fica fora.
    if (tipo) mostrarProgresso();
  }

  /**
   * Abrir, fechar e fechar direito.
   *
   * Um menu que só abre e fecha no próprio botão vira armadilha: a
   * pessoa clica fora esperando que suma, ele não some, e ela clica de
   * novo em cima de algo que não queria. Por isso três saídas — o botão,
   * um clique em qualquer outro lugar, e Esc.
   */
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

  /**
   * O nome e as iniciais de quem está logado.
   *
   * Roda depois da barra já estar desenhada: os links aparecem na hora,
   * pelo tipo lembrado, e só o avatar espera o banco. O contrário — a
   * barra inteira esperando — era meio segundo de tela vazia em toda
   * navegação.
   */
  async function preencherPerfil() {
    const avatar = document.getElementById('perfil-avatar');
    if (!avatar) return;

    let perfil = null;
    try { perfil = await AUTH.perfilAtual(); } catch (_) { /* segue com o genérico */ }
    if (!perfil) return;

    // No dia em que usuarios ganhar uma coluna de foto, ela entra aqui e
    // as iniciais viram o plano B de quem não subiu nenhuma.
    if (perfil.avatar_url) {
      const img = document.createElement('img');
      img.src = perfil.avatar_url;
      img.alt = '';
      avatar.innerHTML = '';
      avatar.appendChild(img);
      avatar.classList.add('perfil__avatar--foto');
    } else {
      avatar.textContent = iniciais(perfil.nome);
    }

    const nome = document.getElementById('perfil-nome');
    const tipo = document.getElementById('perfil-tipo');

    // textContent: nome é texto escrito por pessoa, nunca código.
    if (nome) nome.textContent = perfil.nome || 'Minha conta';
    if (tipo) tipo.textContent = ROTULO_TIPO[perfil.tipo] || '';
  }

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
   * Marca a presença do dia e mostra nível e XP na barra.
   *
   * Uma chamada só faz as duas coisas, e é de propósito: o prêmio
   * diário precisa de um gatilho, e o único momento em que a pessoa
   * com certeza aparece é quando abre uma página. Login não serve — quem
   * faz login é o Supabase, sem passar pelo servidor, e quem deixa a aba
   * aberta a semana toda nunca loga de novo.
   *
   * Chamar em toda visita é seguro: quem decide se vale prêmio é a
   * chave (usuario_id, dia) do banco, não este código.
   *
   * Falhou? O selo continua escondido. A barra de navegação não é lugar
   * de mensagem de erro — a tela de progresso é que vai dizer o que houve.
   */
  async function mostrarProgresso() {
    const selo = document.getElementById('nav-xp');
    if (!window.API || !API.marcarPresenca) return;

    try {
      const r = await API.marcarPresenca();

      if (selo) {
        const xp = (r.xp ?? 0).toLocaleString('pt-BR');
        selo.textContent = `Nv ${r.nivel?.nivel ?? 1} · ${xp} XP`;
        selo.title = r.nivel?.maximo
          ? `${r.nivel.titulo} — nível máximo`
          : `${r.nivel?.titulo || ''} · faltam ${r.nivel?.faltam ?? 0} XP para o nível ${(r.nivel?.nivel ?? 1) + 1}`;
        selo.hidden = false;
      }

      comemorar(r);
    } catch (_) { /* sem selo na barra; a tela de progresso explica */ }
  }

  /**
   * O momento da recompensa.
   *
   * Isto existe porque o jogo tinha um buraco: o aluno ganhava XP e
   * insígnia sem NUNCA ver acontecer. O número só aparecia depois,
   * parado, numa tela que ele podia nem abrir. Prêmio que ninguém vê
   * chegar não premia.
   *
   * O aviso some sozinho. Nada aqui pede clique: é comemoração, não
   * tarefa.
   */
  function comemorar(r) {
    const avisos = [];

    if (r.ganhou_hoje) {
      const dias = r.streak_dias > 1 ? ` · ${r.streak_dias} dias seguidos` : '';
      avisos.push({ emoji: '☀️', titulo: `+${r.pontos_do_dia} XP por hoje`, texto: `Bom te ver de novo${dias}.` });
    }

    for (const i of r.insignias_novas || []) {
      avisos.push({ emoji: '🏅', titulo: i.nome, texto: i.xp ? `${i.descricao} +${i.xp} XP` : i.descricao });
    }

    if (!avisos.length) return;

    const caixa = document.createElement('div');
    caixa.className = 'brindes';

    for (const a of avisos) {
      const cartao = document.createElement('div');
      cartao.className = 'brinde';
      cartao.innerHTML = `
        <span class="brinde__emoji" aria-hidden="true"></span>
        <span class="brinde__texto">
          <strong class="brinde__titulo"></strong>
          <span class="brinde__sub"></span>
        </span>`;
      cartao.querySelector('.brinde__emoji').textContent = a.emoji;
      cartao.querySelector('.brinde__titulo').textContent = a.titulo;
      cartao.querySelector('.brinde__sub').textContent = a.texto;
      caixa.appendChild(cartao);
    }

    document.body.appendChild(caixa);

    // Tempo de ler, não de esperar: 5s por aviso, com teto para quem
    // conquistou várias de uma vez não ficar com a tela ocupada.
    setTimeout(() => caixa.remove(), Math.min(5000 + avisos.length * 1500, 11000));
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
