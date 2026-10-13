-- =====================================================================
--  O CATÁLOGO DE INSÍGNIAS — Heróis da Saúde
--
--  Todas as insígnias do jogo, com a arte de cada uma (63 linhas):
--
--     5  perguntas certas em qualquer lugar      perguntas1..5.png
--     3  dias seguidos de entrada                diaria1..3.png
--     3  tarefas do professor concluídas         professor1..3.png
--     4  missões concluídas pelos lugares        missoes1..4.png
--    48  acertos em cada lugar: 16 × 3 degraus   <lugar>1..3.png
--
--  Dialeto: PostgreSQL (Supabase).
--  Onde rodar: painel do Supabase -> SQL Editor, DEPOIS do db/setup.sql
--  (é ele que cria a tabela, as colunas cenario_slug e grupo e as
--  regras). Pode ser executado mais de uma vez sem quebrar nada.
--
--  ESTE ARQUIVO É A FONTE DA VERDADE. Para calibrar um alvo, trocar um
--  nome ou ligar uma arte nova, edite aqui e rode de novo. Quem já
--  conquistou não perde: a conquista mora em insignias_usuarios e não é
--  recalculada quando a linha muda.
--
--  Os alvos e o XP das insígnias novas (missões e lugares) são um
--  primeiro chute, a calibrar quando houver turma jogando de verdade.
-- =====================================================================


-- ── Guarda: o setup.sql novo tem de ter rodado antes ─────────────────

do $$
begin
  if (select count(*) from information_schema.columns
       where table_schema = 'public' and table_name = 'insignias'
         and column_name in ('cenario_slug', 'grupo')) < 2 then
    raise exception 'A tabela insignias ainda não tem as colunas cenario_slug e grupo. Rode db/setup.sql antes deste arquivo.';
  end if;
end $$;


-- ── As peças avulsas ─────────────────────────────────────────────────
--
-- PERGUNTAS (ACERTOS): questões distintas acertadas, em qualquer lugar.
-- A primeira a 10 é de propósito: uma estante que só começa a 25 fica
-- vazia tempo demais.
--
-- DIÁRIAS (DIAS): dias SEGUIDOS de entrada — o prêmio diário.
--
-- PROFESSOR (MISSOES): quizzes inteiros concluídos, como a lista de
-- missões do mapa e a tela de progresso contam.
--
-- MISSÕES (MISSOES_CENARIO): cada lugar de um quiz concluído conta 1.
-- Um quiz com perguntas da UBS, da Escola e do Mercado vale 3 — é a
-- missão como o aluno a vê no mapa, um lugar de cada vez.

