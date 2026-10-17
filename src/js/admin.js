/** admin.js — painel da equipe (admin.html). As travas de verdade ficam no servidor. */

(() => {
  'use strict';

  const $ = (id) => document.getElementById(id);
  const aviso = $('adm-aviso');

  let eu = null;   // o perfil de quem está usando o painel

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    const perfil = await AUTH.perfilAtual();

    // Esconde a tela de quem não é admin (a trava real é o 403 do servidor).
    if (!perfil || perfil.tipo !== 'ADMIN') {
      document.querySelector('.adm').innerHTML =
        '<p class="vazio">Esta área é da equipe do projeto.</p>';
      return;
    }

    eu = perfil;

    ligarAbas();
    carregarPanorama();
    ligarBusca();

    // Atalho para abrir a própria ficha.
    $('busca-eu').addEventListener('click', () => {
      document.querySelector('.adm__aba[data-aba="usuarios"]').click();
      abrirFicha(perfil.id, false, 'editar');
    });
  }

  // ── Avisos ────────────────────────────────────────────────────────
  /** Mostra o aviso no modal aberto, se houver. */
  const ondeAvisar = () => $('modal-aviso') || aviso;

  function dizer(texto, tipo = 'ok') {
    const onde = ondeAvisar();
    onde.textContent = texto;
    onde.className = `aviso mostrar aviso--${tipo}`;
    if (tipo === 'ok') setTimeout(() => onde.classList.remove('mostrar'), 4000);
    onde.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
  }

  const esconderAviso = () => ondeAvisar().classList.remove('mostrar');

  /** Envolve uma ação para o erro do servidor virar aviso na tela. */
  async function tentar(fn, sucesso) {
    try {
      const r = await fn();
      if (sucesso) dizer(typeof sucesso === 'function' ? sucesso(r) : sucesso, 'ok');
      return r;
    } catch (erro) {
      dizer(erro.message || 'Não foi possível completar.', 'err');
      return null;
    }
  }

  // ── Abas ──────────────────────────────────────────────────────────
  function ligarAbas() {
    const abas = Array.from(document.querySelectorAll('.adm__aba'));

    abas.forEach((aba) => {
      aba.addEventListener('click', () => {
        abas.forEach(a => a.setAttribute('aria-selected', String(a === aba)));
        document.querySelectorAll('[data-painel]').forEach(p => {
          p.hidden = p.dataset.painel !== aba.dataset.aba;
        });
        esconderAviso();

        if (aba.dataset.aba === 'professores') carregarProfessores();
        if (aba.dataset.aba === 'patentes') carregarPatentes();
      });
    });
  }

  // ── Panorama ──────────────────────────────────────────────────────
  async function carregarPanorama() {
    const r = await tentar(() => API.adminResumo());

    // Se o resumo falhar, o subtítulo avisa.
    if (!r) {
      $('adm-sub').textContent = 'Não foi possível carregar o resumo. Veja o terminal do servidor.';
      return;
    }

    $('adm-sub').textContent =
      `${r.usuarios.total} contas · ${r.turmas} turmas · ${r.questoes} questões no banco`;

    const cartoes = [
      ['Alunos', r.usuarios.ALUNO],
      ['Professores', r.usuarios.PROFESSOR],
      ['Equipe', r.usuarios.ADMIN],
      ['Suspensos', r.usuarios.suspensos],
      ['Ativos (7 dias)', r.ativos_7d],
      ['Turmas', r.turmas],
      ['Quizes criados', r.quizzes],
      ['Quizes concluídos', r.conclusoes],
      ['Respostas', r.respostas.total],
      ['Taxa de acerto', `${r.respostas.taxa}%`],
    ];

    $('panorama-numeros').innerHTML = cartoes.map(([rot, val]) => `
      <div class="num">
        <div class="num__valor">${val}</div>
        <div class="num__rot">${rot}</div>
      </div>`).join('');
  }

  // ── Busca ── a aba abre vazia.
  let jaProcurou = false;

  function ligarBusca() {
    const campo = $('busca-q');
    const tipo = $('busca-tipo');

    const procurar = async () => {
      const termo = campo.value.trim();

      // Nem texto nem filtro: não é busca, é a tela em repouso.
      if (!termo && !tipo.value) {
        jaProcurou = false;
        convite();
        return;
      }

      const r = await tentar(() => API.adminUsuarios(termo, tipo.value));
      if (r) { jaProcurou = true; desenharLista(r); }
    };

    $('busca-btn').addEventListener('click', procurar);
    campo.addEventListener('keydown', (e) => { if (e.key === 'Enter') procurar(); });
    tipo.addEventListener('change', procurar);

    convite();
  }

  function convite() {
    $('busca-lista').innerHTML =
      '<p class="vazio">Pesquise por um usuário — nome, e-mail ou o id do Supabase.</p>';
  }

  /** Refaz a última busca. Sem busca feita, não há o que refazer. */
  const reprocurar = () => { if (jaProcurou) $('busca-btn').click(); };

  function desenharLista(lista) {
    const caixa = $('busca-lista');

    if (!lista.length) {
      caixa.innerHTML = '<p class="vazio">Ninguém com esse termo. Vale tentar o e-mail inteiro, ou o id do Supabase.</p>';
      return;
    }

    caixa.innerHTML = lista.map(u => `
      <button class="fichinha" type="button" data-id="${u.id}">
        <span class="fichinha__foto">${foto(u)}</span>
        <span class="fichinha__meio">
          <span class="fichinha__linha">
            ${etiqueta(u.nivel, true)}
            <span class="fichinha__nome">${escapar(u.nome)}</span>
          </span>
          <span class="fichinha__sub">${escapar(u.email || 'sem e-mail')}</span>
        </span>
        <span class="etiq etiq--${u.tipo}">${u.tipo}</span>
        ${u.suspenso ? '<span class="etiq etiq--susp">susp</span>' : ''}
      </button>`).join('');

    caixa.querySelectorAll('.fichinha').forEach(c => {
      c.addEventListener('click', () => abrirFicha(c.dataset.id));
    });
  }

  // ── Ficha em modal ── ver, alterar, punir e apagar.

  let porta = 'ver';          // qual das quatro está escolhida
  let patentesCache = null;

  /** As faixas de patente do tipo, em ordem, já com o nível em que começam. */
  async function faixasDe(tipo) {
    if (!patentesCache) {
      try { patentesCache = (await API.adminPatentes()).patentes || []; }
      catch (_) { patentesCache = []; }
    }

    // Só existem faixas de ALUNO e de PROFESSOR. A equipe entra pela
    // de aluno, que é a que o servidor usa para contar o XP dela.
    const escada = tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';
    const minhas = patentesCache.filter(p => p.tipo === escada).sort((a, b) => a.ate - b.ate);
    let de = 1;
    return minhas.map(p => { const faixa = { ...p, de }; de = p.ate + 1; return faixa; });
  }

  async function abrirFicha(id, mesmaPorta = false, portaInicial = null) {
    const u = await tentar(() => API.adminUsuario(id));
    if (!u) return;

    if (portaInicial) porta = portaInicial;
    else if (!mesmaPorta) porta = 'ver';
    desenharModal(u, await faixasDe(u.tipo));
  }

  function fecharModal() {
    $('modal-lugar').innerHTML = '';
    document.removeEventListener('keydown', escFecha);
  }

  const escFecha = (e) => { if (e.key === 'Escape') fecharModal(); };

  function desenharModal(u, faixas) {
    const xp = u.xp || {};
    const nivel = xp.nivel || {};

    $('modal-lugar').innerHTML = `
      <div class="modal" id="modal-fundo">
        <div class="modal__caixa" role="dialog" aria-modal="true" aria-label="Ficha de ${escapar(u.nome)}">

          <div class="modal__topo">
            <div class="fichinha__foto" style="width:52px;height:52px;font-size:18px">${foto(u)}</div>
            <div style="min-width:0">
              <div class="patente-linha" style="margin-bottom:4px">
                ${etiqueta(nivel)}
                <h2 class="ficha__nome patente-nome" style="margin:0">${escapar(u.nome)}</h2>
                ${eu && u.id === eu.id ? '<span class="ficha__email">(você)</span>' : ''}
              </div>
              <p class="ficha__email">${escapar(u.email || 'sem e-mail')}</p>
              <p class="ficha__email" style="margin-top:4px">
                <span class="etiq etiq--${u.tipo}">${u.tipo}</span>
                ${u.suspenso ? '<span class="etiq etiq--susp">suspenso</span>' : ''}
              </p>
            </div>
            <button class="modal__fechar" id="modal-x" aria-label="Fechar">✕</button>
          </div>

          <div class="aviso" id="modal-aviso" role="alert"></div>

          <div class="modal__portas">
            ${botaoPorta('ver', 'Acessar perfil', 'Só olhar, sem mexer')}
            ${botaoPorta('editar', 'Alterar informações', 'Nome, senha, patente, papel')}
            ${botaoPorta('punir', u.suspenso ? 'Reativar conta' : 'Punir', u.suspenso ? 'Devolver o acesso' : 'Tirar o acesso ao jogo')}
            ${botaoPorta('excluir', 'Excluir usuário', 'Apaga tudo, sem volta', true)}
          </div>

          <div class="painel" id="modal-painel"></div>
        </div>
      </div>`;

    $('modal-x').addEventListener('click', fecharModal);
    $('modal-fundo').addEventListener('mousedown', (e) => {
      if (e.target.id === 'modal-fundo') fecharModal();   // clicar fora fecha
    });
    document.addEventListener('keydown', escFecha);

    document.querySelectorAll('[data-porta]').forEach(b => {
      b.addEventListener('click', () => {
        porta = b.dataset.porta;
        document.querySelectorAll('[data-porta]').forEach(o =>
          o.setAttribute('aria-pressed', String(o.dataset.porta === porta)));
        esconderAviso();
        desenharPainel(u, faixas, nivel, xp);
      });
    });

    desenharPainel(u, faixas, nivel, xp);
  }

  function botaoPorta(chave, titulo, sub, perigo = false) {
    return `<button class="porta${perigo ? ' porta--perigo' : ''}" type="button"
              data-porta="${chave}" aria-pressed="${porta === chave}">
              ${titulo}<small>${sub}</small></button>`;
  }

  function desenharPainel(u, faixas, nivel, xp) {
    const alvo = $('modal-painel');

    if (porta === 'ver') {
      alvo.innerHTML = `
        <div class="ficha__grade">
          <div class="ficha__item"><div class="ficha__rot">XP total</div>
            <div class="ficha__val">${xp.total ?? '—'}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Nível</div>
            <div class="ficha__val">${nivel.nivel ?? '—'}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Patente</div>
            <div class="ficha__val" style="font-size:13px">${etiqueta(nivel) || '—'}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Acertos</div>
            <div class="ficha__val">${xp.acertos_unicos ?? 0}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Ajustes à mão</div>
            <div class="ficha__val">${xp.de_ajustes ?? 0}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Último acesso</div>
            <div class="ficha__val" style="font-size:12px">${data(u.ultimo_login)}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Turma</div>
            <div class="ficha__val" style="font-size:13px">${escapar(u.turma_nome || '—')}</div></div>
          <div class="ficha__item"><div class="ficha__rot">Idade</div>
            <div class="ficha__val">${u.idade ?? '—'}</div></div>
        </div>
        <p class="ficha__email" style="margin-top:14px">id · ${escapar(u.id)}</p>
        ${u.suspenso ? `<p class="ficha__email" style="margin-top:6px;color:#ff8080">
           Suspensa em ${data(u.suspenso_em)}${u.suspenso_motivo ? ` — ${escapar(u.suspenso_motivo)}` : ''}</p>` : ''}`;
      return;
    }

    if (porta === 'editar') {
      alvo.innerHTML = `
        <div class="ficha__bloco">
          <div style="flex:1"><label for="m-nome">Nome</label>
            <input class="adm__campo" id="m-nome" type="text" maxlength="80" value="${escapar(u.nome)}"></div>
          <button class="bt bt--acao" id="m-nome-btn">Salvar nome</button>
        </div>

        <div class="ficha__bloco">
          <div style="flex:1"><label for="m-patente">Patente</label>
            <select class="adm__campo" id="m-patente" style="width:100%">
              <option value="">— escolher pela patente —</option>
              ${faixas.map(f => `<option value="${f.de}"${nivel.nivel >= f.de && nivel.nivel <= f.ate ? ' selected' : ''}
                >${escapar(f.nome)} · níveis ${f.de} a ${f.ate}</option>`).join('')}
            </select></div>
          <div><label for="m-nivel">Nível</label>
            <input class="adm__campo" id="m-nivel" type="number" min="1" max="100"
                   value="${nivel.nivel || 1}" style="width:96px"></div>
          <button class="bt bt--acao" id="m-nivel-btn">Aplicar</button>
        </div>
        <p class="ficha__email" style="margin:-4px 0 4px">
          A patente vem do nível, e não o contrário. Escolher uma aqui leva
          a pessoa ao primeiro nível da faixa; o campo ao lado afina depois.</p>

        <div class="ficha__bloco">
          <div><label for="m-xp">Somar ou tirar XP</label>
            <input class="adm__campo" id="m-xp" type="number" placeholder="250 ou -100" style="width:120px"></div>
          <div style="flex:1"><label for="m-motivo">Motivo (fica registrado)</label>
            <input class="adm__campo" id="m-motivo" type="text" maxlength="200" placeholder="Por que este ajuste?"></div>
          <button class="bt" id="m-xp-btn">Aplicar</button>
        </div>

        <div class="ficha__bloco">
          <div style="flex:1"><label for="m-tipo">Papel</label>
            <select class="adm__campo" id="m-tipo" style="width:100%">
              <option value="ALUNO"     ${u.tipo === 'ALUNO' ? 'selected' : ''}>Aluno</option>
              <option value="PROFESSOR" ${u.tipo === 'PROFESSOR' ? 'selected' : ''}>Professor</option>
              <option value="ADMIN"     ${u.tipo === 'ADMIN' ? 'selected' : ''}>Equipe</option>
            </select></div>
          <button class="bt" id="m-tipo-btn">Trocar papel</button>
        </div>

        <div class="ficha__bloco">
          <div style="flex:1"><label for="m-senha">Nova senha</label>
            <input class="adm__campo" id="m-senha" type="text" minlength="6" maxlength="72"
                   autocomplete="off" placeholder="Pelo menos 6 caracteres"></div>
          <button class="bt bt--perigo" id="m-senha-btn">Definir</button>
          <button class="bt" id="m-codigo-btn">Enviar código por e-mail</button>
        </div>
        <p class="ficha__email" style="margin-top:-4px">
          Enviar o código é o caminho normal: a senha continua sendo só da
          pessoa. Definir aqui serve à criança que esqueceu a senha e não
          tem e-mail aberto na escola — depois disso você sabe a senha dela,
          e o sistema não distingue mais um acesso seu de um acesso dela.</p>`;

      ligarEditar(u);
      return;
    }

    if (porta === 'punir') {
      alvo.innerHTML = u.suspenso ? `
        <p style="font-size:13.5px;color:var(--text-muted);line-height:1.6">
          A conta está suspensa${u.suspenso_motivo ? ` — <strong>${escapar(u.suspenso_motivo)}</strong>` : ''},
          desde ${data(u.suspenso_em)}. Reativar devolve o acesso na hora;
          nada do progresso se perdeu nesse meio-tempo.</p>
        <div class="ficha__acoes" style="margin-top:14px">
          <button class="bt bt--acao" id="m-reativar">Reativar a conta</button>
        </div>`
      : `
        <p style="font-size:13.5px;color:var(--text-muted);line-height:1.6">
          Suspender tranca a conta: a pessoa ainda consegue entrar, mas
          qualquer tela do jogo responde com o motivo que você escrever
          aqui. O progresso fica intacto e volta inteiro ao reativar.</p>

        <label for="m-punir-motivo">Motivo (a pessoa lê este texto)</label>
        <input class="adm__campo" id="m-punir-motivo" type="text" maxlength="200"
               placeholder="Ex: uso indevido do quiz da turma" style="width:100%">

        <div class="ficha__acoes" style="margin-top:14px">
          <button class="bt bt--perigo" id="m-punir">Suspender a conta</button>
        </div>

        <p class="ficha__email" style="margin-top:16px;line-height:1.6">
          <strong>Sobre bloquear o IP:</strong> a escola inteira sai pelo
          mesmo IP público, então bloquear um aluno bloquearia a sala toda —
          e no celular o IP troca sozinho em minutos. Fora isso, o sistema
          não guarda IP de ninguém hoje, e passar a guardar seria começar a
          registrar dado pessoal de criança. A conta é o que identifica a
          pessoa de verdade, e é o que esta tela tranca.</p>`;

      ligarPunir(u);
      return;
    }

    // excluir
    alvo.innerHTML = `
      <p style="font-size:13.5px;color:var(--text-muted);line-height:1.6">
        Apagar remove o login, o perfil, o progresso, as respostas e o
        paciente virtual de <strong>${escapar(u.nome)}</strong>. Não há
        cópia e não há como desfazer. Se a ideia é só tirar o acesso,
        suspender resolve e guarda tudo.</p>

      <label for="m-apagar-nome">Para confirmar, digite o nome exatamente como está acima</label>
      <input class="adm__campo" id="m-apagar-nome" type="text" autocomplete="off" style="width:100%">

      <div class="ficha__acoes" style="margin-top:14px">
        <button class="bt bt--perigo" id="m-apagar">Apagar para sempre</button>
      </div>`;

    $('m-apagar').addEventListener('click', async () => {
      if ($('m-apagar-nome').value.trim() !== u.nome) {
        return dizer('O nome não bateu. Nada foi apagado.', 'err');
      }
      const r = await tentar(() => API.adminApagar(u.id), (x) => x.message);
      if (r) { fecharModal(); reprocurar(); carregarPanorama(); }
    });
  }

  // ── As ações da porta "Alterar informações" ───────────────────────
  function ligarEditar(u) {
    const id = u.id;

    $('m-nome-btn').addEventListener('click', async () => {
      const nome = $('m-nome').value.trim();
      if (nome.length < 2) return dizer('O nome ficou curto demais.', 'err');
      if (nome === u.nome) return dizer('O nome já é esse.', 'err');

      const r = await tentar(() => API.adminAlterar(id, { nome }), 'Nome trocado.');
      if (r) { abrirFicha(id, true); reprocurar(); }
    });

    // A patente só preenche o nível; quem aplica é o botão.
    $('m-patente').addEventListener('change', (e) => {
      if (e.target.value) $('m-nivel').value = e.target.value;
    });

    $('m-nivel-btn').addEventListener('click', async () => {
      const nivel = Number($('m-nivel').value);
      if (!(nivel >= 1 && nivel <= 100)) return dizer('O nível vai de 1 a 100.', 'err');

      const r = await tentar(() => API.adminDefinirNivel(id, nivel), (x) => {
        const patente = x.xp && x.xp.nivel ? x.xp.nivel.patente : '';
        return patente ? `Nível ${nivel} — ${patente}.` : `Nível ${nivel} aplicado.`;
      });
      if (r) abrirFicha(id, true);
    });

    $('m-xp-btn').addEventListener('click', async () => {
      const pontos = Number($('m-xp').value);
      const motivo = $('m-motivo').value.trim();
      if (!pontos) return dizer('Informe quantos pontos somar ou tirar.', 'err');
      if (!motivo) return dizer('Escreva o motivo — ele fica registrado.', 'err');

      const r = await tentar(() => API.adminAjustarXp(id, pontos, motivo),
        `${pontos > 0 ? '+' : ''}${pontos} XP aplicados.`);
      if (r) abrirFicha(id, true);
    });

    $('m-tipo-btn').addEventListener('click', async () => {
      const tipo = $('m-tipo').value;
      if (tipo === u.tipo) return dizer('Já é esse o papel.', 'err');
      if (!confirm(`Trocar o papel de ${u.nome} para ${tipo}?`)) return;

      const r = await tentar(() => API.adminAlterar(id, { tipo }), `Agora é ${tipo}.`);
      // O papel muda a lista de patentes possíveis; o cache precisa cair.
      if (r) { patentesCache = null; abrirFicha(id, true); reprocurar(); }
    });

    $('m-senha-btn').addEventListener('click', async () => {
      const senha = $('m-senha').value;
      if (senha.length < 6) return dizer('A senha precisa de pelo menos 6 caracteres.', 'err');
      if (!confirm(`Definir a senha de ${u.nome} como "${senha}"?\n\nDepois disto você conhece a senha dela.`)) return;

      const r = await tentar(() => API.adminDefinirSenha(id, senha), (x) => x.message);
      if (r) $('m-senha').value = '';
    });

    $('m-codigo-btn').addEventListener('click', async () => {
      if (!u.email) return dizer('Esta conta não tem e-mail para onde mandar.', 'err');
      if (!confirm(`Enviar um código de recuperação para ${u.email}?`)) return;
      await tentar(() => API.adminRecuperarSenha(id), (r) => r.message);
    });
  }

  // ── A porta "Punir" ───────────────────────────────────────────────
  function ligarPunir(u) {
    const botao = $('m-punir') || $('m-reativar');

    botao.addEventListener('click', async () => {
      const suspender = !u.suspenso;
      const motivo = suspender ? $('m-punir-motivo').value.trim() : '';

      if (suspender && !motivo) {
        return dizer('Escreva o motivo — é o que a pessoa vai ler.', 'err');
      }
      if (suspender && !confirm(`Suspender a conta de ${u.nome}?`)) return;

      const r = await tentar(() => API.adminAlterar(u.id, { suspenso: suspender, motivo }),
        suspender ? 'Conta suspensa.' : 'Conta reativada.');
      if (r) { abrirFicha(u.id, true); reprocurar(); carregarPanorama(); }
    });
  }

  // ── Professores ───────────────────────────────────────────────────
  async function carregarProfessores() {
    const r = await tentar(() => API.adminProfessores());
    if (!r) return;

    $('prof-lista').innerHTML = r.length ? r.map(p => `
      <tr data-id="${p.id}">
        <td>${escapar(p.nome)}${p.suspenso ? ' <span class="etiq etiq--susp">suspenso</span>' : ''}</td>
        <td>${p.turmas}</td>
        <td>${p.alunos}</td>
        <td>${p.quizzes}</td>
        <td>${data(p.ultimo_quiz)}</td>
      </tr>`).join('')
      : '<tr><td colspan="5" class="vazio">Nenhum professor cadastrado.</td></tr>';

    $('prof-lista').querySelectorAll('tr[data-id]').forEach(tr => {
      tr.addEventListener('click', () => {
        document.querySelector('.adm__aba[data-aba="usuarios"]').click();
        abrirFicha(tr.dataset.id);
      });
    });
  }

  // ── Patentes ──────────────────────────────────────────────────────
  async function carregarPatentes() {
    const r = await tentar(() => API.adminPatentes());
    if (!r) return;

    const porTipo = { ALUNO: [], PROFESSOR: [] };
    for (const f of r.patentes) if (porTipo[f.tipo]) porTipo[f.tipo].push(f);

    // Banco sem a tabela ainda: a tela diz isso em vez de mostrar vazio.
    if (!r.patentes.length) {
      $('patentes-corpo').innerHTML =
        '<p class="vazio">A tabela de patentes ainda não existe no banco. Rode o db/setup.sql.</p>';
      return;
    }

    $('patentes-corpo').innerHTML = ['ALUNO', 'PROFESSOR'].map(tipo => `
      <div class="ficha">
        <h2 class="ficha__nome">${tipo === 'ALUNO' ? 'Aluno' : 'Professor'}</h2>
        <div id="faixas-${tipo}" style="margin-top:14px">
          ${porTipo[tipo].map(f => linhaFaixa(f.ate, f.nome)).join('')}
        </div>
        <div class="ficha__acoes" style="margin-top:12px">
          <button class="bt" data-add="${tipo}">+ Faixa</button>
          <button class="bt bt--acao" data-salvar="${tipo}" style="margin-left:auto">Salvar ${tipo.toLowerCase()}</button>
        </div>
      </div>`).join('');

    $('patentes-corpo').querySelectorAll('[data-add]').forEach(b => {
      b.addEventListener('click', () => {
        $(`faixas-${b.dataset.add}`).insertAdjacentHTML('beforeend', linhaFaixa(100, ''));
        ligarRemocao();
      });
    });

    $('patentes-corpo').querySelectorAll('[data-salvar]').forEach(b => {
      b.addEventListener('click', () => salvarPatentes(b.dataset.salvar));
    });

    ligarRemocao();
  }

  function linhaFaixa(ate, nome) {
    return `<div class="faixa-linha">
      <span style="font-size:11px;color:var(--text-faint)">até o nível</span>
      <input class="adm__campo" type="number" min="1" max="100" value="${ate}">
      <input class="adm__campo" type="text" maxlength="60" value="${escapar(nome)}" placeholder="Nome da patente">
      <button class="bt bt--perigo" data-remover>✕</button>
    </div>`;
  }

  function ligarRemocao() {
    document.querySelectorAll('[data-remover]').forEach(b => {
      b.onclick = () => b.closest('.faixa-linha').remove();
    });
  }

  async function salvarPatentes(tipo) {
    const faixas = Array.from($(`faixas-${tipo}`).querySelectorAll('.faixa-linha')).map(l => {
      const [num, texto] = l.querySelectorAll('input');
      return { ate: Number(num.value), nome: texto.value.trim() };
    });

    const r = await tentar(() => API.adminSalvarPatentes(tipo, faixas),
      `Patentes de ${tipo.toLowerCase()} salvas.`);
    if (r) carregarPatentes();
  }

  // ── Utilidades ────────────────────────────────────────────────────

  /** Escapa HTML de textos do usuário. */
  function escapar(texto) {
    return String(texto ?? '').replace(/[&<>"']/g,
      c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  }

  /** Etiqueta [PATENTE] colorida (window.PATENTE do navbar.js). */
  function etiqueta(nivel, mini) {
    return window.PATENTE ? window.PATENTE.html(nivel, mini) : '';
  }

  /** A foto de perfil, ou as iniciais quando não há nenhuma. */
  function foto(u) {
    return u.avatar_url
      ? `<img src="${escapar(u.avatar_url)}" alt="">`
      : escapar(iniciais(u.nome));
  }

  /** "Ana Clara Souza" vira "AS". */
  function iniciais(nome) {
    const partes = String(nome || '?').trim().split(/\s+/);
    const primeira = partes[0] ? partes[0][0] : '?';
    const ultima = partes.length > 1 ? partes[partes.length - 1][0] : '';
    return (primeira + ultima).toUpperCase();
  }

  function data(iso) {
    if (!iso) return '—';
    try {
      return new Date(iso).toLocaleDateString('pt-BR',
        { day: '2-digit', month: '2-digit', year: '2-digit' });
    } catch (_) { return '—'; }
  }
})();
