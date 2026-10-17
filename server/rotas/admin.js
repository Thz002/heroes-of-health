/** Painel do admin (exigirTipo('ADMIN')). XP manual vira linha em xp_ajustes;
    o admin não pode se rebaixar, suspender ou apagar, nem remover o último admin. */

const express = require('express');

const { admin } = require('../supabase');
const { autenticar, exigirTipo } = require('../middleware/autenticar');
const { falhou } = require('../erros');
const { lerTudo } = require('../lerTudo');
const PROG = require('../progressao');

const rotas = express.Router();
rotas.use(autenticar, exigirTipo('ADMIN'));

const TIPOS = ['ALUNO', 'PROFESSOR', 'ADMIN'];
const LIMITE_BUSCA = 50;
const TETO_AJUSTE = 100000;   // nem para cima nem para baixo além disto


/** Quantos admins existem além deste. Usado antes de rebaixar alguém. */
async function outrosAdmins(exceto) {
  const r = await admin.from('usuarios').select('id').eq('tipo', 'ADMIN');
  if (r.error) return null;
  return (r.data || []).filter(u => u.id !== exceto).length;
}


// ── Panorama ──

rotas.get('/resumo', async (req, res) => {
  const [usuarios, turmas, questoes, respostas, quizzes, conclusoes] = await Promise.all([
    admin.from('usuarios').select('id, tipo, suspenso, created_at'),
    admin.from('turmas').select('id, professor_id'),
    admin.from('questoes').select('id', { count: 'exact', head: true }),
    admin.from('respostas_alunos').select('usuario_id, acertou, data_resposta'),
    admin.from('quizzes_professores').select('id, professor_id, created_at'),
    admin.from('quiz_concluidos').select('usuario_id, concluido_em'),
  ]);

  if (usuarios.error) {
    return falhou(res, 500, 'Não foi possível carregar o resumo.',
                  usuarios.error, 'GET /admin/resumo');
  }

  // Avisa no terminal quando uma contagem falhou (senão vira "0").
  for (const [nome, r] of Object.entries({ turmas, questoes, respostas, quizzes, conclusoes })) {
    if (r.error) console.error(`  ✖ GET /admin/resumo — ${nome} [${r.error.code}]: ${r.error.message}`);
  }

  const gente = usuarios.data || [];
  const porTipo = { ALUNO: 0, PROFESSOR: 0, ADMIN: 0 };
  let suspensos = 0;
  for (const u of gente) {
    if (porTipo[u.tipo] !== undefined) porTipo[u.tipo]++;
    if (u.suspenso) suspensos++;
  }

  // Ativo = respondeu algo nos últimos 7 dias.
  const semana = Date.now() - 7 * 86_400_000;
  const ativos = new Set(
    (respostas.data || [])
      .filter(r => new Date(r.data_resposta).getTime() >= semana)
      .map(r => r.usuario_id)
  );

  const certas = (respostas.data || []).filter(r => r.acertou).length;
  const totalResp = (respostas.data || []).length;

  res.json({
    usuarios: { total: gente.length, ...porTipo, suspensos },
    turmas: (turmas.data || []).length,
    questoes: questoes.count || 0,
    quizzes: (quizzes.data || []).length,
    respostas: {
      total: totalResp,
      certas,
      taxa: totalResp ? Math.round((certas / totalResp) * 100) : 0,
    },
    conclusoes: (conclusoes.data || []).length,
    ativos_7d: ativos.size,
  });
});


// ── Quem são os professores, e o que andaram fazendo ────────────────

