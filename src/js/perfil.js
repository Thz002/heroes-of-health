/** perfil.js — "Meu perfil" (perfil.html), para aluno e professor. */
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

  // Estado atual, para o Cancelar desfazer.
  let atual = null;

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

    atual = perfil;
    mostrarIdentidade(perfil);
    ligarEditor();
    if (perfil.tipo === 'ADMIN') ligarEquipe(perfil);

    try {
      if (perfil.tipo === 'PROFESSOR') await comoProfessor(perfil);
      else await comoAluno(perfil);
    } catch (err) {
      mostrarErro(err.message);
    }
  }

  /* ── A patente, para quem é da equipe ──────────────────────────── */

  /** Admin troca a própria patente (o servidor confere e grava um ajuste de XP). */
  async function ligarEquipe(perfil) {
    const bloco = document.getElementById('bloco-equipe');
    const escolha = document.getElementById('equipe-patente');
    const campo = document.getElementById('equipe-nivel');
    const botao = document.getElementById('equipe-aplicar');
    const aviso = document.getElementById('equipe-aviso');
    if (!bloco) return;

    const dizer = (texto, ok) => {
      aviso.textContent = texto;
      aviso.hidden = false;
      aviso.classList.toggle('editor__aviso--ok', !!ok);
    };

    let faixas = [];
    try {
      const r = await API.adminPatentes();
      let de = 1;
      // A tabela só tem ALUNO e PROFESSOR. A equipe joga pela escada de
      // aluno — é a que o servidor usa para contar o XP dela —, e sem
      // esta linha a lista saía vazia e a seção nunca aparecia.
      const escada = perfil.tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';

      faixas = (r.patentes || [])
        .filter(p => p.tipo === escada)
        .sort((a, b) => a.ate - b.ate)
        .map(p => { const f = { ...p, de }; de = p.ate + 1; return f; });
    } catch (_) {
      return;   // sem as patentes não há o que oferecer; a seção fica fora
    }

    if (!faixas.length) return;

    escolha.innerHTML =
      '<option value="">— escolher pela patente —</option>' +
      faixas.map(f => `<option value="${f.de}">${f.nome} · níveis ${f.de} a ${f.ate}</option>`).join('');

    // O nível de agora, para o campo não começar em branco.
    try {
      const u = await API.adminUsuario(perfil.id);
      const n = u.xp && u.xp.nivel ? u.xp.nivel.nivel : 1;
      campo.value = n;
      const atualFaixa = faixas.find(f => n >= f.de && n <= f.ate);
      if (atualFaixa) escolha.value = String(atualFaixa.de);
    } catch (_) {
      campo.value = 1;
    }

    escolha.addEventListener('change', () => {
      if (escolha.value) campo.value = escolha.value;
    });

    botao.addEventListener('click', async () => {
      const nivel = Number(campo.value);
      if (!(nivel >= 1 && nivel <= 100)) return dizer('O nível vai de 1 a 100.');

      botao.disabled = true;
      try {
        const r = await API.adminDefinirNivel(perfil.id, nivel);
        const patente = r.xp && r.xp.nivel ? r.xp.nivel.patente : '';
        dizer(patente ? `Agora: ${patente} · nível ${nivel}.` : `Nível ${nivel} aplicado.`, true);
        mostrarPatente(r.xp && r.xp.nivel, r.xp);
      } catch (err) {
        dizer(err.message || 'Não foi possível trocar a patente.');
      } finally {
        botao.disabled = false;
      }
    });

    bloco.hidden = false;
  }

  /* ── O cartão de cima ──────────────────────────────────────────── */

  function mostrarIdentidade(perfil) {
    desenharAvatar(document.getElementById('avatar-grande'), perfil.nome, perfil.avatar_url);

    // textContent: nome é texto escrito por pessoa, nunca código.
    escrever('dado-nome', perfil.nome || 'Sem nome');
    escrever('dado-tipo', ROTULO_TIPO[perfil.tipo] || perfil.tipo || '');

    subtitulo.textContent = perfil.tipo === 'PROFESSOR'
      ? 'Seus dados e suas turmas.'
      : 'Seus dados no jogo.';
  }

  /** Cartões de número: [{ valor, rotulo, nota, destaque }]. */
  /** Patente ao lado do tipo e a barra de nível. */
  function mostrarPatente(nivel, xp) {
    if (!nivel) return;

    const selo = document.getElementById('dado-patente');
    if (selo) {
      // Troca só a classe de cor do selo.
      for (const c of [...selo.classList]) {
        if (c.startsWith('patente-cor--')) selo.classList.remove(c);
      }
      if (nivel.faixa) selo.classList.add(`patente-cor--${nivel.faixa}`);

      escrever('dado-patente-txt', `${nivel.patente} · Nível ${nivel.nivel}`);
      selo.hidden = false;
    }

    if (window.NIVEL) window.NIVEL.atualizar(nivel, xp);
  }

  function mostrarNumeros(cartoes, titulo) {
    const bloco = document.getElementById('bloco-numeros');
    bloco.innerHTML = '';

    for (const c of cartoes) {
      const art = document.createElement('article');
      art.className = 'numero-card' + (c.destaque ? ' numero-card--xp' : '');
      // A terceira linha só aparece quando há nota.
      art.innerHTML = `
        <span class="numero-card__valor"></span>
        <span class="numero-card__rot"></span>` +
        (c.nota ? '<span class="numero-card__nota"></span>' : '');

      art.querySelector('.numero-card__valor').textContent = c.valor;
      art.querySelector('.numero-card__rot').textContent = c.rotulo;
      if (c.nota) art.querySelector('.numero-card__nota').textContent = c.nota;
      bloco.appendChild(art);
    }

    escrever('numeros-titulo', titulo);
    document.getElementById('titulo-numeros').hidden = false;
    bloco.hidden = false;
  }

  /** Estante resumida: conquistadas primeiro (até oito). */
  async function mostrarEstante() {
    let dados;
    try { dados = await API.getMinhaEstante(); } catch (_) { return; }

    const lista = dados.insignias || [];
    if (!lista.length) return;

    const ordem = [...lista].sort((a, b) =>
      (b.conquistada - a.conquistada) || (b.porcentagem - a.porcentagem));

    const estante = document.getElementById('estante');
    estante.innerHTML = '';

    for (const i of ordem.slice(0, 8)) {
      const item = document.createElement('article');
      item.className = `insignia insignia--${i.conquistada ? 'feita' : 'presa'}`;
      item.style.setProperty('--pct', i.porcentagem);
      item.innerHTML = `<div class="insignia__disco"><span class="insignia__arte"></span></div>
                        <h4 class="insignia__nome"></h4>`;

      const arte = item.querySelector('.insignia__arte');
      if (i.imagem) {
        const img = document.createElement('img');
        img.src = '../imgs/insignias/' + i.imagem;
        img.alt = '';
        arte.appendChild(img);
      } else {
        arte.textContent = (i.nome || '?').charAt(0).toUpperCase();
        arte.classList.add('insignia__arte--letra');
      }

      item.querySelector('.insignia__nome').textContent = i.nome;
      item.title = i.descricao;
      estante.appendChild(item);
    }

    escrever('estante-resumo', dados.conquistadas
      ? `${dados.conquistadas} de ${dados.total} conquistadas.`
      : `Nenhuma ainda — são ${dados.total} esperando.`);

    document.getElementById('titulo-estante').hidden = false;
    document.getElementById('bloco-estante').hidden = false;
  }

  async function comoAluno(perfil) {
    const faixa = FAIXAS.find(f => perfil.idade <= f.ate);

    if (perfil.idade) {
      linha('Idade', `${perfil.idade} anos`);
      // O "por quê" junto do dado: sem isso o número é só um número, e a
      // pessoa não liga a idade ao conteúdo que aparece para ela.
      if (faixa) linha('Faixa do conteúdo', `Nível ${faixa.nivel} — missões de ${faixa.texto}`);
    }

    const { turma, posicao, estatisticas } = await API.getMeuResumo();

    if (turma) {
      linha('Turma', turma.ano_escolar ? `${turma.nome} · ${turma.ano_escolar}` : turma.nome);
      if (turma.professor) linha('Professor', turma.professor);

      // Posição só faz sentido com colega: "1º de 1" não é conquista.
      if (posicao && posicao.total > 1) {
        linha('Na turma', `${posicao.lugar}º de ${posicao.total}`);
      }
    } else {
      linha('Turma', 'ainda não entrou em nenhuma');
    }

    const e = estatisticas || {};
    mostrarPatente(e.nivel, e.xp);

    mostrarNumeros([
      { valor: (e.xp || 0).toLocaleString('pt-BR'), rotulo: 'XP acumulado', destaque: true,
        nota: e.acertos_unicos ? `${e.acertos_unicos} ${plural(e.acertos_unicos, 'pergunta nova', 'perguntas novas')}` : 'cada pergunta nova vale 10' },

      { valor: e.missoes_concluidas ?? 0, rotulo: 'missões concluídas',
        nota: e.missoes_totais ? `de ${e.missoes_totais} que seu professor passou` : 'nenhuma tarefa passada ainda' },

      { valor: e.streak_dias ? `${e.streak_dias} ${plural(e.streak_dias, 'dia', 'dias')}` : '—', rotulo: 'de sequência',
        nota: e.jogou_hoje ? 'você jogou hoje' : 'jogue hoje para continuar' },

      { valor: e.taxa === null || e.taxa === undefined ? '—' : `${e.taxa}%`, rotulo: 'de acerto',
        nota: e.respostas ? `${e.acertos} de ${e.respostas} ${plural(e.respostas, 'resposta', 'respostas')}` : 'assim que você responder a primeira' }
    ], 'Seus números');

    document.getElementById('atalhos').hidden = false;
    await mostrarEstante();
  }

  /** Números do professor (o XP dele vem da turma). */
  async function comoProfessor(perfil) {
    let turmas = [];
    try { turmas = await API.getMinhasTurmas(); } catch (_) { /* segue sem a contagem */ }

    const alunos = turmas.reduce((s, t) => s + (t.total_alunos || 0), 0);

    linha('Turmas', turmas.length
      ? `${turmas.length} ${turmas.length === 1 ? 'turma' : 'turmas'}`
      : 'nenhuma turma criada ainda');
    if (alunos) linha('Alunos', `${alunos} ${alunos === 1 ? 'aluno' : 'alunos'} no total`);

    let e = {};
    try {
      const r = await API.getMeuResumo();
      e = r.estatisticas || {};
    } catch (_) { /* segue com o que já há em tela */ }

    mostrarPatente(e.nivel, e.xp);

    // Um fato por cartão, sem a linha apagada embaixo. O que era dito no
    // sussurro ("em 4 quizzes criados", "entre 4 alunos") virou cartão
    // próprio: se o número importa, ele merece um rótulo.
    mostrarNumeros([
      { valor: (e.xp || 0).toLocaleString('pt-BR'), rotulo: 'XP acumulado', destaque: true },
      { valor: e.quizzes_criados ?? 0, rotulo: plural(e.quizzes_criados ?? 0, 'quiz criado', 'quizzes criados') },
      { valor: e.conclusoes ?? 0, rotulo: plural(e.conclusoes ?? 0, 'tarefa concluída', 'tarefas concluídas') },
      { valor: e.taxa_media === null || e.taxa_media === undefined ? '—' : `${e.taxa_media}%`,
        rotulo: 'a turma acerta de primeira' },
      { valor: e.acertos_da_turma ?? 0, rotulo: 'acertos dos alunos' },
      { valor: alunos, rotulo: plural(alunos, 'aluno na turma', 'alunos nas turmas') }
    ], 'Suas turmas');

    await mostrarEstante();
  }



  /* ── Editar ────────────────────────────────────────────────────── */

  /** Editor de perfil: abre preenchido, fecha e salva. */
  function ligarEditor() {
    const editor = document.getElementById('editor');
    const form = document.getElementById('form-perfil');
    const campoNome = document.getElementById('campo-nome');
    const campoFoto = document.getElementById('campo-foto');
    const campoArquivo = document.getElementById('campo-arquivo');
    const previa = document.getElementById('previa');
    const aviso = document.getElementById('editor-aviso');
    const estado = document.getElementById('foto-estado');
    const btnTirar = document.getElementById('btn-tirar');
    const salvar = document.getElementById('btn-salvar');

    // Foto escolhida do computador (null = vale o endereço).
    let arquivoEscolhido = null;

    const fotoAtual = () => arquivoEscolhido || campoFoto.value.trim();

    const abrir = (sim) => {
      editor.hidden = !sim;
      if (!sim) return;

      campoNome.value = atual.nome || '';

      // Foto embutida volta como "arquivo escolhido".
      const foto = atual.avatar_url || '';
      arquivoEscolhido = foto.startsWith('data:') ? foto : null;
      campoFoto.value = arquivoEscolhido ? '' : foto;

      aviso.hidden = true;
      atualizarPrevia();
      campoNome.focus();
    };

    const atualizarPrevia = () => {
      desenharAvatar(previa, campoNome.value || atual.nome, fotoAtual());
      btnTirar.hidden = !fotoAtual();
    };

    document.getElementById('btn-editar').addEventListener('click', () => abrir(editor.hidden));
    document.getElementById('btn-cancelar').addEventListener('click', () => abrir(false));

    campoNome.addEventListener('input', atualizarPrevia);

    // Digitar um endereço descarta o arquivo.
    campoFoto.addEventListener('input', () => {
      if (campoFoto.value.trim()) arquivoEscolhido = null;
      atualizarPrevia();
    });

    document.getElementById('btn-escolher').addEventListener('click', () => campoArquivo.click());

    document.getElementById('btn-tirar').addEventListener('click', () => {
      arquivoEscolhido = null;
      campoFoto.value = '';
      campoArquivo.value = '';
      estado.textContent = 'Sem foto — suas iniciais aparecem no lugar.';
      atualizarPrevia();
    });

    campoArquivo.addEventListener('change', async () => {
      const arquivo = campoArquivo.files?.[0];
      if (!arquivo) return;

      estado.textContent = 'Preparando a imagem…';

      try {
        arquivoEscolhido = await reduzir(arquivo);
        campoFoto.value = '';
        estado.textContent = `${arquivo.name} · pronta para salvar`;
        atualizarPrevia();
      } catch (err) {
        arquivoEscolhido = null;
        estado.textContent = 'Não consegui ler esse arquivo. Tente uma imagem JPEG, PNG ou WEBP.';
        atualizarPrevia();
      }
    });

    form.addEventListener('submit', async (ev) => {
      ev.preventDefault();

      const nome = campoNome.value.trim().replace(/\s+/g, ' ');
      const foto = fotoAtual();

      if (nome.length < 2) return reclamar(aviso, 'Escreva um nome com pelo menos 2 letras.');
      if (foto && !foto.startsWith('data:') && !/^https:\/\//i.test(foto)) {
        return reclamar(aviso, 'O endereço da imagem precisa começar com https://');
      }

      salvar.disabled = true;
      aviso.hidden = true;

      try {
        const salvo = await API.salvarMeuPerfil({ nome, avatar_url: foto });

        atual = { ...atual, ...salvo };
        mostrarIdentidade(atual);
        abrir(false);

        // Recarrega para a barra mostrar o nome e a foto novos.
        window.location.reload();

      } catch (err) {
        reclamar(aviso, err.message);
      } finally {
        salvar.disabled = false;
      }
    });
  }

  function reclamar(onde, mensagem) {
    onde.textContent = mensagem;
    onde.hidden = false;
  }

  /** Reduz a foto a 192×192 (recorte quadrado central) antes de salvar. */
  const LADO = 192;
  const QUALIDADE = 0.82;

  function reduzir(arquivo) {
    return new Promise((resolve, reject) => {
      if (!/^image\//.test(arquivo.type)) return reject(new Error('não é imagem'));

      const url = URL.createObjectURL(arquivo);
      const img = new Image();

      img.onload = () => {
        URL.revokeObjectURL(url);

        try {
          const tela = document.createElement('canvas');
          tela.width = tela.height = LADO;
          const pincel = tela.getContext('2d');

          // O maior quadrado que cabe na foto, pelo meio dela.
          const lado = Math.min(img.width, img.height);
          const x = (img.width - lado) / 2;
          const y = (img.height - lado) / 2;

          pincel.drawImage(img, x, y, lado, lado, 0, 0, LADO, LADO);

          // JPEG (menor que PNG para foto).
          resolve(tela.toDataURL('image/jpeg', QUALIDADE));
        } catch (err) {
          reject(err);
        }
      };

      img.onerror = () => {
        URL.revokeObjectURL(url);
        reject(new Error('não consegui abrir'));
      };

      img.src = url;
    });
  }

  /* ── Utilidades ────────────────────────────────────────────────── */

  /** Foto ou iniciais (onerror volta às iniciais). */
  function desenharAvatar(alvo, nome, url) {
    if (!alvo) return;

    alvo.innerHTML = '';
    alvo.classList.remove('cartao-perfil__avatar--foto');

    if (!url) {
      alvo.textContent = iniciais(nome);
      return;
    }

    const img = document.createElement('img');
    img.src = url;
    img.alt = '';
    img.onerror = () => {
      alvo.innerHTML = '';
      alvo.classList.remove('cartao-perfil__avatar--foto');
      alvo.textContent = iniciais(nome);
    };

    alvo.classList.add('cartao-perfil__avatar--foto');
    alvo.appendChild(img);
  }

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
