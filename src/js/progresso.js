/** progresso.js — "Meu progresso" (progresso.html): números, turma e as 8 barras.
    Nada soa como fracasso: rótulos gentis em vez de porcentagem. */
(() => {
  'use strict';

  const erro = document.getElementById('progresso-erro');
  const subtitulo = document.getElementById('progresso-subtitulo');

  const blocoTurma = document.getElementById('bloco-turma');
  const blocoSemTurma = document.getElementById('bloco-sem-turma');
  const listaTemas = document.getElementById('lista-temas');
  const temasIntro = document.getElementById('temas-intro');
  const caixaAviso = document.getElementById('aviso-novas');

  let usuarioId = null;

  /* Rótulos gentis: a primeira faixa cujo teto não é ultrapassado (o último é 100). */
  /** Menor largura que ainda se enxerga numa barra, em % dela. */
  const PISO_VISIVEL = 4;

  const FAIXAS = [
    { ate: 0,   rotulo: 'a explorar',   classe: 'tema--zero' },
    { ate: 24,  rotulo: 'começando',    classe: 'tema--inicio' },
    { ate: 59,  rotulo: 'em progresso', classe: 'tema--meio' },
    { ate: 89,  rotulo: 'indo bem',     classe: 'tema--bom' },
    { ate: 100, rotulo: 'dominado',     classe: 'tema--topo' }
  ];

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Tela de aluno. O professor tem o painel dele, com outros números.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'PROFESSOR') {
      window.location.href = 'dashboard.html';
      return;
    }

    usuarioId = perfil ? perfil.id : null;

    if (perfil && perfil.nome) {
      subtitulo.textContent = `${primeiroNome(perfil.nome)}, veja onde você já foi e o que ainda falta explorar.`;
    }

    await carregar();
  }

  async function carregar() {
    try {
      // As duas rotas são independentes: pedir em paralelo economiza uma
      // espera inteira numa tela que é só leitura.
      const [resumo, areas] = await Promise.all([
        API.getMeuResumo(),
        API.getMeuProgresso()
      ]);

      mostrarNumeros(resumo.estatisticas);
      mostrarTurma(resumo.turma, resumo.posicao);
      mostrarTemas(areas, Boolean(resumo.turma));

    } catch (err) {
      // Se não carregar, mostra o erro.
      erro.textContent = err.message;
      erro.hidden = false;
      listaTemas.innerHTML = '';
    }
  }

  /* ── BLOCO 1 — os quatro números ───────────────────────────────── */

  function mostrarNumeros(e) {
    escrever('num-missoes', e.missoes_concluidas);
    escrever('num-missoes-nota',
      e.missoes_totais ? `de ${e.missoes_totais} que seu professor passou` : 'nenhuma tarefa passada ainda');

    escrever('num-xp', e.xp.toLocaleString('pt-BR'));
    escrever('num-xp-nota',
      e.acertos_unicos ? `${e.acertos_unicos} ${plural(e.acertos_unicos, 'pergunta nova', 'perguntas novas')}` : 'cada pergunta nova vale 10');

    // "dias" e não um número solto: "3" sozinho não diz 3 de quê.
    escrever('num-streak', e.streak_dias ? `${e.streak_dias} ${plural(e.streak_dias, 'dia', 'dias')}` : '—');
    escrever('num-streak-nota', notaDaSequencia(e));

    escrever('num-taxa', e.taxa === null ? '—' : `${e.taxa}%`);
    escrever('num-taxa-nota',
      e.respostas ? `${e.acertos} de ${e.respostas} ${plural(e.respostas, 'resposta', 'respostas')}` : 'assim que você responder a primeira');
  }

  /** Nota da sequência: sempre um convite. */
  function notaDaSequencia(e) {
    if (e.jogou_hoje) return 'você jogou hoje';
    if (e.streak_dias) return 'jogue hoje para continuar';
    if (e.dias_jogados) return 'volte quando quiser — ela recomeça';
    return 'começa no seu primeiro dia de jogo';
  }

  /* ── BLOCO 2 — a turma ─────────────────────────────────────────── */

  function mostrarTurma(turma, posicao) {
    if (!turma) {
      blocoSemTurma.hidden = false;
      return;
    }

    blocoTurma.hidden = false;

    const ponto = document.getElementById('turma-cor');
    if (turma.cor) ponto.style.background = turma.cor;

    // textContent: texto escrito por pessoas.
    escrever('turma-nome', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);

    // `turma.escola` saiu da resposta do servidor junto com as escolas.
    const onde = [turma.professor && `Prof. ${turma.professor}`].filter(Boolean);
    escrever('turma-onde', onde.join(' · '));

    // Posição só faz sentido com colega: "1º de 1" não é conquista.
    if (!posicao || posicao.total < 2) return;

    document.getElementById('turma-posicao').hidden = false;
    escrever('posicao-lugar', `${posicao.lugar}º`);
    escrever('posicao-rot', `de ${posicao.total} na turma`);
  }

  /* ── BLOCO 3 — as 8 barras ─────────────────────────────────────── */

  /* Barras por tema (régua = missões do aluno + o que já conquistou). Sem turma, não desenha. */
  function mostrarTemas(areas, temTurma) {
    listaTemas.innerHTML = '';
    caixaAviso.replaceChildren();

    if (!temTurma) {
      temasIntro.textContent =
        'Assim que você entrar numa turma, as barras mostram quanto já fez das missões do seu professor.';
      return;
    }

    const { novas, dispensar } = NOVAS_MISSOES.conferir(usuarioId, areas);
    if (novas.length) {
      caixaAviso.appendChild(NOVAS_MISSOES.montarAviso({ novas, dispensar, linkMapa: true }));
    }

    areas.forEach((a, i) => listaTemas.appendChild(montarTema(a, i, novas.includes(a.area))));
  }

  function montarTema(a, ordem, temNovidade) {
    const linha = document.createElement('article');
    linha.className = 'tema';
    linha.style.setProperty('--i', ordem);

    linha.innerHTML = `
      <span class="tema__nome"></span>
      <span class="tema__barra"><i></i></span>
      <span class="tema__rotulo"></span>
    `;

    linha.querySelector('.tema__nome').textContent = a.area;

    const barra = linha.querySelector('.tema__barra i');
    const rotulo = linha.querySelector('.tema__rotulo');

    // Área sem missões: avisa em vez de mostrar barra vazia.
    if (a.sem_missoes) {
      linha.classList.add('tema--vazio');
      barra.style.width = '0%';
      rotulo.textContent = 'sem missões ainda';
      linha.title = 'Nenhuma das suas missões vale pontos nesta área por enquanto.';
      return linha;
    }

    const pct = Math.max(0, Math.min(100, Math.round(a.porcentagem || 0)));
    const faixa = FAIXAS.find(f => pct <= f.ate) || FAIXAS[FAIXAS.length - 1];

    linha.classList.add(faixa.classe);
    rotulo.textContent = faixa.rotulo;

    // Quem já pontuou tem um pedaço mínimo visível.
    barra.style.width = pct > 0 && pct < PISO_VISIVEL ? `${PISO_VISIVEL}%` : `${pct}%`;

    // O número exato fica no title.
    linha.title = `${a.pontos} de ${a.pontos_possiveis} pontos das suas missões em ${a.area}`;

    // Etiqueta na barra que desceu por missão nova.
    if (temNovidade) {
      const selo = document.createElement('span');
      selo.className = 'tema__novo';
      selo.textContent = 'novas missões';
      linha.querySelector('.tema__nome').appendChild(selo);
    }

    return linha;
  }

  /* ── Utilidades ────────────────────────────────────────────────── */

  function escrever(id, texto) {
    const alvo = document.getElementById(id);
    if (alvo) alvo.textContent = texto;
  }

  const plural = (n, um, muitos) => (n === 1 ? um : muitos);

  const primeiroNome = (nome) => String(nome).trim().split(/\s+/)[0];
})();
