/** XP, nível e insígnias, calculados no servidor.
    XP: 10 por questão distinta acertada, 50 por dia de presença, insígnias, conclusões e ajustes do admin. */

const { admin } = require('./supabase');
const { lerTudo } = require('./lerTudo');

const XP_POR_QUESTAO = 10;
const XP_DIARIO = 50;

/* Tabela que ainda não existe no banco vira lista vazia, não erro. */
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

// Dia contado no fuso de quem joga.
const FUSO = 'America/Sao_Paulo';
const UM_DIA = 24 * 60 * 60 * 1000;

/* ── A escada de níveis ──
   Degraus fixos (ninguém cai de nível); novos degraus entram só no topo. */

const TOTAL_DE_NIVEIS = 100;

/* Custo de um degrau: 50 XP + 3 por nível já passado. */
const DEGRAU_BASE = 50;
const DEGRAU_PASSO = 3;

/** Degraus gerados por fórmula (nível 100 = 19.503 XP). */
const NIVEIS = Array.from({ length: TOTAL_DE_NIVEIS }, (_, i) => {
  const nivel = i + 1;
  let xp = 0;
  for (let n = 2; n <= nivel; n++) xp += DEGRAU_BASE + DEGRAU_PASSO * (n - 2);
  return { nivel, xp };
});

/* Patentes: dez faixas de dez níveis (ate é inclusivo e em ordem crescente). */
const PATENTES = {
  ALUNO: [
    { ate:  10, nome: 'Pequeno Aprendiz'  },
    { ate:  20, nome: 'Estudante'         },
    { ate:  30, nome: 'Discípulo'         },
    { ate:  40, nome: 'Buscador'          },
    { ate:  50, nome: 'Erudito'           },
    { ate:  60, nome: 'Prodígio'          },
    { ate:  70, nome: 'Visionário'        },
    { ate:  80, nome: 'Polímata'          },
    { ate:  90, nome: 'Luminar'           },
    { ate: 100, nome: 'Herdeiro do Saber' }
  ],
  PROFESSOR: [
    { ate:  10, nome: 'Monitor'                 },
    { ate:  20, nome: 'Mentor Iniciante'        },
    { ate:  30, nome: 'Instrutor'               },
    { ate:  40, nome: 'Preceptor'               },
    { ate:  50, nome: 'Mestre do Saber'         },
    { ate:  60, nome: 'Arquimestre'             },
    { ate:  70, nome: 'Grão-Mestre'             },
    { ate:  80, nome: 'Venerável'               },
    { ate:  90, nome: 'Oráculo'                 },
    { ate: 100, nome: 'Patrono do Conhecimento' }
  ]
};

/* Patentes da tabela `patentes` substituem as padrão (cache de 1 minuto). */
let patentesDoBanco = null;
let patentesLidasEm = 0;
const VALIDADE_DO_CACHE = 60_000;

async function carregarPatentes() {
  if (patentesDoBanco && Date.now() - patentesLidasEm < VALIDADE_DO_CACHE) return;

  const r = await admin.from('patentes').select('tipo, ate, nome').order('ate');

  // Sem a tabela, usa as faixas do código.
  if (r.error || !r.data?.length) { patentesDoBanco = null; return; }

  const mapa = { ALUNO: [], PROFESSOR: [] };
  for (const f of r.data) if (mapa[f.tipo]) mapa[f.tipo].push({ ate: f.ate, nome: f.nome });
  patentesDoBanco = (mapa.ALUNO.length && mapa.PROFESSOR.length) ? mapa : null;
  patentesLidasEm = Date.now();
}

/** Esquece o cache. Chamada pela rota que grava as patentes. */
function esquecerPatentes() { patentesDoBanco = null; patentesLidasEm = 0; }

/** Faixa do nível: nome e posição (1 a 10, usada para a cor). */
function faixaDe(nivel, tipo) {
  const chave = tipo === 'PROFESSOR' ? 'PROFESSOR' : 'ALUNO';
  const faixas = (patentesDoBanco && patentesDoBanco[chave]) || PATENTES[chave];

  let i = faixas.findIndex(f => nivel <= f.ate);
  if (i < 0) i = faixas.length - 1;

  return { nome: faixas[i].nome, indice: i + 1, de: faixas.length };
}

function patenteDe(nivel, tipo) {
  return faixaDe(nivel, tipo).nome;
}

