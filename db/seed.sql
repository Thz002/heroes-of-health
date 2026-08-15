-- =====================================================================
--  DADOS INICIAIS — Heróis da Saúde
--
--  Só o mínimo para o cadastro funcionar: sem nenhuma escola no banco,
--  a lista do formulário aparece vazia e ninguém consegue se cadastrar.
--
--  Dialeto: PostgreSQL (Supabase).
--  Onde rodar: painel do Supabase -> SQL Editor
--
--  ⚠️ São dados de EXEMPLO, para desenvolvimento e testes. Antes da
--  entrega, troque pelas escolas e turmas reais do projeto.
--
--  Não há missões nem questões aqui: o conteúdo pedagógico é escrito
--  pela equipe de Medicina e não deve ser inventado.
-- =====================================================================


-- ── Escolas ──────────────────────────────────────────────────────────
-- "on conflict do nothing" quer dizer: se já existir uma escola com esse
-- nome, não dê erro, apenas pule. Isso deixa o arquivo seguro de rodar
-- mais de uma vez.

insert into escolas (nome) values
  ('Colégio Santa Maria'),
  ('E. E. Professor Aníbal Machado'),
  ('PUC Minas — Coração Eucarístico')
on conflict (nome) do nothing;


-- ── Turmas ───────────────────────────────────────────────────────────
--
-- O "select id from escolas where nome = ..." busca o número da escola
-- na hora, em vez de a gente chutar que o Colégio Santa Maria é o 1.
-- Se alguém apagar e recriar as escolas, os números mudam — isto continua
-- funcionando.
--
-- O "codigo" é o que o professor entrega para a sala. O aluno digita ele
-- no cadastro e cai direto na turma certa.

insert into turmas (nome, escola_id, codigo) values
  ('6º Ano A', (select id from escolas where nome = 'Colégio Santa Maria'),            '6A-P2LT'),
  ('7º Ano B', (select id from escolas where nome = 'Colégio Santa Maria'),            '7B-K3M9'),
  ('9º Ano A', (select id from escolas where nome = 'Colégio Santa Maria'),            '9A-T8VC'),
  ('8º Ano C', (select id from escolas where nome = 'E. E. Professor Aníbal Machado'), '8C-W7QX'),
  ('6º Ano B', (select id from escolas where nome = 'E. E. Professor Aníbal Machado'), '6B-H5NR'),
  ('1º Ano — Ensino Médio', (select id from escolas where nome = 'PUC Minas — Coração Eucarístico'), '1EM-Z4RB'),
  ('2º Ano — Ensino Médio', (select id from escolas where nome = 'PUC Minas — Coração Eucarístico'), '2EM-J6WY')
on conflict (codigo) do nothing;


-- ── Cenários do mapa ─────────────────────────────────────────────────
-- Os pontos do bairro que o aluno pode visitar. São a estrutura do jogo,
-- não conteúdo clínico, por isso podem entrar aqui.

insert into cenarios (slug, nome, descricao) values
  ('ubs',            'UBS do Bairro',   'A Unidade Básica de Saúde, porta de entrada do SUS.'),
  ('escola',         'Escola',          'Onde a turma aprende e cuida da saúde junto.'),
  ('mercado',        'Mercado',         'Escolhas de alimentação e leitura de rótulos.'),
  ('farmacia',       'Farmácia',        'Uso correto de medicamentos e vacinação.'),
  ('praca',          'Praça',           'Atividade física, lazer e saúde mental.'),
  ('corrego',        'Córrego',         'Saneamento, água e doenças transmitidas.'),
  ('terreno-baldio', 'Terreno Baldio',  'Focos do Aedes aegypti e destino do lixo.')
on conflict (slug) do nothing;


-- ── Conferir ─────────────────────────────────────────────────────────

-- select e.nome as escola, t.nome as turma, t.codigo
-- from turmas t
-- join escolas e on e.id = t.escola_id
-- order by e.nome, t.nome;
