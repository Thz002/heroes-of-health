-- =====================================================================
--  ESQUEMA DO BANCO — Heróis da Saúde
--
--  Banco: PostgreSQL, hospedado no Supabase.
--  (A versão anterior deste arquivo estava escrita em MySQL e não rodava
--   no Supabase. Foi reescrita.)
--
--  Este arquivo descreve o banco COMO ELE É HOJE, depois das migrações
--  01 e 02. Serve para alguém recriar tudo do zero num projeto novo do
--  Supabase, na ordem certa:
--
--     1. este arquivo        -> cria as tabelas
--     2. migracao-02-seguranca.sql -> liga as regras de segurança
--     3. seed.sql            -> coloca escolas, turmas e cenários
--
--  Se o seu banco JÁ existe, não rode este arquivo: ele é o retrato, não
--  o comando. Para mudanças em banco existente, escreva uma migração nova.
--
--  Onde rodar: painel do Supabase -> SQL Editor
-- =====================================================================


-- ── Institucional ────────────────────────────────────────────────────

create table if not exists escolas (
  id bigint primary key generated always as identity,
  -- UNIQUE porque quem cadastra escola é o professor: sem isso o banco
  -- encheria de duplicatas ('Santa Maria', 'Colegio Santa Maria', ...).
  nome varchar(150) not null unique,
  created_at timestamptz not null default now()
);

create table if not exists turmas (
  id bigint primary key generated always as identity,
  nome varchar(50) not null,                   -- ex: '7º Ano B'
  escola_id bigint not null references escolas(id) on delete cascade,

  -- Código curto que o professor entrega para a sala (ex: '7B-K3M9').
  -- O aluno digita só isso no cadastro e entra direto na turma certa,
  -- sem precisar percorrer a lista de escolas.
  codigo varchar(12) unique,

  -- Quem criou a turma. Vira NULL se o professor for removido.
  -- A ligação com usuarios é feita mais abaixo, porque usuarios ainda
  -- não existe neste ponto do arquivo.
  professor_id uuid,

  created_at timestamptz not null default now(),

  -- Não existem duas turmas com o mesmo nome dentro da mesma escola.
  -- Em escolas diferentes pode repetir à vontade.
  unique (escola_id, nome)
);


-- ── Pessoas ──────────────────────────────────────────────────────────

create table if not exists usuarios (
  -- O identificador NÃO é inventado por esta tabela: é o mesmo que o
  -- Supabase cria quando a pessoa faz o cadastro de login.
  --
  -- "references auth.users(id)" amarra os dois: fica impossível existir
  -- alguém no jogo que não consegue entrar.
  id uuid primary key references auth.users(id) on delete cascade,

  nome varchar(100) not null,

  -- Não existe coluna "senha" nem "email" aqui, de propósito: as duas
  -- vivem do lado do Supabase, junto com o login. Guardar senha em dois
  -- lugares é justamente o erro que este desenho evita.

  tipo text not null default 'ALUNO'
       check (tipo in ('ALUNO', 'PROFESSOR', 'ADMIN')),

  -- O jogo só tem missões de 7 a 18 anos. O check faz o próprio banco
  -- recusar valores fora disso, mesmo que a tela deixe passar.
  idade int check (idade between 7 and 18),

  -- ALUNO deixa em branco: a escola dele se descobre pela turma.
  -- PROFESSOR preenche com a escola onde trabalha.
  escola_id bigint references escolas(id) on delete set null,

  -- Só o ALUNO preenche.
  turma_id bigint references turmas(id) on delete set null,

  created_at timestamptz not null default now()
);

-- A ligação turmas -> usuarios fica aqui porque as duas tabelas dependem
-- uma da outra: turmas precisa apontar para o professor, e usuarios
-- precisa apontar para a turma. Uma das duas tem que vir depois.
alter table turmas
  drop constraint if exists turmas_professor_fk;

alter table turmas
  add constraint turmas_professor_fk
  foreign key (professor_id) references usuarios(id) on delete set null;


-- ── Conteúdo do jogo ─────────────────────────────────────────────────

-- Os pontos do bairro que aparecem no mapa.
create table if not exists cenarios (
  id bigint primary key generated always as identity,
  slug varchar(50) not null unique,   -- 'ubs', 'mercado', 'farmacia', 'escola'...
  nome varchar(100) not null,
  descricao text not null
);

create table if not exists missoes (
  id bigint primary key generated always as identity,
  cenario_id bigint not null references cenarios(id) on delete cascade,
  titulo varchar(150) not null,
  descricao text not null,

  -- Faixa etária da missão, comparada com usuarios.idade:
  --   1 = 7 a 10 anos, 2 = 11 a 14 anos, 3 = 15 a 18 anos
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


-- ── Progresso do aluno ───────────────────────────────────────────────

-- As 8 barras fixas: Saúde, Educação, Vacinação, Vetores, Limpeza,
-- Alimentação, Exercícios e Felicidade.
create table if not exists progresso_areas (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  area_nome varchar(50) not null,
  porcentagem real default 0,
  pontos int default 0,
  unique (usuario_id, area_nome)
);

create table if not exists respostas_alunos (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  acertou boolean not null,
  data_resposta timestamptz not null default now()
);

-- Um paciente por aluno. O estado_saude evolui conforme ele avança nas
-- missões da UBS e da Farmácia.
create table if not exists pacientes_virtuais (
  id bigint primary key generated always as identity,
  usuario_id uuid unique not null references usuarios(id) on delete cascade,
  nome_paciente varchar(100) not null,
  idade_paciente int not null,
  estado_saude varchar(100) default 'Estável'
);

-- Quizzes ao vivo que o professor monta para a turma, estilo Kahoot.
create table if not exists quizzes_professores (
  id bigint primary key generated always as identity,
  turma_id bigint not null references turmas(id) on delete cascade,
  professor_id uuid not null references usuarios(id) on delete cascade,
  titulo varchar(150) not null,
  tempo_limite_segundos int default 15,
  created_at timestamptz not null default now()
);


-- =====================================================================
--  IMPORTANTE: as regras de segurança NÃO estão neste arquivo.
--
--  Criar as tabelas deixa todas elas ABERTAS — qualquer pessoa com a
--  chave pública consegue ler e escrever pelo navegador. Quem tranca é
--  o arquivo migracao-02-seguranca.sql, que precisa ser rodado logo
--  depois deste.
-- =====================================================================
