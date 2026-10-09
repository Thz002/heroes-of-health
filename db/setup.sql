-- =====================================================================
--  HERÓIS DA SAÚDE — o banco inteiro, em um arquivo
--
--  Este arquivo substitui as migrações 01, 02, 03, 04 e o schema.sql,
--  que foram para db/_historico/. Ele descreve o banco COMO ELE DEVE
--  SER, e sabe se virar tanto num projeto novo e vazio quanto num que
--  já tem tabelas e gente cadastrada.
--
--  POR QUE UM ARQUIVO SÓ, E NÃO UMA PILHA DE MIGRAÇÕES:
--  histórico de migração serve para proteger dado de produção que não
--  pode ser perdido. Este projeto não tem isso — tem uma equipe de
--  faculdade mexendo num banco de teste. Aqui o histórico só atrapalha:
--  são mais arquivos para ler, mais ordem para lembrar, e mais chance de
--  rodar na sequência errada. Quando alguma coisa mudar, MUDE ESTE
--  ARQUIVO e rode de novo.
--
--  É seguro rodar quantas vezes quiser: tudo usa
--  "if not exists" / "drop ... if exists" / "create or replace".
--  NÃO apaga nenhum dado.
--
--  Onde rodar: painel do Supabase -> SQL Editor -> colar tudo -> Run
--  Depois deste, rode o seed.sql (os 7 cenários do mapa).
--
--  Dialeto: PostgreSQL. Não é MySQL, apesar do que diz o README.
--
--  Banco criado ANTES de as questões deixarem de ter "missão"? Rode
--  primeiro db/migracao-questoes-sem-missoes.sql — a trava logo abaixo
--  recusa seguir enquanto a tabela missoes existir.
--
--  Banco que já tinha questões antes da coluna questoes.criado_por
--  existir? Rode primeiro db/migracao-questoes-criado-por.sql.
-- =====================================================================

do $$
begin
  if to_regclass('public.missoes') is not null then
    raise exception
      'Este banco ainda tem a tabela missoes. Rode db/migracao-questoes-sem-missoes.sql antes deste arquivo.';
  end if;
end $$;


-- #####################################################################
--  1. TABELAS
-- #####################################################################

-- ── Institucional ────────────────────────────────────────────────────

create table if not exists escolas (
  id bigint primary key generated always as identity,
  nome varchar(150) not null,
  created_at timestamptz not null default now()
);

-- O unique fica fora do create table porque a tabela pode já existir sem
-- ele. Sem essa regra o banco enche de duplicata ('Santa Maria',
-- 'Colegio Santa Maria'...) e a lista do cadastro fica impossível de usar.
do $$
declare repetidos int;
begin
  if exists (
    select 1 from pg_constraint
    where conrelid = 'public.escolas'::regclass
      and contype in ('u','p')
      and pg_get_constraintdef(oid) ilike '%(nome)%'
  ) then
    return;
  end if;

  select count(*) into repetidos
  from (select nome from escolas group by nome having count(*) > 1) d;

  if repetidos > 0 then
    raise warning
      'escolas.nome NAO ficou unico: % nome(s) repetido(s). Veja: select nome, count(*) from escolas group by nome having count(*)>1;',
      repetidos;
  else
    alter table escolas add constraint escolas_nome_unico unique (nome);
  end if;
end $$;


create table if not exists turmas (
  id bigint primary key generated always as identity,
  nome varchar(50) not null,                   -- ex: '7º Ano B'
  escola_id bigint not null references escolas(id) on delete cascade,

  -- O código curto que o professor entrega para a sala (ex: '7B-K3M9').
  -- O aluno digita só isso e entra direto na turma certa.
  codigo varchar(12),

  -- Quem criou a turma. A FK é criada mais abaixo, porque usuarios
  -- ainda não existe neste ponto do arquivo.
  professor_id uuid,

  created_at timestamptz not null default now()
);

create unique index if not exists turmas_codigo_unico   on turmas (codigo);
create unique index if not exists turmas_nome_por_escola on turmas (escola_id, nome);

-- Cor e ano escolar são só de exibição no painel do professor (dashboard).
-- A cor tem check com a mesma lista de 6 opções do seletor na tela, como
-- segunda trava além da validação do servidor. O ano fica livre (sem
-- check) porque as opções do <select> podem crescer sem precisar migração.
alter table turmas add column if not exists cor varchar(9)
  not null default '#14b8a6'
  check (cor in ('#14b8a6','#3b82f6','#f9c74f','#f472b6','#a78bfa','#fb923c'));

alter table turmas add column if not exists ano_escolar varchar(10);


-- ── Pessoas ──────────────────────────────────────────────────────────

create table if not exists usuarios (
  -- O identificador NÃO é inventado por esta tabela: é o mesmo que o
  -- Supabase cria no login. "references auth.users(id)" amarra os dois,
  -- e é isso que faz auth.uid() (e portanto o RLS inteiro) funcionar.
  id uuid primary key references auth.users(id) on delete cascade,

  nome varchar(100) not null,

  -- Não existe coluna "senha" nem "email" aqui, de propósito: as duas
  -- vivem do lado do Supabase, junto com o login. Guardar senha em dois
  -- lugares é justamente o erro que este desenho evita.

  tipo text not null default 'ALUNO'
       check (tipo in ('ALUNO', 'PROFESSOR', 'ADMIN')),

  idade int check (idade between 7 and 18),

  -- ALUNO deixa em branco: a escola dele se descobre pela turma.
  -- PROFESSOR preenche com a escola onde trabalha.
  escola_id bigint references escolas(id) on delete set null,

  -- Só o ALUNO preenche.
  turma_id bigint references turmas(id) on delete set null,

  created_at timestamptz not null default now()
);

alter table turmas drop constraint if exists turmas_professor_fk;
alter table turmas
  add constraint turmas_professor_fk
  foreign key (professor_id) references usuarios(id) on delete set null;


-- ── Conteúdo do jogo ─────────────────────────────────────────────────

create table if not exists cenarios (
  id bigint primary key generated always as identity,
  slug varchar(50) not null unique,   -- 'ubs', 'mercado', 'farmacia'...
  nome varchar(100) not null,
  descricao text not null
);

-- Cada questão diz sozinha onde acontece e para que idade é. Antes isso
-- vinha de uma tabela "missoes" intermediária (cenário × faixa etária);
-- hoje "missão" é o nome que o aluno vê para o quiz do professor, e a
-- tabela antiga foi desfeita por db/migracao-questoes-sem-missoes.sql.
create table if not exists questoes (
  id bigint primary key generated always as identity,
  cenario_id bigint not null references cenarios(id) on delete cascade,

  -- Faixa etária, comparada com usuarios.idade (aluno) e com o ano
  -- escolar da turma (quiz do professor):
  --   1 = 7 a 10 anos, 2 = 11 a 14, 3 = 15 a 18
  nivel_etario int not null check (nivel_etario between 1 and 3),

  enunciado text not null,
  opcao_a varchar(255) not null,
  opcao_b varchar(255) not null,
  -- C e D aceitam nulo: a equipe de Medicina também escreve questões de
  -- Verdadeiro/Falso, que têm só duas alternativas. A tela já pula opção
  -- vazia, então isso não exigiu nada do lado de lá.
  opcao_c varchar(255),
  opcao_d varchar(255),
  -- A E só existe no nível 3, que segue o formato do ENEM (cinco
  -- alternativas). Nas outras fica nula, e a tela pula, como a C e a D.
  opcao_e varchar(255),
  resposta_correta char(1) not null check (resposta_correta in ('A','B','C','D','E')),

  -- Texto educativo mostrado depois da resposta, escrito pela equipe de
  -- Medicina. Aparece também quando o aluno erra, em tom de incentivo.
  explicacao text not null
);

