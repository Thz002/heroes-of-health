-- =====================================================================
--  HERÓIS DA SAÚDE — o banco inteiro, em um arquivo
--
--  Este arquivo substitui as migrações 01, 02, 03, 04 e o schema.sql,
--  que foram para db/_historico/. Ele descreve o banco COMO ELE DEVE
--  SER, e sabe se virar tanto num projeto novo e vazio quanto num que
--  já tem tabelas e gente cadastrada.
--
--  POR QUE UM ARQUIVO SÓ, E NÃO UMA PILHA DE MIGRAÇÕES:
--  histórico de migração serve para proteger dado de produção que não
--  pode ser perdido. Este projeto não tem isso — tem uma equipe de
--  faculdade mexendo num banco de teste. Aqui o histórico só atrapalha:
--  são mais arquivos para ler, mais ordem para lembrar, e mais chance de
--  rodar na sequência errada. Quando alguma coisa mudar, MUDE ESTE
--  ARQUIVO e rode de novo.
--
--  É seguro rodar quantas vezes quiser: tudo usa
--  "if not exists" / "drop ... if exists" / "create or replace".
--  NÃO apaga nenhum dado.
--
--  Onde rodar: painel do Supabase -> SQL Editor -> colar tudo -> Run
--  Depois deste, rode o seed.sql (os 7 cenários do mapa).
--
--  Dialeto: PostgreSQL. Não é MySQL, apesar do que diz o README.
-- =====================================================================


-- #####################################################################
--  1. TABELAS
-- #####################################################################

-- ── Institucional ────────────────────────────────────────────────────

create table if not exists escolas (
  id bigint primary key generated always as identity,
  nome varchar(150) not null,
  created_at timestamptz not null default now()
);

-- O unique fica fora do create table porque a tabela pode já existir sem
-- ele. Sem essa regra o banco enche de duplicata ('Santa Maria',
-- 'Colegio Santa Maria'...) e a lista do cadastro fica impossível de usar.
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
  escola_id bigint not null references escolas(id) on delete cascade,

  -- O código curto que o professor entrega para a sala (ex: '7B-K3M9').
  -- O aluno digita só isso e entra direto na turma certa.
  codigo varchar(12),

  -- Quem criou a turma. A FK é criada mais abaixo, porque usuarios
  -- ainda não existe neste ponto do arquivo.
  professor_id uuid,

  created_at timestamptz not null default now()
);

create unique index if not exists turmas_codigo_unico   on turmas (codigo);
create unique index if not exists turmas_nome_por_escola on turmas (escola_id, nome);


-- ── Pessoas ──────────────────────────────────────────────────────────

