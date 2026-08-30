(() => {
  'use strict';


  const btnNova = document.getElementById('btn-nova-turma');
  const modal = document.getElementById('modal-turma');
  const btnFechar = document.getElementById('btn-fechar');
  const btnCancelar = document.getElementById('btn-cancelar');
  const btnSalvar = document.getElementById('btn-salvar');
  const inNome = document.getElementById('in-nome');
  const inAno = document.getElementById('in-ano');
  const seletorCores = document.getElementById('seletor-cores');
  const boxErro = document.getElementById('modal-erro');
  const lista = document.getElementById('lista-turmas');
  const vazio = document.getElementById('empty-turmas');
  const nomeUsuario = document.getElementById('user-name');
  const linhaData = document.getElementById('welcome-message');
  const btnSair = document.getElementById('logout-btn');

  const COR_PADRAO = '#14b8a6'
  const LIMITE_PADRAO = 10;

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    mostrarData();

    const perfil = await AUTH.perfilAtual();
    if (perfil && nomeUsuario) nomeUsuario.textContent = perfil.nome;

    await carregarTurmas();
  }

  function mostrarData() {
    if (!linhaData) return;
    const opts = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
    linhaData.textContent = new Date().toLocaleDateString('pt-BR', opts);
  }

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  })


  btnNova.addEventListener('click', abrirModal);
  btnFechar.addEventListener('click', fecharModal);
  btnCancelar.addEventListener('click', fecharModal);

  modal.addEventListener('click', (e) => {
    if (e.target === modal) fecharModal();
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !modal.hidden) fecharModal();
  });

  function abrirModal() {
    limparFormulario();
    modal.hidden = false;
    inNome.focus();
  }

  function fecharModal() {
    modal.hidden = true;
  }

  function limparFormulario() {
    inNome.value = '';
    inAno.selectedIndex = 0;
    esconderErro();

    seletorCores.querySelectorAll('.cor').forEach((b, i) => {
      b.classList.toggle('cor--ativa', i === 0);
    });
  }

  seletorCores.addEventListener('click', (e) => {
    const bolinha = e.target.closest('.cor');
    if (!bolinha) return;

    seletorCores.querySelectorAll('.cor').forEach(b => b.classList.remove('cor--ativa'));
    bolinha.classList.add('cor--ativa');
  });

  function corEscolhida() {
    const ativa = seletorCores.querySelector('.cor--ativa');
    return ativa ? ativa.dataset.cor : COR_PADRAO;
  }

 
  btnSalvar.addEventListener('click', salvarTurma);

  //Aqui vou fazer o save de turmas

  async function salvarTurma() {
    const nome = inNome.value.trim();

   
    if (nome.length < 2) {
      return mostrarErro('Dê um nome à turma. Ex: 7º Ano B');
    }

    esconderErro();

    btnSalvar.disabled = true;
    btnSalvar.textContent = 'Criando...';

    try {
      const turma = await API.criarTurma({
        nome,
        cor: corEscolhida(),
        ano_escolar: inAno.value
      });

      lista.appendChild(montarCard(turma));
      atualizarVazio();
      fecharModal();

    } catch (err) {
      mostrarErro(err.message);

    } finally {
      btnSalvar.disabled = false;
      btnSalvar.textContent = 'Criar turma';
    }
  }

  function mostrarErro(msg) {
    if (!boxErro) { alert(msg); return; }
    boxErro.textContent = msg;
    boxErro.hidden = false;
  }
  function esconderErro() {
    if (!boxErro) return;
    boxErro.textContent = '';
    boxErro.hidden = true;
  }

  async function carregarTurmas() {
    try {
      const turmas = await API.getMinhasTurmas();

      lista.innerHTML = '';
      turmas.forEach(t => lista.appendChild(montarCard(t)));
      atualizarVazio();

    } catch (err) {
      lista.innerHTML = '';
      const aviso = document.createElement('p');
      aviso.className = 'turmas-erro';
      aviso.textContent = err.message;
      lista.appendChild(aviso);
      if (vazio) vazio.hidden = true;
    }
  }

  function atualizarVazio() {
    if (!vazio) return;
    vazio.hidden = lista.children.length > 0;
  }

  function montarCard(t) { // - >  verificar a origem da variável
    const card = document.createElement('article');
    card.className = 'turma-card';
    card.dataset.id = t.id;

    card.style.setProperty('--cor', t.cor || COR_PADRAO);

    card.innerHTML = `
      <span class="turma-card__tarja"></span>
      <div class="turma-card__info">
        <h4 class="turma-card__nome"></h4>
        <p  class="turma-card__ano"></p>
      </div>
      <span class="turma-card__alunos"></span>
      <button type="button" class="turma-card__codigo" title="Clique para copiar o código">
        <span class="turma-card__codigo-txt"></span>
      </button>
    `;

    card.querySelector('.turma-card__nome').textContent = t.nome;
    card.querySelector('.turma-card__ano').textContent = t.ano_escolar || '';
    card.querySelector('.turma-card__alunos').textContent =
      `${t.total_alunos ?? 0}/${t.limite_alunos ?? LIMITE_PADRAO}`;

    const botaoCodigo = card.querySelector('.turma-card__codigo');
    botaoCodigo.querySelector('.turma-card__codigo-txt').textContent = t.codigo || '—';
    botaoCodigo.addEventListener('click', () => copiarCodigo(botaoCodigo, t.codigo));

    return card;

  }

  async function copiarCodigo(botao, codigo) {
    if (!codigo) return;

    const alvo = botao.querySelector('.turma-card__codigo-txt');
    if (!alvo) return;
    const original = alvo.textContent;


    try {
      await navigator.clipboard.writeText(codigo);    //--analisar o navigator
    } catch (_) {
      copiarNaMarra(codigo);
    }

    alvo.textContent = 'Copiado';
    botao.classList.add('copiado');     //analisar class list

    setTimeout(() => {   //analisar o Timeout
      alvo.textContent = original;
      botao.classList.remove('copiado');
    }, 1200);

  }

  function copiarNaMarra(texto) {
    const campo = document.createElement('textarea');
    campo.value = texto;
    campo.setAttribute('readonly', '');
    campo.style.position = 'fixed';
    campo.style.opacity = '0';
    document.body.appendChild(campo);
    campo.select();
    document.execCommand('copy');
    campo.remove();
  }
})();