rotas.get('/professores', async (req, res) => {
  const profs = await admin
    .from('usuarios').select('id, nome, tipo, suspenso')
    .in('tipo', ['PROFESSOR', 'ADMIN']).order('nome');

  if (profs.error) {
    return falhou(res, 500, 'Não foi possível carregar os professores.',
                  profs.error, 'GET /admin/professores');
  }

  const [turmas, quizzes, alunos] = await Promise.all([
    admin.from('turmas').select('id, professor_id'),
    admin.from('quizzes_professores').select('id, professor_id, created_at'),
    admin.from('usuarios').select('id, turma_id').eq('tipo', 'ALUNO'),
  ]);

  const turmasDe = new Map();
  for (const t of (turmas.data || [])) {
    if (!t.professor_id) continue;
    if (!turmasDe.has(t.professor_id)) turmasDe.set(t.professor_id, []);
    turmasDe.get(t.professor_id).push(t.id);
  }

  const alunosPorTurma = new Map();
  for (const a of (alunos.data || [])) {
    if (!a.turma_id) continue;
    alunosPorTurma.set(a.turma_id, (alunosPorTurma.get(a.turma_id) || 0) + 1);
  }

  const lista = (profs.data || []).map(p => {
    const minhas = turmasDe.get(p.id) || [];
    const meusQuizzes = (quizzes.data || []).filter(q => q.professor_id === p.id);
    const ultimo = meusQuizzes
      .map(q => q.created_at)
      .sort()
      .pop() || null;

    return {
      id: p.id,
      nome: p.nome,
      tipo: p.tipo,
      suspenso: p.suspenso,
      turmas: minhas.length,
      alunos: minhas.reduce((s, id) => s + (alunosPorTurma.get(id) || 0), 0),
      quizzes: meusQuizzes.length,
      ultimo_quiz: ultimo,
    };
  });

  // Nível de cada pessoa da lista (alunos em lote).
  await enfeitarComNivel(lista);

  res.json(lista);
});


// ── Procurar gente ──

rotas.get('/usuarios', async (req, res) => {
  const termo = String(req.query.q || '').trim();
  const tipo = TIPOS.includes(req.query.tipo) ? req.query.tipo : null;

  let consulta = admin
    .from('usuarios')
    .select('id, nome, tipo, idade, turma_id, suspenso, avatar_url')
    .order('nome')
    .limit(LIMITE_BUSCA);

  if (tipo) consulta = consulta.eq('tipo', tipo);

  // Busca por id (uuid), e-mail (auth.users) ou nome.
  const EH_UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

  if (termo && EH_UUID.test(termo)) consulta = consulta.eq('id', termo);
  else if (termo) consulta = consulta.ilike('nome', `%${termo}%`);

  const [achados, contas, turmas] = await Promise.all([
    consulta,
    admin.auth.admin.listUsers({ perPage: 1000 }),
    admin.from('turmas').select('id, nome'),
  ]);

  if (achados.error) {
    return falhou(res, 500, 'Não foi possível buscar.', achados.error, 'GET /admin/usuarios');
  }

  const emailDe = new Map((contas.data?.users || []).map(u => [u.id, u.email]));
  const nomeDaTurma = new Map((turmas.data || []).map(t => [t.id, t.nome]));

  let lista = (achados.data || []).map(u => ({
    ...u,
    email: emailDe.get(u.id) || null,
    turma_nome: u.turma_id ? (nomeDaTurma.get(u.turma_id) || null) : null,
  }));

  // Se o termo parece e-mail e o nome não achou nada, procura nas contas.
  if (termo && termo.includes('@') && !lista.length) {
    const ids = (contas.data?.users || [])
      .filter(u => (u.email || '').toLowerCase().includes(termo.toLowerCase()))
      .map(u => u.id);

    if (ids.length) {
      const porEmail = await admin
        .from('usuarios')
        .select('id, nome, tipo, idade, turma_id, suspenso, avatar_url')
        .in('id', ids.slice(0, LIMITE_BUSCA));

      lista = (porEmail.data || []).map(u => ({
        ...u,
        email: emailDe.get(u.id) || null,
        turma_nome: u.turma_id ? (nomeDaTurma.get(u.turma_id) || null) : null,
      }));
    }
  }

  // Depois do fallback por e-mail, que pode trocar a lista.
  await enfeitarComNivel(lista);

  res.json(lista);
});


/** Acrescenta `nivel` a cada pessoa (falha em silêncio). */
async function enfeitarComNivel(lista) {
  if (!lista.length) return;

  // ADMIN entra no lote dos alunos: ele joga, e é pela régua de aluno
  // que o jogo conta o XP dele.
  const alunos = lista.filter(u => u.tipo !== 'PROFESSOR');
  const outros = lista.filter(u => u.tipo === 'PROFESSOR');

  const [porAluno, dosOutros] = await Promise.all([
    alunos.length ? PROG.xpDeVarios(alunos.map(u => u.id)).catch(() => null) : null,
    Promise.all(outros.map(u => PROG.xpDoProfessor(u.id).catch(() => null))),
  ]);

  if (porAluno) {
    for (const u of alunos) {
      const xp = porAluno.get(u.id);
      if (xp !== undefined) u.nivel = PROG.nivelDoXp(xp, 'ALUNO');
    }
  }

  outros.forEach((u, i) => {
    const r = dosOutros[i];
    if (r && r.nivel) u.nivel = r.nivel;
  });
}


