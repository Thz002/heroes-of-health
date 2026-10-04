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

const TOTAL_DE_NIVEIS = 20;

/**
 * Os degraus, gerados por fórmula e não escritos à mão.
 *
 * O degrau n custa 60 + 30·(n-2) XP a mais que o anterior: o primeiro
 * sai por 60, o décimo por 340, o vigésimo por 880. A soma dá 7.920 XP
 * para chegar ao nível 20.
 *
 * ESSE NÚMERO NÃO É ARBITRÁRIO. É o que um aluno dedicado consegue
 * juntar com o conteúdo que existe hoje:
 *
 *     2.250  acertar as 225 perguntas do banco
 *     ~900   bônus de conclusão dos quizzes
 *     2.750  as dez insígnias
 *     1.500  trinta dias de presença
 *     ─────
 *     ~7.400
 *
 * Ou seja: o nível 20 é "fiz tudo o que havia para fazer, e apareci".
 * Uma escada calibrada acima disso deixaria os últimos degraus
 * inalcançáveis — e um nível que ninguém alcança não é objetivo, é
 * enfeite.
 *
 * Quando o conteúdo crescer, acrescentam-se degraus NO TOPO. Mexer nos
 * de baixo faria quem já subiu descer, e isso o jogo não faz.
 */
const NIVEIS = Array.from({ length: TOTAL_DE_NIVEIS }, (_, i) => {
  const nivel = i + 1;
  let xp = 0;
  for (let n = 2; n <= nivel; n++) xp += 60 + 30 * (n - 2);
  return { nivel, xp };
});

/* ── As patentes ──────────────────────────────────────────────────────
 *
 * O NÚMERO do nível é o mesmo para os dois papéis; o NOME muda, porque
 * o que cada um está construindo é diferente. O aluno aprende, o
 * professor ensina — e o jogo não deveria chamar os dois da mesma coisa.
 *
 * As faixas são 1–10 e 11–20. O pedido dizia "1-10" e "10-20", e o 10
 * não pode pertencer às duas: aqui ele fecha a primeira faixa, para que
 * passar de 10 para 11 seja a troca de patente — um degrau que se sente.
 */
const PATENTES = {
  ALUNO:     [{ ate: 10, nome: 'Pequeno Aprendiz' }, { ate: 20, nome: 'Estudante' }],
  PROFESSOR: [{ ate: 10, nome: 'Monitor' },          { ate: 20, nome: 'Mentor Iniciante' }]
};

