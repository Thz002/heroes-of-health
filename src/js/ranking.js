/**
 * ranking.js — a classificação das turmas (ranking.html)
 *
 * Uma linha por turma, da que vai melhor para a que vai pior. Em cada
 * uma: a colocação (medalha nas três primeiras), o nome, quantas
 * perguntas a turma já respondeu e a taxa de acerto em porcentagem.
 *
 * A ORDEM vem pronta do servidor e não é a taxa crua — ele equilibra
 * turmas que responderam pouco. Três acertos em três respostas dariam
 * 100% e passariam na frente de quem respondeu quatrocentas; por isso a
 * conta lá inclui um peso inicial na média geral.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const lista = document.getElementById('lista-ranking');
  const vazio = document.getElementById('empty-ranking');
  const nota = document.getElementById('ranking-nota');
  const media = document.getElementById('ranking-media');
  const subtitulo = document.getElementById('ranking-subtitulo');

  const COR_PADRAO = '#14b8a6';
  const MEDALHAS = ['ouro', 'prata', 'bronze'];

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Página de professor: o ranking é das turmas dele.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'ALUNO') {
      window.location.href = 'mapa.html';
      return;
    }

    await carregar();
  }

  async function carregar() {
    try {
      const turmas = await API.getRankingDasTurmas();

      lista.innerHTML = '';
      turmas.forEach((t, i) => lista.appendChild(montarLinha(t, i)));

      const houveResposta = turmas.some(t => t.respostas > 0);

      if (vazio) vazio.hidden = turmas.length > 0;
      if (nota) nota.hidden = turmas.length < 2 || !houveResposta;

      if (media) {
        media.textContent = houveResposta ? `${turmas[0].media_geral}%` : '—';
      }

      if (subtitulo && turmas.length > 0) {
        subtitulo.textContent = houveResposta
          ? `${turmas.length} ${turmas.length === 1 ? 'turma' : 'turmas'} em jogo.`
          : 'Nenhuma resposta ainda — a classificação começa no primeiro acerto.';
      }

    } catch (err) {
      // Sem invenção: se não deu para carregar, a tela diz isso.
      lista.innerHTML = '';
      const aviso = document.createElement('p');
      aviso.className = 'turmas-erro';
      aviso.textContent = err.message;
      lista.appendChild(aviso);
      if (vazio) vazio.hidden = true;
      if (nota) nota.hidden = true;
    }
  }

  function montarLinha(t, ordem) {
    const linha = document.createElement('article');
    linha.className = 'ranking-linha';
    linha.dataset.id = t.id;
    linha.style.setProperty('--cor', t.cor || COR_PADRAO);
    linha.style.setProperty('--i', ordem);

    // As três primeiras ganham medalha; da quarta em diante, só o número.
    const medalha = t.respostas > 0 ? MEDALHAS[ordem] : null;
    if (medalha) linha.classList.add(`ranking-linha--${medalha}`);

    linha.innerHTML = `
      <span class="ranking-pos"><span class="ranking-pos__num"></span></span>

      <div class="ranking-linha__meio">
        <h4 class="ranking-linha__nome"></h4>
        <p class="ranking-linha__respondidas"></p>
        <span class="ranking-linha__barra"><i></i></span>
      </div>

      <div class="ranking-linha__numeros">
        <span class="ranking-linha__taxa"></span>
        <span class="ranking-linha__rot">de acerto</span>
      </div>
    `;

    linha.querySelector('.ranking-pos__num').textContent = t.posicao ?? (ordem + 1);

    // textContent e não innerHTML: nome de turma é texto escrito por
    // pessoa, nunca código rodando na página.
    linha.querySelector('.ranking-linha__nome').textContent =
      t.ano_escolar ? `${t.nome} · ${t.ano_escolar}` : t.nome;

    linha.querySelector('.ranking-linha__respondidas').textContent =
      resumirRespostas(t);

    const barra = linha.querySelector('.ranking-linha__barra i');
    barra.style.width = `${t.taxa ?? 0}%`;

    const taxa = linha.querySelector('.ranking-linha__taxa');
    const rotulo = linha.querySelector('.ranking-linha__rot');

    if (t.taxa === null || t.taxa === undefined) {
      taxa.textContent = '—';
      taxa.classList.add('ranking-linha__taxa--vazia');
      rotulo.textContent = 'sem respostas';
      linha.querySelector('.ranking-linha__barra').hidden = true;
    } else {
      taxa.textContent = `${t.taxa}%`;
      taxa.title = `${t.acertos} acertos em ${t.respostas} respostas`;
    }

    return linha;
  }

  /** "12 alunos · 340 perguntas respondidas" */
  function resumirRespostas(t) {
    const alunos = t.total_alunos ?? 0;
    const partes = [`${alunos} ${alunos === 1 ? 'aluno' : 'alunos'}`];

    if (t.respostas > 0) {
      partes.push(
        `${t.respostas.toLocaleString('pt-BR')} ` +
        `${t.respostas === 1 ? 'pergunta respondida' : 'perguntas respondidas'}`
      );
    } else {
      partes.push('nenhuma pergunta respondida ainda');
    }

    return partes.join(' · ');
  }

  // O botão Sair agora é desenhado pelo navbar.js, que também o liga.
  // O listener que existia aqui virou código morto quando esta página
  // passou a usar <nav data-navbar>.
})();