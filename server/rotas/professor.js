/**
 * server/rotas/professor.js — o painel do professor
 *
 * Estas rotas existem porque o RLS sozinho não dava conta: o professor
 * precisa ler linhas que não são dele (o progresso dos alunos), e cada
 * exceção dessas no banco é uma policy a mais para revisar. Do lado de
 * cá a regra fica em um lugar só: "é aluno de uma turma minha?".
 */

const express = require('express');
const { admin } = require('../supabase');
const { autenticar, exigirTipo } = require('../middleware/autenticar');
const { falhou } = require('../erros');
const { lerTudo } = require('../lerTudo');
const { CRIADOR_SISTEMA } = require('../conteudo');

const rotas = express.Router();
rotas.use(autenticar, exigirTipo('PROFESSOR', 'ADMIN'));

/** Confere se a turma pertence a quem está pedindo. ADMIN passa direto. */
async function turmaEhMinha(usuario, turmaId) {
  if (usuario.tipo === 'ADMIN') return true;

  const { data } = await admin
    .from('turmas')
    .select('id')
    .eq('id', turmaId)
    .eq('professor_id', usuario.id)
    .maybeSingle();

  return Boolean(data);
}

// Mesma lista de cores do seletor em dashboard.html, e o check espelhado
// no banco (db/setup.sql). Quem manda a cor é o navegador, então ela
// precisa ser conferida contra uma lista fechada antes de gravar.
const CORES_VALIDAS = ['#14b8a6', '#3b82f6', '#f9c74f', '#f472b6', '#a78bfa', '#fb923c'];

// O jogo atende dos 7 aos 18 anos, então a lista vai do Fundamental ao
// 3º do Médio. Os rótulos do Médio levam "EM" para não se confundirem
// com o 1º/2º/3º do Fundamental, e são curtos de propósito: a coluna
// turmas.ano_escolar é varchar(10) (db/setup.sql).
const ANOS_VALIDOS = [
  '1º ano', '2º ano', '3º ano', '4º ano', '5º ano',
  '6º ano', '7º ano', '8º ano', '9º ano',
  '1º ano EM', '2º ano EM', '3º ano EM'
];

// Quantos alunos cabem numa turma, para o "x/10" do card. Fixo por
// enquanto — se um dia precisar variar por turma, vira coluna no banco.
const LIMITE_ALUNOS_POR_TURMA = 10;

/**
 * Ponte enquanto a coluna `descricao` de quizzes_professores não existir
 * em todo banco. Roda a consulta; se o Postgres reclamar dessa coluna,
 * roda de novo sem ela.
 *
 * É temporário. Some quando todos os bancos rodarem:
 *   alter table quizzes_professores add column if not exists descricao varchar(200);
 *
 * A descrição é a frase que o aluno lê no card — perder a frase é bem
 * menos grave do que a tela inteira de tarefas parar de carregar.
 */
async function comOuSemDescricao(montar) {
  const r = await montar(true);
  if (r.error && /descricao/.test(r.error.message || '')) return montar(false);
  return r;
}

const QTD_MIN = 3;
const QTD_MAX = 30;
function nivelDoAnoEscolar(ano) {
  if (!ano) return null;
  if (ano.includes('EM')) return 3;             // 1º a 3º do Médio

  const numero = parseInt(ano, 10);             // '6º ano' -> 6
  if (!Number.isInteger(numero)) return null;
  if (numero >= 6 && numero <= 9) return 2;     // Fundamental II
  if (numero >= 1 && numero <= 5) return 1;     // Fundamental I
  return null;
}

// ── As turmas do professor, com o código para entregar à sala ────────
rotas.get('/turmas', async (req, res) => {
  const { data, error } = await admin
    .from('turmas')
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .eq('professor_id', req.usuario.id)
    .order('nome');

  if (error) return falhou(res, 500, 'Não foi possível carregar suas turmas.', error, 'GET /professor/turmas');

  const ids = data.map(t => t.id);
  const contagem = new Map(ids.map(id => [id, 0]));

  if (ids.length > 0) {
    const alunos = await admin
      .from('usuarios')
      .select('turma_id')
      .in('turma_id', ids)
      .eq('tipo', 'ALUNO');

    for (const a of alunos.data || []) {
      contagem.set(a.turma_id, (contagem.get(a.turma_id) || 0) + 1);
    }
  }

  res.json(data.map(t => ({
    ...t,
    total_alunos: contagem.get(t.id) || 0,
    limite_alunos: LIMITE_ALUNOS_POR_TURMA
  })));
});

