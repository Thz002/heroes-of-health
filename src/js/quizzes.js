/**
 * quizzes.js — o histórico de quizes do professor (quizzes.html)
 *
 * Lista tudo o que a pessoa já passou para as turmas dela, do mais novo
 * para o mais velho, em barras horizontais: o lugar de onde as perguntas
 * vieram, as áreas que o quiz alimenta, quantas perguntas caíram e
 * quanto tempo o aluno tem em cada uma.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const lista = document.getElementById('lista-quizzes');
  const vazio = document.getElementById('empty-quizzes');
  const total = document.getElementById('quizzes-total');
  const subtitulo = document.getElementById('quizzes-subtitulo');
  const btnSair = document.getElementById('logout-btn');

  const modalApagar = document.getElementById('modal-apagar');
  const apagarTexto = document.getElementById('apagar-texto');
  const apagarErro = document.getElementById('apagar-erro');
  const apagarFechar = document.getElementById('apagar-fechar');
  const apagarNao = document.getElementById('apagar-nao');
  const apagarSim = document.getElementById('apagar-sim');

  // Os lugares do bairro que o formulário de criar quiz oferece. Nome e
  // foto são os mesmos do mapa, para o professor reconhecer de imediato
  // o ponto de onde tirou as perguntas.
  const LUGARES = {
    'ubs':            { nome: 'UBS',            imagem: 'UBS.png' },
    'escola':         { nome: 'Escola',         imagem: 'Escola.png' },
    'mercado':        { nome: 'Mercado',        imagem: 'Mercado.png' },
    'farmacia':       { nome: 'Farmácia',       imagem: 'Farmacia.jpg' },
    'praca':          { nome: 'Pracinha',       imagem: 'Praca.jpg' },
    'corrego':        { nome: 'Córrego',        imagem: 'Corrego.png' },
    'terreno-baldio': { nome: 'Terreno baldio', imagem: 'Baldio.png' }
  };

  // Mesmos ícones e cores das barras do mapa.
  const AREAS = {
    'Saúde':       { icone: '', cor: '#f87171' },
    'Educação':    { icone: '', cor: '#6b8eff' },
    'Vacinação':   { icone: '', cor: '#a78bfa' },
    'Vetores':     { icone: '', cor: '#f9c74f' },
    'Limpeza':     { icone: '', cor: '#38bdf8' },
    'Alimentação': { icone: '', cor: '#4ade80' },
    'Exercícios':  { icone: '', cor: '#fb923c' },
    'Felicidade':  { icone: '', cor: '#f472b6' }
  };

  const COR_PADRAO = '#14b8a6';

  let quizParaApagar = null;

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Página de professor. O aluno que chegar aqui por link ou favorito
    // volta para o jogo, em vez de tomar um 403 na cara.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'ALUNO') {
      window.location.href = 'mapa.html';
      return;
    }

    await carregar();
  }

  async function carregar() {
    try {
      const quizes = await API.getQuizzesCriados();

      lista.innerHTML = '';
      quizes.forEach((q, i) => lista.appendChild(montarLinha(q, i)));

      if (total) total.textContent = quizes.length;
      if (vazio) vazio.hidden = quizes.length > 0;

      if (subtitulo && quizes.length > 0) {
        subtitulo.textContent = `Do mais recente para o mais antigo.`;
      }

    } catch (err) {
      // Sem invenção: se não deu para carregar, a tela diz isso.
      lista.innerHTML = '';
      const aviso = document.createElement('p');
      aviso.className = 'turmas-erro';
      aviso.textContent = err.message;
      lista.appendChild(aviso);
      if (vazio) vazio.hidden = true;
    }
  }

  function montarLinha(q, ordem) {
    const slugs = Array.isArray(q.cenarios) ? q.cenarios : [];
    const principal = LUGARES[slugs[0]] || { nome: 'Bairro inteiro', imagem: 'UBS.png' };

    const linha = document.createElement('article');
    linha.className = 'quiz-linha';
    linha.dataset.id = q.id;
    linha.style.setProperty('--cor', q.turma_cor || COR_PADRAO);
    linha.style.setProperty('--i', ordem);

    linha.innerHTML = `
      <span class="quiz-linha__icone">
        <img alt="" loading="lazy">
      </span>

      <div class="quiz-linha__meio">
        <h4 class="quiz-linha__titulo">
          <span class="quiz-linha__nome"></span>
          <span class="quiz-linha__lugar"></span>
          <span class="quiz-linha__turma"></span>
        </h4>
        <div class="quiz-linha__tags"></div>
      </div>

      <div class="quiz-linha__numeros">
        <span class="quiz-linha__perguntas"></span>
        <span class="quiz-linha__tempo"></span>
      </div>

      <button type="button" class="quiz-linha__apagar" title="Apagar este quiz" aria-label="Apagar">&times;</button>
    `;

    linha.querySelector('img').src = `../imgs/${principal.imagem}`;

    // textContent e não innerHTML: título escrito por pessoa vira texto,
    // nunca código rodando na página.
    linha.querySelector('.quiz-linha__nome').textContent = q.titulo;
    linha.querySelector('.quiz-linha__lugar').textContent =
      `— ${principal.nome}${slugs.length > 1 ? ` +${slugs.length - 1}` : ''}`;

    const turma = linha.querySelector('.quiz-linha__turma');
    turma.textContent = q.turma_nome ? `· ${q.turma_nome}` : '';

    // ── As etiquetas de área ────────────────────────────────────────
    const caixaTags = linha.querySelector('.quiz-linha__tags');
    const areas = Array.isArray(q.areas) ? q.areas : [];

    if (areas.length === 0) {
      const tag = document.createElement('span');
      tag.className = 'quiz-tag quiz-tag--vazia';
      tag.textContent = 'sem área definida';
      caixaTags.appendChild(tag);
    } else {
      areas.forEach(nome => caixaTags.appendChild(montarTag(nome)));
    }

    // ── Os números da direita ───────────────────────────────────────
    const perguntas = q.total_questoes ?? 0;
    linha.querySelector('.quiz-linha__perguntas').textContent =
      `${perguntas} ${perguntas === 1 ? 'pergunta' : 'perguntas'}`;

    // Se o sorteio trouxe menos do que foi pedido, o professor precisa
    // saber — senão parece que a tela contou errado.
    if (q.qtd_pedida && perguntas < q.qtd_pedida) {
      linha.querySelector('.quiz-linha__perguntas').title =
        `Você pediu ${q.qtd_pedida}, mas só havia ${perguntas} disponíveis.`;
      linha.querySelector('.quiz-linha__perguntas').classList.add('quiz-linha__perguntas--menos');
    }

    linha.querySelector('.quiz-linha__tempo').textContent =
      `${formatarTempo(q.tempo_limite_segundos)} por pergunta`;

    linha.querySelector('.quiz-linha__apagar')
      .addEventListener('click', () => pedirConfirmacao(q));

    return linha;
  }

  function montarTag(nome) {
    const visual = AREAS[nome] || { icone: '•', cor: '#6bdfb8' };

    const tag = document.createElement('span');
    tag.className = 'quiz-tag';
    tag.style.setProperty('--tag-cor', visual.cor);
    tag.textContent = `${visual.icone} ${nome}`;

    return tag;
  }

  /** 20 -> "20s"; 60 -> "1 min"; 90 -> "1min30s" */
  function formatarTempo(segundos) {
    const s = Number(segundos);
    if (!Number.isFinite(s) || s <= 0) return 'sem limite';

    if (s < 60) return `${s}s`;

    const minutos = Math.floor(s / 60);
    const resto = s % 60;
    return resto ? `${minutos}min${resto}s` : `${minutos} min`;
  }

  // ── Apagar ────────────────────────────────────────────────────────
  function pedirConfirmacao(q) {
    quizParaApagar = q;

    const negrito = document.createElement('strong');
    negrito.textContent = q.titulo;

    apagarTexto.replaceChildren(
      document.createTextNode('O quiz '),
      negrito,
      document.createTextNode(
        ' some da lista da turma. O que os alunos já responderam continua guardado — o que se perde é a tarefa em si.'
      )
    );

    apagarErro.hidden = true;
    modalApagar.hidden = false;
    apagarNao.focus();
  }

  function fecharApagar() {
    modalApagar.hidden = true;
    quizParaApagar = null;
  }

  apagarFechar.addEventListener('click', fecharApagar);
  apagarNao.addEventListener('click', fecharApagar);
  modalApagar.addEventListener('click', (e) => {
    if (e.target === modalApagar) fecharApagar();
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !modalApagar.hidden) fecharApagar();
  });

  apagarSim.addEventListener('click', async () => {
    if (!quizParaApagar) return;

    const alvo = quizParaApagar;

    apagarSim.disabled = true;
    apagarSim.textContent = 'Apagando...';

    try {
      await API.excluirQuiz(alvo.id);

      const linha = lista.querySelector(`.quiz-linha[data-id="${alvo.id}"]`);
      if (linha) {
        linha.classList.add('saindo');
        setTimeout(() => {
          linha.remove();
          if (total) total.textContent = lista.querySelectorAll('.quiz-linha').length;
          if (vazio) vazio.hidden = lista.querySelectorAll('.quiz-linha').length > 0;
        }, 280);
      }

      fecharApagar();

    } catch (err) {
      apagarErro.textContent = err.message;
      apagarErro.hidden = false;

    } finally {
      apagarSim.disabled = false;
      apagarSim.textContent = 'Apagar';
    }
  });

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });
})();