/** minha-turma.js — a turma do aluno e os colegas (ordem por XP); quem não tem turma escolhe aqui. */
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

  let souEu = null;             // o perfil de quem abriu a tela
  let entradaLigada = false;    // o formulário de entrar só se liga uma vez

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // Tela de aluno. O professor vê as turmas dele pelo painel — mas a
    // conta de equipe fica, porque ela entra em turma para jogar.
    const perfil = await AUTH.perfilAtual();
    if (perfil && perfil.tipo === 'PROFESSOR') {
      window.location.href = 'dashboard.html';
      return;
    }

    souEu = perfil;
    ligarSaida();

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

    const aviso = document.getElementById('turma-aviso-equipe');
    if (aviso) aviso.hidden = !souEu || souEu.tipo === 'ALUNO';
    document.title = `${turma.nome} - Heróis da Saúde`;

    const ponto = document.getElementById('turma-cor');
    if (turma.cor) ponto.style.background = turma.cor;

    // textContent: texto escrito por pessoas.
    escrever('turma-nome', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);

    // `turma.escola` saiu da resposta do servidor junto com as escolas.
    const onde = [turma.professor && `Prof. ${turma.professor}`].filter(Boolean);
    escrever('turma-onde', onde.join(' · '));

    // `total_alunos` conta só alunos. Para quem é da equipe a frase
    // muda de dono: ela não é um deles, está acompanhando.
    const quantos = turma.total_alunos || 0;
    const souAluno = !souEu || souEu.tipo === 'ALUNO';

    if (!souAluno) {
      subtitulo.textContent = quantos === 1
        ? '1 aluno nesta turma.'
        : `${quantos} ${plural(quantos, 'aluno', 'alunos')} nesta turma.`;
    } else {
      subtitulo.textContent = quantos === 1
        ? 'Você é o primeiro da turma por aqui.'
        : `Você e mais ${quantos - 1} ${plural(quantos - 1, 'colega', 'colegas')} nesta turma.`;
    }

    mostrarProfessor(turma.professor_perfil);

    // Posição só faz sentido com colega: "1º de 1" não é conquista.
    if (!posicao || posicao.total < 2) return;

    document.getElementById('turma-posicao').hidden = false;
    escrever('posicao-lugar', `${posicao.lugar}º`);
    escrever('posicao-rot', `de ${posicao.total} na turma`);
  }

  /** Perfil do professor visto pelo aluno. */
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

    // A régua das barrinhas sai do maior XP ENTRE OS ALUNOS. Uma conta
    // de equipe com XP ajustado à mão encostaria todas as barras da
    // turma no chão, e a tela deixaria de dizer qualquer coisa sobre
    // quem está jogando.
    const daTurma = colegas.filter(c => !c.equipe);
    const teto = Math.max(...(daTurma.length ? daTurma : colegas).map(c => c.xp), 1);

    lista.innerHTML = '';
    colegas.forEach((c, i) => lista.appendChild(montarLinha(c, i, teto)));
  }

  function montarLinha(colega, ordem, teto) {
    const li = document.createElement('li');
    li.className = 'colega';
    li.style.setProperty('--i', ordem);

    // Medalha só para quem já pontuou: três zeros não são um pódio.
    // E nunca para a equipe, que está na lista mas fora da disputa —
    // numa turma de dois alunos ela cairia no pódio por sobra de vaga.
    if (!colega.equipe && colega.xp > 0 && PODIO[ordem]) li.classList.add(PODIO[ordem]);
    if (colega.equipe) li.classList.add('colega--equipe');
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

    // Foto do colega (ou iniciais).
    const avatar = li.querySelector('.colega__avatar');
    if (window.AVATAR) window.AVATAR.desenhar(avatar, colega.nome, colega.avatar_url);
    else avatar.textContent = inicial(colega.nome);

    // A equipe não recebe número: ela está sempre por último de
    // propósito, e um "4º" ali seria lido como quarto lugar.
    li.querySelector('.colega__pos').textContent = colega.equipe ? '—' : `${ordem + 1}º`;

    // Só o primeiro nome.
    li.querySelector('.colega__nome').textContent =
      colega.eu ? `${primeiroNome(colega.nome)} (você)` : primeiroNome(colega.nome);

    // Nível e patente ao lado do nome.
    const patente = li.querySelector('.colega__patente');
    if (colega.nivel && window.PATENTE) {
      // A etiqueta é montada por PATENTE.html, que escapa o nome dela.
      patente.innerHTML = window.PATENTE.html(colega.nivel, true) +
        '<span class="colega__nv"></span>' +
        (colega.equipe ? '<span class="colega__equipe">equipe</span>' : '');
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

  /* ── Entrar numa turma (só para quem está sem) ── pelo código; quem grava é o servidor. */

  let turmaDoCodigo = null;     // a turma que o código digitado achou

  function prepararEntrada() {
    // Sair e entrar de novo sem recarregar passaria por aqui duas
    // vezes, e o segundo ouvinte mandaria o formulário em dobro.
    if (entradaLigada) return;
    entradaLigada = true;

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

    // Entrar.
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

  /* ── Sair da turma ───────────────────────────────────────────────

     O medo de perder o que já fez é o que trava a pessoa aqui, então o
     aviso diz, com todas as letras, o que acontece: nada do progresso
     sai junto. Isso é verdade porque XP, acertos e insígnias estão
     presos ao usuário, e não à turma. */

  function ligarSaida() {
    const botao = document.getElementById('sair-turma');
    if (!botao) return;

    botao.addEventListener('click', async () => {
      const combinado = confirm(
        'Sair desta turma?\n\n' +
        'Seu XP, seu nível, suas conquistas e suas respostas continuam todos ' +
        'com você — nada disso é da turma, é seu.\n\n' +
        'O que para é o que vem do professor: os quizes da turma e a sua ' +
        'posição no ranking dela. Entrando de novo com o mesmo código, tudo volta.'
      );
      if (!combinado) return;

      botao.disabled = true;
      botao.textContent = 'Saindo...';

      try {
        await API.sairDaTurma();
        voltarAoComeco();
      } catch (err) {
        erro.textContent = err.message;
        erro.hidden = false;
      } finally {
        botao.disabled = false;
        botao.textContent = 'Sair da turma';
      }
    });
  }

  /** Devolve a tela ao estado de quem ainda não escolheu turma. */
  function voltarAoComeco() {
    erro.hidden = true;
    document.title = 'Minha turma - Heróis da Saúde';

    for (const id of ['bloco-turma', 'bloco-professor', 'bloco-colegas',
                      'titulo-colegas', 'turma-posicao', 'turma-aviso-equipe']) {
      const el = document.getElementById(id);
      if (el) el.hidden = true;
    }

    lista.innerHTML = '';
    blocoSemTurma.hidden = false;
    subtitulo.textContent = 'Você saiu da turma. Seu progresso continua todo aí.';

    // O código digitado antes fica guardado em turmaDoCodigo; sem
    // limpar, apertar "Entrar" sem digitar nada devolveria a pessoa à
    // turma de onde ela acabou de sair.
    turmaDoCodigo = null;
    document.getElementById('entrar-codigo').value = '';
    document.getElementById('entrar-dica').textContent = '';

    prepararEntrada();
    document.getElementById('entrar-codigo').focus();
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