// ── Criar turma ──────────────────────────────────────────────────────
rotas.post('/turmas', async (req, res) => {
  const nome = String(req.body?.nome || '').trim();

  if (nome.length < 2) {
    return res.status(400).json({ message: 'Dê um nome à turma. Ex: 7º Ano B' });
  }
  if (!req.usuario.escola_id) {
    return res.status(400).json({ message: 'Seu cadastro não tem escola. Avise o administrador.' });
  }

  // Cor e ano vêm do navegador, então são conferidos contra uma lista
  // fechada antes de gravar — o mesmo dado inválido também cairia no
  // check do banco, mas é melhor barrar aqui com uma mensagem clara.
  const cor = CORES_VALIDAS.includes(req.body?.cor) ? req.body.cor : CORES_VALIDAS[0];
  const ano_escolar = ANOS_VALIDOS.includes(req.body?.ano_escolar) ? req.body.ano_escolar : null;

  // O código é gerado aqui, e não no navegador: ele é a credencial que
  // deixa um aluno entrar na turma, então quem o inventa tem que ser o
  // lado confiável.
  const codigo = gerarCodigo(nome);

  const { data, error } = await admin
    .from('turmas')
    .insert({
      nome,
      escola_id: req.usuario.escola_id,
      professor_id: req.usuario.id,
      codigo,
      cor,
      ano_escolar
    })
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .single();

  if (error) {
    if (error.message.includes('duplicate') || error.code === '23505') {
      return res.status(409).json({ message: 'Você já tem uma turma com esse nome nesta escola.' });
    }
    return falhou(res, 500, 'Não foi possível criar a turma.', error, 'POST /professor/turmas');
  }

  res.status(201).json({ ...data, total_alunos: 0, limite_alunos: LIMITE_ALUNOS_POR_TURMA });
});

/** Monta um código curto tipo '7B-K3M9'. Sem letras que confundem (O/0, I/1). */
function gerarCodigo(nomeTurma) {
  const LETRAS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  const prefixo = nomeTurma
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, '')
    .slice(0, 3) || 'T';

  let sufixo = '';
  for (let i = 0; i < 4; i++) {
    sufixo += LETRAS[Math.floor(Math.random() * LETRAS.length)];
  }

  return `${prefixo}-${sufixo}`;
}

// ── Editar nome, cor e ano da turma ──────────────────────────────────
// Só esses três campos. O código, a escola e o dono da turma ficam de
// fora de propósito: o código é credencial de entrada e trocá-lo
// deixaria a sala inteira sem conseguir entrar.
rotas.patch('/turmas/:id', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const mudancas = {};

  if (req.body?.nome !== undefined) {
    const nome = String(req.body.nome).trim();
    if (nome.length < 2) {
      return res.status(400).json({ message: 'Dê um nome à turma. Ex: 7º Ano B' });
    }
    mudancas.nome = nome;
  }

  // Ao contrário do POST, aqui um valor fora da lista é recusado em vez
  // de virar o padrão: numa edição, gravar calado uma cor diferente da
  // pedida esconderia o erro de quem chamou.
  if (req.body?.cor !== undefined) {
    if (!CORES_VALIDAS.includes(req.body.cor)) {
      return res.status(400).json({ message: 'Essa cor não está na lista.' });
    }
    mudancas.cor = req.body.cor;
  }

  if (req.body?.ano_escolar !== undefined) {
    const ano = req.body.ano_escolar;
    if (ano !== null && !ANOS_VALIDOS.includes(ano)) {
      return res.status(400).json({ message: 'Esse ano escolar não está na lista.' });
    }
    mudancas.ano_escolar = ano;
  }

  if (Object.keys(mudancas).length === 0) {
    return res.status(400).json({ message: 'Nada para alterar.' });
  }

  const { data, error } = await admin
    .from('turmas')
    .update(mudancas)
    .eq('id', turmaId)
    .select('id, nome, codigo, escola_id, cor, ano_escolar')
    .single();

  if (error) {
    if (error.message.includes('duplicate') || error.code === '23505') {
      return res.status(409).json({ message: 'Você já tem uma turma com esse nome nesta escola.' });
    }
    return falhou(res, 500, 'Não foi possível salvar as mudanças.', error, 'PATCH /professor/turmas/:id');
  }

  // O card mostra "x/10", então a resposta precisa devolver a contagem
  // junto — do contrário a tela teria que buscar a lista inteira de novo.
  const { count } = await admin
    .from('usuarios')
    .select('id', { count: 'exact', head: true })
    .eq('turma_id', turmaId)
    .eq('tipo', 'ALUNO');

  res.json({ ...data, total_alunos: count || 0, limite_alunos: LIMITE_ALUNOS_POR_TURMA });
});

rotas.delete('/turmas/:id', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const { error } = await admin.from('turmas').delete().eq('id', turmaId);

  if (error) {
    return falhou(res, 500, 'Não foi possível desfazer a turma.', error, 'DELETE /professor/turmas/:id');
  }

  res.status(204).end();
});

