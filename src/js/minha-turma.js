/**
 * minha-turma.js — a turma do aluno (minha-turma.html)
 *
 * O que esta tela responde: "em que turma eu estou, e quem joga comigo?"
 * Para quem ainda não tem turma, é também onde ela se escolhe.
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
        prepararEntrada();
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

  /* ── Entrar numa turma (só para quem está sem) ─────────────────────
     Os mesmos dois caminhos do cadastro (auth.js): o código que o
     professor entrega, ou escola + turma na lista. Os dois terminam num
     turma_id mandado para POST /api/minha-turma — é o servidor que
     grava, e só para quem ainda não tem turma.
     ─────────────────────────────────────────────────────────────── */

  let modoEntrada = 'codigo';
  let turmaDoCodigo = null;     // a turma que o código digitado achou
  let escolasCarregadas = false;

  function prepararEntrada() {
    const form = document.getElementById('form-entrar-turma');
    const abas = document.getElementById('entrar-abas');
    const codigo = document.getElementById('entrar-codigo');
    const escola = document.getElementById('entrar-escola');
    const turmaSel = document.getElementById('entrar-turma');
    const dica = document.getElementById('entrar-dica');
    const btn = document.getElementById('entrar-btn');

    const avisar = (texto, tipo = '') => {
      dica.textContent = texto;
      dica.className = 'entrar-turma__dica' + (tipo ? ` entrar-turma__dica--${tipo}` : '');
    };

    abas.addEventListener('click', (e) => {
      const aba = e.target.closest('.aba');
      if (!aba) return;

      modoEntrada = aba.dataset.modo;
      abas.querySelectorAll('.aba').forEach(a => {
        const ativa = a === aba;
        a.classList.toggle('aba--ativa', ativa);
        a.setAttribute('aria-selected', String(ativa));
      });
      form.querySelectorAll('[data-painel]').forEach(p => { p.hidden = p.dataset.painel !== modoEntrada; });
      avisar('');

      if (modoEntrada === 'lista' && !escolasCarregadas) carregarEscolas();
      if (modoEntrada === 'codigo') codigo.focus();
    });

    // ── Pelo código ──
    codigo.addEventListener('input', () => {
      turmaDoCodigo = null;
      codigo.value = codigo.value.toUpperCase();
      avisar('');
    });
    codigo.addEventListener('blur', () => { if (codigo.value.trim()) procurarCodigo(); });

    async function procurarCodigo() {
      const texto = codigo.value.trim();
      turmaDoCodigo = null;
      if (!texto) { avisar('Digite o código que seu professor passou.', 'erro'); return null; }

      avisar('Procurando turma...');
      try {
        const turma = await API.getTurmaPorCodigo(texto);
        if (!turma) { avisar('Código não encontrado. Confira com seu professor.', 'erro'); return null; }

        turmaDoCodigo = turma;
        avisar(`Turma ${turma.nome}${turma.escola_nome ? ` — ${turma.escola_nome}` : ''}`, 'ok');
        return turma;
      } catch (_) {
        avisar('Não foi possível conferir o código agora. Tente de novo.', 'erro');
        return null;
      }
    }

    // ── Pela lista ──
    async function carregarEscolas() {
      try {
        const escolas = await API.getEscolas();
        preencher(escola, escolas, escolas.length ? 'Escolha a escola' : 'Nenhuma escola cadastrada');
        escolasCarregadas = true;
      } catch (_) {
        preencher(escola, [], 'Erro ao carregar as escolas');
      }
    }

    escola.addEventListener('change', async () => {
      turmaSel.disabled = true;
      if (!escola.value) { preencher(turmaSel, [], 'Escolha a escola primeiro'); return; }

      preencher(turmaSel, [], 'Carregando turmas...');
      try {
        const turmas = await API.getTurmasPorEscola(Number(escola.value));
        preencher(turmaSel, turmas, turmas.length ? 'Escolha a turma' : 'Nenhuma turma nesta escola');
        turmaSel.disabled = turmas.length === 0;
      } catch (_) {
        preencher(turmaSel, [], 'Erro ao carregar as turmas');
      }
    });

    // ── Entrar ──
    form.addEventListener('submit', async (e) => {
      e.preventDefault();

      let turmaId = null;
      if (modoEntrada === 'codigo') {
        const turma = turmaDoCodigo || await procurarCodigo();
        if (!turma) return;
        turmaId = turma.id;
      } else {
        if (!turmaSel.value) { avisar('Escolha a escola e depois a turma.', 'erro'); return; }
        turmaId = Number(turmaSel.value);
      }

      btn.disabled = true;
      btn.textContent = 'Entrando...';

      try {
        const { turma, colegas, posicao } = await API.entrarNaTurma(turmaId);

        blocoSemTurma.hidden = true;
        mostrarTurma(turma, posicao);
        mostrarColegas(colegas);

      } catch (err) {
        avisar(err.message, 'erro');

      } finally {
        btn.disabled = false;
        btn.textContent = 'Entrar na turma';
      }
    });
  }

  /** Enche um <select> com [{ id, nome }], com a primeira opção em branco. */
  function preencher(select, itens, rotulo) {
    const vazio = document.createElement('option');
    vazio.value = '';
    vazio.textContent = rotulo;

    select.replaceChildren(vazio, ...itens.map(i => {
      const op = document.createElement('option');
      op.value = i.id;
      op.textContent = i.nome;
      return op;
    }));
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
