-- =====================================================================
--  MIGRAÇÃO: as questões deixam de pertencer a uma "missão"
--
--  Antes:  cenarios ──< missoes ──< questoes      missoes ──< missao_areas
--  Depois: cenarios ──< questoes ──< questoes_areas
--
--  Por quê: "missão" passou a ser o nome que o aluno vê para o QUIZ que
--  o professor cria. A tabela missoes era só um agrupador (cenário ×
--  faixa etária) que ninguém escolhia nem via como tarefa. Agora cada
--  questão carrega o próprio cenário e a própria faixa etária, e diz
--  sozinha quantos pontos dá em cada área.
--
--  O QUE ACONTECE COM OS DADOS:
--    - questoes.cenario_id e questoes.nivel_etario vêm da missão de cada
--      questão;
--    - cada questão recebe, em questoes_areas, exatamente as linhas de
--      missao_areas da missão dela. Os pontos por acerto não mudam, e as
--      metas das barras também não: a soma continua a mesma;
--    - os ids das questões NÃO mudam, então respostas_alunos e
--      quiz_questoes continuam apontando para as mesmas perguntas;
--    - missoes e missao_areas são apagadas — mas antes vão para o schema
--      backup_pre_migracao, dentro do próprio banco (ver o fim do arquivo).
--
--  ORDEM:
--    1. npm run backup           (cópia fora do banco, na sua máquina)
--    2. ESTE arquivo              (SQL Editor -> colar tudo -> Run)
--    3. db/setup.sql              (como sempre; já descreve a estrutura nova)
--
--  É seguro rodar de novo: se missoes já não existir, a parte de dados é
--  pulada. Tudo roda numa transação só — se qualquer conferência falhar,
--  NADA é alterado.
-- =====================================================================

begin;

do $$
declare
  sem_cenario  int;
  antes        bigint;
  depois       bigint;
begin
  if to_regclass('public.missoes') is null then
    raise notice 'missoes já não existe: a migração já foi aplicada. Nada a mover.';
    return;
  end if;

  -- ── 0. Cópia de segurança dentro do banco ─────────────────────────
  -- Fora do alcance da API: o Supabase só expõe o schema public, e os
  -- perfis anon/authenticated não recebem acesso a este.
  create schema if not exists backup_pre_migracao;
  revoke all on schema backup_pre_migracao from anon, authenticated;

  create table if not exists backup_pre_migracao.missoes      as select * from public.missoes;
  create table if not exists backup_pre_migracao.missao_areas as select * from public.missao_areas;
  create table if not exists backup_pre_migracao.questao_missao as
    select id as questao_id, missao_id from public.questoes;

  -- ── 1. Cenário e faixa etária passam para a questão ───────────────
  alter table questoes add column if not exists cenario_id bigint
    references cenarios(id) on delete cascade;
  alter table questoes add column if not exists nivel_etario int
    check (nivel_etario between 1 and 3);

  update questoes q
     set cenario_id   = m.cenario_id,
         nivel_etario = m.nivel_etario
    from missoes m
   where m.id = q.missao_id;

  select count(*) into sem_cenario
    from questoes where cenario_id is null or nivel_etario is null;

  if sem_cenario > 0 then
    raise exception 'Migração abortada: % questão(ões) ficariam sem cenário ou faixa etária.', sem_cenario;
  end if;

  alter table questoes alter column cenario_id   set not null;
  alter table questoes alter column nivel_etario set not null;

  -- ── 2. Os pontos passam a ser por questão ─────────────────────────
  create table if not exists questoes_areas (
    questao_id bigint not null references questoes(id) on delete cascade,
    area_nome varchar(50) not null references areas(nome) on delete cascade,
    pontos int not null default 10 check (pontos > 0),
    primary key (questao_id, area_nome)
  );

  insert into questoes_areas (questao_id, area_nome, pontos)
  select q.id, ma.area_nome, ma.pontos
    from questoes q
    join missao_areas ma on ma.missao_id = q.missao_id
  on conflict (questao_id, area_nome) do nothing;

  -- Conferência: o total de pontos que o conteúdo pode render (é disso
  -- que saem as metas das barras) tem de ser idêntico antes e depois.
  select coalesce(sum(ma.pontos), 0) into antes
    from missao_areas ma join questoes q on q.missao_id = ma.missao_id;
  select coalesce(sum(pontos), 0) into depois from questoes_areas;

  if antes <> depois then
    raise exception 'Migração abortada: os pontos não bateram (antes %, depois %).', antes, depois;
  end if;

  -- ── 3. Some a missão ──────────────────────────────────────────────
  -- As permissões de coluna de questoes.missao_id vão junto com ela.
  drop index if exists questoes_por_missao;
  alter table questoes drop column missao_id;
  drop table missao_areas;
  drop table missoes;

  raise notice 'Migração concluída: % ponto(s) de conteúdo preservados em questoes_areas.', depois;
end $$;


-- ── 4. O que a tabela nova precisa desde já ──────────────────────────
-- O db/setup.sql faz tudo isto de novo, mas não pode ficar para depois:
-- tabela nova no public nasce ABERTA para qualquer visitante até o RLS
-- ser ligado, e recalcular_metas() antiga ainda leria missao_areas.

create index if not exists questoes_por_cenario_e_nivel on questoes (cenario_id, nivel_etario);
create index if not exists questoes_areas_por_area      on questoes_areas (area_nome);

alter table questoes_areas enable row level security;

drop policy if exists "logado le o conteudo"     on questoes_areas;
drop policy if exists "admin escreve o conteudo" on questoes_areas;
create policy "logado le o conteudo" on questoes_areas
  for select to authenticated using (true);
create policy "admin escreve o conteudo" on questoes_areas
  for all to authenticated using (public.eh_admin()) with check (public.eh_admin());

-- O gabarito continua escondido: só as colunas sem resposta são lidas.
revoke select on questoes from anon, authenticated;
grant  select (id, cenario_id, nivel_etario, enunciado, opcao_a, opcao_b, opcao_c, opcao_d)
  on questoes to anon, authenticated;

create or replace function public.recalcular_metas()
returns void language plpgsql security definer set search_path = public as $$
begin
  update areas a
     set meta = coalesce((
       select sum(qa.pontos) from questoes_areas qa where qa.area_nome = a.nome
     ), 0);

  update progresso_areas p
     set porcentagem = case
       when a.meta > 0 then least(100, p.pontos::real / a.meta * 100)
       else 0
     end
    from areas a
   where a.nome = p.area_nome;
end;
$$;

revoke execute on function public.recalcular_metas() from public;
revoke execute on function public.recalcular_metas() from anon, authenticated;

-- Com os mesmos pontos, as metas saem iguais — rodar aqui só confirma.
select public.recalcular_metas();

notify pgrst, 'reload schema';

commit;


-- =====================================================================
--  CONFERIR DEPOIS DE RODAR
-- =====================================================================

-- Questões por cenário e faixa (deve somar 225, se nada mudou):
-- select c.slug, q.nivel_etario, count(*) from questoes q
--   join cenarios c on c.id = q.cenario_id
--  group by 1, 2 order by 1, 2;

-- As metas das barras (devem ser as mesmas de antes):
-- select nome, meta from areas order by ordem;

-- Quando tiver certeza de que está tudo certo, apague a cópia interna:
-- drop schema backup_pre_migracao cascade;
