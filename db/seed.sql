-- =====================================================================
--  DADOS INICIAIS — Heróis da Saúde
--
--  Aqui entra apenas o que faz parte da ESTRUTURA DO JOGO, ou seja,
--  informação que existe porque o jogo é assim, e não porque alguém
--  cadastrou.
--
--  O QUE NÃO ENTRA AQUI, E POR QUÊ:
--
--    escolas  -> quem cria é o PROFESSOR, no cadastro dele
--    turmas   -> quem cria é o PROFESSOR, no painel dele
--    usuarios -> quem cria é a própria pessoa, na tela de cadastro
--
--  Escrever escolas à mão neste arquivo faria elas parecerem dados
--  reais quando na verdade seriam invenção. Pior: apareceriam na lista
--  de todos os alunos, misturadas com as escolas de verdade.
--
--  Dialeto: PostgreSQL (Supabase).
--  Onde rodar: painel do Supabase -> SQL Editor
--  Pode ser executado mais de uma vez sem quebrar nada.
-- =====================================================================


-- ── Cenários: os pontos do bairro no mapa ────────────────────────────
--
-- Estes SIM pertencem ao jogo. O bairro é o mesmo para todas as escolas
-- e todos os alunos. As missões vão ser penduradas neles depois.
--
-- O "slug" é o apelido curto usado pelo código para reconhecer o lugar
-- (o programa procura por 'ubs', não por 'UBS do Bairro'). Ele nunca
-- aparece na tela, e por isso não tem acento nem espaço.
--
-- "on conflict (slug) do nothing" quer dizer: se já existir um cenário
-- com esse apelido, pule em vez de dar erro. É o que deixa este arquivo
-- seguro de rodar duas vezes.

insert into cenarios (slug, nome, descricao) values
  ('ubs',            'UBS do Bairro',  'A Unidade Básica de Saúde, porta de entrada do SUS.'),
  ('escola',         'Escola',         'Onde a turma aprende e cuida da saúde junto.'),
  ('mercado',        'Mercado',        'Escolhas de alimentação e leitura de rótulos.'),
  ('farmacia',       'Farmácia',       'Uso correto de medicamentos e vacinação.'),
  ('praca',          'Praça',          'Atividade física, lazer e saúde mental.'),
  ('corrego',        'Córrego',        'Saneamento, água e doenças transmitidas.'),
  ('terreno-baldio', 'Terreno Baldio', 'Focos do Aedes aegypti e destino do lixo.')
on conflict (slug) do nothing;


-- ── Conferir ─────────────────────────────────────────────────────────
-- Deve devolver 7 linhas.

-- select slug, nome from cenarios order by slug;


-- =====================================================================
--  E AS MISSÕES E QUESTÕES?
--
--  Não entram aqui e não devem ser inventadas. O conteúdo pedagógico
--  (perguntas, respostas e explicações) é escrito pela equipe de
--  Medicina. Inventar conteúdo clínico num jogo educativo de saúde
--  seria errado, mesmo que só para teste.
-- =====================================================================