/** Nível do XP, com a porcentagem do trecho atual. */
function nivelDoXp(xp, tipo = 'ALUNO') {
  const total = Math.max(0, Number(xp) || 0);

  let atual = NIVEIS[0];
  for (const degrau of NIVEIS) if (total >= degrau.xp) atual = degrau;

  const proximo = NIVEIS.find(d => d.nivel === atual.nivel + 1) || null;
  const faixa = faixaDe(atual.nivel, tipo);
  const patente = faixa.nome;

  // Último nível: barra cheia.
  if (!proximo) {
    return {
      nivel: atual.nivel, patente, titulo: patente, xp: total,
      faixa: faixa.indice, faixas: faixa.de,
      xp_do_nivel: atual.xp, xp_do_proximo: null,
      faltam: 0, porcentagem: 100, maximo: true,
      total_de_niveis: TOTAL_DE_NIVEIS, proxima_patente: null
    };
  }

  const trecho = proximo.xp - atual.xp;
  const andado = total - atual.xp;

  // Só anuncia a próxima patente quando ela está no degrau seguinte.
  const patenteDoProximo = patenteDe(proximo.nivel, tipo);

  return {
    nivel: atual.nivel,
    patente,
    titulo: patente,                // nome antigo, mantido para não quebrar telas
    faixa: faixa.indice,            // 1 a 10 — é o que escolhe a cor da patente
    faixas: faixa.de,
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

/* ── Dias ── */

/** '2026-10-01' no fuso de quem joga. 'en-CA' é o formato ano-mês-dia. */
function diaLocal(quando) {
  return new Date(quando).toLocaleDateString('en-CA', { timeZone: FUSO });
}

/** Dias seguidos de presença (vale se o último foi hoje ou ontem). */
function sequenciaDeDias(dias) {
  const ordenados = [...new Set(dias)].sort().reverse();
  if (!ordenados.length) return { dias_jogados: 0, streak_dias: 0, jogou_hoje: false };

  const hoje = diaLocal(Date.now());
  const ontem = diaLocal(Date.now() - UM_DIA);

  let seguidos = 0;

  if (ordenados[0] === hoje || ordenados[0] === ontem) {
    seguidos = 1;

    for (let i = 1; i < ordenados.length; i++) {
      // Meio-dia evita erro do horário de verão.
      const esperado = new Date(ordenados[i - 1] + 'T12:00:00Z');
      esperado.setUTCDate(esperado.getUTCDate() - 1);

      if (esperado.toISOString().slice(0, 10) !== ordenados[i]) break;
      seguidos++;
    }
  }

  return { dias_jogados: ordenados.length, streak_dias: seguidos, jogou_hoje: ordenados[0] === hoje };
}

/** Marca a presença de hoje; a chave (usuario_id, dia) garante um prêmio por dia. */
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

/* ── XP de uma pessoa ── */

/** usuario_id -> Set das questões distintas que ele acertou. */
function acertosUnicosPorAluno(linhas) {
  const porAluno = new Map();

  for (const l of linhas) {
    if (!porAluno.has(l.usuario_id)) porAluno.set(l.usuario_id, new Set());
    porAluno.get(l.usuario_id).add(l.questao_id);
  }

  return porAluno;
}

/** XP de um aluno, somado das fontes, mais o nível. `respostas` pode vir já lida. */
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

  const [bruto1, bruto2, bruto3, bruto4] = await Promise.all([
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId),
    admin.from('quiz_concluidos')
      .select('xp_aluno, taxa, perguntas, concluido_em').eq('usuario_id', usuarioId),
    admin.from('xp_ajustes')
      .select('pontos, motivo, criado_em').eq('usuario_id', usuarioId)
  ]);

  const dias = ouVazio(bruto1);
  const ganhas = ouVazio(bruto2);
  const conclusoes = ouVazio(bruto3);
  const ajustes = ouVazio(bruto4);

  if (dias.error) return { erro: dias.error };
  if (ganhas.error) return { erro: ganhas.error };
  if (conclusoes.error) return { erro: conclusoes.error };

  const feitos = conclusoes.data || [];

  const deQuestoes = distintas.size * XP_POR_QUESTAO;
  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);
  const deConclusoes = feitos.reduce((s, c) => s + (c.xp_aluno || 0), 0);

  // Ajustes do admin entram na soma; o total nunca fica negativo.
  const deAjustes = (ajustes.data || []).reduce((s, a) => s + (a.pontos || 0), 0);

  const total = Math.max(0, deQuestoes + deDias + deInsignias + deConclusoes + deAjustes);

  // A sequência conta os dias de presença.
  const presencas = sequenciaDeDias((dias.data || []).map(d => d.dia));

  return {
    total,
    de_questoes: deQuestoes,
    de_dias: deDias,
    de_insignias: deInsignias,
    de_conclusoes: deConclusoes,
    de_ajustes: deAjustes,
    ajustes: ajustes.data || [],
    acertos_unicos: distintas.size,
    conclusoes: feitos.length,
    nivel: nivelDoXp(total, 'ALUNO'),
    ...presencas,
    insignias: ganhas.data || [],
    respostas
  };
}