// ── Os alunos de uma turma, com o desempenho de cada um ──────────────
rotas.get('/turmas/:id/alunos', async (req, res) => {
  const turmaId = Number(req.params.id);

  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  const alunos = await admin
    .from('usuarios')
    .select('id, nome, idade')
    .eq('turma_id', turmaId)
    .eq('tipo', 'ALUNO')
    .order('nome');

  if (alunos.error) {
    return falhou(res, 500, 'Não foi possível carregar a turma.', alunos.error, 'GET /professor/turmas/:id/alunos');
  }

  const ids = alunos.data.map(a => a.id);
  if (ids.length === 0) return res.json([]);

  const respostas = await admin
    .from('respostas_alunos')
    .select('usuario_id, acertou')
    .in('usuario_id', ids);

  const resumo = new Map(ids.map(id => [id, { total: 0, acertos: 0 }]));
  for (const r of respostas.data || []) {
    const item = resumo.get(r.usuario_id);
    item.total += 1;
    if (r.acertou) item.acertos += 1;
  }

  res.json(alunos.data.map(a => {
    const { total, acertos } = resumo.get(a.id);
    return {
      id: a.id,
      nome: a.nome,
      idade: a.idade,
      respostas: total,
      acertos,
      // Sem respostas ainda, aproveitamento é null e não zero — zero
      // pareceria "foi mal", quando na verdade é "ainda não começou".
      aproveitamento: total ? Math.round((acertos / total) * 100) : null
    };
  }));
});

rotas.post('/quizzes', async (req, res) => {
  const turmaId = Number(req.body?.turma_id);
  const titulo = String(req.body?.titulo || '').trim();

  if (!Number.isInteger(turmaId)) {
    return res.status(400).json({ message: 'Turma inválida.' });
  }
  if (titulo.length < 2) {
    return res.status(400).json({ message: 'Dê um título ao quiz. Ex: Revisão de Dengue' });
  }
  if (!await turmaEhMinha(req.usuario, turmaId)) {
    return res.status(403).json({ message: 'Essa turma não é sua.' });
  }

  // Dois jeitos de montar o quiz:
  //   'auto'   — o servidor sorteia entre as questões que casam com os
  //              cenários/áreas pedidos (o jeito de sempre);
  //   'manual' — o professor manda a lista de questões que escolheu.
  // Nos dois, só entram questões do sistema ou do próprio professor:
  // a de outro professor nunca vira tarefa aqui, nem mandando o id dela.
  const manual = req.body?.modo === 'manual';

  const descricao = String(req.body?.descricao || '').trim().slice(0, 200) || null;

  let tempo = Number(req.body?.tempo_limite_segundos);
  if (!Number.isInteger(tempo) || tempo <= 0) tempo = 20;

  const turma = await admin
    .from('turmas').select('ano_escolar').eq('id', turmaId).maybeSingle();

  const nivel = nivelDoAnoEscolar(turma.data?.ano_escolar);
  if (!nivel) {
    return res.status(400).json({
      message: 'Defina o ano escolar da turma antes de criar o quiz.'
    });
  }

  const escolha = manual
    ? await escolherAMao(req, nivel)
    : await sortear(req, nivel);

  if (escolha.erro) {
    const { status, message, causa } = escolha.erro;
    if (status === 500) return falhou(res, 500, message, causa, 'POST /professor/quizzes');
    return res.status(status).json({ message });
  }

  const { sorteadas, cenarios, areas, qtd } = escolha;
  const COLUNAS = 'id, turma_id, titulo, tempo_limite_segundos, nivel_etario, cenarios, areas, qtd_pedida, created_at';

  const linha = {
    turma_id: turmaId,
    professor_id: req.usuario.id,
    titulo,
    descricao,
    tempo_limite_segundos: tempo,
    nivel_etario: nivel,
    cenarios,
    areas,
    qtd_pedida: qtd
  };

  let criado = await admin
    .from('quizzes_professores')
    .insert(linha)
    .select(COLUNAS + ', descricao')
    .single();

  // A `descricao` é enfeite: é a frase que o aluno lê no card. Se a
  // coluna ainda não existe neste banco, o quiz é criado sem ela em vez
  // de a criação inteira falhar — perder a frase é bem menos grave do
  // que o professor não conseguir passar tarefa nenhuma.
  //
  // Some quando alguém rodar:
  //   alter table quizzes_professores add column if not exists descricao varchar(200);
  if (criado.error && /descricao/.test(criado.error.message || '')) {
    console.warn(
      "  ⚠ quizzes_professores.descricao não existe neste banco — quiz criado sem a descrição.\n" +
      "    Rode: alter table quizzes_professores add column if not exists descricao varchar(200);");

    delete linha.descricao;
    criado = await admin
      .from('quizzes_professores')
      .insert(linha)
      .select(COLUNAS)
      .single();
  }

  if (criado.error) {
    return falhou(res, 500, 'Não foi possível criar o quiz.', criado.error, 'POST /professor/quizzes');
  }
  const vinculo = await admin.from('quiz_questoes').insert(
    sorteadas.map((questaoId, i) => ({
      quiz_id: criado.data.id, questao_id: questaoId, ordem: i + 1
    }))
  );

  if (vinculo.error) {
    await admin.from('quizzes_professores').delete().eq('id', criado.data.id);
    return falhou(res, 500, 'Não foi possível sortear as perguntas do quiz.', vinculo.error, 'POST /professor/quizzes');
  }

  res.status(201).json({ ...criado.data, total_questoes: sorteadas.length });
});

