/**
 * server/progressao.js — XP, nível e insígnias
 *
 * Tudo o que decide "quanto a pessoa tem" mora aqui, do lado do
 * servidor, pelo mesmo motivo de sempre: se a conta acontecesse no
 * navegador, qualquer aluno se daria o nível 10 pelo console.
 *
 * ── DE ONDE VEM O XP ────────────────────────────────────────────────
 *
 *   10  por QUESTÃO distinta acertada   (derivado de respostas_alunos)
 *   50  por DIA em que a pessoa entrou  (gravado em xp_diario)
 *   ?   por INSÍGNIA conquistada        (gravado em insignias_usuarios)
 *
 * Repare na assimetria, que é de propósito. O XP de questão é DERIVADO:
 * respostas_alunos já é a verdade sobre o que a pessoa acertou, e somar
 * de novo numa segunda tabela criaria dois números que um dia
 * discordariam. Os outros dois são GRAVADOS porque não deixam rastro em
 * lugar nenhum — um dia em que a pessoa entrou e não respondeu nada não
 * existe em tabela alguma, e uma insígnia precisa ficar conquistada
 * mesmo que a regra mude depois.
 *
 * ── O TETO ──────────────────────────────────────────────────────────
 *
 * Hoje há 225 questões, ou seja 2.250 XP de conteúdo. É o número contra
 * o qual a escada de níveis foi dimensionada. O prêmio diário não tem
 * teto: é ele que mantém o jogo vivo depois que a pessoa termina tudo.
 */

const { admin } = require('./supabase');
const { lerTudo } = require('./lerTudo');

const XP_POR_QUESTAO = 10;
const XP_DIARIO = 50;

/* ── Enquanto o banco não tiver as tabelas novas ──────────────────────
 *
 * Um banco que ainda não rodou o setup.sql mais recente não tem
 * xp_diario nem insignias. Sem esta ponte, a falta delas derruba
 * /meu-resumo inteiro — e com ele a tela de perfil, a de progresso e o
 * selo da barra, que não têm nada a ver com XP diário.
 *
 * A regra: FALTAR TABELA NÃO É ERRO DE REQUISIÇÃO. O XP volta sem a
 * parte que não dá para calcular, o resto da tela funciona, e o
 * terminal diz exatamente o que rodar. Erro de verdade continua
 * subindo normalmente.
 *
 *   PGRST205 — o PostgREST não conhece a tabela
 *   42P01    — o Postgres não conhece a tabela
 *   42703    — a coluna não existe
 *
 * É temporário. Some quando todos os bancos tiverem rodado o setup.sql.
 */
const CODIGOS_DE_FALTA = ['PGRST205', '42P01', '42703'];

let jaAvisei = false;

function faltaTabela(erro) {
  if (!erro || !CODIGOS_DE_FALTA.includes(erro.code)) return false;

  if (!jaAvisei) {
    jaAvisei = true;
    console.warn(
      '\n  ⚠ As tabelas de progressão ainda não existem neste banco.\n' +
      '    XP diário, níveis e insígnias ficam zerados até você rodar,\n' +
      '    no SQL Editor do Supabase e COM NADA SELECIONADO:\n\n' +
      '        db/setup.sql\n');
  }
  return true;
}

/** Trata "tabela não existe" como lista vazia; qualquer outro erro sobe. */
function ouVazio(resposta) {
  if (resposta.error && faltaTabela(resposta.error)) return { data: [], error: null };
  return resposta;
}

// O dia "de verdade" é o de quem joga, não o do servidor. Sem fixar o
// fuso, quem entra às 22h no Brasil já conta como o dia seguinte em UTC
// e ganharia o prêmio duas vezes na mesma noite.
const FUSO = 'America/Sao_Paulo';
const UM_DIA = 24 * 60 * 60 * 1000;