-- O filtro mais quente do conteúdo: o professor criando um quiz sorteia
-- entre as questões dos cenários escolhidos, na faixa etária da turma.
create index if not exists questoes_por_cenario_e_nivel on questoes (cenario_id, nivel_etario);

-- Identidade estavel do conteudo importado (db/importar-questoes.sql).
--
-- Sem isto o import nao tem como saber se uma linha ja existe: rodar o
-- arquivo duas vezes duplicaria o banco inteiro em silencio. E a saida
-- obvia -- apagar tudo e recriar -- e pior, porque respostas_alunos
-- referencia questoes com "on delete cascade": apagar a questao levaria
-- junto o historico de respostas dos alunos.
--
-- Com o codigo_externo, o import vira "on conflict do update": corrige o
-- texto de uma pergunta sem perder nenhuma resposta ja dada.
alter table questoes add column if not exists codigo_externo varchar(60);

-- O "create table" acima só vale para banco novo; num que já existe ele
-- não muda nada. Estas duas linhas é que soltam a trava nos bancos que
-- já foram criados antes das questões de Verdadeiro/Falso existirem.
alter table questoes alter column opcao_c drop not null;
alter table questoes alter column opcao_d drop not null;

-- A mesma coisa para a letra E, que chegou com o nível 3: num banco que
-- já existe, o "create table" não acrescenta a coluna nem afrouxa o
-- check. O check antigo (só A a D) é achado pelo que ele diz, e não pelo
-- nome — o mesmo jeito do unique de escolas, lá em cima.
alter table questoes add column if not exists opcao_e varchar(255);

do $$
declare antigo record;
begin
  for antigo in
    select conname from pg_constraint
    where conrelid = 'public.questoes'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%resposta_correta%'
      and pg_get_constraintdef(oid) not ilike '%''E''%'
  loop
    execute format('alter table questoes drop constraint %I', antigo.conname);
  end loop;

  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.questoes'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%resposta_correta%'
  ) then
    alter table questoes add constraint questoes_resposta_correta_check
      check (resposta_correta in ('A','B','C','D','E'));
  end if;
end $$;

create unique index if not exists questoes_codigo_externo on questoes (codigo_externo);

-- Quem escreveu a questão.
--
--   '00000000-0000-0000-0000-000000000000'  -> questão DO SISTEMA (equipe de
--                                              Medicina, via importar-questoes.sql)
--   o id de um professor (usuarios.id)      -> questão criada por ele no painel
--
-- O default é o código do sistema, então o import da Medicina não precisa
-- mencionar a coluna: toda questão que entra por ele já nasce "do sistema".
-- Quem grava o id do professor é o servidor (POST /api/professor/questoes),
-- a partir do login — nunca de um campo vindo do navegador.
--
-- Cada professor enxerga as do sistema e as DELE, nunca as de outro
-- professor: quem garante é a policy de questoes (seção 4) e, no servidor,
-- o filtro de server/rotas/professor.js.
--
-- Não há FK para usuarios DE PROPÓSITO: o código do sistema não é um
-- usuário, e a FK recusaria todas as questões da Medicina. Se a conta de um
-- professor for apagada, as questões dele ficam no banco sem ninguém que as
-- veja — e as respostas que os alunos já deram a elas continuam valendo XP.
--
-- Banco que já tinha questões antes desta coluna existir: rode
-- db/migracao-questoes-criado-por.sql (ele preenche e confere). O alter
-- abaixo também preencheria sozinho, mas a migração mostra o que mudou.
alter table questoes add column if not exists criado_por uuid
  not null default '00000000-0000-0000-0000-000000000000';

create index if not exists questoes_por_criador on questoes (criado_por, cenario_id, nivel_etario);


-- ── As 8 barras e o que as alimenta ──────────────────────────────────

create table if not exists areas (
  nome varchar(50) primary key,
  ordem int not null
);

-- Quantos pontos enchem ESTA barra. Não é a mesma para as oito, e é aí
-- que está a diferença: o conteúdo é muito desigual (Saúde tem 140
-- questões, Vetores tem 5). Com uma meta única, ou as barras ricas
-- enchiam com um terço do material, ou as pobres nunca saíam do lugar —
-- nenhum número resolvia as duas coisas ao mesmo tempo.
--
-- Aqui a meta É o conteúdo que existe: encher a barra passa a significar
-- "você cuidou de tudo o que há sobre isso". Quem preenche é a função
-- recalcular_metas(), chamada no fim de cada import.
alter table areas add column if not exists meta int not null default 0;

insert into areas (nome, ordem) values
  ('Saúde', 1), ('Educação', 2), ('Vacinação', 3), ('Vetores', 4),
  ('Limpeza', 5), ('Alimentação', 6), ('Exercícios', 7), ('Felicidade', 8)
on conflict (nome) do nothing;

-- Quanto cada questão vale em cada barra, no primeiro acerto. Sem uma
-- linha aqui, acertar a questão não pontua nada — sem erro nenhum, só
-- silêncio. Uma questão pode encher várias barras (Saúde e Limpeza, por
-- exemplo), cada uma com o seu peso.
create table if not exists questoes_areas (
  questao_id bigint not null references questoes(id) on delete cascade,
  area_nome varchar(50) not null references areas(nome) on delete cascade,
  pontos int not null default 10 check (pontos > 0),
  primary key (questao_id, area_nome)
);

-- O professor filtra o quiz por área ("só Vacinação").
create index if not exists questoes_areas_por_area on questoes_areas (area_nome);


-- ── Progresso do aluno ───────────────────────────────────────────────

create table if not exists progresso_areas (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  area_nome varchar(50) not null,
  porcentagem real default 0,
  pontos int default 0,
  unique (usuario_id, area_nome)
);

-- Fecha area_nome na lista das 8. O DO block existe para este arquivo
-- não morrer no meio caso já haja progresso com um nome fora da lista.
alter table progresso_areas drop constraint if exists progresso_areas_area_fk;
do $$
declare fora int;
begin
  select count(*) into fora
  from progresso_areas p
  where not exists (select 1 from areas a where a.nome = p.area_nome);

  if fora > 0 then
    raise warning
      'FK de progresso_areas NAO aplicada: % linha(s) com area_nome fora das 8 barras. Veja: select distinct area_nome from progresso_areas;',
      fora;
  else
    alter table progresso_areas
      add constraint progresso_areas_area_fk
      foreign key (area_nome) references areas(nome) on delete cascade;
  end if;
end $$;

create table if not exists respostas_alunos (
  id bigint primary key generated always as identity,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  acertou boolean not null,
  data_resposta timestamptz not null default now()
);

-- Esta é a tabela que mais cresce: uma linha por tentativa, de cada
-- aluno, para sempre. O par (usuario, questao) é consultado a cada
-- resposta enviada, para decidir se é o primeiro acerto e vale ponto.
create index if not exists respostas_por_aluno_e_questao
  on respostas_alunos (usuario_id, questao_id);


create table if not exists pacientes_virtuais (
  id bigint primary key generated always as identity,
  usuario_id uuid unique not null references usuarios(id) on delete cascade,
  nome_paciente varchar(100) not null,
  idade_paciente int not null,
  estado_saude varchar(100) default 'Estável'
);

create table if not exists quizzes_professores (
  id bigint primary key generated always as identity,
  turma_id bigint not null references turmas(id) on delete cascade,
  professor_id uuid not null references usuarios(id) on delete cascade,
  titulo varchar(150) not null,
  tempo_limite_segundos int default 15,
  created_at timestamptz not null default now()
);

