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

// ── As turmas do professor, com o código para entregar à sala ────────
rotas.get('/turmas', async (req, res) => {
  const { data, error } = await admin
    .from('turmas')
    .select('id, nome, codigo, escola_id')
    .eq('professor_id', req.usuario.id)
    .order('nome');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar suas turmas.' });
  res.json(data);
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
      codigo
    })
    .select('id, nome, codigo, escola_id')
    .single();

  if (error) {
    if (error.message.includes('duplicate') || error.code === '23505') {
      return res.status(409).json({ message: 'Você já tem uma turma com esse nome nesta escola.' });
    }
    return res.status(500).json({ message: 'Não foi possível criar a turma.' });
  }

  res.status(201).json(data);
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
    return res.status(500).json({ message: 'Não foi possível carregar a turma.' });
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

module.exports = rotas;
