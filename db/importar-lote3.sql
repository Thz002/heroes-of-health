-- =====================================================================
--  HERÓIS DA SAÚDE — as perguntas da equipe de Medicina (lote 3)
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
--  É seguro rodar quantas vezes quiser: cada questão tem um
--  codigo_externo único, e o import é "on conflict do update".
--  Rodar de novo corrige o texto SEM apagar nenhuma resposta já dada
--  pelos alunos — o que um "delete + insert" destruiria, porque
--  respostas_alunos referencia questoes com on delete cascade.
--
--  A coluna criado_por não aparece aqui de propósito: o default dela é
--  o código do sistema ('00000000-0000-0000-0000-000000000000'), então
--  toda questão deste arquivo já entra como "do sistema", visível a
--  todos os professores. Questão de professor nasce pelo painel.
--
--  249 questões, em 18 grupos (cenário × nível).
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

-- Ficaram DE FORA, por não caberem no formato de 2, 4 ou 5 alternativas
-- ou por não terem a resposta marcada no arquivo de origem:
--   nível 1 (ubs), questão 12: sem resposta marcada
--     A Camila sentiu uma dor de cabeça fraca e incômodo no corpo após correr no parque. Como 
--   nível 1 (upa), questão 14: sem resposta marcada
--     Se uma pessoa ingerir por engano um produto de limpeza perigoso (intoxicação), em qual u


-- ── Guarda: os cenários têm de existir antes ─────────────────────────
do $$
declare faltando text;
begin
  select string_agg(s, ', ') into faltando
  from unnest(array['casa', 'corrego', 'escola', 'farmacia', 'mercado', 'parque', 'praca', 'quadra', 'terreno-baldio', 'ubs', 'upa']) s
  where not exists (select 1 from cenarios c where c.slug = s);
  if faltando is not null then
    raise exception 'Cenários que faltam no banco: %. Rode db/seed.sql antes deste arquivo.', faltando;
  end if;
end $$;

-- ── Guarda: a coluna da letra E tem de existir antes ─────────────────
-- Ela chegou com o nível 3 (formato ENEM). Banco que ainda não rodou o
-- setup.sql novo pararia no primeiro insert com um erro sem explicação.
do $$
begin
  if not exists (select 1 from information_schema.columns
                 where table_name = 'questoes' and column_name = 'opcao_e') then
    raise exception 'Falta a coluna questoes.opcao_e. Rode db/setup.sql de novo antes deste arquivo.';
  end if;
end $$;


-- ── 1. As questões ───────────────────────────────────────────────────
-- Cada uma carrega o próprio cenário e a própria faixa etária.