/* ═══════════════════════════════════════════════════════════════════
   A ESCADA DE NÍVEIS

   Os degraus são ABSOLUTOS e nunca mudam. A alternativa — derivar os
   degraus do conteúdo existente, como recalcular_metas() faz com as
   barras — tem um defeito fatal aqui: quando a equipe de Medicina
   subisse 200 questões novas, a escada esticaria e todo mundo CAIRIA de
   nível. Perder um nível por causa de uma mudança que não foi sua é a
   pior coisa que um jogo pode fazer com quem joga.

   Então, quando o conteúdo crescer, acrescentam-se degraus no TOPO.
   Ninguém desce nunca.

   Calibragem: 2.250 XP de conteúdo + 50/dia. Quem responder tudo e
   entrar por um mês chega perto do nível 7.
   ═══════════════════════════════════════════════════════════════════ */

const NIVEIS = [
  { nivel: 1,  xp: 0,    titulo: 'Visitante' },
  { nivel: 2,  xp: 150,  titulo: 'Aprendiz' },
  { nivel: 3,  xp: 400,  titulo: 'Explorador' },
  { nivel: 4,  xp: 800,  titulo: 'Agente Comunitário' },
  { nivel: 5,  xp: 1400, titulo: 'Cuidador' },
  { nivel: 6,  xp: 2200, titulo: 'Guardião do Bairro' },
  { nivel: 7,  xp: 3200, titulo: 'Herói da Saúde' },
  { nivel: 8,  xp: 4500, titulo: 'Herói Veterano' },
  { nivel: 9,  xp: 6000, titulo: 'Lenda do Bairro' },
  { nivel: 10, xp: 8000, titulo: 'Lenda da Saúde' }
];

/**
 * Em que degrau este XP cai, e quanto falta para o próximo.
 *
 * Devolve também `porcentagem`, que é o quanto a barra do nível deve
 * mostrar — e ela é do TRECHO atual, não do total. Uma barra que fosse
 * do zero ao nível 10 quase não se mexeria no começo.
 */
function nivelDoXp(xp) {
  const total = Math.max(0, Number(xp) || 0);

  let atual = NIVEIS[0];
  for (const degrau of NIVEIS) if (total >= degrau.xp) atual = degrau;

  const proximo = NIVEIS.find(d => d.nivel === atual.nivel + 1) || null;

  // No último nível a barra fica cheia: não há mais degrau, e mostrar
  // uma barra pela metade sugeriria que falta algo que não existe.
  if (!proximo) {
    return {
      nivel: atual.nivel, titulo: atual.titulo, xp: total,
      xp_do_nivel: atual.xp, xp_do_proximo: null,
      faltam: 0, porcentagem: 100, maximo: true
    };
  }

  const trecho = proximo.xp - atual.xp;
  const andado = total - atual.xp;

  return {
    nivel: atual.nivel,
    titulo: atual.titulo,
    xp: total,
    xp_do_nivel: atual.xp,
    xp_do_proximo: proximo.xp,
    faltam: proximo.xp - total,
    porcentagem: Math.min(100, Math.round((andado / trecho) * 100)),
    maximo: false
  };
}

/* ═══════════════════════════════════════════════════════════════════
   DIAS
   ═══════════════════════════════════════════════════════════════════ */

/** '2026-10-01' no fuso de quem joga. 'en-CA' é o formato ano-mês-dia. */
function diaLocal(quando) {
  return new Date(quando).toLocaleDateString('en-CA', { timeZone: FUSO });
}

/**
 * Há quantos dias seguidos a pessoa aparece, a partir de uma lista de
 * dias já em texto ('2026-10-01').
 *
 * A sequência continua viva se o último dia for hoje OU ontem — quem
 * entrou ontem à noite e abre o jogo hoje de manhã não pode ver a
 * sequência zerada por ainda não ter feito nada hoje.
 */
