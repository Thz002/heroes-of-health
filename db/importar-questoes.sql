-- =====================================================================
--  HERÓIS DA SAÚDE — as perguntas da equipe de Medicina
--
--  Gerado a partir dos .docx da equipe por db/ferramentas/gerar_sql.py,
--  mas A PARTIR DAQUI ESTE ARQUIVO É A FONTE DA VERDADE: as explicações
--  entram aqui, à mão, como em qualquer outro arquivo de db/.
--
--  Só NÃO rode o gerador de novo em cima dele — isso devolveria os
--  placeholders por cima do que a Medicina escrever. Para um lote novo
--  (o nível 3, por exemplo), o gerador escreve em outro arquivo.
--
--  Rode DEPOIS de db/setup.sql e db/seed.sql.
--
--  É seguro rodar quantas vezes quiser: cada missão e cada questão tem
--  um codigo_externo único, e o import é "on conflict do update".
--  Rodar de novo corrige o texto SEM apagar nenhuma resposta já dada
--  pelos alunos — o que um "delete + insert" destruiria, porque
--  respostas_alunos referencia questoes com on delete cascade.
--
--  156 questões, em 16 missões (cenário × nível).
--
--  As explicações nascem como PLACEHOLDER: o arquivo de origem não
--  trazia o texto que o aluno vê ao errar. Troque cada uma aqui quando
--  a Medicina entregar, e rode o arquivo de novo — o update cobre a
--  coluna explicacao, então o texto novo chega ao banco.
--
--  CUIDADO AO ESCREVER: apóstrofo dentro do texto tem de ser DOBRADO.
--    errado:  'a caixa-d'agua'      certo:  'a caixa-d''agua'
--
--  Para achar as que ainda faltam:
--    select count(*) from questoes where explicacao like 'Explicação em elaboração%';
-- =====================================================================

-- Ficaram DE FORA, por não caberem no formato de 4 alternativas ou
-- por não terem a resposta marcada em verde no arquivo de origem:
--   nível 1, questão 8: sem resposta marcada
--     Durante uma atividade na escola, a professora pediu que as crianças identificassem algum
--   nível 1, questão 11: 2 alternativas
--     Verdadeiro ou Falso
--   nível 1, questão 12: 2 alternativas, sem resposta marcada
--     Verdadeiro ou Falso


-- ── Guarda: os cenários têm de existir antes ─────────────────────────
do $$
declare faltando text;
begin
  select string_agg(s, ', ') into faltando
  from unnest(array['casa', 'creche', 'escola', 'farmacia', 'mercado', 'parque', 'praca', 'quadra', 'ubs', 'upa']) s
  where not exists (select 1 from cenarios c where c.slug = s);
  if faltando is not null then
    raise exception 'Cenários que faltam no banco: %. Rode db/seed.sql antes deste arquivo.', faltando;
  end if;
end $$;


-- ── 1. As missões ────────────────────────────────────────────────────
-- Uma por (cenário × nível): é ela que carrega o lugar do mapa, a faixa
-- etária e as barras que enche. As questões herdam tudo isso.

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'CASA-N1', c.id, 'Casa · 7 a 10 anos', 'Perguntas de saúde ambientadas em casa, para a faixa de 7 a 10 anos. 18 questões.', 1
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'CASA-N2', c.id, 'Casa · 11 a 14 anos', 'Perguntas de saúde ambientadas em casa, para a faixa de 11 a 14 anos. 11 questões.', 2
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'CRECHE-N1', c.id, 'Creche · 7 a 10 anos', 'Perguntas de saúde ambientadas em creche, para a faixa de 7 a 10 anos. 3 questões.', 1
  from cenarios c where c.slug = 'creche'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'ESCOLA-N1', c.id, 'Escola · 7 a 10 anos', 'Perguntas de saúde ambientadas em escola, para a faixa de 7 a 10 anos. 39 questões.', 1
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'ESCOLA-N2', c.id, 'Escola · 11 a 14 anos', 'Perguntas de saúde ambientadas em escola, para a faixa de 11 a 14 anos. 21 questões.', 2
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'FARMACIA-N1', c.id, 'Farmácia · 7 a 10 anos', 'Perguntas de saúde ambientadas em farmácia, para a faixa de 7 a 10 anos. 1 questões.', 1
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'MERCADO-N1', c.id, 'Mercado · 7 a 10 anos', 'Perguntas de saúde ambientadas em mercado, para a faixa de 7 a 10 anos. 1 questões.', 1
  from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'MERCADO-N2', c.id, 'Mercado · 11 a 14 anos', 'Perguntas de saúde ambientadas em mercado, para a faixa de 11 a 14 anos. 1 questões.', 2
  from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'PARQUE-N2', c.id, 'Parque · 11 a 14 anos', 'Perguntas de saúde ambientadas em parque, para a faixa de 11 a 14 anos. 23 questões.', 2
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'PRACA-N1', c.id, 'Praça · 7 a 10 anos', 'Perguntas de saúde ambientadas em praça, para a faixa de 7 a 10 anos. 7 questões.', 1
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'PRACA-N2', c.id, 'Praça · 11 a 14 anos', 'Perguntas de saúde ambientadas em praça, para a faixa de 11 a 14 anos. 3 questões.', 2
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'QUADRA-N1', c.id, 'Campo de lazer · 7 a 10 anos', 'Perguntas de saúde ambientadas em campo de lazer, para a faixa de 7 a 10 anos. 1 questões.', 1
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'UBS-N1', c.id, 'UBS · 7 a 10 anos', 'Perguntas de saúde ambientadas em ubs, para a faixa de 7 a 10 anos. 2 questões.', 1
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'UBS-N2', c.id, 'UBS · 11 a 14 anos', 'Perguntas de saúde ambientadas em ubs, para a faixa de 11 a 14 anos. 16 questões.', 2
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'UPA-N1', c.id, 'UPA · 7 a 10 anos', 'Perguntas de saúde ambientadas em upa, para a faixa de 7 a 10 anos. 4 questões.', 1
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;

insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)
select 'UPA-N2', c.id, 'UPA · 11 a 14 anos', 'Perguntas de saúde ambientadas em upa, para a faixa de 11 a 14 anos. 5 questões.', 2
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set titulo = excluded.titulo, descricao = excluded.descricao,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;


-- ── 2. Quais barras cada missão enche ────────────────────────────────
-- SEM ESTAS LINHAS O ALUNO ACERTA E NADA ACONTECE: o servidor lê daqui
-- para saber o que somar, e zero linhas = zero pontos, sem erro nenhum.
-- Cada acerto vale 10 pontos em cada barra listada.