// ── A ficha de uma pessoa ───────────────────────────────────────────

rotas.get('/usuarios/:id', async (req, res) => {
  const id = String(req.params.id);

  const perfil = await admin
    .from('usuarios')
    .select('id, nome, tipo, idade, turma_id, suspenso, suspenso_em, suspenso_motivo, avatar_url, created_at')
    .eq('id', id).maybeSingle();

  // Erro de consulta não é 404.
  if (perfil.error) {
    return falhou(res, 500, 'A consulta ao banco falhou. Veja o terminal do servidor.',
                  perfil.error, 'GET /admin/usuarios/:id');
  }
  if (!perfil.data) {
    return res.status(404).json({ message: 'Não existe conta com esse id.' });
  }

  // A mesma regra do GET /meu-resumo: professor tem régua própria,
  // todo o resto (aluno e equipe) usa a de aluno. Antes esta ficha
  // media todo mundo como aluno e o cartão da busca media o professor
  // como professor — a mesma pessoa com dois níveis.
  const [conta, xp] = await Promise.all([
    admin.auth.admin.getUserById(id),
    (perfil.data.tipo === 'PROFESSOR'
      ? PROG.xpDoProfessor(id)
      : PROG.xpDoAluno(id)).catch(() => null),
  ]);

  res.json({
    ...perfil.data,
    email: conta.data?.user?.email || null,
    ultimo_login: conta.data?.user?.last_sign_in_at || null,
    xp,
  });
});


// ── Mexer numa pessoa ──

// ── XP à mão ────────────────────────────────────────────────────────

rotas.post('/usuarios/:id/xp', async (req, res) => {
  const id = String(req.params.id);
  const pontos = Math.trunc(Number(req.body?.pontos));
  const motivo = String(req.body?.motivo || '').trim().slice(0, 200);

  if (!Number.isFinite(pontos) || pontos === 0) {
    return res.status(400).json({ message: 'Informe quantos pontos somar ou tirar.' });
  }
  if (Math.abs(pontos) > TETO_AJUSTE) {
    return res.status(400).json({ message: `O ajuste máximo é de ${TETO_AJUSTE} XP por vez.` });
  }
  if (!motivo) {
    return res.status(400).json({ message: 'Escreva o motivo do ajuste.' });
  }

  const r = await admin.from('xp_ajustes').insert({
    usuario_id: id, pontos, motivo, feito_por: req.usuario.id,
  }).select('id, pontos, motivo, criado_em').single();

  if (r.error) {
    return falhou(res, 500, 'Não foi possível registrar o ajuste.',
                  r.error, 'POST /admin/usuarios/:id/xp');
  }

  const xp = await PROG.xpDoAluno(id).catch(() => null);
  console.log(`  · ${req.usuario.nome} ajustou ${pontos > 0 ? '+' : ''}${pontos} XP de ${id}: ${motivo}`);

  res.json({ ajuste: r.data, xp });
});


/** Leva a um nível exato gravando um ajuste de XP. */
rotas.post('/usuarios/:id/nivel', async (req, res) => {
  const id = String(req.params.id);
  const alvo = Math.trunc(Number(req.body?.nivel));

  if (!Number.isInteger(alvo) || alvo < 1 || alvo > PROG.TOTAL_DE_NIVEIS) {
    return res.status(400).json({ message: `O nível vai de 1 a ${PROG.TOTAL_DE_NIVEIS}.` });
  }

  const perfil = await admin.from('usuarios').select('tipo').eq('id', id).maybeSingle();
  if (perfil.error || !perfil.data) {
    return falhou(res, 404, 'Usuário não encontrado.', perfil.error, 'POST /admin/usuarios/:id/nivel');
  }

  const xpAtual = await PROG.xpDoAluno(id).catch(() => null);
  if (!xpAtual) {
    return falhou(res, 500, 'Não foi possível ler o XP atual.', null, 'POST /admin/usuarios/:id/nivel');
  }

  const degrau = PROG.NIVEIS.find(d => d.nivel === alvo);
  const diferenca = degrau.xp - xpAtual.total;

  if (diferenca === 0) {
    return res.json({ message: 'A pessoa já está nesse nível.', xp: xpAtual });
  }

  const r = await admin.from('xp_ajustes').insert({
    usuario_id: id,
    pontos: diferenca,
    motivo: `Nível ajustado para ${alvo} pelo painel`,
    feito_por: req.usuario.id,
  });

  if (r.error) {
    return falhou(res, 500, 'Não foi possível ajustar o nível.',
                  r.error, 'POST /admin/usuarios/:id/nivel');
  }

  const xp = await PROG.xpDoAluno(id).catch(() => null);
  console.log(`  · ${req.usuario.nome} levou ${id} ao nível ${alvo} (${diferenca > 0 ? '+' : ''}${diferenca} XP)`);

  res.json({ xp });
});