function sequenciaDeDias(dias) {
  const ordenados = [...new Set(dias)].sort().reverse();
  if (!ordenados.length) return { dias_jogados: 0, streak_dias: 0, jogou_hoje: false };

  const hoje = diaLocal(Date.now());
  const ontem = diaLocal(Date.now() - UM_DIA);

  let seguidos = 0;

  if (ordenados[0] === hoje || ordenados[0] === ontem) {
    seguidos = 1;

    for (let i = 1; i < ordenados.length; i++) {
      // O meio-dia evita a armadilha do horário de verão: somar ou tirar
      // 24h de uma meia-noite pode cair no dia errado, do meio-dia nunca.
      const esperado = new Date(ordenados[i - 1] + 'T12:00:00Z');
      esperado.setUTCDate(esperado.getUTCDate() - 1);

      if (esperado.toISOString().slice(0, 10) !== ordenados[i]) break;
      seguidos++;
    }
  }

  return { dias_jogados: ordenados.length, streak_dias: seguidos, jogou_hoje: ordenados[0] === hoje };
}

/**
 * Marca presença de hoje e devolve se o prêmio foi ganho AGORA.
 *
 * Quem garante "uma vez por dia" é a chave primária (usuario_id, dia),
 * não um if daqui. Duas abas abertas, dois cliques no mesmo segundo, a
 * página recarregando: o banco recusa o segundo insert e `ganhou` volta
 * false. Nenhuma corrida entre requisições consegue furar isso.
 */
async function marcarPresenca(usuarioId) {
  const hoje = diaLocal(Date.now());

  const r = await admin
    .from('xp_diario')
    .insert({ usuario_id: usuarioId, dia: hoje, pontos: XP_DIARIO })
    .select('dia')
    .maybeSingle();

  // 23505 = unique_violation. Aqui não é erro: é "já passou hoje".
  if (r.error && r.error.code === '23505') return { ganhou: false, pontos: 0, dia: hoje };

  // Tabela ainda não criada: ninguém ganha prêmio, mas a visita continua.
  if (r.error && faltaTabela(r.error)) return { ganhou: false, pontos: 0, dia: hoje };

  if (r.error) return { ganhou: false, pontos: 0, dia: hoje, erro: r.error };

  return { ganhou: true, pontos: XP_DIARIO, dia: hoje };
}

/* ═══════════════════════════════════════════════════════════════════
   O RETRATO DE XP DE UMA PESSOA
   ═══════════════════════════════════════════════════════════════════ */

/** usuario_id -> Set das questões distintas que ele acertou. */
function acertosUnicosPorAluno(linhas) {
  const porAluno = new Map();

  for (const l of linhas) {
    if (!porAluno.has(l.usuario_id)) porAluno.set(l.usuario_id, new Set());
    porAluno.get(l.usuario_id).add(l.questao_id);
  }

  return porAluno;
}

/**
 * O XP de um ALUNO, somado das três fontes, mais o nível que isso dá.
 *
 * `respostas` pode vir pronto de quem já leu a tabela — /meu-resumo lê
 * as respostas de qualquer jeito, e reler aqui seria a segunda viagem
 * ao banco para a mesma pergunta.
 */
async function xpDoAluno(usuarioId, respostas = null) {
  if (!respostas) {
    const r = await lerTudo(() => admin
      .from('respostas_alunos')
      .select('questao_id, acertou, data_resposta, quiz_id')
      .eq('usuario_id', usuarioId)
      .order('id'));

    if (r.error) return { erro: r.error };
    respostas = r.data;
  }

  const certas = respostas.filter(r => r.acertou);
  const distintas = new Set(certas.map(r => r.questao_id));

  const [bruto1, bruto2] = await Promise.all([
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId)
  ]);

  const dias = ouVazio(bruto1);
  const ganhas = ouVazio(bruto2);

  if (dias.error) return { erro: dias.error };
  if (ganhas.error) return { erro: ganhas.error };

  const deQuestoes = distintas.size * XP_POR_QUESTAO;
  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);

  const total = deQuestoes + deDias + deInsignias;

  // Os dias que contam para a SEQUÊNCIA são os de presença, não os de
  // resposta: a pessoa que entra todo dia mantém a sequência mesmo nos
  // dias em que não teve tempo de jogar.
  const presencas = sequenciaDeDias((dias.data || []).map(d => d.dia));

  return {
    total,
    de_questoes: deQuestoes,
    de_dias: deDias,
    de_insignias: deInsignias,
    acertos_unicos: distintas.size,
    nivel: nivelDoXp(total),
    ...presencas,
    insignias: ganhas.data || [],
    respostas
  };
}

