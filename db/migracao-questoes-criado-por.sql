-- Migração: questoes.criado_por (sistema ou professor). Rode uma vez, antes do setup.sql.
-- Ordem: npm run backup -> este arquivo -> db/setup.sql. Roda numa transação.

begin;

-- 1. A coluna, aceitando nulo por enquanto.
alter table questoes add column if not exists criado_por uuid;

-- ── 2. Tudo o que já existe é do sistema ─────────────────────────────
update questoes
   set criado_por = '00000000-0000-0000-0000-000000000000'
 where criado_por is null;

-- 3. Default (código do sistema) e not null.
alter table questoes
  alter column criado_por set default '00000000-0000-0000-0000-000000000000';

alter table questoes alter column criado_por set not null;

-- 4. Índice do filtro do painel do professor.
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

-- Recarrega o cache de schema do PostgREST.
notify pgrst, 'reload schema';


-- Conferir (deve vir só "sistema"):
-- select case when criado_por = '00000000-0000-0000-0000-000000000000' then 'sistema' else 'professor' end as origem, count(*) from questoes group by 1;
