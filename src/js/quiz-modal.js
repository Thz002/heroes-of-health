/**
 * quiz-modal.js — o modal "Criar quiz"
 *
 * Usado por dashboard.html (menu do card da turma → "Criar quiz") e por
 * quizzes.html (botão "+ Criar quiz"). É literalmente o mesmo modal nas
 * duas: este arquivo desenha o HTML e cuida de tudo. Expõe QUIZ_MODAL:
 *
 *   QUIZ_MODAL.abrir({ turma, aoCriar })
 *     turma    a turma já escolhida (vindo do card). Sem ela, o passo 1
 *              ganha um seletor com as turmas do professor.
 *     aoCriar  chamado com o quiz criado, para a página atualizar a lista.
 *
 * Dois modos, escolhidos nos cartões do passo 2:
 *
 *   auto   — o servidor sorteia entre as perguntas que casam com os
 *            cenários (obrigatórios) e as áreas marcadas.
 *   manual — os cenários e as áreas viram FILTRO de uma lista de
 *            perguntas, e o professor marca as que quer. A lista tem
 *            duas abas: as do sistema e as que ele mesmo criou.
 *
 * As marcadas ficam guardadas mesmo quando o filtro muda e elas somem
 * da lista — trocar de cenário para procurar mais perguntas não pode
 * apagar o que já foi escolhido. Trocar de TURMA, sim, limpa: a faixa
 * etária pode mudar, e o servidor recusaria perguntas de outra idade.
 *
 * Depende de api.js e questoes-ui.js, carregados antes.
 */