function patenteDe(nivel, tipo) {
  const faixas = PATENTES[tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO'];
  return (faixas.find(f => nivel <= f.ate) || faixas[faixas.length - 1]).nome;
}

/**
 * Em que degrau este XP cai, e quanto falta para o próximo.
 *
 * Devolve também `porcentagem`, que é o quanto a barra do nível deve
 * mostrar — e ela é do TRECHO atual, não do total. Uma barra que fosse
 * do zero ao nível 10 quase não se mexeria no começo.
 */
function nivelDoXp(xp, tipo = 'ALUNO') {
  const total = Math.max(0, Number(xp) || 0);

  let atual = NIVEIS[0];
  for (const degrau of NIVEIS) if (total >= degrau.xp) atual = degrau;

  const proximo = NIVEIS.find(d => d.nivel === atual.nivel + 1) || null;
  const patente = patenteDe(atual.nivel, tipo);

  // No último nível a barra fica cheia: não há mais degrau, e mostrar
  // uma barra pela metade sugeriria que falta algo que não existe.
  if (!proximo) {
    return {
      nivel: atual.nivel, patente, titulo: patente, xp: total,
      xp_do_nivel: atual.xp, xp_do_proximo: null,
      faltam: 0, porcentagem: 100, maximo: true,
      total_de_niveis: TOTAL_DE_NIVEIS, proxima_patente: null
    };
  }

  const trecho = proximo.xp - atual.xp;
  const andado = total - atual.xp;

  // A próxima patente só é anunciada quando ela está no degrau seguinte.
  // Avisar com dez níveis de antecedência não é promessa, é ruído.
  const patenteDoProximo = patenteDe(proximo.nivel, tipo);

  return {
    nivel: atual.nivel,
    patente,
    titulo: patente,                // nome antigo, mantido para não quebrar telas
    xp: total,
    xp_do_nivel: atual.xp,
    xp_do_proximo: proximo.xp,
    faltam: proximo.xp - total,
    porcentagem: Math.min(100, Math.round((andado / trecho) * 100)),
    maximo: false,
    total_de_niveis: TOTAL_DE_NIVEIS,
    proxima_patente: patenteDoProximo !== patente ? patenteDoProximo : null
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

  const [bruto1, bruto2, bruto3] = await Promise.all([
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId),
    admin.from('quiz_concluidos')
      .select('xp_aluno, taxa, perguntas, concluido_em').eq('usuario_id', usuarioId)
  ]);

  const dias = ouVazio(bruto1);
  const ganhas = ouVazio(bruto2);
  const conclusoes = ouVazio(bruto3);

  if (dias.error) return { erro: dias.error };
  if (ganhas.error) return { erro: ganhas.error };
  if (conclusoes.error) return { erro: conclusoes.error };

  const feitos = conclusoes.data || [];

  const deQuestoes = distintas.size * XP_POR_QUESTAO;
  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);
  const deConclusoes = feitos.reduce((s, c) => s + (c.xp_aluno || 0), 0);

  const total = deQuestoes + deDias + deInsignias + deConclusoes;

  // Os dias que contam para a SEQUÊNCIA são os de presença, não os de
  // resposta: a pessoa que entra todo dia mantém a sequência mesmo nos
  // dias em que não teve tempo de jogar.
  const presencas = sequenciaDeDias((dias.data || []).map(d => d.dia));

  return {
    total,
    de_questoes: deQuestoes,
    de_dias: deDias,
    de_insignias: deInsignias,
    de_conclusoes: deConclusoes,
    acertos_unicos: distintas.size,
    conclusoes: feitos.length,
    nivel: nivelDoXp(total, 'ALUNO'),
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
   O PRÊMIO DE CONCLUIR UM QUIZ

   O evento que liga o aluno ao professor. Quando um questionário é
   fechado, os dois ganham — e o quanto depende de quantas tentativas
   foram precisas.

   A TAXA. Concluir exige acertar todas as perguntas, então "acertos"
   é sempre o total. O que varia é quantas RESPOSTAS a pessoa deu até
   lá. Dez perguntas em dez respostas = 1.00, sabia tudo. Dez perguntas
   em vinte respostas = 0.50, chegou lá tentando.

   Isso fecha dois furos de uma vez. O aluno não ganha mais martelando
   alternativa até passar; e o professor não ganha mais por ter dado uma
   tarefa fácil, porque o que conta não é o acerto bruto, é o aluno ter
   chegado sabendo.

   POR QUE O PRÊMIO É PROPORCIONAL AO TAMANHO: sem isso, dez quizzes de
   3 perguntas pagariam dez vezes mais que um de 30 — e criar quiz de
   três perguntas em série viraria a forma mais rápida de subir de
   nível. Multiplicando pelo tamanho, 10×3 e 1×30 valem igual, e a
   fábrica de quizzes deixa de ser atalho.
   ═══════════════════════════════════════════════════════════════════ */

const XP_CONCLUSAO_ALUNO = 5;        // × perguntas × taxa
const XP_CONCLUSAO_PROFESSOR = 20;   // × perguntas × qualidade, DIVIDIDO pela turma

/**
 * @param perguntas  quantas questões o quiz tinha
 * @param respostas  quantas o aluno deu até fechar
 * @param alunos     quantos alunos existem na turma
 *
 * A DIVISÃO PELO TAMANHO DA TURMA É O PONTO. Sem ela, uma simulação de
 * um semestre mostrou o professor batendo o nível 20 na semana 12,
 * enquanto o aluno dele chegava ao 14 — porque cada aluno que terminava
 * pagava o prêmio inteiro, e vinte e cinco alunos pagavam vinte e cinco
 * vezes.
 *
 * O efeito perverso era pior do que parecer rápido: o professor subia
 * por ter turma GRANDE, não por ensinar bem. Dividindo, o prêmio total
 * de um questionário é o mesmo para uma turma de 5 e uma de 40 — e o
 * que muda entre eles passa a ser a única coisa que deveria importar,
 * que é com quanta facilidade a turma chegou lá.
 *
 * A barra continua andando a cada aluno que termina: cada um entrega
 * a sua fração.
 */
function premioDeConclusao(perguntas, respostas, alunos = 1) {
  const taxa = respostas > 0 ? Math.min(1, perguntas / respostas) : 0;
  const turma = Math.max(1, alunos);

  // Metade garantida, metade pela taxa. A garantida existe porque a
  // tarefa foi cumprida — isso já é trabalho do professor. A outra
  // metade é o quanto a turma chegou pronta.
  const doQuizInteiro = perguntas * XP_CONCLUSAO_PROFESSOR * (0.5 + 0.5 * taxa);

  return {
    taxa,
    // O aluno ganha pela taxa inteira: quem precisou de muitas
    // tentativas concluiu do mesmo jeito, mas o prêmio reconhece quem
    // chegou sabendo.
    aluno: Math.round(perguntas * XP_CONCLUSAO_ALUNO * taxa),

    // Pelo menos 1: numa turma muito grande a fração arredondaria para
    // zero, e um aluno terminar nunca pode valer nada.
    professor: Math.max(1, Math.round(doQuizInteiro / turma))
  };
}

/* ═══════════════════════════════════════════════════════════════════
   O PROFESSOR

   Ele não responde pergunta nenhuma, então o XP dele não pode sair de
   respostas_alunos como o do aluno. Sai inteiro de como a turma avança
   — que é exatamente a ideia do jogo: um educador não melhora sozinho,
   melhora tendo com quem praticar.

   CRIAR QUIZ NÃO DÁ MAIS XP, e essa mudança merece explicação. Antes
   eram 50 por quiz criado, e era um buraco: criar cinquenta quizzes que
   ninguém respondesse valia 2.500 XP de trabalho nenhum. Agora o quiz
   só rende quando um aluno o conclui. Tarefa que a turma não faz não
   ensinou ninguém, e portanto não promove o professor.

   Sobram duas fontes, e as duas dependem da turma:

     1 XP   por questão distinta que um aluno dele acertou
            — faz a barra andar continuamente, pergunta a pergunta
     prêmio por quiz concluído por um aluno
            — o marco, calculado em premioDeConclusao()
   ═══════════════════════════════════════════════════════════════════ */

const XP_POR_ACERTO_DA_TURMA = 1;

async function xpDoProfessor(usuarioId) {
  const [quizzes, turmas, brutoDias, brutoGanhas, brutoConclusoes] = await Promise.all([
    admin.from('quizzes_professores').select('id', { count: 'exact', head: true })
      .eq('professor_id', usuarioId),
    admin.from('turmas').select('id').eq('professor_id', usuarioId),
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId),
    admin.from('quiz_concluidos')
      .select('xp_professor, taxa, perguntas, concluido_em')
      .eq('professor_id', usuarioId)
  ]);

  const dias = ouVazio(brutoDias);
  const ganhas = ouVazio(brutoGanhas);
  const conclusoes = ouVazio(brutoConclusoes);

  const criados = quizzes.count || 0;
  const idsTurmas = (turmas.data || []).map(t => t.id);

  let acertosDaTurma = 0;
  let quantosAlunos = 0;

  if (idsTurmas.length) {
    const alunos = await admin.from('usuarios').select('id')
      .eq('tipo', 'ALUNO').in('turma_id', idsTurmas);

    const ids = (alunos.data || []).map(a => a.id);
    quantosAlunos = ids.length;

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

  const feitos = conclusoes.data || [];

  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deConclusoes = feitos.reduce((s, c) => s + (c.xp_professor || 0), 0);

  // MÉDIA por aluno, e não soma: somar fazia uma turma de 40 render
  // quatro vezes mais que uma de 10 ensinando igual. Assim o número
  // significa "o quanto um aluno meu típico já aprendeu", que é o que
  // o professor de fato constrói — e tem teto no conteúdo que existe.
  const mediaDeAcertos = quantosAlunos ? Math.round(acertosDaTurma / quantosAlunos) : 0;
  const deTurmas = mediaDeAcertos * XP_POR_ACERTO_DA_TURMA;

  // Hoje dá zero, porque não há insígnia de professor cadastrada. Está
  // aqui para que, no dia em que houver, o XP dele já conte — e não vire
  // um bug silencioso de "conquistei e o total não mudou".
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);

  const total = deTurmas + deConclusoes + deDias + deInsignias;

  // A média das taxas é o número que resume o ensino dele: perto de 1,
  // a turma chega sabendo; perto de 0,5, ela chega tentando. Vai para a
  // tela do professor porque é a informação que ele pode USAR.
  const taxaMedia = feitos.length
    ? feitos.reduce((s, c) => s + c.taxa, 0) / feitos.length
    : null;

  return {
    total,
    de_turmas: deTurmas,
    de_conclusoes: deConclusoes,
    de_dias: deDias,
    de_insignias: deInsignias,
    insignias: ganhas.data || [],
    quizzes_criados: criados,
    acertos_da_turma: acertosDaTurma,
    media_de_acertos: mediaDeAcertos,
    total_alunos: quantosAlunos,
    conclusoes: feitos.length,
    taxa_media: taxaMedia === null ? null : Math.round(taxaMedia * 100),
    nivel: nivelDoXp(total, 'PROFESSOR'),
    ...sequenciaDeDias((dias.data || []).map(d => d.dia)),
    medidas: { QUIZZES: criados, ACERTOS_TURMA: acertosDaTurma, CONCLUSOES: feitos.length }
  };
}

/**
 * O XP completo de VÁRIAS pessoas de uma vez.
 *
 * Existe porque o ranking da turma estava mentindo: ele somava só
 * `acertos × 10` e ignorava presença, insígnias e conclusões. Um aluno
 * com 250 XP no próprio perfil aparecia com 90 na lista da turma — dois
 * números para a mesma coisa, que é como ninguém acaba confiando em
 * nenhum.
 *
 * Em lote, e não um xpDoAluno() por pessoa: uma turma de 40 daria 160
 * consultas ao banco para desenhar uma lista.
 */
async function xpDeVarios(ids) {
  const vazio = new Map(ids.map(id => [id, 0]));
  if (!ids.length) return vazio;

  const [certas, dias, insignias, conclusoes] = await Promise.all([
    lerTudo(() => admin.from('respostas_alunos').select('usuario_id, questao_id')
      .eq('acertou', true).in('usuario_id', ids).order('usuario_id').order('questao_id')),
    admin.from('xp_diario').select('usuario_id, pontos').in('usuario_id', ids),
    admin.from('insignias_usuarios').select('usuario_id, insignias(xp)').in('usuario_id', ids),
    admin.from('quiz_concluidos').select('usuario_id, xp_aluno').in('usuario_id', ids)
  ]);

  const total = new Map(ids.map(id => [id, 0]));
  const soma = (id, quanto) => total.has(id) && total.set(id, total.get(id) + quanto);

  if (!certas.error) {
    for (const [id, set] of acertosUnicosPorAluno(certas.data)) soma(id, set.size * XP_POR_QUESTAO);
  }
  for (const d of ouVazio(dias).data || []) soma(d.usuario_id, d.pontos || 0);
  for (const i of ouVazio(insignias).data || []) soma(i.usuario_id, i.insignias?.xp || 0);
  for (const c of ouVazio(conclusoes).data || []) soma(c.usuario_id, c.xp_aluno || 0);

  return total;
}

/**
 * Chamada a cada acerto: se este foi o que fechou o quiz, grava o marco
 * e devolve o que os dois ganharam. Senão, devolve null.
 *
 * TRÊS COISAS QUE ELA SE RECUSA A FAZER:
 *
 * 1. Premiar o professor pelo próprio quiz. A rota /responder deixa ele
 *    responder a tarefa que criou, para testar — e sem esta trava ele
 *    subiria de nível sozinho, sem aluno nenhum, que é o oposto do que
 *    o jogo quer medir.
 *
 * 2. Gravar duas vezes. A chave (usuario_id, quiz_id) recusa a segunda,
 *    e o código trata 23505 como "já era", não como erro.
 *
 * 3. Contar um quiz vazio. Quiz sem questão tem total 0, e 0 >= 0 seria
 *    "concluído" no primeiro acesso.
 */
async function registrarConclusao(usuario, quizId) {
  const quiz = await admin
    .from('quizzes_professores').select('professor_id').eq('id', quizId).maybeSingle();

  if (quiz.error || !quiz.data) return null;

  // O professor testando a própria tarefa não gera marco para ninguém.
  if (quiz.data.professor_id === usuario.id) return null;

  const [vinculos, respostas, turma] = await Promise.all([
    admin.from('quiz_questoes').select('questao_id', { count: 'exact', head: true })
      .eq('quiz_id', quizId),
    lerTudo(() => admin.from('respostas_alunos')
      .select('questao_id, acertou').eq('usuario_id', usuario.id).eq('quiz_id', quizId)
      .order('id')),
    admin.from('usuarios').select('id', { count: 'exact', head: true })
      .eq('turma_id', usuario.turma_id || 0).eq('tipo', 'ALUNO')
  ]);

  const perguntas = vinculos.count || 0;
  if (!perguntas || respostas.error) return null;

  const dadas = respostas.data.length;
  const certas = new Set(respostas.data.filter(r => r.acertou).map(r => r.questao_id));

  if (certas.size < perguntas) return null;          // ainda falta pergunta

  // O tamanho da turma NO MOMENTO da conclusão. Fica congelado na linha
  // gravada: se alguém entrar ou sair da turma depois, o que já foi
  // ganho não muda.
  const premio = premioDeConclusao(perguntas, dadas, turma.count || 1);

  const r = await admin.from('quiz_concluidos').insert({
    usuario_id: usuario.id,
    quiz_id: quizId,
    professor_id: quiz.data.professor_id,
    perguntas,
    respostas: dadas,
    taxa: premio.taxa,
    xp_aluno: premio.aluno,
    xp_professor: premio.professor
  }).select('concluido_em').maybeSingle();

  // 23505 = já estava gravado. Concluir de novo não existe.
  if (r.error && r.error.code === '23505') return null;
  if (r.error && faltaTabela(r.error)) return null;
  if (r.error) return null;

  return {
    perguntas,
    respostas: dadas,
    taxa: Math.round(premio.taxa * 100),
    xp_aluno: premio.aluno,
    xp_professor: premio.professor
  };
}

module.exports = {
  XP_POR_QUESTAO, XP_DIARIO, XP_POR_ACERTO_DA_TURMA,
  XP_CONCLUSAO_ALUNO, XP_CONCLUSAO_PROFESSOR,
  NIVEIS, TOTAL_DE_NIVEIS, PATENTES, FUSO,
  faltaTabela, ouVazio,
  nivelDoXp, patenteDe, diaLocal, sequenciaDeDias, marcarPresenca,
  acertosUnicosPorAluno, xpDoAluno, xpDoProfessor, xpDeVarios,
  premioDeConclusao, registrarConclusao,
  conquistar, medirAluno
};
