/**
 * conquistas.js — a estante de insígnias (conquistas.html)
 *
 * A tela mostra o CATÁLOGO INTEIRO, não só o que a pessoa já tem. É
 * essa a diferença entre uma estante e uma lista: o espaço vazio da
 * próxima insígnia é o que dá vontade de continuar. Esconder o que
 * falta transformaria a tela num recibo.
 *
 * As artes são do outro desenvolvedor e chegam pelo banco, não por
 * código: cada linha de `insignias` tem uma coluna `imagem` com o nome
 * do arquivo em src/imgs/insignias/. Enquanto ela for nula, o lugar
 * aparece com a inicial do nome — a estante funciona desde o primeiro
 * dia e vai ganhando desenho conforme os arquivos chegam.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
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
    ACERTOS:       ['pergunta certa', 'perguntas certas'],
    DIAS:          ['dia seguido', 'dias seguidos'],
    MISSOES:       ['tarefa concluída', 'tarefas concluídas'],
    QUIZZES:       ['quiz criado', 'quizzes criados'],
    ACERTOS_TURMA: ['acerto da turma', 'acertos da turma']
  };

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

    return item;
  }

  /**
   * A linha de baixo de cada peça.
   *
   * Conquistada: quando foi. Bloqueada: quanto falta — um número, nunca
   * uma porcentagem. "Faltam 12 perguntas" é uma tarefa que a pessoa
   * sabe cumprir; "24% da insígnia" não é.
   */
  function dica(i) {
    if (i.conquistada) {
      return i.conquistada_em ? `conquistada em ${data(i.conquistada_em)}` : 'conquistada';
    }

    const falta = Math.max(0, i.alvo - i.progresso);
    const [um, muitos] = UNIDADE[i.regra] || ['ponto', 'pontos'];

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