create table if not exists usuarios (
  -- O identificador NÃO é inventado por esta tabela: é o mesmo que o
  -- Supabase cria no login. "references auth.users(id)" amarra os dois,
  -- e é isso que faz auth.uid() (e portanto o RLS inteiro) funcionar.
  id uuid primary key references auth.users(id) on delete cascade,

  nome varchar(100) not null,

  -- Não existe coluna "senha" nem "email" aqui, de propósito: as duas
  -- vivem do lado do Supabase, junto com o login. Guardar senha em dois
  -- lugares é justamente o erro que este desenho evita.

  tipo text not null default 'ALUNO'
       check (tipo in ('ALUNO', 'PROFESSOR', 'ADMIN')),

  idade int check (idade between 7 and 18),

  -- ALUNO deixa em branco: a escola dele se descobre pela turma.
  -- PROFESSOR preenche com a escola onde trabalha.
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

create table if not exists missoes (
  id bigint primary key generated always as identity,
  cenario_id bigint not null references cenarios(id) on delete cascade,
  titulo varchar(150) not null,
  descricao text not null,

  -- Faixa etária, comparada com usuarios.idade:
  --   1 = 7 a 10 anos, 2 = 11 a 14, 3 = 15 a 18
  nivel_etario int not null default 1 check (nivel_etario between 1 and 3),

  eh_especial boolean not null default false
);

create table if not exists questoes (
  id bigint primary key generated always as identity,
  missao_id bigint not null references missoes(id) on delete cascade,
  enunciado text not null,
  opcao_a varchar(255) not null,
  opcao_b varchar(255) not null,
  opcao_c varchar(255) not null,
  opcao_d varchar(255) not null,
  resposta_correta char(1) not null check (resposta_correta in ('A','B','C','D')),

  -- Texto educativo mostrado depois da resposta, escrito pela equipe de
  -- Medicina. Aparece também quando o aluno erra, em tom de incentivo.
  explicacao text not null
);


-- ── As 8 barras e o que as alimenta ──────────────────────────────────

create table if not exists areas (
  nome varchar(50) primary key,
  ordem int not null
);

insert into areas (nome, ordem) values
  ('Saúde', 1), ('Educação', 2), ('Vacinação', 3), ('Vetores', 4),
  ('Limpeza', 5), ('Alimentação', 6), ('Exercícios', 7), ('Felicidade', 8)
on conflict (nome) do nothing;

-- Quanto cada missão vale em cada barra. Sem uma linha aqui, acertar a
-- questão não pontua nada. Antes esta ligação não existia: a regra das 8
-- áreas estava só na cabeça da equipe, e o servidor não tinha o que
-- consultar na hora de pontuar.
create table if not exists missao_areas (
  missao_id bigint not null references missoes(id) on delete cascade,
  area_nome varchar(50) not null references areas(nome) on delete cascade,
  pontos int not null default 10 check (pontos > 0),
  primary key (missao_id, area_nome)
);


-- ── Progresso do aluno ───────────────────────────────────────────────

create table if not exists progresso_areas (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  area_nome varchar(50) not null,
  porcentagem real default 0,
  pontos int default 0,
  unique (usuario_id, area_nome)
);

-- Fecha area_nome na lista das 8. O DO block existe para este arquivo
-- não morrer no meio caso já haja progresso com um nome fora da lista.
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


-- #####################################################################
--  2. FUNÇÕES AUXILIARES
--
--  Quase todas são "security definer", e isso não é detalhe: é o que
--  evita a armadilha número um do RLS. Uma policy DA tabela usuarios que
--  fizesse "select tipo from usuarios" cairia nas policies de usuarios
--  de novo, que consultariam usuarios de novo... até o PostgreSQL
--  abortar com "infinite recursion detected in policy" (42P17).
--
--  "security definer" faz a função rodar como dona da tabela, e dona de
--  tabela não passa pelo RLS. A recursão para aí.
-- #####################################################################

-- ── Conversão segura de texto para número ────────────────────────────
-- O metadado do cadastro chega como texto, vindo do navegador. Estas
-- devolvem NULL em vez de estourar quando o texto não é número — melhor
-- um cadastro com a idade em branco do que nenhum cadastro.

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

-- ── Turma pelo código ────────────────────────────────────────────────
-- Pergunta fechada: manda-se um código e recebe-se UMA turma, ou nada.
-- Não dá para varrer a tabela atrás de todos os códigos.

create or replace function public.buscar_turma_por_codigo(p_codigo text)
returns table (id bigint, nome varchar, escola_id bigint, escola_nome varchar)
language sql security definer set search_path = public as $$
  select t.id, t.nome, t.escola_id, e.nome
  from turmas t
  join escolas e on e.id = t.escola_id
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

-- ── Pontuação ────────────────────────────────────────────────────────
-- Soma pontos numa barra, criando a linha se for a primeira vez.
--
-- É função (e não um update no backend) por causa da corrida: duas
-- respostas quase simultâneas fariam "ler 40, somar 10, gravar 50" duas
-- vezes e um dos acertos sumiria. Aqui a soma acontece dentro do próprio
-- update, e o banco resolve.

create or replace function public.somar_pontos(
  p_usuario uuid, p_area varchar, p_pontos int
)
returns void language plpgsql security definer set search_path = public as $$
declare
  -- Quantos pontos enchem uma barra. Provisório: quem define a curva de
  -- progressão é a equipe de Medicina junto com a de Computação.
  meta constant int := 500;
begin
  insert into progresso_areas (usuario_id, area_nome, pontos, porcentagem)
  values (p_usuario, p_area, p_pontos, least(100, p_pontos::real / meta * 100))
  on conflict (usuario_id, area_nome) do update
    set pontos      = progresso_areas.pontos + p_pontos,
        porcentagem = least(100, (progresso_areas.pontos + p_pontos)::real / meta * 100);
end;
$$;


-- #####################################################################
--  3. O PERFIL NASCE JUNTO COM A CONTA
--
--  O BUG QUE ISTO RESOLVE: o cadastro fazia duas escritas separadas —
--  o Supabase criava a linha em auth.users, e depois o navegador tentava
--  criar a linha em usuarios. Não era uma transação. Quando a segunda
--  falhava, sobrava uma conta que fazia login mas que o jogo não
--  conhecia: o usuário aparecia na aba "Users" e não na tabela usuarios.
--
--  A REGRA QUE ORGANIZA A FUNÇÃO:
--      o perfil completo é uma tentativa; a conta existir é obrigação.
--
--  Por isso o miolo fica num bloco com "exception". Quando a função de um
--  gatilho em auth.users lança erro, o Supabase desfaz a criação da conta
--  e responde "Database error saving new user" — sem dizer a causa. Ou
--  seja, um descuido aqui dentro vira "a turma inteira não consegue se
--  cadastrar". Se o perfil completo falhar, entra um perfil mínimo e o
--  motivo real vai para o log (painel -> Logs -> Postgres).
-- #####################################################################

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

  -- ATENÇÃO: raw_user_meta_data é preenchido pelo NAVEGADOR, então é
  -- informação que a própria pessoa controla. Nada daqui pode ser aceito
  -- sem conferência. ADMIN nunca sai de um cadastro — promover é manual:
  --     update usuarios set tipo = 'ADMIN' where id = '...';
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
      v_escola_id := public.texto_para_bigint(meta->>'escola_id');
      v_escola_nm := nullif(trim(meta->>'escola_nome'), '');

      if v_escola_id is not null
         and not exists (select 1 from escolas e where e.id = v_escola_id) then
        v_escola_id := null;
      end if;

      -- Professor cadastrando escola nova.
      -- Procura antes de inserir em vez de usar "on conflict (nome)":
      -- aquela cláusula exige uma constraint unique e falha com 42P10 se
      -- ela não existir. Assim funciona com ou sem a constraint.
      if v_escola_id is null and v_escola_nm is not null then
        select e.id into v_escola_id
        from escolas e where lower(e.nome) = lower(v_escola_nm) limit 1;

        if v_escola_id is null then
          insert into escolas (nome) values (left(v_escola_nm, 150))
          returning id into v_escola_id;
        end if;
      end if;
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


-- #####################################################################
--  4. SEGURANÇA (RLS)
--
--  Sem isto, TODAS as tabelas ficam abertas: qualquer visitante com a
--  chave publishable lê e escreve pelo navegador. Criar tabela não
--  tranca nada — trancar é este bloco.
--
--  Como ler:
--    for select -> quem LÊ      for insert -> quem CRIA
--    for update -> quem ALTERA  for delete -> quem APAGA
--    to anon    -> qualquer visitante, mesmo sem conta
--    to authenticated -> só quem entrou
--    auth.uid() -> o identificador de quem está logado agora
-- #####################################################################

alter table escolas             enable row level security;
alter table turmas              enable row level security;
alter table usuarios            enable row level security;
alter table cenarios            enable row level security;
alter table missoes             enable row level security;
alter table questoes            enable row level security;
alter table areas               enable row level security;
alter table missao_areas        enable row level security;
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

-- Pode corrigir o próprio nome, mas NÃO pode se promover. Sem esta
-- trava, qualquer aluno viraria PROFESSOR com um update e passaria a
-- ler os dados dos colegas.
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


-- ── escolas ──────────────────────────────────────────────────────────
-- Legível por VISITANTE de propósito: o aluno escolhe a escola durante o
-- cadastro, ou seja, ANTES de ter conta.

drop policy if exists "qualquer um le as escolas" on escolas;
drop policy if exists "logado cria escola"        on escolas;
drop policy if exists "admin cuida das escolas"   on escolas;

create policy "qualquer um le as escolas"
  on escolas for select to anon, authenticated using (true);

-- Normalmente quem cria escola é o gatilho do cadastro, que roda como
-- dono e nem passa por aqui. Esta policy cobre o caso do professor
-- criando escola pela tela depois de já estar logado.
create policy "logado cria escola"
  on escolas for insert to authenticated with check (true);

create policy "admin cuida das escolas"
  on escolas for update to authenticated
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


-- ── Conteúdo do jogo: todos leem, só o admin escreve ─────────────────

do $$
declare t text;
begin
  foreach t in array array['cenarios', 'missoes', 'questoes', 'areas', 'missao_areas'] loop
    execute format('drop policy if exists "logado le o conteudo" on %I', t);
    execute format('drop policy if exists "admin escreve o conteudo" on %I', t);

    execute format(
      'create policy "logado le o conteudo" on %I for select to authenticated using (true)', t);
    execute format(
      'create policy "admin escreve o conteudo" on %I for all to authenticated
         using (public.eh_admin()) with check (public.eh_admin())', t);
  end loop;
end $$;

-- ⚠️ ATENÇÃO à tabela questoes: a policy acima libera a LINHA INTEIRA,
-- e a linha tem resposta_correta. Um aluno logado consegue ler o
-- gabarito pelo console do navegador.
--
-- Por isso o quiz NÃO pode consultar questoes direto: ele passa pelo
-- servidor Express (server/rotas/jogo.js), que é o único que enxerga
-- essa coluna e devolve só "acertou" mais a explicação.


-- ── Progresso do aluno ───────────────────────────────────────────────
--
-- O aluno só LÊ. Quem escreve é o servidor Express, com a chave secreta.
--
-- Não é excesso de zelo: com permissão de update, o aluno fazia
--     update progresso_areas set pontos = 999999
-- na própria linha pelo console, e o banco aceitava — a linha era dele.
-- "Esta linha é sua?" o RLS responde bem; "você merece estes pontos?"
-- é regra de jogo, e regra de jogo mora no servidor.

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


-- #####################################################################
--  5. PERMISSÃO POR COLUNA
--
--  O RLS é por LINHA e não sabe esconder uma coluna. Mas a policy de
--  turmas precisa liberar a linha para VISITANTE (o aluno escolhe a
--  turma antes de ter conta) — e a linha tem o "codigo", que deveria ser
--  a credencial que o professor entrega à sala.
--
--  Sem isto, "select codigo from turmas" devolvia todos os códigos de
--  todas as escolas, e o código não filtrava ninguém.
--
--  Quem resolve é a permissão por COLUNA, que o PostgreSQL tem.
--  Quem precisa do código legitimamente usa minhas_turmas() ou o
--  servidor Express.
-- #####################################################################

revoke select on turmas from anon, authenticated;
grant  select (id, nome, escola_id, created_at) on turmas to anon, authenticated;

grant execute on function public.buscar_turma_por_codigo(text) to anon, authenticated;
grant execute on function public.minhas_turmas() to authenticated;

-- Pontuar é assunto do servidor. O aluno não executa isto.
revoke execute on function public.somar_pontos(uuid, varchar, int) from anon, authenticated;


-- #####################################################################
--  6. CONFERIR SE DEU CERTO
--
--  Descomente e rode. Ou use db/00-testSecurity.sql, que já traz tudo.
-- #####################################################################

-- (a) Todas as tabelas devem vir com rowsecurity = true.
-- select tablename, rowsecurity from pg_tables
-- where schemaname = 'public' order by rowsecurity, tablename;

-- (b) Não deve sobrar nenhuma conta sem perfil.
-- select count(*) as contas_orfas from auth.users u
-- left join public.usuarios p on p.id = u.id where p.id is null;

-- (c) O visitante não enxerga codigo nem professor_id.
--     Devem vir 4 colunas por grantee: created_at, escola_id, id, nome.
--     O filtro por privilege_type é obrigatório — sem ele a consulta
--     traz INSERT/UPDATE/REFERENCES junto e parece que o revoke falhou.
-- select grantee, column_name from information_schema.column_privileges
-- where table_name = 'turmas' and privilege_type = 'SELECT'
--   and grantee in ('anon','authenticated') order by grantee, column_name;

-- (d) O gatilho está ligado? Uma linha, tgenabled = 'O'.
-- select tgname, tgenabled from pg_trigger
-- where tgrelid = 'auth.users'::regclass and not tgisinternal;
