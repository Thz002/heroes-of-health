-- HERÓIS DA SAÚDE — o banco inteiro (PostgreSQL/Supabase). Seguro de rodar de novo; não apaga dados.
-- Rode no SQL Editor; depois, seed.sql e insignias.sql. Bancos antigos: rode antes as migracao-*.sql.

do $$
begin
  if to_regclass('public.missoes') is not null then
    raise exception
      'Este banco ainda tem a tabela missoes. Rode db/migracao-questoes-sem-missoes.sql antes deste arquivo.';
  end if;
end $$;


-- ── 1. TABELAS ──

-- ── Institucional ────────────────────────────────────────────────────

create table if not exists escolas (
  id bigint primary key generated always as identity,
  nome varchar(150) not null,
  created_at timestamptz not null default now()
);

-- Nome de escola único (só cria a restrição se não houver repetidos).
do $$
declare repetidos int;
begin
  if exists (
    select 1 from pg_constraint
    where conrelid = 'public.escolas'::regclass
      and contype in ('u','p')
      and pg_get_constraintdef(oid) ilike '%(nome)%'
  ) then
    return;
  end if;

  select count(*) into repetidos
  from (select nome from escolas group by nome having count(*) > 1) d;

  if repetidos > 0 then
    raise warning
      'escolas.nome NAO ficou unico: % nome(s) repetido(s). Veja: select nome, count(*) from escolas group by nome having count(*)>1;',
      repetidos;
  else
    alter table escolas add constraint escolas_nome_unico unique (nome);
  end if;
end $$;


create table if not exists turmas (
  id bigint primary key generated always as identity,
  nome varchar(50) not null,                   -- ex: '7º Ano B'
  -- Aposentada: a turma não pertence mais a uma escola.
  escola_id bigint references escolas(id) on delete set null,

  -- Código que o professor entrega para a turma (ex: '7B-K3M9').
  codigo varchar(12),

  -- Quem criou a turma (FK criada mais abaixo).
  professor_id uuid,

  created_at timestamptz not null default now()
);

create unique index if not exists turmas_codigo_unico   on turmas (codigo);
-- Nome de turma único por professor.
create unique index if not exists turmas_nome_por_professor on turmas (professor_id, nome);
drop index if exists turmas_nome_por_escola;

-- Solta o NOT NULL de escola_id em bancos antigos.
do $solta$
begin
  alter table turmas alter column escola_id drop not null;
exception when others then null;
end $solta$;

-- Cor e ano escolar: só exibição no painel do professor.
alter table turmas add column if not exists cor varchar(9)
  not null default '#14b8a6'
  check (cor in ('#14b8a6','#3b82f6','#f9c74f','#f472b6','#a78bfa','#fb923c'));

alter table turmas add column if not exists ano_escolar varchar(10);


-- ── Pessoas ──────────────────────────────────────────────────────────

create table if not exists usuarios (
  -- Mesmo id do login do Supabase (é o que faz auth.uid() e o RLS funcionarem).
  id uuid primary key references auth.users(id) on delete cascade,

  nome varchar(100) not null,

  -- Senha e e-mail ficam no Supabase Auth, não aqui.

  tipo text not null default 'ALUNO'
       check (tipo in ('ALUNO', 'PROFESSOR', 'ADMIN')),

  idade int check (idade between 7 and 18),

  -- Aluno: vazio (a escola vem pela turma).
  escola_id bigint references escolas(id) on delete set null,

  -- Só o ALUNO preenche.
  turma_id bigint references turmas(id) on delete set null,

  created_at timestamptz not null default now()
);

alter table turmas drop constraint if exists turmas_professor_fk;
alter table turmas
  add constraint turmas_professor_fk
  foreign key (professor_id) references usuarios(id) on delete set null;


-- ── Conteúdo do jogo ─────────────────────────────────────────────────

create table if not exists cenarios (
  id bigint primary key generated always as identity,
  slug varchar(50) not null unique,   -- 'ubs', 'mercado', 'farmacia'...
  nome varchar(100) not null,
  descricao text not null
);

-- Cada questão tem o próprio cenário e faixa etária.
create table if not exists questoes (
  id bigint primary key generated always as identity,
  cenario_id bigint not null references cenarios(id) on delete cascade,

  -- Faixa etária: 1 = 7–10 anos, 2 = 11–14, 3 = 15–18.
  nivel_etario int not null check (nivel_etario between 1 and 3),

  enunciado text not null,
  opcao_a varchar(255) not null,
  opcao_b varchar(255) not null,
  -- C e D podem ser nulas (questões de V/F).
  opcao_c varchar(255),
  opcao_d varchar(255),
  -- E só no nível 3 (formato ENEM).
  opcao_e varchar(255),
  resposta_correta char(1) not null check (resposta_correta in ('A','B','C','D','E')),

  -- Texto mostrado depois da resposta.
  explicacao text not null
);

