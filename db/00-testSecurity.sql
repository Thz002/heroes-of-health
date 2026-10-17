-- Diagnóstico do banco (só leitura). Rode no SQL Editor quando algo "does not exist".


-- 1. As tabelas do projeto existem? "existe" deve vir true em todas.

select
  esperada as tabela,
  to_regclass('public.' || esperada) is not null as existe
from unnest(array[
  'escolas', 'turmas', 'usuarios',
  'cenarios', 'questoes', 'areas', 'questoes_areas',
  'progresso_areas', 'respostas_alunos',
  'pacientes_virtuais', 'quizzes_professores'
]) as esperada
order by 2, 1;


-- 2. usuarios.id deve ser uuid, sem colunas senha/email.

select column_name, data_type, is_nullable
from information_schema.columns
where table_schema = 'public' and table_name = 'usuarios'
order by ordinal_position;


-- 3. Tabelas sem RLS (rowsecurity = false) ficam abertas.

select tablename, rowsecurity
from pg_tables
where schemaname = 'public'
order by rowsecurity, tablename;


-- ── 4. Quais regras de segurança existem hoje? ──────────────────────

select tablename, policyname, cmd, roles
from pg_policies
where schemaname = 'public'
order by tablename, cmd;


-- 5. Contas sem perfil em usuarios.

select u.id, u.email, u.created_at, u.email_confirmed_at
from auth.users u
left join public.usuarios p on p.id = u.id
where p.id is null
order by u.created_at desc;


-- 6. Gabarito escondido: esperadas 9 colunas por grantee, sem resposta_correta/explicacao.

select grantee, column_name
from information_schema.column_privileges
where table_name = 'questoes'
  and privilege_type = 'SELECT'
  and grantee in ('anon', 'authenticated')
order by grantee, column_name;


-- 7. Só o servidor executa somar_pontos: proacl preenchido e sem "=X/" (PUBLIC).

select proname, proacl
from pg_proc
where proname in ('somar_pontos', 'progresso_do_aluno');

-- progresso_do_aluno também não pode ser executável por PUBLIC.


-- 8. questoes.criado_por existe, not null, default = código do sistema.

select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'questoes' and column_name = 'criado_por';

-- Quantas são de cada origem.
select case when criado_por = '00000000-0000-0000-0000-000000000000'
            then 'sistema' else 'professor' end as origem,
       count(*) as questoes
from questoes
group by 1;


-- 9. A policy de select de questoes deve filtrar por criado_por.

select policyname, cmd, qual
from pg_policies
where schemaname = 'public' and tablename in ('questoes', 'questoes_areas')
order by tablename, cmd;


-- 10. authenticated só pode atualizar nome e avatar_url em usuarios.

select grantee, column_name
from information_schema.column_privileges
where table_name = 'usuarios'
  and privilege_type = 'UPDATE'
  and grantee in ('anon', 'authenticated')
order by grantee, column_name;