/* ── Insígnias ──
   As regras estão na tabela; aqui só se compara a medida com o alvo. */

/** Confere a estante e grava as conquistas novas. Regra fora de `medidas` é pulada. */
async function conquistar(usuarioId, publico, medidas) {
  const catalogo = ouVazio(await admin
    .from('insignias')
    .select('codigo, nome, descricao, regra, alvo, xp, imagem, ordem, cenario_slug, grupo')
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
    medidaDe(medidas, i) !== undefined &&
    medidaDe(medidas, i) >= i.alvo
  );

  if (!merecidas.length) return [];

  // upsert com ignoreDuplicates: devolve só as linhas realmente inseridas.
  const gravou = await admin
    .from('insignias_usuarios')
    .upsert(merecidas.map(i => ({ usuario_id: usuarioId, insignia_codigo: i.codigo })),
            { onConflict: 'usuario_id,insignia_codigo', ignoreDuplicates: true })
    .select('insignia_codigo');

  if (gravou.error) return [];

  const gravadas = new Set((gravou.data || []).map(i => i.insignia_codigo));
  return merecidas.filter(i => gravadas.has(i.codigo));
}

/** Concede uma insígnia DESCOBERTA (só dessa regra e do público de quem pede).
    Devolve { nova } (null se já tinha) ou { erro }. */
async function descobrir(usuarioId, publico, codigo) {
  const insignia = await admin
    .from('insignias')
    .select('codigo, nome, descricao, regra, alvo, xp, imagem, ordem, cenario_slug, grupo')
    .eq('codigo', codigo)
    .eq('regra', 'DESCOBERTA')
    .eq('publico', publico)
    .maybeSingle();

  if (insignia.error && !faltaTabela(insignia.error)) return { erro: insignia.error };
  if (!insignia.data) return { erro: { naoExiste: true } };

  // Já tinha: o upsert não devolve linha.
  const gravou = await admin
    .from('insignias_usuarios')
    .upsert({ usuario_id: usuarioId, insignia_codigo: codigo },
            { onConflict: 'usuario_id,insignia_codigo', ignoreDuplicates: true })
    .select('insignia_codigo');

  if (gravou.error) return { erro: gravou.error };
  return { nova: (gravou.data || []).length ? insignia.data : null };
}

/** Formata as novas para o aviso; degraus do mesmo grupo viram um aviso só, com o XP somado. */
function paraAviso(novas) {
  const avisos = [];
  const doGrupo = new Map();

  for (const i of novas) {
    const aviso = { codigo: i.codigo, nome: i.nome, descricao: i.descricao, xp: i.xp || 0, imagem: i.imagem || null };

    if (!i.grupo) { avisos.push(aviso); continue; }

    const ja = doGrupo.get(i.grupo);
    if (!ja) {
      doGrupo.set(i.grupo, { ...aviso, alvo: i.alvo });
      avisos.push(doGrupo.get(i.grupo));
      continue;
    }

    const xp = ja.xp + aviso.xp;
    if (i.alvo > ja.alvo) Object.assign(ja, aviso, { alvo: i.alvo });
    ja.xp = xp;
  }

  return avisos.map(({ alvo, ...aviso }) => aviso);
}

/** Medida de uma insígnia no placar ('ACERTOS_CENARIO:ubs' para as de lugar). */
function medidaDe(medidas, insignia) {
  return medidas[insignia.cenario_slug
    ? `${insignia.regra}:${insignia.cenario_slug}`
    : insignia.regra];
}

