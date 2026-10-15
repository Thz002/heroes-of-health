-- =====================================================================
--  AS DUAS LINHAS QUE NÃO SÃO QUESTÃO
--
--  Sobraram da primeira importação, feita por um parser que ainda não
--  sabia ler bloco de Verdadeiro ou Falso sem numeração. Ele juntou
--  várias afirmações numa linha só: o enunciado ficou "Verdadeiro ou
--  Falso", e as alternativas viraram os enunciados das outras — mais o
--  nome do cenário, que era um cabeçalho do documento.
--
--  Não dá para consertar, porque não é uma questão: são três. E as três
--  já entraram certas pela importação de outubro, com os dois feedbacks
--  escritos pela equipe de Medicina.
--
--  Nenhum aluno respondeu a elas e nenhum quiz as usa — o que sai do
--  banco aqui não leva nada junto. `questoes_areas` cai sozinha, por
--  `on delete cascade`.
--
--  Onde rodar: SQL Editor do Supabase, COM NADA SELECIONADO.
--  Pode rodar mais de uma vez: na segunda, não acha nada e não faz nada.
-- =====================================================================


-- "Verdadeiro ou Falso", com três afirmações nas alternativas.
--   o sono e a memória  → agora MERCADO-N1-011
--   sono x virar a noite estudando → agora CASA-N1-022
delete from questoes where codigo_externo = 'MERCADO-N1-001';

-- "Verdadeiro ou Falso", com a afirmação sobre a escola na alternativa A
-- e o cabeçalho "Escola" na B.
--   → agora ESCOLA-N1-045
delete from questoes where codigo_externo = 'PRACA-N1-008';


-- ── A questão de teste do professor ─────────────────────────────────
--
-- "Irei testar o cadastro da primeira pergunta no banco.", com "Opção A"
-- e "Opção B" de alternativas. Não é do sistema: foi criada pela tela do
-- professor e está dentro do quiz 22, "Casas perguntas 2". Por isso não
-- entra na régua das barras e não atrapalha a pontuação de ninguém.
--
-- Fica comentada porque apagá-la tira uma pergunta de um quiz que já
-- existe — é decisão de quem criou. Para apagar, tire o "--" da linha:
--
-- delete from questoes where enunciado = 'Irei testar o cadastro da primeira pergunta no banco.';


-- As metas das oito barras somam o que cada área pode render. Saem duas
-- questões, então as réguas encurtam um pouco e as porcentagens de quem
-- já jogou acompanham.
select public.recalcular_metas();

notify pgrst, 'reload schema';
