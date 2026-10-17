-- Dados iniciais: só a estrutura do jogo (os cenários). Escolas, turmas e usuários nascem pelas telas.
-- Pode rodar mais de uma vez.


-- Cenários do mapa. O slug é o identificador usado pelo código.

insert into cenarios (slug, nome, descricao) values
  ('ubs',            'UBS do Bairro',  'A Unidade Básica de Saúde, porta de entrada do SUS.'),
  ('escola',         'Escola',         'Onde a turma aprende e cuida da saúde junto.'),
  ('mercado',        'Mercado',        'Escolhas de alimentação e leitura de rótulos.'),
  ('farmacia',       'Farmácia',       'Uso correto de medicamentos e vacinação.'),
  ('praca',          'Praça',          'Atividade física, lazer e saúde mental.'),
  ('corrego',        'Córrego',        'Saneamento, água e doenças transmitidas.'),
  ('terreno-baldio', 'Terreno Baldio', 'Focos do Aedes aegypti e destino do lixo.')
on conflict (slug) do nothing;


-- Os 5 cenários que eram só decorativos no mapa (mesmo nome e descrição de mapa.js).

insert into cenarios (slug, nome, descricao) values
  ('casa',   'Casa',           'Visitas do ACS a moradores diferentes, cada um com uma história e um problema de saúde distinto a ser identificado e resolvido.'),
  ('upa',    'UPA',            'Casos urgentes que exigem atendimento rápido, ensinando o jogador a identificar prioridades em situações de emergência.'),
  ('creche', 'Creche',         'Missões voltadas ao cuidado infantil, desenvolvimento na primeira infância e prevenção de doenças comuns nessa fase.'),
  ('quadra', 'Campo de lazer', 'Atividades físicas coletivas em quadras, incentivando exercício e convivência comunitária.'),
  ('parque', 'Parque',         'Áreas arborizadas para caminhadas, com missões de limpeza e reforço da separação correta do lixo.')
on conflict (slug) do nothing;


-- Conferir: devem vir 7 linhas.

-- select slug, nome from cenarios order by slug;


-- Questões não entram aqui: o conteúdo é escrito pela equipe de Medicina.