-- CASA-N3 — 5 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CASA-N3-001', c.id, 3, 'O cyberbullying se diferencia do bullying tradicional principalmente por:',
       'Ser sempre menos prejudicial à vítima pois é algo mais silencioso e passageiro',
       'Não gerar nenhum impacto psicológico por estar em um ambiente tecnológico e não chegar a ter risco físico ou agressões verbais',
       'Ocorrer exclusivamente de forma presencial, não afetando a vítima quando esta em sua própria casa',
       'Ter maior alcance e poder ocorrer a qualquer hora, inclusive fora do ambiente escolar, dificultando o afastamento da situação',
       'Ser praticado apenas por adultos',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CASA-N3-002', c.id, 3, 'O burnout escolar se diferencia do estresse pontual de provas porque envolve:',
       'Exaustão física e emocional prolongada, com impacto duradouro sobre a motivação e o desempenho',
       'Exatamente a mesma duração e intensidade do estresse de uma única prova, se equivalendo em diferentes situações',
       'Nenhuma relação com sobrecarga contínua de atividades e apenas relacionada ao imaginário da própria pessoa',
       'O burnout é manifestado exclusivamente na vida adulta, pois os jovens e adolescentes não trabalham, apenas estudam',
       'Um estado de ânimo que passa em minutos',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CASA-N3-003', c.id, 3, 'Transtornos alimentares são compreendidos como condições multifatoriais porque envolvem:',
       'Exclusivamente fatores nutricionais, sendo necessário a busca de alimentos melhores e condizentes a realidade de cada pessoa',
       'Nenhuma influência emocional ou social',
       'Fatores biológicos, psicológicos e sociais, e não apenas uma escolha alimentar isolada',
       'Apenas características genéticas isoladas, questões sociais e psicológicas nao possuem envolvimento',
       'Apenas fatores hormonais isolados, sendo necessário a busca única de um endocrinologista',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CASA-N3-004', c.id, 3, 'Campanhas de saúde pública enfatizam a busca por ajuda profissional diante de sofrimento persistente porque:',
       'O sofrimento psíquico sempre desaparece espontaneamente com o tempo',
       'Não há benefício comprovado em buscar acompanhamento profissional',
       'A busca por ajuda deve ocorrer apenas em casos extremamente graves',
       'É desnecessária quando os sintomas são leves, sendo procurado apenas quando estamos em estado mais grave',
       'Profissionais capacitados podem oferecer diagnóstico e tratamento adequados, favorecendo a recuperação e prevenindo agravamentos',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CASA-N3-005', c.id, 3, 'São sinais de dependência digital:',
       'Uso equilibrado de dispositivos com horários bem definidos',
       'Dificuldade de controlar o tempo de uso, isolamento social e prejuízo no sono',
       'Ausência completa de qualquer alteração de rotina, a dependência não causa mudanças na vida de alguém',
       'Melhora do desempenho escolar e da qualidade do sono, além da melhora no convívio social entre colegas',
       'Aumento do tempo dedicado a atividades ao ar livre',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- CORREGO-N2 — 30 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-001', c.id, 2, 'Qual é uma das principais funções do tratamento de esgoto?',
       'Produzir água salgada para a população.',
       'Reduzir a contaminação ambiental por resíduos e microrganismos.',
       'Aumentar a quantidade de lixo nos rios.',
       'Substituir a coleta de resíduos sólidos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-002', c.id, 2, 'O esgoto lançado sem tratamento pode:',
       'melhorar a qualidade da água.',
       'eliminar os microrganismos existentes.',
       'contaminar a água e o solo.',
       'transformar qualquer água em potável.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-003', c.id, 2, 'Saneamento básico está relacionado à saúde porque:',
       'atua somente na aparência das cidades.',
       'beneficia exclusivamente animais e plantas.',
       'ajuda a prevenir doenças e proteger a população.',
       'substitui completamente os serviços de saúde.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-004', c.id, 2, 'Se água contaminada for utilizada para consumo, pode ocorrer:',
       'fortalecimento automático da imunidade.',
       'aumento do risco de doenças transmitidas pela água.',
       'destruição imediata de todos os microrganismos.',
       'aumento da quantidade de oxigênio no sangue.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-005', c.id, 2, 'Qual situação representa um risco à saúde?',
       'Tratamento adequado do esgoto.',
       'Destinação correta dos resíduos.',
       'Proteção das fontes de água.',
       'Esgoto correndo a céu aberto.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-006', c.id, 2, 'A contaminação de um córrego pode afetar várias pessoas porque:',
       'doenças ambientais nunca ultrapassam uma residência.',
       'água e ambiente são recursos compartilhados pela comunidade.',
       'microrganismos vivem exclusivamente dentro do corpo.',
       'a qualidade da água não interfere na saúde humana.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-007', c.id, 2, 'Qual relação está CORRETA?',
       'Esgoto tratado → maior contaminação ambiental.',
       'Saneamento adequado → proteção da saúde coletiva.',
       'Água contaminada → menor risco de doenças.',
       'Lixo acumulado → controle de animais vetores.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-008', c.id, 2, 'Por que o saneamento é considerado uma medida preventiva?',
       'Porque trata somente pessoas já doentes.',
       'Porque substitui todas as vacinas existentes.',
       'Porque reduz a exposição da população a alguns agentes causadores de doenças.',
       'Porque elimina qualquer doença de uma comunidade.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-009', c.id, 2, 'Microrganismos presentes em água contaminada:',
       'são sempre benéficos aos seres humanos.',
       'são todos visíveis sem microscópio.',
       'podem incluir organismos capazes de provocar doenças.',
       'desaparecem imediatamente ao entrar na água.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-010', c.id, 2, 'Uma comunidade apresenta esgoto a céu aberto próximo às casas. Qual intervenção atua mais diretamente sobre a origem do problema?',
       'Distribuir somente medicamentos aos moradores.',
       'Melhorar a coleta e o tratamento do esgoto.',
       'Fechar as janelas de todas as residências.',
       'Suspender todas as atividades físicas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-011', c.id, 2, 'A presença de saneamento adequado demonstra que saúde:',
       'depende somente de consultas médicas.',
       'é determinada exclusivamente pela genética.',
       'também depende das condições ambientais e sociais.',
       'não possui relação com políticas públicas.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-012', c.id, 2, 'Qual atitude NÃO contribui para a proteção da água?',
       'Destinar corretamente os resíduos.',
       'Tratar adequadamente o esgoto.',
       'Descartar resíduos diretamente nos córregos.',
       'Evitar a contaminação das fontes de água.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-013', c.id, 2, 'Uma doença associada à água contaminada pode atingir muitas pessoas de uma região. Esse exemplo mostra a importância:',
       'somente da saúde individual.',
       'da saúde pública e do saneamento.',
       'exclusivamente dos hospitais.',
       'apenas da prática esportiva.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-014', c.id, 2, 'Água transparente é necessariamente própria para consumo?',
       'Sim, porque microrganismos alteram sempre a cor.',
       'Sim, se não apresentar cheiro desagradável.',
       'Não, porque contaminantes podem estar presentes sem serem visíveis.',
       'Não, porque nenhuma água transparente é potável.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-015', c.id, 2, 'Qual sequência representa melhor uma possível cadeia de risco?',
       'Tratamento de esgoto → contaminação → doença.',
       'Saneamento → água contaminada → prevenção.',
       'Esgoto sem tratamento → contaminação ambiental → maior risco de doenças.',
       'Limpeza urbana → proliferação de vetores → prevenção.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-016', c.id, 2, 'Por que preservar os rios é também uma questão de saúde?',
       'Porque rios existem somente para atividades recreativas.',
       'Porque a qualidade ambiental e da água influencia a saúde das comunidades.',
       'Porque a água dos rios não interage com outros ambientes.',
       'Porque todo rio fornece água diretamente para consumo.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-017', c.id, 2, 'Jogar lixo em um rio pode:',
       'melhorar a qualidade da água.',
       'aumentar naturalmente sua potabilidade.',
       'favorecer poluição e problemas ambientais.',
       'impedir qualquer proliferação de vetores.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-018', c.id, 2, 'Qual ação contribui para a preservação dos rios?',
       'Descartar óleo diretamente na água.',
       'Lançar esgoto sem tratamento.',
       'Abandonar resíduos nas margens.',
       'Dar aos resíduos uma destinação adequada.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-019', c.id, 2, 'Um rio poluído pode afetar:',
       'somente os peixes.',
       'exclusivamente os seres humanos.',
       'diferentes seres vivos e o equilíbrio ambiental.',
       'apenas as plantas aquáticas.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-020', c.id, 2, 'Meio ambiente e saúde humana:',
       'são assuntos completamente independentes.',
       'estão relacionados de diversas maneiras.',
       'relacionam-se somente durante enchentes.',
       'possuem relação apenas em áreas rurais.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-021', c.id, 2, 'A poluição da água pode aumentar:',
       'sua segurança para consumo.',
       'sua quantidade de nutrientes essenciais.',
       'o risco de problemas ambientais e de saúde.',
       'a eficiência natural do saneamento.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-022', c.id, 2, 'Participar de um mutirão de limpeza das margens de um rio é uma ação:',
       'exclusivamente recreativa.',
       'relacionada apenas à estética.',
       'de cuidado ambiental e comunitário.',
       'sem qualquer relação com saúde.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-023', c.id, 2, 'Se uma fábrica ou residência despeja resíduos inadequadamente no rio, o problema:',
       'permanece restrito ao ponto do descarte.',
       'pode produzir consequências em outras partes do ambiente.',
       'desaparece assim que o resíduo entra na água.',
       'não pode afetar nenhum organismo aquático.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-024', c.id, 2, 'A preservação dos rios contribui para:',
       'aumentar o descarte de resíduos.',
       'eliminar a necessidade de saneamento.',
       'manter o equilíbrio ambiental e proteger a água.',
       'impedir todas as doenças humanas.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-025', c.id, 2, 'Qual frase melhor representa o conceito de saúde ambiental?',
       'A saúde depende exclusivamente dos hospitais.',
       'O ambiente não interfere no bem-estar humano.',
       'Ambientes saudáveis contribuem para comunidades mais saudáveis.',
       'Apenas ambientes urbanos interferem na saúde.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-026', c.id, 2, 'Por que não devemos considerar um rio limpo apenas observando sua aparência?',
       'Porque toda água de rio é necessariamente tóxica.',
       'Porque alguns contaminantes podem não ser percebidos visualmente.',
       'Porque água limpa precisa necessariamente ser azul.',
       'Porque a transparência indica presença de esgoto.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-027', c.id, 2, 'Qual situação demonstra responsabilidade coletiva?',
       'Jogar um pequeno lixo no rio porque “não fará diferença”.',
       'Esperar que apenas o governo preserve o ambiente.',
       'Evitar a poluição e colaborar com a conservação dos espaços naturais.',
       'Queimar resíduos ao lado do rio para evitar descartá-los na água.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-028', c.id, 2, 'O despejo de esgoto em rios pode prejudicar:',
       'apenas a aparência da água.',
       'exclusivamente a temperatura do ambiente.',
       'a qualidade da água e a saúde ambiental.',
       'somente a velocidade da correnteza.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-029', c.id, 2, 'Quando protegemos um rio, podemos beneficiar:',
       'somente quem vive imediatamente ao lado dele.',
       'apenas pessoas que utilizam barcos.',
       'exclusivamente animais aquáticos.',
       'ecossistemas e diferentes comunidades humanas.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N2-030', c.id, 2, 'Qual conclusão é mais adequada?',
       'Preservação ambiental não faz parte da promoção da saúde.',
       'Proteger os recursos naturais também é uma forma de proteger a saúde.',
       'Saúde pública está limitada aos serviços médicos.',
       'Poluição da água é somente um problema visual.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- CORREGO-N3 — 6 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-001', c.id, 3, 'A maior incidência de hepatite A em regiões com saneamento precário se explica porque:',
       'A hepatite A é transmitida só por transfusão de sangue',
       'As três hepatites têm exatamente a mesma via de transmissão',
       'A hepatite A não tem relação com condições sanitárias, sendo exclusiva de fatores internos',
       'A hepatite A é transmitida apenas por contato sexual',
       'A hepatite A é transmitida por via fecal-oral, dependendo diretamente da qualidade da água e dos alimentos',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-002', c.id, 3, 'Durante enchentes, o risco de leptospirose aumenta principalmente devido a:',
       'Exposição prolongada dessa água no sol, por promover a proliferação bacteriana',
       'Contato com mosquitos que picam roedores, atuando como vetores secundários',
       'Contato com poeira doméstica',
       'Contato com água contaminada pela urina de roedores infectados',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-003', c.id, 3, 'O acesso à água tratada e ao esgotamento sanitário contribui para reduzir doenças bacterianas porque:',
       'Aumenta artificialmente a proliferação de bactérias no ambiente',
       'Diminui o contato da população com água e ambientes contaminados',
       'Não guarda nenhuma relação com a incidência dessas doenças',
       'Substitui integralmente a necessidade de vacinação',
       'Elimina a necessidade de higiene pessoal',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-004', c.id, 3, 'O saneamento básico é a medida mais eficaz de controle da esquistossomose porque:',
       'Elimina diretamente todos os caramujos transmissores do ambiente, dificultando a transmissão da doença',
       'Não tem nenhuma relação com o ciclo do parasita',
       'Impede que ovos do Schistosoma mansoni, eliminados nas fezes humanas, alcancem corpos d''água onde vivem os caramujos hospedeiros',
       'Substitui completamente a necessidade de tratamento dos infectados',
       'Aumenta a reprodução dos caramujos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-005', c.id, 3, 'Giardíase e amebíase se diferenciam por serem causadas por:',
       'Protozoários distintos',
       'Bactérias diferentes',
       'Vírus diferentes',
       'Fungos diferentes',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'CORREGO-N3-006', c.id, 3, 'O despejo irregular de esgoto próximo a hortas comunitárias aumenta o risco de contaminação porque:',
       'Não existe relação entre esgoto e contaminação de hortas',
       'A água contaminada pode ser usada para irrigação ou infiltrar-se no solo onde os alimentos são cultivados',
       'Ovos de parasitas não sobrevivem fora do corpo humano, mas podem contaminar as hortaliças',
       'O esgoto elimina automaticamente qualquer parasita presente',
       'As hortas urbanas nunca usam água de córregos',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- ESCOLA-N3 — 23 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-001', c.id, 3, 'Dengue, zika e chikungunya são transmitidas pelo mesmo vetor, mas causadas por vírus de famílias diferentes. Essa informação explica por que:',
       'Uma pessoa pode ser infectada por mais de uma dessas arboviroses ao longo da vida, pois a imunidade a uma não protege contra as outras',
       'As três doenças são exatamente a mesma, com nomes diferentes',
       'Só é possível contrair uma delas uma única vez na vida',
       'A vacina contra uma delas protege automaticamente contra as demais',
       'Essas doenças possuem os mesmos sintomas, mesmo sendo causadas por diferentes famílias de vírus',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-002', c.id, 3, 'Por que uma pessoa pode ter dengue mais de uma vez na vida?',
       'Porque a vacina não funciona',
       'Porque existem quatro sorotipos diferentes do vírus da dengue',
       'Porque o mosquito muda de espécie',
       'Porque a dengue não gera nenhuma imunidade',
       'Porque só ocorre em climas frios',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-003', c.id, 3, 'A dengue tem quatro sorotipos (DENV-1 a DENV-4). O maior risco de dengue grave costuma ocorrer:',
       'Na primeira infecção, independentemente do sorotipo',
       'Em uma infecção secundária por um sorotipo diferente do da primeira infecção',
       'Apenas em crianças menores de 2 anos',
       'Exclusivamente em idosos, mesmo na primeira infecção',
       'Exclusivamente em gestantes',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-004', c.id, 3, 'Programas de controle biológico, como a liberação de mosquitos Aedes aegypti infectados com a bactéria Wolbachia, têm reduzido casos de dengue em algumas cidades porque:',
       'A bactéria dificulta a replicação do vírus da dengue dentro do mosquito, reduzindo sua capacidade de transmissão',
       'A bactéria mata o mosquito imediatamente após a infecção',
       'A Wolbachia elimina o vírus presente no sangue humano',
       'A bactéria torna o mosquito estéril, sem nenhum efeito sobre o vírus',
       'A Wolbachia dificulta a replicação do vírus e cessando o ciclo dentro do próprio mosquito',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-005', c.id, 3, 'Qual arbovirose está mais associada a más-formações no bebê quando a mãe é infectada durante a gravidez?',
       'Dengue',
       'Febre amarela',
       'Malária',
       'Chikungunya',
       'Zika',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-006', c.id, 3, 'Um levantamento epidemiológico mostra picos de chikungunya, doença caracterizada por fortes dores nas articulações, coincidindo com os meses mais chuvosos do ano em uma cidade. A explicação mais adequada para esse padrão é:',
       'O acúmulo de lixo secos em terrenos baldios cria um ambiente favorável para a criação do vetor',
       'O vírus só sobrevive em temperaturas baixas',
       'A chuva elimina o vírus do ambiente',
       'Não há relação entre pluviosidade e proliferação de vetores',
       'O acúmulo de água parada nesse período amplia os criadouros do mosquito vetor',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-007', c.id, 3, 'Qual doença abaixo NÃO é transmitida pelo Aedes aegypti?',
       'Dengue',
       'Zika',
       'Malária',
       'Febre amarela urbana',
       'Chikungunya',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-008', c.id, 3, 'A latência do HPV, que pode durar anos, reforça a importância de:',
       'Rastreamento apenas quando surgem sintomas evidentes',
       'Interromper o acompanhamento após a vacinação',
       'Rastreamento periódico, mesmo sem sintomas',
       'Vacinar apenas pessoas já infectadas',
       'Evitar qualquer exame até os 40 anos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-009', c.id, 3, 'A hepatite C crônica pode evoluir silenciosamente para cirrose e câncer de fígado. Isso reforça a importância de:',
       'Aguardar o surgimento de sintomas para buscar diagnóstico',
       'Não existir necessidade de acompanhamento nesses casos',
       'A doença nunca evoluir sem tratamento',
       'Diagnóstico precoce por exames, mesmo na ausência de sintomas',
       'Tratar apenas quando surgir cirrose',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-010', c.id, 3, 'A diferença entre ser soropositivo para o HIV e desenvolver AIDS está em que:',
       'Ser soropositivo indica infecção pelo vírus; AIDS é o estágio avançado, com comprometimento importante da imunidade, que pode ser retardado ou evitado com tratamento',
       'As duas expressões significam exatamente a mesma coisa, porém com nomenclaturas diferentes referentes a época em que o termo era utilizado',
       'AIDS é uma doença sem qualquer relação com o HIV',
       'Ser soropositivo significa necessariamente já ter desenvolvido a síndrome',
       'AIDS é uma fase anterior à infecção pelo HIV',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-011', c.id, 3, 'Gonorreia e clamídia costumam ser abordadas de forma conjunta em protocolos de saúde porque:',
       'São causadas exatamente pelo mesmo microrganismo',
       'Apenas uma delas é considerada uma IST',
       'Frequentemente ocorrem como coinfecção e apresentam sintomas semelhantes, dificultando a distinção sem exames específicos',
       'Não existe nenhuma relação clínica entre as duas infecções',
       'Uma delas é causada por vírus e outra por bactérias',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-012', c.id, 3, 'O herpes genital, apesar de não ter cura definitiva, é controlável porque:',
       'O acompanhamento médico e o uso de medicamentos específicos podem reduzir a frequência e a intensidade das crises',
       'O tratamento elimina completamente o vírus do organismo, mas pode aparecer sintomas com frequência',
       'Não existe nenhuma forma de manejo clínico disponível',
       '"Controle" e "cura" significam exatamente a mesma coisa nesse contexto',
       'O herpes genital nunca pode ser tratado',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-013', c.id, 3, 'A diferença entre ansiedade pontual e transtorno de ansiedade está principalmente:',
       'No fato de a ansiedade pontual ser sempre mais intensa e duradoura',
       'Não existe nenhuma diferença relevante entre as duas situações',
       'Na persistência e na intensidade dos sintomas',
       'Exclusivamente na idade da pessoa que apresenta os sintomas',
       'No fato de o transtorno durar só um dia',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-014', c.id, 3, 'O uso excessivo de telas está associado ao aumento de ansiedade e à piora do sono porque:',
       'Não guarda nenhuma relação com sono ou ansiedade',
       'Melhora automaticamente a qualidade do sono',
       'Reduz completamente qualquer forma de estímulo mental, deixando a mente em estado cansaço',
       'Só afeta o rendimento escolar, sem interferências na qualidade do sono',
       'Pode interferir em rotinas adequadas de descanso e aumentar a exposição contínua a estímulos e comparações sociais',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-015', c.id, 3, 'Rodas de conversa mediadas por psicólogos contribuem para a saúde mental de jovens porque:',
       'Não têm nenhuma utilidade prática comprovada',
       'Criam ambientes de confiança nos quais dificuldades emocionais podem ser expressas e identificadas precocemente',
       'Substituem completamente o acompanhamento clínico de um médico em qualquer situação',
       'Servem apenas como atividade recreativa, sem propósito terapêutico pois é um momento descontraído e leve',
       'Só devem ser feitas quando já existe um diagnóstico prévio, antes disso as rodas de conversas não surtem o efeito esperado',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-016', c.id, 3, 'A diferença entre tristeza passageira e depressão está principalmente:',
       'No fato de a tristeza passageira ser sempre mais intensa, apesar da depressão ser mais duradoura',
       'Não existe diferença relevante entre as duas situações, sendo apenas nomes diferentes dadas para a mesma situação',
       'A depressão é exclusivamente genética e a tristeza passageira é causada por fatores sociais',
       'Na duração dos sintomas e no impacto funcional que causam na vida cotidiana da pessoa',
       'No fato de a depressão durar só algumas horas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-017', c.id, 3, 'O bullying pode gerar consequências duradouras tanto para quem sofre quanto para quem pratica porque:',
       'Está associado a sofrimento emocional na vítima e ao reforço de padrões de comportamento agressivo em quem pratica',
       'Não gera nenhum impacto emocional mensurável para nenhuma das partes',
       'Afeta exclusivamente o emocional da vítima, sem alterações no convívio social, reforçando ser um transtorno mental de quem é oprimido',
       'É sempre interpretado apenas como brincadeira, sem consequências reais',
       'Só afeta quem pratica, nunca a vítima',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-018', c.id, 3, 'Qual é a diferença entre integração e inclusão no contexto escolar?',
       'São exatamente a mesma coisa',
       'Integração é sempre melhor que inclusão, pois acolhe mais indivíduos com condições especiais',
       'Na inclusão, o ambiente se adapta para acolher os estudantes, enquanto na integração espera-se que o estudante se adapte ao ambiente',
       'Inclusão só se aplica a adultos que convivem com algum tipo de condição dentro do ambiente de trabalho',
       'Integração não existe na educação',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-019', c.id, 3, 'A hemofilia e o daltonismo são exemplos de herança recessiva ligada ao X porque:',
       'São mais frequentes em mulheres, que possuem dois cromossomos X',
       'Afetam igualmente homens e mulheres, sem nenhuma diferença de frequência',
       'Não têm relação alguma com os cromossomos sexuais',
       'São mais frequentes em homens, já que eles possuem apenas um cromossomo X',
       'Só ocorrem em mulheres, pois elas possuem dois cromossomos X e são portadoras obrigatórias',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-020', c.id, 3, 'Uma reação de hipersensibilidade (alergia) ocorre quando:',
       'O sistema imunológico está completamente inativo',
       'Não há nenhuma participação do sistema imunológico no processo',
       'A reação é causada exclusivamente por bactérias',
       'O sistema imunológico reage de forma exagerada a uma substância geralmente inofensiva ao organismo',
       'O sistema nervoso age no lugar do sistema imunológico, criando uma reação àquela substância',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-021', c.id, 3, 'A resistência bacteriana adquirida se diferencia da natural porque:',
       'Surge com uso de antibióticos ao longo do tempo de forma errada',
       'Está sempre presente desde a origem da espécie bacteriana, como a natural',
       'Não guarda nenhuma relação com o uso de antibióticos',
       'Ocorre exclusivamente em vírus, e não em bactérias',
       'É transmitida por herança genética humana, afetando um par de alelos',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-022', c.id, 3, 'A exposição prolongada a substâncias químicas ou esforços repetitivos no trabalho pode provocar:',
       'Nenhum efeito mensurável à saúde do trabalhador',
       'Apenas desconforto passageiro, sem qualquer consequência a longo prazo',
       'Doenças ocupacionais crônicas, como intoxicações ou lesões por esforço repetitivo',
       'Melhora progressiva da saúde física, substituindo exercícios diários e atividades físicas',
       'Fortalecimento muscular sem riscos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'ESCOLA-N3-023', c.id, 3, 'A manifestação de doenças autoimunes e metabólicas costuma envolver:',
       'Exclusivamente fatores genéticos, sem qualquer influência do ambiente',
       'Exclusivamente fatores ambientais, sem qualquer predisposição genética',
       'Nenhum fator de risco identificável até o momento',
       'Apenas fatores hormonais isolados, sem relação genética ou ambiental',
       'A interação entre fatores genéticos e fatores ambientais como os hábitos',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- FARMACIA-N1 — 16 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-002', c.id, 1, 'O que podemos encontrar e fazer em uma farmácia?',
       'É um lugar onde podemos encontrar medicamentos/vacinas e receber orientações sobre seu uso com o farmacêutico.',
       'É um lugar onde qualquer pessoa pode pegar e tomar qualquer medicamento que quiser.',
       'É um lugar que podemos ir se não é possível ir na UBS',
       'É um lugar onde os medicamentos são vendidos sem nenhum cuidado ou orientação.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-003', c.id, 1, 'A mãe de Lucas chega à farmácia com dúvidas sobre como deve tomar um medicamento que foi prescrito para ela. O que o farmacêutico pode fazer?',
       'Dizer que medicamentos não precisam de orientação',
       'Mandar a pessoa tomar uma quantidade maior, mesmo sem saber qual foi a prescrição',
       'Trocar qualquer medicamento por outro sem considerar a prescrição',
       'Orientar sobre o uso correto do medicamento e esclarecer dúvidas relacionadas ao tratamento',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-004', c.id, 1, 'O que o farmacêutico pode fazer para ajudar as pessoas?',
       'Realizar prescrição de medicamentos mesmo não sendo médico',
       'Orientar sobre o uso correto de medicamentos',
       'Realizar exames e consulta de rotina',
       'Aplicar vacinas sem certificado de formação complementar',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-005', c.id, 1, 'Pedro quer comprar um medicamento na farmácia porque viu uma propaganda dizendo que ele pode curar rapidamente uma doença. O que seria mais seguro fazer?',
       'Comprar imediatamente porque a propaganda disse que funciona.',
       'Comprar vários medicamentos para garantir que um deles funcione.',
       'Conversar com um adulto e buscar orientação de um profissional de saúde antes de usar o medicamento.',
       'Tomar o medicamento de um amigo que teve sintomas parecidos.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-006', c.id, 1, 'O farmacêutico pode fazer tudo o que um médico faz?',
       'Sim. Todos os profissionais de saúde têm exatamente as mesmas funções.',
       'Não. Cada profissional possui suas próprias responsabilidades e limites de atuação.',
       'Sim, porque o farmacêutico pode realizar qualquer procedimento médico.',
       'Não, porque o farmacêutico não pode orientar ninguém sobre medicamentos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-007', c.id, 1, 'Por que é importante conversar com o farmacêutico antes de usar um medicamento quando temos dúvidas?',
       'Porque ele pode ajudar a explicar como usar o medicamento corretamente, além de orientar sobre cuidados relacionados ao seu uso, dentro de sua área de atuação.',
       'Porque o farmacêutico pode escolher qualquer medicamento para qualquer pessoa sem avaliação.',
       'Porque depois de conversar com o farmacêutico não precisamos mais procurar outros profissionais de saúde.',
       'Porque o farmacêutico pode substituir a prescrição médica em qualquer situação.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-008', c.id, 1, 'Ana está tomando medicamentos para melhorar sua saúde. Qual destas atitudes Ana deve ter para realizar o uso correto de medicamentos?',
       'Usar o medicamento correto, na quantidade e pelo tempo indicados para o tratamento.',
       'Tomar medicamentos sempre que alguém estiver doente, mesmo sem orientação.',
       'Parar o tratamento assim que a pessoa se sentir um pouco melhor.',
       'Compartilhar medicamentos com familiares e amigos.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-009', c.id, 1, 'A professora de Pedro disse que ele deveria tomar um medicamento que ajudou muito sua colega quando ela estava doente. O que Pedro deve fazer?',
       'Tomar o mesmo medicamento, pois ele funcionou para sua colega.',
       'Tomar uma quantidade maior para melhorar mais rápido.',
       'Pedir orientação a um adulto e a um profissional de saúde antes de usar qualquer medicamento.',
       'Misturar o medicamento com outro para aumentar seu efeito.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-010', c.id, 1, 'O uso nas doses e intervalos corretos garante que o medicamento funcione da forma planejada e segura.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-011', c.id, 1, 'Antibióticos e outros medicamentos controlados não exigem prescrição médica e dispensação orientada na farmácia.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-012', c.id, 1, 'A distribuição gratuita e organizada de medicamentos na Atenção Primária faz parte da assistência farmacêutica do SUS.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-013', c.id, 1, 'Por que é perigoso tomar um remédio por conta própria ou por conselho de um vizinho (automedicação)?',
       'Porque todos os remédios são iguais e não fazem efeito.',
       'Porque pode causar reações ruins ou intoxicação no nosso corpo ao usar o remédio errado.',
       'Porque o remédio sempre funciona melhor sem receita.',
       'Porque tomar remédio sem orientação não traz nenhum risco.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-014', c.id, 1, 'Se a febre ou a dor passarem, você pode parar o tratamento com antibiótico antes do prazo final indicado pelo médico.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-015', c.id, 1, 'Tomar o remédio no horário certinho e na quantidade que o médico marcou ajuda o corpo a se curar com segurança.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-016', c.id, 1, 'Se o médico receitar um antibiótico por 7 dias e você se sentir melhor no 3º dia, qual é a atitude correta?',
       'Parar de tomar o remédio imediatamente e guardar o restante.',
       'Continuar tomando o remédio até completar os 7 dias exatos orientados pelo médico.',
       'Dobrar a quantidade do remédio para sarar mais rápido.',
       'Dar o restante do remédio para um amigo que está doente.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N1-017', c.id, 1, 'Qual é o papel principal da farmácia e dos remédios na Unidade Básica de Saúde (SUS)?',
       'Vender doces e brinquedos para os pacientes.',
       'Garantir a distribuição de remédios essenciais e orientar sobre como usá-los com segurança.',
       'Substituir a necessidade de ir ao médico ou fazer exames.',
       'Dizer que as pessoas podem tomar qualquer remédio sem receita.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- FARMACIA-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-001', c.id, 2, 'O que significa automedicação?',
       'Tomar medicamento exatamente como orientado.',
       'Utilizar medicamentos por conta própria, sem orientação adequada.',
       'Guardar medicamentos em local apropriado.',
       'Conferir a validade antes de utilizá-los.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-002', c.id, 2, 'Por que medicamentos devem ser utilizados com cuidado?',
       'Porque nenhum medicamento produz efeitos no organismo.',
       'Porque medicamentos servem apenas para adultos.',
       'Porque seu uso inadequado pode trazer riscos à saúde.',
       'Porque todos possuem exatamente a mesma função.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-003', c.id, 2, 'Um amigo oferece um antibiótico que “funcionou para ele”. A atitude mais segura é:',
       'tomar metade da dose dele.',
       'usar apenas por um dia.',
       'tomar se os sintomas forem parecidos.',
       'não utilizar o medicamento dessa forma e buscar orientação adequada.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-004', c.id, 2, 'Respeitar os horários de um medicamento é importante porque:',
       'medicamentos funcionam apenas durante o dia.',
       'o tratamento deve seguir a orientação recebida para ser utilizado corretamente.',
       'qualquer atraso torna o medicamento venenoso.',
       'horários só são importantes para vitaminas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-005', c.id, 2, 'Qual prática representa uso responsável de medicamentos?',
       'Aumentar a dose para melhorar mais rápido.',
       'Compartilhar remédios com familiares.',
       'Seguir as orientações dos profissionais de saúde.',
       'Interromper qualquer tratamento ao primeiro sinal de melhora.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-006', c.id, 2, 'A farmácia pode participar da promoção da saúde por meio:',
       'somente da venda de produtos.',
       'apenas da comercialização de cosméticos.',
       'de orientações e participação em campanhas de saúde.',
       'da substituição de todos os demais serviços do SUS.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-007', c.id, 2, 'As vacinas têm como principal objetivo:',
       'substituir hábitos de higiene.',
       'contribuir para a prevenção de determinadas doenças.',
       'tratar qualquer infecção já instalada.',
       'eliminar a necessidade de acompanhamento de saúde.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-008', c.id, 2, 'Por que não devemos alterar a dose de um medicamento por conta própria?',
       'Porque doses maiores sempre anulam o medicamento.',
       'Porque doses menores são sempre mais eficientes.',
       'Porque a dose faz parte da orientação para o uso seguro do tratamento.',
       'Porque todos os medicamentos possuem uma única dose possível.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-009', c.id, 2, 'Qual atitude apresenta maior risco?',
       'Seguir a orientação recebida.',
       'Conferir como o medicamento deve ser usado.',
       'Respeitar os horários estabelecidos.',
       'Utilizar o medicamento indicado para outra pessoa.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-010', c.id, 2, 'Manter as vacinas em dia é importante:',
       'apenas quando a pessoa está doente.',
       'somente durante a primeira infância.',
       'como parte das medidas de prevenção de doenças.',
       'apenas antes de viagens internacionais.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-011', c.id, 2, 'Um medicamento capaz de ajudar uma pessoa:',
       'necessariamente ajudará qualquer outra pessoa.',
       'pode não ser apropriado para outra situação ou pessoa.',
       'pode sempre ser compartilhado entre familiares.',
       'pode ser utilizado sem considerar a dose.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-012', c.id, 2, 'Qual situação representa prevenção?',
       'Aumentar uma dose sem orientação.',
       'Utilizar medicamento de outra pessoa.',
       'Manter a vacinação recomendada atualizada.',
       'Misturar diferentes medicamentos por conta própria.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-013', c.id, 2, 'Medicamentos e vacinas são iguais?',
       'Sim, pois ambos possuem exatamente a mesma função.',
       'Não; são recursos de saúde que podem ter finalidades diferentes.',
       'Sim, pois ambos servem apenas para tratar doenças.',
       'Não, porque vacinas não possuem relação com prevenção.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-014', c.id, 2, 'A frase “se vende na farmácia, posso usar sem cuidado” está:',
       'correta para qualquer produto.',
       'correta apenas para adolescentes.',
       'incorreta, pois produtos de saúde também exigem uso responsável.',
       'correta se outra pessoa já tiver usado.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N2-015', c.id, 2, 'Qual princípio resume melhor o cenário Farmácia?',
       'Quanto mais medicamentos, melhor a saúde.',
       'Medicamentos substituem medidas preventivas.',
       'Medicamentos podem ser úteis, mas seu uso precisa ser seguro e orientado.',
       'Todo problema de saúde pode ser resolvido com remédios.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- FARMACIA-N3 — 9 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-001', c.id, 3, 'Por que, mesmo com vacina eficaz e disponível, ainda ocorrem surtos de febre amarela em determinadas regiões do Brasil?',
       'Cobertura vacinal insuficiente em algumas áreas',
       'A vacina deixou de existir',
       'A doença não depende mais de vetores',
       'A vacina provoca a doença em quem a recebe',
       'Necessidade de uma vacina mais eficaz',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-002', c.id, 3, 'As vacinas de RNA mensageiro (como as usadas contra a covid-19) agem por meio de:',
       'Injetar o vírus vivo diretamente na corrente sanguínea para ter contato com o sistema imune',
       'Instruir células do próprio corpo a produzir temporariamente uma proteína viral, estimulando resposta imune sem causar a doença',
       'Eliminar diretamente o vírus presente no ambiente',
       'Não têm nenhum mecanismo de ação comprovado',
       'Alterar permanentemente o DNA das células humanas, para que acrescentem uma proteína que deixem a pessoa totalmente imune',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-003', c.id, 3, 'A erradicação da circulação do vírus selvagem da poliomielite no Brasil dependeu, sobretudo, de:',
       'Décadas de cobertura vacinal ampla e sustentada na população infantil',
       'Melhorias exclusivas no tratamento de pacientes já paralisados',
       'Uso de antibióticos em larga escala para acabar com os casos',
       'Isolamento geográfico do país',
       'Uma mutação natural que enfraqueceu o vírus durante seu ciclo de vida',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-004', c.id, 3, 'O período de incubação da raiva, que pode durar dias a meses, é importante porque:',
       'Torna inútil qualquer vacinação após a exposição pois a doença some por conta própria',
       'Permite que a vacinação pós-exposição, aplicada logo após a mordida, ainda seja capaz de gerar imunidade a tempo de evitar a doença',
       'Significa que a doença nunca é fatal, o indivíduo não terá a doença manifestada',
       'Elimina a necessidade de atendimento médico após mordidas suspeitas',
       'Faz com que a vacina só funcione antes da mordida, perdendo seu efeito após o contato direto com a raiva.',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-005', c.id, 3, 'A imunidade de rebanho, buscada em campanhas de vacinação contra o sarampo, depende de:',
       'Apenas um pequeno grupo de pessoas vacinadas',
       'Vacinação exclusiva de idosos',
       'Nenhuma relação com a cobertura vacinal populacional',
       'Vacinação apenas de quem já teve a doença',
       'Uma alta proporção de pessoas vacinadas na população',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-006', c.id, 3, 'A necessidade de atualização anual da vacina contra a gripe se deve a:',
       'O vírus da gripe nunca sofrer mutações',
       'A vacina perder efeito por motivos não relacionados ao vírus',
       'Mutações frequentes no vírus influenza, que alteram os subtipos circulantes a cada temporada',
       'Não haver diferença nenhuma entre os vírus da gripe e do sarampo, outras vacinas também imunizam contra a gripe',
       'A gripe deixar de existir a cada ano, surgindo uma nova gripe anualmente',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-007', c.id, 3, 'O surgimento de "superbactérias" está diretamente relacionado a:',
       'Uso correto e criterioso de antibióticos',
       'Uso inadequado e excessivo de antibióticos, que favorece, por seleção natural, a sobrevivência de bactérias resistentes',
       'Ausência total de uso de antibióticos na população',
       'Fatores genéticos humanos, sem relação com o uso de medicamentos',
       'Vacinação em massa contra bactérias comuns, favorecendo o ambiente para as superbactérias',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-008', c.id, 3, 'Antibióticos não têm efeito contra infecções virais porque:',
       'Vírus e bactérias possuem estrutura celular idêntica',
       'Antibióticos eliminam qualquer tipo de patógeno, incluindo vírus',
       'Atuam sobre estruturas e processos típicos de células bacterianas, ausentes nos vírus',
       'Não existe diferença biológica entre vírus e bactérias',
       'Os vírus produzem suas próprias enzimas de defesa contra antibióticos',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'FARMACIA-N3-009', c.id, 3, 'Um programa de vacinação contra o HPV visando reduzir o câncer de colo do útero décadas depois ilustra o princípio de:',
       'Prevenção terciária, voltada ao tratamento de doenças já instaladas',
       'Diagnóstico tardio de doenças',
       'Uma medida sem relação com a prevenção de câncer',
       'Prevenção secundária, feita após o diagnóstico',
       'Prevenção primária, evitando a infecção antes da exposição ao vírus',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- MERCADO-N3 — 1 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'MERCADO-N3-011', c.id, 3, 'Surtos de Salmonelose associados a grandes eventos costumam estar relacionados principalmente a:',
       'Falhas na manipulação, conservação ou cocção inadequada de alimentos',
       'Exposição prolongada ao ar livre de alimentos crus',
       'Contato com plantas ornamentais, normalmente levados por animais domésticos',
       'Uso de vacinas com prazo vencido',
       'Consumo de água engarrafada',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- PARQUE-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-024', c.id, 2, 'Um parque pode contribuir para a saúde ao:',
       'substituir todos os serviços de saúde.',
       'oferecer espaço para movimento, lazer e contato com a natureza.',
       'impedir qualquer doença respiratória.',
       'eliminar a necessidade de convivência social.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-025', c.id, 2, 'Preservar áreas verdes é importante:',
       'somente para deixar a cidade bonita.',
       'para o ambiente e para a qualidade dos espaços comunitários.',
       'exclusivamente para os animais.',
       'apenas para pessoas que praticam esportes.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-026', c.id, 2, 'Separar corretamente o lixo ajuda:',
       'a aumentar o descarte inadequado.',
       'no cuidado com o ambiente e com a comunidade.',
       'somente na aparência das lixeiras.',
       'a eliminar a necessidade de coleta.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-027', c.id, 2, 'Caminhar em um parque é uma forma de:',
       'permanecer sedentário.',
       'realizar atividade física.',
       'substituir o sono.',
       'tratar qualquer doença.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-028', c.id, 2, 'O contato com espaços agradáveis pode contribuir:',
       'exclusivamente para a força muscular.',
       'para o bem-estar.',
       'somente para a digestão.',
       'apenas para a visão.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-029', c.id, 2, 'Jogar resíduos no chão pode:',
       'melhorar o ambiente natural.',
       'aumentar a segurança do espaço.',
       'prejudicar o ambiente e a qualidade do espaço coletivo.',
       'acelerar a decomposição de qualquer material.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-030', c.id, 2, 'Qual atitude demonstra cidadania ambiental?',
       'Abandonar embalagens durante uma caminhada.',
       'Danificar plantas do parque.',
       'Ignorar as regras de descarte.',
       'Utilizar as lixeiras e preservar as áreas verdes.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-031', c.id, 2, 'Um parque limpo beneficia:',
       'somente quem pratica corrida.',
       'exclusivamente os funcionários.',
       'a comunidade e o ambiente.',
       'apenas os animais que vivem nele.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-032', c.id, 2, 'Saúde ambiental significa reconhecer que:',
       'natureza e seres humanos não se relacionam.',
       'as condições do ambiente podem influenciar a saúde e o bem-estar.',
       'somente hospitais determinam a saúde coletiva.',
       'poluição é apenas um problema estético.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-033', c.id, 2, 'Qual atividade combina saúde física e ambiental?',
       'Caminhar enquanto descarta embalagens no chão.',
       'Fazer uma caminhada e descartar os resíduos corretamente.',
       'Correr e danificar a vegetação.',
       'Praticar esportes em áreas proibidas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-034', c.id, 2, 'Por que espaços públicos precisam ser cuidados coletivamente?',
       'Porque pertencem apenas aos profissionais de saúde.',
       'Porque são compartilhados e seu estado pode afetar muitas pessoas.',
       'Porque somente crianças utilizam esses espaços.',
       'Porque limpeza não possui relação com saúde.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-035', c.id, 2, 'Áreas verdes podem incentivar atividade física porque:',
       'obrigam todas as pessoas a correr.',
       'oferecem espaços onde atividades como caminhadas podem ser realizadas.',
       'eliminam a necessidade de descanso.',
       'substituem instalações esportivas em qualquer situação.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-036', c.id, 2, 'Um parque com lixo acumulado apresenta:',
       'somente um problema visual.',
       'um problema ambiental que também pode interferir no uso saudável do espaço.',
       'necessariamente uma epidemia.',
       'um ambiente mais adequado aos visitantes.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-037', c.id, 2, 'O cuidado com parques relaciona:',
       'somente botânica e decoração.',
       'apenas atividade física.',
       'meio ambiente, saúde e cidadania.',
       'exclusivamente coleta seletiva.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PARQUE-N2-038', c.id, 2, 'Qual frase resume melhor o cenário?',
       'Saúde depende apenas do que acontece dentro do corpo.',
       'Natureza e saúde são temas sem relação.',
       'Cuidar dos espaços verdes também é cuidar da qualidade de vida da comunidade.',
       'Parques possuem importância apenas para o lazer.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- PRACA-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-004', c.id, 2, 'Uma pracinha pode promover saúde porque:',
       'serve apenas para descanso.',
       'favorece movimento, convivência e atividades comunitárias.',
       'substitui unidades de saúde.',
       'impede doenças infecciosas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-005', c.id, 2, 'Em um dia muito quente, é importante:',
       'evitar qualquer ingestão de água.',
       'permanecer ao sol pelo maior tempo possível.',
       'manter hidratação e cuidados com a exposição ao calor.',
       'utilizar roupas pesadas para aumentar a transpiração.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-006', c.id, 2, 'A transpiração participa principalmente:',
       'da produção de oxigênio.',
       'dos mecanismos de regulação da temperatura corporal.',
       'da digestão dos alimentos.',
       'da formação dos ossos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-007', c.id, 2, 'Por que beber água é especialmente importante durante atividades em dias quentes?',
       'Porque água impede completamente a transpiração.',
       'Porque o organismo perde água, inclusive pela transpiração.',
       'Porque água reduz permanentemente a temperatura do ambiente.',
       'Porque o corpo deixa de produzir calor.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-008', c.id, 2, 'Exposição excessiva ao calor pode:',
       'ser sempre benéfica ao organismo.',
       'provocar mal-estar e representar risco à saúde.',
       'substituir atividades físicas.',
       'impedir a perda de água corporal.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-009', c.id, 2, 'Qual atitude ajuda na proteção durante exposição ao sol?',
       'Evitar qualquer hidratação.',
       'Permanecer exposto ao calor intenso por muitas horas.',
       'Adotar medidas de proteção contra o sol e evitar exposição excessiva.',
       'Fazer exercícios somente nos horários mais quentes.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-010', c.id, 2, 'Conversar e participar de atividades comunitárias pode contribuir:',
       'somente para a força muscular.',
       'exclusivamente para a pressão arterial.',
       'para aspectos sociais e emocionais da saúde.',
       'apenas para a digestão.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-011', c.id, 2, 'Qual órgão atua como importante barreira entre o corpo e o ambiente?',
       'Estômago.',
       'Coração.',
       'Pele.',
       'Pâncreas.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-012', c.id, 2, 'Atividade física ao ar livre exige atenção:',
       'somente à velocidade do exercício.',
       'às condições ambientais e aos sinais do corpo.',
       'apenas à roupa utilizada.',
       'exclusivamente ao tempo total de atividade.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-013', c.id, 2, 'Saúde comunitária aparece na pracinha quando:',
       'apenas uma pessoa utiliza o espaço.',
       'o local recebe atividades e ações voltadas à população.',
       'atividades sociais são proibidas.',
       'o espaço é utilizado somente para exercícios intensos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-014', c.id, 2, 'Se alguém apresenta mal-estar durante atividade sob calor intenso, o mais adequado é:',
       'incentivar a pessoa a continuar.',
       'ignorar porque é sempre normal.',
       'interromper a atividade e procurar ajuda adequada.',
       'impedir que a pessoa beba água.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-015', c.id, 2, 'Qual situação combina promoção da saúde física e social?',
       'Permanecer isolado e imóvel durante todo o dia.',
       'Participar de uma caminhada comunitária adequada e segura.',
       'Praticar atividade intensa sem descanso no calor.',
       'Evitar qualquer contato com outras pessoas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-016', c.id, 2, 'A sensação de sede:',
       'significa que o corpo não precisa de água.',
       'ocorre apenas durante doenças.',
       'pode indicar necessidade de reposição de líquidos.',
       'deve sempre ser ignorada durante exercícios.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-017', c.id, 2, 'Por que evitar longos períodos sob calor intenso?',
       'Porque o corpo não produz calor.',
       'Porque o organismo precisa manter sua temperatura dentro de limites adequados.',
       'Porque a pele deixa de funcionar ao sol.',
       'Porque qualquer exposição provoca doença.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'PRACA-N2-018', c.id, 2, 'O cenário Pracinha demonstra que promoção da saúde:',
       'ocorre apenas em hospitais.',
       'também pode acontecer nos espaços públicos da comunidade.',
       'depende exclusivamente de medicamentos.',
       'é responsabilidade somente dos profissionais de saúde.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- QUADRA-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-004', c.id, 2, 'A atividade física pode contribuir para:',
       'apenas o crescimento dos cabelos.',
       'a saúde de músculos, ossos e sistema cardiovascular.',
       'somente a saúde digestiva.',
       'exclusivamente a capacidade de estudar.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-005', c.id, 2, 'Durante uma corrida, o coração geralmente:',
       'deixa de bombear sangue aos músculos.',
       'trabalha para atender ao aumento das demandas do organismo.',
       'interrompe temporariamente seus batimentos.',
       'envia sangue exclusivamente aos pulmões.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-006', c.id, 2, 'Praticar esportes em grupo também pode beneficiar:',
       'apenas a musculatura.',
       'exclusivamente os ossos.',
       'a convivência e a saúde social.',
       'somente o sistema respiratório.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-007', c.id, 2, 'Por que a respiração costuma ficar mais rápida durante exercícios?',
       'Porque o pulmão deixa de funcionar normalmente.',
       'Porque o organismo aumenta suas demandas durante a atividade.',
       'Porque o sangue para de circular temporariamente.',
       'Porque os músculos deixam de utilizar energia.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-008', c.id, 2, 'Qual atitude é adequada durante atividades físicas?',
       'Ignorar qualquer sinal de mal-estar.',
       'Evitar beber água durante todo o dia.',
       'Respeitar os limites do corpo e manter cuidados adequados.',
       'Exercitar-se apenas em intensidade máxima.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-009', c.id, 2, 'Ossos e músculos:',
       'não participam dos movimentos corporais.',
       'atuam em conjunto na realização de movimentos.',
       'possuem exatamente a mesma estrutura.',
       'funcionam sem participação do sistema nervoso.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-010', c.id, 2, 'A prática regular de atividades físicas:',
       'garante que uma pessoa nunca fique doente.',
       'é um dos fatores que podem contribuir para uma vida saudável.',
       'substitui alimentação e sono adequados.',
       'precisa ser sempre competitiva.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-011', c.id, 2, 'Qual sistema transporta oxigênio e nutrientes pelo corpo?',
       'Sistema tegumentar.',
       'Sistema digestório isoladamente.',
       'Sistema cardiovascular.',
       'Sistema esquelético.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-012', c.id, 2, 'Uma partida esportiva envolve diferentes sistemas corporais. Isso demonstra que:',
       'cada sistema funciona completamente isolado.',
       'os sistemas do organismo trabalham de maneira integrada.',
       'somente os músculos são necessários para movimentos.',
       'o coração não participa do exercício físico.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-013', c.id, 2, 'Além de benefícios físicos, movimentar-se pode:',
       'impedir qualquer emoção negativa.',
       'contribuir para o bem-estar e o humor.',
       'substituir o convívio social.',
       'eliminar a necessidade de descanso.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-014', c.id, 2, 'O que acontece com os músculos durante muitos movimentos?',
       'Permanecem completamente imóveis.',
       'Realizam contrações que contribuem para o movimento.',
       'Transformam-se temporariamente em ossos.',
       'deixam de receber sangue.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-015', c.id, 2, 'Um adolescente passa a maior parte do tempo sentado. Uma mudança saudável seria:',
       'abandonar todas as atividades escolares.',
       'praticar exercício intenso sem preparação.',
       'incorporar mais movimento e atividades adequadas à rotina.',
       'dormir menos para ter tempo de se exercitar.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-016', c.id, 2, 'Por que atividades coletivas podem beneficiar a saúde social?',
       'Porque impedem qualquer conflito entre pessoas.',
       'Porque podem favorecer interação, cooperação e convivência.',
       'Porque eliminam a necessidade de comunicação.',
       'Porque saúde social depende somente de esportes.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-017', c.id, 2, 'Qual afirmação é mais adequada?',
       'Apenas esportes competitivos contam como atividade física.',
       'Exercício beneficia somente quem quer competir.',
       'Diferentes formas de movimento podem contribuir para a saúde.',
       'Atividade física é importante somente na idade adulta.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'QUADRA-N2-018', c.id, 2, 'Corpo, mente e convivência aparecem juntos nesse cenário porque:',
       'somente o exercício determina a saúde.',
       'a saúde possui diferentes dimensões que se relacionam.',
       'emoções são produzidas exclusivamente pelos músculos.',
       'convivência não interfere no bem-estar.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- TERRENOBALDIO-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-001', c.id, 2, 'Um terreno baldio cheio de lixo pode:',
       'melhorar o equilíbrio ambiental.',
       'favorecer riscos ambientais e à saúde.',
       'impedir a presença de animais.',
       'funcionar como local adequado de descarte.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-002', c.id, 2, 'Recipientes abandonados podem representar risco quando:',
       'permanecem completamente secos.',
       'acumulam água e favorecem alguns vetores.',
       'são reciclados adequadamente.',
       'recebem destinação correta.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-003', c.id, 2, 'O descarte correto do lixo ajuda:',
       'somente na aparência do bairro.',
       'exclusivamente na reciclagem.',
       'na prevenção de problemas ambientais e de saúde.',
       'apenas na conservação das ruas.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-004', c.id, 2, 'O termo “vetor”, no contexto de doenças, refere-se:',
       'necessariamente ao microrganismo causador da doença.',
       'a um organismo capaz de participar da transmissão de um agente infeccioso.',
       'a qualquer objeto encontrado no lixo.',
       'somente a bactérias presentes na água.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-005', c.id, 2, 'Qual situação merece atenção em um terreno?',
       'Área limpa e conservada.',
       'Resíduos recolhidos adequadamente.',
       'Pneus e recipientes acumulando água.',
       'Lixeiras utilizadas corretamente.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-006', c.id, 2, 'A limpeza de terrenos pode ajudar na prevenção de doenças porque:',
       'elimina todas as espécies de insetos.',
       'reduz algumas condições favoráveis a vetores e outros riscos.',
       'substitui completamente o saneamento básico.',
       'impede qualquer microrganismo de existir.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-007', c.id, 2, 'Qual atitude é inadequada?',
       'Utilizar a coleta de resíduos disponível.',
       'Manter recipientes sem água acumulada.',
       'Participar do cuidado dos espaços comunitários.',
       'Descartar entulho em um terreno vazio.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-008', c.id, 2, 'Lixo acumulado também pode aumentar:',
       'apenas o número de árvores.',
       'o risco de acidentes no ambiente.',
       'exclusivamente a umidade do ar.',
       'a segurança dos moradores.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-009', c.id, 2, 'Por que um terreno particular mal cuidado pode se tornar questão de saúde coletiva?',
       'Porque tudo que ocorre em propriedade privada afeta toda a cidade.',
       'Porque certos riscos ambientais podem atingir pessoas da comunidade.',
       'Porque saúde coletiva trata somente de terrenos.',
       'Porque qualquer terreno vazio transmite doenças.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-010', c.id, 2, 'Qual combinação representa maior risco?',
       'Solo limpo + resíduos coletados.',
       'Reciclagem + destinação correta.',
       'Lixo acumulado + recipientes com água parada.',
       'Limpeza + eliminação de criadouros.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-011', c.id, 2, 'Um grupo limpa um terreno, mas deixa vários recipientes capazes de acumular chuva. O problema foi totalmente resolvido?',
       'Sim, porque somente lixo orgânico apresenta riscos.',
       'Sim, porque água da chuva é sempre segura.',
       'Não, pois ainda existem possíveis locais de acúmulo de água.',
       'Não, porque terrenos nunca podem permanecer vazios.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-012', c.id, 2, 'A prevenção de doenças transmitidas por vetores pode envolver:',
       'somente o tratamento das pessoas doentes.',
       'mudanças ambientais que reduzam locais favoráveis aos vetores.',
       'apenas o fechamento das escolas.',
       'exclusivamente o uso de medicamentos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-013', c.id, 2, 'O cuidado com terrenos baldios mostra que:',
       'saúde depende somente de decisões individuais.',
       'ambiente e saúde são independentes.',
       'ações comunitárias e ambientais também interferem na saúde.',
       'prevenção ocorre apenas dentro das UBS.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-014', c.id, 2, 'Um recipiente pequeno com água merece atenção?',
       'Não, porque vetores utilizam apenas grandes lagos.',
       'Sim, porque alguns vetores podem utilizar pequenos acúmulos de água.',
       'Não, se estiver localizado longe de uma casa.',
       'Sim, porque qualquer água parada contém obrigatoriamente doenças.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'TERRENOBALDIO-N2-015', c.id, 2, 'Qual seria a melhor estratégia preventiva?',
       'Retirar apenas resíduos visualmente grandes.',
       'Aplicar medicamentos nos moradores.',
       'Manter o local limpo e eliminar possíveis acúmulos de água.',
       'Esperar aparecerem casos de doenças para agir.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UBS-N1 — 14 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-003', c.id, 1, 'Você sabe o que é uma Unidade Básica de Saúde (UBS), comumente chamada de Posto de saúde?',
       'Um lugar onde as pessoas vão apenas para fazer exames.',
       'Um serviço de saúde que ajuda a cuidar da saúde das pessoas e da comunidade.',
       'Um lugar onde as pessoas aprendem sobre medicina.',
       'Um lugar onde somente pessoas muito doentes podem entrar.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-004', c.id, 1, 'Por que uma Unidade Básica de Saúde (UBS) é importante para a comunidade?',
       'Porque a UBS serve apenas para atender pessoas quando elas estão muito doentes.',
       'Porque na UBS só trabalham médicos e eles não precisam conversar com os pacientes.',
       'Porque a UBS existe somente para dar remédios às pessoas.',
       'Porque a UBS ajuda as pessoas a cuidar da saúde, prevenir doenças e receber orientações com profissionais de saúde.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-005', c.id, 1, 'Ana tem dúvidas sobre sua saúde e sua mãe explica que a UBS é um ótimo lugar para receber orientações de saúde. Você sabe por que é importante conversar com os profissionais da UBS?',
       'Porque conversar substitui todos os tratamentos médicos.',
       'Porque os profissionais precisam saber tudo sobre a vida das pessoas.',
       'Porque conversar ajuda a entender melhor como cuidar da saúde e tirar dúvidas.',
       'Porque somente quem conversa pode receber atendimento.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-006', c.id, 1, 'Na UBS, diferentes profissionais de saúde trabalham juntos para cuidar das pessoas da comunidade. Por que é importante ter vários profissionais trabalhando na UBS?',
       'Porque cada profissional pode contribuir com seus conhecimentos e ajudar em diferentes necessidades de saúde.',
       'Porque todos os profissionais fazem exatamente o mesmo trabalho.',
       'Porque somente um profissional pode cuidar de cada pessoa por vez.',
       'Porque quanto mais profissionais houver, menos as pessoas precisam conversar sobre sua saúde.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-007', c.id, 1, 'Por que ouvir as pessoas é importante para a UBS?',
       'Porque as pessoas podem contar suas dúvidas, necessidades e dificuldades.',
       'Porque os profissionais não precisam estudar quando ouvem a comunidade.',
       'Porque somente os moradores podem decidir os tratamentos médicos.',
       'Porque ouvir as pessoas evita que os profissionais trabalhem.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-008', c.id, 1, 'Qual dessas atitudes ajuda a criar confiança entre a comunidade e os profissionais da UBS?',
       'Não ouvir as pessoas, pois elas não sabem nada de saúde.',
       'Tratar as pessoas com respeito e conversar com elas.',
       'Evitar explicar os cuidados de saúde.',
       'Fazer tudo sem perguntar ou ouvir ninguém.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-009', c.id, 1, 'Caio tem medo de ir à UBS porque acha que ninguém vai ouvi-lo. A equipe começa a conversar com ele com atenção, explica o que está acontecendo e responde às suas perguntas. O que pode acontecer com Caio?',
       'Ele não poderá mais fazer perguntas.',
       'Ele nunca mais precisará cuidar da saúde.',
       'Ele ficará doente por conversar com os profissionais.',
       'Ele pode passar a confiar mais nos profissionais.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-010', c.id, 1, 'João conta para a equipe da UBS que muitas crianças estão tendo dificuldade para entender como evitar algumas doenças. O que a equipe pode fazer?',
       'Ignorar o problema, pois entender como evitar doenças não resolve nada.',
       'Dizer que somente os médicos sabem o que fazer.',
       'Conversar com a comunidade e criar uma atividade para ensinar sobre prevenção.',
       'Fechar a UBS até que o problema desapareça.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-011', c.id, 1, 'A mãe da Jennifer está grávida e precisa fazer as consultas mensais de rotina para acompanhar o crescimento do bebê. Em qual local ela deve realizar o pré-natal?',
       'Na Unidade Básica de Saúde (UBS).',
       'No hospital.',
       'Na Unidade de Pronto Atendimento (UPA).',
       'Não é importante acompanhar a gestação com um médico especialista',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-012', c.id, 1, 'O Pedro precisa tomar a vacina da gripe e buscar um xarope simples recomendado pelo médico. Onde ele encontra vacinas e remédios gratuitos do SUS?',
       'Na igreja.',
       'Na Unidade Básica de Saúde (UBS).',
       'Na Unidade de Pronto Atendimento (UPA).',
       'No supermercado.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-013', c.id, 1, 'A Unidade Básica de Saúde (UBS) é o local ideal para cuidar da saúde no dia a dia. Em quais dias e horários os moradores devem procurar a sua UBS de referência?',
       'Somente de madrugada.',
       'Apenas aos domingos à noite.',
       'De segunda a sexta-feira, das 7h às 17h.',
       'Funciona 24 horas sem parar todos os dias.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-014', c.id, 1, 'A UBS é muito importante para a sociedade porque ela se aproxima da comunidade, cuidando da saúde das famílias no próprio bairro, ajudando a prevenir doenças e acompanhando os moradores de forma contínua.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-015', c.id, 1, 'A Unidade Básica de Saúde (UBS) é a "porta de entrada" do SUS e atende diretamente a região ou o bairro onde os moradores vivem. Nela, a comunidade tem acesso a vacinas, medicamentos gratuitos, exames e atendimento multiprofissional perto de casa.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N1-016', c.id, 1, 'O trabalho dos agentes comunitários de saúde (ACS) com as visitas domiciliares (de casa em casa) distancia os moradores da equipe de saúde do bairro e dificulta a compreensão do cenário social daquela comunidade.',
       'Verdadeiro',
       'Falso',
       null,
       null,
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UBS-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-034', c.id, 2, 'É necessário estar doente para procurar uma UBS?',
       'Sim, sempre.',
       'Não, a UBS também atua em prevenção e promoção da saúde.',
       'Sim, exceto para crianças.',
       'Não, mas somente para buscar medicamentos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-035', c.id, 2, 'UBS significa:',
       'Unidade Brasileira de Socorro.',
       'União Básica Sanitária.',
       'Unidade Básica de Saúde.',
       'Unidade Brasileira de Segurança.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-036', c.id, 2, 'Qual atividade pode fazer parte do cuidado realizado pela UBS?',
       'Somente cirurgias de alta complexidade.',
       'Vacinação, orientações e acompanhamento de saúde.',
       'Apenas atendimento de acidentes graves.',
       'Exclusivamente internações prolongadas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-037', c.id, 2, 'A vacinação realizada ou acompanhada pela atenção à saúde é principalmente uma ação de:',
       'reabilitação esportiva.',
       'tratamento cirúrgico.',
       'prevenção de doenças.',
       'diagnóstico por imagem.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-038', c.id, 2, '“Acompanhamento ao longo do tempo” significa:',
       'procurar atendimento somente uma vez.',
       'acompanhar as necessidades de saúde em diferentes momentos da vida.',
       'frequentar a UBS todos os dias.',
       'permanecer internado na unidade.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-039', c.id, 2, 'Qual situação combina melhor com o papel preventivo da UBS?',
       'Esperar obrigatoriamente uma doença surgir.',
       'Participar de vacinação e receber orientações de saúde.',
       'Utilizar medicamentos sem orientação.',
       'Procurar apenas atendimentos de alta complexidade.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-040', c.id, 2, 'Por que acompanhar a saúde antes de surgirem problemas pode ser importante?',
       'Porque garante que ninguém adoecerá.',
       'Porque prevenção e acompanhamento podem reduzir riscos e identificar necessidades.',
       'Porque elimina a necessidade de hábitos saudáveis.',
       'Porque substitui qualquer outro serviço da rede.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-041', c.id, 2, 'A UBS faz parte:',
       'apenas do sistema escolar.',
       'exclusivamente dos serviços privados.',
       'da rede de cuidados de saúde da população.',
       'somente dos serviços de emergência.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-042', c.id, 2, 'Qual é uma diferença importante entre promoção da saúde e tratamento?',
       'Não existe qualquer diferença.',
       'Promoção também busca favorecer saúde e prevenção antes do aparecimento de problemas.',
       'Tratamento acontece somente em hospitais.',
       'Promoção da saúde utiliza obrigatoriamente medicamentos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-043', c.id, 2, 'Um adolescente saudável participa de uma atividade educativa na UBS. Isso faz sentido?',
       'Não, porque UBS atende somente pessoas doentes.',
       'Sim, porque educação e prevenção também fazem parte do cuidado.',
       'Não, porque adolescentes não utilizam atenção básica.',
       'Sim, mas apenas se precisar de internação.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-044', c.id, 2, 'A ideia de cuidado contínuo significa que:',
       'saúde é cuidada apenas em emergências.',
       'uma consulta resolve qualquer necessidade futura.',
       'o cuidado pode acompanhar diferentes necessidades ao longo da vida.',
       'somente pessoas com doenças crônicas precisam de acompanhamento.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-045', c.id, 2, 'Qual alternativa representa promoção da saúde?',
       'Compartilhar medicamentos.',
       'Ignorar campanhas de prevenção.',
       'Receber orientações sobre hábitos saudáveis.',
       'Procurar atendimento apenas em situações graves.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-046', c.id, 2, 'Uma campanha de vacinação beneficia:',
       'somente os profissionais que trabalham na UBS.',
       'indivíduos e também estratégias de proteção da comunidade.',
       'apenas pessoas que já estão doentes.',
       'exclusivamente adultos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-047', c.id, 2, 'Por que a UBS é importante para o bairro?',
       'Porque substitui todos os hospitais.',
       'Porque aproxima ações de cuidado, prevenção e acompanhamento da comunidade.',
       'Porque atende apenas emergências.',
       'Porque sua função principal é internação.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N2-048', c.id, 2, 'Qual frase representa melhor a Atenção Primária?',
       '“Só procure ajuda quando a situação for grave.”',
       '“Toda situação deve ser atendida em hospital.”',
       '“Cuidar da saúde também envolve prevenção e acompanhamento próximo da comunidade.”',
       '“Vacinação é necessária apenas quando surgem surtos.”',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UBS-N3 — 25 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-001', c.id, 3, 'Infecções urinárias recorrentes são mais frequentes em mulheres devido, entre outros fatores, a:',
       'Maior produção de urina em relação aos homens',
       'Ausência natural de bactérias no sistema urinário feminino',
       'Uma uretra anatomicamente mais curta, o que facilita o acesso de bactérias à bexiga',
       'Uso mais frequente de vacinas específicas',
       'Maior consumo de água pelas mulheres',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-002', c.id, 3, 'O diagnóstico precoce da sífilis tem grande importância epidemiológica porque:',
       'A sífilis sempre evolui, independentemente do tratamento, aumentando a cadeia de transmissão',
       'Não existe tratamento eficaz disponível',
       'A infecção sempre desaparece espontaneamente',
       'Evita a progressão da doença para estágios mais graves e reduz a cadeia de transmissão',
       'Aumenta o risco de complicações',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-003', c.id, 3, 'O estigma histórico em torno da hanseníase dificultou seu controle epidemiológico porque:',
       'A doença nunca teve tratamento disponível, historicamente levando todos os casos a óbito',
       'O estigma facilitava a busca por atendimento médico',
       'Não havia nenhuma forma de preconceito associada à doença',
       'O estigma só existia em outros países',
       'Pessoas escondiam os sintomas por medo de discriminação, atrasando o diagnóstico e o tratamento',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-004', c.id, 3, 'A toxoplasmose representa risco especial na gestação porque a infecção materna pode:',
       'Ser transmitida ao feto, causando complicações que variam de leves a graves, dependendo da fase da gestação',
       'Não ter nenhum efeito sobre o feto, apenas sobre a gestante que pode carregar a doença para o resto da vida',
       'Afetar apenas o desenvolvimento posterior da criança, sem qualquer risco gestacional, podendo acontecer má formação fetal',
       'Ser transmitida somente após o parto',
       'Só afetar a mãe, nunca o bebê',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-005', c.id, 3, 'Ambientes quentes e úmidos favorecem micoses de pele porque:',
       'Eliminam naturalmente qualquer fungo presente',
       'Não têm relação com o desenvolvimento de fungos, por micoses são causadas por bactérias',
       'Favorecem exclusivamente infecções virais por estar em um ambiente mais quentes',
       'Criam condições propícias à proliferação dos fungos causadores dessas micoses',
       'Reduzem a umidade da pele, absorvendo toda a água presente na pele',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-006', c.id, 3, 'O uso excessivo de antibióticos pode favorecer a candidíase porque:',
       'Elimina diretamente o fungo Candida do organismo',
       'Não tem nenhuma relação com o crescimento de fungos',
       'Fortalece exclusivamente a microbiota bacteriana benéfica',
       'Impede totalmente qualquer infecção futura',
       'Pode alterar o equilíbrio da microbiota normal do corpo, permitindo a proliferação excessiva da Candida albicans',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-007', c.id, 3, 'Pacientes imunossuprimidos têm maior risco de infecções fúngicas oportunistas graves porque:',
       'Fungos só representam risco para pessoas com imunidade fortalecida',
       'O sistema imunológico enfraquecido tem menor capacidade de controlar fungos normalmente contidos pelo organismo',
       'Não existe relação entre imunossupressão e infecções fúngicas',
       'A imunossupressão elimina automaticamente os fungos do corpo e alterando o sistema imune da pessoa',
       'A imunossupressão só afeta infecções virais',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-008', c.id, 3, 'O uso do preservativo é a principal prevenção da maioria das ISTs porque:',
       'Cura infecções já instaladas no organismo',
       'Substitui totalmente a necessidade de vacinação contra o HPV',
       'Não apresenta eficácia comprovada na prevenção de ISTs',
       'Só previne gravidez, sem efeito em ISTs',
       'Cria uma barreira física que reduz o contato com fluidos contaminados',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-009', c.id, 3, 'Muitas ISTs, como a clamídia, podem ser assintomáticas. Isso reforça a importância de:',
       'Buscar testagem somente quando sintomas graves aparecem',
       'Testagem regular, mesmo na ausência de sintomas, para diagnóstico e tratamento precoces',
       'O organismo eliminar a infecção espontaneamente em todos os casos',
       'Não haver necessidade de acompanhamento médico regular',
       'Testar apenas uma vez na vida',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-010', c.id, 3, 'A sífilis não tratada evolui em estágios porque:',
       'Os sintomas sempre pioram de forma contínua, sem qualquer período de latência',
       'A infecção desaparece espontaneamente após a fase primária',
       'Não há risco de complicações em estágios avançados',
       'A doença pode continuar progredindo silenciosamente mesmo após o desaparecimento temporário dos sintomas iniciais',
       'A sífilis só afeta a pele, sem outros órgãos, sendo necessário o tratamento unicamente com um dermatologista',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-011', c.id, 3, 'A redução do estigma social em torno das ISTs pode impactar positivamente os indicadores de saúde pública porque:',
       'O estigma não interfere na busca por serviços de saúde, mantendo os mesmos números independente do julgamento social',
       'Pessoas tendem a buscar testagem e tratamento com menos receio de julgamento social',
       'Reduzir o estigma aumenta diretamente a taxa de novas infecções',
       'Não existe relação entre estigma social e comportamento de busca por diagnóstico',
       'O estigma social só afeta doenças raras',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-012', c.id, 3, 'A obesidade é fator de risco central para diversas DCNT porque está associada a:',
       'Nenhuma relação com outras condições crônicas',
       'Apenas questões estéticas, sem implicações clínicas',
       'Maior propensão a diabetes tipo 2, hipertensão e doenças cardiovasculares',
       'Redução do risco cardiovascular, porém causam o aumento de deficiência renal',
       'Diminuição do risco de diabetes',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-013', c.id, 3, 'O sedentarismo aumenta o risco cardiovascular mesmo em pessoas com peso adequado porque:',
       'O peso corporal é o único fator relevante para o risco cardiovascular, desconsiderado fatores metabólicos e fisiológicos',
       'O sedentarismo não gera nenhum efeito fisiológico mensurável',
       'Não existe relação entre atividade física e saúde do coração',
       'Provoca alterações metabólicas e reduz a aptidão cardiorrespiratória, independentemente do peso corporal',
       'O sedentarismo só afeta pessoas obesas',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-014', c.id, 3, 'A hipertensão é chamada de doença silenciosa porque:',
       'Pode se manter assintomática por longos períodos, mesmo causando danos progressivos a órgãos',
       'Sempre apresenta sintomas graves e evidentes desde o início',
       'Não representa nenhum risco à saúde a longo prazo',
       'É facilmente identificada sem necessidade de exames',
       'Só afeta pessoas com mais de 80 anos',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-015', c.id, 3, 'A combinação de sedentarismo, dieta rica em ultraprocessados e obesidade aumenta o risco de infarto e AVC porque:',
       'Favorece hipertensão, resistência à insulina e outros fatores de risco cardiovascular associados',
       'Reduz automaticamente a pressão arterial e favorecendo o risco de doenças respiratórias',
       'Afeta exclusivamente o sistema digestivo, sem repercussão cardiovascular',
       'Só aumenta o risco de doenças respiratórias',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-016', c.id, 3, 'A anemia por deficiência de ferro está diretamente relacionada a fatores nutricionais porque decorre de:',
       'Exclusivamente fatores genéticos hereditários',
       'Uma infecção viral específica',
       'Excesso de vitamina C na dieta',
       'Consumo excessivo de proteínas',
       'Ingestão insuficiente ou perda excessiva de ferro',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-017', c.id, 3, 'Entre os fatores de risco evitáveis relacionados a certos tipos de câncer, destacam-se:',
       'Idade avançada e exposição química',
       'Histórico familiar e o fenótipo individual',
       'Tabagismo e exposição solar excessiva',
       'Sexo biológico',
       'Altura da pessoa',
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-018', c.id, 3, 'A resistência à insulina é central no desenvolvimento do diabetes tipo 2 porque:',
       'Não tem nenhuma relação com o desenvolvimento do diabetes tipo 2 e sim da diabetes tipo 1',
       'Aumenta a produção de insulina de forma que a pessoa precisa eliminá-la de alguma forma',
       'É um mecanismo exclusivo do diabetes tipo 2, sendo essencial no diagnóstico da doença',
       'Reduz a resposta das células à ação da insulina, dificultando a entrada de glicose e elevando os níveis de glicemia',
       'Elimina completamente a glicose do sangue',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-019', c.id, 3, 'Obesidade, hipertensão e resistência à insulina são tratadas como parte de uma síndrome metabólica porque:',
       'Não apresentam nenhuma relação entre si',
       'São sempre causadas por infecções virais que desencadeiam uma resposta no sistema imune, afetando as vias metabólicas',
       'Ocorrem sempre de forma isolada, sem qualquer conexão fisiológica',
       'Reduzem, juntas, o risco de uma possível doença viral',
       'Formam um conjunto de fatores de risco interligados que aumentam substancialmente o risco cardiovascular',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-020', c.id, 3, 'O diagnóstico precoce de distúrbios da tireoide em crianças é importante porque:',
       'Distúrbios não tratados podem impactar diretamente o crescimento físico e o desenvolvimento cognitivo',
       'A tireoide não desempenha função relevante durante a infância e sim a paratireoide',
       'Não existe tratamento disponível para crianças com essas condições',
       'Afeta apenas características estéticas, sem outras implicações',
       'Só afeta apenas o apetite, sem precisar se preocupar com complicações futuras na vida dessa criança',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-021', c.id, 3, 'O acesso a espaços públicos de lazer pode impactar positivamente os indicadores de doenças crônicas não transmissíveis (DCNT) de uma comunidade porque:',
       'Não tem relação alguma com hábitos de saúde da população, pois questões físicas e mentais são completamente distintas',
       'Favorece a prática regular de atividade física entre os moradores, um fator protetor reconhecido',
       'Tende a aumentar o sedentarismo local por não oferecer estímulos reais a população',
       'Substitui totalmente a necessidade de acesso a alimentação saudável, pois a pratica de atividades físicas supre essa necessidade',
       'Aumenta o risco de doenças crônicas',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-022', c.id, 3, 'O diabetes ilustra uma doença do sistema endócrino porque envolve:',
       'Ausência total de qualquer hormônio no organismo, sendo uma das doenças mais graves e preocupantes',
       'Desequilíbrio na produção ou na ação do hormônio insulina, responsável pela regulação da glicose no sangue',
       'Nenhuma relação com o funcionamento do sistema endócrino',
       'Fatores exclusivamente externos, sem base hormonal',
       'Excesso de produção de hormônios como o glucagon e o cortisol, causando um desequilíbrio corporal',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-023', c.id, 3, 'O uso inadequado de antibióticos contribui para a resistência bacteriana porque:',
       'Elimina, sem exceção, todas as bactérias presentes no organismo incluindo as mais resistentes',
       'Não tem relação alguma com o processo evolutivo das populações bacterianas',
       'Fortalece exclusivamente o sistema imunológico humano, sem afetar as bactérias',
       'Impede totalmente que bactérias sobrevivam',
       'Favorece a sobrevivência e a multiplicação de bactérias que possuem mecanismos de resistência',
       'E', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-024', c.id, 3, 'É um exemplo de doença ocupacional:',
       'Uma doença determinada exclusivamente por fatores genéticos',
       'Perda auditiva por exposição contínua a ruído excessivo no trabalho',
       'Uma infecção transmitida por vetores em ambiente doméstico',
       'Um transtorno alimentar ligado a pressão estética exercida na sociedade',
       'Uma alergia sazonal a pólen',
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UBS-N3-025', c.id, 3, 'As doenças neurodegenerativas, como o Alzheimer, tendem a ser progressivas porque:',
       'Se curam espontaneamente ao longo do tempo, sem necessidade de tratamento',
       'Não afetam, de fato, o funcionamento do sistema nervoso',
       'São causadas por um vírus que o sistema imunológico elimina naturalmente',
       'Envolvem a perda gradual e contínua de neurônios e de suas conexões',
       'Afetam exclusivamente pessoas jovens',
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UPA-N1 — 14 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-005', c.id, 1, 'Você sabe o que é uma Unidade de Pronto atendimento (UPA)?',
       'Um lugar onde as pessoas vão para fazer consultas de rotina.',
       'Um lugar onde somente adultos podem ser atendidos.',
       'Um lugar onde são feitas apenas exames de rotina',
       'Um serviço de saúde preparado para atender pessoas que precisam de atendimento de urgência.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-006', c.id, 1, 'Quando uma pessoa deve procurar uma Unidade de Pronto atendimento (UPA)?',
       'Quando precisa de atendimento de urgência e não pode esperar por uma consulta de rotina.',
       'Sempre que quiser conversar sobre qualquer assunto.',
       'Somente para tomar vacinas e fazer consultas de rotina.',
       'Apenas quando precisar fazer um exame de sangue.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-007', c.id, 1, 'Caio procurou uma Unidade de Pronto atendimento (UPA) porque está passando mal. Depois de ser atendido, ele precisa continuar acompanhando sua saúde. O que Caio deve fazer?',
       'Ele nunca mais precisará procurar nenhum serviço de saúde.',
       'Ele deve sempre voltar para UPA para acompanhar sua saúde.',
       'Ele deve voltar lá para fazer exames e consultas de rotina.',
       'Ele pode continuar o acompanhamento na UBS, quando esse acompanhamento for necessário.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-008', c.id, 1, 'Maria está com uma dor forte que começou de repente e precisa ser avaliada rapidamente por um profissional de saúde. Qual serviço pode ajudá-la?',
       'Uma farmácia grande',
       'Unidade Básica de Saúde (UBS)',
       'Uma funerária',
       'Unidade de Pronto atendimento (UPA).',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-009', c.id, 1, 'Por que é importante que a UPA e a UBS tenham uma boa comunicação?',
       'Para que as informações importantes sobre o cuidado da pessoa possam ser compartilhadas.',
       'Para que a pessoa precise contar a mesma história muitas vezes.',
       'Para que somente a UPA possa cuidar da pessoa.',
       'Porque assim os profissionais não precisam conversar com os pacientes.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-010', c.id, 1, 'Por que algumas pessoas acabam procurando a UPA mesmo quando não estão em uma situação de urgência?',
       'Porque a UBS não está preparada para fazer acompanhamento constante.',
       'Porque a UPA atende somente doenças graves.',
       'Porque podem ter dúvidas sobre qual serviço procurar ou encontrar dificuldades para conseguir atendimento em outros serviços.',
       'Porque toda consulta deve acontecer na UPA.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-011', c.id, 1, 'Qual situação mostra melhor a diferença entre a UBS e a UPA?',
       'A UPA faz prevenção e a UBS atende apenas acidentes e situações de emergência.',
       'A UBS atende somente crianças e a UPA somente adultos.',
       'Os dois serviços têm exatamente a mesma função.',
       'A UBS atua no acompanhamento e na prevenção da saúde, já a UPA atende situações que precisam de cuidado de urgência.',
       null,
       'D', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-012', c.id, 1, 'Você sabe diferenciar quando Ir na UBS ou UPA? João está com dor de garganta leve há alguns dias, sem dificuldade para respirar. Ele quer saber onde pode receber ajuda. Maria caiu enquanto brincava, está com muita dor e não consegue mexer o braço direito. Qual alternativa mostra corretamente onde cada um deve procurar atendimento?',
       'João → UBS; Maria → UPA.',
       'João → UPA; Maria → UBS.',
       'João → UPA; Maria → UPA.',
       'João → UBS; Maria → UBS.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-013', c.id, 1, 'Durante toda a gravidez, a mamãe do Pedro foi até a Unidade Básica de Saúde (UBS) para fazer as consultas de rotina do pré-natal (acompanhamento médico da gestante e do bebê antes do nascimento). Mas, se ela sentir dores fortes e urgentes ou precisar de atendimento emergencial 24 horas para ser encaminhada ao hospital, para onde a família deve levá-la?',
       'Para a Unidade de Pronto Atendimento (UPA).',
       'Para a escola.',
       'Para a UBS.',
       'Para a farmácia.',
       null,
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-014', c.id, 1, 'O Lucas mora em uma cidadezinha no interior que não tem hospital, mas conta com uma Unidade de Pronto Atendimento (UPA 24h). Enquanto brincava, o irmão do Lucas sofreu um acidente e fez um corte profundo. Por ser uma emergência com machucado que precisa de atendimento médico e cuidados imediatos, para onde a família deve levá-lo?',
       'Ir para a Unidade Básica de Saúde (UBS) e aguardar até o dia seguinte para agendar uma consulta.',
       'Ir imediatamente para a Unidade de Pronto Atendimento (UPA 24h).',
       'Ir à farmácia apenas para comprar um curativo adesivo simples.',
       'Ficar em casa esperando o machucado sarar sozinho.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-015', c.id, 1, 'O avô da Beatriz sentiu uma dor muito forte no peito e uma falta de ar intensa de repente. Qual serviço emergencial é preparado para esse atendimento?',
       'Unidade Básica de Saúde (UBS).',
       'Unidade de Pronto Atendimento (UPA).',
       'Mercado da cidade.',
       'Praça do bairro.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-016', c.id, 1, 'A Aninha não consegue parar nada no estômago e está vomitando constantemente há várias horas. Para onde a família deve levá-la?',
       'Para a Unidade Básica de Saúde (UBS).',
       'Para a Unidade de Pronto Atendimento (UPA).',
       'Para a escola.',
       'Para o cinema.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-017', c.id, 1, 'Quando um paciente chega à UPA com uma emergência grave e o médico percebe que ele precisará de uma cirurgia ou de internação, qual é o papel da UPA?',
       'Mandar o paciente para casa sem fazer nada.',
       'Estabilizar o paciente e encaminhá-lo para o Hospital.',
       'Pedir para o paciente voltar outro dia.',
       'Enviar o paciente para a igreja.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N1-018', c.id, 1, 'No domingo à noite, a Unidade Básica de Saúde (UBS) do bairro já está fechada, pois funciona de segunda a sexta-feira durante o dia. Se alguém passar mal de repente com febre e dor no corpo no final de semana, para onde a família deve levá-la?',
       'Para a escola da comunidade.',
       'Para a Unidade de Pronto Atendimento (UPA 24h).',
       'Para o parquinho do bairro.',
       'Para a biblioteca pública.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UPA-N2 — 15 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-006', c.id, 2, 'UPA significa:',
       'Unidade Preventiva de Atendimento.',
       'Unidade Primária Ambulatorial.',
       'Unidade de Pronto Atendimento.',
       'Unidade Pública de Acompanhamento.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-007', c.id, 2, 'A principal característica da UPA apresentada no jogo é:',
       'realizar apenas vacinação.',
       'atender problemas que precisam de avaliação e cuidado com maior urgência.',
       'realizar exclusivamente consultas preventivas.',
       'acompanhar todas as pessoas durante anos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-008', c.id, 2, 'UBS e UPA:',
       'possuem exatamente a mesma função.',
       'competem entre si pelos pacientes.',
       'fazem parte da rede de saúde, mas possuem papéis diferentes.',
       'atendem exclusivamente crianças.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-009', c.id, 2, 'Saber reconhecer situações urgentes é importante porque:',
       'qualquer sintoma exige atendimento de emergência.',
       'ajuda a procurar o serviço adequado sem atrasar cuidados necessários.',
       'elimina a necessidade de profissionais de saúde.',
       'permite realizar diagnósticos sozinho.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-010', c.id, 2, 'Para acompanhamento preventivo e vacinação, o documento destaca principalmente:',
       'UPA.',
       'ambulância.',
       'UBS.',
       'centro cirúrgico.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-011', c.id, 2, 'Para um problema que exige avaliação mais urgente, qual serviço do cenário é voltado a esse tipo de atendimento?',
       'Escola.',
       'Mercado.',
       'UPA.',
       'Parque.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-012', c.id, 2, 'Por que não devemos tratar UBS e UPA como sinônimos?',
       'Porque apenas uma delas pertence à saúde.',
       'Porque desempenham funções diferentes dentro da rede de cuidados.',
       'Porque UBS existe somente em áreas rurais.',
       'Porque UPA realiza apenas atividades educativas.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-013', c.id, 2, 'O conceito de “rede de saúde” indica que:',
       'todos os serviços realizam exatamente as mesmas tarefas.',
       'diferentes serviços possuem funções que se complementam no cuidado da população.',
       'somente hospitais são necessários.',
       'prevenção e urgência devem ocorrer no mesmo local.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-014', c.id, 2, 'Qual situação combina mais com acompanhamento contínuo do que com pronto atendimento?',
       'Problema agudo que exige avaliação rápida.',
       'Acompanhamento preventivo e orientações de saúde.',
       'Situação que necessita cuidado com maior urgência.',
       'Problema que precisa de avaliação imediata.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-015', c.id, 2, 'A escolha adequada do serviço de saúde:',
       'não interfere na organização do cuidado.',
       'deve ser feita apenas pela distância.',
       'depende também do tipo e da urgência da necessidade.',
       'significa utilizar sempre a UPA.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-016', c.id, 2, 'A UPA substitui completamente a UBS?',
       'Sim, porque ambas pertencem à rede de saúde.',
       'Não, porque possuem papéis diferentes no cuidado.',
       'Sim, porque a UPA realiza toda prevenção.',
       'Não, porque a UBS atende apenas emergências.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-017', c.id, 2, 'A UBS substitui completamente a UPA?',
       'Sim, pois toda situação pode esperar.',
       'Sim, porque são serviços idênticos.',
       'Não, pois algumas situações exigem atendimento com maior urgência.',
       'Não, porque a UBS não pertence à rede de saúde.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-018', c.id, 2, 'Entender os diferentes serviços do SUS ajuda:',
       'apenas profissionais de saúde.',
       'a população a procurar cuidados mais adequados às suas necessidades.',
       'somente pessoas com doenças crônicas.',
       'exclusivamente adultos.',
       null,
       'B', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-019', c.id, 2, 'Qual associação está CORRETA segundo os cenários do jogo?',
       'UBS → somente emergências graves.',
       'UPA → acompanhamento preventivo contínuo.',
       'UBS → prevenção e acompanhamento; UPA → situações de maior urgência.',
       'UBS e UPA → funções completamente iguais.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N2-020', c.id, 2, 'Qual aprendizagem central o cenário UPA pretende desenvolver?',
       'Ensinar estudantes a diagnosticar doenças sozinhos.',
       'Incentivar a procura da UPA para qualquer problema.',
       'Reconhecer a importância da urgência e compreender os diferentes papéis da rede de saúde.',
       'Mostrar que prevenção não é necessária quando existe pronto atendimento.',
       null,
       'C', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;


