-- Catálogo de insígnias (64). Rode depois do setup.sql; pode rodar de novo.
-- Editar aqui e rodar atualiza; conquistas já ganhas não são recalculadas.


-- ── Guarda: o setup.sql novo tem de ter rodado antes ─────────────────

do $$
begin
  if (select count(*) from information_schema.columns
       where table_schema = 'public' and table_name = 'insignias'
         and column_name in ('cenario_slug', 'grupo')) < 2 then
    raise exception 'A tabela insignias ainda não tem as colunas cenario_slug e grupo. Rode db/setup.sql antes deste arquivo.';
  end if;
end $$;


-- Peças avulsas: acertos, dias seguidos e missões concluídas por lugar.

insert into insignias (codigo, nome, descricao, publico, regra, alvo, xp, ordem, imagem) values
  ('primeiros-passos',     'Primeiros Passos',     'Acertou as 10 primeiras perguntas do bairro.',                 'ALUNO', 'ACERTOS',          10,  50,  1, 'perguntas1.png'),
  ('pe-na-estrada',        'Pé na Estrada',        'Vinte e cinco perguntas certas. O bairro já conhece você.',    'ALUNO', 'ACERTOS',          25, 100,  2, 'perguntas2.png'),
  ('meio-caminho',         'Meio Caminho',         'Cinquenta perguntas certas.',                                  'ALUNO', 'ACERTOS',          50, 200,  3, 'perguntas3.png'),
  ('centuriao',            'Centurião',            'Cem perguntas certas. Pouca gente chega aqui.',                'ALUNO', 'ACERTOS',         100, 400,  4, 'perguntas4.png'),
  ('enciclopedia',         'Enciclopédia',         'Duzentas perguntas certas.',                                   'ALUNO', 'ACERTOS',         200, 800,  5, 'perguntas5.png'),

  ('de-volta',             'De Volta',             'Jogou três dias seguidos.',                                    'ALUNO', 'DIAS',              3,  50,  6, 'diaria1.png'),
  ('semana-cheia',         'Semana Cheia',         'Sete dias seguidos cuidando do bairro.',                       'ALUNO', 'DIAS',              7, 150,  7, 'diaria2.png'),
  ('presenca-de-ouro',     'Presença de Ouro',     'Trinta dias seguidos.',                                        'ALUNO', 'DIAS',             30, 600,  8, 'diaria3.png'),

  -- ordem 9 a 11 vaga (insígnias de professor excluídas).
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


-- Segredos do mapa (regra DESCOBERTA), dados por POST /api/descobrir. Códigos usados em mapa.js.

insert into insignias (codigo, nome, descricao, publico, regra, alvo, xp, ordem, imagem) values
  ('segredo-tv',         'Sintonizado',          'Achou o canal de vídeos de saúde da Fiocruz escondido no bairro.', 'ALUNO', 'DESCOBERTA', 1, 30, 16, 'tvs.png'),
  ('segredo-hqs',        'Balão de Fala',        'Descobriu as histórias em quadrinhos sobre saúde do bairro.',      'ALUNO', 'DESCOBERTA', 1, 30, 17, 'hqs.png'),
  ('segredo-hqs-todas',  'Até a Última Página',  'Leu todas as histórias em quadrinhos sobre saúde.',                'ALUNO', 'DESCOBERTA', 1, 60, 18, 'all-hqs.png'),
  ('segredo-calendario', 'Toda Cor Tem Causa',   'Descobriu o Calendário das Cores da Saúde: cada mês, uma causa.', 'ALUNO', 'DESCOBERTA', 1, 30, 19, 'calendar.png')
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


-- Acertos por lugar: 3 degraus (5, 25, 50) no mesmo grupo. ordem a partir de 101.

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


-- Insígnias excluídas (o delete leva junto quem as tinha e o XP). Rode npm run backup antes.

delete from insignias where codigo in ('primeira-missao', 'mao-na-massa', 'missao-cumprida');


-- Conferir: devem vir 64 linhas, todas com imagem.

-- select codigo, nome, regra, alvo, xp, ordem, imagem, cenario_slug, grupo
--   from insignias order by publico, ordem;
