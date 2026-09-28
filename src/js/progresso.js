/**
 * progresso.js — a tela "Meu progresso" (progresso.html)
 *
 * O buraco que esta tela fecha: o servidor já somava os pontos das 8
 * áreas desde o começo, e o aluno nunca via nada disso. Ele acertava, a
 * missão sumia da lista do mapa, e acabava. A recompensa do jogo existia
 * só dentro do banco.
 *
 * A tela tem três blocos, de cima para baixo:
 *
 *   1. os quatro números — missões, XP, sequência de dias, taxa de acerto
 *   2. a turma dele e a posição entre os colegas
 *   3. as 8 barras por tema
 *
 * REGRA QUE VALE PARA A TELA INTEIRA: nada aqui pode soar como fracasso.
 * Uma barra baixa é "começando", nunca "ruim"; e a porcentagem não
 * aparece escrita. Para uma criança de 7 anos, um "31%" vermelho é
 * motivo para largar o jogo — a barra curta com a palavra gentil ao lado
 * conta a mesma coisa sem a pancada.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const erro = document.getElementById('progresso-erro');
  const subtitulo = document.getElementById('progresso-subtitulo');

  const blocoTurma = document.getElementById('bloco-turma');
  const blocoSemTurma = document.getElementById('bloco-sem-turma');
  const listaTemas = document.getElementById('lista-temas');

  /* ── Os rótulos gentis ────────────────────────────────────────────
     A faixa é escolhida pela PRIMEIRA linha cujo teto a porcentagem não
     ultrapassa. A ordem importa, e o último teto é 100.

     Nenhum rótulo é uma nota. "A explorar" diz que tem coisa nova ali;
     "começando" diz que já começou. Os dois convidam a continuar, que é
     o trabalho que esta coluna tem de fazer.
     ─────────────────────────────────────────────────────────────── */
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
      mostrarTemas(areas);

    } catch (err) {
      // Sem invenção: se não deu para carregar, a tela diz isso em vez de
      // desenhar barras vazias que pareceriam progresso perdido.
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

  /**
   * A sequência é a única caixa que pode dar um empurrão, e é onde o tom
   * mais importa: quem parou há uma semana não precisa ler que perdeu
   * nada — precisa de um convite para voltar.
   */
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

    // textContent e não innerHTML: nome de turma e de escola são texto
    // escrito por pessoa, nunca código rodando na página.
    escrever('turma-nome', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);

    const onde = [turma.escola, turma.professor && `Prof. ${turma.professor}`].filter(Boolean);
    escrever('turma-onde', onde.join(' · '));

    // Posição só faz sentido com colega: "1º de 1" não é conquista.
    if (!posicao || posicao.total < 2) return;

    document.getElementById('turma-posicao').hidden = false;
    escrever('posicao-lugar', `${posicao.lugar}º`);
    escrever('posicao-rot', `de ${posicao.total} na turma`);
  }

  /* ── BLOCO 3 — as 8 barras ─────────────────────────────────────── */

  function mostrarTemas(areas) {
    listaTemas.innerHTML = '';
    areas.forEach((a, i) => listaTemas.appendChild(montarTema(a, i)));
  }

  function montarTema(a, ordem) {
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

    // Área sem conteúdo nenhum: a barra ficaria eternamente vazia e o
    // aluno leria isso como culpa dele. Melhor dizer que ainda não tem.
    if (a.sem_conteudo) {
      linha.classList.add('tema--vazio');
      barra.style.width = '0%';
      rotulo.textContent = 'em breve';
      linha.title = 'Ainda não há perguntas desta área no jogo.';
      return linha;
    }

    const pct = Math.max(0, Math.min(100, Math.round(a.porcentagem || 0)));
    const faixa = FAIXAS.find(f => pct <= f.ate) || FAIXAS[FAIXAS.length - 1];

    linha.classList.add(faixa.classe);
    rotulo.textContent = faixa.rotulo;

    // A meta de uma área é TODO o conteúdo que ela tem no jogo (Saúde
    // vale 1672 pontos hoje). Quem acertou as primeiras perguntas está
    // em 1% ou 2% — e 2% de uma barra são dois pixels, que a pessoa lê
    // como "não aconteceu nada".
    //
    // Então quem já pontuou tem no mínimo um pedacinho visível. Não é
    // mentira: a barra mostra que existe progresso, e o número exato
    // continua inteiro no title.
    barra.style.width = pct > 0 && pct < PISO_VISIVEL ? `${PISO_VISIVEL}%` : `${pct}%`;

    // O número exato existe, mas só para quem for atrás dele. Na tela
    // fica a palavra; no title, a conta.
    linha.title = `${a.pontos} de ${a.meta} pontos em ${a.area}`;

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