/**
 * Modo automático: sorteia `qtd` questões entre as que casam com os
 * cenários (obrigatórios) e áreas (opcionais) pedidos, na faixa etária
 * da turma. Devolve { sorteadas, cenarios, areas, qtd } ou { erro }.
 */
async function sortear(req, nivel) {
  const cenarios = Array.isArray(req.body?.cenarios) ? req.body.cenarios.map(String) : [];
  if (cenarios.length === 0) {
    return { erro: { status: 400, message: 'Escolha pelo menos um cenário de onde tirar as perguntas.' } };
  }

  const areas = Array.isArray(req.body?.areas) ? req.body.areas.map(String) : [];

  let qtd = Number(req.body?.qtd_questoes);
  if (!Number.isInteger(qtd)) qtd = 10;
  qtd = Math.min(QTD_MAX, Math.max(QTD_MIN, qtd));

  // As candidatas: questões dos cenários escolhidos, na faixa etária da
  // turma, do sistema ou do próprio professor e — se ele filtrou — que
  // pontuem em alguma das áreas pedidas. Os "!inner" fazem o join virar
  // filtro: questão sem o cenário (ou sem a área) não vem.
  //
  // Com filtro de área, a mesma questão pode casar com duas áreas e vir
  // duas vezes; o Set logo abaixo desfaz a repetição.
  const questoes = await lerTudo(() => {
    let consulta = admin
      .from('questoes')
      .select('id, cenarios!inner(slug)' + (areas.length ? ', questoes_areas!inner(area_nome)' : ''))
      .eq('nivel_etario', nivel)
      .in('criado_por', [CRIADOR_SISTEMA, req.usuario.id])
      .in('cenarios.slug', cenarios);

    if (areas.length) consulta = consulta.in('questoes_areas.area_nome', areas);
    return consulta.order('id');
  });

  if (questoes.error) {
    return { erro: { status: 500, message: 'Não foi possível procurar as perguntas.', causa: questoes.error } };
  }

  const bolo = [...new Set(questoes.data.map(q => q.id))];

  if (bolo.length === 0) {
    return { erro: { status: 400, message: 'Não há perguntas para essa combinação de cenário, área e ano da turma.' } };
  }

  for (let i = bolo.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [bolo[i], bolo[j]] = [bolo[j], bolo[i]];
  }

  return { sorteadas: bolo.slice(0, qtd), cenarios, areas, qtd };
}

/**
 * Modo manual: o professor mandou `questao_ids`, na ordem em que quer
 * que a turma responda. Cada uma é conferida aqui — existir, ser do
 * sistema ou dele, e ser da faixa etária da turma — porque a lista vem
 * do navegador e pode ter sido escrita no console.
 *
 * Os cenários e as áreas do quiz saem das próprias questões: são eles
 * que decidem em quais lugares do mapa a missão aparece para o aluno.
 */
async function escolherAMao(req, nivel) {
  const pedidas = Array.isArray(req.body?.questao_ids) ? req.body.questao_ids : [];
  const ids = [...new Set(pedidas.map(Number))].filter(n => Number.isInteger(n) && n > 0);

  if (ids.length === 0) {
    return { erro: { status: 400, message: 'Escolha pelo menos uma pergunta para o quiz.' } };
  }
  if (ids.length > QTD_MAX) {
    return { erro: { status: 400, message: `Um quiz tem no máximo ${QTD_MAX} perguntas.` } };
  }

  const { data, error } = await admin
    .from('questoes')
    .select('id, nivel_etario, criado_por, cenarios(slug), questoes_areas(area_nome)')
    .in('id', ids);

  if (error) {
    return { erro: { status: 500, message: 'Não foi possível conferir as perguntas escolhidas.', causa: error } };
  }

  const porId = new Map(data.map(q => [q.id, q]));
  const cenarios = [];
  const areas = [];

  for (const id of ids) {
    const q = porId.get(id);

    // "Não existe" e "é de outro professor" dão a MESMA mensagem: com
    // mensagens diferentes, dava para descobrir pelo console quais ids
    // são perguntas escondidas de colegas.
    if (!q || (q.criado_por !== CRIADOR_SISTEMA && q.criado_por !== req.usuario.id)) {
      return { erro: { status: 400, message: 'Uma das perguntas escolhidas não está disponível. Recarregue a lista e escolha de novo.' } };
    }
    if (q.nivel_etario !== nivel) {
      return { erro: { status: 400, message: 'Uma das perguntas escolhidas é de outra faixa etária, diferente da turma.' } };
    }

    const slug = q.cenarios?.slug;
    if (slug && !cenarios.includes(slug)) cenarios.push(slug);

    for (const a of q.questoes_areas || []) {
      if (!areas.includes(a.area_nome)) areas.push(a.area_nome);
    }
  }

  return { sorteadas: ids, cenarios, areas, qtd: ids.length };
}