-- UPA-N3 — 1 questões

insert into questoes (codigo_externo, cenario_id, nivel_etario, enunciado,
       opcao_a, opcao_b, opcao_c, opcao_d, opcao_e, resposta_correta, explicacao)
select 'UPA-N3-001', c.id, 3, 'A meningite bacteriana costuma exigir tratamento mais urgente do que a viral porque:',
       'Tem potencial de evoluir rapidamente para quadros graves, incluindo sequelas neurológicas e risco de morte',
       'Não apresenta risco à vida do paciente, porém exige análise mais profunda da doença por deixar sequelas',
       'É sempre mais branda que a meningite viral',
       'Não exige diagnóstico diferenciado',
       'Melhora sozinha em poucas horas, sem tratamento',
       'A', 'Explicação em elaboração pela equipe de Medicina. Confira a resposta correta e siga em frente — errar faz parte de aprender!'
  from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update
  set enunciado = excluded.enunciado,
      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario,
      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
      opcao_e = excluded.opcao_e,
      resposta_correta = excluded.resposta_correta,
      explicacao = excluded.explicacao;



-- ── 2. Quais barras cada questão enche ───────────────────────────────
-- SEM ESTAS LINHAS O ALUNO ACERTA E NADA ACONTECE: o servidor lê daqui
-- para saber o que somar, e zero linhas = zero pontos, sem erro nenhum.
-- O peso de cada barra é proporcional a quantas questões do mesmo
-- cenário e nível realmente tratam daquele tema: num grupo de 39
-- questões em que só 1 fala de vetores, acertar vale 10 em Saúde e 1
-- em Vetores. Sem isso a barra de Vetores subiria com mérito que não
-- existe.

