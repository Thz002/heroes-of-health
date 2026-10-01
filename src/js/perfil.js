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