/* ═══════════════════════════════════════════════════════════════════
   AS QUESTÕES

   O professor vê dois montes: as do SISTEMA (equipe de Medicina, iguais
   para todo mundo) e as DELE, que ele mesmo escreveu. As de outro
   professor nunca aparecem — todo select aqui filtra por criado_por.

   O gabarito (resposta_correta + explicacao) só vai junto nas questões
   do próprio professor. As do sistema saem sem ele: qualquer pessoa
   pode se cadastrar como PROFESSOR hoje (docs/banco-de-dados.md §4), e
   entregar o gabarito aqui seria entregá-lo a qualquer aluno esperto.
   ═══════════════════════════════════════════════════════════════════ */

// Quanto uma questão de professor vale em cada área que ele marcar. O
// conteúdo da Medicina usa pesos de 4 a 10; 10 é o padrão da tabela.
const PONTOS_POR_AREA = 10;

const COLUNAS_QUESTAO =
  'id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, nivel_etario, criado_por';

/** "ubs,escola" -> ['ubs', 'escola'] */
function lista(valor) {
  return String(valor || '').split(',').map(s => s.trim()).filter(Boolean);
}

/** As 8 áreas na ordem canônica das barras. */
async function lerAreas() {
  const { data, error } = await admin.from('areas').select('nome, ordem').order('ordem');
  return { nomes: (data || []).map(a => a.nome), error };
}

/** Deixa a questão no formato que a tela usa, com o gabarito só se for dela. */
function formatarQuestao(q, usuario, ordemDasAreas) {
  const minha = q.criado_por === usuario.id;
  const areas = (q.questoes_areas || []).map(a => a.area_nome)
    .sort((a, b) => ordemDasAreas.indexOf(a) - ordemDasAreas.indexOf(b));

  const saida = {
    id: q.id,
    enunciado: q.enunciado,
    opcao_a: q.opcao_a,
    opcao_b: q.opcao_b,
    opcao_c: q.opcao_c,
    opcao_d: q.opcao_d,
    opcao_e: q.opcao_e,
    nivel_etario: q.nivel_etario,
    cenario: q.cenarios ? { slug: q.cenarios.slug, nome: q.cenarios.nome } : null,
    areas,
    minha
  };

  if (minha) {
    saida.resposta_correta = q.resposta_correta;
    saida.explicacao = q.explicacao;
  }
  return saida;
}

// ── Listar questões ──────────────────────────────────────────────────
//   ?origem=sistema|minhas   de qual monte (padrão: sistema)
//   ?nivel=1|2|3             faixa etária (opcional)
//   ?cenarios=ubs,escola     só desses lugares (opcional)
//   ?areas=Saúde,Educação    só as que pontuam em alguma destas (opcional)
rotas.get('/questoes', async (req, res) => {
  const minhas = req.query.origem === 'minhas';
  const cenarios = lista(req.query.cenarios);
  const filtroAreas = lista(req.query.areas);

  let nivel = null;
  if (req.query.nivel !== undefined && req.query.nivel !== '') {
    nivel = Number(req.query.nivel);
    if (![1, 2, 3].includes(nivel)) {
      return res.status(400).json({ message: 'Nível etário inválido.' });
    }
  }

  const colunas = COLUNAS_QUESTAO
    + (minhas ? ', resposta_correta, explicacao' : '')
    + (cenarios.length ? ', cenarios!inner(slug, nome)' : ', cenarios(slug, nome)')
    + ', questoes_areas(area_nome)';

  const [questoes, areas] = await Promise.all([
    lerTudo(() => {
      let consulta = admin
        .from('questoes')
        .select(colunas)
        .eq('criado_por', minhas ? req.usuario.id : CRIADOR_SISTEMA);

      if (nivel) consulta = consulta.eq('nivel_etario', nivel);
      if (cenarios.length) consulta = consulta.in('cenarios.slug', cenarios);

      // As minhas, da mais nova para a mais velha: quem acabou de criar
      // uma pergunta quer vê-la no topo.
      return consulta.order('id', { ascending: !minhas });
    }),
    lerAreas()
  ]);

  const erro = questoes.error || areas.error;
  if (erro) return falhou(res, 500, 'Não foi possível carregar as perguntas.', erro, 'GET /professor/questoes');

  // O filtro de área é feito aqui, e não com um !inner no banco: o
  // !inner cortaria da resposta as OUTRAS áreas da questão, e a tela
  // mostraria "Saúde" numa pergunta que também vale Educação.
  const linhas = filtroAreas.length
    ? questoes.data.filter(q => (q.questoes_areas || []).some(a => filtroAreas.includes(a.area_nome)))
    : questoes.data;

  res.json(linhas.map(q => formatarQuestao(q, req.usuario, areas.nomes)));
});

