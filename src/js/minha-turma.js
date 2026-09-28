/**
 * minha-turma.js — a turma do aluno (minha-turma.html)
 *
 * O que esta tela responde: "em que turma eu estou, e quem joga comigo?"
 *
 * Não confundir com turma.html, que é a mesma pergunta pelo lado do
 * professor. Aquela pede `?id=` na URL e usa rotas de /professor; esta
 * não recebe parâmetro nenhum — a turma do aluno sai da conta dele, e
 * só ela. Aluno não escolhe turma por endereço.
 *
 * O TOM DA LISTA: a ordem é por XP, que é um número que só sobe. Ficar
 * em último com 40 XP ainda é ter 40 XP. Uma coluna de "45% de acerto"
 * ao lado do nome, visível para a turma toda, seria outra conversa — e
 * é justamente a que não queremos ter com uma criança de 8 anos.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const erro = document.getElementById('turma-erro');
  const subtitulo = document.getElementById('turma-subtitulo');

  const blocoTurma = document.getElementById('bloco-turma');
  const blocoSemTurma = document.getElementById('bloco-sem-turma');
  const blocoColegas = document.getElementById('bloco-colegas');
  const tituloColegas = document.getElementById('titulo-colegas');
  const lista = document.getElementById('lista-colegas');

  const PODIO = ['colega--ouro', 'colega--prata', 'colega--bronze'];

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Tela de aluno. O professor vê as turmas dele pelo painel.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'PROFESSOR') {
      window.location.href = 'dashboard.html';
      return;
    }

    await carregar();
  }

  async function carregar() {
    try {
      const { turma, colegas, posicao } = await API.getMinhaTurma();

      if (!turma) {
        blocoSemTurma.hidden = false;
        subtitulo.textContent = 'Você ainda não entrou em uma turma.';
        return;
      }

      mostrarTurma(turma, posicao);
      mostrarColegas(colegas);

    } catch (err) {
      // Sem invenção: se não deu para carregar, a tela diz isso.
      erro.textContent = err.message;
      erro.hidden = false;
    }
  }

  function mostrarTurma(turma, posicao) {
    blocoTurma.hidden = false;
    document.title = `${turma.nome} - Heróis da Saúde`;

    const ponto = document.getElementById('turma-cor');
    if (turma.cor) ponto.style.background = turma.cor;

    // textContent e não innerHTML: nome de turma, de escola e de pessoa
    // são texto escrito por gente, nunca código rodando na página.
    escrever('turma-nome', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);

    const onde = [turma.escola, turma.professor && `Prof. ${turma.professor}`].filter(Boolean);
    escrever('turma-onde', onde.join(' · '));

    const quantos = turma.total_alunos || 0;
    subtitulo.textContent = quantos === 1
      ? 'Você é o primeiro da turma por aqui.'
      : `Você e mais ${quantos - 1} ${plural(quantos - 1, 'colega', 'colegas')} nesta turma.`;

    // Posição só faz sentido com colega: "1º de 1" não é conquista.
    if (!posicao || posicao.total < 2) return;

    document.getElementById('turma-posicao').hidden = false;
    escrever('posicao-lugar', `${posicao.lugar}º`);
    escrever('posicao-rot', `de ${posicao.total} na turma`);
  }

  function mostrarColegas(colegas) {
    if (!colegas.length) return;

    tituloColegas.hidden = false;
    blocoColegas.hidden = false;

    // O maior XP da turma é a régua das barrinhas. Usar 100 fixo deixaria
    // todas praticamente vazias enquanto ninguém tiver jogado muito.
    const teto = Math.max(...colegas.map(c => c.xp), 1);

    lista.innerHTML = '';
    colegas.forEach((c, i) => lista.appendChild(montarLinha(c, i, teto)));
  }

  function montarLinha(colega, ordem, teto) {
    const li = document.createElement('li');
    li.className = 'colega';
    li.style.setProperty('--i', ordem);

    // Medalha só para quem já pontuou: três zeros não são um pódio.
    if (colega.xp > 0 && PODIO[ordem]) li.classList.add(PODIO[ordem]);
    if (colega.eu) li.classList.add('colega--eu');

    li.innerHTML = `
      <span class="colega__pos"></span>
      <span class="colega__avatar"></span>
      <span class="colega__nome"></span>
      <span class="colega__barra"><i></i></span>
      <span class="colega__xp"></span>
    `;

    li.querySelector('.colega__pos').textContent = ordem + 1;
    li.querySelector('.colega__avatar').textContent = inicial(colega.nome);

    // Só o primeiro nome. A lista fica legível no celular, e o sobrenome
    // de uma criança não precisa ficar exposto para a turma inteira.
    li.querySelector('.colega__nome').textContent =
      colega.eu ? `${primeiroNome(colega.nome)} (você)` : primeiroNome(colega.nome);

    li.querySelector('.colega__barra i').style.width = `${Math.round((colega.xp / teto) * 100)}%`;
    li.querySelector('.colega__xp').textContent = `${colega.xp.toLocaleString('pt-BR')} XP`;

    return li;
  }

  /* ── Utilidades ────────────────────────────────────────────────── */

  function escrever(id, texto) {
    const alvo = document.getElementById(id);
    if (alvo) alvo.textContent = texto;
  }

  const plural = (n, um, muitos) => (n === 1 ? um : muitos);

  const primeiroNome = (nome) => String(nome || '').trim().split(/\s+/)[0] || '—';

  const inicial = (nome) => (nome || '?').trim().charAt(0).toUpperCase();
})();
