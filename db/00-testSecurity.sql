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
  'cenarios', 'questoes', 'areas', 'questoes_areas',
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


-- ── 6. O gabarito está escondido? ───────────────────────────────────
--
-- O RLS é por LINHA e não sabe esconder coluna: a policy de conteúdo
-- libera a linha de questoes, e a linha tem resposta_correta. Quem
-- fecha isso é a permissão por coluna (seção 5 do setup.sql).
--
-- Esperado: 9 colunas por grantee — cenario_id, enunciado, id,
-- nivel_etario e opcao_a..opcao_e. Se resposta_correta ou explicacao aparecerem aqui,
-- qualquer aluno logado lê o gabarito pelo console do navegador.
--
-- O filtro por privilege_type é obrigatório: sem ele a consulta traz
-- INSERT/UPDATE/REFERENCES junto e parece que o revoke falhou.

select grantee, column_name
from information_schema.column_privileges
where table_name = 'questoes'
  and privilege_type = 'SELECT'
  and grantee in ('anon', 'authenticated')
order by grantee, column_name;


-- ── 7. Só o servidor consegue pontuar? ──────────────────────────────
--
-- somar_pontos é security definer: quem consegue executá-la escreve em
-- progresso_areas sem passar por RLS nenhum.
--
-- Cuidado ao ler o resultado: proacl NULO é o problema, não a solução.
-- Nulo significa "padrão do PostgreSQL", e o padrão é PUBLIC podendo
-- executar — foi exatamente essa a brecha. O esperado é um proacl
-- preenchido e SEM nenhuma entrada "=X/" (grantee vazio antes do "="
-- é como o PUBLIC aparece nessa lista).

select proname, proacl
from pg_proc
where proname in ('somar_pontos', 'progresso_do_aluno');

-- progresso_do_aluno entra na mesma conferência pelo mesmo motivo, e com
-- um agravante: ela recebe o id do aluno por parâmetro. Executável por
-- PUBLIC, qualquer logado leria as barras de qualquer colega trocando o
-- uuid.


-- ── 8. Toda questão tem dono? ───────────────────────────────────────
--
-- questoes.criado_por diz quem escreveu: o código do sistema
-- ('00000000-0000-0000-0000-000000000000') para o conteúdo da Medicina,
-- ou o id do professor que a criou no painel.
--
-- Esperado: a coluna existe, is_nullable = 'NO', e o default é o código
-- do sistema. Se não vier linha nenhuma, falta rodar
-- db/migracao-questoes-criado-por.sql.

select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'questoes' and column_name = 'criado_por';

-- Quantas são de cada origem.
select case when criado_por = '00000000-0000-0000-0000-000000000000'
            then 'sistema' else 'professor' end as origem,
       count(*) as questoes
from questoes
group by 1;


-- ── 9. Um professor não lê a questão de outro? ──────────────────────
--
-- A policy de select de questoes precisa filtrar por criado_por. Se
-- aparecer aqui uma policy com qual = 'true', qualquer logado lê as
-- perguntas que os professores escreveram.

select policyname, cmd, qual
from pg_policies
where schemaname = 'public' and tablename in ('questoes', 'questoes_areas')
order by tablename, cmd;


-- ── 10. O aluno troca a própria turma pelo console? ─────────────────
--
-- A policy "editar o proprio cadastro" libera a LINHA; quem limita as
-- COLUNAS é o grant da seção 5 do setup.sql. Esperado: só avatar_url e
-- nome para authenticated, e nada para anon. Se aparecer turma_id,
-- idade, tipo ou escola_id, qualquer aluno entra em qualquer turma sem
-- código (ou muda a própria idade) direto pelo navegador.

select grantee, column_name
from information_schema.column_privileges
where table_name = 'usuarios'
  and privilege_type = 'UPDATE'
  and grantee in ('anon', 'authenticated')
order by grantee, column_name;
