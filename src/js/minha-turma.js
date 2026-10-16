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

    // `turma.escola` saiu da resposta do servidor junto com as escolas.
    const onde = [turma.professor && `Prof. ${turma.professor}`].filter(Boolean);
    escrever('turma-onde', onde.join(' · '));

    const quantos = turma.total_alunos || 0;
    subtitulo.textContent = quantos === 1
      ? 'Você é o primeiro da turma por aqui.'
      : `Você e mais ${quantos - 1} ${plural(quantos - 1, 'colega', 'colegas')} nesta turma.`;

    mostrarProfessor(turma.professor_perfil);

    // Posição só faz sentido com colega: "1º de 1" não é conquista.
    if (!posicao || posicao.total < 2) return;

    document.getElementById('turma-posicao').hidden = false;
    escrever('posicao-lugar', `${posicao.lugar}º`);
    escrever('posicao-rot', `de ${posicao.total} na turma`);
  }

  /**
   * O perfil do professor, visto pelo aluno.
   *
   * O jogo é sobre uma dupla: o aluno aprende, o professor ensina, e o
   * XP do professor vem inteiro do avanço da turma. Mostrar o nível
   * dele aqui é o que torna isso visível — o aluno descobre que, quando
   * ele avança, o professor avança junto.
   */
  function mostrarProfessor(prof) {
    const bloco = document.getElementById('bloco-professor');
    if (!bloco || !prof) return;

    bloco.hidden = false;

    if (window.AVATAR) {
      window.AVATAR.desenhar(document.getElementById('prof-avatar'), prof.nome, prof.avatar_url);
    }

    escrever('prof-nome', prof.nome || 'Professor');
    const seloProf = document.getElementById('prof-patente');
    if (seloProf && window.PATENTE) window.PATENTE.pintar(seloProf, prof.nivel, true);
    else escrever('prof-patente', prof.nivel ? `Nv ${prof.nivel.nivel} · ${prof.nivel.patente}` : '');
    escrever('prof-xp', `${(prof.xp || 0).toLocaleString('pt-BR')} XP`);

    const barra = document.getElementById('prof-barra');
    if (barra && prof.nivel) barra.style.width = `${prof.nivel.porcentagem}%`;

    // A frase que liga as duas progressões. Sem ela o cartão é só mais
    // um número na tela; com ela, vira o motivo de o aluno jogar.
    escrever('prof-nota', prof.conclusoes
      ? `${prof.conclusoes} ${plural(prof.conclusoes, 'tarefa concluída', 'tarefas concluídas')} pela turma` +
        (prof.taxa_media !== null && prof.taxa_media !== undefined ? ` · ${prof.taxa_media}% de acerto na primeira tentativa` : '')
      : 'O nível do seu professor sobe quando a turma conclui as tarefas dele.');
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
      <span class="colega__avatar"></span>
      <span class="colega__pos"></span>
      <span class="colega__meio">
        <span class="colega__nome"></span>
        <span class="colega__patente"></span>
      </span>
      <span class="colega__barra"><i></i></span>
      <span class="colega__xp"></span>
    `;

    // A foto do colega, com as iniciais de plano B. Mesma função que
    // desenha o avatar da barra de cima — uma regra só para o círculo.
    const avatar = li.querySelector('.colega__avatar');
    if (window.AVATAR) window.AVATAR.desenhar(avatar, colega.nome, colega.avatar_url);
    else avatar.textContent = inicial(colega.nome);

    li.querySelector('.colega__pos').textContent = `${ordem + 1}º`;

    // Só o primeiro nome. A lista fica legível no celular, e o sobrenome
    // de uma criança não precisa ficar exposto para a turma inteira.
    li.querySelector('.colega__nome').textContent =
      colega.eu ? `${primeiroNome(colega.nome)} (você)` : primeiroNome(colega.nome);

    // Nível e patente ao lado do nome: é a mesma régua do perfil, então
    // o aluno reconhece o próprio número quando se vê na lista.
    const patente = li.querySelector('.colega__patente');
    if (colega.nivel && window.PATENTE) {
      // A etiqueta é montada por PATENTE.html, que escapa o nome dela.
      patente.innerHTML = window.PATENTE.html(colega.nivel, true) +
        '<span class="colega__nv"></span>';
      patente.querySelector('.colega__nv').textContent = `Nv ${colega.nivel.nivel}`;
    } else {
      patente.textContent = colega.nivel
        ? `Nv ${colega.nivel.nivel} · ${colega.nivel.patente}`
        : '';
    }

    li.querySelector('.colega__barra i').style.width = `${Math.round((colega.xp / teto) * 100)}%`;
    li.querySelector('.colega__xp').textContent = `${colega.xp.toLocaleString('pt-BR')} XP`;

    return li;
  }

  /* ── Entrar numa turma (só para quem está sem) ─────────────────────
     Os mesmos dois caminhos do cadastro (auth.js): o código que o
     professor entrega. Ele termina num
     turma_id mandado para POST /api/minha-turma — é o servidor que
     grava, e só para quem ainda não tem turma.
     ─────────────────────────────────────────────────────────────── */

  let turmaDoCodigo = null;     // a turma que o código digitado achou

  function prepararEntrada() {
    const form = document.getElementById('form-entrar-turma');
    const codigo = document.getElementById('entrar-codigo');
    const dica = document.getElementById('entrar-dica');
    const btn = document.getElementById('entrar-btn');

    const avisar = (texto, tipo = '') => {
      dica.textContent = texto;
      dica.className = 'entrar-turma__dica' + (tipo ? ` entrar-turma__dica--${tipo}` : '');
    };

    async function procurarCodigo() {
      const texto = codigo.value.trim();
      turmaDoCodigo = null;
      if (!texto) { avisar('Digite o código que seu professor passou.', 'erro'); return null; }

      avisar('Procurando turma...');
      try {
        const turma = await API.getTurmaPorCodigo(texto);
        if (!turma) { avisar('Código não encontrado. Confira com seu professor.', 'erro'); return null; }

        turmaDoCodigo = turma;
        avisar(`Turma ${turma.nome}`, 'ok');
        return turma;
      } catch (_) {
        avisar('Não foi possível conferir o código agora. Tente de novo.', 'erro');
        return null;
      }
    }

    // ── Pela lista ──
    // ── Entrar ──
    form.addEventListener('submit', async (e) => {
      e.preventDefault();

      const turma = turmaDoCodigo || await procurarCodigo();
      if (!turma) return;
      const turmaId = turma.id;

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

  /* ── Utilidades ────────────────────────────────────────────────── */

  function escrever(id, texto) {
    const alvo = document.getElementById(id);
    if (alvo) alvo.textContent = texto;
  }

  const plural = (n, um, muitos) => (n === 1 ? um : muitos);

  const primeiroNome = (nome) => String(nome || '').trim().split(/\s+/)[0] || '—';

  const inicial = (nome) => (nome || '?').trim().charAt(0).toUpperCase();
})();
