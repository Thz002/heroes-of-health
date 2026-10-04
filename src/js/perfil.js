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

  // Guardado para o formulário saber de onde partiu e para o Cancelar
  // conseguir desfazer sem recarregar a página.
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

    try {
      if (perfil.tipo === 'PROFESSOR') await comoProfessor(perfil);
      else await comoAluno(perfil);
    } catch (err) {
      mostrarErro(err.message);
    }
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

  /**
   * Os cartões de número.
   *
   * `cartoes` é uma lista de { valor, rotulo, nota, destaque } e o
   * primeiro costuma ser o XP. Montar por lista em vez de deixar quatro
   * <article> fixos no HTML é o que permite o aluno e o professor terem
   * números diferentes sem duplicar a tela — eles medem coisas que não
   * se parecem.
   */
  /**
   * A patente ao lado de ALUNO / PROFESSOR, e a barra de nível.
   *
   * A patente é IDENTIDADE, não estatística: "Pequeno Aprendiz" é o que
   * a pessoa é dentro do jogo, do mesmo jeito que "Aluno" é. Por isso
   * fica junto do nome, e não perdida entre os números lá embaixo.
   *
   * A barra também é preenchida aqui, com o nível que esta tela já
   * buscou. O navbar.js preenche toda <div data-nivel> quando a
   * presença do dia volta, mas depender só disso deixava a barra vazia
   * se aquela chamada demorasse ou falhasse — e é a tela de perfil,
   * justamente onde a pessoa vai procurar o próprio nível.
   */
  function mostrarPatente(nivel, xp) {
    if (!nivel) return;

    const selo = document.getElementById('dado-patente');
    if (selo) {
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
      // A terceira linha só existe quando há algo a dizer. Um cartão com
      // uma frase apagada embaixo pesa a tela sem informar nada.
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

  /**
   * A estante resumida: as já conquistadas primeiro, depois as próximas
   * a cair. Mostra oito — o suficiente para a pessoa ver que existe uma
   * estante, sem repetir a página inteira de conquistas.
   */
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
      if (turma.escola) linha('Escola', turma.escola);
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

  /**
   * O professor mede outra coisa.
   *
   * O XP dele vem inteiro da turma — por isso os cartões falam de
   * turmas, de tarefas concluídas e de com quanta facilidade a turma
   * chega lá. "Quizzes criados" aparece como contexto, e não como
   * conquista: criar tarefa não dá mais XP, porque tarefa que ninguém
   * faz não ensinou ninguém.
   */
  async function comoProfessor(perfil) {
    let turmas = [];
    try { turmas = await API.getMinhasTurmas(); } catch (_) { /* segue sem a contagem */ }

    const escola = await nomeDaEscola(perfil.escola_id);
    if (escola) linha('Escola', escola);

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


  /* ── Editar ────────────────────────────────────────────────────── */

  /**
   * Abre, fecha e salva.
   *
   * O formulário nasce preenchido com o que já existe: um campo de nome
   * vazio faria a pessoa achar que vai APAGAR o nome, e não mudá-lo.
   */
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

    // A foto escolhida do computador, já reduzida. Enquanto for null, a
    // foto que vale é a do campo de endereço.
    let arquivoEscolhido = null;

    const fotoAtual = () => arquivoEscolhido || campoFoto.value.trim();

    const abrir = (sim) => {
      editor.hidden = !sim;
      if (!sim) return;

      campoNome.value = atual.nome || '';

      // Foto embutida não cabe no campo de endereço — ela já é a imagem
      // inteira. Volta como "arquivo escolhido", que é o que ela é.
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

    // Digitar um endereço descarta o arquivo: são duas fontes para a
    // mesma foto, e a última escolha é a que vale.
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

        // A barra de cima tem o mesmo avatar e o mesmo nome. Redesenhar
        // aqui seria copiar a regra do navbar.js para dentro desta tela;
        // recarregar deixa uma fonte só de verdade.
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

  /**
   * Transforma o arquivo escolhido numa imagem pequena, pronta para
   * caber numa coluna de texto do banco.
   *
   * POR QUE REDUZIR, E NÃO MANDAR O ARQUIVO: a foto vai inteira para
   * `usuarios.avatar_url`, que é lida em TODA navegação para desenhar o
   * avatar da barra. Uma foto de celular tem 3 ou 4 MB — isso viajaria
   * em cada troca de página. Reduzida para 192 pixels e em JPEG, ela
   * fica em uns 15 KB, que é o tamanho de um ícone.
   *
   * 192 e não 76 (o tamanho em tela) por causa das telas retina, que
   * desenham o dobro de pixels, e para a foto não ficar borrada se o
   * avatar crescer algum dia.
   *
   * O recorte é QUADRADO E CENTRAL: o avatar é um círculo, e uma foto
   * retangular esticada para caber deforma o rosto da pessoa.
   */
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

          // JPEG e não PNG: para fotografia o PNG sai várias vezes maior
          // sem ganho visível. Perde a transparência, que um avatar
          // recortado em círculo não usa.
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

  /**
   * Desenha foto ou iniciais no mesmo lugar.
   *
   * Se a imagem não carregar — endereço quebrado, site fora do ar, link
   * que não era de imagem — o onerror devolve as iniciais. Sem isso a
   * pessoa ficaria com um quadrado vazio e nenhuma pista do motivo.
   */
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
