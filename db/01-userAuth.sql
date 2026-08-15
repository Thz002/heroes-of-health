-- =====================================================================
--  MIGRAÇÃO 01 — Ligar a tabela "usuarios" ao login do Supabase
--
--  O QUE ESTE SCRIPT FAZ, EM UMA FRASE:
--  faz a tabela "usuarios" parar de inventar números sequenciais (1, 2, 3...)
--  e passar a usar o identificador que o Supabase cria no login.
--
--  ATENÇÃO: este script APAGA e recria 5 tabelas. Só rode se elas
--  estiverem vazias. A consulta da PARTE 0 confere isso para você.
--
--  Onde rodar: painel do Supabase -> SQL Editor -> New query -> colar -> Run
-- =====================================================================


-- =====================================================================
--  PARTE 0 — CONFERIR ANTES DE APAGAR
--
--  Rode SÓ estas linhas primeiro (selecione e clique em Run).
--  Se todos os números vierem zerados, pode seguir tranquilo.
--  Se algum vier diferente de zero, PARE e me avise.
-- =====================================================================

-- select
--   (select count(*) from usuarios)             as usuarios,
--   (select count(*) from progresso_areas)      as progresso,
--   (select count(*) from respostas_alunos)     as respostas,
--   (select count(*) from pacientes_virtuais)   as pacientes,
--   (select count(*) from quizzes_professores)  as quizzes;


-- =====================================================================
--  PARTE 1 — APAGAR AS TABELAS ANTIGAS
--
--  Precisamos apagar "usuarios" para recriá-la de outro jeito. Mas outras
--  4 tabelas apontam para ela, e o banco não deixa apagar uma tabela que
--  está sendo usada por outras. Por isso elas caem junto e são recriadas
--  logo abaixo, iguais, só trocando o tipo do identificador.
--
--  "if exists" quer dizer: se a tabela não existir, não reclame, siga.
-- =====================================================================

drop table if exists respostas_alunos    cascade;
drop table if exists progresso_areas     cascade;
drop table if exists pacientes_virtuais  cascade;
drop table if exists quizzes_professores cascade;
drop table if exists usuarios            cascade;


-- =====================================================================
--  PARTE 2 — COMPLETAR A TABELA "turmas"
--
--  Aqui entram as duas colunas que combinamos na conversa sobre o
--  cadastro, e que ainda não existiam no banco:
--
--    codigo       -> o código curto que o professor entrega para a sala
--                    (ex: 7B-K3M9), para o aluno entrar direto na turma
--    professor_id -> quem criou a turma
--
--  "add column if not exists" quer dizer: se a coluna já estiver lá,
--  não faça nada. Isso deixa o script seguro de rodar duas vezes.
-- =====================================================================

alter table turmas add column if not exists codigo       varchar(12);
alter table turmas add column if not exists professor_id uuid;

-- Impede duas turmas com o mesmo código.
create unique index if not exists turmas_codigo_unico on turmas (codigo);

-- Impede duas turmas com o mesmo nome dentro da mesma escola.
create unique index if not exists turmas_nome_por_escola on turmas (escola_id, nome);


-- =====================================================================
--  PARTE 3 — RECRIAR A TABELA "usuarios"  <<< O CORAÇÃO DA MUDANÇA
-- =====================================================================

create table usuarios (

  -- ESTA É A LINHA MAIS IMPORTANTE DO SCRIPT.
  --
  -- Antes era um número que a tabela inventava sozinha.
  -- Agora é o identificador que o Supabase criou no login.
  --
  -- "references auth.users(id)" é o que amarra os dois: o banco passa a
  -- exigir que exista um login de verdade antes de aceitar a linha aqui.
  -- Ou seja, fica impossível cadastrar alguém que não consegue entrar.
  --
  -- "on delete cascade" significa: se o login for apagado, esta linha
  -- some junto, sem deixar lixo para trás.
  id uuid primary key references auth.users(id) on delete cascade,

  nome varchar(100) not null,

  -- Repare que NÃO existe mais coluna "senha" nem "email" aqui.
  -- Os dois passaram a viver do lado do Supabase, na parte do login.
  -- Guardar senha em dois lugares seria justamente o erro que a gente
  -- está evitando.

  tipo text not null default 'ALUNO'
       check (tipo in ('ALUNO', 'PROFESSOR', 'ADMIN')),

  -- O jogo só tem missões para essa faixa de idade. O "check" faz o
  -- próprio banco recusar um valor fora dela, mesmo que o site erre.
  idade int check (idade between 7 and 18),

  -- ALUNO deixa em branco: a escola dele se descobre pela turma.
  -- PROFESSOR preenche com a escola onde trabalha.
  escola_id bigint references escolas(id) on delete set null,

  -- Só o ALUNO preenche.
  turma_id bigint references turmas(id) on delete set null,

  created_at timestamptz not null default now()
);


