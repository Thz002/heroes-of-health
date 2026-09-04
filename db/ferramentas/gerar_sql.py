# -*- coding: utf-8 -*-
"""Le questoes_extraidas.json e escreve um .sql de import.

Passo 2 de 2, depois do parser.py.

  python gerar_sql.py                        -> db/importar-questoes.sql
  python gerar_sql.py ../importar-n3.sql     -> outro arquivo

CUIDADO: nao gere por cima de um .sql que ja recebeu explicacoes
escritas a mao -- elas voltariam a ser placeholder. Para um lote novo,
passe outro nome de arquivo.
"""
import json, sys, io, os
from collections import defaultdict
sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(os.path.dirname(AQUI))   # db/ferramentas -> raiz do projeto
PLACEHOLDER = ('Explicação em elaboração pela equipe de Medicina. '
               'Confira a resposta correta e siga em frente — errar faz parte de aprender!')
PONTOS_POR_AREA = 10

NOMES = {'ubs': 'UBS', 'escola': 'Escola', 'mercado': 'Mercado', 'farmacia': 'Farmácia',
         'praca': 'Praça', 'corrego': 'Córrego', 'terreno-baldio': 'Terreno Baldio',
         'casa': 'Casa', 'upa': 'UPA', 'creche': 'Creche', 'quadra': 'Campo de lazer',
         'parque': 'Parque'}