-- CASA-N1: Educação, Felicidade, Limpeza, Saúde, Vacinação, Vetores
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10),
    ('Vacinação', 10),
    ('Vetores', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'CASA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- CASA-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'CASA-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- CRECHE-N1: Felicidade, Limpeza, Saúde
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'CRECHE-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- ESCOLA-N1: Educação, Felicidade, Limpeza, Saúde, Vetores
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10),
    ('Vetores', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'ESCOLA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- ESCOLA-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'ESCOLA-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- FARMACIA-N1: Educação, Limpeza, Saúde, Vacinação, Vetores
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Limpeza', 10),
    ('Saúde', 10),
    ('Vacinação', 10),
    ('Vetores', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'FARMACIA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- MERCADO-N1: Educação, Felicidade, Saúde
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'MERCADO-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- MERCADO-N2: Educação, Felicidade, Saúde
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'MERCADO-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- PARQUE-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'PARQUE-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- PRACA-N1: Educação, Felicidade, Limpeza, Saúde, Vetores
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10),
    ('Vetores', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'PRACA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- PRACA-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'PRACA-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- QUADRA-N1: Educação, Felicidade, Saúde
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'QUADRA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- UBS-N1: Educação, Felicidade, Limpeza, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'UBS-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- UBS-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'UBS-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- UPA-N1: Educação, Felicidade, Saúde
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'UPA-N1'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;

-- UPA-N2: Educação, Felicidade, Saúde, Vacinação
insert into missao_areas (missao_id, area_nome, pontos)
select m.id, v.area, v.pontos from missoes m
  cross join (values
    ('Educação', 10),
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 10)
  ) as v(area, pontos)
  where m.codigo_externo = 'UPA-N2'
on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;


-- ── 3. As questões ───────────────────────────────────────────────────

-- CASA-N1 — 18 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-001', m.id, 'No bairro de João, algumas pessoas estão ajudando a combater a dengue. Qual atitude ajuda a evitar que o mosquito Aedes aegypti se reproduza?',
       'Deixar vasos e baldes com água no quintal.',
       'Retirar recipientes que possam acumular água.',
       'Manter as caixas-d''água abertas.',
       'Deixar as calhas entupidas.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-002', m.id, 'Depois de uma chuva, Ana percebeu que havia água acumulada em alguns recipientes no quintal. Por que é importante retirar essa água?',
       'Porque a água da chuva deixa o quintal mais bonito.',
       'Para evitar que mosquitos tenham acesso à água e possam se reproduzir.',
       'Porque os mosquitos só aparecem quando está frio.',
       'Porque a água acumulada impede as plantas de crescerem.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-003', m.id, 'Por que devemos intensificar os cuidados contra o mosquito entre os meses de outubro e maio?',
       'Porque é a época que o mosquito entra de férias.',
       'Porque é o período com maior risco de casos da doença devido ao clima favorável à reprodução do mosquito.',
       'Porque é quando as escolas estão fechadas.',
       'Porque os mosquitos preferem o inverno.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-004', m.id, 'Deixar os dentes sujos permitem que as bactérias estraguem nossos dentes. Sabendo disso, em quais momentos é importante escovar os dentes?',
       'Somente quando os dentes estiverem sujos.',
       'Apenas uma vez por dia.',
       'Sempre que comer e antes de dormir.',
       'Somente quando sentir dor de dente',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-005', m.id, 'Lavar as mãos não é apenas uma regra, é um ato de cuidado. Quando você lava as mãos, quem você está protegendo?',
       'Apenas a mim mesmo.',
       'Apenas as plantas da escola.',
       'A mim mesmo e a todas as pessoas que estão perto de mim.',
       'Somente os médicos e enfermeiros.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-006', m.id, 'Para que a lavagem das mãos funcione de verdade e elimine os microrganismos, como ela deve ser feita?',
       'Muito rápida, apenas molhando as pontas dos dedos.',
       'Usando apenas água, sem precisar de sabão.',
       'De forma cuidadosa, esfregando bem todas as partes das mãos com água e sabão.',
       'Limpando as mãos na toalha de um amigo.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-007', m.id, 'João quer ajudar na coleta seletiva da sua casa. Quais materiais podem ser separados para a reciclagem?',
       'Somente restos de comida.',
       'Apenas roupas e sapatos.',
       'Papel, metal, plástico e vidro.',
       'Terra, folhas e areia',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-008', m.id, 'Pedro tem uma garrafa de vidro para colocar na coleta seletiva. Qual é o cuidado mais importante?',
       'Jogar a garrafa no chão para quebrá-la.',
       'Misturar o vidro com restos de comida.',
       'Proteger o vidro para evitar acidentes com os trabalhadores.',
       'Esconder a garrafa dentro de uma caixa de papelão sem avisar ninguém.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-009', m.id, 'O que é importante fazer com as embalagens de plástico ou metal antes de colocá-las no saco de lixo?',
       'Pintá-las com canetinha colorida.',
       'Higienizá-las (limpá-las) para retirar restos de alimentos e líquidos.',
       'Enchê-las com água para ficarem pesadas.',
       'Rasgá-las em pedaços bem pequenininhos.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-010', m.id, 'Como funciona a coleta seletiva "porta a porta"?',
       'Os moradores levam o lixo até o centro da cidade.',
       'Os moradores separam os recicláveis e os deixam no passeio (calçada) para o caminhão recolher.',
       'O caminhão passa pegando o lixo dentro da cozinha das casas.',
       'Não existe esse tipo de coleta.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-011', m.id, 'O sono é muito importante para a nossa saúde. Por que precisamos dormir bem todas as noites?',
       'Porque dormir é uma perda de tempo e não ajuda em nada.',
       'Porque o descanso ajuda o corpo a recuperar as energias e mantém a mente saudável para o dia seguinte.',
       'Porque as crianças não precisam descansar, apenas os adultos.',
       'Porque o corpo só precisa de comida, nunca de descanso.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-012', m.id, 'Qual destas pessoas pode ser um adulto de confiança para uma criança?',
       'Uma pessoa responsável por ela, como um familiar, professor ou outro adulto em quem confia.',
       'Somente uma pessoa que ela conheceu pela internet, pois toda pessoa legal é de confiança.',
       'Qualquer pessoa que peça para guardar um segredo.',
       'Ninguém, porque crianças precisam resolver tudo sozinhas.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-013', m.id, 'Qual destas frases uma criança deve lembrar?',
       '“Se eu conhecer a pessoa, preciso aceitar tudo o que ela fizer, independentemente de como eu me sinto.”',
       '“Se alguém pedir segredo ou me ameaçar, nunca posso contar.”',
       '“Meu corpo merece respeito e, se alguma situação me deixar inseguro ou desconfortável, preciso pedir ajuda.”',
       '“Problemas envolvendo adultos devem ser resolvidos somente por crianças.”',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-014', m.id, 'Se alguém disser que vai machucar uma criança caso ela conte o que aconteceu, o que ela deve fazer?',
       'Guardar o segredo para evitar que a ameaça aconteça.',
       'Esperar alguns dias para descobrir se a ameaça realmente vai acontecer.',
       'Contar para um adulto de confiança e pedir ajuda, mesmo que tenha sido ameaçada.',
       'Tentar resolver a situação sozinha para não envolver outras pessoas.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-015', m.id, 'Se você contar para um adulto de confiança que algo ruim aconteceu e ele não acreditar em você de primeira, o que você deve fazer?',
       'Achar que você está errado e desistir.',
       'Pedir desculpas para a pessoa que te deixou desconfortável.',
       'Continuar procurando e contando para outros adultos de confiança até que alguém te ajude de verdade.',
       'Guardar o segredo só para você a partir de agora.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-016', m.id, 'Por que o trabalho infantil é ruim para as crianças?',
       'Porque diminui o tempo da criança para estudar, brincar, descansar e crescer bem.',
       'Porque pode fazer a criança aprender coisas novas antes dos seus amigos.',
       'Porque pode fazer a criança passar mais tempo fora de casa com outras pessoas.',
       'Porque pode fazer a criança receber responsabilidades diferentes das que costuma ter.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-017', m.id, 'Qual destas atividades é saudável para uma criança fazer?',
       'Cuidar diariamente de outra criança durante muitas horas para que os adultos trabalhem.',
       'Vender produtos na rua durante o horário em que deveria estar estudando.',
       'Organizar os próprios brinquedos e ajudar a manter seu quarto arrumado.',
       'Trabalhar em um estabelecimento para receber dinheiro durante parte do dia.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N1-018', m.id, 'O que acontece quando uma criança gasta muitas horas do dia apenas fazendo "afazeres domésticos" (limpar, cozinhar, cuidar de irmãos)?',
       'Ela fica mais inteligente que os outros colegas.',
       'Ela perde o tempo que deveria usar para estudar, brincar e descansar.',
       'Ela ajuda a escola a ficar mais vazia.',
       'Ela cresce mais rápido que as outras crianças.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- CASA-N2 — 11 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-001', m.id, 'O intestino grosso tem como principal função:',
       'Absorver água e formar as fezes',
       'Digerir proteínas',
       'Produzir bile',
       'Filtrar toxinas',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-002', m.id, 'Irmãos podem ter características diferentes porque:',
       'Herdam combinações diferentes de genes dos pais',
       'Mudam seus genes ao nascer',
       'Recebem exatamente o mesmo DNA',
       'Herdam apenas genes da mãe',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-003', m.id, 'O que fazer com o óleo de cozinha usado?',
       'Jogar na pia',
       'Jogar no vaso sanitário',
       'Guardar em uma garrafa fechada e levar a um ponto de coleta',
       'Jogar no quintal',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-004', m.id, 'Pilhas, baterias e lâmpadas queimadas devem ser descartadas:',
       'No lixo comum da cozinha',
       'Queimadas junto com folhas secas',
       'Enterradas no jardim',
       'Em pontos de coleta específicos, pois contêm substâncias tóxicas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-005', m.id, 'Por quanto tempo, aproximadamente, devemos lavar as mãos com água e sabão?',
       'Menos de 5 segundos',
       'Basta molhar as mãos rapidamente, sem sabão',
       'De 40 a 60 segundos, esfregando palmas, dorso, entre os dedos, polegares e unhas',
       'Exatamente 5 minutos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-006', m.id, 'Qual destes itens NÃO deve ser compartilhado com outras pessoas?',
       'Escova de dentes, toalha de banho e lâmina de barbear',
       'Livro escolar',
       'Guarda-chuva',
       'Caneta',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-007', m.id, 'Escovar os dentes ao menos três vezes ao dia e usar fio dental previne principalmente:',
       'Alergia',
       'Gripe',
       'Cárie e doenças da gengiva',
       'Dor de cabeça',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-008', m.id, 'Qual é a melhor forma de evitar escorpiões perto de casa?',
       'Deixar a porta aberta à noite',
       'Deixar entulho e folhas acumuladas no quintal',
       'Espalhar restos de comida no chão',
       'Manter o quintal limpo, sem entulho, e vedar ralos e frestas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-009', m.id, 'Qual é o maior órgão do corpo humano e responsável pelo sentido do tato?',
       'Intestino',
       'Pulmão',
       'Pele',
       'Fígado',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-010', m.id, 'Qual órgão é responsável por bombear o sangue para todo o corpo?',
       'Estômago',
       'Rim',
       'Coração',
       'Pulmão',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CASA-N2-011', m.id, 'A orelha (ouvido) é responsável pela audição e também por qual outra função?',
       'Respiração',
       'Digestão',
       'Equilíbrio',
       'Circulação',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CASA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- CRECHE-N1 — 3 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CRECHE-N1-001', m.id, 'Você sabia que lavar as mãos com frequência protege você e as pessoas próximas de pegarem doenças? Escolha a opção correta de quando devemos lavar as mãos:',
       'Uma vez por dia',
       'Só quando tem sujeira visível, pois não é preciso lavar quando estão sem impurezas.',
       'Várias vezes por dia, principalmente antes de comer.',
       'Somente depois de ir ao banheiro.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CRECHE-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CRECHE-N1-002', m.id, 'Você sabia que as mãos podem carregar "bichinhos" invisíveis chamados microrganismos que nos fazem ficar doentes? Segundo os especialistas, qual é a medida mais importante para evitar que esses microrganismos se espalhem?',
       'Usar roupas sempre novas.',
       'Lavar as mãos de forma correta e frequente.',
       'Brincar apenas dentro de casa.',
       'Beber muita água com açúcar.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CRECHE-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'CRECHE-N1-003', m.id, 'Às vezes, nossas mãos parecem limpas, mas elas são o principal caminho para os microrganismos entrarem em nosso corpo. Por que devemos lavar as mãos mesmo quando não vemos sujeira nelas?',
       'Porque a água gelada é divertida.',
       'Porque os microrganismos são tão pequenos que não conseguimos enxergar, mas eles continuam lá.',
       'Porque o sabão deixa a mão brilhando no escuro.',
       'Não precisamos lavar se não houver sujeira visível.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'CRECHE-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- ESCOLA-N1 — 39 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-001', m.id, 'A escola de Pedro está realizando uma campanha contra a dengue. Qual atitude mostra que os alunos também podem ajudar?',
       'Jogar lixo e recipientes no pátio.',
       'Deixar água acumulada nos vasos de plantas.',
       'Tirar o lixo e evitar locais que possam acumular água.',
       'Abrir as caixas-d''água para verificar se há mosquitos.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-002', m.id, 'Na escola, Ana diz que está com as mãos sujas depois de brincar. Ela diz: “Não preciso lavar, porque não estou doente”. Isso está certo?',
       'Sim, pois só pessoas doentes precisam higienizar as mãos.',
       'Sim, pois sujeira não pode carregar microrganismos.',
       'Não, pois a higiene das mãos ajuda a prevenir a transmissão de microrganismos.',
       'Não, porque devemos lavar as mãos somente no hospital.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-003', m.id, 'Na escola, cada criança deve cuidar dos seus objetos pessoais. Qual atitude ajuda a manter bons hábitos de higiene e prevenir doenças?',
       'Compartilhar a garrafinha, o copo e os talheres com os colegas.',
       'Usar apenas os próprios objetos pessoais, como garrafinha e copo.',
       'Pegar a garrafinha de um colega quando esquecer a sua.',
       'Trocar a garrafinha com os amigos durante o recreio.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-004', m.id, 'Quando usamos o corrimão de uma escada no shopping ou pegamos em notas de dinheiro, nossas mãos tocam em lugares por onde muitas pessoas já passaram. Por que é fundamental lavar as mãos depois disso?',
       'Porque o dinheiro e os corrimãos são sempre limpos e não oferecem risco.',
       'Porque as mãos são o principal caminho para a transmissão de microrganismos de uma pessoa para outra que podem nos deixar doentes.',
       'Porque só devemos lavar as mãos se elas estiverem visivelmente manchadas de sujeira.',
       'Porque a higiene só é importante quando estamos dentro de um hospital.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-005', m.id, 'Qual das situações abaixo é um exemplo de quando NÃO devemos chamar o SAMU?.',
       'Queimaduras graves.',
       'Agressão por arma ou objetos afiados',
       'Afogamento.',
       'Dor de dente.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-006', m.id, 'Imagine que você presenciou um acidente de moto na rua. De acordo com as orientações do SAMU, o que NÃO devemos fazer?',
       'Ligar para o número 192.',
       'Tocar na pessoa ou retirar o capacete dela.',
       'Observar se a pessoa está consciente.',
       'Esperar a ajuda chegar.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-007', m.id, 'Em uma situação de emergência, às vezes queremos ajudar dando algo para a pessoa beber. Qual é a recomendação do SAMU sobre isso?',
       'Devemos dar bastante água gelada.',
       'Pode-se dar suco para a pessoa ganhar energia.',
       'Não se deve dar água aos acidentados.',
       'Devemos oferecer comida para a vítima se acalmar.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-008', m.id, 'Quando se liga para o 192 para pedir ajuda em um acidente, quais informações se deve tentar passar para os técnicos do SAMU?',
       'A cor favorita das pessoas que estão no local.',
       'O que as pessoas comeram no café da manhã.',
       'A quantidade de vítimas, se elas estão conscientes e a localização do ocorrido.',
       'Apenas o nome da rua, sem dizer o que aconteceu.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-009', m.id, 'Qual destas atitudes demonstra que uma pessoa está ajudando na coleta seletiva?',
       'Misturar papel, plástico, metal e vidro com restos de comida.',
       'Separar os materiais recicláveis, higienizá-los e colocá-los corretamente para a coleta.',
       'Jogar embalagens recicláveis na rua.',
       'Deixar garrafas de vidro quebradas na calçada sem proteção.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-010', m.id, 'É correto misturar restos de comida ou líquidos com o papel e o plástico da coleta seletiva?',
       'Sim, porque tudo vai ser jogado fora mesmo.',
       'Não, pois isso causa contaminação e atrapalha a reciclagem dos materiais.',
       'Sim, para o lixo ficar com um cheiro diferente.',
       'Não, porque o caminhão só aceita lixo seco e sujo.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-011', m.id, 'Para onde os materiais recicláveis são levados para serem separados e aproveitados ao máximo?',
       'Para o meio da floresta.',
       'Para as cooperativas, onde trabalhadores treinados fazem a triagem.',
       'Para o fundo do rio.',
       'Para um parquinho de diversões.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-012', m.id, 'Como preferencialmente deve ser o saco plástico usado para colocar os materiais recicláveis?',
       'Saco preto e grosso.',
       'Saco transparente.',
       'Sacola de pano colorida.',
       'Caixa de madeira pregada.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-013', m.id, 'Qual tipo de caminhão é usado para que a coleta seja mais rápida e consiga atender mais pessoas?',
       'Caminhão de sorvete.',
       'Caminhão compactador (que consegue carregar muito mais material).',
       'Caminhão-baú pequeno.',
       'Caminhonete aberta.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-014', m.id, 'Por que os sentidos são importantes para o nosso dia a dia?',
       'Porque servem apenas para sentir sabores, já que os outros sentidos não são tão importantes.',
       'Porque funcionam somente quando estamos brincando.',
       'Porque ajudam o corpo a perceber o que acontece ao nosso redor e a reagir a diferentes situações.',
       'Porque substituem a necessidade de cuidar do nosso corpo.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-015', m.id, 'Maria começou a correr para pegar a bola. Para conseguir correr, seu corpo precisa trabalhar de forma integrada. Qual alternativa explica melhor isso?',
       'Apenas os pés trabalham durante a corrida.',
       'Apenas os músculos trabalham durante a corrida.',
       'Diferentes partes do corpo trabalham juntas para realizar o movimento.',
       'O corpo não precisa de energia para se movimentar.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-016', m.id, 'Pedro percebeu que está cansado depois de brincar bastante. O que ele pode fazer para cuidar do seu corpo?',
       'Continuar brincando sem parar, pois é normal e vai passar.',
       'Descansar, beber água e prestar atenção às necessidades do seu corpo.',
       'Ficar sem beber água, por que não precisa preocupar com a hidratação.',
       'Ignorar o cansaço, pois faz parte.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-017', m.id, 'Lucas ouviu um barulho muito alto e inesperado. Ele se assustou e rapidamente se afastou. O que essa situação mostra?',
       'O corpo consegue perceber o que acontece ao seu redor e reagir.',
       'O corpo não percebe vários sentidos de uma só vez.',
       'Apenas as pernas participaram da reação.',
       'O corpo só reage quando alguém manda.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-018', m.id, 'Caio pegou uma pedra e percebeu que ela era áspera e fria. Qual sentido o ajudou principalmente a perceber essas características?',
       'Audição.',
       'Visão.',
       'Tato.',
       'Movimento.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-019', m.id, 'O que pode acontecer com uma criança que fica muito tempo sem se movimentar ou praticar esportes (vida sedentária)?',
       'Ela terá muito mais energia e força.',
       'O corpo pode ficar preguiçoso e surgir problemas como falta de sono ou indisposição.',
       'Nada acontece, o corpo continua igual.',
       'Ela vai crescer mais rápido do que quem faz exercícios.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-020', m.id, 'Sobre a nossa alimentação, qual o caminho que a comida faz para nos dar energia?',
       'Ela entra pela boca e some assim que engolimos.',
       'Começa na boca, passa pelo estômago e os nutrientes são aproveitados por todo o corpo para nos dar força.',
       'A comida vai direto para os pés para podermos correr.',
       'O corpo não usa a comida para ter energia, apenas para sentir o sabor.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-021', m.id, 'Para crescer com saúde e alegria, o que as crianças devem aprender sobre seu próprio corpo?',
       'Que não precisam se preocupar com o que comem.',
       'Que devem apenas brincar no celular e não precisam dormir.',
       'Que é fundamental conhecer e cuidar do corpo, tendo bons hábitos todos os dias.',
       'Que o corpo se cuida sozinho, sem precisarmos de água ou boa comida.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-022', m.id, 'Lucas estava ajudando na cozinha e, sem querer, encostou o dedo em uma tampa de panela muito quente. Ele sentiu o calor imediatamente e puxou a mão bem rápido para não se queimar. Por que é importante que o nosso corpo, por meio de sentidos como o tato, perceba o calor e a dor?',
       'Porque sentir dor é algo ruim e o corpo deveria aprender a ignorar o que acontece no ambiente ao nosso redor.',
       'Porque os sentidos nos ajudam a perceber o mundo e funcionam como um alerta, permitindo que o corpo reaja rápido para nos proteger de perigos e manter a nossa saúde.',
       'Porque o tato serve apenas para sentirmos se um brinquedo é macio ou duro, não tendo utilidade para a nossa proteção.',
       'Porque o corpo humano é uma máquina que não precisa sentir nada para saber como se desviar de objetos perigosos.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-023', m.id, 'Se uma criança estiver em uma situação que a deixe assustada, desconfortável ou insegura, o que ela deve fazer?',
       'Guardar o segredo e não contar para ninguém o que aconteceu.',
       'Fazer de conta que nada aconteceu.',
       'Contar para um adulto de confiança e pedir ajuda.',
       'Achar que é culpa dela.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-024', m.id, 'O que significa respeitar os limites de uma criança?',
       'Perguntar se ela está confortável e respeitar quando ela disser que não quer algo.',
       'Continuar fazendo algo mesmo quando ela demonstra que não está confortável.',
       'Decidir por ela o que pode acontecer, sem perguntar como ela se sente.',
       'Fazer algo que ela não quer, desde que seja uma pessoa conhecida.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-025', m.id, 'O que significa abuso contra uma criança?',
       'Quando um adulto orienta a criança sobre algo que ela fez de errado.',
       'Quando alguém ultrapassa os limites da criança e desrespeita seu corpo ou sua segurança.',
       'Quando uma criança fica triste por não poder fazer algo que gostaria.',
       'Quando um adulto estabelece uma regra para proteger a criança de algum perigo.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-026', m.id, 'Se uma criança disser “não” para alguma coisa relacionada ao seu corpo, o que deve acontecer?',
       'A outra pessoa deve respeitar sua decisão e parar o que estiver fazendo.',
       'A outra pessoa pode continuar, porque adultos sabem o que é melhor para ela.',
       'A outra pessoa pode insistir até que a criança mude de ideia sozinha.',
       'A outra pessoa pode continuar se disser que aquilo é apenas uma brincadeira.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-027', m.id, 'Se um amigo contar que está passando por uma situação que o deixa com medo ou desconfortável, o que você pode fazer?',
       'Dizer que ele deve tentar resolver a situação sozinho primeiro.',
       'Pedir para ele contar somente para outras crianças que também sejam amigas dele.',
       'Dizer para ele esperar alguns dias para ver se a situação melhora antes de procurar ajuda.',
       'Ouvir o amigo e ajudá-lo a procurar um adulto de confiança.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-028', m.id, 'Qual situação mostra uma atitude de proteção?',
       'Uma criança percebe que algo está errado, mas não conta para ninguém.',
       'Uma criança percebe que algo está errado, mas tenta resolver sozinha mesmo estando com medo.',
       'Uma criança percebe que algo está errado, mas continua na situação para não deixar a outra pessoa triste.',
       'Uma criança percebe que algo está errado, se afasta e procura um adulto de confiança.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-029', m.id, 'Sobre o seu corpo, o que é mais importante lembrar?',
       'Que qualquer adulto pode tocá-lo se for conhecido.',
       'Que meu corpo é meu íntimo e ninguém pode tocar em minhas partes íntimas sem um motivo de saúde ou higiene.',
       'Que não preciso aprender sobre como me proteger.',
       'Que outras pessoas decidem o que me deixa confortável.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-030', m.id, 'Qual dessas situações define o que é o abuso contra uma criança?',
       'É quando um adulto coloca regras para proteger a saúde da criança.',
       'É quando alguém desrespeita o corpo ou a segurança da criança, fazendo algo que a deixa assustada ou desconfortável.',
       'É quando um professor pede para o aluno fazer a lição de casa.',
       'É quando os pais pedem para a criança dormir cedo.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-031', m.id, 'As crianças têm direito de estudar, brincar, descansar e crescer com segurança. Por isso, existem regras que protegem as crianças de atividades de trabalho que podem prejudicar seu desenvolvimento. Com isso, você sabe o que é trabalho infantil?',
       'É quando uma criança ajuda a organizar seus brinquedos em casa.',
       'É quando uma criança participa de uma brincadeira com seus amigos.',
       'É quando uma criança aprende uma tarefa simples com sua família.',
       'É quando uma criança realiza um trabalho que não deveria fazer pela sua idade.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-032', m.id, 'Qual destas situações pode ser um exemplo de trabalho infantil?',
       'Uma criança ajuda a guardar seus brinquedos depois de brincar.',
       'Uma criança ajuda a colocar a mesa antes de uma refeição.',
       'Uma criança trabalha vendendo produtos na rua durante parte do dia.',
       'Uma criança ajuda a organizar seus materiais antes de ir para a escola.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-033', m.id, 'Por que é importante que uma criança tenha tempo para brincar?',
       'Porque brincar ajuda a criança a se desenvolver, aprender e conviver com outras pessoas.',
       'Porque brincar faz com que a criança não precise participar das atividades da escola.',
       'Porque brincar permite que a criança tenha menos responsabilidades dentro de casa.',
       'Porque brincar é uma atividade que deve substituir todas as outras atividades da criança.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-034', m.id, 'Por que a escola é importante na prevenção do trabalho infantil?',
       'Porque ajuda a criança a ocupar seu tempo e seguir regras durante o dia.',
       'Porque ajuda a criança a aprender tarefas e responsabilidades para o futuro.',
       'Porque ajuda a criança a aprender, desenvolver habilidades e conhecer seus direitos.',
       'Porque ajuda a criança a se preparar para escolher uma profissão no futuro.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-035', m.id, 'Se uma criança tiver dúvidas sobre uma situação de trabalho, o que ela pode fazer?',
       'Guardar a dúvida para si e esperar até ficar mais velha para procurar uma resposta.',
       'Procurar informações sozinha na internet e decidir o que fazer sem contar a ninguém.',
       'Perguntar a outras crianças e seguir o conselho que receber da maioria delas.',
       'Conversar com um adulto de confiança e perguntar se aquela situação é segura e adequada.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-036', m.id, 'De acordo com as leis do Brasil, como o Estatuto da Criança e do Adolescente (ECA), o que as crianças têm direito de fazer?',
       'Trabalhar o dia todo para ajudar os adultos.',
       'Estudar, brincar e crescer com proteção e segurança.',
       'Vender produtos em semáforos durante o horário da aula.',
       'Cuidar sozinhas de todos os afazeres da casa.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-037', m.id, 'No Brasil, existe uma idade mínima para que alguém possa começar a trabalhar de forma protegida, como "aprendiz". Que idade é essa?',
       '5 anos.',
       '10 anos.',
       '14 anos.',
       '8 anos.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-038', m.id, 'Existem programas do governo (como o PETI) que ajudam famílias em dificuldade. O que a criança deve fazer para que a família receba esse apoio?',
       'Trabalhar em dobro durante as férias.',
       'Frequentar a escola regularmente e participar das atividades educativas.',
       'Aprender a vender doces na rua.',
       'Ficar em casa ajudando apenas nos afazeres domésticos.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N1-039', m.id, 'Se você conhecer um amigo que está deixando de ir à escola porque precisa trabalhar, o que seria o mais correto a fazer?',
       'Pedir para ele trabalhar mais para ganhar dinheiro.',
       'Não falar nada para ninguém.',
       'Conversar com um professor ou um adulto de confiança para que eles possam ajudar essa criança.',
       'Parar de estudar para trabalhar junto com ele.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- ESCOLA-N2 — 21 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-001', m.id, 'Qual estrutura controla a entrada e saída de substâncias da célula?',
       'Mitocôndria',
       'Núcleo',
       'Ribossomo',
       'Membrana plasmática',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-002', m.id, 'Se uma célula possui núcleo definido, ela é classificada como:',
       'Unicelular',
       'Viral',
       'Eucarionte',
       'Procarionte',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-003', m.id, 'A organela responsável pela produção de proteínas é o:',
       'Lisossomo',
       'Centríolo',
       'Ribossomo',
       'Vacúolo',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-004', m.id, 'O citoplasma é importante porque:',
       'É onde ficam as organelas e ocorrem diversas reações químicas',
       'Guarda o DNA',
       'Produz oxigênio',
       'Filtra o sangue',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-005', m.id, 'Qual destas células NÃO possui parede celular?',
       'Vegetal',
       'Bactéria',
       'Fungo',
       'Animal',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-006', m.id, 'A troca de oxigênio e gás carbônico acontece nos:',
       'Diafragma',
       'Traqueia',
       'Brônquios',
       'Alvéolos',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-007', m.id, 'O fígado participa da digestão porque produz:',
       'Suco gástrico',
       'Saliva',
       'Insulina',
       'Bile',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-008', m.id, 'Qual sistema trabalha junto ao respiratório para distribuir oxigênio?',
       'Circulatório',
       'Esquelético',
       'Endócrino',
       'Linfático',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-009', m.id, 'O DNA é importante porque:',
       'Contém as informações genéticas do organismo',
       'Forma os ossos',
       'Fabrica hormônios',
       'Produz sangue',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-010', m.id, 'Uma mutação é:',
       'Um órgão',
       'Um tipo de bactéria',
       'Uma alteração no material genético',
       'Uma vitamina',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-011', m.id, 'Os cromossomos são encontrados principalmente no:',
       'Núcleo',
       'Lisossomo',
       'Citoplasma',
       'Complexo de Golgi',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-012', m.id, 'Mendel realizou seus experimentos utilizando:',
       'Feijão',
       'Milho',
       'Trigo',
       'Ervilhas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-013', m.id, 'Existe uma vacina, disponível gratuitamente no SUS para adolescentes, que previne uma IST. Qual é essa infecção?',
       'Herpes',
       'Gonorreia',
       'Sífilis',
       'HPV (Papilomavírus Humano)',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-014', m.id, 'Qual número você deve ligar para chamar uma ambulância em uma emergência médica?',
       '192 (SAMU)',
       '193',
       '190',
       '100',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-015', m.id, 'Ratos em áreas com lixo acumulado podem transmitir qual doença, principalmente em épocas de enchente?',
       'Dengue',
       'Catapora',
       'Caxumba',
       'Leptospirose',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-016', m.id, 'Restos de comida, cascas de fruta e borra de café são classificados como lixo:',
       'Hospitalar',
       'Reciclável',
       'Orgânico',
       'Eletrônico',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-017', m.id, 'Qual é o número do Corpo de Bombeiros?',
       '190',
       '192',
       '181',
       '193',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-018', m.id, 'As partes íntimas do corpo (aquelas cobertas pelo maiô ou pela sunga) são:',
       'Suas e particulares — ninguém deve tocá-las ou pedir para vê-las; em consultas de saúde, apenas com a presença e a autorização de um responsável',
       'De qualquer adulto que cuide de você',
       'De todos da família',
       'De quem oferecer presentes',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-019', m.id, 'Se um adulto ou outra pessoa te pedir para guardar um segredo sobre algo que te deixou desconfortável ou com medo, o certo é:',
       'Fingir que nada aconteceu',
       'Guardar o segredo para não criar problema',
       'Contar só depois de muitos anos',
       'Contar imediatamente a um adulto de confiança, como pai, mãe, professor ou profissional da UBS',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-020', m.id, 'Qual é o canal nacional para denunciar violações de direitos de crianças e adolescentes, como violência e abuso?',
       '199',
       '192',
       'Disque 100 (Disque Direitos Humanos), além do Conselho Tutelar',
       '190',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'ESCOLA-N2-021', m.id, 'Sobre o trabalho infantil no Brasil, é correto afirmar que:',
       'É bom porque ensina responsabilidade desde cedo',
       'É permitido em qualquer idade, desde que fora do horário escolar',
       'É permitido a partir dos 10 anos, se a família precisar',
       'É proibido; só é permitido trabalhar a partir dos 16 anos, ou aos 14 na condição de aprendiz, porque o trabalho precoce prejudica os estudos, a saúde e o desenvolvimento',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'ESCOLA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- FARMACIA-N1 — 1 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'FARMACIA-N1-001', m.id, 'As vacinas ajudam a proteger não apenas uma pessoa, mas também toda a comunidade. Por que a vacinação é importante para a saúde coletiva?',
       'Porque ajuda a prevenir doenças e a proteger a população.',
       'Porque faz com que ninguém nunca mais fique doente.',
       'Porque substitui todos os outros cuidados com a saúde.',
       'Porque somente pessoas que já tiveram uma doença precisam se vacinar.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'FARMACIA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- MERCADO-N1 — 1 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'MERCADO-N1-001', m.id, 'Verdadeiro ou Falso',
       'O sono permite que o corpo recupere as energias e evita a sobrecarga, garantindo o bem-estar mental e físico necessário para o cérebro processar o conhecimento e memorizar o que foi estudado.',
       'Casa',
       '– Verdadeiro ou Falso',
       'As necessidades do corpo, como o sono e o descanso, são menos importantes do que passar a noite inteira acordado lendo.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'MERCADO-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- MERCADO-N2 — 1 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'MERCADO-N2-001', m.id, 'Antes de comer frutas e verduras cruas, o correto é:',
       'Passar apenas um pano',
       'Descascar com a faca suja',
       'Lavar bem em água corrente e higienizar conforme orientação',
       'Comer direto da feira',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'MERCADO-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- PARQUE-N2 — 23 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-001', m.id, 'Se todos os predadores de um ambiente desaparecerem, é provável que:',
       'A população de presas aumente inicialmente',
       'A água desapareça',
       'Os produtores desapareçam primeiro',
       'Não ocorra nenhuma mudança',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-002', m.id, 'Os decompositores são essenciais porque:',
       'Produzem luz',
       'Fabricam chuva',
       'Reciclam nutrientes para o ambiente',
       'Eliminam oxigênio',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-003', m.id, 'Em uma cadeia alimentar, quem possui maior quantidade de energia?',
       'Consumidores terciários',
       'Carnívoros',
       'Produtores',
       'Onívoros',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-004', m.id, 'A extinção de uma espécie pode afetar outras porque:',
       'Os seres vivos dependem uns dos outros nas cadeias alimentares',
       'Apenas os animais são afetados',
       'As espécies vivem isoladas',
       'As plantas não participam',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-005', m.id, 'Biodiversidade elevada geralmente indica:',
       'Ausência de insetos',
       'Pouca vegetação',
       'Ambiente degradado',
       'Maior variedade de espécies e equilíbrio ecológico',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-006', m.id, 'A clorofila tem a função de:',
       'Captar energia luminosa',
       'Produzir sementes',
       'Produzir água',
       'Absorver oxigênio',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-007', m.id, 'Durante a fotossíntese, a planta transforma energia:',
       'Elétrica em térmica',
       'Sonora em luminosa',
       'Térmica em elétrica',
       'Luminosa em energia química',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-008', m.id, 'Os estômatos são estruturas responsáveis principalmente por:',
       'Absorver nutrientes do solo',
       'Transportar seiva',
       'Produzir flores',
       'Realizar trocas gasosas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-009', m.id, 'A raiz contribui para a sobrevivência da planta porque:',
       'Produz frutos',
       'Libera sementes',
       'Absorve água e sais minerais',
       'Faz fotossíntese',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-010', m.id, 'O xilema transporta principalmente:',
       'Água e sais minerais',
       'Oxigênio',
       'Açúcar',
       'Gás carbônico',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-011', m.id, 'Qual mudança de estado físico ocorre na formação da chuva?',
       'Fusão',
       'Solidificação',
       'Condensação',
       'Sublimação',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-012', m.id, 'O efeito estufa natural é importante porque:',
       'Produz oxigênio',
       'Elimina a atmosfera',
       'Mantém a Terra em temperatura adequada para a vida',
       'Impede a luz solar',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-013', m.id, 'O aumento do efeito estufa está relacionado principalmente ao excesso de:',
       'Hélio',
       'Vapor de água apenas',
       'Oxigênio',
       'Gás carbônico',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-014', m.id, 'Um recurso natural renovável é:',
       'Energia solar',
       'Petróleo',
       'Gás natural',
       'Carvão',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-015', m.id, 'Qual camada da atmosfera abriga a maior parte dos fenômenos meteorológicos?',
       'Troposfera',
       'Mesosfera',
       'Estratosfera',
       'Exosfera',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-016', m.id, 'Uma planta foi colocada em um armário escuro por duas semanas. O que provavelmente acontecerá?',
       'Terá dificuldade em produzir alimento pela falta de luz',
       'Crescerá normalmente',
       'Formará mais flores',
       'Produzirá mais oxigênio',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-017', m.id, 'Um peixe é retirado de um lago muito poluído. O fator ambiental que mais pode comprometer sua sobrevivência é:',
       'Rotação da Terra',
       'Excesso de luz',
       'Gravidade',
       'Baixa qualidade da água',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-018', m.id, 'Um cientista testa duas plantas: uma recebe água diariamente e outra não. A água é a:',
       'Hipótese',
       'Resultado',
       'Variável do experimento',
       'Conclusão',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-019', m.id, 'Qual atitude representa desenvolvimento sustentável?',
       'Desmatar para expandir cidades',
       'Descartar lixo em rios',
       'Queimar florestas',
       'Utilizar recursos naturais de forma responsável',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-020', m.id, 'Um morcego alimenta-se de frutos e ajuda a espalhar sementes. Nesse caso, ele exerce importante papel de:',
       'Predador',
       'Produtor',
       'Dispersor de sementes',
       'Decompositor',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-021', m.id, 'Qual destas doenças é transmitida pela picada do mosquito Aedes aegypti?',
       'Tuberculose',
       'Sarampo',
       'Catapora',
       'Dengue, zika e chikungunya',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-022', m.id, '“Saúde coletiva” significa que:',
       'Cada um cuida apenas de si mesmo',
       'Saúde é assunto exclusivo do hospital',
       'A saúde de uma pessoa depende também do ambiente e das atitudes de toda a comunidade',
       'Só o médico é responsável pela saúde',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PARQUE-N2-023', m.id, 'Por que separar o lixo é importante?',
       'Porque permite a reciclagem, reduz a poluição e melhora as condições de trabalho dos catadores',
       'Porque diminui a conta de luz',
       'Só para deixar a rua mais bonita',
       'Porque a lei obriga e não há outro motivo',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PARQUE-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- PRACA-N1 — 7 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-001', m.id, 'Qual dessas atitudes representa melhor o cuidado coletivo com a saúde?',
       'Pensar somente na própria saúde.',
       'Deixar os problemas do bairro para outras pessoas resolverem.',
       'Participar de ações de prevenção e ajudar a proteger a comunidade.',
       'Evitar conversar sobre problemas de saúde.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-002', m.id, 'Lucas terminou de brincar no parquinho e está na hora do lanche. Qual atitude é mais adequada antes de comer?',
       'Comer logo, pois suas mãos parecem limpas. B) Limpar as mãos na roupa e começar a comer.',
       'Lavar as mãos com água e sabão antes de pegar o lanche.',
       'Esperar terminar o lanche para lavar as mãos.',
       'Escola e pracinha',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-003', m.id, 'O SAMU quer ajudar o maior número de pessoas possível, mesmo em lugares difíceis de chegar. Além das ambulâncias que andam nas ruas, que outros transportes eles podem usar? A) Patins e skates para ir mais rápido.',
       'Ambulanchas (barcos) para atender em rios e aeromédicos (aviões ou helicópteros) para lugares distantes.',
       'Carroças puxadas por cavalos.',
       'Eles usam apenas um tipo de ambulância para todas as situações.',
       'UPA',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-004', m.id, 'Por que a coleta seletiva é importante para a nossa cidade e para o meio ambiente?',
       'Porque separa materiais que podem ser aproveitados e reciclados.',
       'Porque faz com que todo o lixo seja mandado separado para o lixão.',
       'Porque aumenta a quantidade de lixo nas ruas.',
       'Porque permite misturar todos os tipos de lixo.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-005', m.id, 'A coleta seletiva traz benefícios para a sociedade e para o meio ambiente. Qual alternativa mostra uma dessas vantagens?',
       'Ajuda a manter a cidade mais organizada e permite que materiais sejam reaproveitados.',
       'Aumenta a quantidade de lixo nas ruas e nos espaços públicos.',
       'Faz com que os materiais recicláveis sejam misturados ao lixo comum.',
       'Dificulta o trabalho das pessoas que fazem a separação dos materiais.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-006', m.id, 'Imagine que Pedro está comendo seu lanche enquanto conversa com um amigo. Qual alternativa mostra melhor como devemos entender o corpo humano?',
       'Cada parte do corpo funciona completamente sozinha, sem ligação com outros órgãos.',
       'Apenas os órgãos internos fazem parte do corpo.',
       'O corpo só funciona quando estamos fazendo exercícios.',
       'O corpo é formado por partes que podem trabalhar juntas e se relacionar com o ambiente.',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N1-007', m.id, 'A frase "O corpo humano é uma máquina feita para o movimento" quer nos dizer que:  A) Devemos passar o dia todo sentados vendo televisão.',
       'Nosso corpo precisa de atividades físicas, como correr, pular e dançar, para funcionar bem e ter saúde.',
       'O corpo humano é exatamente igual a um carro de metal.',
       'Movimentar o corpo é ruim e nos deixa doentes.',
       'Escola e quadra',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- PRACA-N2 — 3 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N2-001', m.id, 'Durante uma corrida entre Bruno e Ana, ele percebeu que ela estava muito ofegante e com o coração acelerado. A frequência cardíaca aumenta principalmente para:',
       'Produzir mais gordura',
       'Diminuir a temperatura',
       'Produzir saliva',
       'Levar mais oxigênio aos músculos',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N2-002', m.id, 'Qual atitude ajuda a evitar a proliferação do mosquito da dengue?',
       'Não deixar água parada em vasos, garrafas e caixas d’água destampadas',
       'Deixar pneus velhos acumulados no quintal',
       'Regar as plantas todos os dias',
       'Deixar o lixo aberto na calçada',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'PRACA-N2-003', m.id, 'Na coleta seletiva, a lixeira azul é destinada a qual material?',
       'Papel e papelão',
       'Metal',
       'Plástico',
       'Vidro',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'PRACA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- QUADRA-N1 — 1 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'QUADRA-N1-001', m.id, 'Brincar, correr, dançar e praticar esportes são formas de movimentar o corpo. Por que esses movimentos são importantes?',
       'Porque fazem apenas os braços ficarem mais fortes.',
       'Porque ajudam o corpo a funcionar bem e contribuem para o bem-estar.',
       'Porque o corpo precisa ficar em movimento o tempo todo, sem descansar.',
       'Porque substituem a alimentação.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'QUADRA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UBS-N1 — 2 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N1-001', m.id, 'Lucas aprendeu na escola que a dengue é transmitida por um "vetor". O que é o vetor da dengue no Brasil?',
       'Uma formiga que vive no jardim.',
       'A fêmea do mosquito Aedes aegypti.',
       'Um passarinho que voa pela cidade.',
       'O lixo acumulado nas calçadas.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N1-002', m.id, 'Pedro está aprendendo sobre o corpo humano. A professora perguntou quais são os cinco sentidos que usamos para perceber o mundo ao nosso redor. Qual alternativa está correta?',
       'Visão, audição, olfato, paladar e tato.',
       'Visão, respiração, olfato, paladar e movimento.',
       'Audição, coração, tato, respiração e paladar.',
       'Olfato, visão, movimento, audição e digestão.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UBS-N2 — 16 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-001', m.id, 'Antibióticos combatem principalmente:',
       'Bactérias',
       'Parasitas',
       'Fungos',
       'Vírus',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-002', m.id, 'A vacinação cria proteção porque estimula a produção de:',
       'Anticorpos e memória imunológica',
       'Glicose',
       'Hemoglobina',
       'Plaquetas',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-003', m.id, 'Qual hábito reduz a transmissão de doenças respiratórias?',
       'Compartilhar copos',
       'Beber refrigerante',
       'Higienizar as mãos e cobrir a boca ao tossir',
       'Dormir menos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-004', m.id, 'Uma dieta pobre em ferro pode causar:',
       'Miopia',
       'Asma',
       'Anemia',
       'Diabetes',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-005', m.id, 'O excesso de radiação ultravioleta pode aumentar o risco de:',
       'Pneumonia',
       'Fratura',
       'Gastrite',
       'Câncer de pele',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-006', m.id, 'O que significa a sigla “IST”?',
       'Inflamação Súbita da Traqueia',
       'Infecção Simples do Tórax',
       'Índice de Saúde Total',
       'Infecção Sexualmente Transmissível',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-007', m.id, 'Qual é o único método que protege ao mesmo tempo contra ISTs e gravidez?',
       'Preservativo (camisinha)',
       'DIU',
       'Pílula anticoncepcional',
       'Injeção anticoncepcional',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-008', m.id, 'Qual destas situações NÃO transmite o HIV?',
       'Abraçar, beijar o rosto ou dividir um copo com uma pessoa que vive com HIV',
       'Compartilhamento de seringas',
       'Relação sexual sem preservativo',
       'Da mãe para o bebê, sem tratamento na gravidez',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-009', m.id, 'Sobre os sintomas das ISTs, é correto afirmar que:',
       'Sempre causam dor forte',
       'Só aparecem em pessoas adultas',
       'Muitas vezes não causam sintoma nenhum, por isso é importante fazer exames',
       'Desaparecem sozinhas sem tratamento',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-010', m.id, 'Onde o bebê se desenvolve durante a gravidez?',
       'No útero',
       'No estômago',
       'Nas trompas',
       'Nos ovários',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-011', m.id, 'Como se chama a célula reprodutora masculina?',
       'Espermatozoide',
       'Glóbulo branco',
       'Óvulo',
       'Hormônio',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-012', m.id, 'A menstruação acontece porque:',
       'O revestimento interno do útero descama quando não há gravidez',
       'A pessoa comeu algo errado',
       'O corpo está doente',
       'Os rins param de funcionar',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-013', m.id, 'Quais destas mudanças são normais na puberdade?',
       'Crescimento rápido de altura e aparecimento de espinhas',
       'Crescimento de pelos e mudança na voz',
       'Aumento da transpiração e mudanças de humor',
       'Todas as anteriores',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-014', m.id, 'Os ovários são responsáveis por:',
       'Filtrar o sangue',
       'Digerir alimentos',
       'Produzir os óvulos e hormônios femininos',
       'Bombear o sangue',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-015', m.id, 'Você se queimou levemente com água quente. O que fazer primeiro?',
       'Passar pasta de dente',
       'Passar manteiga ou óleo',
       'Colocar a região embaixo de água corrente fria por alguns minutos',
       'Estourar as bolhas',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UBS-N2-016', m.id, 'Diabetes e hipertensão são doenças que:',
       'São causadas por vírus',
       'São transmitidas por aperto de mão',
       'Só aparecem em idosos e não têm tratamento',
       'Não são contagiosas e podem ser controladas com hábitos saudáveis e acompanhamento na UBS',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UBS-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UPA-N1 — 4 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N1-001', m.id, 'Em situações de emergência, devemos chamar o SAMU (Serviço de Atendimento Móvel de Urgência). Basta discar 192 no celular ou telefone fixo para conseguir ajuda. Esse serviço é gratuito e funciona TODOS os dias! Você sabe identificar situações de emergência? Selecione abaixo quando devemos chamar o SAMU:',
       'Corte com pouco sangramento.',
       'Febre prolongada.',
       'Acidentes com produtos perigosos.',
       'Vômito e diarreia.',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N1-002', m.id, 'O SAMU pode ajudar pessoas que estão passando por uma situação de emergência. Sobre o serviço, qual alternativa está correta?',
       'O SAMU funciona somente durante o dia.',
       'O SAMU pode ser chamado gratuitamente pelo número 192.',
       'Para chamar o SAMU, é preciso pagar.',
       'O SAMU atende apenas pessoas que sofreram acidentes.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N1-003', m.id, 'Imagine que uma pessoa sofreu um choque elétrico e precisa de ajuda. O que devemos fazer?',
       'Chamar o SAMU pelo número 192.',
       'Esperar algumas horas para ver se ela melhora.',
       'Levar a pessoa para fazer um exame no médico.',
       'Ligar para o SAMU somente se ela estiver com febre.',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N1-004', m.id, 'O SAMU conta com profissionais preparados para orientar as pessoas durante uma emergência. O que acontece quando ligamos para o 192?',
       'A ligação é encerrada imediatamente.',
       'Os profissionais coletam informações e podem orientar sobre os primeiros cuidados.',
       'A pessoa que ligou precisa ir até uma ambulância para receber atendimento.',
       'O SAMU sempre envia um avião, independentemente da situação.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N1'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UPA-N2 — 5 questões

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N2-001', m.id, 'Um colega está engasgado, tossindo forte e conseguindo respirar. O que fazer?',
       'Colocar o dedo na boca dele para retirar o alimento',
       'Bater forte nas costas com o punho fechado',
       'Incentivar que continue tossindo e pedir ajuda de um adulto',
       'Dar água imediatamente',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N2-002', m.id, 'Alguém se cortou e está sangrando bastante. Qual a atitude correta?',
       'Passar pó de café ou terra',
       'Lavar com álcool e esfregar',
       'Pressionar o local com um pano limpo e procurar ajuda',
       'Deixar sangrar até parar sozinho',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N2-003', m.id, 'Uma pessoa desmaiou perto de você. O que você deve fazer?',
       'Jogar água gelada no rosto',
       'Sacudir e levantar a pessoa rapidamente',
       'Deitar a pessoa de costas, elevar as pernas, afrouxar roupas apertadas e chamar ajuda',
       'Dar comida ou bebida imediatamente',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N2-004', m.id, 'Ao ligar para o SAMU (192), qual informação é essencial passar?',
       'O nome do médico da família',
       'Apenas o seu nome',
       'Nada, basta ligar e desligar',
       'O endereço completo, o que aconteceu e quantas pessoas precisam de ajuda',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, missao_id, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)
select 'UPA-N2-005', m.id, 'Durante uma ligação de emergência, você deve:',
       'Desligar assim que falar o endereço',
       'Gritar até alguém atender',
       'Manter a calma, responder às perguntas e só desligar quando o atendente autorizar',
       'Passar informações inventadas para agilizar',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from missoes m where m.codigo_externo = 'UPA-N2'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- ── Conferir depois de rodar ─────────────────────────────────────────
-- select c.slug, m.nivel_etario, count(q.id) as questoes
--   from missoes m join cenarios c on c.id = m.cenario_id
--   left join questoes q on q.missao_id = m.id
--  group by c.slug, m.nivel_etario order by c.slug, m.nivel_etario;
