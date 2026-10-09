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

    // Os DOIS avatares: o do botão e o de dentro do menu. O de dentro
    // faltava — o menu abria com o nome solto, sem a foto que o botão
    // logo acima já estava mostrando.
    desenharAvatar(avatar, perfil.nome, perfil.avatar_url);
    desenharAvatar(document.getElementById('perfil-avatar-menu'), perfil.nome, perfil.avatar_url);

    const nome = document.getElementById('perfil-nome');
    const tipo = document.getElementById('perfil-tipo');

    // textContent: nome é texto escrito por pessoa, nunca código.
    if (nome) nome.textContent = perfil.nome || 'Minha conta';
    if (tipo) tipo.textContent = ROTULO_TIPO[perfil.tipo] || '';
  }

  /**
   * Foto ou iniciais, no mesmo lugar.
   *
   * Exposto em window.AVATAR porque o ranking da turma desenha o mesmo
   * círculo para cada colega — e duas cópias desta regra acabariam
   * divergindo no dia em que uma imagem quebrada precisasse de um plano
   * B diferente em cada tela.
   */
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

    // Endereço quebrado, site fora do ar, link que não era imagem: cai
    // nas iniciais em vez de deixar um círculo vazio sem explicação.
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

    // A barra nasce escondida: só aparece depois que o servidor disser o
    // número. Uma barra zerada piscando antes da resposta faria quem já
    // jogou achar que perdeu o progresso.
    nav.innerHTML = `
      <div class="topLine">
        <div class="navbar__inner">
          <div class="navbar__logo">
            <div class="navbar__logo-dot">${LOGO}</div>
            HERÓIS DA SAÚDE
          </div>

          <div class="navbar__acoes">
            <ul class="navbar__links">${links}</ul>

            <!-- A patente em cima e a barra embaixo, sem número: o
                 nível e o XP por extenso ficam no title e na tela
                 "Meu progresso". -->
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

  /* ── A BARRA DE NÍVEL, EM QUALQUER LUGAR ─────────────────────────────
     Uma página ganha a barra escrevendo só isto:

         <div data-nivel></div>

     e o resto acontece aqui. Existe para resolver um problema concreto:
     o dashboard tinha uma pílula escrita à mão dizendo "Nível Mestre da
     Saúde", com um <span id="user-level"> que nenhum script preencheu
     nunca. Era enfeite parado, não progresso.

     Fica neste arquivo porque ele já roda em todas as páginas e já
     busca o nível em /presenca — um arquivo novo significaria mais uma
     tag <script> em nove HTMLs e mais uma chamada ao servidor.

     window.NIVEL.atualizar() deixa qualquer tela redesenhar a barra sem
     recarregar: é o que o quiz usa para ela subir no momento do acerto.
     ────────────────────────────────────────────────────────────────── */

  let ultimoNivel = null;

  window.NIVEL = {
    atualizar(nivel, xp) {
      if (!nivel) return;
      ultimoNivel = { nivel, xp };

      // Os modais de quiz e de questão usam data-nivel para outra coisa
      // (o nível etário). Sem o :not, a barra seria desenhada por cima
      // deles se um estivesse aberto quando a resposta chegasse.
      document.querySelectorAll('[data-nivel]:not(.modal [data-nivel])')
        .forEach(el => desenharNivel(el, nivel, xp));
    },

    atual: () => ultimoNivel
  };

  function desenharNivel(el, nivel, xp) {
    el.classList.add('nivelzinho');

    // Nasce escondida na barra de navegação: uma barra zerada piscando
    // antes da resposta faria quem já jogou achar que perdeu o progresso.
    el.hidden = false;

    // Onde a barra aparece sozinha, sem as linhas de texto em volta (a
    // da navbar), o título é o único lugar que explica o que ela mede.
    el.title = nivel.maximo
      ? `${nivel.patente} — nível máximo`
      : `${nivel.patente} · faltam ${nivel.faltam} XP para o nível ${nivel.nivel + 1}`;

    const feito = (xp ?? 0) - nivel.xp_do_nivel;
    const trecho = nivel.maximo ? 0 : nivel.xp_do_proximo - nivel.xp_do_nivel;

    el.innerHTML = `
      <div class="nivelzinho__topo">
        <span class="nivelzinho__patente"></span>
        <span class="nivelzinho__nv"></span>
      </div>
      <span class="nivelzinho__barra"><i></i></span>
      <span class="nivelzinho__nota"></span>`;

    el.querySelector('.nivelzinho__patente').textContent = nivel.patente;
    el.querySelector('.nivelzinho__nv').textContent =
      `Nível ${nivel.nivel}/${nivel.total_de_niveis || 20}`;

    el.querySelector('.nivelzinho__barra i').style.width = `${nivel.porcentagem}%`;

    // Dois números concretos em vez de uma porcentagem: "190 de 300 XP"
    // diz o que falta fazer, "63%" não.
    el.querySelector('.nivelzinho__nota').textContent = nivel.maximo
      ? `${(xp ?? 0).toLocaleString('pt-BR')} XP · nível máximo`
      : `${feito.toLocaleString('pt-BR')} de ${trecho.toLocaleString('pt-BR')} XP` +
        (nivel.proxima_patente ? ` · depois: ${nivel.proxima_patente}` : '');
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
   * Falhou? A barrinha continua escondida. A barra de navegação não é
   * lugar de mensagem de erro — a tela de progresso é que vai dizer o
   * que houve.
   */
  async function mostrarProgresso() {
    // typeof, e não window.API: o api.js declara `const API`, e um const
    // solto no arquivo NÃO vira window.API. O teste antigo dava sempre
    // "não existe", esta função parava aqui em toda página, e a barrinha
    // só aparecia no perfil — que chama NIVEL.atualizar por conta própria.
    if (typeof API === 'undefined' || !API.marcarPresenca) {
      console.warn('[navbar] API.marcarPresenca não existe — o api.js foi carregado antes deste arquivo?');
      return;
    }

    try {
      const r = await API.marcarPresenca();

      // Preenche a barrinha da navbar E toda <div data-nivel> da página.
      window.NIVEL.atualizar(r.nivel, r.xp);

      if (!r.nivel) {
        console.warn('[navbar] /presenca respondeu sem "nivel"; a barrinha fica escondida.', r);
      }

    } catch (erro) {
      // A barrinha continua escondida: ela não é lugar de mensagem de erro.
      // Mas o motivo vai para o console — antes isto era engolido em
      // silêncio, e "a barrinha não aparece" não tinha como ser
      // investigado por quem estava olhando a tela.
      console.warn(
        `[navbar] não deu para carregar seu XP (${erro.status || 'sem resposta'}): ${erro.message}`
      );
    }
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
