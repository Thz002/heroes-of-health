-- =====================================================================
--  MIGRAÇÃO: toda questão passa a dizer quem a escreveu (criado_por)
--
--  Antes:  só existiam as questões da equipe de Medicina.
--  Depois: o professor também cria as dele, pelo painel. Cada um enxerga
--          as do sistema e as próprias — nunca as de outro professor.
--
--  A coluna nova, questoes.criado_por (uuid), guarda:
--    '00000000-0000-0000-0000-000000000000'  -> questão DO SISTEMA
--    o id do professor (usuarios.id)         -> questão criada por ele
--
--  O QUE ESTE ARQUIVO FAZ COM OS DADOS:
--    - cria a coluna, se ainda não existir;
--    - marca TODAS as questões que já estão no banco como do sistema
--      (até hoje, toda questão veio do importar-questoes.sql);
--    - fixa o default no código do sistema e trava em "not null";
--    - cria o índice que o painel do professor usa para filtrar;
--    - confere no fim: nenhuma questão pode ficar sem dono.
--
--  O QUE NÃO MUDA: nenhum id, nenhum texto, nenhuma resposta de aluno.
--  respostas_alunos e quiz_questoes continuam apontando para as mesmas
--  perguntas, e os pontos das barras ficam iguais.
--
--  ORDEM:
--    1. npm run backup           (cópia fora do banco, na sua máquina)
--    2. ESTE arquivo              (SQL Editor -> colar tudo -> Run)
--    3. db/setup.sql              (como sempre; traz as policies novas de
--                                  questoes/questoes_areas e a meta das
--                                  barras contando só as do sistema)
--
--  É seguro rodar de novo: se a coluna já existir e estiver preenchida,
--  nada muda. Tudo roda numa transação só — se a conferência do fim
--  falhar, NADA é alterado.
-- =====================================================================

begin;

-- ── 1. A coluna, ainda sem trava ─────────────────────────────────────
-- Nasce aceitando nulo para o update logo abaixo decidir o valor de
-- cada linha às claras, em vez de deixar isso implícito no default.
alter table questoes add column if not exists criado_por uuid;

-- ── 2. Tudo o que já existe é do sistema ─────────────────────────────
update questoes
   set criado_por = '00000000-0000-0000-0000-000000000000'
 where criado_por is null;

-- ── 3. Default e trava ───────────────────────────────────────────────
-- O default é o que deixa o importar-questoes.sql continuar igual: ele
-- não menciona a coluna, e toda questão que entra por ele já nasce
-- "do sistema".
alter table questoes
  alter column criado_por set default '00000000-0000-0000-0000-000000000000';

alter table questoes alter column criado_por set not null;

-- ── 4. O filtro do painel do professor ───────────────────────────────
-- "As do sistema OU as minhas, deste cenário, nesta faixa etária".
create index if not exists questoes_por_criador
  on questoes (criado_por, cenario_id, nivel_etario);

-- ── 5. Conferir antes de gravar ──────────────────────────────────────
do $$
declare
  sem_dono  bigint;
  sistema   bigint;
  total     bigint;
begin
  select count(*) into total    from questoes;
  select count(*) into sem_dono from questoes where criado_por is null;
  select count(*) into sistema  from questoes
   where criado_por = '00000000-0000-0000-0000-000000000000';

  if sem_dono > 0 then
    raise exception 'Ainda há % questão(ões) sem criado_por. Nada foi gravado.', sem_dono;
  end if;

  raise notice 'criado_por OK: % questão(ões) no banco, % do sistema, % de professores.',
    total, sistema, total - sistema;
end $$;

commit;

-- O PostgREST guarda em cache o desenho das tabelas. Sem este aviso, a
-- coluna existe no banco e a API continua dizendo que não.
notify pgrst, 'reload schema';


-- ── Conferir depois de rodar ─────────────────────────────────────────
-- Deve vir uma linha só, "sistema", com o total de questões do banco
-- (até algum professor criar a primeira dele).
--
-- select case when criado_por = '00000000-0000-0000-0000-000000000000'
--             then 'sistema' else 'professor' end as origem,
--        count(*)
--   from questoes group by 1;