// ── Criar questão ────────────────────────────────────────────────────
rotas.post('/questoes', async (req, res) => {
  const b = req.body || {};
  const texto = (v) => String(v ?? '').trim();
  const recusar = (message) => res.status(400).json({ message });

  const enunciado = texto(b.enunciado);
  if (enunciado.length < 10) return recusar('Escreva o enunciado da pergunta (pelo menos 10 letras).');
  if (enunciado.length > 1000) return recusar('O enunciado passou de 1000 letras. Tente resumir.');

  const opcoes = { A: texto(b.opcao_a), B: texto(b.opcao_b), C: texto(b.opcao_c), D: texto(b.opcao_d) };

  if (!opcoes.A || !opcoes.B) return recusar('Preencha pelo menos as alternativas A e B.');
  if (!opcoes.C && opcoes.D) return recusar('Preencha a alternativa C antes da D.');

  // 255 é o tamanho das colunas opcao_* (db/setup.sql). Cortar calado
  // mudaria o sentido da alternativa sem o professor saber.
  for (const letra of 'ABCD') {
    if (opcoes[letra].length > 255) return recusar(`A alternativa ${letra} passou de 255 letras.`);
  }

  const certa = texto(b.resposta_correta).toUpperCase();
  if (!['A', 'B', 'C', 'D'].includes(certa) || !opcoes[certa]) {
    return recusar('Marque qual alternativa é a correta.');
  }

  const explicacao = texto(b.explicacao);
  if (explicacao.length < 5) return recusar('Escreva a explicação que o aluno lê depois de responder.');
  if (explicacao.length > 1000) return recusar('A explicação passou de 1000 letras. Tente resumir.');

  const nivel = Number(b.nivel_etario);
  if (![1, 2, 3].includes(nivel)) return recusar('Escolha o nível etário da pergunta.');

  const [cenario, areas] = await Promise.all([
    admin.from('cenarios').select('id, slug, nome').eq('slug', texto(b.cenario)).maybeSingle(),
    lerAreas()
  ]);

  if (areas.error) return falhou(res, 500, 'Não foi possível salvar a pergunta.', areas.error, 'POST /professor/questoes');
  if (!cenario.data) return recusar('Escolha o cenário da pergunta.');

  const pedidas = [...new Set((Array.isArray(b.areas) ? b.areas : []).map(String))];
  if (pedidas.length === 0) return recusar('Escolha pelo menos uma área para a pergunta dar pontos.');

  const desconhecida = pedidas.find(a => !areas.nomes.includes(a));
  if (desconhecida) return recusar(`A área "${desconhecida}" não existe.`);

  // criado_por vem do login, NUNCA do corpo da requisição: é ele que
  // decide quem enxerga a pergunta.
  const criada = await admin
    .from('questoes')
    .insert({
      cenario_id: cenario.data.id,
      nivel_etario: nivel,
      enunciado,
      opcao_a: opcoes.A,
      opcao_b: opcoes.B,
      opcao_c: opcoes.C || null,
      opcao_d: opcoes.D || null,
      resposta_correta: certa,
      explicacao,
      criado_por: req.usuario.id
    })
    .select(COLUNAS_QUESTAO + ', resposta_correta, explicacao')
    .single();

  if (criada.error) {
    return falhou(res, 500, 'Não foi possível salvar a pergunta.', criada.error, 'POST /professor/questoes');
  }

  // Sem linha em questoes_areas, acertar a pergunta não pontua nada. Se
  // esta parte falhar, a questão sai junto — melhor nenhuma pergunta do
  // que uma que não vale ponto e ninguém sabe por quê.
  const pontos = await admin.from('questoes_areas').insert(
    pedidas.map(area_nome => ({ questao_id: criada.data.id, area_nome, pontos: PONTOS_POR_AREA }))
  );

  if (pontos.error) {
    await admin.from('questoes').delete().eq('id', criada.data.id);
    return falhou(res, 500, 'Não foi possível salvar as áreas da pergunta.', pontos.error, 'POST /professor/questoes');
  }

  res.status(201).json(formatarQuestao({
    ...criada.data,
    cenarios: cenario.data,
    questoes_areas: pedidas.map(area_nome => ({ area_nome }))
  }, req.usuario, areas.nomes));
});