-- Filtro do sorteio de questões do quiz.
create index if not exists questoes_por_cenario_e_nivel on questoes (cenario_id, nivel_etario);

-- Identificador estável do import: permite "on conflict do update" sem perder respostas.
alter table questoes add column if not exists codigo_externo varchar(60);

-- Bancos antigos: C e D passam a aceitar nulo.
alter table questoes alter column opcao_c drop not null;
alter table questoes alter column opcao_d drop not null;

-- Letra E: adiciona a coluna e troca o check antigo (A a D).
alter table questoes add column if not exists opcao_e varchar(255);

do $$
declare antigo record;
begin
  for antigo in
    select conname from pg_constraint
    where conrelid = 'public.questoes'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%resposta_correta%'
      and pg_get_constraintdef(oid) not ilike '%''E''%'
  loop
    execute format('alter table questoes drop constraint %I', antigo.conname);
  end loop;

  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.questoes'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%resposta_correta%'
  ) then
    alter table questoes add constraint questoes_resposta_correta_check
      check (resposta_correta in ('A','B','C','D','E'));
  end if;
end $$;

create unique index if not exists questoes_codigo_externo on questoes (codigo_externo);

-- Autor da questão: código do sistema (Medicina) ou id do professor. Sem FK de propósito.
alter table questoes add column if not exists criado_por uuid
  not null default '00000000-0000-0000-0000-000000000000';

create index if not exists questoes_por_criador on questoes (criado_por, cenario_id, nivel_etario);


-- ── As 8 barras e o que as alimenta ──────────────────────────────────

create table if not exists areas (
  nome varchar(50) primary key,
  ordem int not null
);

-- Meta de cada barra = pontos que o conteúdo dela rende (recalcular_metas()).
alter table areas add column if not exists meta int not null default 0;

insert into areas (nome, ordem) values
  ('Saúde', 1), ('Educação', 2), ('Vacinação', 3), ('Vetores', 4),
  ('Limpeza', 5), ('Alimentação', 6), ('Exercícios', 7), ('Felicidade', 8)
on conflict (nome) do nothing;

-- Pontos de cada questão em cada barra (sem linha aqui, o acerto não pontua).
create table if not exists questoes_areas (
  questao_id bigint not null references questoes(id) on delete cascade,
  area_nome varchar(50) not null references areas(nome) on delete cascade,
  pontos int not null default 10 check (pontos > 0),
  primary key (questao_id, area_nome)
);

-- O professor filtra o quiz por área ("só Vacinação").
create index if not exists questoes_areas_por_area on questoes_areas (area_nome);


-- ── Progresso do aluno ───────────────────────────────────────────────

create table if not exists progresso_areas (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  area_nome varchar(50) not null,
  porcentagem real default 0,
  pontos int default 0,
  unique (usuario_id, area_nome)
);

-- area_nome limitado às 8 barras (só aplica se não houver nome fora da lista).
alter table progresso_areas drop constraint if exists progresso_areas_area_fk;
do $$
declare fora int;
begin
  select count(*) into fora
  from progresso_areas p
  where not exists (select 1 from areas a where a.nome = p.area_nome);

  if fora > 0 then
    raise warning
      'FK de progresso_areas NAO aplicada: % linha(s) com area_nome fora das 8 barras. Veja: select distinct area_nome from progresso_areas;',
      fora;
  else
    alter table progresso_areas
      add constraint progresso_areas_area_fk
      foreign key (area_nome) references areas(nome) on delete cascade;
  end if;
end $$;

create table if not exists respostas_alunos (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  acertou boolean not null,
  data_resposta timestamptz not null default now()
);

-- Consultado a cada resposta para saber se é o primeiro acerto.
create index if not exists respostas_por_aluno_e_questao
  on respostas_alunos (usuario_id, questao_id);


create table if not exists pacientes_virtuais (
  id bigint primary key generated always as identity,
  usuario_id uuid unique not null references usuarios(id) on delete cascade,
  nome_paciente varchar(100) not null,
  idade_paciente int not null,
  estado_saude varchar(100) default 'Estável'
);

create table if not exists quizzes_professores (
  id bigint primary key generated always as identity,
  turma_id bigint not null references turmas(id) on delete cascade,
  professor_id uuid not null references usuarios(id) on delete cascade,
  titulo varchar(150) not null,
  tempo_limite_segundos int default 15,
  created_at timestamptz not null default now()
);

-- Como o quiz foi montado (registro). Mantenha os cinco alters juntos: o SQL Editor roda só o selecionado.
alter table quizzes_professores add column if not exists descricao varchar(200);
alter table quizzes_professores add column if not exists nivel_etario int
  check (nivel_etario between 1 and 3);
alter table quizzes_professores add column if not exists cenarios text[];
alter table quizzes_professores add column if not exists areas text[];
alter table quizzes_professores add column if not exists qtd_pedida int;

