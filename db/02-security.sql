-- =====================================================================
--  MIGRAÇÃO 02 — Trancar as tabelas que ainda estão abertas
--
--  A migração 01 trancou só a tabela "usuarios". Todas as outras seguem
--  abertas: qualquer pessoa com a chave pública consegue ler e ESCREVER
--  nelas pelo navegador.
--
--  Aqui a gente liga as regras de segurança em cada uma.
--
--  Como ler as regras deste arquivo:
--    "for select"  -> quem pode LER
--    "for insert"  -> quem pode CRIAR
--    "for update"  -> quem pode ALTERAR
--    "to anon"     -> qualquer visitante, mesmo sem estar logado
--    "to authenticated" -> só quem entrou com e-mail e senha
--    "auth.uid()"  -> o identificador de quem está logado agora
--
--  Onde rodar: painel do Supabase -> SQL Editor
-- =====================================================================


-- =====================================================================
--  ESCOLAS
--
--  Precisa ser lida por VISITANTE (anon), não só por quem já entrou.
--  Motivo: o aluno escolhe a escola durante o cadastro, ou seja, ANTES
--  de ter conta. Se só quem está logado pudesse ler, a lista apareceria
--  vazia e o cadastro travaria.
--
--  Nome de escola não é informação sensível, então isso é seguro.
-- =====================================================================

alter table escolas enable row level security;

create policy "qualquer um le as escolas"
  on escolas for select
  to anon, authenticated
  using (true);

-- Criar escola: só quem já tem conta. É o professor, no cadastro dele.
create policy "logado cria escola"
  on escolas for insert
  to authenticated
  with check (true);


-- =====================================================================
--  TURMAS
--
--  Mesma lógica das escolas: o aluno precisa ver a lista antes de ter conta.
-- =====================================================================

alter table turmas enable row level security;

create policy "qualquer um le as turmas"
  on turmas for select
  to anon, authenticated
  using (true);

-- Só professor cria turma.
create policy "professor cria turma"
  on turmas for insert
  to authenticated
  with check (
    exists (
      select 1 from usuarios u
      where u.id = auth.uid() and u.tipo = 'PROFESSOR'
    )
  );

-- Só quem criou a turma pode alterá-la.
create policy "professor altera a propria turma"
  on turmas for update
  to authenticated
  using (professor_id = auth.uid());


-- =====================================================================
--  CONTEÚDO DO JOGO — cenarios, missoes, questoes
--
--  Só leitura, e só para quem está logado. Ninguém cria conteúdo pelo
--  site: as missões e questões são escritas pela equipe de Medicina e
--  entram pelo painel do Supabase.
-- =====================================================================

alter table cenarios enable row level security;
alter table missoes  enable row level security;
alter table questoes enable row level security;

create policy "logado le os cenarios"
  on cenarios for select to authenticated using (true);

create policy "logado le as missoes"
  on missoes for select to authenticated using (true);

create policy "logado le as questoes"
  on questoes for select to authenticated using (true);

-- ⚠️ PROBLEMA CONHECIDO, IMPORTANTE:
-- a tabela "questoes" guarda a coluna resposta_correta. Com a regra acima,
-- um aluno logado consegue ler a resposta certa antes de responder, usando
-- as ferramentas de programador do navegador.
--
-- A correção de verdade é o navegador NUNCA receber essa coluna: a
-- conferência da resposta precisa acontecer do lado do banco, e não da
-- tela. Isso se resolve com uma função no banco que recebe a resposta e
-- devolve só "acertou / errou".
--
-- Fica registrado aqui para não ser esquecido.


-- =====================================================================
--  PROGRESSO DO ALUNO
--
--  Aqui a regra é sempre a mesma: cada pessoa só enxerga e altera as
--  próprias linhas. "auth.uid() = usuario_id" se lê como
--  "só se essa linha for minha".
-- =====================================================================

alter table progresso_areas    enable row level security;
alter table respostas_alunos   enable row level security;
alter table pacientes_virtuais enable row level security;

create policy "le o proprio progresso"
  on progresso_areas for select to authenticated using (auth.uid() = usuario_id);
create policy "cria o proprio progresso"
  on progresso_areas for insert to authenticated with check (auth.uid() = usuario_id);
create policy "altera o proprio progresso"
  on progresso_areas for update to authenticated using (auth.uid() = usuario_id);

create policy "le as proprias respostas"
  on respostas_alunos for select to authenticated using (auth.uid() = usuario_id);
create policy "cria as proprias respostas"
  on respostas_alunos for insert to authenticated with check (auth.uid() = usuario_id);

create policy "le o proprio paciente"
  on pacientes_virtuais for select to authenticated using (auth.uid() = usuario_id);
create policy "cria o proprio paciente"
  on pacientes_virtuais for insert to authenticated with check (auth.uid() = usuario_id);
create policy "altera o proprio paciente"
  on pacientes_virtuais for update to authenticated using (auth.uid() = usuario_id);


-- =====================================================================
--  QUIZZES DO PROFESSOR
-- =====================================================================

alter table quizzes_professores enable row level security;

create policy "professor le os proprios quizzes"
  on quizzes_professores for select to authenticated using (auth.uid() = professor_id);
create policy "professor cria os proprios quizzes"
  on quizzes_professores for insert to authenticated with check (auth.uid() = professor_id);
create policy "professor altera os proprios quizzes"
  on quizzes_professores for update to authenticated using (auth.uid() = professor_id);


-- =====================================================================
--  O PROFESSOR PRECISA VER OS ALUNOS DA TURMA DELE
--
--  A migração 01 deixou "usuarios" com a regra de que cada um só vê o
--  próprio cadastro. Isso impediria o painel do professor de existir.
--  Esta regra abre a exceção: o professor enxerga os alunos das turmas
--  que ele criou.
-- =====================================================================

create policy "professor le os alunos das turmas dele"
  on usuarios for select
  to authenticated
  using (
    exists (
      select 1 from turmas t
      where t.id = usuarios.turma_id
        and t.professor_id = auth.uid()
    )
  );


-- =====================================================================
--  CONFERIR SE DEU CERTO
--
--  Deve listar todas as tabelas com rowsecurity = true.
-- =====================================================================

-- select tablename, rowsecurity
-- from pg_tables
-- where schemaname = 'public'
-- order by tablename;