-- Como o quiz foi montado. Isto é REGISTRO, não regra: as questões já
-- foram sorteadas e congeladas em quiz_questoes na hora da criação. Ficam
-- aqui para o professor lembrar o que pediu e conseguir repetir depois.
--
-- descricao é a frase que o aluno lê no card da missão, escrita pelo
-- professor. Sem ela o card mostraria só o título, e "Doenças" sozinho
-- não diz o que a pessoa vai encontrar ali dentro.
--
-- nivel_etario NÃO é escolhido pelo professor: sai do ano escolar da
-- turma (uma turma de 9º ano puxa questões de 11 a 14). Fica gravado
-- porque o ano da turma pode mudar depois, e aí o quiz antigo mentiria
-- sobre o próprio conteúdo.
--
-- As cinco ficam JUNTAS de propósito. O SQL Editor do Supabase roda só o
-- texto selecionado, e enquanto "descricao" estava separada das outras
-- por uma linha em branco ela foi deixada de fora da seleção — o banco
-- ficou com quatro das cinco, e criar quiz passou a falhar.
alter table quizzes_professores add column if not exists descricao varchar(200);
alter table quizzes_professores add column if not exists nivel_etario int
  check (nivel_etario between 1 and 3);
alter table quizzes_professores add column if not exists cenarios text[];
alter table quizzes_professores add column if not exists areas text[];
alter table quizzes_professores add column if not exists qtd_pedida int;

-- O PostgREST guarda em cache o desenho das tabelas. Sem este aviso a
-- coluna existe no banco e a API continua dizendo que não.
notify pgrst, 'reload schema';


-- As questões que caíram naquele quiz, congeladas na criação.
--
-- É esta tabela que faz a turma inteira responder as MESMAS perguntas —
-- sem ela, cada aluno sortearia as suas e o ranking não compararia nada.
-- A chave primária composta é também o que garante "não repete dentro do
-- mesmo quiz": o banco recusaria a segunda linha igual.
create table if not exists quiz_questoes (
  quiz_id bigint not null references quizzes_professores(id) on delete cascade,
  questao_id bigint not null references questoes(id) on delete cascade,
  ordem int not null,
  primary key (quiz_id, questao_id)
);

create index if not exists quiz_questoes_por_quiz on quiz_questoes (quiz_id, ordem);

-- De qual quiz veio esta resposta. Nulo = exploração livre pelo mapa.
--
-- Sem esta coluna é impossível saber se um aluno terminou um quiz, dar
-- nota, ou separar no relatório o que foi tarefa do que foi brincadeira
-- — a tabela é plana e não sabe dizer a que contexto cada acerto pertence.
alter table respostas_alunos add column if not exists quiz_id bigint
  references quizzes_professores(id) on delete set null;

create index if not exists respostas_por_quiz on respostas_alunos (quiz_id);


-- ── A foto de perfil ─────────────────────────────────────────────────
--
-- `text` e não `varchar(n)` porque a foto pode chegar de dois jeitos: um
-- endereço https:// curto, ou a imagem inteira embutida (data:image/...)
-- quando a pessoa escolhe um arquivo do próprio computador. O segundo
-- caso tem alguns milhares de caracteres.
--
-- Fica colado no bloco de progressão abaixo DE PROPÓSITO, sem linha em
-- branco no meio: o SQL Editor do Supabase roda só o texto selecionado,
-- e um alter sozinho entre comentários é exatamente o que ficou de fora
-- quando a coluna `descricao` sumiu três vezes.
alter table usuarios add column if not exists avatar_url text;
-- ── O XP que não vem de acertar pergunta ─────────────────────────────
--
-- Acerto de questão NÃO entra aqui: ele já está em respostas_alunos, e
-- o XP sai de lá por conta (10 por questão distinta). Duplicar daria
-- duas versões do mesmo número, e um dia elas discordariam.
--
-- O prêmio diário é o contrário: não deixa rastro em lugar nenhum. Se
-- não for gravado, não existe. Por isso esta tabela.
--
-- A CHAVE É A REGRA: unique (usuario_id, dia) é o que garante "uma vez
-- por dia" — não um if no servidor. Dois cliques no mesmo segundo, duas
-- abas abertas, a pessoa recarregando a página: o banco recusa o
-- segundo, sempre, sem depender de o código lembrar de conferir.
--
-- `dia` é date e não timestamp de propósito: o prêmio é por DIA do
-- calendário de quem joga, não por 24 horas corridas.
create table if not exists xp_diario (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  dia date not null,
  pontos int not null default 50 check (pontos > 0),
  created_at timestamptz not null default now(),
  primary key (usuario_id, dia)
);


-- ── As insígnias ─────────────────────────────────────────────────────
--
-- A ESTANTE É DIRIGIDA POR DADO, não por código. Cada insígnia é uma
-- LINHA: para criar uma nova, ninguém abre o servidor — insere aqui.
-- É o que permite o outro desenvolvedor desenhar as artes e ligá-las
-- sem tocar em JavaScript nenhum.
--
-- POR QUE NÃO HÁ REGRA DE PORCENTAGEM: a quantidade de quizzes muda o
-- tempo todo, porque o professor cria e apaga. "Acertou 80% do que foi
-- passado" mudaria de significado toda semana, e uma insígnia já
-- conquistada poderia deixar de valer. Toda regra aqui é de CONTAGEM
-- ABSOLUTA — 50 acertos são 50 acertos para sempre.
--
--   ACERTOS       questões distintas que a pessoa acertou
--   DIAS          dias de sequência (o prêmio diário)
--   MISSOES       quizzes concluídos
--   QUIZZES       quizzes criados          (professor)
--   ACERTOS_TURMA acertos dos alunos dele  (professor)
create table if not exists insignias (
  codigo varchar(40) primary key,
  nome varchar(60) not null,
  descricao varchar(160) not null,

  publico varchar(10) not null check (publico in ('ALUNO', 'PROFESSOR')),

  regra varchar(20) not null
        check (regra in ('ACERTOS', 'DIAS', 'MISSOES', 'QUIZZES', 'ACERTOS_TURMA')),
  alvo int not null check (alvo > 0),

  xp int not null default 0 check (xp >= 0),
  ordem int not null,

  -- O nome do arquivo da arte, dentro de src/img/insignias/.
  -- Nulo = ainda sem arte: a estante desenha o lugar vazio dela.
  imagem varchar(120)
);


-- ── O que cada pessoa já conquistou ──────────────────────────────────
--
-- CONQUISTA NÃO SE PERDE. Esta tabela é o único lugar do jogo onde o
-- dado é gravado justamente para NÃO ser recalculado: se amanhã a
-- equipe de Medicina apagar 30 questões, quem já tinha a insígnia de
-- 100 acertos continua com ela. Recalcular tiraria da pessoa algo que
-- ela fez, por causa de uma mudança que não foi dela.
create table if not exists insignias_usuarios (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  insignia_codigo varchar(40) not null references insignias(codigo) on delete cascade,
  conquistada_em timestamptz not null default now(),
  primary key (usuario_id, insignia_codigo)
);

create index if not exists insignias_por_usuario
  on insignias_usuarios (usuario_id, conquistada_em desc);


-- ── Quando um aluno termina um quiz ──────────────────────────────────
--
-- O momento em que o professor e o aluno ganham junto. Uma linha por
-- (aluno, quiz), gravada na resposta que fecha o questionário.
--
-- POR QUE GRAVAR, SE DAVA PARA CALCULAR: dava — bastava contar as
-- respostas. Mas o quiz pode ser APAGADO pelo professor, e
-- respostas_alunos.quiz_id vira nulo quando isso acontece. O XP de
-- ambos sumiria junto com o quiz, e o professor perderia nível por ter
-- feito uma faxina no painel. Conquista não se desfaz.
--
-- Por isso `professor_id` também é gravado aqui, e não lido de
-- quizzes_professores na hora de somar: o quiz pode não existir mais.
--
-- `taxa` é acertos ÷ respostas dadas dentro daquele quiz. Como concluir
-- exige acertar todas, ela mede QUANTAS TENTATIVAS foram precisas —
-- 1.00 é quem acertou tudo de primeira. É o número que diz se a pessoa
-- sabia ou se martelou até passar.
create table if not exists quiz_concluidos (
  usuario_id uuid not null references usuarios(id) on delete cascade,
  quiz_id bigint not null,
  professor_id uuid references usuarios(id) on delete set null,

  perguntas int not null check (perguntas > 0),
  respostas int not null check (respostas > 0),
  taxa real not null check (taxa >= 0 and taxa <= 1),

  xp_aluno int not null default 0 check (xp_aluno >= 0),
  xp_professor int not null default 0 check (xp_professor >= 0),

  concluido_em timestamptz not null default now(),
  primary key (usuario_id, quiz_id)
);