-- Recarrega o cache de schema do PostgREST.
notify pgrst, 'reload schema';


-- Questões sorteadas de cada quiz, congeladas na criação.
create table if not exists quiz_questoes (
  quiz_id bigint not null references quizzes_professores(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  ordem int not null,
  primary key (quiz_id, questao_id)
);

create index if not exists quiz_questoes_por_quiz on quiz_questoes (quiz_id, ordem);

-- Quiz de origem da resposta.
alter table respostas_alunos add column if not exists quiz_id bigint
  references quizzes_professores(id) on delete set null;

create index if not exists respostas_por_quiz on respostas_alunos (quiz_id);


-- Foto de perfil (URL ou data:image).
alter table usuarios add column if not exists avatar_url text;
-- XP diário: a chave (usuario_id, dia) garante um prêmio por dia.
create table if not exists xp_diario (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  dia date not null,
  pontos int not null default 50 check (pontos > 0),
  created_at timestamptz not null default now(),
  primary key (usuario_id, dia)
);


-- ── Insígnias ──
-- Regras: ACERTOS, ACERTOS_CENARIO, DIAS, MISSOES (sem uso), MISSOES_CENARIO, QUIZZES, ACERTOS_TURMA, DESCOBERTA.
-- DESCOBERTA: segredos do mapa, dados por POST /api/descobrir.
create table if not exists insignias (
  codigo varchar(40) primary key,
  nome varchar(60) not null,
  descricao varchar(160) not null,

  publico varchar(10) not null check (publico in ('ALUNO', 'PROFESSOR')),

  regra varchar(20) not null
        check (regra in ('ACERTOS', 'ACERTOS_CENARIO', 'DIAS', 'MISSOES',
                         'MISSOES_CENARIO', 'QUIZZES', 'ACERTOS_TURMA',
                         'DESCOBERTA')),
  alvo int not null check (alvo > 0),

  xp int not null default 0 check (xp >= 0),
  ordem int not null,

  -- Arquivo da arte em src/imgs/insignias/ (nulo = sem arte).
  imagem varchar(120)
);

-- Refaz o check de regras em bancos que já têm a tabela.
alter table insignias drop constraint if exists insignias_regra_check;
alter table insignias add constraint insignias_regra_check
  check (regra in ('ACERTOS', 'ACERTOS_CENARIO', 'DIAS', 'MISSOES',
                   'MISSOES_CENARIO', 'QUIZZES', 'ACERTOS_TURMA',
                   'DESCOBERTA'));

-- Lugar da insígnia ACERTOS_CENARIO (slug do mapa, sem FK de propósito).
alter table insignias add column if not exists cenario_slug varchar(40);

alter table insignias drop constraint if exists insignias_cenario_coerente;
alter table insignias add constraint insignias_cenario_coerente
  check ((regra = 'ACERTOS_CENARIO') = (cenario_slug is not null));

-- Insígnias do mesmo grupo são degraus de uma peça só (juntados por GET /minha-estante).
alter table insignias add column if not exists grupo varchar(40);


-- Conquistas: gravadas para nunca serem recalculadas.
create table if not exists insignias_usuarios (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  insignia_codigo varchar(40) not null references insignias(codigo) on delete cascade,
  conquistada_em timestamptz not null default now(),
  primary key (usuario_id, insignia_codigo)
);

create index if not exists insignias_por_usuario
  on insignias_usuarios (usuario_id, conquistada_em desc);


-- Quizzes concluídos: o XP do aluno e do professor fica gravado mesmo se o quiz for apagado.
create table if not exists quiz_concluidos (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  quiz_id bigint not null,
  professor_id uuid references usuarios(id) on delete set null,

  perguntas int not null check (perguntas > 0),
  respostas int not null check (respostas > 0),
  taxa real not null check (taxa >= 0 and taxa <= 1),

  xp_aluno int not null default 0 check (xp_aluno >= 0),
  xp_professor int not null default 0 check (xp_professor >= 0),

  concluido_em timestamptz not null default now(),
  primary key (usuario_id, quiz_id)
);

-- Para o professor somar o que as turmas dele renderam sem varrer a
-- tabela inteira.
create index if not exists conclusoes_por_professor
  on quiz_concluidos (professor_id, concluido_em desc);


-- O catálogo de insígnias fica em db/insignias.sql.

-- A estante do professor ainda não tem insígnias.


-- ── Recuperação de senha ──
-- Guarda só o hash do código, com limite de tentativas e um ticket para a troca.
create table if not exists codigos_recuperacao (
  id bigint primary key generated always as identity,
  email text not null,
  codigo_hash text not null,
  tentativas int not null default 0,
  expira_em timestamptz not null,
  ticket_hash text,
  ticket_expira_em timestamptz,
  usado_em timestamptz,
  criado_em timestamptz not null default now()
);

-- Busca o código mais recente de um e-mail.
create index if not exists codigos_por_email
  on codigos_recuperacao (email, criado_em desc);


-- Id da conta pelo e-mail. Só o servidor executa (revoke abaixo).
create or replace function public.conta_por_email(p_email text)
returns uuid
language sql stable security definer set search_path = auth, public as $$
  select id from auth.users where lower(email) = lower(trim(p_email)) limit 1;
$$;


-- ── O que o admin mexe ──

-- 1. Suspender em vez de apagar.
alter table usuarios add column if not exists suspenso boolean not null default false;
alter table usuarios add column if not exists suspenso_em timestamptz;
alter table usuarios add column if not exists suspenso_motivo varchar(200);


-- 2. Ajustes de XP feitos pelo admin, com quem fez e o motivo.
create table if not exists xp_ajustes (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  pontos int not null,                      -- pode ser negativo
  motivo varchar(200),
  feito_por uuid references usuarios(id) on delete set null,
  criado_em timestamptz not null default now()
);

create index if not exists ajustes_por_usuario on xp_ajustes (usuario_id);


-- 3. Nomes das patentes (a escada de XP continua no código).
create table if not exists patentes (
  id bigint primary key generated always as identity,
  tipo varchar(20) not null check (tipo in ('ALUNO', 'PROFESSOR')),
  ate int not null check (ate between 1 and 100),   -- último nível da faixa
  nome varchar(60) not null,
  unique (tipo, ate)
);

insert into patentes (tipo, ate, nome) values
  ('ALUNO',      10, 'Pequeno Aprendiz'),       ('PROFESSOR',  10, 'Monitor'),
  ('ALUNO',      20, 'Estudante'),              ('PROFESSOR',  20, 'Mentor Iniciante'),
  ('ALUNO',      30, 'Discípulo'),              ('PROFESSOR',  30, 'Instrutor'),
  ('ALUNO',      40, 'Buscador'),               ('PROFESSOR',  40, 'Preceptor'),
  ('ALUNO',      50, 'Erudito'),                ('PROFESSOR',  50, 'Mestre do Saber'),
  ('ALUNO',      60, 'Prodígio'),               ('PROFESSOR',  60, 'Arquimestre'),
  ('ALUNO',      70, 'Visionário'),             ('PROFESSOR',  70, 'Grão-Mestre'),
  ('ALUNO',      80, 'Polímata'),               ('PROFESSOR',  80, 'Venerável'),
  ('ALUNO',      90, 'Luminar'),                ('PROFESSOR',  90, 'Oráculo'),
  ('ALUNO',     100, 'Herdeiro do Saber'),      ('PROFESSOR', 100, 'Patrono do Conhecimento')
on conflict (tipo, ate) do nothing;


-- ── 2. FUNÇÕES AUXILIARES ──
-- security definer evita a recursão infinita do RLS quando uma policy de usuarios lê usuarios.

-- Converte texto em número, devolvendo NULL em vez de erro.

create or replace function public.texto_para_int(p text)
returns int language plpgsql immutable as $$
begin
  return nullif(trim(p), '')::int;
exception when others then
  return null;
end;
$$;

create or replace function public.texto_para_bigint(p text)
returns bigint language plpgsql immutable as $$
begin
  return nullif(trim(p), '')::bigint;
exception when others then
  return null;
end;
$$;

-- ── Quem sou eu ──────────────────────────────────────────────────────

create or replace function public.meu_tipo()
returns text language sql stable security definer set search_path = public as $$
  select u.tipo from usuarios u where u.id = auth.uid();
$$;

create or replace function public.eh_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from usuarios u where u.id = auth.uid() and u.tipo = 'ADMIN'
  );
