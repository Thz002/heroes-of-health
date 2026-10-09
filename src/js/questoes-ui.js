/**
 * questoes-ui.js — as peças de tela das questões do professor
 *
 * Usado por dashboard.html (criar quiz) e quizzes.html (Minhas perguntas).
 * Expõe o objeto global `QUESTOES_UI`:
 *
 *   LUGARES, AREAS, FAIXAS        as listas fixas (nome, ícone, cor)
 *   grupoDeChips(raiz, itens, op) etiquetas que ligam e desligam
 *   seletorCenarios(raiz, op)     etiquetas de cenário + o ícone ao lado
 *   cartaoQuestao(q, op)          o cartão de uma pergunta numa lista
 *   abrirCriacao(op)              o modal "Nova pergunta" — o MESMO nas
 *                                 duas páginas, desenhado daqui
 *
 * Carregado depois de supabase.js e api.js, antes do script da página.
 */
const QUESTOES_UI = (() => {
  'use strict';

  // Os 12 cenários que existem no banco (db/seed.sql). Nome e ícone são
  // os mesmos do mapa do aluno (CENARIOS em mapa.js) — o professor
  // reconhece de cara o lugar onde a turma vai encontrar a pergunta. Se
  // um ícone mudar lá, mude aqui também.
  const LUGARES = {
    'ubs':            { nome: 'UBS',            imagem: 'UBS.png' },
    'upa':            { nome: 'UPA',            imagem: 'UPA.png' },
    'escola':         { nome: 'Escola',         imagem: 'Escola.png' },
    'creche':         { nome: 'Creche',         imagem: 'Creche.png' },
    'casa':           { nome: 'Casa',           imagem: 'Casa.png' },
    'mercado':        { nome: 'Mercado',        imagem: 'Mercado.png' },
    'farmacia':       { nome: 'Farmácia',       imagem: 'Farmacia.jpg' },
    'praca':          { nome: 'Pracinha',       imagem: 'Praca.jpg' },
    'parque':         { nome: 'Parque',         imagem: 'Parque.png' },
    'quadra':         { nome: 'Campo de lazer', imagem: 'Quadra.png' },
    'corrego':        { nome: 'Córrego',        imagem: 'Corrego.png' },
    'terreno-baldio': { nome: 'Terreno baldio', imagem: 'Baldio.png' }
  };

  // As 8 barras, com as cores do mapa. Os nomes são exatamente os da
  // tabela areas — o servidor recusa qualquer outro.
  const AREAS = {
    'Saúde':       '#f87171',
    'Educação':    '#6b8eff',
    'Vacinação':   '#a78bfa',
    'Vetores':     '#f9c74f',
    'Limpeza':     '#38bdf8',
    'Alimentação': '#4ade80',
    'Exercícios':  '#fb923c',
    'Felicidade':  '#f472b6'
  };

  const FAIXAS = { 1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos' };

  const imagemDo = (slug) => `../imgs/${(LUGARES[slug] || LUGARES.ubs).imagem}`;
  const nomeDo = (slug, reserva) => (LUGARES[slug] || {}).nome || reserva || slug;

  /* ═══════════════════════════════════════════════════════════════════
     ETIQUETAS QUE LIGAM E DESLIGAM

     `multiplo: false` faz o grupo agir como rádio: clicar numa desliga a
     outra, e clicar na que já está ligada não a desliga (o campo nunca
     fica sem resposta depois de escolhido).
     ═══════════════════════════════════════════════════════════════════ */
  function grupoDeChips(raiz, itens, { multiplo = true, aoMudar } = {}) {
    raiz.classList.add('opcoes');
    raiz.replaceChildren(...itens.map(it => {
      const chip = document.createElement('button');
      chip.type = 'button';
      chip.className = 'chip';
      chip.dataset.valor = it.valor;
      chip.textContent = it.rotulo;
      if (it.cor) {
        chip.classList.add('chip--cor');
        chip.style.setProperty('--chip-cor', it.cor);
      }
      return chip;
    }));

    raiz.addEventListener('click', (e) => {
      const chip = e.target.closest('.chip');
      if (!chip || !raiz.contains(chip)) return;

      if (multiplo) {
        chip.classList.toggle('chip--ativo');
      } else {
        raiz.querySelectorAll('.chip').forEach(c => c.classList.toggle('chip--ativo', c === chip));
      }
      aoMudar?.(valores(), chip.dataset.valor, chip.classList.contains('chip--ativo'));
    });

    function valores() {
      return [...raiz.querySelectorAll('.chip--ativo')].map(c => c.dataset.valor);
    }

    function marcar(lista) {
      const quero = new Set((lista || []).map(String));
      raiz.querySelectorAll('.chip').forEach(c => c.classList.toggle('chip--ativo', quero.has(c.dataset.valor)));
    }

    return { valores, marcar, limpar: () => marcar([]) };
  }

  const itensDeArea = () => Object.entries(AREAS).map(([nome, cor]) => ({ valor: nome, rotulo: nome, cor }));

  /* ═══════════════════════════════════════════════════════════════════
     SELETOR DE CENÁRIOS, COM O ÍCONE AO LADO

     À esquerda, as etiquetas. À direita, a "vitrine": o ícone de cada
     cenário escolhido, o mesmo recorte que o aluno vê no mapa. O último
     clicado entra com um pulinho, para o olho achar qual acabou de mudar.
     ═══════════════════════════════════════════════════════════════════ */
  function seletorCenarios(raiz, { multiplo = true, aoMudar } = {}) {
    raiz.classList.add('cenario-picker');
    raiz.innerHTML = `
      <div class="cenario-picker__chips"></div>
      <div class="vitrine" aria-live="polite"></div>
    `;

    const vitrine = raiz.querySelector('.vitrine');
    let ultimo = null;

    const chips = grupoDeChips(
      raiz.querySelector('.cenario-picker__chips'),
      Object.entries(LUGARES).map(([slug, l]) => ({ valor: slug, rotulo: l.nome })),
      {
        multiplo,
        aoMudar: (lista, clicado, ligou) => {
          ultimo = ligou ? clicado : null;
          desenharVitrine(lista);
          aoMudar?.(lista);
        }
      }
    );

    function desenharVitrine(lista) {
      vitrine.classList.toggle('vitrine--vazia', lista.length === 0);
      vitrine.classList.toggle('vitrine--unica', lista.length === 1);

      if (lista.length === 0) {
        vitrine.innerHTML = `
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" aria-hidden="true">
            <path d="M12 21s-7-6.2-7-11.5A7 7 0 0 1 19 9.5C19 14.8 12 21 12 21z"/><circle cx="12" cy="9.5" r="2.5"/>
          </svg>
          <span>${multiplo ? 'Clique num cenário para ver o ícone dele aqui' : 'Clique num cenário para escolhê-lo'}</span>`;
        return;
      }

      vitrine.replaceChildren(...lista.map(slug => {
        const item = document.createElement('figure');
        item.className = 'vitrine__item' + (slug === ultimo ? ' vitrine__item--novo' : '');

        const img = document.createElement('img');
        img.src = imagemDo(slug);
        img.alt = '';

        const nome = document.createElement('figcaption');
        nome.textContent = nomeDo(slug);

        item.append(img, nome);
        return item;
      }));
    }

    desenharVitrine([]);

    return {
      valores: chips.valores,
      marcar(lista) {
        ultimo = null;
        chips.marcar(lista);
        desenharVitrine(chips.valores());
      },
      limpar() { this.marcar([]); }
    };
  }

  /* ═══════════════════════════════════════════════════════════════════
     O CARTÃO DE UMA PERGUNTA

       selecionavel  -> vira <label> com caixinha de marcar (montar quiz)
       marcada       -> já começa marcada
       aoMarcar(q, marcada)
       aoApagar(q)   -> mostra o × de apagar (Minhas perguntas)

     A alternativa certa só aparece destacada nas perguntas do próprio
     professor: as do sistema chegam do servidor sem o gabarito.
     Tudo que veio do banco entra por textContent, nunca innerHTML.
     ═══════════════════════════════════════════════════════════════════ */
  function cartaoQuestao(q, { selecionavel = false, marcada = false, aoMarcar, aoApagar } = {}) {
    const cartao = document.createElement(selecionavel ? 'label' : 'article');
    cartao.className = 'questao-card';
    cartao.dataset.id = q.id;

    if (selecionavel) {
      const caixa = document.createElement('input');
      caixa.type = 'checkbox';
      caixa.className = 'questao-card__marca';
      caixa.checked = marcada;
      cartao.classList.toggle('questao-card--marcada', marcada);
      caixa.addEventListener('change', () => {
        cartao.classList.toggle('questao-card--marcada', caixa.checked);
        aoMarcar?.(q, caixa.checked);
      });
      cartao.appendChild(caixa);
    }

    const slug = q.cenario?.slug;
    const icone = document.createElement('span');
    icone.className = 'questao-card__icone';
    const img = document.createElement('img');
    img.src = imagemDo(slug);
    img.alt = '';
    img.loading = 'lazy';
    icone.appendChild(img);

    const meio = document.createElement('div');
    meio.className = 'questao-card__meio';

    const enunciado = document.createElement('p');
    enunciado.className = 'questao-card__enunciado';
    enunciado.textContent = q.enunciado;

    const opcoes = document.createElement('ol');
    opcoes.className = 'questao-card__opcoes';
    for (const letra of ['A', 'B', 'C', 'D', 'E']) {
      const texto = q[`opcao_${letra.toLowerCase()}`];
      if (!texto) continue;   // Verdadeiro/Falso tem só A e B; só o nível 3 tem E
      const li = document.createElement('li');
      li.dataset.letra = letra;
      li.textContent = texto;
      if (q.resposta_correta === letra) {
        li.classList.add('questao-card__opcao--certa');
        li.title = 'Alternativa correta';
      }
      opcoes.appendChild(li);
    }

    const tags = document.createElement('div');
    tags.className = 'questao-card__tags';
    tags.appendChild(etiqueta(nomeDo(slug, q.cenario?.nome || 'Sem cenário'), 'quiz-tag--lugar'));
    tags.appendChild(etiqueta(FAIXAS[q.nivel_etario] || `Nível ${q.nivel_etario}`, 'quiz-tag--nivel'));
    (q.areas || []).forEach(a => tags.appendChild(etiqueta(a, '', AREAS[a])));
    if (q.minha) tags.appendChild(etiqueta('Minha', 'quiz-tag--minha'));

    meio.append(enunciado, opcoes, tags);

    if (q.minha && q.explicacao) {
      const exp = document.createElement('p');
      exp.className = 'questao-card__explicacao';
      exp.textContent = q.explicacao;
      meio.appendChild(exp);
    }

    cartao.append(icone, meio);

    if (aoApagar) {
      const apagar = document.createElement('button');
      apagar.type = 'button';
      apagar.className = 'quiz-linha__apagar questao-card__apagar';
      apagar.title = 'Apagar esta pergunta';
      apagar.setAttribute('aria-label', 'Apagar');
      apagar.innerHTML = '&times;';
      apagar.addEventListener('click', () => aoApagar(q));
      cartao.appendChild(apagar);
    }

    return cartao;
  }

  function etiqueta(texto, classe = '', cor) {
    const tag = document.createElement('span');
    tag.className = `quiz-tag ${classe}`.trim();
    if (cor) tag.style.setProperty('--tag-cor', cor);
    tag.textContent = texto;
    return tag;
  }

  /* ═══════════════════════════════════════════════════════════════════
     MODAL "NOVA PERGUNTA"

     Desenhado por este arquivo, e não escrito em cada página, para ser
     literalmente o mesmo modal no "Criar quiz" do painel e no "Minhas
     perguntas" da página de quizzes. Nasce na primeira vez que é aberto.

     Ele fica POR CIMA de outro modal (o de criar quiz), então o Esc e o
     clique fora são tratados aqui, na fase de captura: fecham só ele, e
     o modal de baixo continua aberto com tudo o que já foi preenchido.
     ═══════════════════════════════════════════════════════════════════ */
  let modal = null;
  let campos = null;
  let aoCriarAtual = null;

  function montarModal() {
    modal = document.createElement('div');
    modal.className = 'modal modal--sobre modal-questao';
    modal.hidden = true;
    modal.innerHTML = `
      <div class="modal__caixa modal__caixa--larga" role="dialog" aria-modal="true" aria-labelledby="questao-titulo">
        <div class="modal-header">
          <h3 id="questao-titulo">Nova pergunta</h3>
          <button type="button" class="modal__fechar" data-fechar aria-label="Fechar">&times;</button>
        </div>
        <p class="modal__sub">Só você vê as perguntas que cria. Elas ficam em “Minhas questões”, prontas para entrar nos seus quizzes.</p>

        <div class="campo">
          <span class="campo__label">Cenário <span class="campo__dica">(o lugar do mapa onde a pergunta acontece)</span></span>
          <div data-cenario></div>
        </div>

        <div class="campo">
          <span class="campo__label">Nível etário</span>
          <div data-nivel></div>
        </div>

        <label class="campo">
          <span class="campo__label">Enunciado</span>
          <textarea data-enunciado rows="3" maxlength="1000"
            placeholder="Ex: Qual destas atitudes ajuda a evitar o mosquito da dengue?"></textarea>
        </label>

        <div class="campo">
          <span class="campo__label">Alternativas
            <span class="campo__dica">(marque a bolinha da correta · deixe C e D vazias para Verdadeiro/Falso)</span>
          </span>
          <div class="alternativas">
            ${['A', 'B', 'C', 'D'].map(l => `
              <div class="alternativa">
                <label class="alternativa__certa" title="Marcar a ${l} como correta">
                  <input type="radio" name="questao-certa" value="${l}">
                  <span class="alternativa__letra">${l}</span>
                </label>
                <input type="text" data-opcao="${l}" maxlength="255"
                  placeholder="${l === 'C' || l === 'D' ? 'Opcional' : `Alternativa ${l}`}" autocomplete="off">
              </div>`).join('')}
          </div>
        </div>

        <label class="campo">
          <span class="campo__label">Explicação <span class="campo__dica">(o aluno lê depois de responder, acertando ou errando)</span></span>
          <textarea data-explicacao rows="2" maxlength="1000"
            placeholder="Ex: Água parada é onde o mosquito põe os ovos. Sem recipiente, sem criadouro."></textarea>
        </label>

        <div class="campo">
          <span class="campo__label">Áreas <span class="campo__dica">(quais barras o acerto faz crescer)</span></span>
          <div data-areas></div>
        </div>

        <p class="modal__erro" data-erro hidden></p>

        <div class="modal__acoes">
          <button type="button" class="btn-ghost" data-fechar>Cancelar</button>
          <button type="button" class="btn-primary" data-salvar>Salvar pergunta</button>
        </div>
      </div>
    `;
    document.body.appendChild(modal);

    const $ = (sel) => modal.querySelector(sel);

    campos = {
      cenario: seletorCenarios($('[data-cenario]'), { multiplo: false }),
      nivel: grupoDeChips($('[data-nivel]'),
        Object.entries(FAIXAS).map(([n, rotulo]) => ({ valor: n, rotulo })), { multiplo: false }),
      areas: grupoDeChips($('[data-areas]'), itensDeArea()),
      enunciado: $('[data-enunciado]'),
      explicacao: $('[data-explicacao]'),
      opcoes: Object.fromEntries(['A', 'B', 'C', 'D'].map(l => [l, $(`[data-opcao="${l}"]`)])),
      erro: $('[data-erro]'),
      salvar: $('[data-salvar]')
    };

    modal.querySelectorAll('[data-fechar]').forEach(b => b.addEventListener('click', fechar));
    modal.addEventListener('click', (e) => { if (e.target === modal) fechar(); });

    window.addEventListener('keydown', (e) => {
      if (e.key !== 'Escape' || modal.hidden) return;
      e.stopPropagation();
      fechar();
    }, true);

    campos.salvar.addEventListener('click', salvar);
  }

  /**
   * Abre o modal.
   *   cenario  slug já escolhido (opcional)
   *   nivel    1, 2 ou 3 já escolhido (opcional)
   *   aoCriar  chamado com a pergunta criada, como o servidor a devolveu
   */
  function abrirCriacao({ cenario, nivel, aoCriar } = {}) {
    if (!modal) montarModal();

    aoCriarAtual = aoCriar || null;

    campos.cenario.marcar(cenario ? [cenario] : []);
    campos.nivel.marcar(nivel ? [String(nivel)] : []);
    campos.areas.limpar();
    campos.enunciado.value = '';
    campos.explicacao.value = '';
    Object.values(campos.opcoes).forEach(i => { i.value = ''; });
    modal.querySelectorAll('input[name="questao-certa"]').forEach(r => { r.checked = false; });
    esconderErro();

    modal.hidden = false;
    campos.enunciado.focus();
  }

  function fechar() {
    if (!modal) return;
    modal.hidden = true;
    aoCriarAtual = null;
  }

  async function salvar() {
    const certa = modal.querySelector('input[name="questao-certa"]:checked');
    const op = (l) => campos.opcoes[l].value.trim();

    const dados = {
      cenario: campos.cenario.valores()[0] || '',
      nivel_etario: Number(campos.nivel.valores()[0]) || null,
      enunciado: campos.enunciado.value.trim(),
      opcao_a: op('A'),
      opcao_b: op('B'),
      opcao_c: op('C'),
      opcao_d: op('D'),
      resposta_correta: certa ? certa.value : '',
      explicacao: campos.explicacao.value.trim(),
      areas: campos.areas.valores()
    };

    // As mesmas conferências do servidor, só para avisar antes da viagem.
    // Quem decide de verdade é ele (POST /api/professor/questoes).
    if (!dados.cenario) return mostrarErro('Escolha o cenário da pergunta.');
    if (!dados.nivel_etario) return mostrarErro('Escolha o nível etário da pergunta.');
    if (dados.enunciado.length < 10) return mostrarErro('Escreva o enunciado da pergunta (pelo menos 10 letras).');
    if (!dados.opcao_a || !dados.opcao_b) return mostrarErro('Preencha pelo menos as alternativas A e B.');
    if (!dados.opcao_c && dados.opcao_d) return mostrarErro('Preencha a alternativa C antes da D.');
    if (!dados.resposta_correta) return mostrarErro('Marque a bolinha da alternativa correta.');
    if (!op(dados.resposta_correta)) return mostrarErro('A alternativa marcada como correta está vazia.');
    if (dados.explicacao.length < 5) return mostrarErro('Escreva a explicação que o aluno lê depois de responder.');
    if (dados.areas.length === 0) return mostrarErro('Escolha pelo menos uma área para a pergunta dar pontos.');

    esconderErro();
    campos.salvar.disabled = true;
    campos.salvar.textContent = 'Salvando...';

    try {
      const criada = await API.criarQuestao(dados);
      const avisar = aoCriarAtual;
      fechar();
      avisar?.(criada);
    } catch (err) {
      mostrarErro(err.message);
    } finally {
      campos.salvar.disabled = false;
      campos.salvar.textContent = 'Salvar pergunta';
    }
  }

  function mostrarErro(msg) {
    campos.erro.textContent = msg;
    campos.erro.hidden = false;
  }

  function esconderErro() {
    campos.erro.textContent = '';
    campos.erro.hidden = true;
  }

  return {
    LUGARES, AREAS, FAIXAS,
    itensDeArea,
    grupoDeChips,
    seletorCenarios,
    cartaoQuestao,
    abrirCriacao
  };
})();