-- Agora que "usuarios" existe, podemos amarrar o professor da turma a ela.
alter table turmas
  add constraint turmas_professor_fk
  foreign key (professor_id) references usuarios(id) on delete set null;


-- =====================================================================
--  PARTE 4 — RECRIAR AS 4 TABELAS QUE DEPENDEM DE "usuarios"
--
--  São idênticas às de antes. A única diferença é que a coluna que
--  aponta para o usuário deixou de ser número e virou "uuid".
-- =====================================================================

-- As 8 barras de progresso do aluno
create table progresso_areas (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  area_nome varchar(50) not null,
  porcentagem real default 0,
  pontos int default 0,
  unique (usuario_id, area_nome)
);

-- Histórico de cada resposta dada pelo aluno
create table respostas_alunos (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  acertou boolean not null,
  data_resposta timestamptz not null default now()
);

-- O paciente virtual, um por aluno
create table pacientes_virtuais (
  id bigint primary key generated always as identity,
  usuario_id uuid unique not null references usuarios(id) on delete cascade,
  nome_paciente varchar(100) not null,
  idade_paciente int not null,
  estado_saude varchar(100) default 'Estável'
);

-- Os quizzes que o professor monta para a turma
create table quizzes_professores (
  id bigint primary key generated always as identity,
  turma_id bigint not null references turmas(id) on delete cascade,
  professor_id uuid not null references usuarios(id) on delete cascade,
  titulo varchar(150) not null,
  tempo_limite_segundos int default 15,
  created_at timestamptz not null default now()
);


-- =====================================================================
--  PARTE 5 — TRANCAR A TABELA "usuarios"
--
--  Lembra que o site conversa direto com o banco, sem nada no meio?
--  Sem estas regras, qualquer pessoa que abrisse as ferramentas do
--  navegador conseguiria pedir a lista de TODOS os alunos.
--
--  A partir daqui, o banco passa a recusar sozinho qualquer pedido que
--  não se encaixe nas regras abaixo.
--
--  Em todas elas, "auth.uid()" quer dizer "o identificador de quem
--  está logado agora". E "id" é a coluna da linha que ele quer acessar.
--  Então "auth.uid() = id" se lê como: "só se for a própria pessoa".
-- =====================================================================

alter table usuarios enable row level security;

-- Ler: cada pessoa enxerga só o próprio cadastro.
create policy "ler o proprio cadastro"
  on usuarios for select
  using (auth.uid() = id);

-- Criar: cada pessoa só cria um cadastro para ela mesma.
-- É isso que impede alguém de criar uma linha se passando por outro.
create policy "criar o proprio cadastro"
  on usuarios for insert
  with check (auth.uid() = id);

-- Alterar: cada pessoa só edita o próprio cadastro.
create policy "editar o proprio cadastro"
  on usuarios for update
  using (auth.uid() = id);

-- OBSERVAÇÃO PARA DEPOIS:
-- com só estas três regras, o professor ainda NÃO consegue ver os alunos
-- da turma dele — o banco vai bloquear, porque não é o próprio cadastro.
-- Isso é de propósito: é uma regra a mais, que a gente escreve quando for
-- construir o painel do professor.


-- =====================================================================
--  PARTE 6 — CONFERIR SE DEU CERTO
--
--  Rode esta consulta depois. Ela deve mostrar a coluna "id" da tabela
--  usuarios com o tipo "uuid".
-- =====================================================================

-- select column_name, data_type
-- from information_schema.columns
-- where table_name = 'usuarios' and table_schema = 'public'
-- order by ordinal_position;