FAIXA = {1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos'}


def q(s):
    """Aspas simples do Postgres: o escape e duplicar, nunca barra invertida."""
    return "'" + str(s).replace("'", "''") + "'"


qs = json.load(open(os.path.join(AQUI, 'questoes_extraidas.json'), encoding='utf-8'))
prontas = [x for x in qs if len(x['alts']) == 4 and x['certa'] is not None
           and x['lugares'] and x['areas']]
fora = [x for x in qs if x not in prontas]

grupos = defaultdict(list)
for x in prontas:
    grupos[(x['lugares'][0], x['nivel'])].append(x)

L = []
w = L.append

w('-- =====================================================================')
w('--  HERÓIS DA SAÚDE — as perguntas da equipe de Medicina')
w('--')
w('--  Gerado a partir dos .docx da equipe por db/ferramentas/gerar_sql.py,')
w('--  mas A PARTIR DAQUI ESTE ARQUIVO É A FONTE DA VERDADE: as explicações')
w('--  entram aqui, à mão, como em qualquer outro arquivo de db/.')
w('--')
w('--  Só NÃO rode o gerador de novo em cima dele — isso devolveria os')
w('--  placeholders por cima do que a Medicina escrever. Para um lote novo')
w('--  (o nível 3, por exemplo), o gerador escreve em outro arquivo.')
w('--')
w('--  Rode DEPOIS de db/setup.sql e db/seed.sql.')
w('--')
w('--  É seguro rodar quantas vezes quiser: cada missão e cada questão tem')
w('--  um codigo_externo único, e o import é "on conflict do update".')
w('--  Rodar de novo corrige o texto SEM apagar nenhuma resposta já dada')
w('--  pelos alunos — o que um "delete + insert" destruiria, porque')
w('--  respostas_alunos referencia questoes com on delete cascade.')
w('--')
w('--  %d questões, em %d missões (cenário × nível).' % (len(prontas), len(grupos)))
w('--')
w('--  As explicações nascem como PLACEHOLDER: o arquivo de origem não')
w('--  trazia o texto que o aluno vê ao errar. Troque cada uma aqui quando')
w('--  a Medicina entregar, e rode o arquivo de novo — o update cobre a')
w('--  coluna explicacao, então o texto novo chega ao banco.')
w('--')
w('--  CUIDADO AO ESCREVER: apóstrofo dentro do texto tem de ser DOBRADO.')
w("--    errado:  'a caixa-d'agua'      certo:  'a caixa-d''agua'")
w('--')
w('--  Para achar as que ainda faltam:')
w("--    select count(*) from questoes where explicacao like 'Explicação em elaboração%';")
w('-- =====================================================================')
w('')

if fora:
    w('-- Ficaram DE FORA, por não caberem no formato de 4 alternativas ou')
    w('-- por não terem a resposta marcada em verde no arquivo de origem:')
    for x in fora:
        motivo = []
        if len(x['alts']) != 4:
            motivo.append('%d alternativas' % len(x['alts']))
        if x['certa'] is None:
            motivo.append('sem resposta marcada')
        w('--   nível %d, questão %d: %s' % (x['nivel'], x['num'], ', '.join(motivo)))
        w('--     %s' % x['enunciado'][:88])
    w('')

w('')
w('-- ── Guarda: os cenários têm de existir antes ─────────────────────────')
slugs = sorted({k[0] for k in grupos})
w('do $$')
w('declare faltando text;')
w('begin')
w("  select string_agg(s, ', ') into faltando")
w('  from unnest(array[%s]) s' % ', '.join(q(s) for s in slugs))
w('  where not exists (select 1 from cenarios c where c.slug = s);')
w('  if faltando is not null then')
w("    raise exception 'Cenários que faltam no banco: %. Rode db/seed.sql antes deste arquivo.', faltando;")
w('  end if;')
w('end $$;')
w('')
w('')

w('-- ── 1. As missões ────────────────────────────────────────────────────')
w('-- Uma por (cenário × nível): é ela que carrega o lugar do mapa, a faixa')
w('-- etária e as barras que enche. As questões herdam tudo isso.')
w('')
for (slug, nivel), itens in sorted(grupos.items()):
    cod = '%s-N%d' % (slug.upper().replace('-', ''), nivel)
    titulo = '%s · %s' % (NOMES[slug], FAIXA[nivel])
    desc = ('Perguntas de saúde ambientadas em %s, para a faixa de %s. %d questões.'
            % (NOMES[slug].lower(), FAIXA[nivel], len(itens)))
    w('insert into missoes (codigo_externo, cenario_id, titulo, descricao, nivel_etario)')
    w('select %s, c.id, %s, %s, %d' % (q(cod), q(titulo), q(desc), nivel))
    w('  from cenarios c where c.slug = %s' % q(slug))
    w('on conflict (codigo_externo) do update')
    w('  set titulo = excluded.titulo, descricao = excluded.descricao,')
    w('      cenario_id = excluded.cenario_id, nivel_etario = excluded.nivel_etario;')
    w('')

w('')
w('-- ── 2. Quais barras cada missão enche ────────────────────────────────')
w('-- SEM ESTAS LINHAS O ALUNO ACERTA E NADA ACONTECE: o servidor lê daqui')
w('-- para saber o que somar, e zero linhas = zero pontos, sem erro nenhum.')
w('-- Cada acerto vale %d pontos em cada barra listada.' % PONTOS_POR_AREA)
w('')
for (slug, nivel), itens in sorted(grupos.items()):
    cod = '%s-N%d' % (slug.upper().replace('-', ''), nivel)
    areas = sorted({a for x in itens for a in x['areas']})
    w('-- %s: %s' % (cod, ', '.join(areas)))
    w('insert into missao_areas (missao_id, area_nome, pontos)')
    w('select m.id, v.area, v.pontos from missoes m')
    w('  cross join (values')
    w(',\n'.join('    (%s, %d)' % (q(a), PONTOS_POR_AREA) for a in areas))
    w('  ) as v(area, pontos)')
    w('  where m.codigo_externo = %s' % q(cod))
    w('on conflict (missao_id, area_nome) do update set pontos = excluded.pontos;')
    w('')

w('')
w('-- ── 3. As questões ───────────────────────────────────────────────────')
w('')
for (slug, nivel), itens in sorted(grupos.items()):
    cod_m = '%s-N%d' % (slug.upper().replace('-', ''), nivel)
    w('-- %s — %d questões' % (cod_m, len(itens)))
    w('')
    for i, x in enumerate(itens, 1):
        cod_q = '%s-%03d' % (cod_m, i)
        letra = 'ABCD'[x['certa']]
        w('insert into questoes (codigo_externo, missao_id, enunciado,')
        w('       opcao_a, opcao_b, opcao_c, opcao_d, resposta_correta, explicacao)')
        w('select %s, m.id, %s,' % (q(cod_q), q(x['enunciado'])))
        for a in x['alts']:
            w('       %s,' % q(a))
        w('       %s, %s' % (q(letra), q(PLACEHOLDER)))
        w('  from missoes m where m.codigo_externo = %s' % q(cod_m))
        w('on conflict (codigo_externo) do update')
        w('  set enunciado = excluded.enunciado, missao_id = excluded.missao_id,')
        w('      opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,')
        w('      opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,')
        w('      resposta_correta = excluded.resposta_correta,')
        w('      explicacao = excluded.explicacao;')
        w('')
    w('')

w('-- ── Conferir depois de rodar ─────────────────────────────────────────')
w('-- select c.slug, m.nivel_etario, count(q.id) as questoes')
w('--   from missoes m join cenarios c on c.id = m.cenario_id')
w('--   left join questoes q on q.missao_id = m.id')
w('--  group by c.slug, m.nivel_etario order by c.slug, m.nivel_etario;')

destino = sys.argv[1] if len(sys.argv) > 1 else os.path.join(RAIZ, 'db', 'importar-questoes.sql')
io.open(destino, 'w', encoding='utf-8').write('\n'.join(L) + '\n')

print('gerado: %s' % destino)
print('  questoes importadas : %d' % len(prontas))
print('  deixadas de fora    : %d' % len(fora))
print('  missoes             : %d' % len(grupos))
print('  linhas de SQL       : %d' % len(L))
print('')
print('missoes por cenario x nivel:')
for (slug, nivel), itens in sorted(grupos.items()):
    areas = sorted({a for x in itens for a in x['areas']})
    print('  %-15s n%d  %3d questoes  | %s' % (slug, nivel, len(itens), ', '.join(areas)))