insert into insignias (codigo, nome, descricao, publico, regra, alvo, xp, ordem, imagem) values
  ('primeiros-passos',     'Primeiros Passos',     'Acertou as 10 primeiras perguntas do bairro.',                 'ALUNO', 'ACERTOS',          10,  50,  1, 'perguntas1.png'),
  ('pe-na-estrada',        'Pé na Estrada',        'Vinte e cinco perguntas certas. O bairro já conhece você.',    'ALUNO', 'ACERTOS',          25, 100,  2, 'perguntas2.png'),
  ('meio-caminho',         'Meio Caminho',         'Cinquenta perguntas certas.',                                  'ALUNO', 'ACERTOS',          50, 200,  3, 'perguntas3.png'),
  ('centuriao',            'Centurião',            'Cem perguntas certas. Pouca gente chega aqui.',                'ALUNO', 'ACERTOS',         100, 400,  4, 'perguntas4.png'),
  ('enciclopedia',         'Enciclopédia',         'Duzentas perguntas certas.',                                   'ALUNO', 'ACERTOS',         200, 800,  5, 'perguntas5.png'),

  ('de-volta',             'De Volta',             'Jogou três dias seguidos.',                                    'ALUNO', 'DIAS',              3,  50,  6, 'diaria1.png'),
  ('semana-cheia',         'Semana Cheia',         'Sete dias seguidos cuidando do bairro.',                       'ALUNO', 'DIAS',              7, 150,  7, 'diaria2.png'),
  ('presenca-de-ouro',     'Presença de Ouro',     'Trinta dias seguidos.',                                        'ALUNO', 'DIAS',             30, 600,  8, 'diaria3.png'),

  ('primeira-missao',      'Primeira Missão',      'Concluiu a primeira tarefa do professor.',                     'ALUNO', 'MISSOES',           1,  50,  9, 'professor1.png'),
  ('mao-na-massa',         'Mão na Massa',         'Concluiu cinco tarefas do professor.',                         'ALUNO', 'MISSOES',           5, 150, 10, 'professor2.png'),
  ('missao-cumprida',      'Missão Cumprida',      'Concluiu dez tarefas do professor.',                           'ALUNO', 'MISSOES',          10, 300, 11, 'professor3.png'),

  ('primeira-parada',      'Primeira Parada',      'Concluiu a primeira missão num lugar do bairro.',              'ALUNO', 'MISSOES_CENARIO',   1,  50, 12, 'missoes1.png'),
  ('volta-no-quarteirao',  'Volta no Quarteirão',  'Cinco missões concluídas pelos lugares do bairro.',            'ALUNO', 'MISSOES_CENARIO',   5, 100, 13, 'missoes2.png'),
  ('conhece-cada-esquina', 'Conhece Cada Esquina', 'Vinte e cinco missões concluídas. O bairro inteiro sabe seu nome.', 'ALUNO', 'MISSOES_CENARIO', 25, 250, 14, 'missoes3.png'),
  ('mapa-na-cabeca',       'Mapa na Cabeça',       'Cinquenta missões concluídas pelos lugares do bairro.',        'ALUNO', 'MISSOES_CENARIO',  50, 500, 15, 'missoes4.png')
on conflict (codigo) do update set
  nome         = excluded.nome,
  descricao    = excluded.descricao,
  publico      = excluded.publico,
  regra        = excluded.regra,
  alvo         = excluded.alvo,
  xp           = excluded.xp,
  ordem        = excluded.ordem,
  imagem       = excluded.imagem,
  cenario_slug = null,
  grupo        = null;


-- ── Acertos em cada lugar do bairro ──────────────────────────────────
--
-- Uma peça por lugar, com três degraus que SE SOBREPÕEM: os três ficam
-- no mesmo `grupo` (cenario-<slug>), e a estante mostra só o mais alto
-- já conquistado. Cada degrau tem a própria arte — <arte>1, 2 e 3.
--
-- `arte` é o começo do nome do arquivo e nem sempre é igual ao slug:
-- quadra é "campo-lazer" e igreja é "centro-religioso", porque é assim
-- que o aluno chama esses lugares no mapa.
--
-- Os 16 lugares são os do mapa (src/js/mapa.js). Banca, igreja, rio e
-- ruas ainda não têm linha em cenarios nem perguntas, então as deles
-- ficam bloqueadas até isso mudar — e o slug que entrar em cenarios tem
-- de ser o mesmo daqui, senão a ligação se perde.
--
-- Escrito como tabela de lugares × tabela de degraus para que os 48
-- nomes fiquem lado a lado, fáceis de revisar e trocar.
--
-- OS MARCOS: 5, 25 e 50 acertos no lugar. O primeiro é baixo de
-- propósito, para cada lugar render uma peça logo na primeira visita;
-- o último cabe no conteúdo que os lugares com mais perguntas têm hoje.
--
-- O código é cenario-<slug>-<DEGRAU>, e não o alvo: recalibrar um marco
-- aqui atualiza a mesma linha. Um código com o alvo dentro viraria uma
-- linha nova a cada ajuste, e a antiga ficaria órfã na estante.
--
-- ordem: 101 em diante, 3 por lugar. Os lugares vêm depois de todas as
-- peças avulsas, e o espaço até 100 fica livre para as que vierem.