-- Para o professor somar o que as turmas dele renderam sem varrer a
-- tabela inteira.
create index if not exists conclusoes_por_professor
  on quiz_concluidos (professor_id, concluido_em desc);


-- ── A estante de hoje ────────────────────────────────────────────────
--
-- `do update` e não `do nothing`: ajustar o alvo de uma insígnia é algo
-- que vai acontecer (os números abaixo são um primeiro chute e vão ser
-- calibrados quando houver turma jogando de verdade). Quem já conquistou
-- não perde — a conquista mora na outra tabela e não é recalculada.
--
-- `imagem` fica de fora do update DE PROPÓSITO: quando o outro
-- desenvolvedor preencher o nome do arquivo da arte, rodar este setup
-- de novo não pode apagar o trabalho dele.
--
-- OS NÚMEROS: 225 questões existem hoje, então "Enciclopédia" (200) é
-- quase tudo o que há. As duas do meio — 50 e 100 — são as que foram
-- combinadas; o resto é a escada que dá sentido a elas, porque uma
-- primeira insígnia a 50 acertos deixa a estante vazia tempo demais.
insert into insignias (codigo, nome, descricao, publico, regra, alvo, xp, ordem) values
  ('primeiros-passos', 'Primeiros Passos', 'Acertou as 10 primeiras perguntas do bairro.',        'ALUNO', 'ACERTOS',  10,  50, 1),
  ('pe-na-estrada',    'Pé na Estrada',     'Vinte e cinco perguntas certas. O bairro já conhece você.', 'ALUNO', 'ACERTOS',  25, 100, 2),
  ('meio-caminho',     'Meio Caminho',      'Cinquenta perguntas certas.',                          'ALUNO', 'ACERTOS',  50, 200, 3),
  ('centuriao',        'Centurião',         'Cem perguntas certas. Pouca gente chega aqui.',        'ALUNO', 'ACERTOS', 100, 400, 4),
  ('enciclopedia',     'Enciclopédia',      'Duzentas perguntas certas.',                           'ALUNO', 'ACERTOS', 200, 800, 5),

  ('de-volta',         'De Volta',          'Jogou três dias seguidos.',                            'ALUNO', 'DIAS',      3,  50, 6),
  ('semana-cheia',     'Semana Cheia',      'Sete dias seguidos cuidando do bairro.',               'ALUNO', 'DIAS',      7, 150, 7),
  ('presenca-de-ouro', 'Presença de Ouro',  'Trinta dias seguidos.',                                'ALUNO', 'DIAS',     30, 600, 8),

  ('primeira-missao',  'Primeira Missão',   'Concluiu a primeira tarefa do professor.',             'ALUNO', 'MISSOES',   1,  50, 9),
  ('missao-cumprida',  'Missão Cumprida',   'Concluiu dez tarefas do professor.',                   'ALUNO', 'MISSOES',  10, 300, 10)
on conflict (codigo) do update set
  nome      = excluded.nome,
  descricao = excluded.descricao,
  publico   = excluded.publico,
  regra     = excluded.regra,
  alvo      = excluded.alvo,
  xp        = excluded.xp,
  ordem     = excluded.ordem;

-- A estante do PROFESSOR existe e está vazia, de propósito. As regras
-- dele (QUIZZES e ACERTOS_TURMA) já são aceitas pela tabela; faltam as
-- linhas, que serão combinadas depois. A tela trata estante vazia como
-- estado normal, não como erro.


-- #####################################################################
--  2. FUNÇÕES AUXILIARES
--
--  Quase todas são "security definer", e isso não é detalhe: é o que
--  evita a armadilha número um do RLS. Uma policy DA tabela usuarios que
--  fizesse "select tipo from usuarios" cairia nas policies de usuarios
--  de novo, que consultariam usuarios de novo... até o PostgreSQL
--  abortar com "infinite recursion detected in policy" (42P17).
--
--  "security definer" faz a função rodar como dona da tabela, e dona de
--  tabela não passa pelo RLS. A recursão para aí.
-- #####################################################################

-- ── Conversão segura de texto para número ────────────────────────────
-- O metadado do cadastro chega como texto, vindo do navegador. Estas
-- devolvem NULL em vez de estourar quando o texto não é número — melhor
-- um cadastro com a idade em branco do que nenhum cadastro.

create or replace function public.texto_para_int(p text)
returns int language plpgsql immutable as $$
begin
  return nullif(trim(p), '')::int;
exception when others then
  return null;
end;
$$;

create or replace function public.texto_para_bigint(p text)
returns bigint language plpgsql immutable as $$
begin
  return nullif(trim(p), '')::bigint;
exception when others then
  return null;
end;
$$;

-- ── Quem sou eu ──────────────────────────────────────────────────────

create or replace function public.meu_tipo()
returns text language sql stable security definer set search_path = public as $$
  select u.tipo from usuarios u where u.id = auth.uid();
$$;

create or replace function public.eh_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from usuarios u where u.id = auth.uid() and u.tipo = 'ADMIN'
  );
$$;

create or replace function public.eh_meu_aluno(p_aluno uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1
    from usuarios a
    join turmas t on t.id = a.turma_id
    where a.id = p_aluno and t.professor_id = auth.uid()
  );
$$;

-- ── Turma pelo código ────────────────────────────────────────────────
-- Pergunta fechada: manda-se um código e recebe-se UMA turma, ou nada.
-- Não dá para varrer a tabela atrás de todos os códigos.

create or replace function public.buscar_turma_por_codigo(p_codigo text)
returns table (id bigint, nome varchar, escola_id bigint, escola_nome varchar)
language sql security definer set search_path = public as $$
  select t.id, t.nome, t.escola_id, e.nome
  from turmas t
  join escolas e on e.id = t.escola_id
  where t.codigo = upper(trim(p_codigo))
  limit 1;
$$;

-- O professor precisa ver o código das turmas DELE para entregar à sala.
create or replace function public.minhas_turmas()
returns table (id bigint, nome varchar, codigo varchar, escola_id bigint, total_alunos bigint)
language sql security definer set search_path = public as $$
  select
    t.id, t.nome, t.codigo, t.escola_id,
    (select count(*) from usuarios a where a.turma_id = t.id)
  from turmas t
  where t.professor_id = auth.uid()
  order by t.nome;
$$;

-- ── Pontuação ────────────────────────────────────────────────────────
-- Soma pontos numa barra, criando a linha se for a primeira vez.
--
-- É função (e não um update no backend) por causa da corrida: duas
-- respostas quase simultâneas fariam "ler 40, somar 10, gravar 50" duas
-- vezes e um dos acertos sumiria. Aqui a soma acontece dentro do próprio
-- update, e o banco resolve.

create or replace function public.somar_pontos(
  p_usuario uuid, p_area varchar, p_pontos int
)
returns void language plpgsql security definer set search_path = public as $$
declare
  -- A meta vem da tabela areas, e é diferente para cada barra: ela vale
  -- todos os pontos que o conteúdo daquela área pode render hoje.
  v_meta int;