-- CASA-N3: Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'CASA-N3-001',
    'CASA-N3-002',
    'CASA-N3-003',
    'CASA-N3-004',
    'CASA-N3-005'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- CORREGO-N2: Felicidade=10, Limpeza=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Limpeza', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'CORREGO-N2-001',
    'CORREGO-N2-002',
    'CORREGO-N2-003',
    'CORREGO-N2-004',
    'CORREGO-N2-005',
    'CORREGO-N2-006',
    'CORREGO-N2-007',
    'CORREGO-N2-008',
    'CORREGO-N2-009',
    'CORREGO-N2-010',
    'CORREGO-N2-011',
    'CORREGO-N2-012',
    'CORREGO-N2-013',
    'CORREGO-N2-014',
    'CORREGO-N2-015',
    'CORREGO-N2-016',
    'CORREGO-N2-017',
    'CORREGO-N2-018',
    'CORREGO-N2-019',
    'CORREGO-N2-020',
    'CORREGO-N2-021',
    'CORREGO-N2-022',
    'CORREGO-N2-023',
    'CORREGO-N2-024',
    'CORREGO-N2-025',
    'CORREGO-N2-026',
    'CORREGO-N2-027',
    'CORREGO-N2-028',
    'CORREGO-N2-029',
    'CORREGO-N2-030'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- CORREGO-N3: Alimentação=2, Limpeza=10, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Alimentação', 2),
    ('Limpeza', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'CORREGO-N3-001',
    'CORREGO-N3-002',
    'CORREGO-N3-003',
    'CORREGO-N3-004',
    'CORREGO-N3-005',
    'CORREGO-N3-006'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- ESCOLA-N3: Educação=7, Felicidade=2, Saúde=10, Vetores=3
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Educação', 7),
    ('Felicidade', 2),
    ('Saúde', 10),
    ('Vetores', 3)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'ESCOLA-N3-001',
    'ESCOLA-N3-002',
    'ESCOLA-N3-003',
    'ESCOLA-N3-004',
    'ESCOLA-N3-005',
    'ESCOLA-N3-006',
    'ESCOLA-N3-007',
    'ESCOLA-N3-008',
    'ESCOLA-N3-009',
    'ESCOLA-N3-010',
    'ESCOLA-N3-011',
    'ESCOLA-N3-012',
    'ESCOLA-N3-013',
    'ESCOLA-N3-014',
    'ESCOLA-N3-015',
    'ESCOLA-N3-016',
    'ESCOLA-N3-017',
    'ESCOLA-N3-018',
    'ESCOLA-N3-019',
    'ESCOLA-N3-020',
    'ESCOLA-N3-021',
    'ESCOLA-N3-022',
    'ESCOLA-N3-023'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- FARMACIA-N1: Felicidade=10, Saúde=10, Vacinação=1
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 1)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'FARMACIA-N1-002',
    'FARMACIA-N1-003',
    'FARMACIA-N1-004',
    'FARMACIA-N1-005',
    'FARMACIA-N1-006',
    'FARMACIA-N1-007',
    'FARMACIA-N1-008',
    'FARMACIA-N1-009',
    'FARMACIA-N1-010',
    'FARMACIA-N1-011',
    'FARMACIA-N1-012',
    'FARMACIA-N1-013',
    'FARMACIA-N1-014',
    'FARMACIA-N1-015',
    'FARMACIA-N1-016',
    'FARMACIA-N1-017'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- FARMACIA-N2: Felicidade=10, Saúde=10, Vacinação=3
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 3)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'FARMACIA-N2-001',
    'FARMACIA-N2-002',
    'FARMACIA-N2-003',
    'FARMACIA-N2-004',
    'FARMACIA-N2-005',
    'FARMACIA-N2-006',
    'FARMACIA-N2-007',
    'FARMACIA-N2-008',
    'FARMACIA-N2-009',
    'FARMACIA-N2-010',
    'FARMACIA-N2-011',
    'FARMACIA-N2-012',
    'FARMACIA-N2-013',
    'FARMACIA-N2-014',
    'FARMACIA-N2-015'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- FARMACIA-N3: Educação=1, Saúde=10, Vacinação=8, Vetores=1
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Educação', 1),
    ('Saúde', 10),
    ('Vacinação', 8),
    ('Vetores', 1)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'FARMACIA-N3-001',
    'FARMACIA-N3-002',
    'FARMACIA-N3-003',
    'FARMACIA-N3-004',
    'FARMACIA-N3-005',
    'FARMACIA-N3-006',
    'FARMACIA-N3-007',
    'FARMACIA-N3-008',
    'FARMACIA-N3-009'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- MERCADO-N3: Alimentação=10, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Alimentação', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'MERCADO-N3-011'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- PARQUE-N2: Felicidade=10, Limpeza=10, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'PARQUE-N2-024',
    'PARQUE-N2-025',
    'PARQUE-N2-026',
    'PARQUE-N2-027',
    'PARQUE-N2-028',
    'PARQUE-N2-029',
    'PARQUE-N2-030',
    'PARQUE-N2-031',
    'PARQUE-N2-032',
    'PARQUE-N2-033',
    'PARQUE-N2-034',
    'PARQUE-N2-035',
    'PARQUE-N2-036',
    'PARQUE-N2-037',
    'PARQUE-N2-038'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- PRACA-N2: Exercícios=5, Felicidade=3, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Exercícios', 5),
    ('Felicidade', 3),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'PRACA-N2-004',
    'PRACA-N2-005',
    'PRACA-N2-006',
    'PRACA-N2-007',
    'PRACA-N2-008',
    'PRACA-N2-009',
    'PRACA-N2-010',
    'PRACA-N2-011',
    'PRACA-N2-012',
    'PRACA-N2-013',
    'PRACA-N2-014',
    'PRACA-N2-015',
    'PRACA-N2-016',
    'PRACA-N2-017',
    'PRACA-N2-018'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- QUADRA-N2: Exercícios=10, Felicidade=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Exercícios', 10),
    ('Felicidade', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'QUADRA-N2-004',
    'QUADRA-N2-005',
    'QUADRA-N2-006',
    'QUADRA-N2-007',
    'QUADRA-N2-008',
    'QUADRA-N2-009',
    'QUADRA-N2-010',
    'QUADRA-N2-011',
    'QUADRA-N2-012',
    'QUADRA-N2-013',
    'QUADRA-N2-014',
    'QUADRA-N2-015',
    'QUADRA-N2-016',
    'QUADRA-N2-017',
    'QUADRA-N2-018'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- TERRENOBALDIO-N2: Felicidade=10, Limpeza=10, Vetores=5
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Limpeza', 10),
    ('Vetores', 5)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'TERRENOBALDIO-N2-001',
    'TERRENOBALDIO-N2-002',
    'TERRENOBALDIO-N2-003',
    'TERRENOBALDIO-N2-004',
    'TERRENOBALDIO-N2-005',
    'TERRENOBALDIO-N2-006',
    'TERRENOBALDIO-N2-007',
    'TERRENOBALDIO-N2-008',
    'TERRENOBALDIO-N2-009',
    'TERRENOBALDIO-N2-010',
    'TERRENOBALDIO-N2-011',
    'TERRENOBALDIO-N2-012',
    'TERRENOBALDIO-N2-013',
    'TERRENOBALDIO-N2-014',
    'TERRENOBALDIO-N2-015'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UBS-N1: Felicidade=10, Saúde=10, Vacinação=1
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 1)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UBS-N1-003',
    'UBS-N1-004',
    'UBS-N1-005',
    'UBS-N1-006',
    'UBS-N1-007',
    'UBS-N1-008',
    'UBS-N1-009',
    'UBS-N1-010',
    'UBS-N1-011',
    'UBS-N1-012',
    'UBS-N1-013',
    'UBS-N1-014',
    'UBS-N1-015',
    'UBS-N1-016'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UBS-N2: Felicidade=10, Saúde=10, Vacinação=3
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 3)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UBS-N2-034',
    'UBS-N2-035',
    'UBS-N2-036',
    'UBS-N2-037',
    'UBS-N2-038',
    'UBS-N2-039',
    'UBS-N2-040',
    'UBS-N2-041',
    'UBS-N2-042',
    'UBS-N2-043',
    'UBS-N2-044',
    'UBS-N2-045',
    'UBS-N2-046',
    'UBS-N2-047',
    'UBS-N2-048'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UBS-N3: Educação=8, Felicidade=2, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Educação', 8),
    ('Felicidade', 2),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UBS-N3-001',
    'UBS-N3-002',
    'UBS-N3-003',
    'UBS-N3-004',
    'UBS-N3-005',
    'UBS-N3-006',
    'UBS-N3-007',
    'UBS-N3-008',
    'UBS-N3-009',
    'UBS-N3-010',
    'UBS-N3-011',
    'UBS-N3-012',
    'UBS-N3-013',
    'UBS-N3-014',
    'UBS-N3-015',
    'UBS-N3-016',
    'UBS-N3-017',
    'UBS-N3-018',
    'UBS-N3-019',
    'UBS-N3-020',
    'UBS-N3-021',
    'UBS-N3-022',
    'UBS-N3-023',
    'UBS-N3-024',
    'UBS-N3-025'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UPA-N1: Felicidade=10, Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UPA-N1-005',
    'UPA-N1-006',
    'UPA-N1-007',
    'UPA-N1-008',
    'UPA-N1-009',
    'UPA-N1-010',
    'UPA-N1-011',
    'UPA-N1-012',
    'UPA-N1-013',
    'UPA-N1-014',
    'UPA-N1-015',
    'UPA-N1-016',
    'UPA-N1-017',
    'UPA-N1-018'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UPA-N2: Felicidade=10, Saúde=10, Vacinação=1
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Felicidade', 10),
    ('Saúde', 10),
    ('Vacinação', 1)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UPA-N2-006',
    'UPA-N2-007',
    'UPA-N2-008',
    'UPA-N2-009',
    'UPA-N2-010',
    'UPA-N2-011',
    'UPA-N2-012',
    'UPA-N2-013',
    'UPA-N2-014',
    'UPA-N2-015',
    'UPA-N2-016',
    'UPA-N2-017',
    'UPA-N2-018',
    'UPA-N2-019',
    'UPA-N2-020'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

-- UPA-N3: Saúde=10
insert into questoes_areas (questao_id, area_nome, pontos)
select qs.id, v.area, v.pontos from questoes qs
  cross join (values
    ('Saúde', 10)
  ) as v(area, pontos)
  where qs.codigo_externo in (
    'UPA-N3-001'
  )
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;


-- ── As metas das barras ──────────────────────────────────────────────
-- A meta de cada área é tudo o que o conteúdo dela pode render. Como
-- este arquivo acabou de mudar o conteúdo, ela precisa ser refeita —
-- e as porcentagens de quem já jogou vão junto.
select public.recalcular_metas();

-- select nome, meta from areas order by ordem;

-- ── Conferir depois de rodar ─────────────────────────────────────────
-- select c.slug, q.nivel_etario, count(*) as questoes
--   from questoes q join cenarios c on c.id = q.cenario_id
--  group by c.slug, q.nivel_etario order by c.slug, q.nivel_etario;