insert into insignias (codigo, nome, descricao, publico, regra, alvo, xp, ordem, imagem, cenario_slug, grupo)
select
  'cenario-' || l.slug || '-' || d.degrau,
  case d.degrau when 1 then l.nome_1 when 2 then l.nome_2 else l.nome_3 end,
  d.frase || ' ' || l.onde || '.',
  'ALUNO',
  'ACERTOS_CENARIO',
  d.alvo,
  d.xp,
  100 + (l.posicao - 1) * 3 + d.degrau,
  l.arte || d.degrau || '.png',
  l.slug,
  'cenario-' || l.slug
from (values
  --  slug             pos  arte                onde                      5 acertos               25 acertos            50 acertos
  ('ubs',               1, 'ubs',              'na UBS',                 'Porta de Entrada',     'Prontuário em Dia',  'Coração do SUS'),
  ('escola',            2, 'escola',           'na Escola',              'Lição Aprendida',      'Nota Dez',           'Quadro de Honra'),
  ('casa',              3, 'casa',             'nas visitas às casas',   'Porta Aberta',         'Visita em Dia',      'Gente de Casa'),
  ('mercado',           4, 'mercado',          'no Mercado',             'Lista de Compras',     'Rótulo Decifrado',   'Prato Colorido'),
  ('farmacia',          5, 'farmacia',         'na Farmácia',            'Receita Certa',        'Dose Exata',         'Carteirinha em Dia'),
  ('upa',               6, 'upa',              'na UPA',                 'Sinal de Alerta',      'Triagem Afiada',     'Sangue Frio'),
  ('creche',            7, 'creche',           'na Creche',              'Primeiros Cuidados',   'Caderneta em Dia',   'Colo Seguro'),
  ('praca',             8, 'praca',            'na Pracinha',            'Sombra e Água Fresca', 'Roda de Conversa',   'Alma da Praça'),
  ('quadra',            9, 'campo-lazer',      'no Campo de lazer',      'Aquecimento',          'Segundo Tempo',      'Camisa 10'),
  ('parque',           10, 'parque',           'no Parque',              'Trilha Limpa',         'Lixeira Certa',      'Pulmão Verde'),
  ('corrego',          11, 'corrego',          'no Córrego',             'Fio d''Água',          'Correnteza',         'Nascente Protegida'),
  ('terreno-baldio',   12, 'terreno-baldio',   'no Terreno baldio',      'Lixo no Lugar',        'Fim do Foco',        'Terreno Transformado'),
  ('rio',              13, 'rio',              'no Rio',                 'Margem Limpa',         'Mutirão',            'Rio Vivo'),
  ('ruas',             14, 'ruas',             'nas Ruas',               'Passo a Passo',        'Lixo por Cor',       'Rua Exemplar'),
  ('banca',            15, 'banca',            'na Banca de jornal',     'Leitura do Dia',       'Fato ou Fake',       'Primeira Página'),
  ('igreja',           16, 'centro-religioso', 'no Centro religioso',    'Escuta Atenta',        'Ombro Amigo',        'Porto Seguro')
) as l(slug, posicao, arte, onde, nome_1, nome_2, nome_3)
cross join (values
  --  degrau  alvo  xp   frase
  (1,           5,  30, 'Acertou as 5 primeiras perguntas'),
  (2,          25, 100, 'Vinte e cinco perguntas certas'),
  (3,          50, 200, 'Cinquenta perguntas certas')
) as d(degrau, alvo, xp, frase)
on conflict (codigo) do update set
  nome         = excluded.nome,
  descricao    = excluded.descricao,
  publico      = excluded.publico,
  regra        = excluded.regra,
  alvo         = excluded.alvo,
  xp           = excluded.xp,
  ordem        = excluded.ordem,
  imagem       = excluded.imagem,
  cenario_slug = excluded.cenario_slug,
  grupo        = excluded.grupo;


-- ── Conferir ─────────────────────────────────────────────────────────
-- Deve devolver 63 linhas, todas com imagem preenchida.

-- select codigo, nome, regra, alvo, xp, ordem, imagem, cenario_slug, grupo
--   from insignias order by publico, ordem;