/* ═══════════════════════════════════════════════════════════════════
   INSÍGNIAS

   A regra de cada uma está na TABELA, não aqui. Este código sabe
   comparar um número com um alvo; quais são os alvos, quantas insígnias
   existem e como elas se chamam é dado, e muda com um insert.

   É o que permite o outro desenvolvedor acrescentar insígnias e artes
   sem abrir um arquivo .js.
   ═══════════════════════════════════════════════════════════════════ */

/**
 * Confere a estante inteira e grava o que acabou de ser conquistado.
 *
 * `medidas` é o placar da pessoa por tipo de regra:
 *   { ACERTOS: 62, DIAS: 4, MISSOES: 2 }
 *
 * Uma regra que não estiver em `medidas` é simplesmente pulada — é
 * assim que o professor não ganha insígnia de aluno e vice-versa, mesmo
 * que alguém se engane ao cadastrar uma linha nova.
 *
 * Devolve só as NOVAS, para a tela poder comemorar. Conquistar de novo
 * não acontece: a chave primária (usuario_id, insignia_codigo) recusa.
 */
async function conquistar(usuarioId, publico, medidas) {
  const catalogo = ouVazio(await admin
    .from('insignias')
    .select('codigo, nome, descricao, regra, alvo, xp, imagem, ordem')
    .eq('publico', publico)
    .order('ordem'));

  if (catalogo.error || !catalogo.data?.length) return [];

  const jaTem = ouVazio(await admin
    .from('insignias_usuarios')
    .select('insignia_codigo')
    .eq('usuario_id', usuarioId));

  if (jaTem.error) return [];

  const tenho = new Set((jaTem.data || []).map(i => i.insignia_codigo));

  const merecidas = catalogo.data.filter(i =>
    !tenho.has(i.codigo) &&
    medidas[i.regra] !== undefined &&
    medidas[i.regra] >= i.alvo
  );

  if (!merecidas.length) return [];

  // upsert com ignoreDuplicates, e não insert: duas abas pedindo ao
  // mesmo tempo chegariam aqui com a mesma lista, e um insert comum
  // derrubaria a segunda inteira por causa de uma linha que a primeira
  // acabou de gravar.
  //
  // Com resolution=ignore-duplicates o PostgREST devolve SÓ as linhas
  // que ele realmente inseriu — que é exatamente a definição de "novas".
  const gravou = await admin
    .from('insignias_usuarios')
    .upsert(merecidas.map(i => ({ usuario_id: usuarioId, insignia_codigo: i.codigo })),
            { onConflict: 'usuario_id,insignia_codigo', ignoreDuplicates: true })
    .select('insignia_codigo');

  if (gravou.error) return [];

  const gravadas = new Set((gravou.data || []).map(i => i.insignia_codigo));
  return merecidas.filter(i => gravadas.has(i.codigo));
}

/**
 * O placar de um aluno, no formato que `conquistar` espera.
 *
 * MISSOES conta quizzes da turma em que todas as questões já foram
 * acertadas — a mesma conta da lista do mapa e da tela de progresso.
 * Se as três discordassem, o aluno veria três números para a mesma
 * coisa.
 */
async function medirAluno(usuarioId, turmaId, retrato) {
  const medidas = {
    ACERTOS: retrato.acertos_unicos,
    DIAS: retrato.streak_dias,
    MISSOES: 0
  };

  if (!turmaId) return medidas;

  const quizzes = await admin
    .from('quizzes_professores').select('id').eq('turma_id', turmaId);

  const ids = (quizzes.data || []).map(q => q.id);
  if (!ids.length) return medidas;

  const vinculos = await lerTudo(() => admin
    .from('quiz_questoes').select('quiz_id, questao_id')
    .in('quiz_id', ids).order('quiz_id').order('questao_id'));

  if (vinculos.error) return medidas;

  const total = new Map();
  for (const v of vinculos.data) total.set(v.quiz_id, (total.get(v.quiz_id) || 0) + 1);

  const prontas = new Map();
  for (const r of retrato.respostas.filter(r => r.acertou && r.quiz_id)) {
    if (!prontas.has(r.quiz_id)) prontas.set(r.quiz_id, new Set());
    prontas.get(r.quiz_id).add(r.questao_id);
  }

  medidas.MISSOES = ids.filter(id =>
    (total.get(id) || 0) > 0 && (prontas.get(id) || new Set()).size >= total.get(id)).length;

  return medidas;
}