begin
  select meta into v_meta from areas where nome = p_area;

  -- Área ainda sem conteúdo (Alimentação e Exercícios hoje). Guarda o
  -- ponto, mas não calcula porcentagem — dividir por zero derrubaria a
  -- resposta inteira do aluno por causa de uma barra vazia.
  if v_meta is null or v_meta <= 0 then
    insert into progresso_areas (usuario_id, area_nome, pontos, porcentagem)
    values (p_usuario, p_area, p_pontos, 0)
    on conflict (usuario_id, area_nome) do update
      set pontos = progresso_areas.pontos + p_pontos;
    return;
  end if;

  insert into progresso_areas (usuario_id, area_nome, pontos, porcentagem)
  values (p_usuario, p_area, p_pontos, least(100, p_pontos::real / v_meta * 100))
  on conflict (usuario_id, area_nome) do update
    set pontos      = progresso_areas.pontos + p_pontos,
        porcentagem = least(100, (progresso_areas.pontos + p_pontos)::real / v_meta * 100);
end;
$$;


-- ── Recalcular as metas a partir do conteúdo ─────────────────────────
--
-- A meta de uma área é a soma de tudo o que ela pode render: os pontos
-- de todas as questões que a alimentam.
--
-- Chame depois de importar conteúdo. As porcentagens de quem já jogou
-- são refeitas junto — sem isso um aluno ficaria com 100% numa barra
-- cuja régua acabou de crescer.
--
-- Só as questões DO SISTEMA entram na régua. As de professor valem pontos
-- para quem as acerta, mas não esticam a meta: senão cada pergunta criada
-- numa escola baixaria a porcentagem dos alunos de todas as outras, que
-- nem conseguem ver essa pergunta. (O teto de 100% em somar_pontos cobre
-- quem passar da meta somando as duas.)
create or replace function public.recalcular_metas()
returns void language plpgsql security definer set search_path = public as $$
begin
  update areas a
     set meta = coalesce((
       select sum(qa.pontos)
         from questoes_areas qa
         join questoes q on q.id = qa.questao_id
        where qa.area_nome = a.nome
          and q.criado_por = '00000000-0000-0000-0000-000000000000'
     ), 0);

  update progresso_areas p
     set porcentagem = case
       when a.meta > 0 then least(100, p.pontos::real / a.meta * 100)
       else 0
     end
    from areas a
   where a.nome = p.area_nome;
end;
$$;


-- ── As barras de cada aluno, relativas ao que ELE tem para fazer ─────
--
-- É ESTA função que as telas usam hoje (GET /api/meu-progresso). As
-- metas globais acima (areas.meta, recalcular_metas, a porcentagem
-- gravada em progresso_areas) ficaram como reserva e saem numa limpeza
-- futura.
--
-- POR QUE A RÉGUA MUDOU: o aluno só joga dentro dos quizzes que o
-- professor passa. Medir a barra contra o banco inteiro era medir contra
-- algo que ele nunca alcança — e, ao contrário, uma meta fixa que ele
-- já tivesse batido deixaria sem sentido continuar jogando quando
-- chegasse missão nova.
--
-- A RÉGUA DE CADA ALUNO é o "universo" dele:
--     as questões dos quizzes da turma ATUAL
--   + as questões que ele JÁ ACERTOU, em qualquer momento.
--
-- A segunda parte é a regra "conquista não se perde": se o professor
-- apaga um quiz já feito, ou o aluno troca de turma, o que ele acertou
-- continua contando — a barra não cai por uma decisão que não foi dele.
-- Já um quiz NOVO aumenta o universo e a barra desce: há coisa nova
-- para fazer (a tela avisa "novas missões" quando isso acontece).
--
-- O peso de cada questão é o `pontos` de questoes_areas, como sempre.
-- Os pontos ganhos são os do PRIMEIRO acerto de cada questão (distinct),
-- a mesma regra de POST /api/responder.
--
-- Calculada na hora, e não gravada: a régua muda quando QUALQUER
-- professor cria ou apaga quiz, ou quando o aluno troca de turma. Um
-- número gravado ficaria velho em cada um desses caminhos. Uma turma
-- com dezenas de quizzes ainda são poucos milhares de linhas — nada
-- para o Postgres, e numa ida só, sem o corte de 1000 linhas da API.
create or replace function public.progresso_do_aluno(p_usuario uuid)
returns table (area varchar, ordem int, pontos_ganhos bigint, pontos_possiveis bigint)
language sql stable security definer set search_path = public as $$
  with disponiveis as (
    select qq.questao_id
      from quiz_questoes qq
      join quizzes_professores qp on qp.id = qq.quiz_id
      join usuarios u on u.turma_id = qp.turma_id
     where u.id = p_usuario
  ),
  acertadas as (
    select distinct r.questao_id
      from respostas_alunos r
     where r.usuario_id = p_usuario and r.acertou
  ),
  universo as (
    select questao_id from disponiveis
    union
    select questao_id from acertadas
  ),
  pontos as (
    select qa.area_nome, qa.pontos, (ac.questao_id is not null) as ganho
      from universo un
      join questoes_areas qa on qa.questao_id = un.questao_id
      left join acertadas ac on ac.questao_id = un.questao_id
  )
  select a.nome,
         a.ordem,
         coalesce(sum(p.pontos) filter (where p.ganho), 0)::bigint,
         coalesce(sum(p.pontos), 0)::bigint
    from areas a
    left join pontos p on p.area_nome = a.nome
   group by a.nome, a.ordem
   order by a.ordem;
$$;

-- O "quizzes desta turma" da função acima.
create index if not exists quizzes_por_turma on quizzes_professores (turma_id);


-- #####################################################################
--  3. O PERFIL NASCE JUNTO COM A CONTA
--
--  O BUG QUE ISTO RESOLVE: o cadastro fazia duas escritas separadas —
--  o Supabase criava a linha em auth.users, e depois o navegador tentava
--  criar a linha em usuarios. Não era uma transação. Quando a segunda
--  falhava, sobrava uma conta que fazia login mas que o jogo não
--  conhecia: o usuário aparecia na aba "Users" e não na tabela usuarios.
--
--  A REGRA QUE ORGANIZA A FUNÇÃO:
--      o perfil completo é uma tentativa; a conta existir é obrigação.
--
--  Por isso o miolo fica num bloco com "exception". Quando a função de um
--  gatilho em auth.users lança erro, o Supabase desfaz a criação da conta
--  e responde "Database error saving new user" — sem dizer a causa. Ou
--  seja, um descuido aqui dentro vira "a turma inteira não consegue se
--  cadastrar". Se o perfil completo falhar, entra um perfil mínimo e o
--  motivo real vai para o log (painel -> Logs -> Postgres).
-- #####################################################################

create or replace function public.criar_perfil_do_novo_usuario()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  meta        jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_nome      text;
  v_tipo      text;
  v_idade     int;
  v_turma_id  bigint;
  v_escola_id bigint;
  v_escola_nm text;