/** questao_id -> slug do lugar (em fatias, por causa do tamanho da URL). */
async function lugarDasQuestoes(ids) {
  const lugar = new Map();

  for (let i = 0; i < ids.length; i += 200) {
    const r = await admin
      .from('questoes')
      .select('id, cenarios(slug)')
      .in('id', ids.slice(i, i + 200));

    if (r.error) return { erro: r.error };

    for (const q of r.data || []) {
      if (q.cenarios?.slug) lugar.set(q.id, q.cenarios.slug);
    }
  }

  return { lugar };
}

/** Placar do aluno para `conquistar`: acertos, dias, acertos por lugar e missões concluídas por lugar. */
async function medirAluno(usuarioId, turmaId, retrato) {
  const medidas = {
    ACERTOS: retrato.acertos_unicos,
    DIAS: retrato.streak_dias
  };

  const certas = [...new Set(retrato.respostas.filter(r => r.acertou).map(r => r.questao_id))];
  const { lugar } = await lugarDasQuestoes(certas);

  if (lugar) {
    medidas.MISSOES_CENARIO = 0;

    for (const id of certas) {
      const slug = lugar.get(id);
      if (slug) medidas[`ACERTOS_CENARIO:${slug}`] = (medidas[`ACERTOS_CENARIO:${slug}`] || 0) + 1;
    }
  }

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

  const concluidos = ids.filter(id =>
    (total.get(id) || 0) > 0 && (prontas.get(id) || new Set()).size >= total.get(id));

  // O lugar das questões já está no mapa `lugar`.
  if (lugar) {
    for (const id of concluidos) {
      const lugares = new Set();
      for (const questao of prontas.get(id)) {
        if (lugar.has(questao)) lugares.add(lugar.get(questao));
      }
      medidas.MISSOES_CENARIO += lugares.size;
    }
  }

  return medidas;
}

/* ── O prêmio de concluir um quiz ──
   Proporcional ao tamanho do quiz e à taxa (perguntas ÷ respostas dadas). */

/* XP do aluno por pergunta de quiz concluído. */
const XP_CONCLUSAO_ALUNO = 15;       // × perguntas × taxa
const XP_CONCLUSAO_PROFESSOR = 20;   // × perguntas × qualidade, DIVIDIDO pela turma

/** Prêmio de conclusão. O do professor é dividido pelo tamanho da turma. */
function premioDeConclusao(perguntas, respostas, alunos = 1) {
  const taxa = respostas > 0 ? Math.min(1, perguntas / respostas) : 0;
  const turma = Math.max(1, alunos);

  // Professor: metade garantida, metade pela taxa.
  const doQuizInteiro = perguntas * XP_CONCLUSAO_PROFESSOR * (0.5 + 0.5 * taxa);

  return {
    taxa,
    // O aluno ganha pela taxa inteira.
    aluno: Math.round(perguntas * XP_CONCLUSAO_ALUNO * taxa),

    // Pelo menos 1: numa turma muito grande a fração arredondaria para
    // zero, e um aluno terminar nunca pode valer nada.
    professor: Math.max(1, Math.round(doQuizInteiro / turma))
  };
}

/* ── O professor ──
   XP vem da turma: média de acertos por aluno + prêmios de conclusão. Criar quiz não dá XP. */

const XP_POR_ACERTO_DA_TURMA = 1;