$$;

create or replace function public.eh_meu_aluno(p_aluno uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1
    from usuarios a
    join turmas t on t.id = a.turma_id
    where a.id = p_aluno and t.professor_id = auth.uid()
  );
$$;

-- Busca uma turma pelo código (não lista os códigos).

create or replace function public.buscar_turma_por_codigo(p_codigo text)
returns table (id bigint, nome varchar, escola_id bigint, escola_nome varchar)
language sql security definer set search_path = public as $$
  -- left join: turmas novas não têm escola.
  select t.id, t.nome, t.escola_id, e.nome
  from turmas t
  left join escolas e on e.id = t.escola_id
  where t.codigo = upper(trim(p_codigo))
  limit 1;
$$;

-- O professor precisa ver o código das turmas DELE para entregar à sala.
create or replace function public.minhas_turmas()
returns table (id bigint, nome varchar, codigo varchar, escola_id bigint, total_alunos bigint)
language sql security definer set search_path = public as $$
  select
    t.id, t.nome, t.codigo, t.escola_id,
    (select count(*) from usuarios a where a.turma_id = t.id)
  from turmas t
  where t.professor_id = auth.uid()
  order by t.nome;
$$;

-- Soma pontos numa barra de forma atômica.

create or replace function public.somar_pontos(
  p_usuario uuid, p_area varchar, p_pontos int
)
returns void language plpgsql security definer set search_path = public as $$
declare
  -- Meta da barra (pontos que o conteúdo dela rende).
  v_meta int;
