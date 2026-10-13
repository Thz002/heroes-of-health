/**
 * conquista-aviso.js — o aviso de "conquista desbloqueada"
 *
 * O cartão que desliza no canto superior direito quando a pessoa ganha
 * uma insígnia, como nos videogames: a arte, o nome, a descrição e o XP
 * que ela rendeu. Some sozinho depois de alguns segundos, ou com um
 * clique.
 *
 * QUEM CHAMA. As insígnias novas chegam em duas respostas do servidor,
 * sempre no campo `insignias_novas`:
 *   - POST /api/presenca  (navbar.js, ao abrir qualquer página: dias
 *                          seguidos, e o que o catálogo ganhou desde a
 *                          última visita)
 *   - POST /api/responder (quiz.js, a cada resposta: acertos, missões)
 * O servidor já junta os degraus do mesmo lugar que caem juntos, então
 * aqui cada item é um aviso.
 *
 * MUITAS DE UMA VEZ. Um aluno veterano, na primeira visita depois que
 * o catálogo cresceu, pode ganhar dez de uma vez. Uma fila de dez
 * avisos de seis segundos seria um minuto de tela coberta; então
 * entram no máximo MAX_VISIVEIS juntos, empilhados, e o resto vira um
 * cartão "e mais N" que leva à estante.
 *
 * Global: CONQUISTA_AVISO.mostrar(lista). Carregado antes de navbar.js.
 */
const CONQUISTA_AVISO = (() => {
  'use strict';

  const PASTA = '../imgs/insignias/';
  const DURACAO = 6500;        // quanto cada aviso fica na tela
  const INTERVALO = 450;       // o atraso entre um aviso e o seguinte
  const MAX_VISIVEIS = 3;

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

  function cartaoDoResto(quantas) {
    const el = document.createElement('a');
    el.className = 'conquista-aviso conquista-aviso--resto';
    el.href = 'conquistas.html';
    el.textContent = `E mais ${quantas} ${quantas === 1 ? 'conquista' : 'conquistas'} — ver na estante`;
    return el;
  }

  function entrar(el) {
    obterPilha().appendChild(el);

    // Um quadro depois de entrar no DOM, senão o navegador pula a
    // transição e o cartão aparece já no lugar.
    requestAnimationFrame(() => requestAnimationFrame(() => el.classList.add('conquista-aviso--dentro')));

    let restante = DURACAO;
    let inicio = Date.now();
    let timer = setTimeout(() => sair(el), restante);

    // Passar o mouse segura o aviso: quem está lendo a descrição não
    // pode ver o cartão sumir no meio da frase.
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

  function sair(el) {
    if (el.classList.contains('conquista-aviso--saindo')) return;
    el.classList.add('conquista-aviso--saindo');
    el.classList.remove('conquista-aviso--dentro');

    // Remove ao fim da transição; o timeout cobre quem desligou as
    // animações (prefers-reduced-motion), em que transitionend não vem.
    const remover = () => el.remove();
    el.addEventListener('transitionend', remover, { once: true });
    setTimeout(remover, 600);
  }

  return { mostrar };
})();