async function xpDoProfessor(usuarioId) {
  const [quizzes, turmas, brutoDias, brutoGanhas, brutoConclusoes, brutoAjustes] = await Promise.all([
    admin.from('quizzes_professores').select('id', { count: 'exact', head: true })
      .eq('professor_id', usuarioId),
    admin.from('turmas').select('id').eq('professor_id', usuarioId),
    admin.from('xp_diario').select('dia, pontos').eq('usuario_id', usuarioId),
    admin.from('insignias_usuarios')
      .select('insignia_codigo, conquistada_em, insignias(nome, descricao, xp, imagem, ordem)')
      .eq('usuario_id', usuarioId),
    admin.from('quiz_concluidos')
      .select('xp_professor, taxa, perguntas, concluido_em')
      .eq('professor_id', usuarioId),
    admin.from('xp_ajustes').select('pontos, motivo, criado_em').eq('usuario_id', usuarioId)
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
        // Distintas por aluno.
        const porAluno = acertosUnicosPorAluno(respostas.data);
        for (const s of porAluno.values()) acertosDaTurma += s.size;
      }
    }
  }

  const feitos = conclusoes.data || [];

  const deDias = (dias.data || []).reduce((s, d) => s + (d.pontos || 0), 0);
  const deConclusoes = feitos.reduce((s, c) => s + (c.xp_professor || 0), 0);

  // Média por aluno, não soma.
  const mediaDeAcertos = quantosAlunos ? Math.round(acertosDaTurma / quantosAlunos) : 0;
  const deTurmas = mediaDeAcertos * XP_POR_ACERTO_DA_TURMA;

  // Ainda não há insígnias de professor.
  const deInsignias = (ganhas.data || []).reduce((s, i) => s + (i.insignias?.xp || 0), 0);

  // O ajuste manual do painel vale aqui como vale para o aluno. Sem
  // isto, "definir nível" num professor mudava o número do painel e
  // não mudava nada na tela dele — duas verdades sobre a mesma pessoa.
  const ajustes = ouVazio(brutoAjustes);
  const deAjustes = (ajustes.data || []).reduce((s, a) => s + (a.pontos || 0), 0);

  const total = Math.max(0, deTurmas + deConclusoes + deDias + deInsignias + deAjustes);

  // Média das taxas de conclusão.
  const taxaMedia = feitos.length
    ? feitos.reduce((s, c) => s + c.taxa, 0) / feitos.length
    : null;

  return {
    total,
    de_turmas: deTurmas,
    de_conclusoes: deConclusoes,
    de_dias: deDias,
    de_insignias: deInsignias,
    de_ajustes: deAjustes,
    ajustes: ajustes.data || [],
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

/** XP completo de várias pessoas de uma vez (para o ranking). */
async function xpDeVarios(ids) {
  const vazio = new Map(ids.map(id => [id, 0]));
  if (!ids.length) return vazio;

  const [certas, dias, insignias, conclusoes, ajustes] = await Promise.all([
    lerTudo(() => admin.from('respostas_alunos').select('usuario_id, questao_id')
      .eq('acertou', true).in('usuario_id', ids).order('usuario_id').order('questao_id')),
    admin.from('xp_diario').select('usuario_id, pontos').in('usuario_id', ids),
    admin.from('insignias_usuarios').select('usuario_id, insignias(xp)').in('usuario_id', ids),
    admin.from('quiz_concluidos').select('usuario_id, xp_aluno').in('usuario_id', ids),
    admin.from('xp_ajustes').select('usuario_id, pontos').in('usuario_id', ids)
  ]);

  const total = new Map(ids.map(id => [id, 0]));
  const soma = (id, quanto) => total.has(id) && total.set(id, total.get(id) + quanto);

  if (!certas.error) {
    for (const [id, set] of acertosUnicosPorAluno(certas.data)) soma(id, set.size * XP_POR_QUESTAO);
  }
  for (const d of ouVazio(dias).data || []) soma(d.usuario_id, d.pontos || 0);
  for (const i of ouVazio(insignias).data || []) soma(i.usuario_id, i.insignias?.xp || 0);
  for (const c of ouVazio(conclusoes).data || []) soma(c.usuario_id, c.xp_aluno || 0);

  // Inclui os ajustes do admin.
  for (const a of ouVazio(ajustes).data || []) soma(a.usuario_id, a.pontos || 0);

  // Ajuste negativo pode passar do que a pessoa tem; nível negativo não
  // existe. Mesma regra do xpDoAluno().
  for (const [id, quanto] of total) if (quanto < 0) total.set(id, 0);

  return total;
}

/** A cada acerto: se fechou o quiz, grava a conclusão e devolve o prêmio; senão, null.
    Não premia o próprio professor, não grava duas vezes e ignora quiz vazio. */
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

  // Tamanho da turma no momento da conclusão.
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
  carregarPatentes, esquecerPatentes, patenteDe, faixaDe,
  faltaTabela, ouVazio,
  nivelDoXp, patenteDe, diaLocal, sequenciaDeDias, marcarPresenca,
  acertosUnicosPorAluno, xpDoAluno, xpDoProfessor, xpDeVarios,
  premioDeConclusao, registrarConclusao,
  conquistar, descobrir, medirAluno, medidaDe, paraAviso
};