begin
  select meta into v_meta from areas where nome = p_area;

  -- Área sem conteúdo: soma o ponto sem calcular porcentagem.
  if v_meta is null or v_meta <= 0 then
    insert into progresso_areas (usuario_id, area_nome, pontos, porcentagem)
    values (p_usuario, p_area, p_pontos, 0)
    on conflict (usuario_id, area_nome) do update
      set pontos = progresso_areas.pontos + p_pontos;
    return;
  end if;

  insert into progresso_areas (usuario_id, area_nome, pontos, porcentagem)
  values (p_usuario, p_area, p_pontos, least(100, p_pontos::real / v_meta * 100))
  on conflict (usuario_id, area_nome) do update
    set pontos      = progresso_areas.pontos + p_pontos,
        porcentagem = least(100, (progresso_areas.pontos + p_pontos)::real / v_meta * 100);
end;
$$;


-- Refaz as metas a partir das questões do sistema e atualiza as porcentagens.
create or replace function public.recalcular_metas()
returns void language plpgsql security definer set search_path = public as $$
begin
  update areas a
     set meta = coalesce((
       select sum(qa.pontos)
         from questoes_areas qa
         join questoes q on q.id = qa.questao_id
        where qa.area_nome = a.nome
          and q.criado_por = '00000000-0000-0000-0000-000000000000'
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


-- Barras do aluno (GET /api/meu-progresso): pontos das questões acertadas sobre as dos quizzes
-- da turma atual + as já acertadas. Calculado na hora.
create or replace function public.progresso_do_aluno(p_usuario uuid)
returns table (area varchar, ordem int, pontos_ganhos bigint, pontos_possiveis bigint)
language sql stable security definer set search_path = public as $$
  with disponiveis as (
    select qq.questao_id
      from quiz_questoes qq
      join quizzes_professores qp on qp.id = qq.quiz_id
      join usuarios u on u.turma_id = qp.turma_id
     where u.id = p_usuario
  ),
  acertadas as (
    select distinct r.questao_id
      from respostas_alunos r
     where r.usuario_id = p_usuario and r.acertou
  ),
  universo as (
    select questao_id from disponiveis
    union
    select questao_id from acertadas
  ),
  pontos as (
    select qa.area_nome, qa.pontos, (ac.questao_id is not null) as ganho
      from universo un
      join questoes_areas qa on qa.questao_id = un.questao_id
      left join acertadas ac on ac.questao_id = un.questao_id
  )
  select a.nome,
         a.ordem,
         coalesce(sum(p.pontos) filter (where p.ganho), 0)::bigint,
         coalesce(sum(p.pontos), 0)::bigint
    from areas a
    left join pontos p on p.area_nome = a.nome
   group by a.nome, a.ordem
   order by a.ordem;
$$;

-- O "quizzes desta turma" da função acima.
create index if not exists quizzes_por_turma on quizzes_professores (turma_id);


-- ── 3. O PERFIL NASCE JUNTO COM A CONTA ──
-- Gatilho em auth.users cria o perfil; se falhar, cria um perfil mínimo (a conta nunca é recusada).

create or replace function public.criar_perfil_do_novo_usuario()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  meta        jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_nome      text;
  v_tipo      text;
  v_idade     int;
  v_turma_id  bigint;
  v_escola_id bigint;
  v_escola_nm text;
begin
  v_nome := nullif(trim(meta->>'nome'), '');
  if v_nome is null then
    v_nome := split_part(coalesce(new.email, 'heroi@'), '@', 1);
  end if;
  v_nome := left(v_nome, 100);

  v_tipo := upper(coalesce(nullif(trim(meta->>'tipo'), ''), 'ALUNO'));

  -- O metadado vem do navegador: ADMIN nunca sai do cadastro.
  if v_tipo not in ('ALUNO', 'PROFESSOR') then
    v_tipo := 'ALUNO';
  end if;

  begin
    if v_tipo = 'ALUNO' then
      v_idade := public.texto_para_int(meta->>'idade');

      -- O check da tabela recusa fora de 7..18 e derrubaria tudo.
      if v_idade is not null and (v_idade < 7 or v_idade > 18) then
        v_idade := null;
      end if;

      v_turma_id := public.texto_para_bigint(meta->>'turma_id');

      if v_turma_id is not null
         and not exists (select 1 from turmas t where t.id = v_turma_id) then
        v_turma_id := null;
      end if;

      v_escola_id := null;   -- a escola do aluno vem pela turma

    else
      -- Professor também não tem escola.
      v_escola_id := null;
    end if;

    insert into usuarios (id, nome, tipo, idade, escola_id, turma_id)
    values (new.id, v_nome, v_tipo, v_idade, v_escola_id, v_turma_id)
    on conflict (id) do nothing;

  exception when others then
    raise warning
      '[cadastro] perfil completo falhou para % (%): % / meta=%',
      new.id, new.email, sqlerrm, meta;

    begin
      insert into usuarios (id, nome, tipo)
      values (new.id, v_nome, 'ALUNO')
      on conflict (id) do nothing;
    exception when others then
      raise warning '[cadastro] perfil minimo tambem falhou para %: %', new.id, sqlerrm;
    end;
  end;

  return new;
end;
$$;

drop trigger if exists ao_criar_conta on auth.users;
create trigger ao_criar_conta
  after insert on auth.users
  for each row execute function public.criar_perfil_do_novo_usuario();

-- Adota quem já ficou órfão antes do gatilho existir.
insert into usuarios (id, nome, tipo)
select
  u.id,
  coalesce(nullif(trim(u.raw_user_meta_data->>'nome'), ''), split_part(u.email, '@', 1)),
  'ALUNO'
from auth.users u
left join usuarios p on p.id = u.id
where p.id is null
on conflict (id) do nothing;


-- ── 4. SEGURANÇA (RLS) ──

alter table escolas             enable row level security;
alter table turmas              enable row level security;
alter table usuarios            enable row level security;
alter table cenarios            enable row level security;
alter table questoes            enable row level security;
alter table areas               enable row level security;
alter table questoes_areas      enable row level security;
alter table progresso_areas     enable row level security;
alter table respostas_alunos    enable row level security;
alter table pacientes_virtuais  enable row level security;
alter table quizzes_professores enable row level security;


-- ── usuarios ─────────────────────────────────────────────────────────

drop policy if exists "ler o proprio cadastro"              on usuarios;
drop policy if exists "criar o proprio cadastro"            on usuarios;
drop policy if exists "editar o proprio cadastro"           on usuarios;
drop policy if exists "professor le os alunos das turmas dele" on usuarios;
drop policy if exists "admin le todos os cadastros"         on usuarios;
drop policy if exists "admin edita qualquer cadastro"       on usuarios;

create policy "ler o proprio cadastro"
  on usuarios for select to authenticated using (auth.uid() = id);

create policy "criar o proprio cadastro"
  on usuarios for insert to authenticated with check (auth.uid() = id);

-- Edita o próprio cadastro, mas não muda o próprio tipo.
create policy "editar o proprio cadastro"
  on usuarios for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id and tipo = public.meu_tipo());

create policy "professor le os alunos das turmas dele"
  on usuarios for select to authenticated using (public.eh_meu_aluno(usuarios.id));

create policy "admin le todos os cadastros"
  on usuarios for select to authenticated using (public.eh_admin());

create policy "admin edita qualquer cadastro"
  on usuarios for update to authenticated
  using (public.eh_admin()) with check (public.eh_admin());


-- Escolas (aposentada): só o admin.

drop policy if exists "qualquer um le as escolas" on escolas;
drop policy if exists "logado cria escola"        on escolas;
drop policy if exists "admin cuida das escolas"   on escolas;

create policy "admin cuida das escolas"
  on escolas for all to authenticated
  using (public.eh_admin()) with check (public.eh_admin());


-- ── turmas ───────────────────────────────────────────────────────────

drop policy if exists "qualquer um le as turmas"        on turmas;
drop policy if exists "professor cria turma"            on turmas;
drop policy if exists "professor altera a propria turma" on turmas;
drop policy if exists "professor apaga a propria turma" on turmas;
drop policy if exists "admin cuida das turmas"          on turmas;
drop policy if exists "admin apaga turma"               on turmas;

create policy "qualquer um le as turmas"
  on turmas for select to anon, authenticated using (true);

create policy "professor cria turma"
  on turmas for insert to authenticated
  with check (public.meu_tipo() in ('PROFESSOR', 'ADMIN'));

create policy "professor altera a propria turma"
  on turmas for update to authenticated using (professor_id = auth.uid());

-- Turma com aluno dentro não é apagada: o progresso deles iria junto.
create policy "professor apaga a propria turma"
  on turmas for delete to authenticated
  using (
    professor_id = auth.uid()
    and not exists (select 1 from usuarios a where a.turma_id = turmas.id)
  );

create policy "admin cuida das turmas"
  on turmas for update to authenticated
  using (public.eh_admin()) with check (public.eh_admin());

create policy "admin apaga turma"
  on turmas for delete to authenticated using (public.eh_admin());


-- Conteúdo do jogo: todos leem, só o admin escreve.

do $$
declare t text;
begin
  foreach t in array array['cenarios', 'questoes', 'areas', 'questoes_areas'] loop
    execute format('drop policy if exists "logado le o conteudo" on %I', t);
    execute format('drop policy if exists "admin escreve o conteudo" on %I', t);

    execute format(
      'create policy "admin escreve o conteudo" on %I for all to authenticated
         using (public.eh_admin()) with check (public.eh_admin())', t);
  end loop;

  foreach t in array array['cenarios', 'areas'] loop
    execute format(
      'create policy "logado le o conteudo" on %I for select to authenticated using (true)', t);
  end loop;
end $$;

-- Questões do sistema: todo logado lê; as de professor, só o autor e o admin.
drop policy if exists "le as questoes do sistema e as proprias" on questoes;

create policy "le as questoes do sistema e as proprias"
  on questoes for select to authenticated using (
    criado_por = '00000000-0000-0000-0000-000000000000'
    or criado_por = auth.uid()
    or public.eh_admin()
  );

-- Pontos por área seguem a visibilidade da questão.
drop policy if exists "le as areas das questoes que enxerga" on questoes_areas;

create policy "le as areas das questoes que enxerga"
  on questoes_areas for select to authenticated using (
    exists (select 1 from questoes q where q.id = questoes_areas.questao_id)
  );

-- A linha tem o gabarito: quem esconde as colunas é a seção 5.


-- Progresso: o aluno só lê; quem escreve é o servidor.

drop policy if exists "le o proprio progresso"                on progresso_areas;
drop policy if exists "cria o proprio progresso"              on progresso_areas;
drop policy if exists "altera o proprio progresso"            on progresso_areas;
drop policy if exists "professor le o progresso dos alunos dele" on progresso_areas;

create policy "le o proprio progresso"
  on progresso_areas for select to authenticated using (auth.uid() = usuario_id);

create policy "professor le o progresso dos alunos dele"
  on progresso_areas for select to authenticated using (public.eh_meu_aluno(usuario_id));

drop policy if exists "le as proprias respostas"               on respostas_alunos;
drop policy if exists "cria as proprias respostas"             on respostas_alunos;
drop policy if exists "professor le as respostas dos alunos dele" on respostas_alunos;

create policy "le as proprias respostas"
  on respostas_alunos for select to authenticated using (auth.uid() = usuario_id);

create policy "professor le as respostas dos alunos dele"
  on respostas_alunos for select to authenticated using (public.eh_meu_aluno(usuario_id));

drop policy if exists "le o proprio paciente"    on pacientes_virtuais;
drop policy if exists "cria o proprio paciente"  on pacientes_virtuais;
drop policy if exists "altera o proprio paciente" on pacientes_virtuais;

create policy "le o proprio paciente"
  on pacientes_virtuais for select to authenticated using (auth.uid() = usuario_id);


-- ── Quizzes do professor ─────────────────────────────────────────────

drop policy if exists "professor le os proprios quizzes"    on quizzes_professores;
drop policy if exists "professor cria os proprios quizzes"  on quizzes_professores;
drop policy if exists "professor altera os proprios quizzes" on quizzes_professores;
drop policy if exists "professor apaga os proprios quizzes" on quizzes_professores;

create policy "professor le os proprios quizzes"
  on quizzes_professores for select to authenticated using (auth.uid() = professor_id);
create policy "professor cria os proprios quizzes"
  on quizzes_professores for insert to authenticated with check (auth.uid() = professor_id);
create policy "professor altera os proprios quizzes"
  on quizzes_professores for update to authenticated using (auth.uid() = professor_id);
create policy "professor apaga os proprios quizzes"
  on quizzes_professores for delete to authenticated using (auth.uid() = professor_id);

-- Aluno lê os quizzes da turma dele.
drop policy if exists "aluno le os quizzes da turma dele" on quizzes_professores;

create policy "aluno le os quizzes da turma dele"
  on quizzes_professores for select to authenticated using (
    turma_id in (select u.turma_id from usuarios u where u.id = auth.uid())
  );


-- Questões dos quizzes: só leitura (quem escreve é o servidor).
alter table quiz_questoes enable row level security;

drop policy if exists "professor le as questoes dos proprios quizzes" on quiz_questoes;
drop policy if exists "aluno le as questoes do quiz da turma dele"    on quiz_questoes;

create policy "professor le as questoes dos proprios quizzes"
  on quiz_questoes for select to authenticated using (
    quiz_id in (select q.id from quizzes_professores q where q.professor_id = auth.uid())
  );

create policy "aluno le as questoes do quiz da turma dele"
  on quiz_questoes for select to authenticated using (
    quiz_id in (
      select q.id from quizzes_professores q
      join usuarios u on u.turma_id = q.turma_id
      where u.id = auth.uid()
    )
  );


-- XP e insígnias: só leitura (quem escreve é o servidor).
alter table xp_diario          enable row level security;
alter table insignias          enable row level security;
alter table insignias_usuarios enable row level security;
alter table quiz_concluidos    enable row level security;


-- Códigos de recuperação: RLS sem policy (só o servidor acessa).
alter table codigos_recuperacao enable row level security;


-- Ajustes de XP: só o admin lê; quem grava é o servidor.
alter table xp_ajustes enable row level security;

drop policy if exists "admin le os ajustes" on xp_ajustes;

create policy "admin le os ajustes"
  on xp_ajustes for select to authenticated using (public.eh_admin());

-- Patentes: todo logado lê, só o admin escreve.
alter table patentes enable row level security;

drop policy if exists "todos leem as patentes" on patentes;
drop policy if exists "admin cuida das patentes" on patentes;

create policy "todos leem as patentes"
  on patentes for select to authenticated using (true);

create policy "admin cuida das patentes"
  on patentes for all to authenticated
  using (public.eh_admin()) with check (public.eh_admin());

revoke execute on function public.conta_por_email(text) from public;
revoke execute on function public.conta_por_email(text) from anon, authenticated;

drop policy if exists "le as proprias conclusoes"           on quiz_concluidos;
drop policy if exists "professor le as conclusoes da turma" on quiz_concluidos;

create policy "le as proprias conclusoes"
  on quiz_concluidos for select to authenticated using (auth.uid() = usuario_id);

-- O professor lê as conclusões que renderam XP para ele.
create policy "professor le as conclusoes da turma"
  on quiz_concluidos for select to authenticated using (auth.uid() = professor_id);

drop policy if exists "le o proprio xp diario" on xp_diario;

create policy "le o proprio xp diario"
  on xp_diario for select to authenticated using (auth.uid() = usuario_id);

-- Todo logado lê o catálogo de insígnias.
drop policy if exists "todos leem o catalogo de insignias" on insignias;

create policy "todos leem o catalogo de insignias"
  on insignias for select to authenticated using (true);

drop policy if exists "le as proprias insignias"            on insignias_usuarios;
drop policy if exists "professor le as insignias dos alunos" on insignias_usuarios;

create policy "le as proprias insignias"
  on insignias_usuarios for select to authenticated using (auth.uid() = usuario_id);

-- O professor vê as insígnias dos alunos dele.
create policy "professor le as insignias dos alunos"
  on insignias_usuarios for select to authenticated using (public.eh_meu_aluno(usuario_id));


-- ── 5. PERMISSÃO POR COLUNA ──
-- O RLS não esconde colunas: turmas.codigo fica de fora do select público.

revoke select on turmas from anon, authenticated;
grant  select (id, nome, escola_id, created_at) on turmas to anon, authenticated;

-- Gabarito (resposta_correta e explicacao) fora do select do navegador; só o servidor lê.
revoke select on questoes from anon, authenticated;
grant  select (id, cenario_id, nivel_etario, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e)
  on questoes to anon, authenticated;

grant execute on function public.buscar_turma_por_codigo(text) to anon, authenticated;
grant execute on function public.minhas_turmas() to authenticated;

-- Só o servidor pontua (revoga também de PUBLIC, de onde todos herdam).
revoke execute on function public.somar_pontos(uuid, varchar, int) from public;
revoke execute on function public.somar_pontos(uuid, varchar, int) from anon, authenticated;

-- Mesma trava para recalcular_metas().
revoke execute on function public.recalcular_metas() from public;
revoke execute on function public.recalcular_metas() from anon, authenticated;

-- Só o servidor lê as barras de um aluno.
revoke execute on function public.progresso_do_aluno(uuid) from public;
revoke execute on function public.progresso_do_aluno(uuid) from anon, authenticated;

-- No próprio cadastro, o navegador só altera nome e foto.
revoke update on usuarios from anon, authenticated;
grant  update (nome, avatar_url) on usuarios to authenticated;


-- ── 6. CONFERIR SE DEU CERTO (ou use db/00-testSecurity.sql) ──

-- (a) Todas com rowsecurity = true:
-- select tablename, rowsecurity from pg_tables where schemaname = 'public' order by rowsecurity, tablename;

-- (b) Nenhuma conta sem perfil:
-- select count(*) as contas_orfas from auth.users u left join public.usuarios p on p.id = u.id where p.id is null;

-- (c) Visitante sem codigo/professor_id (4 colunas por grantee):
-- select grantee, column_name from information_schema.column_privileges where table_name = 'turmas' and privilege_type = 'SELECT' and grantee in ('anon','authenticated') order by grantee, column_name;

-- (d) Gatilho ligado (tgenabled = 'O'):
-- select tgname, tgenabled from pg_trigger where tgrelid = 'auth.users'::regclass and not tgisinternal;

-- (e) Gabarito escondido (9 colunas por grantee, sem resposta_correta/explicacao):
-- select grantee, column_name from information_schema.column_privileges where table_name = 'questoes' and privilege_type = 'SELECT' and grantee in ('anon','authenticated') order by grantee, column_name;

-- (f) somar_pontos sem "=X/" (PUBLIC) no proacl:
-- select proname, proacl from pg_proc where proname = 'somar_pontos';


-- ── 7. Recarrega o cache de schema da API (fica no fim de propósito) ──

notify pgrst, 'reload schema';
