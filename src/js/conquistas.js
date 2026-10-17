/** conquistas.js — estante de insígnias (conquistas.html), com o catálogo inteiro. */
(() => {
  'use strict';

  const erro = document.getElementById('estante-erro');
  const subtitulo = document.getElementById('estante-subtitulo');
  const contagem = document.getElementById('estante-contagem');
  const estante = document.getElementById('estante');
  const vazia = document.getElementById('estante-vazia');

  const PASTA = '../imgs/insignias/';

  // Como cada regra se lê em português, para o "faltam X" fazer sentido.
  const UNIDADE = {
    ACERTOS:         ['pergunta certa', 'perguntas certas'],
    ACERTOS_CENARIO: ['pergunta certa aqui', 'perguntas certas aqui'],
    DIAS:            ['dia seguido', 'dias seguidos'],
    MISSOES_CENARIO: ['missão concluída', 'missões concluídas'],
    QUIZZES:       ['quiz criado', 'quizzes criados'],
    ACERTOS_TURMA: ['acerto da turma', 'acertos da turma'],
    DESCOBERTA:    ['segredo achado', 'segredos achados']
  };

  // "Como conquistar": instrução gerada pela regra e pelo alvo.
  const COMO = {
    ACERTOS: n =>
      `Acerte ${n} ${n === 1 ? 'pergunta diferente' : 'perguntas diferentes'} em qualquer lugar do bairro. Cada pergunta conta uma vez só.`,
    ACERTOS_CENARIO: n =>
      `Acerte ${n} ${n === 1 ? 'pergunta diferente' : 'perguntas diferentes'} nas missões deste lugar do bairro.`,
    DIAS: n =>
      `Entre no jogo ${n} dias seguidos. Se pular um dia, a contagem recomeça.`,
    MISSOES_CENARIO: n =>
      `Conclua ${n} ${n === 1 ? 'missão' : 'missões'} pelos lugares do bairro. Cada lugar de um quiz terminado conta uma: um quiz com perguntas da UBS e da Escola vale duas.`,
    QUIZZES: n =>
      `Crie ${n} ${n === 1 ? 'quiz' : 'quizzes'} para as suas turmas.`,
    ACERTOS_TURMA: n =>
      `Seus alunos precisam somar ${n} acertos.`,
    // Sem dizer onde: o caminho é das dicas que o mapa mostra.
    DESCOBERTA: () =>
      'Um segredo escondido em algum lugar do bairro. Explore o mapa: alguns lugares dão dicas quando você entra neles.'
  };

  const modal = document.getElementById('modal-insignia');
  let quemAbriu = null;     // a peça que abriu o modal, para o foco voltar a ela

  ligarModal();
  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    try {
      const dados = await API.getMinhaEstante();

      mostrarNivel(dados.nivel, dados.xp);
      mostrarEstante(dados);

    } catch (err) {
      erro.textContent = err.message;
      erro.hidden = false;
    }
  }

  /* ── O nível ───────────────────────────────────────────────────── */

  function mostrarNivel(nivel, xp) {
    if (!nivel) return;

    document.getElementById('bloco-nivel').hidden = false;

    escrever('nivel-num', nivel.nivel);
    escrever('nivel-titulo', nivel.titulo);
    escrever('nivel-xp', (xp || 0).toLocaleString('pt-BR'));

    document.getElementById('nivel-barra').style.width = `${nivel.porcentagem}%`;

    // A barra é do TRECHO atual, não do total — e a legenda precisa
    // dizer isso, senão "80%" parece 80% do jogo inteiro.
    escrever('nivel-nota', nivel.maximo
      ? 'Você chegou ao último nível. Daqui para a frente é manter o bairro de pé.'
      : `Faltam ${nivel.faltam.toLocaleString('pt-BR')} XP para o nível ${nivel.nivel + 1}.`);
  }

  /* ── A estante ─────────────────────────────────────────────────── */

  function mostrarEstante(dados) {
    const lista = dados.insignias || [];

    if (!lista.length) {
      vazia.hidden = false;
      contagem.hidden = true;

      // O professor tem estante, só não tem peças ainda. Dizer qual é o
      // caso evita que ele ache que a tela quebrou.
      if (dados.publico === 'PROFESSOR') {
        document.getElementById('estante-vazia-dica').textContent =
          'As insígnias de professor ainda estão sendo definidas. Seu nível já sobe com os quizzes que você passa e com os acertos das suas turmas.';
      }
      return;
    }

    const feitas = dados.conquistadas || 0;

    subtitulo.textContent = feitas
      ? `${feitas} de ${dados.total} ${feitas === 1 ? 'insígnia conquistada' : 'insígnias conquistadas'}.`
      : 'Sua estante está esperando a primeira.';

    contagem.textContent = 'Os lugares vazios mostram o que vem a seguir — e quanto falta para cada um.';

    estante.innerHTML = '';
    lista.forEach((i, ordem) => estante.appendChild(montar(i, ordem)));
  }

  function montar(insignia, ordem) {
    const item = document.createElement('article');
    item.className = `insignia insignia--${insignia.conquistada ? 'feita' : 'presa'}`;
    item.style.setProperty('--i', ordem);
    item.style.setProperty('--pct', insignia.porcentagem);

    item.innerHTML = `
      <div class="insignia__disco">
        <span class="insignia__arte"></span>
      </div>
      <h4 class="insignia__nome"></h4>
      <p class="insignia__dica"></p>
    `;

    const arte = item.querySelector('.insignia__arte');

    // Com arquivo, a arte do outro dev. Sem arquivo, a inicial — e o
    // lugar continua sendo um lugar, não um buraco.
    if (insignia.imagem) {
      const img = document.createElement('img');
      img.src = PASTA + insignia.imagem;
      img.alt = '';
      img.loading = 'lazy';
      arte.appendChild(img);
    } else {
      arte.textContent = (insignia.nome || '?').trim().charAt(0).toUpperCase();
      arte.classList.add('insignia__arte--letra');
    }

    item.querySelector('.insignia__nome').textContent = insignia.nome;
    item.querySelector('.insignia__dica').textContent = dica(insignia);
    item.title = insignia.descricao;

    // Um ponto por degrau.
    if (insignia.degraus > 1) {
      const pontos = document.createElement('div');
      pontos.className = 'insignia__degraus';
      pontos.setAttribute('aria-label', `degrau ${insignia.degraus_feitos} de ${insignia.degraus}`);

      for (let n = 1; n <= insignia.degraus; n++) {
        const p = document.createElement('span');
        if (n <= insignia.degraus_feitos) p.className = 'aceso';
        pontos.appendChild(p);
      }

      item.querySelector('.insignia__nome').after(pontos);
    }

    // Peça clicável e acessível pelo teclado.
    item.tabIndex = 0;
    item.setAttribute('role', 'button');
    item.setAttribute('aria-haspopup', 'dialog');
    item.setAttribute('aria-label', `${insignia.nome} — ver detalhes`);
    item.addEventListener('click', () => abrirDetalhe(insignia, item));
    item.addEventListener('keydown', e => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        abrirDetalhe(insignia, item);
      }
    });

    return item;
  }

  /* ── O detalhe de uma insígnia (modal) ─────────────────────────── */

  function ligarModal() {
    if (!modal) return;

    document.getElementById('detalhe-fechar').addEventListener('click', fecharDetalhe);

    // Clique no fundo escuro fecha; clique dentro da caixa, não.
    modal.addEventListener('click', e => { if (e.target === modal) fecharDetalhe(); });

    document.addEventListener('keydown', e => {
      if (e.key === 'Escape' && !modal.hidden) fecharDetalhe();
    });
  }

  function abrirDetalhe(i, origem) {
    if (!modal) return;
    quemAbriu = origem;

    const feita = i.conquistada;
    const final = feita && !i.proximo;      // conquistada e sem degrau acima

    const estado = document.getElementById('detalhe-estado');
    estado.textContent = final ? 'Conquistada' : feita ? `Degrau ${i.degraus_feitos} de ${i.degraus}` : 'Bloqueada';
    estado.className = `detalhe-insignia__estado detalhe-insignia__estado--${feita ? 'feita' : 'presa'}`;

    desenharArte(document.getElementById('detalhe-arte'), i, feita);

    escrever('detalhe-nome', i.nome);
    escrever('detalhe-descricao', i.descricao);
    escrever('detalhe-xp', i.xp ? `+${i.xp} XP` : '');

    // "Como conquistar" fala do PRÓXIMO passo: o alvo desta peça se ela
    // está bloqueada, o do degrau seguinte se esta já caiu.
    const como = document.getElementById('detalhe-como');
    const progresso = document.getElementById('detalhe-progresso');
    const instrucao = COMO[i.regra] || (n => `Alcance ${n}.`);

    if (final) {
      como.textContent = i.conquistada_em
        ? `Você conquistou esta insígnia em ${data(i.conquistada_em)}.`
        : 'Você já conquistou esta insígnia.';
      progresso.hidden = true;
    } else {
      const alvo = feita ? i.proximo : i;
      como.textContent = (feita ? `Próximo degrau, ${i.proximo.nome}: ` : '') + instrucao(alvo.alvo);

      const [um, muitos] = UNIDADE[i.regra] || ['ponto', 'pontos'];
      document.getElementById('detalhe-barra').style.width = `${alvo.porcentagem}%`;
      escrever('detalhe-conta', `${alvo.progresso} de ${alvo.alvo} ${alvo.alvo === 1 ? um : muitos}`);
      progresso.hidden = false;
    }

    desenharEscada(i.escada);

    modal.hidden = false;
    document.getElementById('detalhe-fechar').focus();
  }

  function fecharDetalhe() {
    modal.hidden = true;
    if (quemAbriu) quemAbriu.focus();
    quemAbriu = null;
  }

  /** Os degraus de uma peça de lugar, do primeiro ao último. */
  function desenharEscada(escada) {
    const lista = document.getElementById('detalhe-escada');
    lista.innerHTML = '';

    if (!escada || escada.length < 2) {
      lista.hidden = true;
      return;
    }

    for (const d of escada) {
      const li = document.createElement('li');
      li.className = `detalhe-insignia__degrau${d.conquistada ? ' detalhe-insignia__degrau--feito' : ''}`;
      li.innerHTML = `
        <span class="detalhe-insignia__mini"></span>
        <span class="detalhe-insignia__degrau-nome"></span>
        <span class="detalhe-insignia__degrau-alvo"></span>
      `;

      desenharArte(li.querySelector('.detalhe-insignia__mini'), d, d.conquistada);
      li.querySelector('.detalhe-insignia__degrau-nome').textContent = d.nome;
      li.querySelector('.detalhe-insignia__degrau-alvo').textContent =
        `${d.alvo} ${d.alvo === 1 ? 'acerto' : 'acertos'}${d.conquistada ? ' ✓' : ''}`;

      lista.appendChild(li);
    }

    lista.hidden = false;
  }

  /** A arte (ou a inicial), em cores se conquistada, em silhueta se não. */
  function desenharArte(alvo, insignia, feita) {
    alvo.innerHTML = '';
    alvo.classList.toggle('arte--presa', !feita);
    alvo.classList.remove('arte--letra');

    if (insignia.imagem) {
      const img = document.createElement('img');
      img.src = PASTA + insignia.imagem;
      img.alt = '';
      alvo.appendChild(img);
    } else {
      alvo.textContent = (insignia.nome || '?').trim().charAt(0).toUpperCase();
      alvo.classList.add('arte--letra');
    }
  }

  /** Linha de baixo da peça: data da conquista ou quanto falta. */
  function dica(i) {
    const [um, muitos] = UNIDADE[i.regra] || ['ponto', 'pontos'];

    // Degrau conquistado com outro acima: o que importa agora é o
    // próximo, não a data deste.
    if (i.conquistada && i.proximo) {
      const falta = Math.max(0, i.proximo.alvo - i.proximo.progresso);
      return `próximo: faltam ${falta} ${falta === 1 ? um : muitos}`;
    }

    if (i.conquistada) {
      return i.conquistada_em ? `conquistada em ${data(i.conquistada_em)}` : 'conquistada';
    }

    // Segredo não tem "quanto falta": ou achou, ou não.
    if (i.regra === 'DESCOBERTA') return 'segredo do bairro';

    const falta = Math.max(0, i.alvo - i.progresso);

    return `faltam ${falta} ${falta === 1 ? um : muitos}`;
  }

  function data(iso) {
    try {
      return new Date(iso).toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' });
    } catch (_) {
      return '—';
    }
  }

  function escrever(id, texto) {
    const alvo = document.getElementById(id);
    if (alvo) alvo.textContent = texto;
  }
})();