begin
  v_nome := nullif(trim(meta->>'nome'), '');
  if v_nome is null then
    v_nome := split_part(coalesce(new.email, 'heroi@'), '@', 1);
  end if;
  v_nome := left(v_nome, 100);

  v_tipo := upper(coalesce(nullif(trim(meta->>'tipo'), ''), 'ALUNO'));

  -- ATENÇÃO: raw_user_meta_data é preenchido pelo NAVEGADOR, então é
  -- informação que a própria pessoa controla. Nada daqui pode ser aceito
  -- sem conferência. ADMIN nunca sai de um cadastro — promover é manual:
  --     update usuarios set tipo = 'ADMIN' where id = '...';
  if v_tipo not in ('ALUNO', 'PROFESSOR') then
    v_tipo := 'ALUNO';
  end if;

  begin
    if v_tipo = 'ALUNO' then
      v_idade := public.texto_para_int(meta->>'idade');

      -- O check da tabela recusa fora de 7..18 e derrubaria tudo.
      if v_idade is not null and (v_idade < 7 or v_idade > 18) then
        v_idade := null;
      end if;

      v_turma_id := public.texto_para_bigint(meta->>'turma_id');

      if v_turma_id is not null
         and not exists (select 1 from turmas t where t.id = v_turma_id) then
        v_turma_id := null;
      end if;

      v_escola_id := null;   -- a escola do aluno vem pela turma

    else
      v_escola_id := public.texto_para_bigint(meta->>'escola_id');
      v_escola_nm := nullif(trim(meta->>'escola_nome'), '');

      if v_escola_id is not null
         and not exists (select 1 from escolas e where e.id = v_escola_id) then
        v_escola_id := null;
      end if;

      -- Professor cadastrando escola nova.
      -- Procura antes de inserir em vez de usar "on conflict (nome)":
      -- aquela cláusula exige uma constraint unique e falha com 42P10 se
      -- ela não existir. Assim funciona com ou sem a constraint.
      if v_escola_id is null and v_escola_nm is not null then
        select e.id into v_escola_id
        from escolas e where lower(e.nome) = lower(v_escola_nm) limit 1;

        if v_escola_id is null then
          insert into escolas (nome) values (left(v_escola_nm, 150))
          returning id into v_escola_id;
        end if;
      end if;
    end if;

    insert into usuarios (id, nome, tipo, idade, escola_id, turma_id)
    values (new.id, v_nome, v_tipo, v_idade, v_escola_id, v_turma_id)
    on conflict (id) do nothing;

  exception when others then
    raise warning
      '[cadastro] perfil completo falhou para % (%): % / meta=%',
      new.id, new.email, sqlerrm, meta;

    begin
      insert into usuarios (id, nome, tipo)
      values (new.id, v_nome, 'ALUNO')
      on conflict (id) do nothing;
    exception when others then
      raise warning '[cadastro] perfil minimo tambem falhou para %: %', new.id, sqlerrm;
    end;
  end;

  return new;
end;
$$;

drop trigger if exists ao_criar_conta on auth.users;
create trigger ao_criar_conta
  after insert on auth.users
  for each row execute function public.criar_perfil_do_novo_usuario();

-- Adota quem já ficou órfão antes do gatilho existir.
insert into usuarios (id, nome, tipo)
select
  u.id,
  coalesce(nullif(trim(u.raw_user_meta_data->>'nome'), ''), split_part(u.email, '@', 1)),
  'ALUNO'
from auth.users u
left join usuarios p on p.id = u.id
where p.id is null
on conflict (id) do nothing;


-- #####################################################################
--  4. SEGURANÇA (RLS)
--
--  Sem isto, TODAS as tabelas ficam abertas: qualquer visitante com a
--  chave publishable lê e escreve pelo navegador. Criar tabela não
--  tranca nada — trancar é este bloco.
--
--  Como ler:
--    for select -> quem LÊ      for insert -> quem CRIA
--    for update -> quem ALTERA  for delete -> quem APAGA
--    to anon    -> qualquer visitante, mesmo sem conta
--    to authenticated -> só quem entrou
--    auth.uid() -> o identificador de quem está logado agora
-- #####################################################################

alter table escolas             enable row level security;
alter table turmas              enable row level security;
alter table usuarios            enable row level security;
alter table cenarios            enable row level security;
alter table questoes            enable row level security;
alter table areas               enable row level security;
alter table questoes_areas      enable row level security;
alter table progresso_areas     enable row level security;
alter table respostas_alunos    enable row level security;
alter table pacientes_virtuais  enable row level security;
alter table quizzes_professores enable row level security;


-- ── usuarios ─────────────────────────────────────────────────────────

drop policy if exists "ler o proprio cadastro"              on usuarios;
drop policy if exists "criar o proprio cadastro"            on usuarios;
drop policy if exists "editar o proprio cadastro"           on usuarios;
drop policy if exists "professor le os alunos das turmas dele" on usuarios;
drop policy if exists "admin le todos os cadastros"         on usuarios;
drop policy if exists "admin edita qualquer cadastro"       on usuarios;

create policy "ler o proprio cadastro"
  on usuarios for select to authenticated using (auth.uid() = id);

create policy "criar o proprio cadastro"
  on usuarios for insert to authenticated with check (auth.uid() = id);

-- Pode corrigir o próprio nome, mas NÃO pode se promover. Sem esta
-- trava, qualquer aluno viraria PROFESSOR com um update e passaria a
-- ler os dados dos colegas.
create policy "editar o proprio cadastro"
  on usuarios for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id and tipo = public.meu_tipo());

create policy "professor le os alunos das turmas dele"
  on usuarios for select to authenticated using (public.eh_meu_aluno(usuarios.id));

create policy "admin le todos os cadastros"
  on usuarios for select to authenticated using (public.eh_admin());

create policy "admin edita qualquer cadastro"
  on usuarios for update to authenticated
  using (public.eh_admin()) with check (public.eh_admin());


-- ── escolas ──────────────────────────────────────────────────────────
-- Legível por VISITANTE de propósito: o aluno escolhe a escola durante o
-- cadastro, ou seja, ANTES de ter conta.

drop policy if exists "qualquer um le as escolas" on escolas;
drop policy if exists "logado cria escola"        on escolas;
drop policy if exists "admin cuida das escolas"   on escolas;

create policy "qualquer um le as escolas"
  on escolas for select to anon, authenticated using (true);

-- Normalmente quem cria escola é o gatilho do cadastro, que roda como
-- dono e nem passa por aqui. Esta policy cobre o caso do professor
-- criando escola pela tela depois de já estar logado.
create policy "logado cria escola"
  on escolas for insert to authenticated with check (true);

create policy "admin cuida das escolas"
  on escolas for update to authenticated
  using (public.eh_admin()) with check (public.eh_admin());


-- ── turmas ───────────────────────────────────────────────────────────

drop policy if exists "qualquer um le as turmas"        on turmas;
drop policy if exists "professor cria turma"            on turmas;
drop policy if exists "professor altera a propria turma" on turmas;
drop policy if exists "professor apaga a propria turma" on turmas;
drop policy if exists "admin cuida das turmas"          on turmas;
drop policy if exists "admin apaga turma"               on turmas;

create policy "qualquer um le as turmas"
  on turmas for select to anon, authenticated using (true);

create policy "professor cria turma"
  on turmas for insert to authenticated
  with check (public.meu_tipo() in ('PROFESSOR', 'ADMIN'));

create policy "professor altera a propria turma"
  on turmas for update to authenticated using (professor_id = auth.uid());

-- Turma com aluno dentro não é apagada: o progresso deles iria junto.
create policy "professor apaga a propria turma"
  on turmas for delete to authenticated
  using (
    professor_id = auth.uid()
    and not exists (select 1 from usuarios a where a.turma_id = turmas.id)
  );

create policy "admin cuida das turmas"
  on turmas for update to authenticated
  using (public.eh_admin()) with check (public.eh_admin());

create policy "admin apaga turma"
  on turmas for delete to authenticated using (public.eh_admin());


-- ── Conteúdo do jogo: todos leem, só o admin escreve ─────────────────
--
-- O "drop" de "logado le o conteudo" roda nas QUATRO tabelas, mas a
-- policy só volta em cenarios e areas: questoes e questoes_areas ganharam
-- regra própria logo abaixo, por causa das questões de professor.