// ── Papel, nome, suspensão ──────────────────────────────────────────

rotas.patch('/usuarios/:id', async (req, res) => {
  const id = String(req.params.id);
  const souEu = id === req.usuario.id;
  const mudancas = {};

  // ── o papel ──
  if (req.body?.tipo !== undefined) {
    const tipo = String(req.body.tipo).toUpperCase();
    if (!TIPOS.includes(tipo)) {
      return res.status(400).json({ message: 'Papel inválido.' });
    }

    if (souEu && tipo !== 'ADMIN') {
      return res.status(400).json({
        message: 'Você não pode tirar o próprio acesso de admin. Peça a outro admin.',
      });
    }

    // O último admin não pode ser rebaixado.
    if (!souEu && tipo !== 'ADMIN') {
      const alvo = await admin.from('usuarios').select('tipo').eq('id', id).maybeSingle();
      if (alvo.data?.tipo === 'ADMIN' && (await outrosAdmins(id)) === 0) {
        return res.status(400).json({
          message: 'Este é o último admin do sistema. Promova outra pessoa antes.',
        });
      }
    }

    mudancas.tipo = tipo;
  }

  // ── o nome ──
  if (req.body?.nome !== undefined) {
    const nome = String(req.body.nome).trim().slice(0, 100);
    if (nome.length < 2) return res.status(400).json({ message: 'Nome curto demais.' });
    mudancas.nome = nome;
  }

  // ── suspender / reativar ──
  if (req.body?.suspenso !== undefined) {
    const suspenso = Boolean(req.body.suspenso);

    if (souEu && suspenso) {
      return res.status(400).json({ message: 'Você não pode suspender a si mesmo.' });
    }

    mudancas.suspenso = suspenso;
    mudancas.suspenso_em = suspenso ? new Date().toISOString() : null;
    mudancas.suspenso_motivo = suspenso
      ? String(req.body?.motivo || '').trim().slice(0, 200) || null
      : null;
  }

  if (!Object.keys(mudancas).length) {
    return res.status(400).json({ message: 'Nada para alterar.' });
  }

  const r = await admin.from('usuarios').update(mudancas).eq('id', id)
    .select('id, nome, tipo, suspenso, suspenso_em, suspenso_motivo').single();

  if (r.error) {
    return falhou(res, 500, 'Não foi possível salvar.', r.error, 'PATCH /admin/usuarios/:id');
  }

  console.log(`  · ${req.usuario.nome} alterou ${id}: ${JSON.stringify(mudancas)}`);
  res.json(r.data);
});


// Dispara o e-mail de recuperação (o admin não escolhe a senha).

rotas.post('/usuarios/:id/recuperar-senha', async (req, res) => {
  const id = String(req.params.id);

  const conta = await admin.auth.admin.getUserById(id);
  const email = conta.data?.user?.email;

  if (!email) {
    return res.status(404).json({ message: 'Esta conta não tem e-mail.' });
  }

  const { criarEEnviarCodigo } = require('./recuperacao');

  try {
    await criarEEnviarCodigo(email);
    console.log(`  · ${req.usuario.nome} disparou recuperação de senha para ${email}`);
    res.json({ message: `Código de recuperação enviado para ${email}.` });
  } catch (erro) {
    return falhou(res, 500, 'Não foi possível enviar o código.',
                  erro, 'POST /admin/usuarios/:id/recuperar-senha');
  }
});


// Define a senha direto (fica registrado no log).
rotas.post('/usuarios/:id/senha', async (req, res) => {
  const id = String(req.params.id);
  const senha = String(req.body?.senha || '');

  if (senha.length < 6) {
    return res.status(400).json({ message: 'A senha precisa de pelo menos 6 caracteres.' });
  }

  const r = await admin.auth.admin.updateUserById(id, { password: senha });

  if (r.error) {
    return falhou(res, 500, 'Não foi possível trocar a senha.',
                  r.error, 'POST /admin/usuarios/:id/senha');
  }

  console.log(`  ⚠ ${req.usuario.nome} DEFINIU a senha da conta ${id}`);
  res.json({ message: 'Senha trocada. Avise a pessoa qual é.' });
});