const QUIZ_MODAL = (() => {
  'use strict';

  const FAIXAS = { 1: 'perguntas de 7 a 10 anos', 2: 'perguntas de 11 a 14 anos', 3: 'perguntas de 15 a 18 anos' };

  let modal = null;
  let el = null;                // os elementos de dentro, achados uma vez
  let seletorCenarios = null;
  let seletorAreas = null;

  let turmaDoQuiz = null;
  let turmasDoProfessor = [];   // só quando o modal é aberto sem turma
  let aoCriarAtual = null;

  let modo = 'auto';
  let origem = 'sistema';
  let nivelDoQuiz = null;

  // id -> questão, na ordem em que foram marcadas. É essa a ordem em que
  // a turma vai responder.
  const selecionadas = new Map();

  // Cada recarga da lista ganha um número. Resposta que chega fora de
  // ordem (o professor clicou rápido em três cenários) é descartada, para
  // a lista não mostrar o filtro de dois cliques atrás.
  let pedidoDaLista = 0;

  /* ═══════════════════════════════════════════════════════════════════
     O HTML
     ═══════════════════════════════════════════════════════════════════ */
  function montar() {
    modal = document.createElement('div');
    modal.className = 'modal modal-quiz';
    modal.hidden = true;
    modal.innerHTML = `
      <div class="modal__caixa modal__caixa--larga" role="dialog" aria-modal="true" aria-labelledby="quiz-modal-titulo">
        <div class="modal-header">
          <h3 id="quiz-modal-titulo">Criar quiz</h3>
          <button type="button" class="modal__fechar" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <p class="modal__sub" data-sub>para a turma —</p>

        <!-- ── 1. Sobre o quiz ── -->
        <section class="passo">
          <h4 class="passo__titulo"><span class="passo__num">1</span> Sobre o quiz</h4>

          <!-- Só quando o modal abre fora do card de uma turma. -->
          <label class="campo" data-campo-turma hidden>
            <span class="campo__label">Turma <span class="campo__dica">(quem vai receber o quiz)</span></span>
            <select data-turma></select>
          </label>

          <div class="campo-duplo">
            <label class="campo">
              <span class="campo__label">Título do quiz</span>
              <input type="text" data-nome placeholder="Revisão de Dengue" maxlength="60" autocomplete="off">
            </label>

            <label class="campo">
              <span class="campo__label">Descrição <span class="campo__dica">(a frase que o aluno lê no card)</span></span>
              <input type="text" data-descricao placeholder="Revise o que aprendemos sobre o mosquito"
                     maxlength="200" autocomplete="off">
            </label>
          </div>

          <!-- O nível não se escolhe: sai do ano escolar da turma, do lado
               do servidor. Aqui só se mostra qual foi. -->
          <p class="nivel-pill" data-nivel>—</p>
        </section>

        <!-- ── 2. Como montar ── -->
        <section class="passo">
          <h4 class="passo__titulo"><span class="passo__num">2</span> Como escolher as perguntas?</h4>

          <div class="modos" data-modos role="radiogroup" aria-label="Como escolher as perguntas">
            <button type="button" class="modo modo--ativo" data-modo="auto" role="radio" aria-checked="true">
              <span class="modo__icone" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M13 2 4 14h7l-1 8 9-12h-7l1-8z"/>
                </svg>
              </span>
              <span class="modo__titulo">Criar automático</span>
              <span class="modo__texto">Ao selecionar a opção o sistema pegará perguntas já registradas e fará uma seleção automática conforme suas escolhas.</span>
            </button>

            <button type="button" class="modo" data-modo="manual" role="radio" aria-checked="false">
              <span class="modo__icone" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M9 11l3 3 8-8"/><path d="M20 12v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h9"/>
                </svg>
              </span>
              <span class="modo__titulo">Escolha manualmente</span>
              <span class="modo__texto">Ao selecionar essa opção você visualiza as perguntas disponíveis conforme suas escolhas, e seleciona as que melhor encaixam na sua dinâmica. Também é possível criar suas próprias perguntas, escolhendo o cenário e áreas a qual as perguntas darão pontos!</span>
            </button>
          </div>
        </section>

        <!-- ── 3. Cenários e áreas ── -->
        <section class="passo">
          <h4 class="passo__titulo"><span class="passo__num">3</span> Cenários e áreas</h4>

          <div class="campo">
            <span class="campo__label">Cenários <span class="campo__dica" data-dica-cenarios>(de onde vêm as perguntas)</span></span>
            <div data-cenarios></div>
          </div>

          <div class="campo">
            <span class="campo__label">Áreas <span class="campo__dica" data-dica-areas>(quais barras o acerto faz crescer)</span></span>
            <div data-areas></div>
          </div>
        </section>

        <!-- ── 4. As perguntas ── -->
        <section class="passo">
          <h4 class="passo__titulo"><span class="passo__num">4</span> Perguntas e tempo</h4>

          <!-- Só no modo manual: o banco de perguntas para escolher a dedo. -->
          <div class="banco" data-banco hidden>
            <div class="banco__barra">
              <div class="abas" data-abas role="tablist">
                <button type="button" class="aba aba--ativa" data-origem="sistema" role="tab" aria-selected="true">Perguntas do sistema</button>
                <button type="button" class="aba" data-origem="minhas" role="tab" aria-selected="false">Minhas questões</button>
              </div>
              <button type="button" class="btn-ghost btn-mini" data-nova-questao>+ Criar pergunta</button>
            </div>

            <p class="banco__info" data-banco-info></p>
            <div class="banco__lista" data-banco-lista></div>
          </div>

          <div class="campo-duplo">
            <label class="campo" data-campo-qtd>
              <span class="campo__label">Nº de perguntas</span>
              <input type="number" data-qtd value="10" min="3" max="30">
            </label>
            <div class="campo" data-campo-contador hidden>
              <span class="campo__label">Selecionadas</span>
              <p class="banco__contador" data-contador>Nenhuma pergunta</p>
            </div>
            <label class="campo">
              <span class="campo__label">Tempo por pergunta</span>
              <select data-tempo>
                <option value="15">15 segundos</option>
                <option value="20" selected>20 segundos</option>
                <option value="30">30 segundos</option>
                <option value="45">45 segundos</option>
                <option value="60">1 minuto</option>
              </select>
            </label>
          </div>
        </section>

        <p class="modal__erro" data-erro hidden></p>
        <p class="modal__resumo" data-resumo hidden></p>

        <div class="modal__acoes">
          <button type="button" class="btn-ghost" data-fechar>Cancelar</button>
          <button type="button" class="btn-primary" data-salvar>Criar quiz</button>
        </div>
      </div>
    `;
    document.body.appendChild(modal);

    const $ = (sel) => modal.querySelector(sel);
    el = {
      sub: $('[data-sub]'),
      campoTurma: $('[data-campo-turma]'),
      turma: $('[data-turma]'),
      nome: $('[data-nome]'),
      descricao: $('[data-descricao]'),
      nivel: $('[data-nivel]'),
      modos: $('[data-modos]'),
      dicaCenarios: $('[data-dica-cenarios]'),
      dicaAreas: $('[data-dica-areas]'),
      banco: $('[data-banco]'),
      abas: $('[data-abas]'),
      novaQuestao: $('[data-nova-questao]'),
      bancoInfo: $('[data-banco-info]'),
      bancoLista: $('[data-banco-lista]'),
      campoQtd: $('[data-campo-qtd]'),
      qtd: $('[data-qtd]'),
      campoContador: $('[data-campo-contador]'),
      contador: $('[data-contador]'),
      tempo: $('[data-tempo]'),
      erro: $('[data-erro]'),
      resumo: $('[data-resumo]'),
      salvar: $('[data-salvar]')
    };

    seletorCenarios = QUESTOES_UI.seletorCenarios($('[data-cenarios]'), { aoMudar: aoMudarFiltro });
    seletorAreas = QUESTOES_UI.grupoDeChips($('[data-areas]'), QUESTOES_UI.itensDeArea(), { aoMudar: aoMudarFiltro });

    modal.querySelectorAll('[data-fechar]').forEach(b => b.addEventListener('click', fechar));
    modal.addEventListener('click', (e) => { if (e.target === modal) fechar(); });

    // Bolha, não captura: o modal "Nova pergunta" fica por cima deste e
    // trata o Esc na captura, parando o evento antes de chegar aqui —
    // assim o Esc fecha só ele, e este continua aberto.
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && !modal.hidden) fechar();
    });

    el.turma.addEventListener('change', () => escolherTurma(Number(el.turma.value)));

    el.modos.addEventListener('click', (e) => {
      const cartao = e.target.closest('.modo');
      if (cartao) trocarModo(cartao.dataset.modo);
    });

    el.abas.addEventListener('click', (e) => {
      const aba = e.target.closest('.aba');
      if (aba) trocarOrigem(aba.dataset.origem);
    });

    el.novaQuestao.addEventListener('click', criarPergunta);
    el.salvar.addEventListener('click', salvar);
  }

  /* ═══════════════════════════════════════════════════════════════════
     ABRIR E FECHAR
     ═══════════════════════════════════════════════════════════════════ */

  async function abrir({ turma = null, aoCriar = null } = {}) {
    if (!modal) montar();

    aoCriarAtual = aoCriar;

    el.nome.value = '';
    el.descricao.value = '';
    el.qtd.value = 10;
    el.tempo.value = '20';
    el.erro.hidden = true;
    el.resumo.hidden = true;

    seletorCenarios.limpar();
    seletorAreas.limpar();
    selecionadas.clear();
    trocarOrigem('sistema', false);
    trocarModo('auto', false);

    el.campoTurma.hidden = Boolean(turma);
    modal.hidden = false;

    if (turma) {
      definirTurma(turma);
      el.nome.focus();
      return;
    }

    // Aberto fora do card: a turma se escolhe aqui dentro.
    definirTurma(null);
    preencherTurmas([], 'Carregando suas turmas...');
    el.turma.disabled = true;

    try {
      turmasDoProfessor = await API.getMinhasTurmas();
    } catch (err) {
      turmasDoProfessor = [];
      preencherTurmas([], 'Não foi possível carregar as turmas');
      return avisar(err.message);
    }

    if (turmasDoProfessor.length === 0) {
      preencherTurmas([], 'Você ainda não tem turmas');
      return avisar('Crie uma turma no painel antes de criar um quiz.');
    }

    el.turma.disabled = false;
    preencherTurmas(turmasDoProfessor, 'Escolha a turma');

    // Uma turma só: já vem escolhida, sem pedir um clique à toa.
    if (turmasDoProfessor.length === 1) {
      el.turma.value = String(turmasDoProfessor[0].id);
      escolherTurma(turmasDoProfessor[0].id);
    }
    el.turma.focus();
  }

  function fechar() {
    if (!modal) return;
    modal.hidden = true;
    turmaDoQuiz = null;
    aoCriarAtual = null;
  }

  /* ═══════════════════════════════════════════════════════════════════
     A TURMA E O NÍVEL
     ═══════════════════════════════════════════════════════════════════ */

  function preencherTurmas(turmas, rotulo) {
    const vazio = document.createElement('option');
    vazio.value = '';
    vazio.textContent = rotulo;

    el.turma.replaceChildren(vazio, ...turmas.map(t => {
      const op = document.createElement('option');
      op.value = t.id;
      op.textContent = t.ano_escolar ? `${t.nome} · ${t.ano_escolar}` : t.nome;
      return op;
    }));
  }

  function escolherTurma(id) {
    const turma = turmasDoProfessor.find(t => t.id === id) || null;

    // Outra turma pode ser de outra faixa etária: o que estava marcado
    // deixaria de valer, e o servidor recusaria.
    selecionadas.clear();
    atualizarContador();

    definirTurma(turma);
    el.erro.hidden = true;
    if (modo === 'manual') carregarBanco();
  }

  function definirTurma(turma) {
    turmaDoQuiz = turma;
    nivelDoQuiz = turma ? nivelDoAnoEscolar(turma.ano_escolar) : null;

    el.sub.textContent = turma ? `para a turma ${turma.nome}` : 'Escolha a turma no passo 1.';

    el.nivel.classList.toggle('nivel-pill--alerta', Boolean(turma) && !nivelDoQuiz);
    if (!turma) el.nivel.textContent = 'O nível sai do ano escolar da turma escolhida.';
    else if (nivelDoQuiz) el.nivel.textContent = `Turma ${turma.ano_escolar} · ${FAIXAS[nivelDoQuiz]}`;
    else el.nivel.textContent = 'Esta turma não tem ano escolar definido — edite a turma antes de criar o quiz.';
  }

  // Mesma regra de server/rotas/professor.js — quem decide de verdade é ele.
  function nivelDoAnoEscolar(ano) {
    if (!ano) return null;
    if (ano.includes('EM')) return 3;
    const n = parseInt(ano, 10);
    if (!Number.isInteger(n)) return null;
    if (n >= 6 && n <= 9) return 2;
    if (n >= 1 && n <= 5) return 1;
    return null;
  }

  /* ═══════════════════════════════════════════════════════════════════
     MODO E ABAS
     ═══════════════════════════════════════════════════════════════════ */

  function trocarModo(novo, recarregar = true) {
    modo = novo === 'manual' ? 'manual' : 'auto';

    el.modos.querySelectorAll('.modo').forEach(c => {
      const ativo = c.dataset.modo === modo;
      c.classList.toggle('modo--ativo', ativo);
      c.setAttribute('aria-checked', String(ativo));
    });

    const manual = modo === 'manual';
    el.banco.hidden = !manual;
    el.campoQtd.hidden = manual;
    el.campoContador.hidden = !manual;

    el.dicaCenarios.textContent = manual
      ? '(filtram a lista do passo 4 — nenhum marcado mostra todos)'
      : '(de onde vêm as perguntas)';
    el.dicaAreas.textContent = manual
      ? '(filtram a lista do passo 4 — nenhuma marcada mostra todas)'
      : '(quais barras o acerto faz crescer)';

    el.erro.hidden = true;
    atualizarContador();
    if (manual && recarregar) carregarBanco();
  }

  function aoMudarFiltro() {
    if (modo === 'manual') carregarBanco();
  }

  function trocarOrigem(nova, recarregar = true) {
    origem = nova === 'minhas' ? 'minhas' : 'sistema';
    el.abas.querySelectorAll('.aba').forEach(a => {
      const ativa = a.dataset.origem === origem;
      a.classList.toggle('aba--ativa', ativa);
      a.setAttribute('aria-selected', String(ativa));
    });
    if (recarregar) carregarBanco();
  }

  /* ═══════════════════════════════════════════════════════════════════
     A LISTA DE PERGUNTAS (modo manual)
     ═══════════════════════════════════════════════════════════════════ */

  async function carregarBanco() {
    if (!turmaDoQuiz) {
      ++pedidoDaLista;
      el.bancoInfo.textContent = 'Escolha a turma no passo 1 para ver as perguntas do nível dela.';
      el.bancoLista.replaceChildren();
      return;
    }
    if (!nivelDoQuiz) {
      ++pedidoDaLista;
      el.bancoInfo.textContent = 'Esta turma não tem ano escolar definido — edite a turma para ver as perguntas.';
      el.bancoLista.replaceChildren();
      return;
    }

    const meu = ++pedidoDaLista;
    el.bancoInfo.textContent = 'Carregando perguntas…';
    el.bancoLista.classList.add('banco__lista--carregando');

    try {
      const questoes = await API.getQuestoesProfessor({
        origem,
        nivel: nivelDoQuiz,
        cenarios: seletorCenarios.valores(),
        areas: seletorAreas.valores()
      });
      if (meu !== pedidoDaLista) return;

      desenharBanco(questoes);

    } catch (err) {
      if (meu !== pedidoDaLista) return;
      el.bancoInfo.textContent = err.message;
      el.bancoLista.replaceChildren();

    } finally {
      if (meu === pedidoDaLista) el.bancoLista.classList.remove('banco__lista--carregando');
    }
  }

  function desenharBanco(questoes) {
    const faixa = QUESTOES_UI.FAIXAS[nivelDoQuiz];

    if (questoes.length === 0) {
      el.bancoInfo.textContent = origem === 'minhas'
        ? `Você ainda não tem perguntas de ${faixa} com esse filtro. Clique em “+ Criar pergunta” para escrever uma.`
        : 'Nenhuma pergunta do sistema para esse filtro. Tente outros cenários ou áreas.';
    } else {
      el.bancoInfo.textContent =
        `${questoes.length} ${questoes.length === 1 ? 'pergunta' : 'perguntas'} de ${faixa} (o nível da turma).`;
    }

    el.bancoLista.replaceChildren(...questoes.map(q => QUESTOES_UI.cartaoQuestao(q, {
      selecionavel: true,
      marcada: selecionadas.has(q.id),
      aoMarcar: marcarQuestao
    })));
  }

  function marcarQuestao(q, marcada) {
    if (marcada) selecionadas.set(q.id, q);
    else selecionadas.delete(q.id);
    atualizarContador();
  }

  function atualizarContador() {
    const n = selecionadas.size;
    el.contador.textContent = n === 0 ? 'Nenhuma pergunta' : `${n} ${n === 1 ? 'pergunta' : 'perguntas'}`;
    el.contador.classList.toggle('banco__contador--cheio', n > 0);
  }

  // O modal "Nova pergunta" abre POR CIMA deste; ao salvar, a pergunta já
  // aparece em "Minhas questões" e entra marcada, se for do nível da turma.
  function criarPergunta() {
    QUESTOES_UI.abrirCriacao({
      cenario: seletorCenarios.valores()[0],
      nivel: nivelDoQuiz,
      aoCriar: (q) => {
        if (nivelDoQuiz && q.nivel_etario === nivelDoQuiz) selecionadas.set(q.id, q);
        atualizarContador();
        trocarOrigem('minhas');
      }
    });
  }

  /* ═══════════════════════════════════════════════════════════════════
     SALVAR
     ═══════════════════════════════════════════════════════════════════ */

  async function salvar() {
    const titulo = el.nome.value.trim();

    if (!turmaDoQuiz) return avisar('Escolha a turma que vai receber o quiz.');
    if (titulo.length < 2) return avisar('Dê um título ao quiz. Ex: Revisão de Dengue');

    const cenarios = seletorCenarios.valores();
    const manual = modo === 'manual';

    if (!manual && cenarios.length === 0) {
      return avisar('Escolha pelo menos um cenário de onde tirar as perguntas.');
    }
    if (manual && selecionadas.size === 0) {
      return avisar('Marque pelo menos uma pergunta na lista do passo 4.');
    }

    el.erro.hidden = true;
    el.salvar.disabled = true;
    el.salvar.textContent = manual ? 'Criando...' : 'Sorteando...';

    try {
      const pedidas = manual ? selecionadas.size : Number(el.qtd.value);

      const quiz = await API.criarQuiz({
        turma_id: turmaDoQuiz.id,
        titulo,
        descricao: el.descricao.value.trim(),
        modo,
        cenarios,
        areas: seletorAreas.valores(),
        qtd_questoes: Number(el.qtd.value),
        questao_ids: manual ? [...selecionadas.keys()] : undefined,
        tempo_limite_segundos: Number(el.tempo.value)
      });
      const veio = quiz.total_questoes;

      el.resumo.hidden = false;
      el.resumo.textContent = veio < pedidas
        ? `Quiz "${quiz.titulo}" criado com ${veio} das ${pedidas} questões pedidas — `
          + 'o banco ainda não tem mais perguntas para esse filtro.'
        : `Quiz "${quiz.titulo}" criado com ${veio} questões. A turma já pode responder.`;

      // O modal fica aberto, com o resumo: é comum passar mais de um
      // quiz seguido. Só o título é limpo, para o próximo.
      el.nome.value = '';
      if (manual) {
        selecionadas.clear();
        atualizarContador();
        el.bancoLista.querySelectorAll('.questao-card__marca:checked').forEach(c => {
          c.checked = false;
          c.closest('.questao-card').classList.remove('questao-card--marcada');
        });
      }

      aoCriarAtual?.({ ...quiz, turma_nome: turmaDoQuiz.nome, turma_cor: turmaDoQuiz.cor });

    } catch (err) {
      avisar(err.message);

    } finally {
      el.salvar.disabled = false;
      el.salvar.textContent = 'Criar quiz';
    }
  }

  function avisar(mensagem) {
    el.erro.textContent = mensagem;
    el.erro.hidden = false;
  }

  return { abrir, fechar };
})();