do $$
declare t text;
begin
  foreach t in array array['cenarios', 'questoes', 'areas', 'questoes_areas'] loop
    execute format('drop policy if exists "logado le o conteudo" on %I', t);
    execute format('drop policy if exists "admin escreve o conteudo" on %I', t);

    execute format(
      'create policy "admin escreve o conteudo" on %I for all to authenticated
         using (public.eh_admin()) with check (public.eh_admin())', t);
  end loop;

  foreach t in array array['cenarios', 'areas'] loop
    execute format(
      'create policy "logado le o conteudo" on %I for select to authenticated using (true)', t);
  end loop;
end $$;

-- As questões do sistema, todo logado lê. As de professor, só o próprio
-- autor (e o admin). Sem isto, um professor listaria pelo console as
-- perguntas que os colegas de outras escolas escreveram.
--
-- O aluno não precisa ler a questão do professor por aqui: ele a recebe
-- pelo servidor (GET /api/quizzes/:id/questoes), que confere se o quiz é
-- da turma dele.
--
-- Professor NÃO tem policy de insert: questão nova passa pelo servidor,
-- que valida os campos e grava criado_por a partir do login.
drop policy if exists "le as questoes do sistema e as proprias" on questoes;

create policy "le as questoes do sistema e as proprias"
  on questoes for select to authenticated using (
    criado_por = '00000000-0000-0000-0000-000000000000'
    or criado_por = auth.uid()
    or public.eh_admin()
  );

-- Os pontos por área seguem a questão: quem não vê a questão não vê as
-- linhas dela. O exists passa pela policy de questoes acima — e não há
-- recursão, porque aquela policy não consulta questoes_areas.
drop policy if exists "le as areas das questoes que enxerga" on questoes_areas;

create policy "le as areas das questoes que enxerga"
  on questoes_areas for select to authenticated using (
    exists (select 1 from questoes q where q.id = questoes_areas.questao_id)
  );

-- ⚠️ A policy acima libera a LINHA INTEIRA de questoes, e a linha tem
-- resposta_correta. O RLS é por linha e não sabe esconder coluna, então
-- sozinho ele entregaria o gabarito a qualquer aluno logado.
--
-- Quem fecha isso é a permissão por COLUNA, na seção 5 deste arquivo.
-- O quiz continua passando pelo servidor Express (server/rotas/jogo.js),
-- que enxerga tudo com a chave secreta e devolve só "acertou" mais a
-- explicação — agora as duas trancas se somam, em vez de só a convenção.


-- ── Progresso do aluno ───────────────────────────────────────────────
--
-- O aluno só LÊ. Quem escreve é o servidor Express, com a chave secreta.
--
-- Não é excesso de zelo: com permissão de update, o aluno fazia
--     update progresso_areas set pontos = 999999
-- na própria linha pelo console, e o banco aceitava — a linha era dele.
-- "Esta linha é sua?" o RLS responde bem; "você merece estes pontos?"
-- é regra de jogo, e regra de jogo mora no servidor.

drop policy if exists "le o proprio progresso"                on progresso_areas;
drop policy if exists "cria o proprio progresso"              on progresso_areas;
drop policy if exists "altera o proprio progresso"            on progresso_areas;
drop policy if exists "professor le o progresso dos alunos dele" on progresso_areas;

create policy "le o proprio progresso"
  on progresso_areas for select to authenticated using (auth.uid() = usuario_id);

create policy "professor le o progresso dos alunos dele"
  on progresso_areas for select to authenticated using (public.eh_meu_aluno(usuario_id));

drop policy if exists "le as proprias respostas"               on respostas_alunos;
drop policy if exists "cria as proprias respostas"             on respostas_alunos;
drop policy if exists "professor le as respostas dos alunos dele" on respostas_alunos;

create policy "le as proprias respostas"
  on respostas_alunos for select to authenticated using (auth.uid() = usuario_id);

create policy "professor le as respostas dos alunos dele"
  on respostas_alunos for select to authenticated using (public.eh_meu_aluno(usuario_id));

drop policy if exists "le o proprio paciente"    on pacientes_virtuais;
drop policy if exists "cria o proprio paciente"  on pacientes_virtuais;
drop policy if exists "altera o proprio paciente" on pacientes_virtuais;

create policy "le o proprio paciente"
  on pacientes_virtuais for select to authenticated using (auth.uid() = usuario_id);


-- ── Quizzes do professor ─────────────────────────────────────────────

drop policy if exists "professor le os proprios quizzes"    on quizzes_professores;
drop policy if exists "professor cria os proprios quizzes"  on quizzes_professores;
drop policy if exists "professor altera os proprios quizzes" on quizzes_professores;
drop policy if exists "professor apaga os proprios quizzes" on quizzes_professores;

create policy "professor le os proprios quizzes"
  on quizzes_professores for select to authenticated using (auth.uid() = professor_id);
create policy "professor cria os proprios quizzes"
  on quizzes_professores for insert to authenticated with check (auth.uid() = professor_id);
create policy "professor altera os proprios quizzes"
  on quizzes_professores for update to authenticated using (auth.uid() = professor_id);
create policy "professor apaga os proprios quizzes"
  on quizzes_professores for delete to authenticated using (auth.uid() = professor_id);

-- Faltava o outro lado: o aluno precisa VER o quiz que lhe foi passado.
-- Sem esta política, o professor criava a tarefa e a turma não enxergava
-- nada — só o servidor Express conseguia ler, com a chave secreta.
drop policy if exists "aluno le os quizzes da turma dele" on quizzes_professores;

create policy "aluno le os quizzes da turma dele"
  on quizzes_professores for select to authenticated using (
    turma_id in (select u.turma_id from usuarios u where u.id = auth.uid())
  );


-- ── As questões congeladas de cada quiz ──────────────────────────────
--
-- Só leitura, para os dois lados. Quem ESCREVE aqui é o servidor, no
-- momento do sorteio — se o aluno pudesse inserir, escolheria as próprias
-- perguntas; se pudesse apagar, sumiria com as que não soubesse.
alter table quiz_questoes enable row level security;

drop policy if exists "professor le as questoes dos proprios quizzes" on quiz_questoes;
drop policy if exists "aluno le as questoes do quiz da turma dele"    on quiz_questoes;

create policy "professor le as questoes dos proprios quizzes"
  on quiz_questoes for select to authenticated using (
    quiz_id in (select q.id from quizzes_professores q where q.professor_id = auth.uid())
  );

create policy "aluno le as questoes do quiz da turma dele"
  on quiz_questoes for select to authenticated using (
    quiz_id in (
      select q.id from quizzes_professores q
      join usuarios u on u.turma_id = q.turma_id
      where u.id = auth.uid()
    )
  );


-- ── XP diário e insígnias ────────────────────────────────────────────
--
-- Repare no que NÃO existe aqui: nenhuma policy de insert ou update.
-- É deliberado, e é a mesma regra de progresso_areas — quem escreve
-- pontuação é o servidor, com a chave secreta. Com um insert liberado,
-- qualquer aluno abriria o console e se daria 50 XP cinquenta vezes,
-- ou se concederia a insígnia de 225 acertos sem responder nada.
--
-- A pessoa LÊ o próprio XP e as próprias insígnias. Só isso.
alter table xp_diario          enable row level security;
alter table insignias          enable row level security;
alter table insignias_usuarios enable row level security;
alter table quiz_concluidos    enable row level security;

drop policy if exists "le as proprias conclusoes"           on quiz_concluidos;
drop policy if exists "professor le as conclusoes da turma" on quiz_concluidos;

create policy "le as proprias conclusoes"
  on quiz_concluidos for select to authenticated using (auth.uid() = usuario_id);

-- O professor precisa ver de onde veio o XP dele. É o mesmo direito que
-- ele já tem sobre as respostas dos alunos das turmas dele.
create policy "professor le as conclusoes da turma"
  on quiz_concluidos for select to authenticated using (auth.uid() = professor_id);

drop policy if exists "le o proprio xp diario" on xp_diario;

create policy "le o proprio xp diario"
  on xp_diario for select to authenticated using (auth.uid() = usuario_id);

-- O catálogo é conteúdo do jogo, como cenarios e areas: todo mundo vê a
-- estante inteira, inclusive as que ainda não conquistou. É isso que
-- transforma a prateleira vazia em objetivo em vez de mistério.
drop policy if exists "todos leem o catalogo de insignias" on insignias;

create policy "todos leem o catalogo de insignias"
  on insignias for select to authenticated using (true);

drop policy if exists "le as proprias insignias"            on insignias_usuarios;
drop policy if exists "professor le as insignias dos alunos" on insignias_usuarios;

create policy "le as proprias insignias"
  on insignias_usuarios for select to authenticated using (auth.uid() = usuario_id);

-- O professor acompanha a turma: ver quem conquistou o quê é o mesmo
-- direito que ele já tem sobre as respostas dos alunos dele.
create policy "professor le as insignias dos alunos"
  on insignias_usuarios for select to authenticated using (public.eh_meu_aluno(usuario_id));


-- #####################################################################
--  5. PERMISSÃO POR COLUNA
--
--  O RLS é por LINHA e não sabe esconder uma coluna. Mas a policy de
--  turmas precisa liberar a linha para VISITANTE (o aluno escolhe a
--  turma antes de ter conta) — e a linha tem o "codigo", que deveria ser
--  a credencial que o professor entrega à sala.
--
--  Sem isto, "select codigo from turmas" devolvia todos os códigos de
--  todas as escolas, e o código não filtrava ninguém.
--
--  Quem resolve é a permissão por COLUNA, que o PostgreSQL tem.
--  Quem precisa do código legitimamente usa minhas_turmas() ou o
--  servidor Express.
-- #####################################################################

revoke select on turmas from anon, authenticated;
grant  select (id, nome, escola_id, created_at) on turmas to anon, authenticated;

-- O mesmo problema, e a mesma solução, para o gabarito: a policy de
-- conteúdo libera a linha de questoes, e a linha tem resposta_correta e
-- explicacao. Sem isto, "select * from questoes" no console do navegador
-- devolvia o gabarito inteiro do jogo — e piora a cada questão importada.
--
-- A explicacao também fica de fora porque ela costuma dizer QUAL é a
-- resposta ("a alternativa correta é a B porque..."). Quem precisa das
-- duas legitimamente é o servidor Express, que usa a chave secreta e não
-- passa por aqui; ele entrega a explicação em /api/responder, depois que
-- o aluno já gastou a tentativa.
--
-- Efeito colateral aceito: o ADMIN também deixa de ler essas duas colunas
-- pelo navegador. Para corrigir conteúdo ele usa o SQL Editor do painel,
-- que roda como postgres e ignora estas permissões — é o mesmo caminho
-- que o projeto já usa para importar questão.
revoke select on questoes from anon, authenticated;
grant  select (id, cenario_id, nivel_etario, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e)
  on questoes to anon, authenticated;

grant execute on function public.buscar_turma_por_codigo(text) to anon, authenticated;
grant execute on function public.minhas_turmas() to authenticated;

-- Pontuar é assunto do servidor. O aluno não executa isto.
--
-- O "from public" é o que importa: no PostgreSQL, create function já
-- concede execute a PUBLIC, e todo perfil (anon, authenticated) herda
-- dali. Revogar só dos perfis tirava um grant direto que nunca existiu,
-- e deixava o herdado intacto — na prática, o aluno conseguia chamar
-- somar_pontos com 999999 pontos e encher as próprias barras.
revoke execute on function public.somar_pontos(uuid, varchar, int) from public;
revoke execute on function public.somar_pontos(uuid, varchar, int) from anon, authenticated;

-- Mesma trava para a recalculadora de metas: ela reescreve a porcentagem
-- de TODO mundo. Roda no SQL Editor (como postgres) ou pelo servidor.
revoke execute on function public.recalcular_metas() from public;
revoke execute on function public.recalcular_metas() from anon, authenticated;

-- As barras de um aluno: só o servidor pergunta. A função é security
-- definer e recebe o id por parâmetro — aberta, qualquer logado leria o
-- progresso de qualquer colega só trocando o uuid.
revoke execute on function public.progresso_do_aluno(uuid) from public;
revoke execute on function public.progresso_do_aluno(uuid) from anon, authenticated;

-- ── O que a pessoa pode alterar no próprio cadastro ──────────────────
-- A policy "editar o proprio cadastro" (seção 4) diz QUAL LINHA: a
-- própria. Não diz QUAIS COLUNAS — e o RLS não sabe dizer. Sem isto, um
-- aluno trocava pelo console a própria turma (entrando em qualquer
-- sala, sem código), a idade (mudando as perguntas que recebe) ou a
-- escola.
--
-- Pelo navegador, só nome e foto. E nem esses são escritos direto
-- hoje: passam por PATCH /api/meu-perfil. Entrar numa turma é
-- POST /api/minha-turma, que só aceita quem ainda não tem turma.
-- O servidor usa a chave secreta e não passa por aqui.
revoke update on usuarios from anon, authenticated;
grant  update (nome, avatar_url) on usuarios to authenticated;


-- #####################################################################
--  6. CONFERIR SE DEU CERTO
--
--  Descomente e rode. Ou use db/00-testSecurity.sql, que já traz tudo.
-- #####################################################################

-- (a) Todas as tabelas devem vir com rowsecurity = true.
-- select tablename, rowsecurity from pg_tables
-- where schemaname = 'public' order by rowsecurity, tablename;

-- (b) Não deve sobrar nenhuma conta sem perfil.
-- select count(*) as contas_orfas from auth.users u
-- left join public.usuarios p on p.id = u.id where p.id is null;

-- (c) O visitante não enxerga codigo nem professor_id.
--     Devem vir 4 colunas por grantee: created_at, escola_id, id, nome.
--     O filtro por privilege_type é obrigatório — sem ele a consulta
--     traz INSERT/UPDATE/REFERENCES junto e parece que o revoke falhou.
-- select grantee, column_name from information_schema.column_privileges
-- where table_name = 'turmas' and privilege_type = 'SELECT'
--   and grantee in ('anon','authenticated') order by grantee, column_name;

-- (d) O gatilho está ligado? Uma linha, tgenabled = 'O'.
-- select tgname, tgenabled from pg_trigger
-- where tgrelid = 'auth.users'::regclass and not tgisinternal;

-- (e) O aluno não enxerga o gabarito.
--     Devem vir 9 colunas por grantee: cenario_id, enunciado, id,
--     nivel_etario e opcao_a..opcao_e. Se aparecer resposta_correta ou explicacao, o
--     revoke da seção 5 não pegou.
-- select grantee, column_name from information_schema.column_privileges
-- where table_name = 'questoes' and privilege_type = 'SELECT'
--   and grantee in ('anon','authenticated') order by grantee, column_name;

-- (f) Ninguém além do servidor executa somar_pontos.
--     Atenção à leitura: proacl NULO é o problema, não a solução — nulo
--     quer dizer "padrão do PostgreSQL", e o padrão é PUBLIC podendo
--     executar. O que se espera aqui é um proacl preenchido e SEM a
--     entrada "=X/" (grantee vazio antes do "=" é justamente o PUBLIC).
-- select proname, proacl from pg_proc where proname = 'somar_pontos';


-- #####################################################################
--  7. AVISAR A API QUE O DESENHO MUDOU
--
--  O Supabase guarda em cache o desenho das tabelas. Sem este aviso, a
--  tabela existe no banco e a API continua respondendo
--  "Could not find the table ... in the schema cache" — o cenário mais
--  confuso de depurar que existe aqui, porque o SQL rodou sem erro.
--
--  Fica no FIM do arquivo de propósito: assim vale para tudo o que foi
--  criado acima, e não só para o último bloco.
-- #####################################################################

notify pgrst, 'reload schema';
