/** conquista-aviso.js — avisos no canto superior direito (global CONQUISTA_AVISO):
    mostrar(insígnias), progresso(barras) e dicas(lista). Carregado antes de navbar.js. */
const CONQUISTA_AVISO = (() => {
  'use strict';

  const PASTA = '../imgs/insignias/';
  const DURACAO = 6500;        // quanto cada aviso fica na tela
  const DURACAO_PROGRESSO = 4500;  // menor: aparece a cada acerto
  const DURACAO_DICA = 9000;   // maior: charada se lê duas vezes
  const INTERVALO = 450;       // o atraso entre um aviso e o seguinte
  const MAX_VISIVEIS = 3;

  // Espera o cartão entrar antes de encher a barra.
  const ESPERA_ENCHER = 450;
  const TEMPO_ENCHER = 1100;

  // Crescimento mínimo visível da barra (%).
  const PISO = 3;

  let cartaoDeProgresso = null;   // o que está na tela agora, se houver
  let cartoesDeDica = [];         // as dicas na tela agora

  let pilha = null;

  function obterPilha() {
    if (pilha && document.body.contains(pilha)) return pilha;

    pilha = document.createElement('div');
    pilha.className = 'conquista-pilha';
    // polite: o leitor de tela anuncia sem interromper a pergunta que a
    // pessoa está ouvindo.
    pilha.setAttribute('role', 'status');
    pilha.setAttribute('aria-live', 'polite');
    document.body.appendChild(pilha);
    return pilha;
  }

  /** Mostra os avisos de uma lista de insígnias. Lista vazia não faz nada. */
  function mostrar(lista) {
    if (!Array.isArray(lista) || !lista.length) return;

    const visiveis = lista.slice(0, MAX_VISIVEIS);
    const resto = lista.length - visiveis.length;

    visiveis.forEach((insignia, n) => {
      setTimeout(() => entrar(cartao(insignia)), n * INTERVALO);
    });

    if (resto > 0) {
      setTimeout(() => entrar(cartaoDoResto(resto)), visiveis.length * INTERVALO);
    }
  }

  function cartao(insignia) {
    const el = document.createElement('div');
    el.className = 'conquista-aviso';
    el.innerHTML = `
      <div class="conquista-aviso__arte"></div>
      <div class="conquista-aviso__texto">
        <span class="conquista-aviso__rotulo">Conquista desbloqueada!</span>
        <strong class="conquista-aviso__nome"></strong>
        <span class="conquista-aviso__descricao"></span>
      </div>
      <span class="conquista-aviso__xp"></span>
    `;

    const arte = el.querySelector('.conquista-aviso__arte');
    if (insignia.imagem) {
      const img = document.createElement('img');
      img.src = PASTA + insignia.imagem;
      img.alt = '';
      arte.appendChild(img);
    } else {
      arte.textContent = (insignia.nome || '?').trim().charAt(0).toUpperCase();
      arte.classList.add('conquista-aviso__arte--letra');
    }

    el.querySelector('.conquista-aviso__nome').textContent = insignia.nome || 'Nova insígnia';
    el.querySelector('.conquista-aviso__descricao').textContent = insignia.descricao || '';

    const xp = el.querySelector('.conquista-aviso__xp');
    if (insignia.xp) xp.textContent = `+${insignia.xp} XP`;
    else xp.remove();

    return el;
  }

  /** Aviso de progresso de um acerto: [{ area, ganhou, pontos, possiveis, cor }]. Substitui o anterior. */
  function progresso(barras) {
    if (!Array.isArray(barras) || !barras.length) return;

    if (cartaoDeProgresso) sair(cartaoDeProgresso, true);

    const el = document.createElement('div');
    el.className = 'conquista-aviso progresso-aviso';
    el.innerHTML = `
      <div class="progresso-aviso__topo">
        <span class="conquista-aviso__rotulo progresso-aviso__rotulo">Resposta certa!</span>
        <strong class="progresso-aviso__titulo"></strong>
      </div>
      <div class="progresso-aviso__barras"></div>
    `;

    el.querySelector('.progresso-aviso__titulo').textContent =
      barras.length === 1 ? 'Sua barra subiu' : 'Suas barras subiram';

    const lista = el.querySelector('.progresso-aviso__barras');
    const animar = barras.map(b => {
      const linha = linhaDeBarra(b);
      lista.appendChild(linha.el);
      return linha.encher;
    });

    entrar(el, DURACAO_PROGRESSO);
    cartaoDeProgresso = el;

    setTimeout(() => animar.forEach(encher => encher()), ESPERA_ENCHER);
  }

  /** Uma área: nome, +pontos, a barra e a porcentagem. */
  function linhaDeBarra(b) {
    const el = document.createElement('div');
    el.className = 'progresso-aviso__linha';
    el.style.setProperty('--cor', b.cor || 'var(--primary)');
    el.innerHTML = `
      <div class="progresso-aviso__cabeca">
        <span class="progresso-aviso__area"></span>
        <span class="progresso-aviso__ganho"></span>
        <span class="progresso-aviso__pct"></span>
      </div>
      <span class="progresso-aviso__barra"><i class="progresso-aviso__antes"></i><i class="progresso-aviso__novo"></i></span>
    `;

    el.querySelector('.progresso-aviso__area').textContent = b.area;
    el.querySelector('.progresso-aviso__ganho').textContent = `+${b.ganhou}`;

    const pct = el.querySelector('.progresso-aviso__pct');

    // Sem régua não há barra honesta: fica só o "+N".
    if (!b.possiveis) {
      el.querySelector('.progresso-aviso__barra').hidden = true;
      return { el, encher() {} };
    }

    // Porcentagem escrita arredondada para baixo; largura exata.
    const exatoAntes = Math.min(100, Math.max(0, b.pontos - b.ganhou) * 100 / b.possiveis);
    const exatoDepois = Math.min(100, b.pontos * 100 / b.possiveis);
    const pctAntes = Math.floor(exatoAntes);
    const pctDepois = Math.floor(exatoDepois);

    el.querySelector('.progresso-aviso__antes').style.width = `${exatoAntes}%`;

    const novo = el.querySelector('.progresso-aviso__novo');
    const largura = Math.min(100 - exatoAntes, Math.max(PISO, exatoDepois - exatoAntes));
    novo.style.width = '0%';

    pct.textContent = `${pctAntes}%`;

    return {
      el,
      encher() {
        novo.style.width = `${largura}%`;
        contar(pct, pctAntes, pctDepois);
      }
    };
  }

  /** A porcentagem sobe junto com a barra, de número em número. */
  function contar(el, de, ate) {
    if (de === ate || matchMedia('(prefers-reduced-motion: reduce)').matches) {
      el.textContent = `${ate}%`;
      return;
    }

    const inicio = performance.now();
    const passo = agora => {
      const t = Math.min(1, (agora - inicio) / TEMPO_ENCHER);
      // A mesma curva da barra (sai rápido, assenta devagar), para o
      // número e a barra chegarem juntos.
      const suave = 1 - Math.pow(1 - t, 3);
      el.textContent = `${Math.round(de + (ate - de) * suave)}%`;
      if (t < 1) requestAnimationFrame(passo);
    };
    requestAnimationFrame(passo);
  }

  /** Dicas de um lugar: [{ titulo, texto, imagem }]. Substituem as que estiverem na tela. */
  function dicas(lista) {
    cartoesDeDica.forEach(el => sair(el, true));
    cartoesDeDica = [];
    if (!Array.isArray(lista) || !lista.length) return;

    lista.forEach((d, n) => {
      const el = cartaoDeDica(d);
      cartoesDeDica.push(el);
      setTimeout(() => {
        // Ignora a dica se foi trocada antes de entrar.
        if (cartoesDeDica.includes(el)) entrar(el, DURACAO_DICA);
      }, n * INTERVALO);
    });
  }

  function cartaoDeDica(d) {
    const el = document.createElement('div');
    el.className = 'conquista-aviso conquista-aviso--dica';
    el.innerHTML = `
      <div class="conquista-aviso__arte"></div>
      <div class="conquista-aviso__texto">
        <span class="conquista-aviso__rotulo">Dica secreta</span>
        <strong class="conquista-aviso__nome"></strong>
        <span class="conquista-aviso__descricao"></span>
      </div>
    `;

    const arte = el.querySelector('.conquista-aviso__arte');
    if (d.imagem) {
      const img = document.createElement('img');
      img.src = PASTA + d.imagem;
      img.alt = '';
      arte.appendChild(img);
    } else {
      arte.textContent = '?';
      arte.classList.add('conquista-aviso__arte--letra');
    }

    el.querySelector('.conquista-aviso__nome').textContent = d.titulo || 'Um segredo por aqui';
    el.querySelector('.conquista-aviso__descricao').textContent = d.texto || '';
    return el;
  }

  function cartaoDoResto(quantas) {
    const el = document.createElement('a');
    el.className = 'conquista-aviso conquista-aviso--resto';
    el.href = 'conquistas.html';
    el.textContent = `E mais ${quantas} ${quantas === 1 ? 'conquista' : 'conquistas'} — ver na estante`;
    return el;
  }

  function entrar(el, duracao = DURACAO) {
    obterPilha().appendChild(el);

    // Um quadro depois de entrar no DOM, senão o navegador pula a
    // transição e o cartão aparece já no lugar.
    requestAnimationFrame(() => requestAnimationFrame(() => el.classList.add('conquista-aviso--dentro')));

    let restante = duracao;
    let inicio = Date.now();
    let timer = setTimeout(() => sair(el), restante);

    // Hover segura o aviso.
    el.addEventListener('mouseenter', () => {
      clearTimeout(timer);
      restante -= Date.now() - inicio;
    });
    el.addEventListener('mouseleave', () => {
      inicio = Date.now();
      timer = setTimeout(() => sair(el), Math.max(restante, 1500));
    });

    // O cartão do resto é um link: o clique tem de navegar, não fechar.
    if (!el.classList.contains('conquista-aviso--resto')) {
      el.addEventListener('click', () => { clearTimeout(timer); sair(el); });
    }
  }

  /** `jaVaiOutro`: sai do fluxo na hora para o novo não pular. */
  function sair(el, jaVaiOutro = false) {
    if (el === cartaoDeProgresso) cartaoDeProgresso = null;
    cartoesDeDica = cartoesDeDica.filter(c => c !== el);
    // Uma dica trocada antes de entrar nunca chegou ao DOM: nada a animar.
    if (!el.isConnected) return;
    if (el.classList.contains('conquista-aviso--saindo')) return;
    el.classList.add('conquista-aviso--saindo');
    el.classList.remove('conquista-aviso--dentro');

    if (jaVaiOutro) {
      el.style.position = 'absolute';
      el.style.top = `${el.offsetTop}px`;
    }

    // Remove ao fim da transição (com timeout para quem desligou animações).
    const remover = () => el.remove();
    el.addEventListener('transitionend', remover, { once: true });
    setTimeout(remover, 600);
  }

  return { mostrar, progresso, dicas };
})();