/* ═══════════════════════════════════════════════════════════════════
   O PROFESSOR

   Ele não responde pergunta nenhuma, então o XP dele não pode sair de
   respostas_alunos como o do aluno. Sai das duas coisas que ele de fato
   faz: PASSAR tarefa e ter uma turma que avança.

   O peso é deliberado. 50 por quiz criado reconhece o trabalho de
   montar a tarefa; 1 por acerto distinto dos alunos faz o professor
   subir junto com a turma, sem que uma turma grande valha mais que uma
   turma que aprende — são os acertos que contam, não a quantidade de
   gente matriculada.
   ═══════════════════════════════════════════════════════════════════ */

const XP_POR_QUIZ_CRIADO = 50;
const XP_POR_ACERTO_DA_TURMA = 1;

async function xpDoProfessor(usuarioId) {
  const [quizzes, turmas, brutoDias, brutoGanhas] = await Promise.all([
    admin.from('quizzes_professores').select('id', { count: 'exact', head: true })
      .eq('professor_id', usuarioId),
    admin.from('turmas').select('id').eq('professor_id', usuarioId),
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId)
  ]);

  const dias = ouVazio(brutoDias);
  const ganhas = ouVazio(brutoGanhas);

  const criados = quizzes.count || 0;
  const idsTurmas = (turmas.data || []).map(t => t.id);

  let acertosDaTurma = 0;

  if (idsTurmas.length) {
    const alunos = await admin.from('usuarios').select('id')
      .eq('tipo', 'ALUNO').in('turma_id', idsTurmas);

    const ids = (alunos.data || []).map(a => a.id);

    if (ids.length) {
      const respostas = await lerTudo(() => admin
        .from('respostas_alunos').select('usuario_id, questao_id')
        .eq('acertou', true).in('usuario_id', ids)
        .order('usuario_id').order('questao_id'));

      if (!respostas.error) {
        // Distintas POR ALUNO: a mesma questão acertada por dois alunos
        // conta duas vezes, porque são dois aprendizados.
        const porAluno = acertosUnicosPorAluno(respostas.data);
        for (const s of porAluno.values()) acertosDaTurma += s.size;
      }
    }
  }

  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deQuizzes = criados * XP_POR_QUIZ_CRIADO;
  const deTurmas = acertosDaTurma * XP_POR_ACERTO_DA_TURMA;

  // Hoje dá zero, porque não há insígnia de professor cadastrada. Está
  // aqui para que, no dia em que houver, o XP dele já conte — e não vire
  // um bug silencioso de "conquistei e o total não mudou".
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);

  const total = deQuizzes + deTurmas + deDias + deInsignias;

  return {
    total,
    de_quizzes: deQuizzes,
    de_turmas: deTurmas,
    de_dias: deDias,
    de_insignias: deInsignias,
    insignias: ganhas.data || [],
    quizzes_criados: criados,
    acertos_da_turma: acertosDaTurma,
    nivel: nivelDoXp(total),
    ...sequenciaDeDias((dias.data || []).map(d => d.dia)),
    medidas: { QUIZZES: criados, ACERTOS_TURMA: acertosDaTurma }
  };
}

module.exports = {
  XP_POR_QUESTAO, XP_DIARIO, XP_POR_QUIZ_CRIADO, XP_POR_ACERTO_DA_TURMA,
  NIVEIS, FUSO,
  faltaTabela, ouVazio,
  nivelDoXp, diaLocal, sequenciaDeDias, marcarPresenca,
  acertosUnicosPorAluno, xpDoAluno, xpDoProfessor,
  conquistar, medirAluno
};
