/**
 * server/rotas/jogo.js — as rotas que o aluno usa jogando
 *
 * O motivo deste arquivo existir: enquanto a correção da resposta
 * acontecia no navegador, ela não valia nada. O aluno lia
 * `resposta_correta` pelo console e escrevia a própria pontuação com um
 * update. Aqui a regra do jogo fica do lado de cá, fora do alcance dele.
 */

const express = require('express');
const { admin } = require('../supabase');
const { autenticar } = require('../middleware/autenticar');

const rotas = express.Router();
rotas.use(autenticar);

/** Traduz a idade para a faixa das missões (1 = 7-10, 2 = 11-14, 3 = 15-18). */
function nivelDaIdade(idade) {
  if (!idade) return null;
  if (idade <= 10) return 1;
  if (idade <= 14) return 2;
  return 3;
}

// ── Cenários do mapa ─────────────────────────────────────────────────
rotas.get('/cenarios', async (req, res) => {
  const { data, error } = await admin
    .from('cenarios')
    .select('id, slug, nome, descricao')
    .order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar o mapa.' });
  res.json(data);
});

// ── Missões de um cenário, já filtradas pela idade ───────────────────
rotas.get('/cenarios/:slug/missoes', async (req, res) => {
  const cenario = await admin
    .from('cenarios')
    .select('id')
    .eq('slug', req.params.slug)
    .maybeSingle();

  if (cenario.error || !cenario.data) {
    return res.status(404).json({ message: 'Esse lugar não existe no mapa.' });
  }

  let consulta = admin
    .from('missoes')
    .select('id, titulo, descricao, nivel_etario, eh_especial')
    .eq('cenario_id', cenario.data.id);

  // O filtro etário é regra de negócio: uma missão de imunologia não
  // aparece para quem tem 8 anos. Aplicado aqui, e não na tela, para
  // que não dependa do navegador cooperar.
  const nivel = nivelDaIdade(req.usuario.idade);
  if (nivel) consulta = consulta.eq('nivel_etario', nivel);

  const { data, error } = await consulta.order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar as missões.' });
  res.json(data);
});

// ── Questões de uma missão ───────────────────────────────────────────
//
// Repare no select: `resposta_correta` e `explicacao` NÃO estão nele.
// As duas ficam no servidor até a pessoa responder. É o conserto do
// vazamento de gabarito descrito em docs/banco-de-dados.md (§4, item 4).
rotas.get('/missoes/:id/questoes', async (req, res) => {
  const { data, error } = await admin
    .from('questoes')
    .select('id, enunciado, opcao_a, opcao_b, opcao_c, opcao_d')
    .eq('missao_id', req.params.id)
    .order('id');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar as questões.' });
  res.json(data);
});

// ── Responder uma questão ────────────────────────────────────────────
rotas.post('/responder', async (req, res) => {
  const questaoId = Number(req.body?.questao_id);
  const resposta  = String(req.body?.resposta || '').trim().toUpperCase();

  if (!questaoId || !['A', 'B', 'C', 'D'].includes(resposta)) {
    return res.status(400).json({ message: 'Resposta inválida.' });
  }

  const questao = await admin
    .from('questoes')
    .select('id, missao_id, resposta_correta, explicacao')
    .eq('id', questaoId)
    .maybeSingle();

  if (questao.error || !questao.data) {
    return res.status(404).json({ message: 'Essa questão não existe.' });
  }

  const acertou = resposta === questao.data.resposta_correta;

  // O histórico guarda TODAS as tentativas, inclusive as erradas: é
  // desse histórico que sai o relatório do professor.
  const gravou = await admin.from('respostas_alunos').insert({
    usuario_id: req.usuario.id,
    questao_id: questaoId,
    acertou
  });

  if (gravou.error) {
    return res.status(500).json({ message: 'Não foi possível registrar sua resposta.' });
  }

  let pontosGanhos = [];

  if (acertou) {
    // Pontua só no PRIMEIRO acerto de cada questão. Sem isso, bastava
    // responder a mesma pergunta certa dez vezes para encher as barras.
    const jaAcertou = await admin
      .from('respostas_alunos')
      .select('id')
      .eq('usuario_id', req.usuario.id)
      .eq('questao_id', questaoId)
      .eq('acertou', true)
      .limit(2);

    const primeiraVez = !jaAcertou.error && (jaAcertou.data || []).length <= 1;

    if (primeiraVez) {
      // Quais barras esta missão alimenta, e quanto. A tabela
      // missao_areas foi criada na migração 03 justamente para isto.
      const areas = await admin
        .from('missao_areas')
        .select('area_nome, pontos')
        .eq('missao_id', questao.data.missao_id);

      for (const area of areas.data || []) {
        const r = await admin.rpc('somar_pontos', {
          p_usuario: req.usuario.id,
          p_area:    area.area_nome,
          p_pontos:  area.pontos
        });
        if (!r.error) pontosGanhos.push({ area: area.area_nome, pontos: area.pontos });
      }
    }
  }

  // O que volta para a tela. Mesmo errando, a pessoa recebe a explicação
  // — mas NUNCA a letra certa: a ideia é que ela tente de novo com o
  // conteúdo em mãos, e não que copie a resposta.
  res.json({
    acertou,
    explicacao: questao.data.explicacao,
    pontos: pontosGanhos
  });
});

// ── As 8 barras do aluno ─────────────────────────────────────────────
rotas.get('/meu-progresso', async (req, res) => {
  const { data, error } = await admin
    .from('areas')
    .select('nome, ordem')
    .order('ordem');

  if (error) return res.status(500).json({ message: 'Não foi possível carregar seu progresso.' });

  const progresso = await admin
    .from('progresso_areas')
    .select('area_nome, pontos, porcentagem')
    .eq('usuario_id', req.usuario.id);

  const porArea = new Map((progresso.data || []).map(p => [p.area_nome, p]));

  // Devolve sempre as 8, mesmo as que ainda estão zeradas, para a tela
  // poder desenhar todas as barras desde o primeiro acesso.
  res.json(data.map(a => ({
    area:        a.nome,
    pontos:      porArea.get(a.nome)?.pontos ?? 0,
    porcentagem: porArea.get(a.nome)?.porcentagem ?? 0
  })));
});

module.exports = rotas;
