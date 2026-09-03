(() => {
    'use strict'

    const topo = document.querySelector('.turma-topo');
    const turmaNome = document.getElementById('turma-nome');
    const turmaAno = document.getElementById('turma-ano');
    const turmaAlunos = document.getElementById('turma-alunos');
    const turmaCodigo = document.getElementById('turma-codigo');
    const lista = document.getElementById('lista-rank');
    const vazio = document.getElementById('empty-rank');
    const btnSair = document.getElementById('logout-btn');

    const LIMITE_PADRAO = 10;
    const COR_PADRAO = '#14b8a6';

    const PODIO = ['rank__linha--ouro', 'rank__linha--prata', 'rank__linha--bronze'];

    iniciar();

    async function iniciar() {
        const conta = await AUTH.exigirLogin();
        if (!conta) return;

        const id = idDaUrl();
        if (id == null) return;

        try {
            const turma = await buscarTurma(id);
            if (!turma) {
                mostrarErro('Turma não encontrada, ou não pertence a você.');
                return;
            }
            preencherTopo(turma);

            const alunos = await API.getAlunosDaTurma(id);
            desenharRanking(alunos);
        } catch (err) {
            mostrarErro(err.message);
        }
    }

    function idDaUrl() {
        const bruto = new URLSearchParams(window.location.search).get('id');
        const id = Number(bruto);

        if (!Number.isInteger(id) || id <= 0) {
            window.location.href = 'dashboard.html';
            return null;
        }
        return id;
    }

    async function buscarTurma(id) {
        const turmas = await API.getMinhasTurmas();
        return turmas.find(t => t.id === id) || null;
    }
      function preencherTopo(turma) {
    if (topo) topo.style.setProperty('--cor', turma.cor || COR_PADRAO);

    if (turmaNome)   turmaNome.textContent   = turma.nome;
    if (turmaAno)    turmaAno.textContent    = turma.ano_escolar || '';
    if (turmaCodigo) turmaCodigo.textContent = turma.codigo || '—';
    if (turmaAlunos) {
      turmaAlunos.textContent =
        `${turma.total_alunos ?? 0}/${turma.limite_alunos ?? LIMITE_PADRAO}`;
    }

    document.title = `${turma.nome} - Heróis da Saúde`;
  }

  function desenharRanking(alunos) {
    lista.innerHTML = '';
    const ordenados = [...alunos].sort(
        (a, b) => (b.aproveitamento ?? -1) - (a.aproveitamento ?? -1)
    );

    ordenados.forEach((aluno, i) => lista.appendChild(montarLinha(aluno, i + 1)));

    if (vazio) vazio.hidden = ordenados.length > 0;
}



function montarLinha(aluno, posicao) {
    const li = document.createElement('li');
    li.className = 'rank__linha';
    if (PODIO[posicao - 1]) li.classList.add(PODIO[posicao - 1]);

    li.innerHTML = `
      <span class="rank__pos"></span>
      <span class="rank__aluno">
        <span class="rank__avatar"></span>
        <span class="rank__nome"></span>
      </span>
      <span class="rank__barra"><i></i></span>
      <span class="rank__pontos"></span>
    `;

    li.querySelector('.rank__pos').textContent = posicao;
    li.querySelector('.rank__avatar').textContent = inicial(aluno.nome);
    li.querySelector('.rank__nome').textContent = aluno.nome;
    li.querySelector('.rank__barra i').style.width = `${aluno.aproveitamento ?? 0}%`;
    li.querySelector('.rank__pontos').textContent =
        aluno.respostas > 0 ? `${aluno.acertos}/${aluno.respostas}` : '—';

    return li;
}

  function inicial(nome) {
    return (nome || '?').trim().charAt(0).toUpperCase();
}

  function mostrarErro(mensagem) {
    lista.innerHTML = '';
    const aviso = document.createElement('li');
    aviso.className = 'turmas-erro';
    aviso.textContent = mensagem;
    lista.appendChild(aviso);
    if (vazio) vazio.hidden = true;
}

btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });
})();