// ── Apagar questão ───────────────────────────────────────────────────
// Só a própria, e só enquanto ninguém a respondeu nem a usa num quiz.
// respostas_alunos referencia questoes com "on delete cascade": apagar
// uma pergunta já respondida levaria junto as respostas — e o XP — dos
// alunos, por causa de uma decisão que não foi deles.
rotas.delete('/questoes/:id', async (req, res) => {
  const questaoId = Number(req.params.id);

  if (!Number.isInteger(questaoId) || questaoId <= 0) {
    return res.status(400).json({ message: 'Pergunta inválida.' });
  }

  const questao = await admin
    .from('questoes').select('id, criado_por').eq('id', questaoId).maybeSingle();

  if (!questao.data || questao.data.criado_por !== req.usuario.id) {
    return res.status(403).json({ message: 'Essa pergunta não é sua.' });
  }

  const [respostas, quizzes] = await Promise.all([
    admin.from('respostas_alunos').select('id', { count: 'exact', head: true }).eq('questao_id', questaoId),
    admin.from('quiz_questoes').select('quiz_id', { count: 'exact', head: true }).eq('questao_id', questaoId)
  ]);

  if (respostas.count > 0) {
    return res.status(409).json({
      message: 'Alunos já responderam esta pergunta. Apagá-la apagaria as respostas e o XP deles.'
    });
  }
  if (quizzes.count > 0) {
    return res.status(409).json({
      message: 'Esta pergunta está em um quiz. Apague o quiz antes de apagar a pergunta.'
    });
  }

  const { error } = await admin.from('questoes').delete().eq('id', questaoId);
  if (error) return falhou(res, 500, 'Não foi possível apagar a pergunta.', error, 'DELETE /professor/questoes/:id');

  res.status(204).end();
});


rotas.get('/quizzes', async (req, res) => {
  const turmaId = Number(req.query.turma_id);

  // Sem turma_id na URL, devolve o histórico INTEIRO de quem pediu — é o
  // que a página de quizzes usa. Com turma_id, só os daquela turma.
  const filtrarPorTurma = req.query.turma_id !== undefined && req.query.turma_id !== '';

  if (filtrarPorTurma) {
    if (!Number.isInteger(turmaId)) {
      return res.status(400).json({ message: 'Turma inválida.' });
    }
    if (!await turmaEhMinha(req.usuario, turmaId)) {
      return res.status(403).json({ message: 'Essa turma não é sua.' });
    }
  }

  const { data, error } = await comOuSemDescricao(com => {
    const consulta = admin
      .from('quizzes_professores')
      .select('id, titulo, turma_id, ' + (com ? 'descricao, ' : '') +
              'tempo_limite_segundos, nivel_etario, cenarios, areas, qtd_pedida, created_at')
      .order('created_at', { ascending: false });

    // ADMIN sem filtro veria o banco inteiro; continua preso ao que é dele.
    return filtrarPorTurma
      ? consulta.eq('turma_id', turmaId)
      : consulta.eq('professor_id', req.usuario.id);
  });

  if (error) return falhou(res, 500, 'Não foi possível carregar os quizzes.', error, 'GET /professor/quizzes');

  const ids = data.map(q => q.id);

  // O nome e a cor da turma vêm junto: sem eles a página de histórico
  // mostraria "quiz da turma 4", que não diz nada a quem tem seis turmas.
  const turmaDe = new Map();
  const idsTurmas = [...new Set(data.map(q => q.turma_id).filter(Boolean))];

  if (idsTurmas.length > 0) {
    const turmas = await admin
      .from('turmas').select('id, nome, cor').in('id', idsTurmas);

    for (const t of turmas.data || []) turmaDe.set(t.id, t);
  }
  const contagem = new Map(ids.map(id => [id, 0]));

  if (ids.length > 0) {
    const vinculos = await admin.from('quiz_questoes').select('quiz_id').in('quiz_id', ids);
    for (const v of vinculos.data || []) {
      contagem.set(v.quiz_id, (contagem.get(v.quiz_id) || 0) + 1);
    }
  }

  res.json(data.map(q => ({
    ...q,
    total_questoes: contagem.get(q.id) || 0,
    turma_nome: (turmaDe.get(q.turma_id) || {}).nome || null,
    turma_cor: (turmaDe.get(q.turma_id) || {}).cor || null
  })));
});


rotas.delete('/quizzes/:id', async (req, res) => {
  const quizId = Number(req.params.id);

  if (!Number.isInteger(quizId)) {
    return res.status(400).json({ message: 'Quiz inválido.' });
  }

  const dono = await admin
    .from('quizzes_professores').select('id')
    .eq('id', quizId).eq('professor_id', req.usuario.id).maybeSingle();

  if (!dono.data && req.usuario.tipo !== 'ADMIN') {
    return res.status(403).json({ message: 'Esse quiz não é seu.' });
  }

  const { error } = await admin.from('quizzes_professores').delete().eq('id', quizId);
  if (error) return falhou(res, 500, 'Não foi possível desfazer o quiz.', error, 'DELETE /professor/quizzes/:id');

  res.status(204).end();
});

