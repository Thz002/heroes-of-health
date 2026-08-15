-- =====================================================================
--  DIAGNÓSTICO — o que existe de verdade neste banco?
--
--  Não altera nada. Só pergunta.
--
--  Rode isto sempre que uma migração falhar dizendo que alguma coisa
--  "does not exist": o repositório descreve o banco que a gente QUERIA
--  ter, e os dois podem ter divergido.
--
--  Onde rodar: painel do Supabase -> SQL Editor
-- =====================================================================


-- ── 1. As 10 tabelas do projeto estão todas lá? ─────────────────────
--
-- A coluna "existe" precisa vir true em todas. Onde vier false, é uma
-- tabela que o schema.sql cria e que nunca foi criada aqui.

select
  esperada as tabela,
  to_regclass('public.' || esperada) is not null as existe
from unnest(array[
  'escolas', 'turmas', 'usuarios',
  'cenarios', 'missoes', 'questoes',
  'progresso_areas', 'respostas_alunos',
  'pacientes_virtuais', 'quizzes_professores'
]) as esperada
order by 2, 1;


-- ── 2. A tabela "usuarios" é a versão nova? ─────────────────────────
--
-- Precisa aparecer "id" com tipo "uuid".
-- Se aparecer bigint/integer, ou se existir coluna "senha" ou "email",
-- este banco ainda está na versão anterior à migração 01.

select column_name, data_type, is_nullable
from information_schema.columns
where table_schema = 'public' and table_name = 'usuarios'
order by ordinal_position;


-- ── 3. Quais tabelas estão destrancadas? ────────────────────────────
--
-- rowsecurity = false é uma tabela aberta para qualquer visitante com a
-- chave publishable.

select tablename, rowsecurity
from pg_tables
where schemaname = 'public'
order by rowsecurity, tablename;


-- ── 4. Quais regras de segurança existem hoje? ──────────────────────

select tablename, policyname, cmd, roles
from pg_policies
where schemaname = 'public'
order by tablename, cmd;


-- ── 5. Tem conta sem perfil? ────────────────────────────────────────
--
-- Cada linha aqui é alguém que entrou em auth.users e nunca chegou em
-- usuarios. Se "email_confirmed_at" vier nulo, a causa é o "Confirm
-- email" ligado no painel.

select u.id, u.email, u.created_at, u.email_confirmed_at
from auth.users u
left join public.usuarios p on p.id = u.id
where p.id is null
order by u.created_at desc;
