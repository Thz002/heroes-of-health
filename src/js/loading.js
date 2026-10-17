// loading.js — menu inicial do aluno (loading.html). Não carrega auth.js (evita loop de redirecionamento).

(() => {
  'use strict';

  const btnJogar = document.getElementById('btn-jogar');
  const btnSair = document.getElementById('btn-sair');
  const saudacao = document.getElementById('menu-saudacao');

  const INTERVALO = 7000;   // o pedido: um cartão novo a cada 7s

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // O nome é enfeite: se a consulta falhar, a tela continua servindo.
    if (!saudacao) return;
    try {
      const perfil = await AUTH.perfilAtual();
      const primeiro = primeiroNome(perfil, conta);
      if (primeiro) saudacao.textContent = `Bom te ver, ${primeiro}!`;
    } catch (_) { /* segue sem o nome */ }
  }

  /** Primeiro nome para a saudação; ignora o nome gerado a partir do e-mail (com dígitos, ponto ou _). */
  function primeiroNome(perfil, conta) {
    const nome = (perfil && perfil.nome || '').trim();
    if (!nome) return '';

    const prefixo = (conta.email || '').split('@')[0].trim();
    const copiouOEmail = prefixo && nome.toLowerCase() === prefixo.toLowerCase();
    const pareceLogin = /[0-9._]/.test(nome);

    if (copiouOEmail && pareceLogin) return '';

    return nome.split(/\s+/)[0];
  }

  btnJogar?.addEventListener('click', () => {
    window.location.href = 'mapa.html';
  });

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });


  // ── Carrossel do tutorial ── o JS só troca data-pos; o CSS posiciona.

  function montarCarrossel() {
    const palco = document.getElementById('palco');
    const trilha = document.getElementById('pontos');
    if (!palco || !trilha) return;

    const cartoes = Array.from(palco.querySelectorAll('.tcard'));
    if (cartoes.length < 3) return;   // com menos de três não há "os lados"

    const paradoPorPreferencia =
      window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    let atual = 0;
    let relogio = null;

    // ── as bolinhas ──────────────────────────────────────────────
    const pontos = cartoes.map((cartao, i) => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'tponto';
      b.setAttribute('role', 'tab');
      b.setAttribute('aria-label', `Passo ${i + 1} de ${cartoes.length}`);
      b.addEventListener('click', () => {
        mostrar(i);
        reiniciar();
      });
      trilha.appendChild(b);
      return b;
    });

    // Posição circular de cada cartão em relação ao da frente.
    function posicaoDe(i, frente) {
      const n = cartoes.length;
      let d = (i - frente + n) % n;
      if (d > n / 2) d -= n;
      if (d === 0) return 'frente';
      if (d === 1) return 'direita';
      if (d === -1) return 'esquerda';
      return 'fora';
    }

    function mostrar(indice) {
      atual = (indice + cartoes.length) % cartoes.length;

      cartoes.forEach((cartao, i) => {
        const pos = posicaoDe(i, atual);
        cartao.dataset.pos = pos;

        // Só o cartão da frente fica acessível.
        cartao.setAttribute('aria-hidden', pos === 'frente' ? 'false' : 'true');
      });

      pontos.forEach((p, i) =>
        p.setAttribute('aria-selected', i === atual ? 'true' : 'false'));
    }

    function girar() { mostrar(atual + 1); }

    function ligar(espera = INTERVALO) {
      if (paradoPorPreferencia) return;
      parar();
      relogio = setInterval(girar, espera);
    }

    function parar() {
      if (relogio) { clearInterval(relogio); relogio = null; }
    }

    /** Clicar num cartão reinicia os 7s. */
    function reiniciar() {
      ligar();
    }

    // Clicar num cartão lateral o traz para a frente.
    cartoes.forEach((cartao, i) => {
      cartao.addEventListener('click', () => {
        if (cartao.dataset.pos === 'frente') return;
        mostrar(i);
      });
    });

    // Pausa com o mouse em cima.
    palco.addEventListener('mouseenter', parar);
    palco.addEventListener('mouseleave', () => ligar());
    palco.addEventListener('focusin', parar);
    palco.addEventListener('focusout', () => ligar());

    // Pausa com a aba escondida.
    document.addEventListener('visibilitychange', () => {
      document.hidden ? parar() : ligar();
    });

    // ── setas do teclado ─────────────────────────────────────────
    trilha.addEventListener('keydown', (e) => {
      if (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight') return;
      e.preventDefault();
      mostrar(atual + (e.key === 'ArrowRight' ? 1 : -1));
      pontos[atual].focus();
      reiniciar();
    });

    mostrar(0);
    ligar();
  }

  // Por último: depende de constantes declaradas acima.
  montarCarrossel();
})();