/* ═══════════════════════════════════════════════════════════════════
   RANKING DAS TURMAS

   Ordena as turmas do professor por desempenho. O número que o professor
   lê é a taxa crua (acertos ÷ respostas), mas a ORDEM não pode ser essa:
   uma turma com 3 respostas e 3 acertos daria 100% e passaria na frente
   de uma com 400 respostas e 92%. Uma amostra de três respostas não diz
   nada sobre a turma.

   Quem resolve é uma média com peso: cada turma entra na conta já com
   PESO_INICIAL respostas imaginárias na média geral de todas as turmas.
   Quem respondeu pouco fica perto da média (não sobe nem desce à toa) e
   quem respondeu muito domina a própria nota. É a mesma ideia da nota de
   filme que exige um mínimo de votos.

   As contagens usam count/head: o banco conta e devolve só o número, em
   vez de mandar todas as respostas para cá para serem contadas aqui.
   ═══════════════════════════════════════════════════════════════════ */

const PESO_INICIAL = 10;

rotas.get('/ranking', async (req, res) => {
  const turmas = await admin
    .from('turmas')
    .select('id, nome, cor, ano_escolar')
    .eq('professor_id', req.usuario.id)
    .order('nome');

  if (turmas.error) {
    return falhou(res, 500, 'Não foi possível carregar o ranking.', turmas.error, 'GET /professor/ranking');
  }
  if (!turmas.data.length) return res.json([]);

  const idsTurmas = turmas.data.map(t => t.id);

  const alunos = await admin
    .from('usuarios')
    .select('id, turma_id')
    .eq('tipo', 'ALUNO')
    .in('turma_id', idsTurmas);

  if (alunos.error) {
    return falhou(res, 500, 'Não foi possível carregar os alunos.', alunos.error, 'GET /professor/ranking');
  }

  const alunosDe = new Map(idsTurmas.map(id => [id, []]));
  for (const a of alunos.data || []) {
    if (alunosDe.has(a.turma_id)) alunosDe.get(a.turma_id).push(a.id);
  }

  const linhas = [];

  for (const turma of turmas.data) {
    const ids = alunosDe.get(turma.id) || [];

    if (ids.length === 0) {
      linhas.push({ ...turma, total_alunos: 0, respostas: 0, acertos: 0, taxa: null });
      continue;
    }

    const [tudo, certas] = await Promise.all([
      admin.from('respostas_alunos')
        .select('*', { count: 'exact', head: true })
        .in('usuario_id', ids),
      admin.from('respostas_alunos')
        .select('*', { count: 'exact', head: true })
        .in('usuario_id', ids).eq('acertou', true)
    ]);

    const respostas = tudo.count || 0;
    const acertos = certas.count || 0;

    linhas.push({
      ...turma,
      total_alunos: ids.length,
      respostas,
      acertos,
      // null e não zero: "ninguém respondeu" não é "foi mal".
      taxa: respostas ? Math.round((acertos / respostas) * 100) : null
    });
  }

  // A média geral é a régua: quem respondeu pouco é puxado para ela.
  const somaRespostas = linhas.reduce((s, l) => s + l.respostas, 0);
  const somaAcertos = linhas.reduce((s, l) => s + l.acertos, 0);
  const mediaGeral = somaRespostas ? somaAcertos / somaRespostas : 0;

  for (const l of linhas) {
    l.nota = (l.acertos + PESO_INICIAL * mediaGeral) / (l.respostas + PESO_INICIAL);
  }

  /* A ordem sai em DOIS GRUPOS, e isso conserta um bug sutil.

     A fórmula acima puxa toda turma para a média geral — é o que impede
     três acertos em três respostas de passarem na frente de quem
     respondeu quatrocentas. Só que uma turma com ZERO respostas cai
     exatamente SOBRE a média, e a média ganha de quem ficou um pouco
     abaixo dela:

         turma vazia  (0 de 0)   -> (0 + 10×0,828) / (0 + 10)  = 0,8280
         turma ativa  (24 de 29) -> (24 + 8,28)   / (29 + 10)  = 0,8277

     O resultado era o painel mostrando duas turmas que nunca jogaram em
     1º e 2º, e a única que estava jogando em 3º.

     A correção não é mexer no peso: é reconhecer que turma sem resposta
     não tem o que classificar. Ela não "empata na média", ela ainda não
     entrou. Vai para o fim, e entre elas vale a ordem alfabética. */
  linhas.sort((a, b) => {
    const jogouA = a.respostas > 0;
    const jogouB = b.respostas > 0;

    if (jogouA !== jogouB) return jogouA ? -1 : 1;
    if (!jogouA) return a.nome.localeCompare(b.nome, 'pt-BR');

    // Desempate: quem respondeu mais vem primeiro — fez mais para chegar lá.
    return (b.nota - a.nota) || (b.respostas - a.respostas);
  });

  res.json(linhas.map((l, i) => ({
    ...l,
    posicao: i + 1,
    nota: Math.round(l.nota * 1000) / 1000,
    media_geral: Math.round(mediaGeral * 100)
  })));
});

module.exports = rotas;