// ── Apagar ──────────────────────────────────────────────────────────

rotas.delete('/usuarios/:id', async (req, res) => {
  const id = String(req.params.id);

  if (id === req.usuario.id) {
    return res.status(400).json({ message: 'Você não pode apagar a própria conta.' });
  }

  const alvo = await admin.from('usuarios').select('nome, tipo').eq('id', id).maybeSingle();
  if (!alvo.data) return res.status(404).json({ message: 'Usuário não encontrado.' });

  if (alvo.data.tipo === 'ADMIN' && (await outrosAdmins(id)) === 0) {
    return res.status(400).json({
      message: 'Este é o último admin do sistema. Promova outra pessoa antes.',
    });
  }

  // Apaga a conta e, em cascata, todo o progresso. Não volta.
  const r = await admin.auth.admin.deleteUser(id);

  if (r.error) {
    return falhou(res, 500, 'Não foi possível apagar a conta.',
                  r.error, 'DELETE /admin/usuarios/:id');
  }

  console.log(`  · ${req.usuario.nome} APAGOU a conta de ${alvo.data.nome} (${id})`);
  res.json({ message: `Conta de ${alvo.data.nome} apagada.` });
});


// ── Patentes ──

rotas.get('/patentes', async (_req, res) => {
  const r = await admin.from('patentes').select('id, tipo, ate, nome').order('tipo').order('ate');

  if (r.error) {
    return falhou(res, 500, 'Não foi possível carregar as patentes.',
                  r.error, 'GET /admin/patentes');
  }

  res.json({
    patentes: r.data || [],
    total_de_niveis: PROG.TOTAL_DE_NIVEIS,
    escada: PROG.NIVEIS,
  });
});


/** Substitui todas as faixas de um papel de uma vez. */
rotas.put('/patentes', async (req, res) => {
  const tipo = String(req.body?.tipo || '').toUpperCase();
  const faixas = Array.isArray(req.body?.faixas) ? req.body.faixas : null;

  if (tipo !== 'ALUNO' && tipo !== 'PROFESSOR') {
    return res.status(400).json({ message: 'Informe se é de ALUNO ou PROFESSOR.' });
  }
  if (!faixas || !faixas.length) {
    return res.status(400).json({ message: 'Mande pelo menos uma faixa.' });
  }

  const limpas = [];
  for (const f of faixas) {
    const ate = Math.trunc(Number(f?.ate));
    const nome = String(f?.nome || '').trim().slice(0, 60);

    if (!Number.isInteger(ate) || ate < 1 || ate > PROG.TOTAL_DE_NIVEIS) {
      return res.status(400).json({
        message: `Cada faixa termina num nível entre 1 e ${PROG.TOTAL_DE_NIVEIS}.`,
      });
    }
    if (!nome) return res.status(400).json({ message: 'Toda faixa precisa de nome.' });

    limpas.push({ tipo, ate, nome });
  }

  limpas.sort((a, b) => a.ate - b.ate);

  if (new Set(limpas.map(f => f.ate)).size !== limpas.length) {
    return res.status(400).json({ message: 'Duas faixas terminam no mesmo nível.' });
  }

  // A última faixa precisa chegar ao nível máximo.
  if (limpas[limpas.length - 1].ate !== PROG.TOTAL_DE_NIVEIS) {
    return res.status(400).json({
      message: `A última faixa precisa terminar no nível ${PROG.TOTAL_DE_NIVEIS}.`,
    });
  }

  const apagou = await admin.from('patentes').delete().eq('tipo', tipo);
  if (apagou.error) {
    return falhou(res, 500, 'Não foi possível salvar as patentes.',
                  apagou.error, 'PUT /admin/patentes (delete)');
  }

  const gravou = await admin.from('patentes').insert(limpas).select('id, tipo, ate, nome');
  if (gravou.error) {
    return falhou(res, 500, 'Não foi possível salvar as patentes.',
                  gravou.error, 'PUT /admin/patentes (insert)');
  }

  PROG.esquecerPatentes();
  console.log(`  · ${req.usuario.nome} reescreveu as patentes de ${tipo} (${limpas.length} faixas)`);

  res.json(gravou.data);
});


module.exports = rotas;
