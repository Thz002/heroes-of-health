-- Questões que faltavam (gerado por db/ferramentas/gerar_importacao.py — não edite à mão).
-- Idempotente pelo codigo_externo. Rode depois de db/feedback-questoes.sql.



-- ── CASA — 7 questões (3 com cenário da equipe, 4 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-019', c.id, 1, 'Maria e sua família estão fazendo uma faxina no quintal para evitar a dengue. O que eles devem fazer com a caixa-d''água?',   -- cenário deduzido
  'Deixá-la aberta para o mosquito entrar.', 'Mantê-la sempre bem fechada e vedada.', 'Colocar brinquedos dentro dela.', 'Deixá-la furada para a água sair.', null,
  'B', 'Acertou! A caixa-d''água bem fechada e vedada impede que o mosquito entre e coloque ovos na água. É um cuidado simples que protege a sua família e os vizinhos.', 'Quase! O mosquito procura água parada para colocar os ovos. O que a família pode fazer com a caixa-d''água para ele não conseguir entrar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-020', c.id, 1, 'que é importante fazer com as embalagens de plástico ou metal antes de colocá-las no saco de lixo?',
  'Pintá-las com canetinha colorida.', 'Higienizá-las (limpá-las) para retirar restos de alimentos e líquidos.', 'Enchê-las com água para ficarem pesadas.', 'Rasgá-las em pedaços bem pequenininhos.', null,
  'B', 'Muito bem! Limpar as embalagens, tirando restos de comida e líquidos, evita mau cheiro e contaminação e ajuda na reciclagem.', 'Não desista! Embalagens com restos de comida atrapalham a reciclagem. O que devemos fazer com elas antes de separar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-021', c.id, 1, 'sono é muito importante para a nossa saúde. Por que precisamos dormir bem todas as noites?',
  'Porque dormir é uma perda de tempo e não ajuda em nada.', 'Porque o descanso ajuda o corpo a recuperar as energias e mantém a mente saudável para o dia seguinte.', 'Porque as crianças não precisam descansar, apenas os adultos.', 'Porque o corpo só precisa de comida, nunca de descanso.', null,
  'B', 'Certo! Durante o sono, o corpo recupera as energias e a mente descansa, para termos disposição no dia seguinte.', 'Boa tentativa! Dormir bem faz muito bem. Como você se sente depois de uma boa noite de sono? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-022', c.id, 1, 'Verdadeiro ou Falso As necessidades do corpo, como o sono e o descanso, são menos importantes do que passar a noite inteira acordado lendo.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! Sono e descanso são tão importantes quanto estudar. Passar a noite inteira acordado cansa o corpo e a mente.', 'Quase! Será que ficar a noite inteira acordado faz bem? Pense no que o corpo precisa para ter energia. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-023', c.id, 1, 'Verdadeiro ou Falso Uma alimentação rica e diversa em frutas, legumes e verduras é essencial para o bom funcionamento do corpo, pois os nutrientes dos alimentos são aproveitados por cada parte do nosso organismo para garantir energia e força.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, parabéns! Frutas, legumes e verduras têm nutrientes que o corpo usa para ter energia e força. Quanto mais variada a alimentação, melhor!', 'Quase! Pense: será que alimentos variados dão ao corpo tudo o que ele precisa? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N1-024', c.id, 1, 'que acontece quando uma criança gasta muitas horas do dia apenas fazendo "afazeres domésticos" (limpar, cozinhar, cuidar de irmãos)?',
  'Ela fica mais inteligente que os outros colegas.', 'Ela perde o tempo que deveria usar para estudar, brincar e descansar.', 'Ela ajuda a escola a ficar mais vazia.', 'Ela cresce mais rápido que as outras crianças.', null,
  'B', 'Isso! Quando a criança passa muitas horas em afazeres domésticos, ela perde o tempo de estudar, brincar e descansar. Ajudar um pouquinho em casa é bom, mas o excesso atrapalha.', 'Quase! Pense no que falta para uma criança que passa muitas horas fazendo tarefas de casa. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CASA-N3-001', c.id, 3, 'As condições sociais e ambientais em que uma pessoa vive podem influenciar seu processo saúde-doença.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Muito bem! Moradia, saneamento, renda, educação e acesso aos serviços são determinantes sociais da saúde e influenciam quem adoece e como. Cuidar da saúde também é cuidar das condições de vida.', 'Quase! Pense em como saneamento, moradia e renda afetam a saúde das pessoas. Eles influenciam ou não? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'casa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── CORREGO — 32 questões (30 com cenário da equipe, 2 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-001', c.id, 2, 'Qual é uma das principais funções do tratamento de esgoto?',
  'Produzir água salgada para a população.', 'Reduzir a contaminação ambiental por resíduos e microrganismos.', 'Aumentar a quantidade de lixo nos rios.', 'Substituir a coleta de resíduos sólidos.', null,
  'B', 'Correto! O tratamento de esgoto reduz a contaminação do ambiente por resíduos e microrganismos, protegendo rios, solo e a saúde das pessoas.', 'Não foi dessa vez. Pense no que acontece com a água e o ambiente quando o esgoto é tratado. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-002', c.id, 2, 'O esgoto lançado sem tratamento pode:',
  'melhorar a qualidade da água.', 'eliminar os microrganismos existentes.', 'contaminar a água e o solo.', 'transformar qualquer água em potável.', null,
  'C', 'Isso mesmo! Esgoto sem tratamento contamina a água e o solo, espalhando microrganismos que podem causar doenças.', 'Quase! Pense no que o esgoto cheio de microrganismos faz ao ser lançado direto na natureza. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-003', c.id, 2, 'Saneamento básico está relacionado à saúde porque:',
  'atua somente na aparência das cidades.', 'beneficia exclusivamente animais e plantas.', 'ajuda a prevenir doenças e proteger a população.', 'substitui completamente os serviços de saúde.', null,
  'C', 'Muito bem! O saneamento básico (água tratada, esgoto, lixo) previne doenças e protege a população.', 'Não foi dessa vez. O saneamento vai muito além da aparência da cidade. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-004', c.id, 2, 'Se água contaminada for utilizada para consumo, pode ocorrer:',
  'fortalecimento automático da imunidade.', 'aumento do risco de doenças transmitidas pela água.', 'destruição imediata de todos os microrganismos.', 'aumento da quantidade de oxigênio no sangue.', null,
  'B', 'Correto! Beber água contaminada aumenta o risco de doenças transmitidas pela água, como diarreias, hepatite A e leptospirose.', 'Quase! Pense no risco de beber água com microrganismos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-005', c.id, 2, 'Qual situação representa um risco à saúde?',
  'Tratamento adequado do esgoto.', 'Destinação correta dos resíduos.', 'Proteção das fontes de água.', 'Esgoto correndo a céu aberto.', null,
  'D', 'Exato! Esgoto a céu aberto expõe as pessoas a microrganismos e atrai vetores, representando risco à saúde.', 'Não foi dessa vez. Procure a situação que NÃO é uma boa prática de saneamento. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-006', c.id, 2, 'A contaminação de um córrego pode afetar várias pessoas porque:',
  'doenças ambientais nunca ultrapassam uma residência.', 'água e ambiente são recursos compartilhados pela comunidade.', 'microrganismos vivem exclusivamente dentro do corpo.', 'a qualidade da água não interfere na saúde humana.', null,
  'B', 'Boa! Água e ambiente são recursos compartilhados: um córrego contaminado pode afetar toda a comunidade que o utiliza.', 'Quase! Pense em quantas pessoas dependem do mesmo córrego. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-007', c.id, 2, 'Qual relação está CORRETA?',
  'Esgoto tratado → maior contaminação ambiental.', 'Saneamento adequado → proteção da saúde coletiva.', 'Água contaminada → menor risco de doenças.', 'Lixo acumulado → controle de animais vetores.', null,
  'B', 'Correto! Saneamento adequado protege a saúde coletiva. As outras relações apresentam causa e efeito invertidos.', 'Não foi dessa vez. Observe qual relação liga uma ação positiva a um efeito positivo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-008', c.id, 2, 'Por que o saneamento é considerado uma medida preventiva?',
  'Porque trata somente pessoas já doentes.', 'Porque substitui todas as vacinas existentes.', 'Porque reduz a exposição da população a alguns agentes causadores de doenças.', 'Porque elimina qualquer doença de uma comunidade.', null,
  'C', 'Muito bem! O saneamento é preventivo porque reduz a exposição da população a agentes causadores de doenças, antes que as pessoas adoeçam.', 'Quase! Prevenir é agir antes da doença. Como o saneamento faz isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-009', c.id, 2, 'Microrganismos presentes em água contaminada:',
  'são sempre benéficos aos seres humanos.', 'são todos visíveis sem microscópio.', 'podem incluir organismos capazes de provocar doenças.', 'desaparecem imediatamente ao entrar na água.', null,
  'C', 'Correto! Na água contaminada podem existir microrganismos capazes de provocar doenças, e muitos só aparecem ao microscópio.', 'Não foi dessa vez. Nem todo microrganismo é inofensivo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-010', c.id, 2, 'Uma comunidade apresenta esgoto a céu aberto próximo às casas. Qual intervenção atua mais diretamente sobre a origem do problema?',
  'Distribuir somente medicamentos aos moradores.', 'Melhorar a coleta e o tratamento do esgoto.', 'Fechar as janelas de todas as residências.', 'Suspender todas as atividades físicas.', null,
  'B', 'Isso mesmo! Melhorar a coleta e o tratamento do esgoto resolve a origem do problema, e não só os sintomas.', 'Quase! Qual medida ataca a causa do esgoto a céu aberto? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-011', c.id, 2, 'A presença de saneamento adequado demonstra que saúde:',
  'depende somente de consultas médicas.', 'é determinada exclusivamente pela genética.', 'também depende das condições ambientais e sociais.', 'não possui relação com políticas públicas.', null,
  'C', 'Correto! Saneamento mostra que a saúde também depende das condições ambientais e sociais, e das políticas públicas.', 'Não foi dessa vez. A saúde não depende só de consultas ou da genética. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-012', c.id, 2, 'Qual atitude NÃO contribui para a proteção da água?',
  'Destinar corretamente os resíduos.', 'Tratar adequadamente o esgoto.', 'Descartar resíduos diretamente nos córregos.', 'Evitar a contaminação das fontes de água.', null,
  'C', 'Exato! Jogar resíduos direto nos córregos polui a água e não ajuda a protegê-la. As demais atitudes ajudam.', 'Quase! Atenção: a pergunta pede a atitude que NÃO ajuda. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-013', c.id, 2, 'Uma doença associada à água contaminada pode atingir muitas pessoas de uma região. Esse exemplo mostra a importância:',
  'somente da saúde individual.', 'da saúde pública e do saneamento.', 'exclusivamente dos hospitais.', 'apenas da prática esportiva.', null,
  'B', 'Muito bem! Uma doença ligada à água contaminada pode atingir muita gente, e isso mostra a importância da saúde pública e do saneamento.', 'Não foi dessa vez. Quando muita gente adoece pela mesma causa, o assunto é coletivo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-014', c.id, 2, 'Água transparente é necessariamente própria para consumo?',
  'Sim, porque microrganismos alteram sempre a cor.', 'Sim, se não apresentar cheiro desagradável.', 'Não, porque contaminantes podem estar presentes sem serem visíveis.', 'Não, porque nenhuma água transparente é potável.', null,
  'C', 'Correto! Água transparente pode conter contaminantes invisíveis. Só o tratamento e análises garantem que é segura.', 'Quase! Cor e cheiro nem sempre mostram a contaminação. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-015', c.id, 2, 'Qual sequência representa melhor uma possível cadeia de risco?',
  'Tratamento de esgoto → contaminação → doença.', 'Saneamento → água contaminada → prevenção.', 'Esgoto sem tratamento → contaminação ambiental → maior risco de doenças.', 'Limpeza urbana → proliferação de vetores → prevenção.', null,
  'C', 'Isso mesmo! Esgoto sem tratamento leva à contaminação ambiental e aumenta o risco de doenças: é uma cadeia de risco.', 'Não foi dessa vez. Procure a sequência que mostra causa, consequência e risco de doença. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-016', c.id, 2, 'Por que preservar os rios é também uma questão de saúde?',
  'Porque rios existem somente para atividades recreativas.', 'Porque a qualidade ambiental e da água influencia a saúde das comunidades.', 'Porque a água dos rios não interage com outros ambientes.', 'Porque todo rio fornece água diretamente para consumo.', null,
  'B', 'Correto! A qualidade da água e do ambiente influencia a saúde das comunidades. Cuidar dos rios é cuidar de pessoas.', 'Quase! Pense em como o rio se liga à saúde de quem vive perto dele. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-017', c.id, 2, 'Jogar lixo em um rio pode:',
  'melhorar a qualidade da água.', 'aumentar naturalmente sua potabilidade.', 'favorecer poluição e problemas ambientais.', 'impedir qualquer proliferação de vetores.', null,
  'C', 'Isso mesmo! Lixo no rio favorece poluição e problemas ambientais, prejudicando seres vivos e pessoas.', 'Não foi dessa vez. O que o lixo causa na água? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-018', c.id, 2, 'Qual ação contribui para a preservação dos rios?',
  'Descartar óleo diretamente na água.', 'Lançar esgoto sem tratamento.', 'Abandonar resíduos nas margens.', 'Dar aos resíduos uma destinação adequada.', null,
  'D', 'Boa! Dar destino adequado aos resíduos evita a poluição e protege os rios.', 'Quase! Qual ação cuida do rio, em vez de poluí-lo? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-019', c.id, 2, 'Um rio poluído pode afetar:',
  'somente os peixes.', 'exclusivamente os seres humanos.', 'diferentes seres vivos e o equilíbrio ambiental.', 'apenas as plantas aquáticas.', null,
  'C', 'Correto! Um rio poluído afeta diferentes seres vivos e o equilíbrio ambiental, como uma teia ligada.', 'Não foi dessa vez. A poluição não atinge só um grupo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-020', c.id, 2, 'Meio ambiente e saúde humana:',
  'são assuntos completamente independentes.', 'estão relacionados de diversas maneiras.', 'relacionam-se somente durante enchentes.', 'possuem relação apenas em áreas rurais.', null,
  'B', 'Muito bem! Meio ambiente e saúde humana se relacionam de várias maneiras, e não só em casos específicos.', 'Quase! Evite alternativas com “somente” ou “completamente independentes”. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-021', c.id, 2, 'A poluição da água pode aumentar:',
  'sua segurança para consumo.', 'sua quantidade de nutrientes essenciais.', 'o risco de problemas ambientais e de saúde.', 'a eficiência natural do saneamento.', null,
  'C', 'Correto! Poluição da água aumenta os riscos ambientais e à saúde.', 'Não foi dessa vez. Poluir deixa a água mais segura ou mais arriscada? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-022', c.id, 2, 'Participar de um mutirão de limpeza das margens de um rio é uma ação:',
  'exclusivamente recreativa.', 'relacionada apenas à estética.', 'de cuidado ambiental e comunitário.', 'sem qualquer relação com saúde.', null,
  'C', 'Isso mesmo! Participar de mutirões de limpeza é uma ação de cuidado ambiental e comunitário, com benefícios para a saúde de todos.', 'Quase! Mutirão é mais do que lazer ou estética. Qual o valor dele? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-023', c.id, 2, 'Se uma fábrica ou residência despeja resíduos inadequadamente no rio, o problema:',
  'permanece restrito ao ponto do descarte.', 'pode produzir consequências em outras partes do ambiente.', 'desaparece assim que o resíduo entra na água.', 'não pode afetar nenhum organismo aquático.', null,
  'B', 'Correto! Resíduos despejados no rio podem causar consequências em outras partes do ambiente, rio abaixo.', 'Não foi dessa vez. A água corre e leva a poluição consigo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-024', c.id, 2, 'A preservação dos rios contribui para:',
  'aumentar o descarte de resíduos.', 'eliminar a necessidade de saneamento.', 'manter o equilíbrio ambiental e proteger a água.', 'impedir todas as doenças humanas.', null,
  'C', 'Muito bem! Preservar rios mantém o equilíbrio ambiental e protege a água de que dependemos.', 'Quase! Qual benefício vem de cuidar dos rios? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-025', c.id, 2, 'Qual frase melhor representa o conceito de saúde ambiental?',
  'A saúde depende exclusivamente dos hospitais.', 'O ambiente não interfere no bem-estar humano.', 'Ambientes saudáveis contribuem para comunidades mais saudáveis.', 'Apenas ambientes urbanos interferem na saúde.', null,
  'C', 'Exato! Ambientes saudáveis contribuem para comunidades mais saudáveis: esse é o conceito de saúde ambiental.', 'Não foi dessa vez. Pense na relação entre ambiente e bem-estar. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-026', c.id, 2, 'Por que não devemos considerar um rio limpo apenas observando sua aparência?',
  'Porque toda água de rio é necessariamente tóxica.', 'Porque alguns contaminantes podem não ser percebidos visualmente.', 'Porque água limpa precisa necessariamente ser azul.', 'Porque a transparência indica presença de esgoto.', null,
  'B', 'Correto! Alguns contaminantes não são vistos a olho nu. Um rio aparentemente limpo pode estar poluído.', 'Quase! Aparência nem sempre mostra a qualidade da água. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-027', c.id, 2, 'Qual situação demonstra responsabilidade coletiva?',
  'Jogar um pequeno lixo no rio porque “não fará diferença”.', 'Esperar que apenas o governo preserve o ambiente.', 'Evitar a poluição e colaborar com a conservação dos espaços naturais.', 'Queimar resíduos ao lado do rio para evitar descartá-los na água.', null,
  'C', 'Muito bem! Responsabilidade coletiva é evitar a poluição e colaborar na conservação, sem esperar só pelos outros.', 'Não foi dessa vez. Pequenas ações somadas fazem diferença. Qual atitude é responsável? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-028', c.id, 2, 'O despejo de esgoto em rios pode prejudicar:',
  'apenas a aparência da água.', 'exclusivamente a temperatura do ambiente.', 'a qualidade da água e a saúde ambiental.', 'somente a velocidade da correnteza.', null,
  'C', 'Correto! Esgoto despejado em rios prejudica a qualidade da água e a saúde ambiental.', 'Quase! O esgoto causa danos além da aparência. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-029', c.id, 2, 'Quando protegemos um rio, podemos beneficiar:',
  'somente quem vive imediatamente ao lado dele.', 'apenas pessoas que utilizam barcos.', 'exclusivamente animais aquáticos.', 'ecossistemas e diferentes comunidades humanas.', null,
  'D', 'Isso mesmo! Proteger um rio beneficia ecossistemas e diferentes comunidades humanas, perto e longe dele.', 'Não foi dessa vez. O benefício de um rio protegido é bem amplo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N2-030', c.id, 2, 'Qual conclusão é mais adequada?',
  'Preservação ambiental não faz parte da promoção da saúde.', 'Proteger os recursos naturais também é uma forma de proteger a saúde.', 'Saúde pública está limitada aos serviços médicos.', 'Poluição da água é somente um problema visual.', null,
  'B', 'Correto! Proteger recursos naturais também protege a saúde, pois ambiente saudável e pessoas saudáveis andam juntos.', 'Quase! Qual conclusão liga meio ambiente e saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N3-001', c.id, 3, 'A esquistossomose (barriga-d''água) caracteriza-se pela inflamação do fígado e do baço causada pelo verme Schistosoma mansoni (esquistossomo). O contágio ocorre depois que larvas do verme são liberadas na água pelo caramujo do gênero Biomphalaria, seu hospedeiro intermediário, e penetram na pele humana. Após o diagnóstico, o tratamento tradicional utiliza medicamentos por via oral para matar o parasita dentro do corpo. Uma nova estratégia terapêutica baseia-se na utilização de uma vacina, feita a partir de uma proteína extraída do verme, que induz o organismo humano a produzir anticorpos para combater e prevenir a doença. (IOC/Fiocruz. Fiocruz anuncia nova fase de vacina para esquistossomose, adaptado.) Uma vantagem da vacina em relação ao tratamento tradicional é que ela poderá',   -- cenário deduzido
  'impedir a penetração do parasita pela pele.', 'eliminar o caramujo para que não haja contágio.', 'impedir o acesso do esquistossomo especificamente para o fígado.', 'eliminar o esquistossomo antes que ocorra contato com o organismo.', 'eliminar o esquistossomo dentro do organismo antes da manifestação de sintomas.',
  'A', 'Correto! A vacina estimula a produção de anticorpos que atuam antes de a doença se instalar, podendo impedir a infecção já na entrada das larvas pela pele. O tratamento tradicional, ao contrário, só age depois que o parasita já está no corpo.', 'Não desanime! Compare: o remédio age depois da infecção, enquanto a vacina prepara o corpo antes. Qual alternativa descreve uma ação na porta de entrada do parasita? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CORREGO-N3-002', c.id, 3, 'Algumas toneladas de medicamentos para uso humano e veterinário são produzidas por ano. Os fármacos são desenvolvidos para serem estáveis mantendo suas propriedades químicas de forma a atender a um propósito terapêutico. Após o consumo de fármacos, parte de sua dosagem é excretada de forma inalterada, persistindo no meio ambiente. Em todo o mundo, antibióticos, hormônios, anestésicos, anti-inflamatórios, entre outros, são detectados em concentrações preocupantes no esgoto doméstico, em águas superficiais e de subsolo. Dessa forma, a ocorrência de fármacos residuais no meio ambiente pode apresentar efeitos adversos em organismos aquáticos e terrestres. (BILA, D. M.; DEZOTTI, M. Fármacos no meio ambiente. Química Nova, v. 26, n. 4, adaptado.) Qual ação minimiza a permanência desses contaminantes nos recursos hídricos?',   -- cenário deduzido
  'Utilização de esterco como fertilizante na agricultura.', 'Ampliação das redes de coleta de esgoto na zona urbana.', 'Descarte dos medicamentos fora do prazo de validade em lixões.', 'Desenvolvimento de novos processos nas estações de tratamento de efluentes.', 'Reúso dos lodos provenientes das estações de tratamento de esgoto na agricultura.',
  'D', 'Correto! Como os fármacos são estáveis e resistem aos tratamentos convencionais, é preciso desenvolver novos processos nas estações de tratamento para removê-los da água. Descartar medicamentos corretamente em pontos de coleta também ajuda.', 'Não foi dessa vez, mas você consegue! O texto diz que os fármacos são estáveis e persistem mesmo no esgoto. Qual medida atuaria justamente na remoção desses compostos? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'corrego'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── CRECHE — 1 questões (0 com cenário da equipe, 1 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'CRECHE-N1-004', c.id, 1, 'Além de lavar as mãos, qual desses também é um hábito de higiene fundamental que ajuda a manter o nosso corpo saudável e a prevenir complicações?',   -- cenário deduzido
  'Assistir televisão por muito tempo.', 'Higiene oral (escovar os dentes).', 'Comer doces antes de dormir.', 'Deixar os brinquedos espalhados pelo chão.', null,
  'B', 'Certo! A higiene oral, ou seja, escovar os dentes, também é fundamental. Dentes limpos evitam cáries e problemas na boca que podem afetar a saúde do corpo inteiro.', 'Quase! Procure o hábito que cuida do corpo, assim como lavar as mãos. Qual dessas opções é um cuidado de higiene? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'creche'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── ESCOLA — 90 questões (58 com cenário da equipe, 32 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-040', c.id, 1, 'Verdadeiro ou Falso Lavar as mãos é uma forma simples e barata de evitar que doenças graves se espalhem pelo mundo.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, muito bem! Lavar as mãos é simples, barato e evita que muitas doenças, até as mais graves, se espalhem pelo mundo. Um pequeno gesto com um grande efeito!', 'Ops! Pense: lavar as mãos só precisa de água e sabão, algo bem simples. Será que isso ajuda a evitar doenças? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-041', c.id, 1, 'Verdadeiro ou Falso Se uma pessoa apresentar uma alteração de repente na fala ou perder a força em um lado do corpo, devemos chamar o SAMU imediatamente.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, parabéns! Fala diferente de repente ou perda de força em um lado do corpo podem ser sinais de AVC, um problema sério no cérebro. Ligar rápido para o 192 faz toda a diferença.', 'Ops! Mudanças repentinas na fala ou na força do corpo são sinais de que algo sério pode estar acontecendo. Será que dá para esperar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-042', c.id, 1, 'Durante uma atividade na escola, a professora pediu que as crianças identificassem algumas partes do corpo humano. Qual alternativa apresenta apenas partes do corpo?',
  'Cabeça, tronco, braços e pernas.', 'Cabeça, coração, pulmão e pernas.', 'Braços, olhos, barriga e pés.', 'Pernas, mãos, ouvido e cabeça.', null,
  'A', 'Certo! Cabeça, tronco, braços e pernas são as grandes partes em que dividimos o corpo humano.', 'Quase! Lembre-se das grandes partes em que dividimos o corpo: a parte de cima, o meio e os membros. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-043', c.id, 1, 'que pode acontecer com uma criança que fica muito tempo sem se movimentar ou praticar esportes (vida sedentária)?',
  'Ela terá muito mais energia e força.', 'O corpo pode ficar preguiçoso e surgir problemas como falta de sono ou indisposição.', 'Nada acontece, o corpo continua igual.', 'Ela vai crescer mais rápido do que quem faz exercícios.', null,
  'B', 'Isso! Quando a criança fica muito parada, o corpo pode ficar sem disposição e podem surgir problemas como falta de sono. Brincar e se mexer fazem bem!', 'Quase! Pense no que acontece com o corpo quando ele quase não se mexe. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-044', c.id, 1, 'que significa abuso contra uma criança?',
  'Quando um adulto orienta a criança sobre algo que ela fez de errado.', 'Quando alguém ultrapassa os limites da criança e desrespeita seu corpo ou sua segurança.', 'Quando uma criança fica triste por não poder fazer algo que gostaria.', 'Quando um adulto estabelece uma regra para proteger a criança de algum perigo.', null,
  'B', 'Correto! Abuso é quando alguém ultrapassa os limites da criança e desrespeita seu corpo ou sua segurança. A culpa nunca é da criança, e ela pode pedir ajuda.', 'Quase! Dar regras para proteger a criança é cuidado, não abuso. Pense no que significa desrespeitar o corpo e a segurança de alguém. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-045', c.id, 1, 'Verdadeiro ou Falso A escola é um lugar seguro onde posso aprender a identificar situações perigosas e pedir ajuda se algo estiver errado.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! A escola é um lugar seguro, onde professores e funcionários ajudam a identificar situações perigosas e acolhem quem precisa de ajuda.', 'Ops! Pense nas pessoas da escola que cuidam de você. Será que a escola pode ser um lugar de proteção e de ajuda? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-046', c.id, 1, 'Verdadeiro ou Falso No Brasil, existe uma campanha chamada "Maio Laranja" que serve para ensinar todas as pessoas a protegerem as crianças contra o abuso.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! O Maio Laranja é uma campanha nacional que acontece em maio, no Brasil, para ensinar a proteger crianças e adolescentes contra o abuso e a exploração sexual. Todo mundo pode participar!', 'Quase! No Brasil existe uma campanha anual, ligada à cor laranja, para proteger as crianças. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-047', c.id, 1, 'Toda criança tem o direito de:',   -- cenário deduzido
  'Resolver todos os seus problemas perigosos sozinha.', 'Ser protegida contra qualquer tipo de violência e crescer em um ambiente seguro.', 'Guardar segredos que a deixam com medo para não chatear os adultos.', 'Não ter ninguém com quem conversar na escola.', null,
  'B', 'Isso! Toda criança tem direito de ser protegida contra qualquer tipo de violência e de crescer em um ambiente seguro. Esse direito está garantido no ECA.', 'Boa tentativa! Crianças têm direitos importantes, como proteção e segurança. Qual alternativa fala disso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-048', c.id, 1, 'Verdadeiro ou Falso No Brasil, o trabalho infantil é permitido porque queremos garantir que todas as crianças tenham a chance de um futuro melhor através dos estudos.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! No Brasil o trabalho infantil não é permitido, e a lei protege o direito da criança de estudar e brincar. É o estudo, e não o trabalho, que abre caminho para um futuro melhor.', 'Quase! A frase diz que o trabalho infantil é permitido. Será que isso protege as crianças? Pense no que a lei diz. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N1-049', c.id, 1, 'Quando um paciente chega à UPA com uma emergência grave e o médico percebe que ele precisará de uma cirurgia ou de internação, qual é o papel da UPA?',
  'Mandar o paciente para casa sem fazer nada.', 'Estabilizar o paciente e encaminhá-lo para o Hospital.', 'Pedir para o paciente voltar outro dia.', 'Enviar o paciente para a igreja.', null,
  'B', 'Muito bem! A UPA estabiliza o paciente, cuida da emergência e o encaminha ao hospital quando ele precisa de cirurgia ou internação.', 'Quase! A UPA cuida primeiro da urgência e depois leva o paciente para onde ele precisa. Qual é o papel dela? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-025', c.id, 2, 'Bullying envolve comportamentos de agressão ou humilhação que podem ocorrer de forma repetida ou sistemática e causar sofrimento à vítima.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, correto! Bullying é agressão ou humilhação repetida que causa sofrimento. Reconhecê-lo é o primeiro passo para combatê-lo.', 'Não foi dessa vez. Pense em agressões e humilhações que se repetem e machucam. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-026', c.id, 2, 'Cyberbullying pode ocorrer por meio de redes sociais, aplicativos de mensagens, jogos online e outras plataformas digitais.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, muito bem! O cyberbullying acontece em redes sociais, aplicativos de mensagens, jogos online e outras plataformas digitais, e também machuca de verdade.', 'Quase! O bullying também pode acontecer no ambiente digital. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-027', c.id, 2, 'Uma brincadeira deixa de ser saudável quando provoca sofrimento ou humilhação e continua mesmo depois de a pessoa demonstrar desconforto.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, isso mesmo! Brincadeira de verdade é boa para todos. Se alguém sofre e a situação continua mesmo após mostrar desconforto, deixou de ser brincadeira.', 'Não foi dessa vez. Brincadeira saudável respeita o limite do outro. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-028', c.id, 2, 'Compartilhar uma imagem íntima de alguém sem autorização pode causar danos e constituir uma forma de violência.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, correto! Compartilhar imagem íntima sem autorização é violência e pode causar danos graves, inclusive com consequências legais. Se isso acontecer, procure um adulto de confiança.', 'Quase! Divulgar imagens íntimas sem permissão viola a privacidade e machuca. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-029', c.id, 2, 'A melhor maneira de enfrentar uma situação de bullying é responder sempre com agressão física.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! Responder com agressão piora a situação. O melhor é buscar ajuda de um adulto de confiança, professores ou da direção da escola.', 'Não foi dessa vez. Violência gera mais violência. Qual caminho é mais seguro para resolver? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-030', c.id, 2, 'A cultura de paz envolve respeito, diálogo, prevenção de conflitos e valorização dos direitos humanos.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, correto! A cultura de paz valoriza respeito, diálogo, prevenção de conflitos e direitos humanos.', 'Quase! Pense no que significa construir um ambiente de paz. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-031', c.id, 2, 'Discriminação e preconceito podem produzir consequências para a saúde física e mental das pessoas.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, isso mesmo! Preconceito e discriminação podem causar sofrimento, ansiedade e prejuízos à saúde física e mental.', 'Não foi dessa vez. Ser tratado com desrespeito afeta o corpo e a mente. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-032', c.id, 2, 'Uma pessoa que sofre violência deve ser responsabilizada pela agressão que recebeu.',
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, correto! A vítima nunca é culpada pela violência sofrida. A responsabilidade é de quem agride. Quem sofre violência deve receber apoio.', 'Quase! Quem sofre violência merece proteção e acolhimento, não culpa. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-033', c.id, 2, 'Ao presenciar uma situação de violência, procurar um adulto ou serviço responsável pode ser uma forma de proteção.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, muito bem! Ao presenciar violência, procurar um adulto ou serviço responsável é uma forma de proteger quem está sofrendo. O Disque 100 recebe denúncias.', 'Não foi dessa vez. Pedir ajuda não é “dedurar”, é proteger. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-034', c.id, 2, 'Relações saudáveis podem envolver diferenças de opinião, desde que existam respeito e formas adequadas de lidar com os conflitos.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, correto! Pensar diferente é normal. Relações saudáveis lidam com divergências com respeito e diálogo.', 'Quase! Relações saudáveis admitem opiniões diferentes, desde que haja respeito. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-035', c.id, 2, 'Cuidar da própria saúde envolve reconhecer riscos, desenvolver hábitos saudáveis e saber quando procurar ajuda.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, isso mesmo! Cuidar da saúde é reconhecer riscos, ter hábitos saudáveis e procurar ajuda quando preciso. Autocuidado também é prevenção.', 'Não foi dessa vez. Cuidar da saúde vai além de ir ao médico só quando adoece. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N2-036', c.id, 2, 'Saúde integral considera somente a ausência de doenças físicas.',
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! Saúde integral envolve o bem-estar físico, mental, emocional e social, e não apenas a ausência de doenças.', 'Quase! A saúde tem várias dimensões, não só a física. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-001', c.id, 3, 'Dengue, zika e chikungunya são transmitidas pelo mesmo vetor, mas causadas por vírus de famílias diferentes. Essa informação explica por que:',
  'Uma pessoa pode ser infectada por mais de uma dessas arboviroses ao longo da vida, pois a imunidade a uma não protege contra as outras', 'As três doenças são exatamente a mesma, com nomes diferentes', 'Só é possível contrair uma delas uma única vez na vida', 'A vacina contra uma delas protege automaticamente contra as demais', 'Essas doenças possuem os mesmos sintomas, mesmo sendo causadas por diferentes famílias de vírus',
  'A', 'Parabéns, resposta certa! Dengue, zika e chikungunya compartilham o mosquito Aedes aegypti, mas são vírus distintos: a imunidade criada contra um deles não protege contra os outros. Por isso, prevenir os criadouros do mosquito continua sendo a melhor defesa para todas.', 'Quase lá, não desanime! Pense assim: se os vírus são de famílias diferentes, os anticorpos feitos contra um deles reconhecem os outros? Releia o enunciado com essa ideia em mente e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-002', c.id, 3, 'Por que uma pessoa pode ter dengue mais de uma vez na vida?',
  'Porque a vacina não funciona', 'Porque existem quatro sorotipos diferentes do vírus da dengue', 'Porque o mosquito muda de espécie', 'Porque a dengue não gera nenhuma imunidade', 'Porque só ocorre em climas frios',
  'B', 'Muito bem! O vírus da dengue possui quatro sorotipos (DENV-1 a DENV-4). A infecção por um deles gera imunidade duradoura apenas contra aquele sorotipo, então a pessoa pode adoecer até quatro vezes.', 'Não foi dessa vez, mas você consegue! Lembre-se de que o vírus da dengue não é um só: ele aparece em variações. Pense em quantas são e no que isso muda para a imunidade, e tente de novo.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-003', c.id, 3, 'A dengue tem quatro sorotipos (DENV-1 a DENV-4). O maior risco de dengue grave costuma ocorrer:',
  'Na primeira infecção, independentemente do sorotipo', 'Em uma infecção secundária por um sorotipo diferente do da primeira infecção', 'Apenas em crianças menores de 2 anos', 'Exclusivamente em idosos, mesmo na primeira infecção', 'Exclusivamente em gestantes',
  'B', 'Excelente! Na segunda infecção por um sorotipo diferente, os anticorpos da primeira vez podem não neutralizar bem o novo vírus e favorecer formas mais graves da doença. Por isso, qualquer suspeita de dengue merece atenção médica, principalmente em quem já teve a doença.', 'Ainda não, mas vale insistir! Pense no que acontece quando o corpo já conhece um sorotipo e encontra outro diferente. Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-004', c.id, 3, 'Programas de controle biológico, como a liberação de mosquitos Aedes aegypti infectados com a bactéria Wolbachia, têm reduzido casos de dengue em algumas cidades porque:',
  'A bactéria dificulta a replicação do vírus da dengue dentro do mosquito, reduzindo sua capacidade de transmissão', 'A bactéria mata o mosquito imediatamente após a infecção', 'A Wolbachia elimina o vírus presente no sangue humano', 'A bactéria torna o mosquito estéril, sem nenhum efeito sobre o vírus', 'A Wolbachia dificulta a replicação do vírus e cessando o ciclo dentro do próprio mosquito',
  'A', 'Correto! A Wolbachia reduz a multiplicação do vírus dentro do mosquito, diminuindo sua capacidade de transmitir a dengue. Ela é passada de geração em geração entre os insetos, o que torna o método sustentável.', 'Quase! Foque no que a bactéria faz com o vírus dentro do mosquito, e não no humano nem na vida do inseto. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-005', c.id, 3, 'Qual arbovirose está mais associada a más-formações no bebê quando a mãe é infectada durante a gravidez?',
  'Dengue', 'Febre amarela', 'Malária', 'Chikungunya', 'Zika',
  'E', 'Isso mesmo! O zika vírus na gestação está associado à microcefalia e a outras alterações neurológicas no bebê, a chamada síndrome congênita do zika. Por isso gestantes devem reforçar a proteção contra o mosquito.', 'Não foi essa, mas você está aprendendo! Lembre-se da epidemia de 2015 e 2016 no Brasil, que chamou atenção para bebês nascidos com microcefalia. Qual arbovirose esteve ligada a isso? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-006', c.id, 3, 'Um levantamento epidemiológico mostra picos de chikungunya, doença caracterizada por fortes dores nas articulações, coincidindo com os meses mais chuvosos do ano em uma cidade. A explicação mais adequada para esse padrão é:',
  'O acúmulo de lixo secos em terrenos baldios cria um ambiente favorável para a criação do vetor', 'O vírus só sobrevive em temperaturas baixas', 'A chuva elimina o vírus do ambiente', 'Não há relação entre pluviosidade e proliferação de vetores', 'O acúmulo de água parada nesse período amplia os criadouros do mosquito vetor',
  'E', 'Muito bom! O Aedes aegypti se reproduz em água parada, e a chuva aumenta o número de recipientes que acumulam água. Mais criadouros significam mais mosquitos e, consequentemente, mais casos.', 'Não desanime! Pense em onde o mosquito Aedes deposita seus ovos e no que a chuva provoca nesses locais. Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-007', c.id, 3, 'Por que, mesmo com vacina eficaz e disponível, ainda ocorrem surtos de febre amarela em determinadas regiões do Brasil?',
  'Cobertura vacinal insuficiente em algumas áreas', 'A vacina deixou de existir', 'A doença não depende mais de vetores', 'A vacina provoca a doença em quem a recebe', 'Necessidade de uma vacina mais eficaz',
  'A', 'Acertou! A vacina contra febre amarela é eficaz e oferecida gratuitamente, mas surtos acontecem onde parte da população não se vacinou. Manter a cobertura vacinal alta é o que protege indivíduos e comunidades.', 'Quase! Se a vacina é eficaz e está disponível, o que pode estar faltando para que ela proteja todas as pessoas de uma região? Pense nisso e tente de novo.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-008', c.id, 3, 'Qual doença abaixo NÃO é transmitida pelo Aedes aegypti?',
  'Dengue', 'Zika', 'Malária', 'Febre amarela urbana', 'Chikungunya',
  'C', 'Perfeito! A malária é transmitida por mosquitos do gênero Anopheles e é causada por protozoários do gênero Plasmodium. Já dengue, zika, chikungunya e febre amarela urbana são transmitidas pelo Aedes aegypti.', 'Não foi dessa vez, mas você consegue! Atenção ao “NÃO” no enunciado: procure a doença que tem outro mosquito como vetor e é causada por um protozoário. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-009', c.id, 3, 'As vacinas de RNA mensageiro (como as usadas contra a covid-19) agem por meio de:',
  'Injetar o vírus vivo diretamente na corrente sanguínea para ter contato com o sistema imune', 'Instruir células do próprio corpo a produzir temporariamente uma proteína viral, estimulando resposta imune sem causar a doença', 'Eliminar diretamente o vírus presente no ambiente', 'Não têm nenhum mecanismo de ação comprovado', 'Alterar permanentemente o DNA das células humanas, para que acrescentem uma proteína que deixem a pessoa totalmente imune',
  'B', 'Isso aí! O RNA mensageiro entrega às células a instrução para fabricar uma proteína viral por pouco tempo, e o sistema imune aprende a reconhecê-la. O RNAm não entra no núcleo nem altera o DNA.', 'Quase lá! Lembre-se de que a vacina de RNAm não contém o vírus inteiro e não modifica o DNA. Ela entrega uma instrução temporária às células. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-010', c.id, 3, 'A maior incidência de hepatite A em regiões com saneamento precário se explica porque:',
  'A hepatite A é transmitida só por transfusão de sangue', 'As três hepatites têm exatamente a mesma via de transmissão', 'A hepatite A não tem relação com condições sanitárias, sendo exclusiva de fatores internos', 'A hepatite A é transmitida apenas por contato sexual', 'A hepatite A é transmitida por via fecal-oral, dependendo diretamente da qualidade d’água e dos alimentos',
  'E', 'Correto! A hepatite A se espalha pela via fecal-oral, por água e alimentos contaminados. Saneamento básico, higiene das mãos e vacinação são as principais formas de prevenção.', 'Não foi essa, mas siga firme! Pense em como a hepatite A chega ao organismo e no papel da água e dos alimentos nisso. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-011', c.id, 3, 'A erradicação da circulação do vírus selvagem da poliomielite no Brasil dependeu, sobretudo, de:',
  'Décadas de cobertura vacinal ampla e sustentada na população infantil', 'Melhorias exclusivas no tratamento de pacientes já paralisados', 'Uso de antibióticos em larga escala para acabar com os casos', 'Isolamento geográfico do país', 'Uma mutação natural que enfraqueceu o vírus durante seu ciclo de vida',
  'A', 'Muito bem! A vacinação em massa das crianças, mantida por décadas, interrompeu a circulação do poliovírus selvagem no Brasil. O sucesso depende de manter as coberturas altas para evitar o retorno da doença.', 'Quase! Lembre-se de que a poliomielite é causada por um vírus, então antibióticos não resolvem, e que não existe tratamento que cure a paralisia. Qual medida preventiva foi decisiva? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-012', c.id, 3, 'O período de incubação da raiva, que pode durar dias a meses, é importante porque:',
  'Torna inútil qualquer vacinação após a exposição pois a doença some por conta própria', 'Permite que a vacinação pós-exposição, aplicada logo após a mordida, ainda seja capazde gerar imunidade a tempo de evitar a doença', 'Significa que a doença nunca é fatal, o indivíduo não terá a doença manifestada', 'Elimina a necessidade de atendimento médico após mordidas suspeitas', 'Faz com que a vacina só funcione antes da mordida, perdendo seu efeito após o contato direto com a raiva.',
  'B', 'Acertou! Como o vírus da raiva demora a chegar ao sistema nervoso, há uma janela de tempo para a profilaxia pós-exposição (vacina e, quando indicado, soro). A raiva é quase sempre fatal depois que os sintomas aparecem, por isso procurar atendimento logo após a mordida é essencial.', 'Não desanime! Pense no que a demora do vírus para causar sintomas permite fazer logo depois da mordida. Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-013', c.id, 3, 'A latência do HPV, que pode durar anos, reforça a importância de:',
  'Rastreamento apenas quando surgem sintomas evidentes', 'Interromper o acompanhamento após a vacinação', 'Rastreamento periódico, mesmo sem sintomas', 'Vacinar apenas pessoas já infectadas', 'Evitar qualquer exame até os 40 anos',
  'C', 'Excelente! O HPV pode permanecer sem sintomas por muitos anos, e lesões que levam ao câncer de colo do útero também evoluem em silêncio. Por isso o exame preventivo periódico é fundamental, mesmo para quem se vacinou.', 'Quase! Se o vírus pode ficar anos sem dar sinais, esperar sintomas é uma boa estratégia? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-014', c.id, 3, 'A imunidade de rebanho, buscada em campanhas de vacinação contra o sarampo, depende de:',
  'Apenas um pequeno grupo de pessoas vacinadas', 'Vacinação exclusiva de idosos', 'Nenhuma relação com a cobertura vacinal populacional', 'Vacinação apenas de quem já teve a doença', 'Uma alta proporção de pessoas vacinadas na população',
  'E', 'Correto! Quando muitas pessoas estão imunizadas, o vírus encontra poucos suscetíveis e a transmissão diminui, protegendo também quem não pode se vacinar. No sarampo, que é muito contagioso, é preciso manter a cobertura em torno de 95%.', 'Não foi dessa vez, mas continue! Imagine o vírus tentando passar de pessoa em pessoa: quando ele encontra mais barreiras? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-015', c.id, 3, 'A necessidade de atualização anual da vacina contra a gripe se deve a:',
  'O vírus da gripe nunca sofrer mutações', 'A vacina perder efeito por motivos não relacionados ao vírus', 'Mutações frequentes no vírus influenza, que alteram os subtipos circulantes a cada temporada', 'Não haver diferença nenhuma entre os vírus da gripe e do sarampo, outras vacinas também imunizam contra a gripe', 'A gripe deixar de existir a cada ano, surgindo uma nova gripe anualmente',
  'C', 'Muito bem! O vírus influenza muda com frequência, e a vacina é reformulada a cada ano para proteger contra as cepas mais prováveis. Por isso vale se vacinar todos os anos.', 'Quase lá! O ponto-chave é o comportamento do vírus influenza ao longo do tempo. Ele muda ou permanece sempre igual? Releia e Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-016', c.id, 3, 'A hepatite C crônica pode evoluir silenciosamente para cirrose e câncer de fígado. Isso reforça a importância de:',
  'Aguardar o surgimento de sintomas para buscar diagnóstico', 'Não existir necessidade de acompanhamento nesses casos', 'A doença nunca evoluir sem tratamento', 'Diagnóstico precoce por exames, mesmo na ausência de sintomas', 'Tratar apenas quando surgir cirrose',
  'D', 'Acertou! Como a hepatite C costuma ser silenciosa, só o teste revela a infecção. Hoje existe tratamento com alta taxa de cura, e quanto mais cedo o diagnóstico, menores os riscos de cirrose e câncer.', 'Não foi essa, mas você consegue! Se a doença evolui sem avisar, como é possível descobri-la a tempo? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-017', c.id, 3, 'Antibióticos não têm efeito contra infecções virais porque:',
  'Vírus e bactérias possuem estrutura celular idêntica', 'Antibióticos eliminam qualquer tipo de patógeno, incluindo vírus', 'Atuam sobre estruturas e processos típicos de células bacterianas, ausentes nos vírus', 'Não existe diferença biológica entre vírus e bactérias', 'Os vírus produzem suas próprias enzimas de defesa contra antibióticos',
  'C', 'Correto! Os antibióticos atacam alvos específicos das bactérias, como a parede celular e os ribossomos bacterianos, que os vírus não possuem. Por isso gripe e resfriado não se tratam com antibiótico.', 'Não desanime! Lembre-se de que vírus não são células e não têm parede celular nem metabolismo próprio. Em que os antibióticos atuam? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-018', c.id, 3, 'Durante enchentes, o risco de leptospirose aumenta principalmente devido a:',
  'Exposição prolongada dessa água no sol, por promover a proliferação bacteriana', 'Contato com mosquitos que picam roedores, atuando como vetores secundários', 'Contato com poeira doméstica', 'Contato com água contaminada pela urina de roedores infectados', null,
  'D', 'Muito bem! A bactéria Leptospira é eliminada na urina de roedores e, nas enchentes, se espalha na água e na lama, penetrando pela pele, principalmente se houver feridas. Evite contato com a água de enchente e procure atendimento se tiver febre depois.', 'Quase! Pense em quem elimina a bactéria da leptospirose e no que a enchente faz com esse material. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-019', c.id, 3, 'A meningite bacteriana costuma exigir tratamento mais urgente do que a viral porque:',
  'Tem potencial de evoluir rapidamente para quadros graves, incluindo sequelas neurológicas e risco de morte', 'Não apresenta risco à vida do paciente, porém exige análise mais profunda da doença por deixar sequelas', 'É sempre mais branda que a meningite viral', 'Não exige diagnóstico diferenciado', 'Melhora sozinha em poucas horas, sem tratamento',
  'A', 'Perfeito! A meningite bacteriana pode piorar em poucas horas e causar sequelas ou morte, por isso o tratamento com antibióticos deve começar o mais rápido possível. A meningite viral costuma ter evolução mais branda.', 'Não foi essa, mas siga em frente! Compare a gravidade das duas formas: qual delas pode piorar rapidamente e deixar sequelas? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-020', c.id, 3, 'Infecções urinárias recorrentes são mais frequentes em mulheres devido, entre outros fatores, a:',
  'Maior produção de urina em relação aos homens', 'Ausência natural de bactérias no sistema urinário feminino', 'Uma uretra anatomicamente mais curta, o que facilita o acesso de bactérias à bexiga', 'Uso mais frequente de vacinas específicas', 'Maior consumo de água pelas mulheres',
  'C', 'Acertou! A uretra feminina é mais curta e fica próxima à região anal, o que facilita a chegada de bactérias à bexiga. Beber água, urinar com regularidade e manter hábitos de higiene ajudam na prevenção.', 'Quase! Pense na anatomia: o que muda na uretra feminina em comparação à masculina e como isso afeta o caminho das bactérias? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-021', c.id, 3, 'O diagnóstico precoce da sífilis tem grande importância epidemiológica porque:',
  'A sífilis sempre evolui, independentemente do tratamento, aumentando a cadeia de transmissão', 'Não existe tratamento eficaz disponível', 'A infecção sempre desaparece espontaneamente', 'Evita a progressão da doença para estágios mais graves e reduz a cadeia de transmissão', 'Aumenta o risco de complicações',
  'D', 'Excelente! A sífilis tem tratamento eficaz e gratuito no SUS (penicilina). Diagnosticar cedo impede as fases graves, protege o bebê na gestação e interrompe a transmissão para outras pessoas.', 'Não foi dessa vez, mas você consegue! Lembre-se de que a sífilis tem cura quando tratada. O que o diagnóstico precoce muda na evolução da doença e na transmissão? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-022', c.id, 3, 'O estigma histórico em torno da hanseníase dificultou seu controle epidemiológico porque:',
  'A doença nunca teve tratamento disponível, historicamente levando todos os casos a óbito', 'O estigma facilitava a busca por atendimento médico', 'Não havia nenhuma forma de preconceito associada à doença', 'O estigma só existia em outros países', 'Pessoas escondiam os sintomas por medo de discriminação, atrasando o diagnóstico e tratamento',
  'E', 'Muito bem! O medo do preconceito levava pessoas a esconder as manchas e a demorar a procurar ajuda, o que atrasava o tratamento e mantinha a transmissão. Hoje a hanseníase tem cura e o tratamento é gratuito pelo SUS.', 'Quase! Pense no efeito do preconceito sobre quem tem sintomas: a pessoa procura ajuda mais rápido ou mais devagar? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-023', c.id, 3, 'Surtos de Salmonelose associados a grandes eventos costumam estar relacionados principalmente a:',
  'Falhas na manipulação, conservação ou cocção inadequada de alimentos', 'Exposição prolongada ao ar livre de alimentos crus', 'Contato com plantas ornamentais, normalmente levados por animais domésticos', 'Uso de vacinas com prazo vencido', 'Consumo de água engarrafada',
  'A', 'Correto! A Salmonella se espalha por alimentos mal conservados, mal cozidos ou manipulados sem higiene, como ovos, carnes e maionese. Em eventos com muita comida, cuidados com temperatura e higiene são essenciais.', 'Não foi essa, mas continue! Pense nos cuidados de higiene, conservação e cozimento dos alimentos servidos para muita gente. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-024', c.id, 3, 'O acesso à água tratada e ao esgotamento sanitário contribui para reduzir doenças bacterianas porque:',
  'Aumenta artificialmente a proliferação de bactérias no ambiente', 'Diminui o contato da população com água e ambientes contaminados', 'Não guarda nenhuma relação com a incidência dessas doenças', 'Substitui integralmente a necessidade de vacinação', 'Elimina a necessidade de higiene pessoal',
  'B', 'Muito bem! Água tratada e esgoto bem destinado reduzem a exposição a micro-organismos causadores de diarreias, cólera, febre tifoide e leptospirose. O saneamento é uma das medidas de saúde pública mais eficazes.', 'Quase! Pense no caminho do micro-organismo: o saneamento aproxima ou afasta as pessoas da água contaminada? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-025', c.id, 3, 'O saneamento básico é a medida mais eficaz de controle da esquistossomose porque:',
  'Elimina diretamente todos os caramujos transmissores do ambiente, dificultando a transmissão da doença', 'Não tem nenhuma relação com o ciclo do parasita', 'Impede que ovos do Schistosoma mansoni, eliminados nas fezes humanas, alcancem corpos d''água onde vivem os caramujos hospedeiros', 'Substitui completamente a necessidade de tratamento dos infectados', 'Aumenta a reprodução dos caramujos',
  'C', 'Acertou! O ciclo da esquistossomose depende de ovos nas fezes chegando à água e infectando caramujos. Com esgoto tratado, o ciclo é interrompido. O tratamento dos doentes continua importante, mas não substitui o saneamento.', 'Não desanime! Relembre o ciclo do parasita: os ovos saem nas fezes e precisam chegar à água para infectar o caramujo. O que o saneamento faz com esse caminho? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-026', c.id, 3, 'A toxoplasmose representa risco especial na gestação porque a infecção materna pode:',
  'Ser transmitida ao feto, causando complicações que variam de leves a graves, dependendo da fase da gestação', 'Não ter nenhum efeito sobre o feto, apenas sobre a gestante que pode carregar a doença para o resto da vida', 'Afetar apenas o desenvolvimento posterior da criança, sem qualquer risco gestacional, podendo acontecer má formação fetal', 'Ser transmitida somente após o parto', 'Só afetar a mãe, nunca o bebê',
  'A', 'Correto! O Toxoplasma gondii pode atravessar a placenta e causar desde alterações leves até lesões graves no bebê. Por isso o pré-natal inclui exames e orientações, como evitar carne crua e cuidar da higiene com gatos e hortaliças.', 'Quase lá! Lembre-se de que o parasita pode passar da mãe para o bebê durante a gravidez. Isso muda a importância da prevenção na gestação? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-027', c.id, 3, 'Giardíase e amebíase se diferenciam por serem causadas por:',
  'Protozoários distintos', 'Bactérias diferentes', 'Vírus diferentes', 'Fungos diferentes', null,
  'B', 'Muito bem! A giardíase é causada pela Giardia lamblia e a amebíase pela Entamoeba histolytica, dois protozoários distintos. Ambas se transmitem por água e alimentos contaminados.', 'Não foi dessa vez, mas você consegue! Giardia e Entamoeba são seres unicelulares eucariontes, parasitas intestinais. A que grupo eles pertencem? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-028', c.id, 3, 'O despejo irregular de esgoto próximo a hortas comunitárias aumenta o risco de contaminação porque:',
  'Não existe relação entre esgoto e contaminação de hortas', 'A água contaminada pode ser usada para irrigação ou infiltrar-se no solo onde os alimentos são cultivados', 'Ovos de parasitas não sobrevivem fora do corpo humano, mas podem contaminar as hortaliças', 'O esgoto elimina automaticamente qualquer parasita presente', 'As hortas urbanas nunca usam água de córregos',
  'B', 'Acertou! Ovos e cistos de parasitas, e bactérias presentes no esgoto, podem chegar às hortaliças pela água de irrigação ou pelo solo. Lavar bem e higienizar as verduras e proteger as hortas do esgoto reduz o risco.', 'Quase! Pense no caminho que o esgoto pode fazer até a horta: pela água de irrigação ou pelo solo. Esse contato aumenta ou diminui o risco? Tente de novo.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-029', c.id, 3, 'A diferença entre ansiedade pontual e transtorno de ansiedade está principalmente:',
  'No fato de a ansiedade pontual ser sempre mais intensa e duradoura', 'Não existe nenhuma diferença relevante entre as duas situações', 'Na persistência e na intensidade dos sintomas', 'Exclusivamente na idade da pessoa que apresenta os sintomas', 'No fato de o transtorno durar só um dia',
  'C', 'Correto! Sentir ansiedade antes de uma prova é normal. Quando os sintomas são intensos, persistentes e atrapalham a rotina, pode ser um transtorno e vale buscar ajuda profissional.', 'Quase! Pense em quando a ansiedade deixa de ser uma reação passageira e passa a atrapalhar a vida. O que muda: intensidade, duração ou os dois? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-030', c.id, 3, 'O cyberbullying se diferencia do bullying tradicional principalmente por:',
  'Ser sempre menos prejudicial à vítima pois é algo mais silencioso e passageiro', 'Não gerar nenhum impacto psicológico por estar em um ambiente tecnológico e não chegar a ter risco físico ou agressões verbais', 'Ocorrer exclusivamente de forma presencial, não afetando a vítima quando está em sua própria casa', 'Ter maior alcance e poder ocorrer a qualquer hora, inclusive fora do ambiente escolar, dificultando o afastamento da situação', 'Ser praticado apenas por adultos',
  'D', 'Muito bem! No ambiente digital, as ofensas se espalham rápido, ficam registradas e podem chegar à vítima a qualquer hora, até dentro de casa. Se presenciar ou sofrer cyberbullying, guarde provas e procure um adulto de confiança.', 'Não desanime! Pense no que a internet muda: o alcance, o horário e o lugar onde a agressão pode acontecer. Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-031', c.id, 3, 'O uso excessivo de telas está associado ao aumento de ansiedade e à piora do sono porque:',
  'Não guarda nenhuma relação com sono ou ansiedade', 'Melhora automaticamente a qualidade do sono', 'Reduz completamente qualquer forma de estímulo mental, deixando a mente em estado cansaço', 'Só afeta o rendimento escolar, sem interferências na qualidade do sono', 'Pode interferir em rotinas adequadas de descanso e aumentar a exposição contínua à estímulos e comparações sociais',
  'E', 'Acertou! Telas à noite atrapalham a rotina de descanso, e o fluxo constante de estímulos e comparações nas redes pode aumentar a ansiedade. Desligar os aparelhos antes de dormir ajuda o sono.', 'Quase! Pense nos estímulos contínuos das telas e no que eles fazem com o descanso e com a mente. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-032', c.id, 3, 'O burnout escolar se diferencia do estresse pontual de provas porque envolve:',
  'Exaustão física e emocional prolongada, com impacto duradouro sobre a motivação e o desempenho', 'Exatamente a mesma duração e intensidade do estresse de uma única prova, se equivalendo em diferentes situações', 'Nenhuma relação com sobrecarga contínua de atividades e apenas relacionada ao imaginário da própria pessoa', 'O burnout é manifestado exclusivamente na vida adulta, pois os jovens e adolescentes não trabalham, apenas estudam', 'Um estado de ânimo que passa em minutos',
  'A', 'Correto! O burnout resulta de sobrecarga prolongada e causa exaustão, desmotivação e queda no desempenho, e não se resolve com uma noite de descanso. Ele também pode atingir estudantes.', 'Não foi dessa vez, mas continue! Compare: o estresse de uma prova passa depois dela, e o burnout vem de um desgaste longo. Qual alternativa descreve isso? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-033', c.id, 3, 'Rodas de conversa mediadas por psicólogos contribuem para a saúde mental de jovens porque:',
  'Não têm nenhuma utilidade prática comprovada', 'Criam ambientes de confiança nos quais dificuldades emocionais podem ser expressas e identificadas precocemente', 'Substituem completamente o acompanhamento clínico de um médico em qualquer situação', 'Servem apenas como atividade recreativa, sem propósito terapêutico pois é um momento descontraído e leve', 'Só devem ser feitas quando já existe um diagnóstico prévio, antes disso as rodas de conversas não surtem o efeito esperado',
  'B', 'Muito bem! Em um espaço acolhedor, os jovens falam sobre o que sentem, percebem que não estão sozinhos e dificuldades podem ser identificadas cedo. Elas complementam, e não substituem, o cuidado clínico.', 'Quase! Pense no valor de ter um espaço seguro para falar sobre emoções. Isso ajuda a perceber problemas mais cedo? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-034', c.id, 3, 'Transtornos alimentares são compreendidos como condições multifatoriais porque envolvem:',
  'Exclusivamente fatores nutricionais, sendo necessário a busca de alimentos melhores e condizentes realidade de cada pessoa', 'Nenhuma influência emocional ou social', 'Fatores biológicos, psicológicos e sociais, e não apenas uma escolha alimentar isolada', 'Apenas características genéticas isoladas, questões sociais e psicológicas não possuem envolvimento', 'Apenas fatores hormonais isolados, sendo necessário a busca única de um endocrinologista',
  'C', 'Correto! Transtornos como anorexia e bulimia resultam da combinação de fatores biológicos, psicológicos e sociais, e não de uma simples escolha. O tratamento costuma envolver equipe multiprofissional.', 'Não desanime! “Multifatorial” quer dizer que há várias causas atuando juntas. Qual alternativa reúne mais de um tipo de fator? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-035', c.id, 3, 'A diferença entre tristeza passageira e depressão está principalmente:',
  'No fato de a tristeza passageira ser sempre mais intensa, apesar da depressão ser mais duradoura', 'Não existe diferença relevante entre as duas situações, sendo apenas nomes diferentes dadas para a mesma situação', 'A depressão é exclusivamente genética e a tristeza passageira é causada por fatores sociais', 'Na duração dos sintomas e no impacto funcional que causam na vida cotidiana da pessoa', 'No fato de a depressão durar só algumas horas',
  'D', 'Acertou! Todo mundo sente tristeza em algum momento. Na depressão, os sintomas duram semanas ou mais e prejudicam o estudo, o trabalho e as relações. Se isso estiver acontecendo, procurar ajuda é um ato de cuidado.', 'Quase! Pense em quanto tempo os sintomas duram e no quanto atrapalham o dia a dia. Releia e Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-036', c.id, 3, 'Campanhas de saúde pública enfatizam a busca por ajuda profissional diante de sofrimento persistente porque:',
  'O sofrimento psíquico sempre desaparece espontaneamente com o tempo', 'Não há benefício comprovado em buscar acompanhamento profissional', 'A busca por ajuda deve ocorrer apenas em casos extremamente graves', 'É desnecessária quando os sintomas são leves, sendo procurado apenas quando estamos em estado mais grave', 'Profissionais capacitados podem oferecer diagnóstico e tratamento adequados, favorecendo a recuperação e prevenindo agravamentos',
  'E', 'Muito bem! Profissionais de saúde mental avaliam, orientam e tratam, e quanto antes a ajuda chega, melhores as chances de recuperação. Pedir ajuda não é sinal de fraqueza.', 'Não foi essa, mas você está quase lá! Se o sofrimento continua por muito tempo, esperar passar sozinho é a melhor saída? Pense no papel do profissional e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-037', c.id, 3, 'O bullying pode gerar consequências duradouras tanto para quem sofre quanto para quem pratica porque:',
  'Está associado a sofrimento emocional na vítima e ao reforço de padrões de comportamento agressivo em quem pratica', 'Não gera nenhum impacto emocional mensurável para nenhuma das partes', 'Afeta exclusivamente o emocional da vítima, sem alterações no convívio social, reforçando ser um transtorno mental de quem é oprimido', 'É sempre interpretado apenas como brincadeira, sem consequências reais', 'Só afeta quem pratica, nunca a vítima',
  'A', 'Correto! Quem sofre bullying pode desenvolver ansiedade, depressão e isolamento, e quem pratica pode consolidar comportamentos agressivos. Por isso a prevenção deve envolver os dois lados.', 'Quase! O bullying não é só brincadeira: pense nos efeitos sobre quem sofre e também sobre quem agride. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-038', c.id, 3, 'São sinais de dependência digital:',
  'Uso equilibrado de dispositivos com horários bem definidos', 'Dificuldade de controlar o tempo de uso, isolamento social e prejuízo no sono', 'Ausência completa de qualquer alteração de rotina, a dependência não causa mudanças na vida de alguém', 'Melhora do desempenho escolar e da qualidade do sono, além da melhora no convívio social entre colegas', 'Aumento do tempo dedicado a atividades ao ar livre',
  'B', 'Muito bem! Perder o controle do tempo de uso, se isolar e dormir mal são sinais de alerta. Se perceber isso em você ou em alguém, converse com alguém de confiança e busque orientação.', 'Não desanime! Procure a alternativa que descreve prejuízos causados pelo uso exagerado, e não benefícios. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-039', c.id, 3, 'Qual é a diferença entre integração e inclusão no contexto escolar?',
  'São exatamente a mesma coisa', 'Integração é sempre melhor que inclusão, pois acolhe mais indivíduos com condições especiais', 'Na inclusão, o ambiente se adapta para acolher os estudantes, enquanto na integração espera-se que o estudante se adapte ao ambiente', 'Inclusão só se aplica a adultos que convivem com algum tipo de condição dentro do ambiente de trabalho', 'Integração não existe na educação',
  'C', 'Correto! Na inclusão, a escola muda (estrutura, métodos, atitudes) para receber todos os estudantes. Na integração, o estudante é quem precisa se ajustar ao que já existe. A inclusão é o modelo defendido hoje.', 'Quase! Pense em quem precisa mudar em cada modelo: o estudante ou o ambiente? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-040', c.id, 3, 'A hemofilia e o daltonismo são exemplos de herança recessiva ligada ao X porque:',
  'São mais frequentes em mulheres, que possuem dois cromossomos X', 'Afetam igualmente homens e mulheres, sem nenhuma diferença de frequência', 'Não têm relação alguma com os cromossomos sexuais', 'São mais frequentes em homens, já que eles possuem apenas um cromossomo X', 'Só ocorrem em mulheres, pois elas possuem dois cromossomos X e são portadoras obrigatórias',
  'D', 'Muito bem! Os homens (XY) têm só um X, então um único alelo recessivo já se manifesta. As mulheres (XX) precisam ter o alelo nos dois cromossomos para serem afetadas, por isso as duas condições são mais frequentes nos homens.', 'Não foi dessa vez, mas você consegue! Compare homens (XY) e mulheres (XX): em quem um único alelo recessivo no X aparece sem “reserva” de um segundo X? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-041', c.id, 3, 'O diabetes ilustra uma doença do sistema endócrino porque envolve:',
  'Ausência total de qualquer hormônio no organismo, sendo uma das doenças mais graves preocupantes', 'Desequilíbrio na produção ou na ação do hormônio insulina, responsável pela regulação da glicose no sangue', 'Nenhuma relação com o funcionamento do sistema endócrino', 'Fatores exclusivamente externos, sem base hormonal', 'Excesso de produção de hormônios como o glucagon e o cortisol, causando um desequilíbrio corporal',
  'B', 'Correto! O diabetes está ligado à falta de insulina (tipo 1) ou à má resposta a ela (tipo 2). Como a insulina é um hormônio produzido pelo pâncreas, o diabetes é uma doença endócrina.', 'Quase! Pense em qual hormônio controla a glicose no sangue e no que acontece quando ele falta ou não funciona bem. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-042', c.id, 3, 'Uma reação de hipersensibilidade (alergia) ocorre quando:',
  'O sistema imunológico está completamente inativo', 'Não há nenhuma participação do sistema imunológico no processo', 'A reação é causada exclusivamente por bactérias', 'O sistema imunológico reage de forma exagerada a uma substância geralmente inofensiva ao organismo', 'O sistema nervoso age no lugar do sistema imunológico, criando uma reação àquela substância',
  'D', 'Acertou! Na alergia, o sistema imune ataca como se fosse uma ameaça substâncias comuns, como pólen, poeira ou alguns alimentos. Evitar o alérgeno e buscar orientação médica são as principais medidas.', 'Não desanime! Alergia envolve o sistema imunológico em ação, e não parado. Como ele reage a algo inofensivo? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-043', c.id, 3, 'O uso inadequado de antibióticos contribui para a resistência bacteriana porque:',
  'Elimina, sem exceção, todas as bactérias presentes no organismo incluindo as mais resistentes', 'Não tem relação alguma com o processo evolutivo das populações bacterianas', 'Fortalece exclusivamente o sistema imunológico humano, sem afetar as bactérias', 'Impede totalmente que bactérias sobrevivam', 'Favorece a sobrevivência e a multiplicação de bactérias que possuem mecanismos de resistência',
  'E', 'Muito bem! O antibiótico usado de forma errada elimina as bactérias sensíveis e deixa as resistentes se multiplicarem, o que é seleção natural em ação. Usar apenas com prescrição e completar o tratamento reduz esse risco.', 'Quase! Pense em quais bactérias sobrevivem a um antibiótico usado de forma incorreta e no que elas fazem depois. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-044', c.id, 3, 'A resistência bacteriana adquirida se diferencia da natural porque:',
  'Surge com uso de antibióticos ao longo do tempo de forma errada', 'Está sempre presente desde a origem da espécie bacteriana, como a natural', 'Não guarda nenhuma relação com o uso de antibióticos', 'Ocorre exclusivamente em vírus, e não em bactérias', 'É transmitida por herança genética humana, afetando um par de alelos',
  'A', 'Correto! A resistência natural é característica da espécie desde sempre, e a adquirida surge depois, por mutações ou troca de genes, sendo favorecida pela pressão do uso de antibióticos. Por isso o uso racional desses medicamentos é tão importante.', 'Não foi dessa vez, mas continue! Pense no sentido de “adquirida”: algo que surge depois, e não que já existia desde a origem. Qual alternativa descreve isso? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-045', c.id, 3, 'É um exemplo de doença ocupacional:',
  'Uma doença determinada exclusivamente por fatores genéticos', 'Perda auditiva por exposição contínua a ruído excessivo no trabalho', 'Uma infecção transmitida por vetores em ambiente doméstico', 'Um transtorno alimentar ligado a pressão estética exercida na sociedade', 'Uma alergia sazonal a pólen',
  'B', 'Muito bem! Doença ocupacional é aquela causada ou agravada pelas condições de trabalho, como a perda auditiva induzida por ruído. O uso de protetores e a organização do ambiente ajudam a preveni-la.', 'Quase! Procure a alternativa em que a causa está diretamente ligada ao ambiente ou à atividade de trabalho. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-046', c.id, 3, 'A exposição prolongada a substâncias químicas ou esforços repetitivos no trabalho pode provocar:',
  'Nenhum efeito mensurável à saúde do trabalhador', 'Apenas desconforto passageiro, sem qualquer consequência a longo prazo', 'Doenças ocupacionais crônicas, como intoxicações ou lesões por esforço repetitivo', 'Melhora progressiva da saúde física, substituindo exercícios diários e atividades físicas', 'Fortalecimento muscular sem riscos',
  'C', 'Correto! Produtos químicos podem causar intoxicações, e movimentos repetitivos podem causar lesões como a tendinite (LER/DORT). Equipamentos de proteção, pausas e boa ergonomia são medidas essenciais.', 'Não desanime! Pense nos riscos de repetir o mesmo movimento por anos ou de lidar com substâncias tóxicas sem proteção. Eles ficam sem efeito? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-047', c.id, 3, 'As doenças neurodegenerativas, como o Alzheimer, tendem a ser progressivas porque:',
  'Se curam espontaneamente ao longo do tempo, sem necessidade de tratamento', 'Não afetam, de fato, o funcionamento do sistema nervoso', 'São causadas por um vírus que o sistema imunológico elimina naturalmente', 'Envolvem a perda gradual e contínua de neurônios e de suas conexões', 'Afetam exclusivamente pessoas jovens',
  'D', 'Acertou! Nessas doenças, os neurônios e suas conexões vão sendo perdidos aos poucos, e por isso os sintomas pioram com o tempo. O Alzheimer, por exemplo, afeta principalmente a memória e outras funções cognitivas.', 'Quase! O nome já ajuda: neurodegenerativas são doenças em que os neurônios se degeneram. O que isso significa para a evolução ao longo do tempo? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-048', c.id, 3, 'A manifestação de doenças autoimunes e metabólicas costuma envolver:',
  'Exclusivamente fatores genéticos, sem qualquer influência do ambiente', 'Exclusivamente fatores ambientais, sem qualquer predisposição genética', 'Nenhum fator de risco identificável até o momento', 'Apenas fatores hormonais isolados, sem relação genética ou ambiental', 'A interação entre fatores genéticos e fatores ambientais como os hábitos',
  'E', 'Muito bem! Em geral há uma predisposição genética que se manifesta sob influência do ambiente e dos hábitos de vida, como alimentação, sedentarismo e estresse. Por isso a prevenção continua valendo, mesmo com histórico familiar.', 'Não foi essa, mas você consegue! Evite respostas com “exclusivamente”: pense em como genes e ambiente podem atuar juntos. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-049', c.id, 3, 'Sobre os cigarros eletrônicos, qual afirmação é mais adequada?',   -- cenário deduzido
  'São constituídos apenas por vapor de água.', 'Podem liberar substâncias potencialmente nocivas e causar dependência.', 'São considerados seguros porque não utilizam folhas de tabaco.', 'Não apresentam efeitos relevantes sobre adolescentes.', null,
  'B', 'Muito bem! O vapor dos cigarros eletrônicos contém nicotina e outras substâncias tóxicas, que causam dependência e podem prejudicar os pulmões, principalmente em adolescentes. No Brasil, a venda é proibida pela Anvisa.', 'Não desanime! O “vapor” desses aparelhos é só água? Pense no que existe nos líquidos usados e nos efeitos da nicotina. Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-050', c.id, 3, 'Um adolescente recebe pressão dos amigos para experimentar uma substância. Qual resposta representa maior autonomia?',   -- cenário deduzido
  'Aceitar para evitar exclusão do grupo.', 'Experimentar somente uma pequena quantidade.', 'Recusar e manter sua decisão, buscando apoio se necessário.', 'Usar a substância apenas em ambientes considerados seguros.', null,
  'C', 'Perfeito! Dizer “não” e manter a decisão é um exemplo de autonomia, e buscar apoio de um adulto de confiança fortalece essa escolha. Amizades de verdade respeitam os limites de cada um.', 'Quase! Autonomia é decidir por si mesmo, sem se deixar levar pela pressão. Qual alternativa mostra isso? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-051', c.id, 3, 'Qual situação apresenta risco particularmente elevado?',   -- cenário deduzido
  'Utilizar transporte público após uma festa.', 'Dirigir ou pilotar após consumir bebida alcoólica.', 'Pedir a alguém sóbrio para conduzir o veículo.', 'Utilizar transporte por aplicativo para retornar para casa.', null,
  'B', 'Correto! O álcool reduz reflexos e atenção, e dirigir depois de beber é uma das principais causas de acidentes graves. Se beber, não dirija: peça a um motorista sóbrio ou use outro transporte.', 'Não foi essa, mas siga firme! Atenção: três opções são formas seguras de voltar para casa. Qual delas coloca a vida em risco? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-052', c.id, 3, 'Um amigo demonstra dificuldade para controlar o consumo de uma substância. Qual atitude é mais adequada?',   -- cenário deduzido
  'Fazer ameaças para obrigá-lo a parar.', 'Esconder a situação para evitar problemas.', 'Incentivar a busca por ajuda profissional e oferecer apoio.', 'Recomendar uma substância diferente para substituir a anterior.', null,
  'C', 'Muito bem! Acolher sem julgar e incentivar a procura por um profissional, como no CAPS ou na unidade de saúde, é a forma mais eficaz de ajudar. Ameaças e segredos costumam afastar a pessoa do tratamento.', 'Quase! Pense em uma atitude que ajude de verdade, com acolhimento e orientação profissional, em vez de ameaçar, esconder ou trocar uma substância por outra. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-053', c.id, 3, 'Qual atitude contribui para a prevenção do uso problemático de substâncias?',   -- cenário deduzido
  'Evitar qualquer conversa sobre drogas para não despertar curiosidade.', 'Utilizar medicamentos para controlar comportamentos de risco sem avaliação.', 'Basear decisões exclusivamente em experiências relatadas por colegas.', 'Desenvolver habilidades de decisão, buscar informação confiável e fortalecer redes de apoio.', null,
  'D', 'Excelente! A prevenção funciona melhor com informação de qualidade, habilidades para decidir e uma rede de apoio forte. Falar abertamente sobre o tema protege mais do que o silêncio.', 'Não desanime! Pense no que realmente protege: silêncio, remédio sem avaliação ou conselhos de colegas, ou informação confiável e apoio? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-054', c.id, 3, 'Cyberbullying pode ocorrer por meio de redes sociais, aplicativos de mensagens, jogos on-line e outras plataformas digitais.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Correto! O cyberbullying pode acontecer em qualquer ambiente digital, inclusive em jogos on-line. Se for vítima ou testemunha, guarde as provas e converse com um adulto de confiança.', 'Quase! Pense em onde as pessoas se comunicam on-line hoje: redes, mensagens, jogos... A agressão fica restrita a um único lugar? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-055', c.id, 3, 'Compartilhar uma imagem íntima de alguém sem autorização pode causar danos e constituir uma forma de violência.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Muito bem! Divulgar imagens íntimas sem consentimento causa grande sofrimento e é crime no Brasil. Respeitar a privacidade do outro é fundamental, e vítimas devem buscar apoio e denunciar.', 'Não foi dessa vez, mas você consegue! Pense no impacto de expor a intimidade de alguém sem permissão. Isso é inofensivo ou violência? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-056', c.id, 3, 'A cultura de paz envolve respeito, diálogo, prevenção de conflitos e valorização dos direitos humanos.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Correto! A cultura de paz se constrói no dia a dia, com respeito, diálogo e cuidado com os direitos de todas as pessoas. A escola é um espaço importante para praticá-la.', 'Quase! Releia os elementos citados: respeito, diálogo, prevenção de conflitos e direitos humanos. Eles combinam com a ideia de paz? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-057', c.id, 3, 'Ao presenciar uma situação de violência, procurar um adulto ou serviço responsável pode ser uma forma de proteção.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Muito bem! Pedir ajuda a um adulto de confiança ou a um serviço responsável protege a vítima e a você. Não precisa enfrentar a situação sozinho.', 'Não desanime! Em situações de violência, procurar ajuda de um adulto ou de um serviço adequado é arriscado ou protetor? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-058', c.id, 3, 'Relações saudáveis podem envolver diferenças de opinião, desde que existam respeito e formas adequadas de lidar com os conflitos.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Correto! Discordar faz parte de qualquer relação. O que torna uma relação saudável é o respeito e a capacidade de conversar e resolver conflitos sem violência.', 'Quase! Pense nas suas relações: pessoas que se respeitam nunca discordam, ou conseguem discordar com respeito? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-059', c.id, 3, 'Informações de saúde encontradas nas redes sociais devem ser consideradas verdadeiras quando possuem muitas curtidas.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Acertou! Curtidas medem popularidade, e não veracidade. Confira sempre a informação em fontes oficiais, como Ministério da Saúde, OMS e profissionais habilitados.', 'Quase! Muitas curtidas garantem que uma informação seja verdadeira? Pense em como confirmar uma informação de saúde de maneira segura. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-060', c.id, 3, 'Buscar informações em fontes oficiais e profissionais qualificados pode ajudar o adolescente a tomar decisões mais seguras.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Muito bem! Fontes oficiais e profissionais qualificados oferecem informação confiável, o que ajuda a decidir com segurança sobre a própria saúde. Buscar boa informação é um sinal de autonomia.', 'Não foi dessa vez, mas você consegue! Pense na qualidade das informações vindas de fontes oficiais e de profissionais de saúde. Elas ajudam nas decisões? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-061', c.id, 3, 'A distrofia muscular Duchenne (DMD) é uma doença causada por uma mutação em um gene localizado no cromossomo X. Pesquisadores estudaram uma família na qual gêmeas monozigóticas eram portadoras de um alelo mutante recessivo para esse gene (heterozigóticas). O interessante é que uma das gêmeas apresentava o fenótipo relacionado ao alelo mutante, isto é, DMD, enquanto a sua irmã apresentava fenótipo normal. (RICHARDS, C. S. et al. The American Journal of Human Genetics, n. 4, 1990, adaptado.) A diferença na manifestação da DMD entre as gêmeas pode ser explicada pela',   -- cenário deduzido
  'dominância incompleta do alelo mutante em relação ao alelo normal.', 'falha na separação dos cromossomos X no momento da separação dos dois embriões.', 'recombinação cromossômica em uma divisão celular embrionária anterior à separação dos dois embriões.', 'inativação aleatória de um dos cromossomos X em fase posterior à divisão que resulta nos dois embriões.', 'origem paterna do cromossomo portador do alelo mutante em uma das gêmeas e origem materna na outra.',
  'D', 'Excelente! Em cada célula das mulheres, um dos cromossomos X é inativado de forma aleatória. Se nas duas gêmeas essa inativação ocorreu depois da separação dos embriões, cada uma pode ter ficado com proporções diferentes de células com o X mutante ativo, e por isso uma manifestou a doença e a outra não.', 'Não desanime! Lembre-se de que as gêmeas monozigóticas têm o mesmo genótipo, então a diferença não está nos genes, e sim em qual X ficou ativo nas células. Pense na inativação do X e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-062', c.id, 3, 'Uma população encontra-se em equilíbrio genético quanto ao sistema ABO, em que 25% dos indivíduos pertencem ao grupo O e 16%, ao grupo A homozigotos. Considerando que: p = frequência de IA; q = frequência de IB; e r = frequência de i, espera-se encontrar: Grupo A: genótipos IAIA e IAi, frequências p² + 2pr; Grupo B: IBIB e IBi, q² + 2qr; Grupo AB: IAIB, 2pq; Grupo O: ii, r². A porcentagem de doadores compatíveis para alguém do grupo B nessa população deve ser de',   -- cenário deduzido
  '11%.', '19%.', '26%.', '36%.', '60%.',
  'D', 'Excelente! Se O = 25%, então r = 0,5; se A homozigoto = 16%, então p = 0,4; logo q = 0,1. O grupo B (q² + 2qr) é 0,01 + 0,10 = 11%, e doadores compatíveis para o grupo B são B e O: 11% + 25% = 36%.', 'Não desanime! Comece achando as frequências: r² = 0,25 dá r = 0,5, e p² = 0,16 dá p = 0,4, então q = 1 − 0,4 − 0,5 = 0,1. Doadores compatíveis para B são os grupos B e O. Some as duas frequências. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-063', c.id, 3, 'Na figura está representado o mosaicismo em função da inativação aleatória de um dos cromossomos X, que ocorre em todas as mulheres sem alterações patológicas. [A figura mostra: gameta masculino (22+X) e gameta feminino (22+X) formando o zigoto (44+XX), a blástula (44+XX) e amostras de células corporais, algumas com o cromossomo X paterno inativado e outras com o X materno inativado. A imagem original não pôde ser reproduzida aqui.] Entre mulheres heterozigotas para doenças determinadas por genes recessivos ligados ao sexo, essa inativação tem como consequência a ocorrência de',   -- cenário deduzido
  'pleiotropia.', 'mutação gênica.', 'interação gênica.', 'penetrância incompleta.', 'expressividade variável.',
  'E', 'Muito bem! Como a inativação do X é aleatória, cada mulher heterozigota pode ter proporções diferentes de células com o alelo recessivo ativo, e a doença se manifesta com intensidade variável. Isso é expressividade variável.', 'Não desanime! Como o X inativado varia de uma mulher para outra, a proporção de células afetadas muda. Que termo descreve a variação na intensidade com que um genótipo se manifesta? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-064', c.id, 3, 'Avaliação de substâncias genotóxicas. O ensaio de micronúcleos é um teste de avaliação de genotoxicidade que associa a presença de micronúcleos (pequenos núcleos que aparecem próximo aos núcleos das células) com lesões genéticas. Os micronúcleos são fragmentos de DNA encapsulados, provenientes do fuso mitótico durante a divisão celular. (DIAS, V. M. Micronúcleos em células tumorais: biologia e implicações para a tumorigênese. Dissertação de Mestrado, USP, 2006, adaptado.) Os micronúcleos se originam dos(as)',   -- cenário deduzido
  'nucléolos.', 'lisossomos.', 'ribossomos.', 'mitocôndrias.', 'cromossomos.',
  'E', 'Correto! O texto diz que os micronúcleos são fragmentos de DNA. Na divisão celular, fragmentos de cromossomos que não se ligam ao fuso ficam para trás e são encapsulados, formando os micronúcleos.', 'Quase! Releia: micronúcleos são fragmentos de DNA vindos da divisão celular. Qual estrutura contém o DNA organizado e se separa durante a mitose? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-065', c.id, 3, 'A síndrome de Down é uma alteração genética associada à trissomia do cromossomo 21, ou seja, o indivíduo possui três cromossomos 21 e não um par, como é normal. Isso ocorre pela união de um gameta contendo um cromossomo 21 com um gameta possuidor de dois cromossomos 21. Embora, normalmente, as mulheres com a síndrome sejam estéreis, em 2008, no interior de São Paulo, uma delas deu à luz uma menina sem a síndrome de Down. Sabendo disso, um jovem casal, ambos com essa síndrome, procura um médico especialista para aconselhamento genético porque querem ter um bebê. O médico informa ao casal que, com relação ao cromossomo 21, os zigotos formados serão:',   -- cenário deduzido
  'todos normais.', 'todos tetrassômicos.', 'apenas normais ou tetrassômicos.', 'apenas trissômicos ou tetrassômicos.', 'normais, trissômicos ou tetrassômicos.',
  'E', 'Excelente! Cada pessoa com trissomia produz gametas com um ou com dois cromossomos 21. Combinando os gametas do casal: 1+1 = 2 (normal), 1+2 = 3 (trissômico) e 2+2 = 4 (tetrassômico). Logo, os três tipos de zigoto são possíveis.', 'Não foi dessa vez, mas você consegue! Cada pai pode formar gametas com 1 ou com 2 cromossomos 21. Faça todas as combinações possíveis entre os gametas do casal e conte quantos cromossomos 21 cada zigoto terá. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-066', c.id, 3, 'O desenvolvimento da biotecnologia e da clonagem gênica em procariotos fez com que a produção de proteínas se tornasse mais intensa, rápida e econômica. Para a produção de hormônios, enzimas e proteínas de resistência a drogas, uma variação da técnica de reação em cadeia pela polimerase (PCR, na sigla em inglês) utiliza a enzima transcriptase reversa (RT-PCR), que sintetiza moléculas de DNA complementares a partir de fitas de RNA. Nesse contexto, essa técnica é importante para detectar genes',   -- cenário deduzido
  'expressos.', 'plasmidiais.', 'bacterianos.', 'dominantes.', 'autossômicos.',
  'A', 'Muito bem! A RT-PCR parte do RNA mensageiro para produzir cDNA. Como só existe RNAm de genes que estão sendo transcritos, a técnica detecta genes expressos em determinado momento.', 'Não foi dessa vez, mas você consegue! A transcriptase reversa trabalha com RNA, e só genes ativos geram RNAm. Qual alternativa se refere a genes que estão sendo transcritos? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-067', c.id, 3, 'A deficiência da enzima lipase ácida causa uma doença em que o portador apresenta células que não degradam colesterol esterificado nem triglicerídeos, resultando no depósito desses compostos em diversos órgãos, principalmente no fígado. (ANDERSON, R. A. et al. In Situ Localization of the Genetic Locus Encoding [...]. Genomics, n. 1, jan. 1993, adaptado.) Essa doença resulta da insuficiência funcional de qual estrutura celular?',   -- cenário deduzido
  'Lisossomos.', 'Ribossomos.', 'Mitocôndrias.', 'Peroxissomos.', 'Retículo endoplasmático liso.',
  'A', 'Correto! Os lisossomos contêm enzimas ácidas que digerem moléculas dentro da célula, como a lipase ácida. Se a enzima falta, lipídios se acumulam: é uma doença de depósito lisossômico.', 'Quase! A enzima chama-se lipase ácida e degrada lipídios dentro da célula. Qual organela é a “central de digestão” celular, com enzimas que funcionam em pH ácido? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'ESCOLA-N3-068', c.id, 3, 'Golden Rice, ou arroz dourado, é uma variedade de arroz enriquecida em betacaroteno, precursor da vitamina A. Foi desenvolvida para ajudar a combater a doença decorrente da deficiência dessa vitamina. Para a obtenção dessa variedade de arroz, foram utilizados métodos de engenharia genética. (BORÉM, A.; SANTOS, F. R. Entendendo a biotecnologia. Viçosa: UFV, 2008, adaptado.) Esse alimento contribui para diminuir a carência associada a qual doença?',   -- cenário deduzido
  'Hemofilia.', 'Escorbuto.', 'Raquitismo.', 'Cegueira noturna.', 'Anemia perniciosa.',
  'D', 'Muito bem! A vitamina A é essencial para a visão, e sua carência causa cegueira noturna e outros problemas oculares. O arroz dourado é um exemplo de alimento transgênico criado para combater essa deficiência.', 'Não desanime! O betacaroteno é precursor da vitamina A. Qual doença da lista está ligada à falta dessa vitamina e à visão? Lembre-se: escorbuto é falta de vitamina C e raquitismo, de vitamina D. Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'escola'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── FARMACIA — 42 questões (26 com cenário da equipe, 16 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-002', c.id, 1, 'Brasil foi o primeiro país do mundo a oferecer a vacina contra a dengue em seu sistema público de saúde. Você sabe qual é o nome desse sistema que cuida da saúde de todos os brasileiros?',   -- cenário deduzido
  'Farmácia Amiga.', 'Sistema Único de Saúde (SUS).', 'Clube de Vacinas.', 'Hospital de Brinquedos', null,
  'B', 'Muito bem! O SUS, Sistema Único de Saúde, cuida da saúde de todos os brasileiros e oferece atendimento, vacinas e remédios gratuitos. O Brasil foi o primeiro país do mundo a oferecer a vacina contra a dengue em um sistema público de saúde.', 'Não desista! Esse sistema tem uma sigla de três letras e é responsável por postos de saúde, vacinas gratuitas e muito mais. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-003', c.id, 1, 'que podemos encontrar e fazer em uma farmácia?',
  'É um lugar onde podemos encontrar medicamentos/vacinas e receber orientações sobre seu uso com o farmacêutico.', 'É um lugar onde qualquer pessoa pode pegar e tomar qualquer medicamento que quiser.', 'É um lugar que podemos ir se não é possível ir na UBS', 'É um lugar onde os medicamentos são vendidos sem nenhum cuidado ou orientação.', null,
  'A', 'Muito bem! Na farmácia encontramos medicamentos e vacinas e podemos receber orientações do farmacêutico sobre como usá-los.', 'Quase! A farmácia é um lugar de cuidado, com orientação, e não de pegar qualquer remédio. O que o farmacêutico faz por nós? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-004', c.id, 1, 'A mãe de Lucas chega à farmácia com dúvidas sobre como deve tomar um medicamento que foi prescrito para ela. O que o farmacêutico pode fazer?',
  'Dizer que medicamentos não precisam de orientação', 'Mandar a pessoa tomar uma quantidade maior, mesmo sem saber qual foi a prescrição', 'Trocar qualquer medicamento por outro sem considerar a prescrição', 'Orientar sobre o uso correto do medicamento e esclarecer dúvidas relacionadas ao tratamento', null,
  'D', 'Correto! O farmacêutico orienta sobre o uso correto do medicamento e esclarece dúvidas sobre o tratamento.', 'Quase! O farmacêutico é um profissional de saúde que ajuda quem tem dúvidas. Qual atitude ajuda a mãe de Lucas? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-005', c.id, 1, 'que o farmacêutico pode fazer para ajudar as pessoas?',
  'Realizar prescrição de medicamentos mesmo não sendo médico', 'Orientar sobre o uso correto de medicamentos', 'Realizar exames e consulta de rotina', 'Aplicar vacinas sem certificado de formação complementar', null,
  'B', 'Isso! O farmacêutico ajuda orientando sobre o uso correto dos medicamentos. Cada profissional de saúde tem a sua função.', 'Boa tentativa! Cada profissional tem suas funções e seus limites. O que faz parte do trabalho do farmacêutico? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-006', c.id, 1, 'Pedro quer comprar um medicamento na farmácia porque viu uma propaganda dizendo que ele pode curar rapidamente uma doença. O que seria mais seguro fazer?',
  'Comprar imediatamente porque a propaganda disse que funciona.', 'Comprar vários medicamentos para garantir que um deles funcione.', 'Conversar com um adulto e buscar orientação de um profissional de saúde antes de usar o medicamento.', 'Tomar o medicamento de um amigo que teve sintomas parecidos.', null,
  'C', 'Muito bem! Propaganda não é receita. O mais seguro é conversar com um adulto e buscar a orientação de um profissional de saúde antes de usar qualquer medicamento.', 'Quase! Remédio não deve ser tomado só porque a propaganda disse que funciona. Qual é a atitude mais segura? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-007', c.id, 1, 'farmacêutico pode fazer tudo o que um médico faz?',
  'Sim. Todos os profissionais de saúde têm exatamente as mesmas funções.', 'Não. Cada profissional possui suas próprias responsabilidades e limites de atuação.', 'Sim, porque o farmacêutico pode realizar qualquer procedimento médico.', 'Não, porque o farmacêutico não pode orientar ninguém sobre medicamentos.', null,
  'B', 'Correto! Cada profissional de saúde tem suas responsabilidades e limites de atuação. O farmacêutico não faz tudo o que o médico faz, mas eles trabalham juntos pela nossa saúde.', 'Quase! Médico, farmacêutico, enfermeiro: cada um estudou uma área. Será que todos fazem exatamente a mesma coisa? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-008', c.id, 1, 'Por que é importante conversar com o farmacêutico antes de usar um medicamento quando temos dúvidas?',
  'Porque ele pode ajudar a explicar como usar o medicamento corretamente, além de orientar sobre cuidados relacionados ao seu uso, dentro de sua área de atuação.', 'Porque o farmacêutico pode escolher qualquer medicamento para qualquer pessoa sem avaliação.', 'Porque depois de conversar com o farmacêutico não precisamos mais procurar outros profissionais de saúde.', 'Porque o farmacêutico pode substituir a prescrição médica em qualquer situação.', null,
  'A', 'Isso! Conversar com o farmacêutico ajuda a usar o medicamento corretamente e a saber os cuidados necessários, dentro da área de atuação dele.', 'Boa tentativa! O farmacêutico ajuda muito, mas não substitui o médico nem a receita. O que ele pode fazer por nós? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-009', c.id, 1, 'Ana está tomando medicamentos para melhorar sua saúde. Qual destas atitudes Ana deve ter para realizar o uso correto de medicamentos?',
  'Usar o medicamento correto, na quantidade e pelo tempo indicados para o tratamento.', 'Tomar medicamentos sempre que alguém estiver doente, mesmo sem orientação.', 'Parar o tratamento assim que a pessoa se sentir um pouco melhor.', 'Compartilhar medicamentos com familiares e amigos.', null,
  'A', 'Muito bem! Para o tratamento funcionar, usamos o medicamento certo, na quantidade e pelo tempo indicados.', 'Quase! Remédio é coisa séria. O que Ana deve fazer para usá-lo do jeito certo? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-010', c.id, 1, 'A professora de Pedro disse que ela deveria tomar um medicamento que ajudou muito sua colega quando ela estava doente. O que Pedro deve fazer?',
  'Tomar o mesmo medicamento, pois ele funcionou para sua colega.', 'Tomar uma quantidade maior para melhorar mais rápido.', 'Pedir orientação a um adulto e a um profissional de saúde antes de usar qualquer medicamento.', 'Misturar o medicamento com outro para aumentar seu efeito.', null,
  'C', 'Correto! Cada pessoa é diferente, e um remédio que ajudou uma colega pode fazer mal a outra. Antes de usar qualquer medicamento, peça orientação a um adulto e a um profissional de saúde.', 'Quase! Um remédio que funciona para uma pessoa pode não servir para outra. O que Pedro deve fazer antes de usar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-011', c.id, 1, 'Verdadeiro ou Falso: O uso nas doses e intervalos corretos garante que o medicamento funcione da forma planejada e segura.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! Tomar o medicamento nas doses e nos intervalos corretos faz com que ele funcione como planejado e com segurança.', 'Ops! Será que tomar menos ou mais do que o profissional indicou é seguro? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-012', c.id, 1, 'Verdadeiro ou Falso: Antibióticos e outros medicamentos controlados não exigem prescrição médica e dispensação orientada na farmácia.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! Antibióticos e outros medicamentos controlados exigem prescrição médica e dispensação orientada na farmácia, porque o uso errado pode fazer mal.', 'Quase! Antibióticos são remédios fortes. Será que qualquer pessoa pode usá-los sem receita? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-013', c.id, 1, 'Verdadeiro ou Falso: A distribuição gratuita e organizada de medicamentos na Atenção Primária faz parte da assistência farmacêutica do SUS.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! A distribuição gratuita e organizada de medicamentos na Atenção Primária faz parte da assistência farmacêutica do SUS, que garante acesso a remédios importantes.', 'Quase! O SUS oferece remédios gratuitos nas UBS. Isso faz parte do cuidado com a saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-014', c.id, 1, 'Por que é perigoso tomar um remédio por conta própria ou por conselho de um vizinho (automedicação)?',
  'Porque todos os remédios são iguais e não fazem efeito.', 'Porque pode causar reações ruins ou intoxicação no nosso corpo ao usar o remédio errado.', 'Porque o remédio sempre funciona melhor sem receita.', 'Porque tomar remédio sem orientação não traz nenhum risco.', null,
  'B', 'Isso! Tomar remédio por conta própria ou por conselho de vizinho pode causar reações ruins ou intoxicação. Só um profissional de saúde sabe qual remédio é certo para cada pessoa.', 'Boa tentativa! Cada remédio tem seu uso e seus riscos. O que pode acontecer se usarmos o remédio errado? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-015', c.id, 1, 'Verdadeiro ou Falso: Se a febre ou a dor passarem, você pode parar o tratamento com antibiótico antes do prazo final indicado pelo médico.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, parabéns! Mesmo que a febre ou a dor passem, é preciso tomar o antibiótico até o fim do prazo indicado pelo médico, para não deixar os microrganismos voltarem mais fortes.', 'Quase! Sentir-se melhor não quer dizer que o tratamento acabou. O que o médico orienta fazer? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-016', c.id, 1, 'Verdadeiro ou Falso: Tomar o remédio no horário certinho e na quantidade que o médico marcou ajuda o corpo a se curar com segurança.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! Tomar o remédio no horário certinho e na quantidade indicada ajuda o corpo a se curar com segurança.', 'Ops! O médico marca horário e quantidade por um motivo. Seguir essa orientação ajuda ou atrapalha? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-017', c.id, 1, 'Se o médico receitar um antibiótico por 7 dias e você se sentir melhor no 3º dia, qual é a atitude correta?',
  'Parar de tomar o remédio imediatamente e guardar o restante.', 'Continuar tomando o remédio até completar os 7 dias exatos orientados pelo médico.', 'Dobrar a quantidade do remédio para sarar mais rápido.', 'Dar o restante do remédio para um amigo que está doente.', null,
  'B', 'Muito bem! Mesmo melhorando no 3º dia, é preciso continuar tomando o remédio até completar os 7 dias, como o médico orientou.', 'Quase! O médico disse 7 dias. Melhorar antes do fim não muda o tratamento. Qual é a atitude certa? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N1-018', c.id, 1, 'Qual é o papel principal da farmácia e dos remédios na Unidade Básica de Saúde (SUS)?',
  'Vender doces e brinquedos para os pacientes.', 'Garantir a distribuição de remédios essenciais e orientar sobre como usá-los com segurança.', 'Substituir a necessidade de ir ao médico ou fazer exames.', 'Dizer que as pessoas podem tomar qualquer remédio sem receita.', null,
  'B', 'Correto! Na UBS, a farmácia garante a distribuição de remédios essenciais e orienta como usá-los com segurança.', 'Quase! A farmácia da UBS cuida dos remédios e das orientações de uso. Qual alternativa descreve o seu papel? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-001', c.id, 2, 'O que significa automedicação?',
  'Tomar medicamento exatamente como orientado.', 'Utilizar medicamentos por conta própria, sem orientação adequada.', 'Guardar medicamentos em local apropriado.', 'Conferir a validade antes de utilizá-los.', null,
  'B', 'Correto! Automedicação é usar remédios por conta própria, sem orientação adequada, o que traz riscos como intoxicação e mascarar doenças.', 'Quase! “Auto” lembra “por conta própria”. Qual alternativa descreve isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-002', c.id, 2, 'Por que medicamentos devem ser utilizados com cuidado?',
  'Porque nenhum medicamento produz efeitos no organismo.', 'Porque medicamentos servem apenas para adultos.', 'Porque seu uso inadequado pode trazer riscos à saúde.', 'Porque todos possuem exatamente a mesma função.', null,
  'C', 'Isso mesmo! O uso inadequado de medicamentos pode trazer riscos à saúde, por isso é preciso cuidado e orientação.', 'Não foi dessa vez. Todo remédio tem efeitos no corpo. Por que o cuidado é necessário? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-003', c.id, 2, 'Um amigo oferece um antibiótico que “funcionou para ele”. A atitude mais segura é:',
  'tomar metade da dose dele.', 'usar apenas por um dia.', 'tomar se os sintomas forem parecidos.', 'não utilizar o medicamento dessa forma e buscar orientação adequada.', null,
  'D', 'Muito bem! Remédio que funcionou para um amigo pode não servir para você. Busque orientação adequada e não use o antibiótico de outra pessoa.', 'Quase! Cada pessoa e situação são diferentes. Qual atitude é segura? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-004', c.id, 2, 'Respeitar os horários de um medicamento é importante porque:',
  'medicamentos funcionam apenas durante o dia.', 'o tratamento deve seguir a orientação recebida para ser utilizado corretamente.', 'qualquer atraso torna o medicamento venenoso.', 'horários só são importantes para vitaminas.', null,
  'B', 'Correto! Seguir a orientação, inclusive os horários, garante que o tratamento funcione e seja seguro.', 'Não foi dessa vez. Os horários fazem parte da orientação do tratamento. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-005', c.id, 2, 'Qual prática representa uso responsável de medicamentos?',
  'Aumentar a dose para melhorar mais rápido.', 'Compartilhar remédios com familiares.', 'Seguir as orientações dos profissionais de saúde.', 'Interromper qualquer tratamento ao primeiro sinal de melhora.', null,
  'C', 'Boa! Seguir as orientações dos profissionais de saúde é o uso responsável de medicamentos.', 'Quase! Aumentar dose, dividir remédio ou parar antes pode ser perigoso. Qual é a prática correta? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-006', c.id, 2, 'A farmácia pode participar da promoção da saúde por meio:',
  'somente da venda de produtos.', 'apenas da comercialização de cosméticos.', 'de orientações e participação em campanhas de saúde.', 'da substituição de todos os demais serviços do SUS.', null,
  'C', 'Correto! A farmácia pode orientar a população e participar de campanhas de saúde, além de vender produtos.', 'Não foi dessa vez. A farmácia faz mais que vender. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-007', c.id, 2, 'As vacinas têm como principal objetivo:',
  'substituir hábitos de higiene.', 'contribuir para a prevenção de determinadas doenças.', 'tratar qualquer infecção já instalada.', 'eliminar a necessidade de acompanhamento de saúde.', null,
  'B', 'Isso mesmo! As vacinas têm como principal objetivo contribuir para a prevenção de determinadas doenças.', 'Quase! Vacina previne, não trata uma doença já instalada. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-008', c.id, 2, 'Por que não devemos alterar a dose de um medicamento por conta própria?',
  'Porque doses maiores sempre anulam o medicamento.', 'Porque doses menores são sempre mais eficientes.', 'Porque a dose faz parte da orientação para o uso seguro do tratamento.', 'Porque todos os medicamentos possuem uma única dose possível.', null,
  'C', 'Muito bem! A dose faz parte da orientação para o uso seguro. Mais ou menos que o indicado pode causar riscos ou falhar no tratamento.', 'Não foi dessa vez. Alterar a dose por conta própria é arriscado. Por quê? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-009', c.id, 2, 'Qual atitude apresenta maior risco?',
  'Seguir a orientação recebida.', 'Conferir como o medicamento deve ser usado.', 'Respeitar os horários estabelecidos.', 'Utilizar o medicamento indicado para outra pessoa.', null,
  'D', 'Correto! Usar o medicamento indicado para outra pessoa é a atitude de maior risco.', 'Quase! A pergunta pede o maior risco. Qual atitude ignora a orientação personalizada? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-010', c.id, 2, 'Manter as vacinas em dia é importante:',
  'apenas quando a pessoa está doente.', 'somente durante a primeira infância.', 'como parte das medidas de prevenção de doenças.', 'apenas antes de viagens internacionais.', null,
  'C', 'Isso mesmo! Manter as vacinas em dia faz parte das medidas de prevenção de doenças, e vale para todas as idades.', 'Não foi dessa vez. Vacinar não é só para a infância nem só para viagens. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-011', c.id, 2, 'Um medicamento capaz de ajudar uma pessoa:',
  'necessariamente ajudará qualquer outra pessoa.', 'pode não ser apropriado para outra situação ou pessoa.', 'pode sempre ser compartilhado entre familiares.', 'pode ser utilizado sem considerar a dose.', null,
  'B', 'Correto! O que ajuda uma pessoa pode não ser apropriado para outra, por causa de idade, peso, doenças e alergias.', 'Quase! Cada pessoa é única. Qual alternativa reconhece isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-012', c.id, 2, 'Qual situação representa prevenção?',
  'Aumentar uma dose sem orientação.', 'Utilizar medicamento de outra pessoa.', 'Manter a vacinação recomendada atualizada.', 'Misturar diferentes medicamentos por conta própria.', null,
  'C', 'Muito bem! Manter a vacinação em dia é prevenção. As outras opções são práticas arriscadas.', 'Não foi dessa vez. Qual atitude evita doenças antes de elas aparecerem? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-013', c.id, 2, 'Medicamentos e vacinas são iguais?',
  'Sim, pois ambos possuem exatamente a mesma função.', 'Não; são recursos de saúde que podem ter finalidades diferentes.', 'Sim, pois ambos servem apenas para tratar doenças.', 'Não, porque vacinas não possuem relação com prevenção.', null,
  'B', 'Correto! Medicamentos e vacinas são recursos de saúde com finalidades diferentes: um trata e outro previne.', 'Quase! Eles se complementam, mas não são iguais. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-014', c.id, 2, 'A frase “se vende na farmácia, posso usar sem cuidado” está:',
  'correta para qualquer produto.', 'correta apenas para adolescentes.', 'incorreta, pois produtos de saúde também exigem uso responsável.', 'correta se outra pessoa já tiver usado.', null,
  'C', 'Isso mesmo! Mesmo vendido na farmácia, todo produto de saúde exige uso responsável e orientado.', 'Não foi dessa vez. Vender na farmácia não significa que é livre de risco. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N2-015', c.id, 2, 'Qual princípio resume melhor o cenário Farmácia?',
  'Quanto mais medicamentos, melhor a saúde.', 'Medicamentos substituem medidas preventivas.', 'Medicamentos podem ser úteis, mas seu uso precisa ser seguro e orientado.', 'Todo problema de saúde pode ser resolvido com remédios.', null,
  'C', 'Correto! Medicamentos podem ser úteis, mas seu uso precisa ser seguro e orientado.', 'Quase! Qual princípio equilibra benefício e cuidado? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-001', c.id, 3, 'O surgimento de “superbactérias” está diretamente relacionado a:',   -- cenário deduzido
  'Uso correto e criterioso de antibióticos', 'Uso inadequado e excessivo de antibióticos, que favorece, por seleção natural, a sobrevivência de bactérias resistentes', 'Ausência total de uso de antibióticos na população', 'Fatores genéticos humanos, sem relação com o uso de medicamentos', 'Vacinação em massa contra bactérias comuns, favorecendo o ambiente para as superbactérias',
  'B', 'Isso mesmo! O uso excessivo ou incorreto de antibióticos elimina as bactérias sensíveis e deixa sobreviver as resistentes, que se multiplicam. Só tome antibiótico com prescrição e siga o tratamento até o fim.', 'Quase! Pense na seleção natural: quando os antibióticos são usados de forma inadequada, quais bactérias sobrevivem? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-002', c.id, 3, 'A automedicação pode apresentar riscos porque medicamentos podem produzir efeitos adversos e interações.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Correto! Mesmo remédios comuns podem causar reações, mascarar sintomas e interagir com outros medicamentos. Use medicamentos apenas com orientação de um profissional de saúde.', 'Não desanime! Todo medicamento tem riscos além dos benefícios. Usar sem orientação pode causar problemas? Releia a frase e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-003', c.id, 3, 'Os medicamentos são rotineiramente utilizados pelo ser humano com o intuito de diminuir ou, por muitas vezes, curar possíveis transtornos de saúde. Os antibióticos são grupos de fármacos inseridos no tratamento de doenças causadas por bactérias. Na terapêutica das doenças mencionadas, alguns desses fármacos atuam',   -- cenário deduzido
  'ativando o sistema imunológico do hospedeiro.', 'interferindo na cascata bioquímica da inflamação.', 'removendo as toxinas sintetizadas pelas bactérias.', 'combatendo as células hospedeiras das bactérias.', 'danificando estruturas específicas da célula bacteriana.',
  'E', 'Correto! Os antibióticos atuam diretamente sobre as bactérias, por exemplo danificando a parede celular ou bloqueando os ribossomos bacterianos, sem afetar as células humanas. É essa seletividade que os torna úteis.', 'Quase! Pense no alvo dos antibióticos: eles agem sobre o organismo do paciente ou sobre a própria bactéria? Procure a alternativa que fala de estruturas da célula bacteriana. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-004', c.id, 3, 'A terapia celular tem sido amplamente divulgada como revolucionária, por permitir a regeneração de tecidos a partir de células novas. Entretanto, a técnica de se introduzirem novas células em um tecido, para o tratamento de enfermidades em indivíduos, já era aplicada rotineiramente em hospitais. A que técnica se refere o texto?',   -- cenário deduzido
  'Vacina.', 'Biópsia.', 'Hemodiálise.', 'Quimioterapia.', 'Transfusão de sangue.',
  'E', 'Muito bem! A transfusão de sangue introduz células novas (como hemácias e plaquetas) no organismo para tratar enfermidades, sendo uma forma antiga e rotineira de terapia celular. Doar sangue salva vidas!', 'Quase! O texto fala em introduzir células novas em um tecido. Qual dessas técnicas coloca células de outra pessoa no corpo? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-005', c.id, 3, 'O 2,4-dinitrofenol (DNP) é conhecido como desacoplador da cadeia de elétrons na mitocôndria e apresenta um efeito emagrecedor. Contudo, por ser perigoso e pela ocorrência de casos letais, seu uso como medicamento é proibido em diversos países, inclusive no Brasil. Na mitocôndria, essa substância (H+) captura, no espaço intermembranas, prótons provenientes da atividade das proteínas da cadeia respiratória, retornando-os à matriz mitocondrial. Assim, esses prótons não passam pelo transporte enzimático na membrana interna. (GRUNDLINGH, J. et al. Journal of Medical Toxicology, v. 7, 2011, adaptado.) O efeito emagrecedor desse composto está relacionado ao(à)',   -- cenário deduzido
  'obstrução da cadeia respiratória, resultando em maior consumo celular de ácidos graxos.', 'bloqueio das reações do ciclo de Krebs, resultando em maior gasto celular de energia.', 'diminuição da produção de acetil CoA, resultando em maior gasto celular de piruvato.', 'inibição da glicólise, resultando em maior absorção celular da glicose sanguínea.', 'redução da produção de ATP, resultando em maior gasto celular de nutrientes.',
  'E', 'Muito bem! Sem o fluxo de prótons pela ATP sintase, a célula produz menos ATP e precisa consumir mais nutrientes para tentar compensar, o que explica o efeito emagrecedor. Mas o DNP é perigoso e seu uso é proibido.', 'Quase! Se os prótons não passam pela enzima que produz ATP, o que acontece com a produção de energia e, para compensar, com o consumo de nutrientes? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-006', c.id, 3, 'Na indústria farmacêutica, é muito comum o emprego de substâncias de revestimento em medicamentos de uso oral, pois trazem uma série de benefícios como alteração de sabor em medicamentos que tenham gosto ruim, melhoria da assimilação do composto, entre outras ações. Alguns compostos poliméricos à base do polissacarídeo celulose são utilizados para garantir que o fármaco somente seja liberado quando em contato com soluções aquosas cujo pH se encontre próximo da faixa da neutralidade. (BORTOLINI, K. et al. Revista da Unifebe, n. 12, 2013, adaptado.) Qual é a finalidade do uso desse revestimento à base de celulose?',   -- cenário deduzido
  'Diminuir a absorção do princípio ativo no intestino.', 'Impedir que o fármaco seja solubilizado no intestino.', 'Garantir que o fármaco não seja afetado pelas secreções gástricas.', 'Permitir a liberação do princípio ativo pela ação das amilases salivares.', 'Facilitar a liberação do fármaco pela ação dos sais biliares sobre o revestimento.',
  'C', 'Correto! O estômago é muito ácido, e o revestimento só se dissolve em pH próximo do neutro, como no intestino. Assim, o fármaco atravessa o estômago protegido das secreções gástricas e é liberado no local certo.', 'Não foi dessa vez, mas você consegue! O revestimento só libera o fármaco em pH próximo da neutralidade. Qual parte do trato digestivo é muito ácida e qual é quase neutra? Pense nisso e tente de novo.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-007', c.id, 3, 'A Agência Nacional de Vigilância Sanitária (Anvisa) aprovou um produto de terapia gênica no país, indicado para o tratamento da distrofia hereditária da retina. O procedimento é recomendado para crianças acima de 12 meses e adultos com perda de visão causada pela mutação do gene humano RPE65. O produto, elaborado por engenharia genética, é composto por um vírus, no qual foi inserida uma cópia do gene normal humano RPE65 para corrigir o funcionamento das células da retina. (ANVISA. Disponível em: www.gov.br/anvisa, adaptado.) O sucesso dessa terapia advém do fato de que o produto favorecerá a',   -- cenário deduzido
  'correção do código genético para a tradução da proteína.', 'alteração do RNA ribossômico ligado à síntese da proteína.', 'produção de mutações benéficas para a correção do problema.', 'liberação imediata da proteína normal na região ocular humana.', 'expressão do gene responsável pela produção da enzima normal.',
  'E', 'Correto! O vírus funciona como transportador: leva uma cópia normal do gene para as células da retina, que passam a expressá-lo e a produzir a enzima funcional. A terapia gênica não entrega a proteína pronta, e sim o gene que a produz.', 'Quase! O vírus entrega uma cópia do gene normal. O que as células fazem com essa cópia para resolver o problema? Pense em expressão gênica. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-008', c.id, 3, 'A tecnologia de vacinas de RNA mensageiro (RNAm) é investigada há anos. Avanços científicos em genética molecular permitiram desenvolver uma vacina para controle da pandemia da covid-19 causada pelo vírus de RNA SARS-CoV-2. A vacina de RNAm tem sequências de genes do vírus. Entretanto, por ser muito instável, o RNAm deve ser recoberto por uma capa de lipídios que evita sua degradação e favorece sua ação. Dessa forma, o RNAm desempenhará sua função específica atuando no mesmo compartimento celular de sempre. (Disponível em: https://sbim.org.br, adaptado.) A imunização produzida por esse tipo de vacina é alcançada por meio da',   -- cenário deduzido
  'estimulação de leucócitos induzida pela capa lipídica contendo RNAm.', 'atuação do RNAm como sequestrador do vírus para o meio extracelular.', 'tradução do RNAm em proteína viral, desencadeando a resposta antigênica.', 'competição entre o RNAm vacinal e o RNA viral pelos sítios dos ribossomos.', 'incorporação do RNAm viral ao genoma do hospedeiro, gerando novo fenótipo.',
  'C', 'Correto! O RNAm da vacina age no citoplasma, onde os ribossomos o traduzem em proteína viral (como a espícula), e o sistema imune reage a essa proteína, criando memória imunológica sem causar a doença.', 'Quase! O texto diz que o RNAm atua “no mesmo compartimento celular de sempre”, ou seja, onde acontece a síntese de proteínas. O que os ribossomos fazem com o RNAm? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-009', c.id, 3, 'Indústrias farmacêuticas e instituições científicas têm trabalhado no desenvolvimento de diferentes vacinas contra a covid-19. Em algumas dessas vacinas, a principal estrutura antigênica é uma proteína de superfície viral chamada espícula (spike, em inglês). Essa proteína só existe em coronavírus, incluindo o SARS-CoV-2. Ela se liga a receptores de membrana específicos das células humanas por um mecanismo do tipo “chave-fechadura”. Dessa forma, os vírus entram nas células, podendo se multiplicar e acarretar a doença. (O que são vacinas? Disponível em: www.cienciaviva.pt, adaptado.) Nessas vacinas, essa proteína viral induz a',   -- cenário deduzido
  'produção de anticorpos específicos contra os vírus.', 'imunidade passiva contra o desenvolvimento da doença.', 'alteração genômica para formação da memória imunológica.', 'neutralização direta dos vírus presentes na circulação sanguínea.', 'modificação dos receptores de membrana específicos para o vírus.',
  'A', 'Muito bem! A proteína espícula funciona como antígeno: o sistema imune a reconhece e produz anticorpos específicos, além de células de memória. É imunidade ativa, que o corpo constrói por conta própria.', 'Não desanime! A espícula é o antígeno da vacina. Qual é a resposta do sistema imune quando entra em contato com um antígeno? Lembre-se de que a vacina gera imunidade ativa. Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'FARMACIA-N3-010', c.id, 3, 'A produção de vacinas exige uma sequência de procedimentos, além do cumprimento estrito de verificações de segurança. No esquema, estão demonstradas as etapas básicas realizadas para a fabricação de uma vacina utilizando a tecnologia tradicional e o efeito dela no organismo. [O esquema original não pôde ser reproduzido aqui.] O antígeno utilizado na vacina causa um efeito protetor contra o vírus porque',   -- cenário deduzido
  'mata o vírus pela ligação.', 'aglutina o vírus por associação.', 'contém imunoglobulinas de defesa.', 'induz a produção de proteínas neutralizadoras.', 'mantém a quantidade de anticorpos preexistentes.',
  'D', 'Muito bem! O antígeno da vacina não combate o vírus diretamente: ele estimula o organismo a produzir anticorpos, que são proteínas neutralizadoras, e células de memória. Assim, o corpo reage rápido se encontrar o vírus de verdade.', 'Não foi dessa vez, mas você consegue! O antígeno não é uma defesa pronta, e sim um estímulo para o corpo produzir a própria defesa. Qual alternativa descreve isso? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'farmacia'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── MERCADO — 7 questões (2 com cenário da equipe, 5 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N1-011', c.id, 1, 'Verdadeiro ou Falso O sono permite que o corpo recupere as energias e evita a sobrecarga, garantindo o bem-estar mental e físico necessário para o cérebro processar o conhecimento e memorizar o que foi estudado.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! O sono permite que o corpo recupere as energias e ajuda o cérebro a guardar o que aprendemos. Dormir bem ajuda a estudar!', 'Ops! Pense no que acontece com o corpo e com o cérebro quando a gente dorme bem. Será que isso ajuda a lembrar o que estudou? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N1-012', c.id, 1, 'Verdadeiro ou Falso: Um lanche com fruta e pão alimenta melhor o corpo do que um lanche só de salgadinho.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro! Um lanche com fruta e pão alimenta melhor o corpo do que um lanche só de salgadinho, que tem poucos nutrientes.', 'Quase! Pense em qual lanche tem alimentos de verdade e qual tem poucos nutrientes. Vamos tentar novamente!',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N2-021', c.id, 2, 'Por que é importante variar os alimentos no prato?',
  'Para deixar a comida mais bonita', 'Porque cada tipo de alimento fornece nutrientes diferentes', 'Não tem importância nenhuma', 'Só para economizar dinheiro', null,
  'B', 'Boa! Cada alimento fornece nutrientes diferentes, então variar o prato ajuda o corpo a receber tudo de que precisa.', 'Quase! Pense no que cada alimento oferece de diferente ao corpo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N3-011', c.id, 3, 'A obesidade é fator de risco central para diversas DCNT porque está associada a:',   -- cenário deduzido
  'Nenhuma relação com outras condições crônicas', 'Apenas questões estéticas, sem implicações clínicas', 'Maior propensão a diabetes tipo 2, hipertensão e doenças cardiovasculares', 'Redução do risco cardiovascular, porém causam o aumento de deficiência renal', 'Diminuição do risco de diabetes',
  'C', 'Correto! A obesidade favorece a resistência à insulina, o aumento da pressão arterial e alterações nas gorduras do sangue, elevando o risco de diabetes tipo 2 e doenças do coração. Cuidar da alimentação e da atividade física é cuidar da saúde como um todo.', 'Quase! A obesidade vai muito além da estética. Pense em quais doenças crônicas ela costuma acompanhar. Releia e Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N3-012', c.id, 3, 'Na fertilização in vitro, espermatozoides são adicionados aos gametas femininos retirados de uma mulher. Após o período de incubação, a fecundação é favorecida pela ação de enzimas. Em um procedimento realizado, observou-se que nenhum dos gametas femininos foi fertilizado e, posteriormente, verificou-se que havia sido adicionado, equivocadamente, um coquetel de inibidores das enzimas do acrossomo, no lugar de um dos nutrientes constituintes do meio de cultura. O coquetel de inibidores impediu o(a)',   -- cenário deduzido
  'formação do pronúcleo masculino.', 'início da divisão mitótica do zigoto.', 'término da segunda divisão meiótica do ovócito.', 'passagem do espermatozoide pela corona radiata e zona pelúcida.', 'fusão das membranas plasmáticas do ovócito e do espermatozoide.',
  'D', 'Muito bem! As enzimas do acrossomo digerem as camadas que envolvem o ovócito, a corona radiata e a zona pelúcida, permitindo que o espermatozoide chegue até a membrana do óvulo. Sem elas, ele não consegue atravessar essas barreiras.', 'Não desanime! Pense no papel das enzimas do acrossomo: elas digerem as camadas que protegem o ovócito. Qual alternativa fala dessa passagem? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N3-013', c.id, 3, 'O consumo exagerado de refrigerantes é preocupante, pois contribui para o aumento de casos de obesidade e diabetes. Considere dois refrigerantes enlatados, um comum e um diet, e que ambos possuam a mesma quantidade de aditivos, exceto pela presença de açúcar. O refrigerante comum contém basicamente água carbonatada e grande quantidade de açúcar; já o refrigerante diet tem água carbonatada e adoçantes, cujas massas são muito pequenas. (CAVAGIS, A. D. M.; PEREIRA, E. A.; OLIVEIRA, L. C. Química Nova na Escola, n. 3, 2014, adaptado.) Entre as duas versões apresentadas, o refrigerante comum possui',   -- cenário deduzido
  'maior densidade.', 'menor viscosidade.', 'maior volume de gás dissolvido.', 'menor massa de solutos dissolvidos.', 'maior temperatura de congelamento.',
  'A', 'Muito bem! O açúcar dissolvido aumenta a massa de soluto na mesma quantidade de líquido, o que torna o refrigerante comum mais denso. Por isso a lata de refrigerante comum afunda na água e a diet flutua!', 'Não desanime! A diferença entre as duas versões é a grande massa de açúcar do refrigerante comum. Como mais soluto dissolvido muda a densidade, a viscosidade e a temperatura de congelamento? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'MERCADO-N3-014', c.id, 3, 'Os mais antigos cozinhavam o feijão na panela de ferro a fim de acabar com a palidez de seus filhos. Alguns chegavam até a colocar um prego enferrujado nesse cozimento para liberar o ferro contido nele. Sabe-se que esse elemento pode ser encontrado na sua forma metálica ou iônica, sendo essencial para a manutenção da vida humana. As estratégias citadas eram utilizadas com o objetivo de',   -- cenário deduzido
  'tratar a diarreia.', 'prevenir a anemia.', 'evitar as verminoses.', 'remediar o raquitismo.', 'combater a febre amarela.',
  'B', 'Correto! A palidez é um sinal clássico de anemia, e o ferro é necessário para formar a hemoglobina. Cozinhar em panela de ferro acrescenta ferro à comida e ajuda a prevenir a anemia ferropriva.', 'Quase! A palidez e o mineral ferro dão uma pista: o ferro faz parte da hemoglobina do sangue. Qual doença está relacionada à falta dele? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'mercado'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── PARQUE — 15 questões (15 com cenário da equipe, 0 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-024', c.id, 2, 'Um parque pode contribuir para a saúde ao:',
  'substituir todos os serviços de saúde.', 'oferecer espaço para movimento, lazer e contato com a natureza.', 'impedir qualquer doença respiratória.', 'eliminar a necessidade de convivência social.', null,
  'B', 'Isso mesmo! Um parque oferece espaço para movimento, lazer e contato com a natureza, e faz bem à saúde.', 'Quase! Parques ajudam, mas não substituem serviços de saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-025', c.id, 2, 'Preservar áreas verdes é importante:',
  'somente para deixar a cidade bonita.', 'para o ambiente e para a qualidade dos espaços comunitários.', 'exclusivamente para os animais.', 'apenas para pessoas que praticam esportes.', null,
  'B', 'Correto! Preservar áreas verdes cuida do ambiente e da qualidade dos espaços comunitários.', 'Não foi dessa vez. Áreas verdes servem a todos, não só à beleza da cidade. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-026', c.id, 2, 'Separar corretamente o lixo ajuda:',
  'a aumentar o descarte inadequado.', 'no cuidado com o ambiente e com a comunidade.', 'somente na aparência das lixeiras.', 'a eliminar a necessidade de coleta.', null,
  'B', 'Muito bem! Separar o lixo corretamente ajuda no cuidado com o ambiente e com a comunidade.', 'Quase! Separar o lixo tem benefícios além da aparência. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-027', c.id, 2, 'Caminhar em um parque é uma forma de:',
  'permanecer sedentário.', 'realizar atividade física.', 'substituir o sono.', 'tratar qualquer doença.', null,
  'B', 'Boa! Caminhar em um parque é uma forma de atividade física.', 'Não foi dessa vez. Caminhar é movimento. Que tipo de atividade é? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-028', c.id, 2, 'O contato com espaços agradáveis pode contribuir:',
  'exclusivamente para a força muscular.', 'para o bem-estar.', 'somente para a digestão.', 'apenas para a visão.', null,
  'B', 'Correto! O contato com espaços agradáveis pode contribuir para o bem-estar.', 'Quase! Ambientes agradáveis influenciam como nos sentimos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-029', c.id, 2, 'Jogar resíduos no chão pode:',
  'melhorar o ambiente natural.', 'aumentar a segurança do espaço.', 'prejudicar o ambiente e a qualidade do espaço coletivo.', 'acelerar a decomposição de qualquer material.', null,
  'C', 'Isso mesmo! Resíduos no chão prejudicam o ambiente e a qualidade do espaço coletivo.', 'Não foi dessa vez. Lixo no chão melhora ou piora o lugar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-030', c.id, 2, 'Qual atitude demonstra cidadania ambiental?',
  'Abandonar embalagens durante uma caminhada.', 'Danificar plantas do parque.', 'Ignorar as regras de descarte.', 'Utilizar as lixeiras e preservar as áreas verdes.', null,
  'D', 'Muito bem! Usar as lixeiras e preservar as áreas verdes é cidadania ambiental.', 'Quase! Qual atitude cuida do espaço de todos? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-031', c.id, 2, 'Um parque limpo beneficia:',
  'somente quem pratica corrida.', 'exclusivamente os funcionários.', 'a comunidade e o ambiente.', 'apenas os animais que vivem nele.', null,
  'C', 'Correto! Um parque limpo beneficia a comunidade e o ambiente.', 'Não foi dessa vez. Um parque limpo faz bem a mais gente do que parece. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-032', c.id, 2, 'Saúde ambiental significa reconhecer que:',
  'natureza e seres humanos não se relacionam.', 'as condições do ambiente podem influenciar a saúde e o bem-estar.', 'somente hospitais determinam a saúde coletiva.', 'poluição é apenas um problema estético.', null,
  'B', 'Boa! Saúde ambiental é reconhecer que as condições do ambiente podem influenciar a saúde e o bem-estar.', 'Quase! Poluição não é só estética. Qual afirmação liga ambiente e saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-033', c.id, 2, 'Qual atividade combina saúde física e ambiental?',
  'Caminhar enquanto descarta embalagens no chão.', 'Fazer uma caminhada e descartar os resíduos corretamente.', 'Correr e danificar a vegetação.', 'Praticar esportes em áreas proibidas.', null,
  'B', 'Isso mesmo! Fazer uma caminhada e descartar os resíduos corretamente une saúde física e ambiental.', 'Não foi dessa vez. Procure a atividade que cuida do corpo e do ambiente. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-034', c.id, 2, 'Por que espaços públicos precisam ser cuidados coletivamente?',
  'Porque pertencem apenas aos profissionais de saúde.', 'Porque são compartilhados e seu estado pode afetar muitas pessoas.', 'Porque somente crianças utilizam esses espaços.', 'Porque limpeza não possui relação com saúde.', null,
  'B', 'Correto! Espaços públicos são compartilhados e seu estado afeta muitas pessoas, por isso o cuidado é coletivo.', 'Quase! Pense em quem usa um parque. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-035', c.id, 2, 'Áreas verdes podem incentivar atividade física porque:',
  'obrigam todas as pessoas a correr.', 'oferecem espaços onde atividades como caminhadas podem ser realizadas.', 'eliminam a necessidade de descanso.', 'substituem instalações esportivas em qualquer situação.', null,
  'B', 'Muito bem! Áreas verdes oferecem espaços onde caminhadas e outras atividades podem ser realizadas.', 'Não foi dessa vez. Parques incentivam, mas não obrigam nem substituem tudo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-036', c.id, 2, 'Um parque com lixo acumulado apresenta:',
  'somente um problema visual.', 'um problema ambiental que também pode interferir no uso saudável do espaço.', 'necessariamente uma epidemia.', 'um ambiente mais adequado aos visitantes.', null,
  'B', 'Isso mesmo! Lixo acumulado em um parque é problema ambiental e atrapalha o uso saudável do espaço.', 'Quase! Lixo é mais que um problema visual. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-037', c.id, 2, 'O cuidado com parques relaciona:',
  'somente botânica e decoração.', 'apenas atividade física.', 'meio ambiente, saúde e cidadania.', 'exclusivamente coleta seletiva.', null,
  'C', 'Correto! O cuidado com parques relaciona meio ambiente, saúde e cidadania.', 'Não foi dessa vez. Esse tema envolve mais de uma área. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PARQUE-N2-038', c.id, 2, 'Qual frase resume melhor o cenário?',
  'Saúde depende apenas do que acontece dentro do corpo.', 'Natureza e saúde são temas sem relação.', 'Cuidar dos espaços verdes também é cuidar da qualidade de vida da comunidade.', 'Parques possuem importância apenas para o lazer.', null,
  'C', 'Boa! Cuidar dos espaços verdes é também cuidar da qualidade de vida da comunidade.', 'Quase! Qual frase resume a ligação entre natureza e saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'parque'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── PRACA — 16 questões (16 com cenário da equipe, 0 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N1-009', c.id, 1, 'Verdadeiro ou Falso Se todos os vizinhos trabalharem juntos para remover recipientes que acumulam água, a chance de interromper a transmissão da dengue aumenta.',
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, muito bem! Quando todos os vizinhos eliminam a água parada, o mosquito perde os lugares onde se reproduz e a transmissão da dengue diminui. Quando a gente se une, o cuidado fica muito mais forte!', 'Ops, não foi dessa vez! Imagine um bairro em que todo mundo cuida do seu quintal. Isso ajuda ou atrapalha no combate ao mosquito? Pense mais um pouquinho. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-004', c.id, 2, 'Uma pracinha pode promover saúde porque:',
  'serve apenas para descanso.', 'favorece movimento, convivência e atividades comunitárias.', 'substitui unidades de saúde.', 'impede doenças infecciosas.', null,
  'B', 'Correto! Uma pracinha favorece movimento, convivência e atividades comunitárias, promovendo saúde.', 'Quase! Espaços públicos fazem muito mais que servir de descanso. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-005', c.id, 2, 'Em um dia muito quente, é importante:',
  'evitar qualquer ingestão de água.', 'permanecer ao sol pelo maior tempo possível.', 'manter hidratação e cuidados com a exposição ao calor.', 'utilizar roupas pesadas para aumentar a transpiração.', null,
  'C', 'Isso mesmo! Em dias quentes, mantenha a hidratação e cuide da exposição ao calor.', 'Não foi dessa vez. No calor, o corpo perde água. Como se proteger? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-006', c.id, 2, 'A transpiração participa principalmente:',
  'da produção de oxigênio.', 'dos mecanismos de regulação da temperatura corporal.', 'da digestão dos alimentos.', 'da formação dos ossos.', null,
  'B', 'Muito bem! A transpiração participa da regulação da temperatura corporal, resfriando o corpo.', 'Quase! O suor tem a ver com manter o corpo na temperatura adequada. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-007', c.id, 2, 'Por que beber água é especialmente importante durante atividades em dias quentes?',
  'Porque água impede completamente a transpiração.', 'Porque o organismo perde água, inclusive pela transpiração.', 'Porque água reduz permanentemente a temperatura do ambiente.', 'Porque o corpo deixa de produzir calor.', null,
  'B', 'Correto! O corpo perde água, inclusive pelo suor, e precisa repô-la, principalmente em dias quentes.', 'Não foi dessa vez. Pense na água perdida ao suar. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-008', c.id, 2, 'Exposição excessiva ao calor pode:',
  'ser sempre benéfica ao organismo.', 'provocar mal-estar e representar risco à saúde.', 'substituir atividades físicas.', 'impedir a perda de água corporal.', null,
  'B', 'Exato! O excesso de calor pode causar mal-estar e riscos como desidratação e insolação.', 'Quase! Calor em excesso faz bem ou mal ao corpo? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-009', c.id, 2, 'Qual atitude ajuda na proteção durante exposição ao sol?',
  'Evitar qualquer hidratação.', 'Permanecer exposto ao calor intenso por muitas horas.', 'Adotar medidas de proteção contra o sol e evitar exposição excessiva.', 'Fazer exercícios somente nos horários mais quentes.', null,
  'C', 'Boa! Medidas de proteção contra o sol e evitar exposição excessiva ajudam a prevenir problemas de saúde.', 'Não foi dessa vez. Qual atitude protege do sol e do calor? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-010', c.id, 2, 'Conversar e participar de atividades comunitárias pode contribuir:',
  'somente para a força muscular.', 'exclusivamente para a pressão arterial.', 'para aspectos sociais e emocionais da saúde.', 'apenas para a digestão.', null,
  'C', 'Correto! Conversar e participar de atividades comunitárias contribui para os aspectos sociais e emocionais da saúde.', 'Quase! Pense no efeito de estar em contato com outras pessoas. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-011', c.id, 2, 'Qual órgão atua como importante barreira entre o corpo e o ambiente?',
  'Estômago.', 'Coração.', 'Pele.', 'Pâncreas.', null,
  'C', 'Isso mesmo! A pele é uma importante barreira entre o corpo e o ambiente, protegendo contra agentes externos.', 'Não foi dessa vez. Pense no órgão que fica em contato direto com o ambiente. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-012', c.id, 2, 'Atividade física ao ar livre exige atenção:',
  'somente à velocidade do exercício.', 'às condições ambientais e aos sinais do corpo.', 'apenas à roupa utilizada.', 'exclusivamente ao tempo total de atividade.', null,
  'B', 'Muito bem! Atividade ao ar livre exige atenção às condições ambientais e aos sinais do corpo.', 'Quase! Além do exercício em si, o que mais importa ao ar livre? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-013', c.id, 2, 'Saúde comunitária aparece na pracinha quando:',
  'apenas uma pessoa utiliza o espaço.', 'o local recebe atividades e ações voltadas à população.', 'atividades sociais são proibidas.', 'o espaço é utilizado somente para exercícios intensos.', null,
  'B', 'Correto! A saúde comunitária aparece quando o espaço recebe atividades e ações voltadas à população.', 'Não foi dessa vez. Qual situação mostra o espaço sendo usado pela comunidade? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-014', c.id, 2, 'Se alguém apresenta mal-estar durante atividade sob calor intenso, o mais adequado é:',
  'incentivar a pessoa a continuar.', 'ignorar porque é sempre normal.', 'interromper a atividade e procurar ajuda adequada.', 'impedir que a pessoa beba água.', null,
  'C', 'Boa! Diante de mal-estar no calor, interrompa a atividade e procure ajuda adequada, sem insistir.', 'Quase! Ignorar o mal-estar pode ser perigoso. Qual é a atitude correta? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-015', c.id, 2, 'Qual situação combina promoção da saúde física e social?',
  'Permanecer isolado e imóvel durante todo o dia.', 'Participar de uma caminhada comunitária adequada e segura.', 'Praticar atividade intensa sem descanso no calor.', 'Evitar qualquer contato com outras pessoas.', null,
  'B', 'Isso mesmo! Uma caminhada comunitária adequada e segura combina saúde física e social.', 'Não foi dessa vez. Procure a situação que une movimento e convivência com segurança. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-016', c.id, 2, 'A sensação de sede:',
  'significa que o corpo não precisa de água.', 'ocorre apenas durante doenças.', 'pode indicar necessidade de reposição de líquidos.', 'deve sempre ser ignorada durante exercícios.', null,
  'C', 'Correto! A sede pode indicar necessidade de repor líquidos. Escute esse sinal do corpo.', 'Quase! A sede é um aviso do corpo. O que ele indica? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-017', c.id, 2, 'Por que evitar longos períodos sob calor intenso?',
  'Porque o corpo não produz calor.', 'Porque o organismo precisa manter sua temperatura dentro de limites adequados.', 'Porque a pele deixa de funcionar ao sol.', 'Porque qualquer exposição provoca doença.', null,
  'B', 'Muito bem! O organismo precisa manter a temperatura dentro de limites adequados, por isso devemos evitar longos períodos sob calor intenso.', 'Não foi dessa vez. O corpo produz calor sim, e precisa regulá-lo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'PRACA-N2-018', c.id, 2, 'O cenário Pracinha demonstra que promoção da saúde:',
  'ocorre apenas em hospitais.', 'também pode acontecer nos espaços públicos da comunidade.', 'depende exclusivamente de medicamentos.', 'é responsabilidade somente dos profissionais de saúde.', null,
  'B', 'Correto! A promoção da saúde também acontece nos espaços públicos da comunidade, não só em hospitais.', 'Quase! Saúde não se promove apenas em serviços de saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'praca'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── QUADRA — 18 questões (15 com cenário da equipe, 3 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-004', c.id, 2, 'A atividade física pode contribuir para:',
  'apenas o crescimento dos cabelos.', 'a saúde de músculos, ossos e sistema cardiovascular.', 'somente a saúde digestiva.', 'exclusivamente a capacidade de estudar.', null,
  'B', 'Correto! A atividade física contribui para a saúde de músculos, ossos e sistema cardiovascular.', 'Quase! Os benefícios do exercício vão além do cabelo ou de um só sistema. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-005', c.id, 2, 'Durante uma corrida, o coração geralmente:',
  'deixa de bombear sangue aos músculos.', 'trabalha para atender ao aumento das demandas do organismo.', 'interrompe temporariamente seus batimentos.', 'envia sangue exclusivamente aos pulmões.', null,
  'B', 'Muito bem! Durante a corrida, o coração trabalha mais para levar oxigênio e nutrientes aos músculos.', 'Não foi dessa vez. O coração não para na corrida. O que ele faz? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-006', c.id, 2, 'Praticar esportes em grupo também pode beneficiar:',
  'apenas a musculatura.', 'exclusivamente os ossos.', 'a convivência e a saúde social.', 'somente o sistema respiratório.', null,
  'C', 'Isso mesmo! Esportes em grupo também beneficiam a convivência e a saúde social.', 'Quase! Além do corpo, o esporte coletivo ajuda em outro aspecto da saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-007', c.id, 2, 'Por que a respiração costuma ficar mais rápida durante exercícios?',
  'Porque o pulmão deixa de funcionar normalmente.', 'Porque o organismo aumenta suas demandas durante a atividade.', 'Porque o sangue para de circular temporariamente.', 'Porque os músculos deixam de utilizar energia.', null,
  'B', 'Correto! Na atividade, o organismo precisa de mais oxigênio e por isso a respiração acelera.', 'Não foi dessa vez. Os pulmões e o sangue continuam trabalhando. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-008', c.id, 2, 'Qual atitude é adequada durante atividades físicas?',
  'Ignorar qualquer sinal de mal-estar.', 'Evitar beber água durante todo o dia.', 'Respeitar os limites do corpo e manter cuidados adequados.', 'Exercitar-se apenas em intensidade máxima.', null,
  'C', 'Boa! Respeitar os limites do corpo e manter cuidados, como hidratação, torna a atividade segura.', 'Quase! Ignorar sinais do corpo é perigoso. Qual atitude é segura? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-009', c.id, 2, 'Ossos e músculos:',
  'não participam dos movimentos corporais.', 'atuam em conjunto na realização de movimentos.', 'possuem exatamente a mesma estrutura.', 'funcionam sem participação do sistema nervoso.', null,
  'B', 'Correto! Ossos e músculos atuam em conjunto para produzir movimentos, coordenados pelo sistema nervoso.', 'Não foi dessa vez. Eles trabalham juntos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-010', c.id, 2, 'A prática regular de atividades físicas:',
  'garante que uma pessoa nunca fique doente.', 'é um dos fatores que podem contribuir para uma vida saudável.', 'substitui alimentação e sono adequados.', 'precisa ser sempre competitiva.', null,
  'B', 'Isso mesmo! A atividade física regular é um dos fatores que contribuem para uma vida saudável, mas não garante que nunca adoeça.', 'Quase! Ela ajuda, mas não substitui sono e alimentação. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-011', c.id, 2, 'Qual sistema transporta oxigênio e nutrientes pelo corpo?',
  'Sistema tegumentar.', 'Sistema digestório isoladamente.', 'Sistema cardiovascular.', 'Sistema esquelético.', null,
  'C', 'Muito bem! O sistema cardiovascular (coração e vasos) transporta oxigênio e nutrientes pelo corpo.', 'Não foi dessa vez. Pense no sistema que tem coração e vasos sanguíneos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-012', c.id, 2, 'Uma partida esportiva envolve diferentes sistemas corporais. Isso demonstra que:',
  'cada sistema funciona completamente isolado.', 'os sistemas do organismo trabalham de maneira integrada.', 'somente os músculos são necessários para movimentos.', 'o coração não participa do exercício físico.', null,
  'B', 'Correto! Os sistemas do corpo trabalham de forma integrada, e por isso uma partida envolve vários deles ao mesmo tempo.', 'Quase! Nenhum sistema funciona isolado. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-013', c.id, 2, 'Além de benefícios físicos, movimentar-se pode:',
  'impedir qualquer emoção negativa.', 'contribuir para o bem-estar e o humor.', 'substituir o convívio social.', 'eliminar a necessidade de descanso.', null,
  'B', 'Isso mesmo! Movimentar-se pode contribuir para o bem-estar e o humor, embora não impeça emoções negativas.', 'Não foi dessa vez. Cuidado com “impedir qualquer” ou “substituir”. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-014', c.id, 2, 'O que acontece com os músculos durante muitos movimentos?',
  'Permanecem completamente imóveis.', 'Realizam contrações que contribuem para o movimento.', 'Transformam-se temporariamente em ossos.', 'deixam de receber sangue.', null,
  'B', 'Correto! Os músculos se contraem para gerar movimento, como o bíceps ao dobrar o braço.', 'Quase! Pense no que os músculos fazem quando nos movimentamos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-015', c.id, 2, 'Um adolescente passa a maior parte do tempo sentado. Uma mudança saudável seria:',
  'abandonar todas as atividades escolares.', 'praticar exercício intenso sem preparação.', 'incorporar mais movimento e atividades adequadas à rotina.', 'dormir menos para ter tempo de se exercitar.', null,
  'C', 'Boa! Incorporar mais movimento adequado à rotina é uma mudança saudável e possível de manter.', 'Não foi dessa vez. Evite atitudes radicais, como treinar sem preparo ou dormir menos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-016', c.id, 2, 'Por que atividades coletivas podem beneficiar a saúde social?',
  'Porque impedem qualquer conflito entre pessoas.', 'Porque podem favorecer interação, cooperação e convivência.', 'Porque eliminam a necessidade de comunicação.', 'Porque saúde social depende somente de esportes.', null,
  'B', 'Correto! Atividades coletivas favorecem interação, cooperação e convivência, que fazem bem à saúde social.', 'Quase! Qual benefício vem de estar com outras pessoas? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-017', c.id, 2, 'Qual afirmação é mais adequada?',
  'Apenas esportes competitivos contam como atividade física.', 'Exercício beneficia somente quem quer competir.', 'Diferentes formas de movimento podem contribuir para a saúde.', 'Atividade física é importante somente na idade adulta.', null,
  'C', 'Muito bem! Diferentes formas de movimento contribuem para a saúde, não só os esportes competitivos.', 'Não foi dessa vez. Atividade física não é só competição nem só para adultos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N2-018', c.id, 2, 'Corpo, mente e convivência aparecem juntos nesse cenário porque:',
  'somente o exercício determina a saúde.', 'a saúde possui diferentes dimensões que se relacionam.', 'emoções são produzidas exclusivamente pelos músculos.', 'convivência não interfere no bem-estar.', null,
  'B', 'Isso mesmo! A saúde tem várias dimensões (corpo, mente e convivência) que se relacionam.', 'Quase! Corpo, mente e convivência estão ligados. Qual afirmação mostra isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N3-001', c.id, 3, 'A eritropoetina (EPO) é um hormônio endógeno secretado pelos rins que influencia a maturação dos eritrócitos. Suas formas recombinantes, sintetizadas em laboratório, têm sido usadas por alguns atletas em esportes de resistência na busca por melhores resultados. No entanto, a administração da EPO recombinante no esporte foi proibida pelo Comitê Olímpico Internacional e seu uso considerado doping. (MARTELLI, A. Eritropoetina: síntese e liberação fisiológica e o uso de sua forma recombinante no esporte. Perspectivas Online: biológicas & saúde, v. 10, n. 3, 2013, adaptado.) Uma influência que esse doping poderá exercer na melhoria da capacidade física desses atletas está relacionada ao transporte de',   -- cenário deduzido
  'lipídios, para aumento do gasto calórico.', 'ATP, para aumento da síntese hormonal.', 'oxigênio, para aumento da produção de ATP.', 'proteínas, para aumento da massa muscular.', 'vitamina C, para aumento da integridade dos vasos sanguíneos.',
  'C', 'Muito bem! A EPO estimula a produção de hemácias, que transportam oxigênio. Com mais oxigênio chegando aos músculos, aumenta a produção de ATP na respiração aeróbica e o desempenho em provas de resistência.', 'Quase! Eritrócitos são as hemácias. Qual substância elas transportam e por que ela é importante para gerar energia nos músculos? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N3-002', c.id, 3, 'Diversas substâncias são empregadas com a intenção de incrementar o desempenho esportivo de atletas de alto nível. O chamado doping sanguíneo, por exemplo, pela utilização da eritropoietina, é proibido pelas principais federações de esportes no mundo. A eritropoietina é um hormônio produzido pelos rins e fígado e sua principal ação é regular o processo de eritropoiese. Seu uso administrado intravenosamente em quantidades superiores àqueles presentes naturalmente no organismo permite que o indivíduo aumente a sua capacidade de realização de exercícios físicos. Esse tipo de doping está diretamente relacionado ao aumento da',   -- cenário deduzido
  'frequência cardíaca.', 'capacidade pulmonar.', 'massa muscular do indivíduo.', 'atividade anaeróbica da musculatura.', 'taxa de transporte de oxigênio pelo sangue.',
  'E', 'Correto! A eritropoiese é a produção de hemácias. Com mais hemácias, o sangue transporta mais oxigênio aos músculos, melhorando a resistência. Esse tipo de doping é proibido e traz riscos à saúde, como trombose.', 'Quase! Eritropoiese é a produção de glóbulos vermelhos. Qual é a principal função dessas células no sangue? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'QUADRA-N3-003', c.id, 3, 'As fibras musculares esqueléticas não são todas iguais. As fibras lentas, também conhecidas como fibras vermelhas, apresentam muitas mitocôndrias e são bem supridas por vasos sanguíneos. Já as fibras rápidas, ou fibras brancas, apresentam poucas mitocôndrias e recebem menor suprimento sanguíneo. Dessa forma, a distribuição das fibras nos músculos esqueléticos do corpo auxilia de forma diferenciada no desempenho físico de um atleta. (SADAVA, D. et al. Vida: a ciência da biologia, v. III. Porto Alegre: Artmed, 2009, adaptado.) Um atleta que sonha em disputar os Jogos Olímpicos e tem uma maior proporção de fibras brancas que fibras vermelhas teria mais vantagens na realização da prova de:',   -- cenário deduzido
  'Triatlo.', 'Salto em altura.', 'Marcha atlética.', 'Maratona aquática.', 'Ciclismo em estrada.',
  'B', 'Correto! Fibras brancas têm poucas mitocôndrias e geram força rápida e explosiva por pouco tempo, ideal para provas curtas e intensas, como o salto em altura. Provas de resistência favorecem as fibras vermelhas.', 'Quase! Fibras brancas fazem esforços rápidos e curtos, com pouca resistência. Qual prova exige um esforço explosivo e rápido, e não longa duração? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'quadra'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── TERRENO-BALDIO — 22 questões (15 com cenário da equipe, 7 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-001', c.id, 2, 'Um terreno baldio cheio de lixo pode:',
  'melhorar o equilíbrio ambiental.', 'favorecer riscos ambientais e à saúde.', 'impedir a presença de animais.', 'funcionar como local adequado de descarte.', null,
  'B', 'Correto! Um terreno baldio com lixo favorece riscos ambientais e à saúde, como a proliferação de vetores.', 'Quase! O lixo acumulado melhora ou piora o ambiente? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-002', c.id, 2, 'Recipientes abandonados podem representar risco quando:',
  'permanecem completamente secos.', 'acumulam água e favorecem alguns vetores.', 'são reciclados adequadamente.', 'recebem destinação correta.', null,
  'B', 'Isso mesmo! Recipientes que acumulam água podem virar criadouros de mosquitos, como o Aedes aegypti.', 'Não foi dessa vez. Pense no que os mosquitos precisam para se reproduzir. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-003', c.id, 2, 'O descarte correto do lixo ajuda:',
  'somente na aparência do bairro.', 'exclusivamente na reciclagem.', 'na prevenção de problemas ambientais e de saúde.', 'apenas na conservação das ruas.', null,
  'C', 'Muito bem! O descarte correto previne problemas ambientais e de saúde, e vai muito além da aparência.', 'Quase! Descartar corretamente traz benefícios amplos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-004', c.id, 2, 'O termo “vetor”, no contexto de doenças, refere-se:',
  'necessariamente ao microrganismo causador da doença.', 'a um organismo capaz de participar da transmissão de um agente infeccioso.', 'a qualquer objeto encontrado no lixo.', 'somente a bactérias presentes na água.', null,
  'B', 'Correto! Vetor é um organismo que participa da transmissão de um agente infeccioso, como o mosquito da dengue.', 'Não foi dessa vez. O vetor leva o agente, mas não é necessariamente o causador. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-005', c.id, 2, 'Qual situação merece atenção em um terreno?',
  'Área limpa e conservada.', 'Resíduos recolhidos adequadamente.', 'Pneus e recipientes acumulando água.', 'Lixeiras utilizadas corretamente.', null,
  'C', 'Exato! Pneus e recipientes acumulando água merecem atenção, pois podem abrigar larvas de mosquitos.', 'Quase! Procure a situação que representa risco. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-006', c.id, 2, 'A limpeza de terrenos pode ajudar na prevenção de doenças porque:',
  'elimina todas as espécies de insetos.', 'reduz algumas condições favoráveis a vetores e outros riscos.', 'substitui completamente o saneamento básico.', 'impede qualquer microrganismo de existir.', null,
  'B', 'Boa! Limpar terrenos reduz condições favoráveis a vetores e outros riscos. Não elimina todos os insetos, mas ajuda muito.', 'Não foi dessa vez. Cuidado com afirmações absolutas, como “elimina todas”. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-007', c.id, 2, 'Qual atitude é inadequada?',
  'Utilizar a coleta de resíduos disponível.', 'Manter recipientes sem água acumulada.', 'Participar do cuidado dos espaços comunitários.', 'Descartar entulho em um terreno vazio.', null,
  'D', 'Correto! Descartar entulho em terreno vazio é inadequado e cria problemas ambientais e de saúde.', 'Quase! A pergunta pede a atitude inadequada. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-008', c.id, 2, 'Lixo acumulado também pode aumentar:',
  'apenas o número de árvores.', 'o risco de acidentes no ambiente.', 'exclusivamente a umidade do ar.', 'a segurança dos moradores.', null,
  'B', 'Isso mesmo! Lixo acumulado pode aumentar o risco de acidentes, além de atrair animais e vetores.', 'Não foi dessa vez. Pense nos perigos de áreas cheias de lixo. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-009', c.id, 2, 'Por que um terreno particular mal cuidado pode se tornar questão de saúde coletiva?',
  'Porque tudo que ocorre em propriedade privada afeta toda a cidade.', 'Porque certos riscos ambientais podem atingir pessoas da comunidade.', 'Porque saúde coletiva trata somente de terrenos.', 'Porque qualquer terreno vazio transmite doenças.', null,
  'B', 'Muito bem! Riscos ambientais de um terreno mal cuidado podem atingir pessoas da comunidade, por isso é questão de saúde coletiva.', 'Quase! Evite exageros como “tudo” ou “qualquer”. Qual afirmação é equilibrada? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-010', c.id, 2, 'Qual combinação representa maior risco?',
  'Solo limpo + resíduos coletados.', 'Reciclagem + destinação correta.', 'Lixo acumulado + recipientes com água parada.', 'Limpeza + eliminação de criadouros.', null,
  'C', 'Correto! Lixo acumulado somado a recipientes com água parada é a combinação de maior risco.', 'Não foi dessa vez. Procure a mistura que favorece mais os mosquitos. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-011', c.id, 2, 'Um grupo limpa um terreno, mas deixa vários recipientes capazes de acumular chuva. O problema foi totalmente resolvido?',
  'Sim, porque somente lixo orgânico apresenta riscos.', 'Sim, porque água da chuva é sempre segura.', 'Não, pois ainda existem possíveis locais de acúmulo de água.', 'Não, porque terrenos nunca podem permanecer vazios.', null,
  'C', 'Boa! Se ainda há recipientes que acumulam chuva, o problema não foi totalmente resolvido: eles podem virar criadouros.', 'Quase! Limpar o lixo é ótimo, mas ainda falta algo. O quê? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-012', c.id, 2, 'A prevenção de doenças transmitidas por vetores pode envolver:',
  'somente o tratamento das pessoas doentes.', 'mudanças ambientais que reduzam locais favoráveis aos vetores.', 'apenas o fechamento das escolas.', 'exclusivamente o uso de medicamentos.', null,
  'B', 'Correto! A prevenção pode envolver mudanças ambientais que reduzam locais favoráveis aos vetores.', 'Não foi dessa vez. Prevenir é agir sobre o ambiente, não só tratar quem adoeceu. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-013', c.id, 2, 'O cuidado com terrenos baldios mostra que:',
  'saúde depende somente de decisões individuais.', 'ambiente e saúde são independentes.', 'ações comunitárias e ambientais também interferem na saúde.', 'prevenção ocorre apenas dentro das UBS.', null,
  'C', 'Isso mesmo! Cuidar de terrenos mostra que ações comunitárias e ambientais também interferem na saúde.', 'Quase! Ambiente e saúde estão ligados. Qual alternativa mostra isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-014', c.id, 2, 'Um recipiente pequeno com água merece atenção?',
  'Não, porque vetores utilizam apenas grandes lagos.', 'Sim, porque alguns vetores podem utilizar pequenos acúmulos de água.', 'Não, se estiver localizado longe de uma casa.', 'Sim, porque qualquer água parada contém obrigatoriamente doenças.', null,
  'B', 'Muito bem! Alguns vetores usam pequenos acúmulos de água, como uma tampinha com água de chuva.', 'Não foi dessa vez. O Aedes se reproduz até em pouca água. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N2-015', c.id, 2, 'Qual seria a melhor estratégia preventiva?',
  'Retirar apenas resíduos visualmente grandes.', 'Aplicar medicamentos nos moradores.', 'Manter o local limpo e eliminar possíveis acúmulos de água.', 'Esperar aparecerem casos de doenças para agir.', null,
  'C', 'Correto! Manter o local limpo e eliminar acúmulos de água é a melhor estratégia preventiva.', 'Quase! Qual estratégia age antes de surgirem casos? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-001', c.id, 3, 'Eliminar recipientes que acumulam água pode contribuir para reduzir criadouros do mosquito Aedes aegypti.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Isso mesmo! O Aedes aegypti deposita seus ovos em água parada, e eliminar pratos de vaso, pneus, garrafas e outros recipientes reduz muito os criadouros. Cada casa faz diferença no combate à dengue.', 'Não foi dessa vez, mas continue! Lembre-se de onde o Aedes se reproduz: água parada. Eliminar esses recipientes ajuda ou não? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-002', c.id, 3, 'Na família Retroviridae encontram-se diversos vírus que infectam aves e mamíferos, sendo caracterizada pela produção de DNA a partir de uma molécula de RNA. Alguns retrovírus infectam exclusivamente humanos, não necessitando de outros hospedeiros, reservatórios ou vetores biológicos. As infecções ocasionadas por esses vírus vêm causando mortes e grandes prejuízos ao desenvolvimento social e econômico. Nesse contexto, pesquisadores têm produzido medicamentos que contribuem para o tratamento dessas doenças. Que avanços tecnológicos têm contribuído para o tratamento dessas infecções virais?',   -- cenário deduzido
  'Melhoria dos métodos de controle dos vetores desses vírus.', 'Fabricação de soros mutagênicos para combate desses vírus.', 'Investimento da indústria em equipamentos de proteção individual.', 'Produção de vacinas que evitam a infecção das células hospedeiras.', 'Desenvolvimento de antirretrovirais que dificultam a reprodução desses vírus.',
  'E', 'Muito bem! Os antirretrovirais, como os usados contra o HIV, interferem em etapas da reprodução do retrovírus, como a transcrição reversa, e permitem que as pessoas vivam bem por muitos anos.', 'Quase! O enunciado fala de medicamentos para tratar a infecção, e o HIV não tem vetor nem vacina disponível. Qual alternativa trata de medicamentos que atuam na reprodução do vírus? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-003', c.id, 3, 'O protozoário Trypanosoma cruzi, causador da doença de Chagas, pode ser a nova arma da medicina contra o câncer. Pesquisadores brasileiros conseguiram criar uma vacina contra a doença usando uma variação do protozoário incapaz de desencadear a patologia (não patogênico). Para isso, realizaram uma modificação genética criando um T. cruzi capaz de produzir também moléculas fabricadas pelas células tumorais. Quando o organismo inicia o combate ao protozoário, entra em contato também com a molécula tumoral, que passa a ser vista também pelo sistema imune como um indicador de células do protozoário. Depois de induzidas as defesas, estas passam a destruir todas as células com a molécula tumoral, como se lutassem apenas contra o protozoário. (Disponível em: www.estadao.com.br, adaptado.) Qual o mecanismo utilizado no experimento para enganar as células de defesa, fazendo com que ataquem o tumor?',   -- cenário deduzido
  'Autoimunidade.', 'Hipersensibilidade.', 'Ativação da resposta inata.', 'Apresentação de antígeno específico.', 'Desencadeamento de processo anti-inflamatório.',
  'D', 'Muito bem! O protozoário modificado apresenta ao sistema imune a molécula tumoral como antígeno, e as células de defesa aprendem a reconhecê-la e passam a destruir as células do tumor. É a base da imunoterapia contra o câncer.', 'Não foi dessa vez, mas continue! O texto diz que o sistema imune passa a “ver” a molécula tumoral como indicador do protozoário. Qual processo apresenta um antígeno às células de defesa? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-004', c.id, 3, 'Os resultados de um ensaio clínico randomizado na dengue nas áreas que receberam o mosquito Aedes aegypti técnica utilizada no Brasil pelo Método Wolbachia, iniciativa bactéria induz a redução da carga viral no mosquito e, sendo repassada por meio do cruzamento entre os insetos. também precisa entrar nas células para se reproduzir, ambos. (COSTA, G. Agência Fiocruz de Notícias. Estudo confirma eficácia do Método Wolbachia.) Essa tecnologia utilizada no combate à dengue consiste na',   -- cenário deduzido
  'predação do vírus pela bactéria.', 'esterilização de mosquitos infectados.', 'alteração no genótipo do mosquito pela bactéria.', 'competição do vírus e da bactéria no hospedeiro.', 'inserção de material genético do vírus na bactéria.',
  'D', 'Muito bem! O texto indica que tanto a bactéria quanto o vírus precisam entrar nas células para se reproduzir, o que leva a uma competição no hospedeiro e reduz a carga viral no mosquito. Esse é o princípio do Método Wolbachia.', 'Não desanime! O texto diz que a Wolbachia reduz a carga viral e que a bactéria e o vírus precisam das mesmas células para se reproduzir. O que isso sugere sobre a relação entre os dois? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-005', c.id, 3, 'De acordo com a Organização Mundial da Saúde, a filariose e a leishmaniose são consideradas doenças tropicais infecciosas e constituem uma preocupação para a saúde pública por ser alto o índice de mortalidade a elas associado. Uma medida profilática comum a essas duas doenças é o(a)',   -- cenário deduzido
  'incineração do lixo orgânico.', 'construção de rede de esgoto.', 'uso de vermífugo pela população.', 'controle das populações dos vetores.', 'consumo de carnes vermelhas bem cozidas.',
  'D', 'Muito bem! A filariose é transmitida por mosquitos (Culex) e a leishmaniose, por flebotomíneos (mosquito-palha). Em ambas, controlar os vetores é uma medida preventiva comum.', 'Não foi dessa vez, mas continue! As duas doenças são transmitidas por insetos. Qual medida atua sobre esses transmissores? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-006', c.id, 3, 'A leishmaniose visceral é uma zoonose causada por um protozoário do gênero Leishmania que é encontrado em diversos tecidos. Ela é transmitida ao homem de forma indireta, por vetores do ambiente doméstico. O cão é considerado um importante hospedeiro desse protozoário, podendo ou não apresentar os sintomas da doença, como perda de peso, anemia, ferimentos na pele, diarreia, conjuntivite e insuficiência renal. Em uma região que sofre com alta incidência dessa doença, uma campanha do centro de zoonoses buscou verificar a presença desse protozoário nos cães para tentar controlar a doença. Em qual material biológico dos cães a presença desse protozoário representa risco de transmissão dessa zoonose?',   -- cenário deduzido
  'Urina.', 'Saliva.', 'Fezes.', 'Sangue.', 'Secreção ocular.',
  'D', 'Correto! A transmissão é indireta, pela picada do flebotomíneo (mosquito-palha), que se infecta ao sugar o sangue do cão contendo o protozoário. Por isso o sangue é o material de risco, e não urina, saliva ou fezes.', 'Quase! O texto diz que a transmissão é feita por um vetor, um inseto que pica. De qual material do cão esse inseto se alimenta e pode se infectar? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'TERRENOBA-N3-007', c.id, 3, 'As autoridades sanitárias brasileiras têm se preocupado muito nos últimos anos com o aumento da ocorrência de doenças transmitidas por mosquitos, principalmente arboviroses como chikungunya e zika, que se tornaram epidêmicas ou endêmicas em áreas urbanas. Parte de uma análise da relação entre a urbanização e a incidência dessas doenças está representada no fluxograma. (ALMEIDA, L. S.; COTA, A. L. S.; RODRIGUES, D. F. Saneamento, arboviroses e determinantes ambientais: impactos na saúde urbana. Ciência & Saúde Coletiva, v. 25, n. 10, 2020, adaptado.) [O fluxograma original não pôde ser reproduzido aqui.] Nesse contexto, como a urbanização está causando riscos à saúde humana?',   -- cenário deduzido
  'Disseminando verminoses.', 'Causando a eutrofização de lagoas.', 'Aumentando a chance de contato com coliformes.', 'Diminuindo a população de predadores aquáticos.', 'Aproximando as pessoas das áreas de ocorrência de mosquitos.',
  'E', 'Correto! A urbanização desordenada, com acúmulo de água em lixo, pneus e recipientes e falta de saneamento, cria criadouros dentro das cidades e aproxima as pessoas dos mosquitos transmissores de arboviroses.', 'Quase! O enunciado trata de doenças transmitidas por mosquitos. Qual alternativa relaciona a urbanização a esses insetos, e não a outros problemas ambientais? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'terreno-baldio'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── UBS — 65 questões (48 com cenário da equipe, 17 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-003', c.id, 1, 'Verdadeiro ou Falso: Agora que já temos a vacina contra a dengue, não precisamos mais nos preocupar em tirar a água parada dos pratinhos de plantas e pneus.',
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, parabéns! A vacina é um reforço importante, mas o controle do mosquito continua sendo o principal método de prevenção. Ela sozinha não acaba com os mosquitos, então a água parada nos pratinhos de plantas e nos pneus continua sendo um perigo.', 'Quase! A vacina ajuda muito, mas será que ela faz os mosquitos sumirem? Pense nos pratinhos de plantas e nos pneus. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-004', c.id, 1, 'Você sabe o que é uma Unidade Básica de Saúde (UBS), comumente chamada de Posto de saúde?',
  'Um lugar onde as pessoas vão apenas para fazer exames.', 'Um serviço de saúde que ajuda a cuidar da saúde das pessoas e da comunidade.', 'Um lugar onde as pessoas aprendem sobre medicina.', 'Um lugar onde somente pessoas muito doentes podem entrar.', null,
  'B', 'Muito bem! A UBS, o posto de saúde, é um serviço que cuida da saúde das pessoas e da comunidade, com vacinas, consultas, orientações e prevenção de doenças.', 'Quase! A UBS é o posto de saúde do bairro e faz muito mais do que exames ou ensino. Pense no que um posto de saúde faz pela comunidade. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-005', c.id, 1, 'Por que uma Unidade Básica de Saúde (UBS) é importante para a comunidade?',
  'Porque a UBS serve apenas para atender pessoas quando elas estão muito doentes.', 'Porque na UBS só trabalham médicos e eles não precisam conversar com os pacientes.', 'Porque a UBS existe somente para dar remédios às pessoas.', 'Porque a UBS ajuda as pessoas a cuidar da saúde, prevenir doenças e receber orientações com profissionais de saúde.', null,
  'D', 'Isso! A UBS ajuda as pessoas a cuidar da saúde, prevenir doenças e receber orientações de profissionais de saúde, perto de casa.', 'Boa tentativa! A UBS não serve só para quem está muito doente. Pense nos vários cuidados que ela oferece. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-006', c.id, 1, 'Ana tem dúvidas sobre sua saúde e sua mãe explica que a UBS é um ótimo lugar para receber orientações de saúde. Você sabe por que é importante conversar com os profissionais da UBS?',
  'Porque conversar substitui todos os tratamentos médicos.', 'Porque os profissionais precisam saber tudo sobre a vida das pessoas.', 'Porque conversar ajuda a entender melhor como cuidar da saúde e tirar dúvidas.', 'Porque somente quem conversa pode receber atendimento.', null,
  'C', 'Correto! Conversar com os profissionais da UBS ajuda a entender melhor como cuidar da saúde e tirar dúvidas. Perguntar é um jeito de se cuidar!', 'Quase! Conversar ajuda, mas não substitui tratamentos. O que a gente ganha ao tirar dúvidas com quem entende de saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-007', c.id, 1, 'Na UBS, diferentes profissionais de saúde trabalham juntos para cuidar das pessoas da comunidade. Por que é importante ter vários profissionais trabalhando na UBS?',
  'Porque cada profissional pode contribuir com seus conhecimentos e ajudar em diferentes necessidades de saúde.', 'Porque todos os profissionais fazem exatamente o mesmo trabalho.', 'Porque somente um profissional pode cuidar de cada pessoa por vez.', 'Porque quanto mais profissionais houver, menos as pessoas precisam conversar sobre sua saúde.', null,
  'A', 'Muito bem! Na UBS, cada profissional contribui com seus conhecimentos e ajuda em diferentes necessidades de saúde. Trabalhar em equipe cuida melhor das pessoas.', 'Quase! Cada profissional estudou uma área diferente. Por que é bom ter vários profissionais juntos? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-008', c.id, 1, 'Por que ouvir as pessoas é importante para a UBS?',
  'Porque as pessoas podem contar suas dúvidas, necessidades e dificuldades.', 'Porque os profissionais não precisam estudar quando ouvem a comunidade.', 'Porque somente os moradores podem decidir os tratamentos médicos.', 'Porque ouvir as pessoas evita que os profissionais trabalhem.', null,
  'A', 'Isso! Ouvir as pessoas ajuda a UBS a conhecer as dúvidas, necessidades e dificuldades da comunidade e a cuidar melhor de todos.', 'Boa tentativa! Quando a equipe escuta a comunidade, ela aprende coisas importantes. O que as pessoas podem contar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-009', c.id, 1, 'Qual dessas atitudes ajuda a criar confiança entre a comunidade e os profissionais da UBS?',
  'Não ouvir as pessoas, pois elas não sabem nada de saúde.', 'Tratar as pessoas com respeito e conversar com elas.', 'Evitar explicar os cuidados de saúde.', 'Fazer tudo sem perguntar ou ouvir ninguém.', null,
  'B', 'Correto! Tratar as pessoas com respeito e conversar com elas cria confiança entre a comunidade e os profissionais da UBS.', 'Quase! Confiança nasce quando alguém se sente escutado e respeitado. Qual atitude faz isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-010', c.id, 1, 'Caio tem medo de ir à UBS porque acha que ninguém vai ouvi-lo. A equipe começa a conversar com ele com atenção, explica o que está acontecendo e responde às suas perguntas. O que pode acontecer com João?',
  'Ele não poderá mais fazer perguntas.', 'Ele nunca mais precisará cuidar da saúde.', 'Ele ficará doente por conversar com os profissionais.', 'Ele pode passar a confiar mais nos profissionais.', null,
  'D', 'Muito bem! Quando a equipe escuta com atenção e explica tudo com carinho, a pessoa pode passar a confiar mais nos profissionais e a se sentir à vontade para cuidar da saúde.', 'Quase! A equipe conversou com atenção e respondeu às perguntas. Como ele pode se sentir depois disso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-011', c.id, 1, 'João conta para a equipe da UBS que muitas crianças estão tendo dificuldade para entender como evitar algumas doenças. O que a equipe pode fazer?',
  'Ignorar o problema, pois entender como evitar doenças não resolve nada.', 'Dizer que somente os médicos sabem o que fazer.', 'Conversar com a comunidade e criar uma atividade para ensinar sobre prevenção.', 'Fechar a UBS até que o problema desapareça.', null,
  'C', 'Isso! Quando a equipe percebe que as crianças têm dúvidas, pode conversar com a comunidade e criar atividades para ensinar sobre prevenção. É a educação em saúde!', 'Boa tentativa! Quando as crianças têm dificuldade para entender algo importante, o que ajuda? Pense em ensinar e conversar. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-012', c.id, 1, 'A mãe da Jennifer está grávida e precisa fazer as consultas mensais de rotina para acompanhar o crescimento do bebê. Em qual local ela deve realizar o pré-natal?',
  'Na Unidade Básica de Saúde (UBS).', 'No hospital.', 'Na Unidade de Pronto Atendimento (UPA).', 'Não é importante acompanhar a gestação com um médico especialista', null,
  'A', 'Correto! O pré-natal, o acompanhamento da gestante e do bebê, é feito na UBS, perto de casa. Consultas regulares ajudam a mamãe e o bebê a ficarem saudáveis.', 'Quase! As consultas de rotina da gravidez são feitas em um serviço que acompanha a saúde no dia a dia. Qual é ele? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-013', c.id, 1, 'Pedro precisa tomar a vacina da gripe e buscar um xarope simples recomendado pelo médico. Onde ele encontra vacinas e remédios gratuitos do SUS?',
  'Na igreja.', 'Na Unidade Básica de Saúde (UBS).', 'Na Unidade de Pronto Atendimento (UPA).', 'No supermercado.', null,
  'B', 'Muito bem! Na UBS, o SUS oferece vacinas e remédios de graça, como a vacina da gripe e os medicamentos indicados pelo médico.', 'Quase! Vacinas e remédios gratuitos do SUS estão no posto de saúde do bairro. Qual lugar é esse? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-014', c.id, 1, 'Verdadeiro ou Falso: A UBS é muito importante para a sociedade porque ela se aproxima da comunidade, cuidando da saúde das famílias no próprio bairro, ajudando a prevenir doenças e acompanhando os moradores de forma contínua.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, muito bem! A UBS fica perto da comunidade, cuida das famílias no próprio bairro, ajuda a prevenir doenças e acompanha os moradores de forma contínua.', 'Ops! Pense: a UBS está no bairro, perto das famílias. Isso é importante para a sociedade? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-015', c.id, 1, 'Verdadeiro ou Falso: A Unidade Básica de Saúde (UBS) é a "porta de entrada" do SUS e atende diretamente a região ou o bairro onde os moradores vivem. Nela, a comunidade tem acesso a vacinas, medicamentos gratuitos, exames e atendimento multiprofissional perto de casa.',   -- cenário deduzido
  'Verdadeiro', 'Falso', null, null, null,
  'A', 'Verdadeiro, parabéns! A UBS é a porta de entrada do SUS e atende a região onde os moradores vivem, com vacinas, remédios gratuitos, exames e atendimento de vários profissionais.', 'Quase! Pense no papel da UBS: ela é o primeiro lugar onde a comunidade procura cuidado. Releia a frase. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-016', c.id, 1, 'Verdadeiro ou Falso: O trabalho dos agentes comunitários de saúde (ACS) com as visitas domiciliares (de casa em casa) distancia os moradores da equipe de saúde do bairro e dificulta a compreensão do cenário social daquela comunidade.',
  'Verdadeiro', 'Falso', null, null, null,
  'B', 'Falso, muito bem! As visitas dos agentes comunitários de saúde aproximam os moradores da equipe e ajudam a conhecer a realidade da comunidade. Eles são a ponte entre a UBS e as famílias!', 'Quase! Os agentes comunitários vão de casa em casa. Será que isso afasta ou aproxima as pessoas da equipe de saúde? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N1-017', c.id, 1, 'No domingo à noite, a Unidade Básica de Saúde (UBS) do bairro já está fechada, pois funciona de segunda a sexta-feira durante o dia. Se alguém passar mal de repente com febre e dor no corpo no final de semana, para onde a família deve levá-la?',
  'Para a escola da comunidade.', 'Para a Unidade de Pronto Atendimento (UPA 24h).', 'Para o parquinho do bairro.', 'Para a biblioteca pública.', null,
  'B', 'Isso! Quando a UBS está fechada, como à noite e nos fins de semana, a UPA 24h atende as urgências.', 'Quase! A UBS está fechada no domingo à noite. Qual serviço de saúde funciona 24 horas? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-034', c.id, 2, 'Uma adolescente suspeita que teve contato com uma IST. Qual conduta é mais adequada?',
  'Procurar um serviço de saúde para avaliação, orientação e, quando indicado, testagem.', 'Utilizar medicamentos que tenham funcionado para outra pessoa.', 'Esperar obrigatoriamente o surgimento de sintomas antes de procurar atendimento.', 'Evitar comentar a situação para impedir qualquer constrangimento.', null,
  'A', 'Boa! Diante de suspeita de IST, procure um serviço de saúde para avaliação, orientação e testagem. Não use remédios de outra pessoa.', 'Quase! Qual atitude garante diagnóstico e tratamento corretos, sem riscos? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-035', c.id, 2, 'É necessário estar doente para procurar uma UBS?',
  'Sim, sempre.', 'Não, a UBS também atua em prevenção e promoção da saúde.', 'Sim, exceto para crianças.', 'Não, mas somente para buscar medicamentos.', null,
  'B', 'Correto! Não é preciso estar doente para ir à UBS: ela atua também na prevenção e promoção da saúde.', 'Quase! A UBS cuida de você antes mesmo de adoecer. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-036', c.id, 2, 'UBS significa:',
  'Unidade Brasileira de Socorro.', 'União Básica Sanitária.', 'Unidade Básica de Saúde.', 'Unidade Brasileira de Segurança.', null,
  'C', 'Isso mesmo! UBS significa Unidade Básica de Saúde, a “porta de entrada” do SUS.', 'Não foi dessa vez. A sigla UBS significa Unidade Básica de Saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-037', c.id, 2, 'Qual atividade pode fazer parte do cuidado realizado pela UBS?',
  'Somente cirurgias de alta complexidade.', 'Vacinação, orientações e acompanhamento de saúde.', 'Apenas atendimento de acidentes graves.', 'Exclusivamente internações prolongadas.', null,
  'B', 'Muito bem! A UBS faz vacinação, orientações e acompanhamento de saúde.', 'Quase! A UBS cuida do dia a dia da saúde, não só de casos graves. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-038', c.id, 2, 'A vacinação realizada ou acompanhada pela atenção à saúde é principalmente uma ação de:',
  'reabilitação esportiva.', 'tratamento cirúrgico.', 'prevenção de doenças.', 'diagnóstico por imagem.', null,
  'C', 'Correto! A vacinação é principalmente uma ação de prevenção de doenças.', 'Não foi dessa vez. Vacina age antes da doença. Que tipo de ação é? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-039', c.id, 2, '“Acompanhamento ao longo do tempo” significa:',
  'procurar atendimento somente uma vez.', 'acompanhar as necessidades de saúde em diferentes momentos da vida.', 'frequentar a UBS todos os dias.', 'permanecer internado na unidade.', null,
  'B', 'Boa! Acompanhamento ao longo do tempo é acompanhar as necessidades de saúde em diferentes momentos da vida.', 'Quase! Pense em cuidado contínuo, que não se limita a uma única consulta. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-040', c.id, 2, 'Qual situação combina melhor com o papel preventivo da UBS?',
  'Esperar obrigatoriamente uma doença surgir.', 'Participar de vacinação e receber orientações de saúde.', 'Utilizar medicamentos sem orientação.', 'Procurar apenas atendimentos de alta complexidade.', null,
  'B', 'Isso mesmo! Participar de vacinação e receber orientações combina com o papel preventivo da UBS.', 'Não foi dessa vez. Prevenir é agir antes da doença. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-041', c.id, 2, 'Por que acompanhar a saúde antes de surgirem problemas pode ser importante?',
  'Porque garante que ninguém adoecerá.', 'Porque prevenção e acompanhamento podem reduzir riscos e identificar necessidades.', 'Porque elimina a necessidade de hábitos saudáveis.', 'Porque substitui qualquer outro serviço da rede.', null,
  'B', 'Correto! Prevenção e acompanhamento podem reduzir riscos e identificar necessidades, mas não garantem que ninguém adoeça.', 'Quase! Acompanhar a saúde antes dos problemas traz vantagens. Quais? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-042', c.id, 2, 'A UBS faz parte:',
  'apenas do sistema escolar.', 'exclusivamente dos serviços privados.', 'da rede de cuidados de saúde da população.', 'somente dos serviços de emergência.', null,
  'C', 'Muito bem! A UBS faz parte da rede de cuidados de saúde da população.', 'Não foi dessa vez. Ela não é do sistema escolar nem só privada. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-043', c.id, 2, 'Qual é uma diferença importante entre promoção da saúde e tratamento?',
  'Não existe qualquer diferença.', 'Promoção também busca favorecer saúde e prevenção antes do aparecimento de problemas.', 'Tratamento acontece somente em hospitais.', 'Promoção da saúde utiliza obrigatoriamente medicamentos.', null,
  'B', 'Correto! A promoção da saúde busca favorecer saúde e prevenção antes dos problemas, e não depende de remédios.', 'Quase! Qual é a diferença entre cuidar antes e tratar depois? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-044', c.id, 2, 'Um adolescente saudável participa de uma atividade educativa na UBS. Isso faz sentido?',
  'Não, porque UBS atende somente pessoas doentes.', 'Sim, porque educação e prevenção também fazem parte do cuidado.', 'Não, porque adolescentes não utilizam atenção básica.', 'Sim, mas apenas se precisar de internação.', null,
  'B', 'Isso mesmo! Educação e prevenção também fazem parte do cuidado, e adolescentes saudáveis podem participar das atividades na UBS.', 'Não foi dessa vez. A UBS atende pessoas de todas as idades e promove educação em saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-045', c.id, 2, 'A ideia de cuidado contínuo significa que:',
  'saúde é cuidada apenas em emergências.', 'uma consulta resolve qualquer necessidade futura.', 'o cuidado pode acompanhar diferentes necessidades ao longo da vida.', 'somente pessoas com doenças crônicas precisam de acompanhamento.', null,
  'C', 'Correto! Cuidado contínuo acompanha diferentes necessidades ao longo da vida.', 'Quase! Cuidado contínuo não é só emergência ou uma consulta só. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-046', c.id, 2, 'Qual alternativa representa promoção da saúde?',
  'Compartilhar medicamentos.', 'Ignorar campanhas de prevenção.', 'Receber orientações sobre hábitos saudáveis.', 'Procurar atendimento apenas em situações graves.', null,
  'C', 'Boa! Receber orientações sobre hábitos saudáveis é promoção da saúde.', 'Não foi dessa vez. Procure a atitude que cuida da saúde de forma preventiva. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-047', c.id, 2, 'Uma campanha de vacinação beneficia:',
  'somente os profissionais que trabalham na UBS.', 'indivíduos e também estratégias de proteção da comunidade.', 'apenas pessoas que já estão doentes.', 'exclusivamente adultos.', null,
  'B', 'Muito bem! Campanhas de vacinação beneficiam as pessoas e ajudam a proteger toda a comunidade.', 'Quase! A vacinação beneficia mais do que um grupo restrito. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-048', c.id, 2, 'Por que a UBS é importante para o bairro?',
  'Porque substitui todos os hospitais.', 'Porque aproxima ações de cuidado, prevenção e acompanhamento da comunidade.', 'Porque atende apenas emergências.', 'Porque sua função principal é internação.', null,
  'B', 'Correto! A UBS aproxima cuidado, prevenção e acompanhamento da comunidade, o que é muito importante para o bairro.', 'Não foi dessa vez. A UBS não substitui hospitais nem é só emergência. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-049', c.id, 2, 'Qual frase representa melhor a Atenção Primária?',
  '“Só procure ajuda quando a situação for grave.”', '“Toda situação deve ser atendida em hospital.”', '“Cuidar da saúde também envolve prevenção e acompanhamento próximo da comunidade.”', '“Vacinação é necessária apenas quando surgem surtos.”', null,
  'C', 'Isso mesmo! Atenção Primária é cuidar da saúde com prevenção e acompanhamento próximo da comunidade.', 'Quase! Qual frase mostra o cuidado preventivo e próximo? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N2-050', c.id, 2, 'Para acompanhamento preventivo e vacinação, o documento destaca principalmente:',
  'UPA.', 'ambulância.', 'UBS.', 'centro cirúrgico.', null,
  'C', 'Isso mesmo! Para acompanhamento preventivo e vacinação, o serviço indicado é a UBS.', 'Não foi dessa vez. Qual serviço faz prevenção e vacinação? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-001', c.id, 3, 'Ambientes quentes e úmidos favorecem micoses de pele porque:',   -- cenário deduzido
  'Eliminam naturalmente qualquer fungo presente', 'Não têm relação com o desenvolvimento de fungos, por micoses são causadas por bactérias', 'Favorecem exclusivamente infecções virais por estar em um ambiente mais quentes', 'Criam condições propícias à proliferação dos fungos causadores dessas micoses', 'Reduzem a umidade da pele, absorvendo toda a água presente na pele',
  'D', 'Correto! Fungos crescem bem em locais quentes e úmidos, como entre os dedos dos pés e dobras da pele. Secar bem o corpo, usar calçados arejados e evitar compartilhar toalhas ajuda a prevenir.', 'Não foi essa, mas siga firme! Pense nas condições de que os fungos gostam para crescer. Calor e umidade ajudam ou atrapalham? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-002', c.id, 3, 'O uso excessivo de antibióticos pode favorecer a candidíase porque:',
  'Elimina diretamente o fungo Candida do organismo', 'Não tem nenhuma relação com o crescimento de fungos', 'Fortalece exclusivamente a microbiota bacteriana benéfica', 'Impede totalmente qualquer infecção futura', 'Pode alterar o equilíbrio da microbiota normal do corpo, permitindo a proliferação excessiva da Candida albicans',
  'E', 'Muito bem! Os antibióticos eliminam também bactérias benéficas que controlam a Candida. Sem essa competição, o fungo se multiplica em excesso. Mais um motivo para só usar antibióticos com indicação médica.', 'Quase! Lembre-se de que antibióticos atuam contra bactérias, inclusive as benéficas. O que acontece com o fungo quando as bactérias que o controlam diminuem? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-003', c.id, 3, 'Pacientes imunossuprimidos têm maior risco de infecções fúngicas oportunistas graves porque:',
  'Fungos só representam risco para pessoas com imunidade fortalecida', 'O sistema imunológico enfraquecido tem menor capacidade de controlar fungos normalmente contidos pelo organismo', 'Não existe relação entre imunossupressão e infecções fúngicas', 'A imunossupressão elimina automaticamente os fungos do corpo e alterando o sistema imune da pessoa', 'A imunossupressão só afeta infecções virais',
  'B', 'Excelente! Muitos fungos convivem com nosso corpo sem causar problemas porque a imunidade os controla. Quando as defesas estão baixas, como na aids ou em quimioterapia, eles podem causar doenças graves, as infecções oportunistas.', 'Não foi dessa vez, mas você consegue! Pense no papel do sistema imune: quando ele está enfraquecido, o controle sobre os micro-organismos aumenta ou diminui? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-004', c.id, 3, 'O uso do preservativo é a principal prevenção da maioria das ISTs porque:',   -- cenário deduzido
  'Cura infecções já instaladas no organismo', 'Substitui totalmente a necessidade de vacinação contra o HPV', 'Não apresenta eficácia comprovada na prevenção de ISTs', 'Só previne gravidez, sem efeito em ISTs', 'Cria uma barreira física que reduz o contato com fluidos contaminados',
  'E', 'Correto! O preservativo, usado corretamente em todas as relações, funciona como barreira física e reduz bastante o risco de várias ISTs e de gravidez. Ele complementa, e não substitui, a vacinação e o acompanhamento de saúde.', 'Quase! Pense no que o preservativo faz fisicamente durante a relação sexual. Ele cura, ou impede o contato com fluidos e lesões? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-005', c.id, 3, 'A diferença entre ser soropositivo para o HIV e desenvolver AIDS está em que:',
  'Ser soropositivo indica infecção pelo vírus; AIDS é o estágio avançado, com comprometimento importante da imunidade, que pode ser retardado ou evitado com tratamento', 'As duas expressões significam exatamente a mesma coisa, porém com nomenclaturas diferentes referentes a época em que o termo era utilizado', 'AIDS é uma doença sem qualquer relação com o HIV', 'Ser soropositivo significa necessariamente já ter desenvolvido a síndrome', 'AIDS é uma fase anterior à infecção pelo HIV',
  'A', 'Muito bem! Soropositivo é quem tem o HIV; a aids é a fase avançada, em que a imunidade fica muito comprometida. Com o tratamento antirretroviral, muitas pessoas vivem bem por décadas sem desenvolver a síndrome.', 'Não foi essa, mas você está no caminho! Pense na ordem dos acontecimentos: primeiro vem a infecção, depois, se não tratada, o enfraquecimento do sistema imune. Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-006', c.id, 3, 'Muitas ISTs, como a clamídia, podem ser assintomáticas. Isso reforça a importância de:',
  'Buscar testagem somente quando sintomas graves aparecem', 'Testagem regular, mesmo na ausência de sintomas, para diagnóstico e tratamento precoces', 'O organismo eliminar a infecção espontaneamente em todos os casos', 'Não haver necessidade de acompanhamento médico regular', 'Testar apenas uma vez na vida',
  'B', 'Acertou! Quem tem uma IST assintomática pode transmiti-la sem saber e sofrer complicações, como infertilidade. Testar regularmente permite tratar cedo e proteger a si e aos outros.', 'Quase! Se a infecção pode não dar sinais, esperar sintomas é um bom plano? Pense em como descobrir e tratar a tempo e tente de novo.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-007', c.id, 3, 'Gonorreia e clamídia costumam ser abordadas de forma conjunta em protocolos de saúde porque:',
  'São causadas exatamente pelo mesmo microrganismo', 'Apenas uma delas é considerada uma IST', 'Frequentemente ocorrem como coinfecção e apresentam sintomas semelhantes, dificultando a distinção sem exames específicos', 'Não existe nenhuma relação clínica entre as duas infecções', 'Uma delas é causada por vírus e outra por bactérias',
  'C', 'Correto! As duas são ISTs bacterianas, com sintomas parecidos e que muitas vezes aparecem juntas. Sem exame específico é difícil diferenciá-las, por isso são abordadas em conjunto.', 'Não desanime! Lembre-se de que as duas são ISTs bacterianas, causadas por bactérias diferentes, e que podem aparecer ao mesmo tempo com sinais parecidos. Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-008', c.id, 3, 'A sífilis não tratada evolui em estágios porque:',
  'Os sintomas sempre pioram de forma contínua, sem qualquer período de latência', 'A infecção desaparece espontaneamente após a fase primária', 'Não há risco de complicações em estágios avançados', 'A doença pode continuar progredindo silenciosamente mesmo após o desaparecimento temporário dos sintomas iniciais', 'A sífilis só afeta a pele, sem outros órgãos, sendo necessário o tratamento unicamente com um dermatologista',
  'D', 'Muito bem! Na sífilis, as feridas iniciais somem sozinhas, mas a bactéria continua no corpo e pode causar, anos depois, lesões graves em coração, cérebro e outros órgãos. Sumiu o sintoma não significa que a doença foi curada.', 'Quase! Pense na característica traiçoeira da sífilis: os sinais podem desaparecer, mas a bactéria continua ali? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-009', c.id, 3, 'Um programa de vacinação contra o HPV visando reduzir o câncer de colo do útero décadas depois ilustra o princípio de:',
  'Prevenção terciária, voltada ao tratamento de doenças já instaladas', 'Diagnóstico tardio de doenças', 'Uma medida sem relação com a prevenção de câncer', 'Prevenção secundária, feita após o diagnóstico', 'Prevenção primária, evitando a infecção antes da exposição ao vírus',
  'E', 'Excelente! Vacinar antes da exposição ao vírus impede a infecção, o que caracteriza a prevenção primária. A vacina contra o HPV está disponível no SUS para meninas e meninos na faixa etária indicada.', 'Não foi dessa vez, mas você consegue! Prevenção primária atua antes de a doença ou a infecção surgir. Qual alternativa descreve isso? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-010', c.id, 3, 'O herpes genital, apesar de não ter cura definitiva, é controlável porque:',
  'O acompanhamento médico e o uso de medicamentos específicos podem reduzir a frequência e a intensidade das crises', 'O tratamento elimina completamente o vírus do organismo, mas pode aparecer sintomas com frequência', 'Não existe nenhuma forma de manejo clínico disponível', '“Controle” e “cura” significam exatamente a mesma coisa nesse contexto', 'O herpes genital nunca pode ser tratado',
  'A', 'Correto! O vírus permanece no organismo, mas os antivirais reduzem a frequência, a duração e a intensidade das crises e diminuem o risco de transmissão. Controlar não é o mesmo que curar.', 'Quase! Pense na diferença entre eliminar o vírus e controlar os sintomas. Qual alternativa descreve o que o tratamento realmente faz? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-011', c.id, 3, 'A redução do estigma social em torno das ISTs pode impactar positivamente os indicadores de saúde pública porque:',
  'O estigma não interfere na busca por serviços de saúde, mantendo os mesmos números independente do julgamento social', 'Pessoas tendem a buscar testagem e tratamento com menos receio de julgamento social', 'Reduzir o estigma aumenta diretamente a taxa de novas infecções', 'Não existe relação entre estigma social e comportamento de busca por diagnóstico', 'O estigma social só afeta doenças raras',
  'B', 'Muito bem! Sem medo de julgamento, as pessoas procuram testagem e tratamento mais cedo, o que reduz a transmissão. Acolhimento e informação são ferramentas de saúde pública.', 'Não desanime! Imagine alguém com medo de ser julgado: ele procura o serviço de saúde com facilidade? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-012', c.id, 3, 'O sedentarismo aumenta o risco cardiovascular mesmo em pessoas com peso adequado porque:',
  'O peso corporal é o único fator relevante para o risco cardiovascular, desconsiderado fatores metabólicos e fisiológicos', 'O sedentarismo não gera nenhum efeito fisiológico mensurável', 'Não existe relação entre atividade física e saúde do coração', 'Provoca alterações metabólicas e reduz a aptidão cardiorrespiratória, independentemente do peso corporal', 'O sedentarismo só afeta pessoas obesas',
  'D', 'Muito bem! Mesmo sem excesso de peso, a falta de atividade física prejudica o metabolismo e a capacidade do coração e dos pulmões. Movimentar-se é protetor para todos.', 'Não foi dessa vez, mas você consegue! Lembre-se de que o peso não é o único fator: o sedentarismo também afeta o metabolismo e o condicionamento do corpo. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-013', c.id, 3, 'A hipertensão é chamada de doença silenciosa porque:',
  'Pode se manter assintomática por longos períodos, mesmo causando danos progressivos a órgãos', 'Sempre apresenta sintomas graves e evidentes desde o início', 'Não representa nenhum risco à saúde a longo prazo', 'É facilmente identificada sem necessidade de exames', 'Só afeta pessoas com mais de 80 anos',
  'A', 'Acertou! A pressão alta muitas vezes não dá sintomas, mas vai lesionando coração, rins, cérebro e vasos. Por isso é importante medir a pressão regularmente.', 'Quase! Pense no sentido de “silenciosa”: a doença avisa que está presente, ou age sem dar sinais? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-014', c.id, 3, 'A combinação de sedentarismo, dieta rica em ultraprocessados e obesidade aumenta o risco de infarto e AVC porque:',
  'Favorece hipertensão, resistência à insulina e outros fatores de risco cardiovascular associados', 'Reduz automaticamente a pressão arterial e favorecendo o risco de doenças respiratórias', 'Afeta exclusivamente o sistema digestivo, sem repercussão cardiovascular', 'Só aumenta o risco de doenças respiratórias', null,
  'B', 'Muito bem! Esses hábitos juntos favorecem pressão alta, resistência à insulina e alterações do colesterol, que são os principais fatores de risco para infarto e AVC. Pequenas mudanças diárias já ajudam muito.', 'Não desanime! Pense nos efeitos desses três fatores no coração e nos vasos sanguíneos. Eles protegem ou aumentam o risco? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-015', c.id, 3, 'A anemia por deficiência de ferro está diretamente relacionada a fatores nutricionais porque decorre de:',
  'Exclusivamente fatores genéticos hereditários', 'Uma infecção viral específica', 'Excesso de vitamina C na dieta', 'Consumo excessivo de proteínas', 'Ingestão insuficiente ou perda excessiva de ferro',
  'E', 'Correto! O ferro é essencial para produzir hemoglobina. Quando a ingestão é insuficiente ou há perda de sangue, a hemoglobina diminui e surge a anemia. Feijão, carnes e folhas verde-escuras são boas fontes.', 'Quase! Pense no nome da doença: anemia por deficiência de ferro. O problema está no excesso ou na falta do mineral? Releia e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-016', c.id, 3, 'Entre os fatores de risco evitáveis relacionados a certos tipos de câncer, destacam-se:',
  'Idade avançada e exposição química', 'Histórico familiar e o fenótipo individual', 'Tabagismo e exposição solar excessiva', 'Sexo biológico', 'Altura da pessoa',
  'C', 'Excelente! Tabagismo e excesso de sol sem proteção são fatores de risco que podemos evitar, ao contrário de idade, sexo e histórico familiar. Parar de fumar e usar protetor solar reduzem o risco de vários tipos de câncer.', 'Não foi essa, mas continue! A pergunta pede fatores que a pessoa pode evitar. Idade, sexo e genética dão para mudar? Pense em hábitos e exposições e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-017', c.id, 3, 'A resistência à insulina é central no desenvolvimento do diabetes tipo 2 porque:',
  'Não tem nenhuma relação com o desenvolvimento do diabetes tipo 2 e sim da diabetes tipo 1', 'Aumenta a produção de insulina de forma que a pessoa precisa eliminá-la de alguma forma', 'É um mecanismo exclusivo do diabetes tipo 2, sendo essencial no diagnóstico da doença', 'Reduz a resposta das células à ação da insulina, dificultando a entrada de glicose e elevando os níveis de glicemia', 'Elimina completamente a glicose do sangue',
  'D', 'Muito bem! Na resistência à insulina, as células respondem mal ao hormônio, a glicose fica no sangue e a glicemia sobe. Alimentação equilibrada e atividade física melhoram a sensibilidade à insulina.', 'Quase lá! Pense na função da insulina: ajudar a glicose a entrar nas células. Se as células não respondem a ela, o que acontece com a glicose no sangue? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-018', c.id, 3, 'Obesidade, hipertensão e resistência à insulina são tratadas como parte de uma síndrome metabólica porque:',
  'Não apresentam nenhuma relação entre si', 'São sempre causadas por infecções virais que desencadeiam uma resposta no sistema imune, afetando as vias metabólicas', 'Ocorrem sempre de forma isolada, sem qualquer conexão fisiológica', 'Reduzem, juntas, o risco de uma possível doença viral', 'Formam um conjunto de fatores de risco interligados que aumentam substancialmente orisco cardiovascular',
  'E', 'Correto! Na síndrome metabólica, esses fatores se associam e se reforçam, elevando bastante o risco de doenças cardiovasculares e diabetes. Por isso são avaliados em conjunto.', 'Não desanime! Pense na palavra “síndrome”: um conjunto de alterações que aparecem juntas. Elas são independentes ou se reforçam? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-019', c.id, 3, 'O diagnóstico precoce de distúrbios da tireoide em crianças é importante porque:',
  'Distúrbios não tratados podem impactar diretamente o crescimento físico e o desenvolvimento cognitivo', 'A tireoide não desempenha função relevante durante a infância e sim a paratireoide', 'Não existe tratamento disponível para crianças com essas condições', 'Afeta apenas características estéticas, sem outras implicações', 'Só afeta apenas o apetite, sem precisar se preocupar com complicações futuras na vida dessa criança',
  'A', 'Acertou! Os hormônios da tireoide são essenciais para o crescimento e o desenvolvimento do cérebro. Por isso existe o teste do pezinho, que detecta o hipotireoidismo congênito logo nos primeiros dias de vida.', 'Quase! Lembre-se de que os hormônios da tireoide atuam no crescimento e no desenvolvimento do sistema nervoso. O que a falta deles pode causar na infância? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-020', c.id, 3, 'O acesso a espaços públicos de lazer pode impactar positivamente os indicadores de doenças crônicas não transmissíveis (DCNT) de uma comunidade porque:',
  'Não tem relação alguma com hábitos de saúde da população, pois questões físicas e mentais são completamente distintas', 'Favorece a prática regular de atividade física entre os moradores, um fator protetor reconhecido', 'Tende a aumentar o sedentarismo local por não oferecer estímulos reais a população', 'Substitui totalmente a necessidade de acesso a alimentação saudável, pois a pratica de atividades físicas supre essa necessidade', 'Aumenta o risco de doenças crônicas',
  'B', 'Muito bem! Praças, parques e quadras incentivam a atividade física, que protege contra diabetes, hipertensão e outras DCNT. Ambientes saudáveis facilitam escolhas saudáveis.', 'Não foi essa, mas você consegue! Pense no que um parque ou uma quadra estimulam nas pessoas e como isso se relaciona com o sedentarismo. Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-021', c.id, 3, 'Em uma relação sexual, consentimento significa:',   -- cenário deduzido
  'Concordar porque existe pressão do parceiro ou grupo de amigos.', 'Aceitar determinada situação para evitar conflitos.', 'Manifestar concordância de forma livre, consciente e sem coerção.', 'Considerar que um relacionamento anterior significa consentimento permanente.', null,
  'C', 'Perfeito! Consentimento é um “sim” livre, consciente e sem pressão, que pode ser retirado a qualquer momento. Sem consentimento, não há relação, e isso vale para qualquer tipo de relacionamento.', 'Quase! Para existir consentimento, a concordância precisa ser livre. Pressão, medo de conflito ou “já aconteceu antes” contam como um sim verdadeiro? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-022', c.id, 3, 'Uma adolescente suspeita que teve contato com uma IST. Qual conduta é mais adequada?',   -- cenário deduzido
  'Procurar um serviço de saúde para avaliação, orientação e, quando indicado, testagem.', 'Utilizar medicamentos que tenham funcionado para outra pessoa.', 'Esperar obrigatoriamente o surgimento de sintomas antes de procurar atendimento.', 'Evitar comentar a situação para impedir qualquer constrangimento.', null,
  'A', 'Isso mesmo! A unidade de saúde faz avaliação, testagem e tratamento de forma gratuita e sigilosa, e a procura precoce protege você e as pessoas com quem se relaciona.', 'Não desanime! Pense em quem pode avaliar a situação com segurança. Medicamento de outra pessoa ou esperar os sintomas são boas opções? Releia com calma as alternativas e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-023', c.id, 3, 'Pesquisadores criaram um tipo de plaqueta artificial, feita com um polímero gelatinoso coberto de anticorpos, que promete agilizar o processo de coagulação quando injetada no corpo. Se houver sangramento, esses anticorpos fazem com que a plaqueta mude sua forma e se transforme em uma espécie de rede que gruda nas lesões dos vasos sanguíneos e da pele. (MOUTINHO, S. Coagulação acelerada. Ciência Hoje, adaptado.) Qual a doença cujos pacientes teriam melhora de seu estado de saúde com o uso desse material?',   -- cenário deduzido
  'Filariose.', 'Hemofilia.', 'Aterosclerose.', 'Doença de Chagas.', 'Síndrome da imunodeficiência adquirida.',
  'B', 'Muito bem! A hemofilia é uma doença genética em que a coagulação do sangue é deficiente, e a plaqueta artificial ajudaria a formar o coágulo e estancar sangramentos. Plaquetas e fatores de coagulação são peças-chave nesse processo.', 'Não foi dessa vez, mas você consegue! A plaqueta artificial atua na coagulação. Qual das doenças listadas tem como problema central a dificuldade de coagular o sangue? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-024', c.id, 3, 'A retina é um tecido sensível à luz, localizado na parte posterior do olho, onde ocorre o processo de formação de imagem. Nesse tecido, encontram-se vários tipos celulares específicos. Um desses tipos celulares são os cones, os quais convertem os diferentes comprimentos de onda da luz visível em sinais elétricos, que são transmitidos pelo nervo óptico até o cérebro. (Disponível em: www.portaldaretina.com.br, adaptado.) Em relação à visão, a degeneração desse tipo celular irá',   -- cenário deduzido
  'comprometer a capacidade de visão em cores.', 'impedir a projeção dos raios luminosos na retina.', 'provocar a formação de imagens invertidas na retina.', 'causar dificuldade de visualização de objetos próximos.', 'acarretar a perda da capacidade de alterar o diâmetro da pupila.',
  'A', 'Correto! Os cones são as células responsáveis pela visão colorida e funcionam melhor com muita luz. Sua degeneração compromete a percepção das cores. Já os bastonetes atuam em pouca luz.', 'Não foi dessa vez, mas você consegue! O enunciado diz que os cones convertem diferentes comprimentos de onda da luz em sinais. Pense: comprimentos de onda diferentes correspondem a quê na nossa percepção? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-025', c.id, 3, 'A maioria das pessoas fica com a visão embaçada ao abrir os olhos debaixo d''água. Mas há uma exceção: o povo moken, que habita a costa da Tailândia. Essa característica se deve principalmente à adaptabilidade do olho e à plasticidade do cérebro, o que significa que você também, com algum treinamento, poderia enxergar relativamente bem debaixo d''água. Estudos mostraram que as pupilas de olhos de indivíduos moken sofrem redução significativa debaixo d''água, o que faz com que os raios luminosos incidam quase paralelamente ao eixo óptico da pupila. (GISLÉN, A. et al. Visual Training Improves Underwater Vision in Children. Vision Research, n. 46, 2006, adaptado.) A acuidade visual associada à redução das pupilas é fisicamente explicada pela diminuição',   -- cenário deduzido
  'da intensidade luminosa incidente na retina.', 'da difração dos feixes luminosos que atravessam a pupila.', 'da intensidade dos feixes luminosos em uma direção por polarização.', 'do desvio dos feixes luminosos refratados no interior do olho.', 'das reflexões dos feixes luminosos no interior do olho.',
  'D', 'Correto! Quando os raios incidem quase paralelos ao eixo óptico, o desvio causado pela refração diminui, e a imagem se forma com mais nitidez na retina. Por isso a pupila reduzida melhora a acuidade visual debaixo d''água.', 'Não desanime! Raios que incidem quase paralelos ao eixo óptico sofrem pouco desvio ao mudar de meio. Qual fenômeno físico está ligado a esse desvio da luz? Releia o texto e tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-026', c.id, 3, 'O “The Kidney Project” é um projeto realizado por cientistas que pretendem desenvolver um rim biônico que executará a maioria das funções biológicas do órgão. O rim biônico possuirá duas partes que incorporam recentes avanços de nanotecnologia, filtração de membrana e biologia celular. Esse projeto significará uma grande melhoria na qualidade de vida para aquelas pessoas que dependem da hemodiálise para sobrevivência. (Disponível em: https://pharm.ucsf.edu, adaptado.) O dispositivo criado promoverá diretamente a',   -- cenário deduzido
  'remoção de ureia.', 'excreção de lipídios.', 'síntese de vasopressina.', 'transformação de amônia.', 'fabricação de aldosterona.',
  'A', 'Muito bem! O rim filtra o sangue e remove resíduos como a ureia, função que a hemodiálise também realiza. O rim biônico substituiria essa filtração de forma contínua e mais prática para o paciente.', 'Quase! Pense na função principal dos rins e da hemodiálise: filtrar o sangue e eliminar quais resíduos nitrogenados? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-027', c.id, 3, 'Pesquisadores dos Estados Unidos desenvolveram uma nova técnica, que utiliza raios de luz infravermelha (invisíveis a olho nu) para destruir tumores. Primeiramente, o paciente recebe uma injeção com versões modificadas de anticorpos que têm a capacidade de “grudar” apenas nas células cancerosas. Sozinhos, eles não fazem nada contra o tumor. Entretanto, esses anticorpos estão ligados a uma molécula, denominada IR700, que funcionará como uma “microbomba”, que irá destruir o câncer. Em seguida, o paciente recebe raios infravermelhos. Esses raios penetram no corpo e chegam até a molécula IR700, que é ativada e libera uma substância que ataca a célula cancerosa. (Disponível em: http://super.abril.com.br, adaptado.) Com base nas etapas de desenvolvimento, o nome apropriado para a técnica descrita é:',   -- cenário deduzido
  'Radioterapia.', 'Cromoterapia.', 'Quimioterapia.', 'Fotoimunoterapia.', 'Terapia magnética.',
  'D', 'Muito bem! A técnica une luz (foto), anticorpos (imuno) e tratamento (terapia): daí o nome fotoimunoterapia. Decompor o nome ajuda a descobrir a resposta!', 'Quase! A técnica usa dois elementos: luz infravermelha e anticorpos. Qual nome combina os dois? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-028', c.id, 3, 'No processo de captação da luz pelo olho para a formação de imagens estão envolvidas duas estruturas celulares: os cones e os bastonetes. Os cones são sensíveis à energia dos fótons, e os bastonetes, à quantidade de fótons incidentes. A energia dos fótons que compõem os raios luminosos está associada à sua frequência, e a intensidade, ao número de fótons incidentes. Um animal que tem bastonetes mais sensíveis irá',   -- cenário deduzido
  'apresentar daltonismo.', 'perceber cores fora do espectro do visível.', 'enxergar bem em ambientes mal iluminados.', 'necessitar de mais luminosidade para enxergar.', 'fazer uma pequena distinção de cores em ambientes iluminados.',
  'C', 'Correto! Bastonetes respondem à quantidade de fótons, ou seja, à intensidade da luz. Quanto mais sensíveis, melhor o animal enxerga com pouca luz, como acontece com animais de hábitos noturnos.', 'Quase! O texto associa os bastonetes à quantidade de fótons, isto é, à intensidade luminosa. Bastonetes mais sensíveis ajudam em ambientes com muita ou com pouca luz? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-029', c.id, 3, 'Entre as diversas técnicas para diagnóstico da covid-19, destaca-se o teste genético. Considerando as diferentes variantes e cargas virais, um exemplo é a PCR, reação efetuada por uma enzima do tipo polimerase. Essa técnica permite identificar, com confiabilidade, o material genético do SARS-CoV-2, um vírus de RNA. Para comprovação da infecção por esse coronavírus, são coletadas amostras de secreções do indivíduo. Uma etapa que antecede a reação de PCR precisa ser realizada para permitir a amplificação do material genético do vírus. Essa etapa deve ser realizada para',   -- cenário deduzido
  'concentrar o RNA viral para otimizar a técnica.', 'identificar nas amostras anticorpos anti-SARS-CoV-2.', 'proliferar o vírus em culturas, aumentando a carga viral.', 'purificar ácidos nucleicos virais, facilitando a ação da enzima.', 'obter moléculas de cDNA viral por meio da transcrição reversa.',
  'E', 'Correto! A PCR amplifica DNA, mas o SARS-CoV-2 tem RNA. Por isso, antes da reação, a transcriptase reversa converte o RNA viral em DNA complementar (cDNA), que então pode ser amplificado.', 'Quase! A polimerase da PCR trabalha com DNA, e o vírus tem RNA. Que etapa transforma RNA em DNA antes da amplificação? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-030', c.id, 3, 'Durante o ano de 2020, impulsionado pela necessidade de respostas rápidas e eficientes para desinfectar ambientes de possíveis contaminações com o SARS-CoV-2, causador da covid-19, diversas alternativas foram buscadas para os procedimentos de descontaminação de materiais e ambientes. Entre elas, o uso de ozônio em meio aquoso como agente sanitizante para pulverização em humanos e equipamentos de proteção em câmaras ou túneis, higienização de automóveis e de ambientes fechados e descontaminação de trajes. No entanto, pouca atenção foi dada à toxicidade do ozônio, à formação de subprodutos, ao nível de concentração segura e às precauções necessárias. (LIMA, M. J. A.; FELIX, E. P.; CARDOSO, A. A. Química Nova, n. 9, 2021, adaptado.) O grande risco envolvido no emprego indiscriminado dessa substância deve-se à sua ação química como',   -- cenário deduzido
  'catalisador.', 'oxidante.', 'redutor.', 'ácido.', 'base.',
  'B', 'Correto! O ozônio é um oxidante muito forte: é isso que o torna um bom sanitizante, mas também o que o torna tóxico para os tecidos humanos, como o pulmão. Concentração e precauções importam!', 'Quase! O poder de “desinfetar” vem da capacidade de reagir fortemente com outras substâncias, retirando elétrons delas. Qual termo descreve essa ação química? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-031', c.id, 3, 'Muitas mulheres sofrem com desconfortos nos dias que antecedem a menstruação, a chamada tensão pré-menstrual. Entre outros sintomas, podem ocorrer alterações de humor. Atualmente, acredita-se que os sintomas são resultado da queda na concentração do neurotransmissor serotonina, que, por sua vez, está relacionado com a diminuição na produção dos hormônios ovarianos estrógeno e progesterona, observada nessa fase do ciclo feminino. (DIMMOCK, P. W. et al. The Lancet, n. 9 236,2000, adaptado.) A redução da produção desses hormônios nessa fase está relacionada com o(a)',   -- cenário deduzido
  'regressão do corpo lúteo ovariano.', 'diminuição na produção de ocitocina.', 'liberação do gameta feminino na ovulação.', 'aumento nos níveis dos hormônios LH e FSH.', 'elevação nos níveis sorológicos de adrenalina.',
  'A', 'Muito bem! Se não há fecundação, o corpo lúteo regride no final do ciclo e deixa de produzir progesterona e estrógeno. Essa queda hormonal antecede a menstruação e está ligada aos sintomas da TPM.', 'Não foi dessa vez, mas você consegue! Depois da ovulação, o corpo lúteo produz progesterona. O que acontece com ele no fim do ciclo, quando não há gravidez? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-032', c.id, 3, 'O vírus linfotrópico de células T humanas tipo 1 (HTLV-1) é um retrovírus do mesmo grupo do vírus da imunodeficiência humana (HIV). Ambos são transmitidos da mesma forma e infectam as mesmas células de defesa do organismo, os linfócitos T. A diferença entre eles é que o HTLV-1 estimula o aumento da produção desses linfócitos, enquanto o HIV causa destruição dessas células. (O vírus linfotrópico de células T humanas tipo 1 (HTLV-1): quando suspeitar da infecção? Revista da Associação Médica Brasileira, v. 56, 2010, adaptado.) Uma possível consequência da infecção por HTLV-1 é o desenvolvimento de',   -- cenário deduzido
  'aids.', 'câncer.', 'diabetes.', 'hepatite B.', 'hemorragia.',
  'B', 'Correto! O HTLV-1 estimula a multiplicação dos linfócitos T, e o aumento descontrolado de células pode levar a leucemias e linfomas, que são tipos de câncer. A aids, ao contrário, vem da destruição dessas células pelo HIV.', 'Quase! O texto diz que o HTLV-1 aumenta a produção de linfócitos T. O que costuma acontecer quando as células se multiplicam de forma descontrolada? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UBS-N3-033', c.id, 3, 'Com base em testes realizados em ratos, concluiu-se que os compostos nitrosos são substâncias mutagênicas, ou seja, produzem mutações nas células e possivelmente câncer. Esses compostos podem ser obtidos pela reação entre o nitrito de sódio, que é um conservante adicionado às carnes, e o ácido clorídrico. O ácido nitroso produzido irá reagir com compostos nitrogenados, como as aminas, dando origem aos compostos nitrosos. Em qual órgão esse processo será iniciado?',   -- cenário deduzido
  'Rim.', 'Fígado.', 'Intestino.', 'Pâncreas.', 'Estômago.',
  'E', 'Muito bem! O ácido clorídrico faz parte do suco gástrico, produzido no estômago. É lá que o nitrito das carnes processadas reage com ele e dá início à formação dos compostos nitrosos. Moderar o consumo de embutidos é uma boa prática.', 'Não desanime! A reação precisa de ácido clorídrico. Em qual órgão do sistema digestivo o HCl é produzido? Vamos tentar novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'ubs'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;


-- ── UPA — 33 questões (26 com cenário da equipe, 7 deduzidas) ──

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-005', c.id, 1, 'SAMU pode ajudar pessoas que estão passando por uma situação de emergência. Sobre o serviço, qual alternativa está correta?',
  'O SAMU funciona somente durante o dia.', 'O SAMU pode ser chamado gratuitamente pelo número 192.', 'Para chamar o SAMU, é preciso pagar.', 'O SAMU atende apenas pessoas que sofreram acidentes.', null,
  'B', 'Isso! O SAMU funciona todos os dias, a qualquer hora, e a ligação para o número 192 é gratuita. Guarde esse número!', 'Boa tentativa! Releia o começo da pergunta: ele traz pistas importantes sobre o número, o custo e os dias de funcionamento do SAMU. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-006', c.id, 1, 'SAMU conta com profissionais preparados para orientar as pessoas durante uma emergência. O que acontece quando ligamos para o 192?',
  'A ligação é encerrada imediatamente.', 'Os profissionais coletam informações e podem orientar sobre os primeiros cuidados.', 'A pessoa que ligou precisa ir até uma ambulância para receber atendimento.', 'O SAMU sempre envia um avião, independentemente da situação.', null,
  'B', 'Isso! Quando ligamos para o 192, os profissionais do SAMU fazem perguntas sobre o que aconteceu e podem orientar os primeiros cuidados até a ajuda chegar.', 'Quase! Os profissionais do SAMU estão ali para ajudar. O que será que eles fazem quando atendem a ligação? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-007', c.id, 1, 'Se uma pessoa estiver com um problema respiratório grave e não conseguir respirar direito (como em um caso de engasgo ou sufocamento), o que deve ser feito?',   -- cenário deduzido
  'Devemos esperar a pessoa se recuperar sozinha.', 'Devemos ligar para o SAMU 192, pois problemas respiratórios são situações de urgência.', 'Devemos dar algo pesado para a pessoa comer.', 'Não é necessário chamar ajuda se a pessoa estiver acordada.', null,
  'B', 'Certo! Dificuldade para respirar, como no engasgo ou no sufocamento, é uma urgência. Ligar rápido para o 192 pode salvar uma vida, e o SAMU orienta o que fazer enquanto a ajuda chega.', 'Não desanime! Respirar é essencial para o nosso corpo. Se alguém não consegue respirar direito, dá para esperar? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-008', c.id, 1, 'A Unidade Básica de Saúde (UBS) é o local ideal para cuidar da saúde no dia a dia. Em quais dias e horários os moradores devem procurar a sua UBS de referência?',
  'Somente de madrugada.', 'Apenas aos domingos à noite.', 'De segunda a sexta-feira, das 7h às 17h.', 'Funciona 24 horas sem parar todos os dias.', null,
  'C', 'Isso! A UBS funciona, em geral, de segunda a sexta-feira, em horário comercial, para o cuidado do dia a dia. Vale confirmar o horário da UBS do seu bairro.', 'Quase! A UBS cuida da saúde do dia a dia, e não funciona 24 horas. Pense em horários de dias de trabalho. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-009', c.id, 1, 'A Camila sentiu uma dor de cabeça fraca e incômodo no corpo após correr no parque. Como não é uma emergência grave, onde ela deve ser atendida?',
  'Na Unidade de Pronto Atendimento (UPA).', 'Na Unidade Básica de Saúde (UBS).', 'No hospital da cidade.', 'No supermercado.', null,
  'B', 'Correto! Uma dor de cabeça fraca sem gravidade pode ser atendida na UBS. A UPA fica para urgências.', 'Quase! A dor de Camila é leve e não é uma emergência. Qual serviço cuida desses casos do dia a dia? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-010', c.id, 1, 'Você sabe o que é uma Unidade de Pronto atendimento (UPA)?',
  'Um lugar onde as pessoas vão para fazer consultas de rotina.', 'Um lugar onde somente adultos podem ser atendidos.', 'Um lugar onde são feitas apenas exames de rotina', 'Um serviço de saúde preparado para atender pessoas que precisam de atendimento de urgência.', null,
  'D', 'Muito bem! A UPA é um serviço de saúde preparado para atender urgências, funciona 24 horas e recebe pessoas de todas as idades.', 'Quase! O nome já dá uma dica: "pronto atendimento". Para que tipo de situação ele serve? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-011', c.id, 1, 'Quando uma pessoa deve procurar uma uma Unidade de Pronto atendimento (UPA)?',
  'Quando precisa de atendimento de urgência e não pode esperar por uma consulta de rotina.', 'Sempre que quiser conversar sobre qualquer assunto.', 'Somente para tomar vacinas e fazer consultas de rotina.', 'Apenas quando precisar fazer um exame de sangue.', null,
  'A', 'Isso! Procuramos a UPA quando precisamos de atendimento de urgência e não dá para esperar por uma consulta de rotina.', 'Boa tentativa! A UPA não é para conversar, vacinar ou fazer exames de rotina. Quando ela é necessária? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-012', c.id, 1, 'Caio procurou uma Unidade de Pronto atendimento (UPA) porque está passando mal. Depois de ser atendido, ele precisa continuar acompanhando sua saúde. O que Caio deve fazer?',
  'Ele nunca mais precisará procurar nenhum serviço de saúde.', 'Ele deve sempre voltar para UPA para acompanhar sua saúde.', 'Ele deve voltar lá para fazer exames e consultas de rotina.', 'Ele pode continuar o acompanhamento na UBS, quando esse acompanhamento for necessário.', null,
  'D', 'Correto! Depois do atendimento de urgência na UPA, o acompanhamento da saúde pode continuar na UBS, quando necessário. Os dois serviços se complementam.', 'Quase! A UPA resolve a urgência, mas depois o cuidado continua. Onde fica o acompanhamento do dia a dia? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-013', c.id, 1, 'Maria está com uma dor forte que começou de repente e precisa ser avaliado rapidamente por um profissional de saúde. Qual serviço pode ajudá-la?',
  'Uma farmácia grande', 'Unidade Básica de Saúde (UBS)', 'Uma funerária', 'Unidade de Pronto atendimento (UPA).', null,
  'D', 'Muito bem! Uma dor forte que começou de repente precisa ser avaliada rápido, e a UPA está preparada para esse tipo de urgência.', 'Quase! A dor de Maria é forte e começou de repente. Qual serviço atende urgências? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-014', c.id, 1, 'Por que é importante que a UPA e a UBS tenham uma boa comunicação?',
  'Para que as informações importantes sobre o cuidado da pessoa possam ser compartilhadas.', 'Para que a pessoa precise contar a mesma história muitas vezes.', 'Para que somente a UPA possa cuidar da pessoa.', 'Porque assim os profissionais não precisam conversar com os pacientes.', null,
  'A', 'Isso! Quando a UPA e a UBS conversam, as informações importantes sobre o cuidado da pessoa são compartilhadas e o tratamento continua sem falhas.', 'Boa tentativa! Pense no que acontece quando dois serviços trocam informações sobre o mesmo paciente. Isso ajuda ou atrapalha? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-015', c.id, 1, 'Por que algumas pessoas acabam procurando a UPA mesmo quando não estão em uma situação de urgência?',
  'Porque a UBS não está preparada para fazer acompanhamento constante.', 'Porque a UPA atende somente doenças graves.', 'Porque podem ter dúvidas sobre qual serviço procurar ou encontrar dificuldades para conseguir atendimento em outros serviços.', 'Porque toda consulta deve acontecer na UPA.', null,
  'C', 'Correto! Às vezes as pessoas procuram a UPA por dúvida sobre qual serviço escolher ou por dificuldade de conseguir atendimento em outros lugares. Por isso é bom conhecer o papel de cada serviço.', 'Quase! Nem todo mundo sabe qual serviço procurar ou consegue atendimento com facilidade. Qual alternativa explica isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-016', c.id, 1, 'Qual situação mostra melhor a diferença entre a UBS e a UPA?',
  'A UPA faz prevenção e a UBS atende apenas acidentes e situações de emergência.', 'A UBS atende somente crianças e a UPA somente adultos.', 'Os dois serviços têm exatamente a mesma função.', 'A UBS atua no acompanhamento e na prevenção da saúde, já a UPA atende situações que precisam de cuidado de urgência.', null,
  'D', 'Muito bem! A UBS acompanha a saúde e previne doenças no dia a dia, e a UPA atende situações que precisam de cuidado urgente. Cada uma tem o seu papel!', 'Quase! UBS e UPA são serviços diferentes. Qual alternativa explica o papel de cada uma? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-017', c.id, 1, 'Você sabe diferenciar quando ir na UBS ou UPA? João está com dor de garganta leve há alguns dias, sem dificuldade para respirar. Ele quer saber onde pode receber ajuda. Maria caiu enquanto brincava, está com muita dor e não consegue mexer o braço direito. Qual alternativa mostra corretamente onde cada um deve procurar atendimento?',   -- cenário deduzido
  'João → UBS; Maria → UPA.', 'João → UPA; Maria → UBS.', 'João → UPA; Maria → UPA.', 'João → UBS; Maria → UBS.', null,
  'A', 'Parabéns! João, com dor de garganta leve, pode ir à UBS. Maria, com muita dor e sem conseguir mexer o braço, precisa da UPA. Saber escolher ajuda a ser atendido mais rápido.', 'Quase! Veja a gravidade de cada caso: um é leve e o outro é urgente. Onde cada um deve procurar atendimento? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-018', c.id, 1, 'Durante toda a gravidez, a mamãe do Pedro foi até a Unidade Básica de Saúde (UBS) para fazer as consultas de rotina do pré-natal (acompanhamento médico da gestante e do bebê antes do nascimento). Mas, se ela sentir dores fortes e urgentes ou precisar de atendimento emergencial 24 horas para ser encaminhada ao hospital, para onde a família deve levá-la?',
  'Para a Unidade de Pronto Atendimento (UPA).', 'Para a escola.', 'Para a UBS.', 'Para a farmácia.', null,
  'A', 'Correto! O pré-natal é na UBS, mas, em caso de dores fortes e urgentes, a UPA atende 24 horas e encaminha para o hospital se for preciso.', 'Quase! O pré-natal é feito na UBS, mas uma urgência precisa de atendimento 24 horas. Qual serviço faz isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-019', c.id, 1, 'Lucas mora em uma cidadezinha no interior que não tem hospital, mas conta com uma Unidade de Pronto Atendimento (UPA 24h). Enquanto brincava, o irmão do Lucas sofreu um acidente e fez um corte profundo. Por ser uma emergência com machucado que precisa de atendimento médico e cuidados imediatos, para onde a família deve levá-lo?',
  'Ir para a Unidade Básica de Saúde (UBS) e aguardar até o dia seguinte para agendar uma consulta.', 'Ir imediatamente para a Unidade de Pronto Atendimento (UPA 24h).', 'Ir à farmácia apenas para comprar um curativo adesivo simples.', 'Ficar em casa esperando o machucado sarar sozinho.', null,
  'B', 'Muito bem! Em uma emergência com corte profundo, a família deve ir imediatamente à UPA 24h, que atende urgências a qualquer hora.', 'Quase! Um corte profundo é urgente e não pode esperar até o dia seguinte. Para onde a família deve ir? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-020', c.id, 1, 'A avô da Beatriz sentiu uma dor muito forte no peito e uma falta de ar intensa de repente. Qual serviço emergencial é preparado para esse atendimento?',   -- cenário deduzido
  'Unidade Básica de Saúde (UBS).', 'Unidade de Pronto Atendimento (UPA).', 'Mercado da cidade.', 'Praça do bairro.', null,
  'B', 'Isso! Dor forte no peito e falta de ar repentina são sinais graves, e a UPA está preparada para atender. Também é possível ligar para o SAMU, no 192.', 'Quase! Dor forte no peito e falta de ar são sinais graves. Qual serviço atende urgências? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-021', c.id, 1, 'A Aninha não consegue parar nada no estômago e está vomitando constantemente há várias horas. Para onde a família deve levá-la?',   -- cenário deduzido
  'Para a Unidade Básica de Saúde (UBS).', 'Para a Unidade de Pronto Atendimento (UPA).', 'Para a escola.', 'Para o cinema.', null,
  'B', 'Correto! Vômitos constantes por várias horas precisam de atendimento rápido, porque o corpo pode ficar sem líquidos. A UPA pode cuidar da Aninha.', 'Quase! Vomitar sem parar por horas é uma urgência. Qual serviço atende rapidamente? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N1-022', c.id, 1, 'Se uma pessoa ingerir por engano um produto de limpeza perigoso (intoxicação), em qual unidade do SUS ela deve ser socorrida de imediato?',   -- cenário deduzido
  'Na Unidade de Pronto Atendimento (UPA).', 'Na farmácia.', 'Na casa de um vizinho.', 'Na Unidade Básica de Saúde (UBS).', null,
  'A', 'Certo! Em casos de intoxicação, o socorro imediato é na UPA. Também se pode ligar para o SAMU, no 192, e seguir a orientação dos profissionais.', 'Quase! Intoxicação é uma urgência e não pode esperar. Qual unidade do SUS atende urgências? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-006', c.id, 2, 'UPA significa:',
  'Unidade Preventiva de Atendimento.', 'Unidade Primária Ambulatorial.', 'Unidade de Pronto Atendimento.', 'Unidade Pública de Acompanhamento.', null,
  'C', 'Correto! UPA significa Unidade de Pronto Atendimento.', 'Não foi dessa vez. Pense na unidade que presta atendimento rápido. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-007', c.id, 2, 'A principal característica da UPA apresentada no jogo é:',
  'realizar apenas vacinação.', 'atender problemas que precisam de avaliação e cuidado com maior urgência.', 'realizar exclusivamente consultas preventivas.', 'acompanhar todas as pessoas durante anos.', null,
  'B', 'Isso mesmo! A UPA atende problemas que exigem avaliação e cuidado com maior urgência.', 'Quase! A UPA tem foco na urgência. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-008', c.id, 2, 'UBS e UPA:',
  'possuem exatamente a mesma função.', 'competem entre si pelos pacientes.', 'fazem parte da rede de saúde, mas possuem papéis diferentes.', 'atendem exclusivamente crianças.', null,
  'C', 'Muito bem! UBS e UPA fazem parte da rede de saúde, mas têm papéis diferentes.', 'Não foi dessa vez. Elas se complementam em vez de competir. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-009', c.id, 2, 'Saber reconhecer situações urgentes é importante porque:',
  'qualquer sintoma exige atendimento de emergência.', 'ajuda a procurar o serviço adequado sem atrasar cuidados necessários.', 'elimina a necessidade de profissionais de saúde.', 'permite realizar diagnósticos sozinho.', null,
  'B', 'Correto! Reconhecer situações urgentes ajuda a procurar o serviço certo sem atrasar o cuidado.', 'Quase! Nem todo sintoma é emergência, e saber a diferença ajuda. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-010', c.id, 2, 'Para um problema que exige avaliação mais urgente, qual serviço do cenário é voltado a esse tipo de atendimento?',   -- cenário deduzido
  'Escola.', 'Mercado.', 'UPA.', 'Parque.', null,
  'C', 'Boa! A UPA é o serviço do cenário voltado a problemas que exigem avaliação mais urgente.', 'Quase! Escola, mercado e parque não são serviços de saúde. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-011', c.id, 2, 'Por que não devemos tratar UBS e UPA como sinônimos?',
  'Porque apenas uma delas pertence à saúde.', 'Porque desempenham funções diferentes dentro da rede de cuidados.', 'Porque UBS existe somente em áreas rurais.', 'Porque UPA realiza apenas atividades educativas.', null,
  'B', 'Correto! UBS e UPA desempenham funções diferentes dentro da rede de cuidados.', 'Não foi dessa vez. Ambos são serviços de saúde, mas com funções distintas. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-012', c.id, 2, 'O conceito de “rede de saúde” indica que:',
  'todos os serviços realizam exatamente as mesmas tarefas.', 'diferentes serviços possuem funções que se complementam no cuidado da população.', 'somente hospitais são necessários.', 'prevenção e urgência devem ocorrer no mesmo local.', null,
  'B', 'Muito bem! Em uma rede de saúde, diferentes serviços têm funções que se complementam.', 'Quase! “Rede” indica cooperação entre serviços diferentes. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-013', c.id, 2, 'Qual situação combina mais com acompanhamento contínuo do que com pronto atendimento?',
  'Problema agudo que exige avaliação rápida.', 'Acompanhamento preventivo e orientações de saúde.', 'Situação que necessita cuidado com maior urgência.', 'Problema que precisa de avaliação imediata.', null,
  'B', 'Isso mesmo! Acompanhamento preventivo e orientações combinam com cuidado contínuo, e não com pronto atendimento.', 'Não foi dessa vez. Procure a situação ligada a acompanhamento, e não a urgência. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-014', c.id, 2, 'A escolha adequada do serviço de saúde:',
  'não interfere na organização do cuidado.', 'deve ser feita apenas pela distância.', 'depende também do tipo e da urgência da necessidade.', 'significa utilizar sempre a UPA.', null,
  'C', 'Correto! A escolha do serviço depende do tipo e da urgência da necessidade.', 'Quase! Nem sempre dá para usar o mesmo serviço. O que influencia a escolha? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-015', c.id, 2, 'A UPA substitui completamente a UBS?',
  'Sim, porque ambas pertencem à rede de saúde.', 'Não, porque possuem papéis diferentes no cuidado.', 'Sim, porque a UPA realiza toda prevenção.', 'Não, porque a UBS atende apenas emergências.', null,
  'B', 'Muito bem! A UPA não substitui a UBS: cada uma tem seu papel no cuidado.', 'Não foi dessa vez. As funções são diferentes. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-016', c.id, 2, 'A UBS substitui completamente a UPA?',
  'Sim, pois toda situação pode esperar.', 'Sim, porque são serviços idênticos.', 'Não, pois algumas situações exigem atendimento com maior urgência.', 'Não, porque a UBS não pertence à rede de saúde.', null,
  'C', 'Correto! A UBS não substitui a UPA, pois, algumas situações exigem atendimento com maior urgência.', 'Quase! Algumas situações não podem esperar. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-017', c.id, 2, 'Entender os diferentes serviços do SUS ajuda:',
  'apenas profissionais de saúde.', 'a população a procurar cuidados mais adequados às suas necessidades.', 'somente pessoas com doenças crônicas.', 'exclusivamente adultos.', null,
  'B', 'Isso mesmo! Conhecer os serviços do SUS ajuda a população a procurar o cuidado mais adequado.', 'Não foi dessa vez. Esse conhecimento é útil para todas as pessoas. Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-018', c.id, 2, 'Qual associação está CORRETA segundo os cenários do jogo?',
  'UBS → somente emergências graves.', 'UPA → acompanhamento preventivo contínuo.', 'UBS → prevenção e acompanhamento; UPA → situações de maior urgência.', 'UBS e UPA → funções completamente iguais.', null,
  'C', 'Correto! UBS: prevenção e acompanhamento; UPA: situações de maior urgência.', 'Quase! Cuidado com associações trocadas. Qual está certa? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N2-019', c.id, 2, 'Qual aprendizagem central o cenário UPA pretende desenvolver?',
  'Ensinar estudantes a diagnosticar doenças sozinhos.', 'Incentivar a procura da UPA para qualquer problema.', 'Reconhecer a importância da urgência e compreender os diferentes papéis da rede de saúde.', 'Mostrar que prevenção não é necessária quando existe pronto atendimento.', null,
  'C', 'Excelente! O cenário busca reconhecer a importância da urgência e entender os diferentes papéis da rede de saúde.', 'Não foi dessa vez. O objetivo é saber usar bem cada serviço. Qual alternativa expressa isso? Vamos tentar novamente?',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;

insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select 'UPA-N3-001', c.id, 3, 'O veneno da cascavel pode causar hemorragia com risco de morte a quem é picado pela serpente. No entanto, pesquisadores do Brasil e da Bélgica desenvolveram uma molécula de interesse farmacêutico, a PEG-collineína-1, a partir de uma proteína encontrada no veneno dessa cobra, capaz de modular a coagulação sanguínea. Embora a técnica não seja nova, foi a primeira vez que o método foi usado a partir de uma toxina animal na sua forma recombinante, ou seja, produzida em laboratório por um fungo geneticamente modificado. (JULIÃO, A. Agência Fapesp, 22 nov. 2021, adaptado.) Esse novo medicamento apresenta potencial aplicação para',   -- cenário deduzido
  'impedir a formação de trombos, típicos em alguns casos de acidente vascular cerebral.', 'tratar consequências da anemia profunda, em razão da perda de grande volume de sangue.', 'evitar a manifestação de urticárias, comumente relacionadas a processos alérgicos.', 'reduzir o inchaço dos linfonodos, parte da resposta imunitária de diferentes infecções.', 'regular a oscilação da pressão arterial, característica dos quadros de hipertensão.',
  'A', 'Muito bem! O veneno de cascavel causa hemorragia por interferir na coagulação, e a molécula derivada modula esse processo. Uma aplicação potencial é impedir a formação de trombos (coágulos), que podem causar AVC.', 'Não foi dessa vez, mas você consegue! A molécula modula a coagulação do sangue. Qual das situações descritas tem como problema a formação de coágulos que entopem vasos? Tente novamente.',
  '00000000-0000-0000-0000-000000000000'
from cenarios c where c.slug = 'upa'
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;



-- Áreas que cada questão pontua (a primeira vale 10, as demais 5).

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'CASA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'CASA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'CASA-N1-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'CASA-N1-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'CASA-N1-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'CASA-N1-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'CASA-N1-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'CASA-N1-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'CASA-N1-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'CASA-N1-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'CASA-N1-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N1-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'CASA-N1-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'CASA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'CASA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CASA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'CORREGO-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'CORREGO-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'CORREGO-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'CORREGO-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'CORREGO-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'CORREGO-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'CRECHE-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'CRECHE-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'CRECHE-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'ESCOLA-N1-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'ESCOLA-N1-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-039'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-051'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-051'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-051'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-052'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-052'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-052'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-053'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-053'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-053'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-054'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-054'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-054'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-055'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-055'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-055'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-056'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-056'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-056'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-057'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-057'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-057'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-058'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-058'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-058'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-059'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-059'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-059'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-060'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-060'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-060'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-061'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-061'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-061'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-062'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-062'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-062'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-063'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-063'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-063'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-064'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-064'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-064'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-065'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-065'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-065'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-066'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-066'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-066'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-067'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-067'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-067'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'ESCOLA-N3-068'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-068'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'ESCOLA-N3-068'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'FARMACIA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'FARMACIA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'FARMACIA-N3-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'FARMACIA-N3-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'MERCADO-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'MERCADO-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'MERCADO-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N2-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N3-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N3-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Alimentação', 10 from questoes q where q.codigo_externo = 'MERCADO-N3-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'MERCADO-N3-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'PARQUE-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'PARQUE-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 10 from questoes q where q.codigo_externo = 'PRACA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'PRACA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'PRACA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Exercícios', 10 from questoes q where q.codigo_externo = 'QUADRA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'QUADRA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'TERRENOBA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vetores', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'TERRENOBA-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 10 from questoes q where q.codigo_externo = 'UBS-N1-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N2-034'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-035'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-036'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-037'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-038'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-039'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-039'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-039'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-040'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-041'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-042'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-043'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-044'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-045'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-046'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-047'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-048'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-049'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UBS-N2-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N2-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N2-050'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N3-002'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-003'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-004'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'UBS-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N3-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'UBS-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UBS-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UBS-N3-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 10 from questoes q where q.codigo_externo = 'UBS-N3-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-023'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-024'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-025'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-026'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-027'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-028'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-029'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-030'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-031'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-032'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UBS-N3-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UBS-N3-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UBS-N3-033'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'UPA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'UPA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-005'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 10 from questoes q where q.codigo_externo = 'UPA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 5 from questoes q where q.codigo_externo = 'UPA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N1-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N1-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Vacinação', 5 from questoes q where q.codigo_externo = 'UPA-N1-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N1-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N1-020'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N1-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N1-021'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N1-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N1-022'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-006'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-007'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-008'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-009'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N2-010'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-011'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-012'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-013'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-014'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-015'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-016'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-017'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-018'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Felicidade', 10 from questoes q where q.codigo_externo = 'UPA-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Limpeza', 5 from questoes q where q.codigo_externo = 'UPA-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 5 from questoes q where q.codigo_externo = 'UPA-N2-019'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Saúde', 10 from questoes q where q.codigo_externo = 'UPA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;

insert into questoes_areas (questao_id, area_nome, pontos)
select q.id, 'Educação', 5 from questoes q where q.codigo_externo = 'UPA-N3-001'
on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;



-- Refaz as metas das barras com o conteúdo novo.
select public.recalcular_metas();

notify pgrst, 'reload schema';
