-- Remove duas linhas de importação quebrada (V/F agrupado). Pode rodar de novo.


-- V/F com três afirmações nas alternativas (já reimportadas).
delete from questoes where codigo_externo = 'MERCADO-N1-001';

-- V/F com a afirmação da escola na alternativa A (já reimportada).
delete from questoes where codigo_externo = 'PRACA-N1-008';


-- Questão de teste de um professor (quiz 22). Para apagar, descomente:
-- -- delete from questoes where enunciado = 'Irei testar o cadastro da primeira pergunta no banco.';


-- Refaz as metas das barras.
select public.recalcular_metas();

notify pgrst, 'reload schema';
