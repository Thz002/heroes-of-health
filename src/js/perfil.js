/**
 * perfil.js — a tela "Meu perfil" (perfil.html)
 *
 * Serve os dois papéis, porque os dois têm conta: o aluno vê a faixa
 * etária, a turma e os números do jogo; o professor vê a escola e
 * quantas turmas mantém.
 *
 * Nada aqui é editável ainda. É de propósito: trocar nome, idade ou
 * turma mexe em quem a pessoa é dentro do jogo (a idade decide QUAIS
 * questões ela vê), e isso pede regra combinada antes de tela.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const erro = document.getElementById('perfil-erro');
  const subtitulo = document.getElementById('perfil-subtitulo');
  const lista = document.getElementById('dado-lista');

  const ROTULO_TIPO = { ALUNO: 'Aluno', PROFESSOR: 'Professor', ADMIN: 'Equipe do projeto' };

  // As mesmas três faixas do resto do sistema. Aqui elas servem para a
  // pessoa entender POR QUE vê o conteúdo que vê.
  const FAIXAS = [
    { ate: 10, nivel: 1, texto: '7 a 10 anos' },
    { ate: 14, nivel: 2, texto: '11 a 14 anos' },
    { ate: 18, nivel: 3, texto: '15 a 18 anos' }
  ];

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    let perfil = null;
    try {
      perfil = await AUTH.perfilAtual();
    } catch (_) { /* tratado abaixo */ }

    if (!perfil) {
      mostrarErro('Não foi possível carregar seu cadastro.');
      return;
    }

    mostrarIdentidade(perfil);

    try {
      if (perfil.tipo === 'PROFESSOR') await comoProfessor(perfil);
      else await comoAluno(perfil);
    } catch (err) {
      mostrarErro(err.message);
    }
  }

  /* ── O cartão de cima ──────────────────────────────────────────── */

  function mostrarIdentidade(perfil) {
    document.getElementById('avatar-grande').textContent = iniciais(perfil.nome);

    // textContent: nome é texto escrito por pessoa, nunca código.
    escrever('dado-nome', perfil.nome || 'Sem nome');
    escrever('dado-tipo', ROTULO_TIPO[perfil.tipo] || perfil.tipo || '');

    subtitulo.textContent = perfil.tipo === 'PROFESSOR'
      ? 'Seus dados e suas turmas.'
      : 'Seus dados no jogo.';
  }

  async function comoAluno(perfil) {
    const faixa = FAIXAS.find(f => perfil.idade <= f.ate);

    if (perfil.idade) {
      linha('Idade', `${perfil.idade} anos`);
      // O "por quê" junto do dado: sem isso o número é só um número, e a
      // pessoa não liga a idade ao conteúdo que aparece para ela.
      if (faixa) linha('Faixa do conteúdo', `Nível ${faixa.nivel} — missões de ${faixa.texto}`);
    }

    const { turma, estatisticas } = await API.getMeuResumo();

    if (turma) {
      linha('Turma', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);
      if (turma.escola) linha('Escola', turma.escola);
      if (turma.professor) linha('Professor', turma.professor);
    } else {
      linha('Turma', 'ainda não entrou em nenhuma');
    }

    mostrarNumeros(estatisticas);
    document.getElementById('bloco-numeros').hidden = false;
    document.getElementById('atalhos').hidden = false;
  }

  async function comoProfessor(perfil) {
    let turmas = [];
    try { turmas = await API.getMinhasTurmas(); } catch (_) { /* segue sem a contagem */ }

    const escola = await nomeDaEscola(perfil.escola_id);
    if (escola) linha('Escola', escola);

    linha('Turmas', turmas.length
      ? `${turmas.length} ${turmas.length === 1 ? 'turma' : 'turmas'}`
      : 'nenhuma turma criada ainda');

    const alunos = turmas.reduce((s, t) => s + (t.total_alunos || 0), 0);
    if (alunos) linha('Alunos', `${alunos} ${alunos === 1 ? 'aluno' : 'alunos'} no total`);
  }

  /** O nome da escola sai da lista pública — é a mesma que o cadastro usa. */
  async function nomeDaEscola(id) {
    if (!id) return null;
    try {
      const escolas = await API.getEscolas();
      return escolas.find(e => e.id === id)?.nome || null;
    } catch (_) {
      return null;
    }
  }

  /* ── Os números do aluno ───────────────────────────────────────── */

  function mostrarNumeros(e) {
    if (!e) return;

    escrever('num-xp', e.xp.toLocaleString('pt-BR'));
    escrever('num-xp-nota', e.acertos_unicos
      ? `${e.acertos_unicos} ${plural(e.acertos_unicos, 'pergunta nova', 'perguntas novas')}`
      : 'cada pergunta nova vale 10');

    escrever('num-missoes', e.missoes_concluidas);
    escrever('num-missoes-nota', e.missoes_totais
      ? `de ${e.missoes_totais} que seu professor passou`
      : 'nenhuma tarefa passada ainda');

    escrever('num-streak', e.streak_dias
      ? `${e.streak_dias} ${plural(e.streak_dias, 'dia', 'dias')}`
      : '—');
    escrever('num-streak-nota', e.jogou_hoje ? 'você jogou hoje' : 'jogue hoje para continuar');

    escrever('num-taxa', e.taxa === null ? '—' : `${e.taxa}%`);
    escrever('num-taxa-nota', e.respostas
      ? `${e.acertos} de ${e.respostas} ${plural(e.respostas, 'resposta', 'respostas')}`
      : 'assim que você responder a primeira');
  }

  /* ── Utilidades ────────────────────────────────────────────────── */

  /** Uma linha "rótulo / valor" no cartão. */
  function linha(rotulo, valor) {
    const dt = document.createElement('dt');
    const dd = document.createElement('dd');
    dt.textContent = rotulo;
    dd.textContent = valor;
    lista.append(dt, dd);
  }

  function escrever(id, texto) {
    const alvo = document.getElementById(id);
    if (alvo) alvo.textContent = texto;
  }

  function mostrarErro(mensagem) {
    erro.textContent = mensagem;
    erro.hidden = false;
  }

  function iniciais(nome) {
    const partes = String(nome || '').trim().split(/\s+/).filter(Boolean);
    if (!partes.length) return '?';
    if (partes.length === 1) return partes[0].charAt(0).toUpperCase();
    return (partes[0].charAt(0) + partes[partes.length - 1].charAt(0)).toUpperCase();
  }

  const plural = (n, um, muitos) => (n === 1 ? um : muitos);
})();
