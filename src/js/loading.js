// loading.js — o menu inicial do aluno (src/pages/loading.html)
//
// É a primeira tela depois do login. Duas responsabilidades antigas:
// barrar quem não está logado, e levar ao mapa quando a pessoa mandar.
// E uma nova: girar o carrossel do tutorial.
//
// Repare que esta página NÃO carrega o auth.js. Ele é o controlador da
// tela de login e leva junto a entrada automática, que mandaria o aluno
// já logado para cá — daqui para cá, em loop.

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

  /**
   * O primeiro nome da pessoa — ou nada, quando não existe um.
   *
   * O gatilho do banco preenche `usuarios.nome` com o pedaço do e-mail
   * antes do @ quando o cadastro não mandou nome nenhum. Isso é um bom
   * padrão para a tabela não ficar com nome vazio, mas é péssimo para
   * ler em voz de saudação: "Bom te ver, duartethiago017!".
   *
   * Então aqui a gente desconfia — mas com cuidado. "Bater com o
   * prefixo" sozinho não serve de prova: `ana@gmail.com` chamada Ana
   * tem um nome de verdade que por acaso é igual ao prefixo, e
   * engolir esse nome seria trocar um defeito por outro.
   *
   * O que denuncia o substituto é ele não parecer um nome: dígitos
   * ("duartethiago017", "aluno1") ou ponto e sublinhado no meio
   * ("pedro.alves"). Gente não se chama assim. Só aí a saudação sai
   * sem nome, e a frase padrão da tela fica no lugar.
   */
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


  // ═══════════════════════════════════════════════════════════════
  //  O CARROSSEL DO TUTORIAL
  //
  //  Cinco cartões, três à vista: um na frente e dois atrás, de lado.
  //  O giro é só troca de atributo — cada cartão recebe `data-pos` e o
  //  CSS cuida do resto. Nenhum `style.transform` escrito daqui.
  //
  //  Isso não é preciosismo: posição em CSS é o que deixa a mesma
  //  animação se comportar diferente no celular (as medidas mudam
  //  dentro do @media) sem este arquivo saber que celular existe.
  // ═══════════════════════════════════════════════════════════════

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

    // ── onde cada cartão fica, dado quem está na frente ──────────
    //
    // A distância é circular: com 5 cartões e o 0 na frente, o 4 está
    // à esquerda (e não a quatro passos de distância). Sem isso, o
    // último cartão entraria pelo lado errado ao dar a volta.
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

        // Quem não está na frente sai do alcance do leitor de tela e
        // do Tab. Três cartões lidos ao mesmo tempo viram sopa.
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

    /**
     * Escolher um cartão recomeça a contagem dos 7s daquele cartão.
     *
     * Aqui já houve uma espera maior: a ideia era que quem clica está
     * lendo e merece mais tempo. O efeito foi o contrário. A espera de
     * 12s terminava LIGANDO um ciclo novo de 7s, então o primeiro giro
     * depois do clique só vinha 19 segundos mais tarde — e 19 segundos
     * de carrossel imóvel não se leem como "ele está me dando tempo",
     * se leem como "eu quebrei ele".
     *
     * Uma regra só, sem caso especial: clicou, tem os mesmos 7s que
     * qualquer outro cartão teria.
     */
    function reiniciar() {
      ligar();
    }

    // ── clicar num cartão de lado o traz para a frente ───────────
    //
    // Sem religar o relógio, de propósito: para clicar num cartão o
    // ponteiro está em cima do palco, e o palco já está pausado pelo
    // hover. Religar aqui faria o cartão girar embaixo do cursor de
    // quem acabou de escolher ele. Quem recomeça é o mouseleave.
    cartoes.forEach((cartao, i) => {
      cartao.addEventListener('click', () => {
        if (cartao.dataset.pos === 'frente') return;
        mostrar(i);
      });
    });

    // ── parar enquanto a pessoa lê ───────────────────────────────
    //
    // Trocar o cartão embaixo de quem está no meio de uma frase é a
    // forma mais rápida de um carrossel virar estorvo.
    palco.addEventListener('mouseenter', parar);
    palco.addEventListener('mouseleave', () => ligar());
    palco.addEventListener('focusin', parar);
    palco.addEventListener('focusout', () => ligar());

    // ── e parar quando ninguém está olhando ──────────────────────
    //
    // Numa aba escondida o navegador já atrasa o setInterval, mas ele
    // continua existindo. Desligar de vez poupa bateria do celular da
    // escola, que é onde este jogo vai rodar.
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

  // Por último, e não lá em cima junto com iniciar().
  //
  // Esta linha já esteve antes dos `addEventListener` dos botões, e o
  // resultado foi Jogar e Sair mortos: `montarCarrossel` lê a constante
  // INTERVALO, que naquele ponto ainda não tinha sido inicializada.
  // `const` não é içada como função — ela existe mas ainda não pode ser
  // tocada. A exceção saía daqui e as duas linhas seguintes, que eram
  // justamente as que ligavam os botões, nunca chegavam a rodar.
  montarCarrossel();
})();
