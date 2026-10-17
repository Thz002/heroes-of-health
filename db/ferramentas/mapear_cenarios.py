import importlib.util
import os
import re
import sys
import unicodedata
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('cb', os.path.join(AQUI, 'casar_com_banco.py'))
cb = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cb)

FAIXA_NOME = {1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos'}
QTD_MIN = 3


# 1. Blocos (primeira, última) de cada nível, contados a partir de 1.
BLOCOS = {
    1: [
        ((1, 1),   'terreno-baldio'),  # vizinhos removendo recipientes
        ((2, 2),   'casa'),            # faxina no quintal contra a dengue
        ((3, 4),   'farmacia'),        # vacina da dengue
        ((5, 6),   'creche'),          # lavar as mãos e higiene na infância
        ((7, 9),   'upa'),             # AVC, problema respiratório grave
        ((10, 12), 'casa'),            # sono, descanso, alimentação
        ((13, 16), 'escola'),          # escola segura, Maio Laranja, direitos
        ((17, 31), 'ubs'),
        ((32, 46), 'upa'),
        ((47, 62), 'farmacia'),
        ((63, 63), 'mercado'),         # lanche com fruta e pão
    ],
    2: [
        ((1, 1),     'mercado'),
        ((2, 13),    'escola'),          # bullying, violência, cultura de paz
        ((14, 28),   'corrego'),         # saneamento, esgoto, água
        ((29, 43),   'corrego'),         # rios, preservação, saúde ambiental
        ((44, 58),   'farmacia'),
        ((59, 73),   'terreno-baldio'),
        ((74, 88),   'quadra'),          # esporte, sistemas do corpo em movimento
        ((89, 103),  'praca'),           # pracinha, calor, hidratação
        ((104, 118), 'parque'),          # áreas verdes, lixo, cidadania ambiental
        ((119, 133), 'ubs'),
        ((134, 148), 'upa'),
    ],
    # Nível 3: faixas mais finas, porque alguns blocos misturam lugares.
    3: [
        ((1, 8),     'terreno-baldio'),  # arboviroses e o Aedes
        ((9, 16),    'farmacia'),        # vacinas e imunização
        ((17, 18),   'farmacia'),        # superbactérias, uso de antibiótico
        ((19, 19),   'corrego'),         # leptospirose em enchente
        ((20, 20),   'upa'),             # meningite: urgência
        ((21, 24),   'ubs'),             # ITU, sífilis, hanseníase, salmonelose
        ((25, 29),   'corrego'),         # saneamento, esquistossomose
        ((30, 32),   'ubs'),             # micoses, fungos oportunistas
        ((33, 40),   'ubs'),             # ISTs
        ((41, 41),   'mercado'),         # obesidade como fator de risco
        ((42, 42),   'quadra'),          # sedentarismo
        ((43, 43),   'casa'),            # hipertensão, a doença silenciosa
        ((44, 45),   'mercado'),         # ultraprocessados, anemia por ferro
        ((46, 46),   'ubs'),             # fatores de risco evitáveis de câncer
        ((47, 48),   'casa'),            # diabetes, síndrome metabólica
        ((49, 49),   'creche'),          # tireoide em crianças
        ((50, 50),   'praca'),           # espaços públicos de lazer
        ((51, 61),   'praca'),           # saúde mental, telas, bullying
        ((62, 70),   'escola'),          # genética, endócrino, ocupacional
        ((71, 75),   'praca'),           # saúde mental na prática
        ((76, 81),   'ubs'),             # ISTs na prática
        ((82, 84),   'farmacia'),        # caderneta de vacinação
        ((85, 87),   'mercado'),         # alimentação
        ((88, 89),   'quadra'),          # atividade física
        ((90, 94),   'escola'),          # substâncias, cigarro eletrônico
        ((95, 99),   'escola'),          # bullying e violência
        ((100, 100), 'terreno-baldio'),  # criadouros
        ((101, 101), 'casa'),            # determinantes sociais e ambientais
        ((102, 102), 'farmacia'),        # automedicação
        ((103, 104), 'escola'),          # informação de saúde e fontes confiáveis
        # 105 em diante: cauda estilo ENEM, decidida por assunto.
    ],
}


# 2. Assunto -> lugar (cauda do nível 3). A primeira regra que casar decide.
POR_ASSUNTO = [
    # Urgência vem antes de tudo.
    ('upa',            r'hemorragia|cascavel|serpente|picad|envenenament|intoxicac|parada card|'
                       r'urgenc|emergenc|socorro'),

    ('terreno-baldio', r'dengue|aedes|mosquit|arbovir|leishman|filarios|chagas|triatom|vetor'),
    ('corrego',        r'esquistossom|saneament|esgoto|agua contaminada|leptospir|\brio\b'),

    # Regulação e medicamentos antes de genética.
    ('farmacia',       r'vacina|imuniz|anvisa|terapia genica|terapia celular|antiveneno|'
                       r'anticorpo monoclonal|rna mensageiro|rnam'),

    # Genética antes de criança e músculo.
    ('escola',         r'mutaca|cromossom|trissomia|clonagem|biotecnolog|genotoxic|micronucleo|'
                       r'equilibrio genetico|hereditar|distrofia|dna recombinante|\bgene\b'),

    ('creche',         r'crianc|lactente|primeira infancia|amamenta|recem.nascid|\bbebe\b|neonat'),
    ('mercado',        r'aliment|refrigerante|arroz|betacaroten|nutrient|\bferro\b|dieta|obesid|'
                       r'vitamina|acucar'),
    ('quadra',         r'muscul|esport|desempenho fisic|exercici|atleta|fibras? lenta|\bepo\b|'
                       r'eritropoetina'),
    ('farmacia',       r'medicament|farmac|antibiotic|\bdose|comprimid|revestiment|principio ativo'),
    ('ubs',            r'\brim\b|rins|retina|olho|visao|plaqueta|sangue|hormon|gestan|menstrua|'
                       r'tireoide|diagnostic|exame|teste genetic|covid|hiv|htlv|cancer|tumor|'
                       r'fertilizacao|\btpm\b|tensao pre'),
    ('escola',         r'dna|celul|enzima|proteina|mitocondri|in vitro|genetic'),
]

PADRAO = 'escola'   # ciência sem gancho de lugar: a aula de ciências


def sem_acento(s):
    t = unicodedata.normalize('NFD', (s or '').lower())
    return ''.join(c for c in t if unicodedata.category(c) != 'Mn')


def cenario_de(nivel, posicao, enunciado):
    """Devolve (cenario, por_que)."""
    for (ini, fim), slug in BLOCOS.get(nivel, []):
        if ini <= posicao <= fim:
            return slug, 'bloco'

    texto = sem_acento(enunciado)
    for slug, padrao in POR_ASSUNTO:
        if re.search(padrao, texto):
            return slug, 'assunto'

    return PADRAO, 'padrão'


def classificar():
    pares, sem_par, duvidosos, novas, cenarios, doc, linhas = cb.casar()

    # Quantas já existem no jogo, por cenário e nível.
    slug_de = {c['id']: c['slug'] for c in cb.ler_banco()['cenarios']} \
        if not isinstance(cenarios, dict) else cenarios
    atual = defaultdict(Counter)
    for q in linhas:
        atual[slug_de.get(q['cenario_id'], '(sem cenário)')][q['nivel_etario']] += 1

    # Classifica as novas, nível a nível, pela posição no documento.
    propostas = []
    for nivel in (1, 2, 3):
        doN = [q for q in novas if q['nivel'] == nivel]
        for posicao, q in enumerate(doN, 1):
            slug, motivo = cenario_de(nivel, posicao, q['enunciado'])
            propostas.append({'q': q, 'nivel': nivel, 'posicao': posicao,
                              'cenario': slug, 'motivo': motivo})

    return propostas, atual, slug_de, linhas


def relatorio(propostas, atual, slug_de, linhas):
    L = []
    def p(s=''): L.append(s)

    novas_por = defaultdict(Counter)
    for x in propostas:
        novas_por[x['cenario']][x['nivel']] += 1

    todos = sorted(set(list(atual.keys()) + list(novas_por.keys())))
    todos = [s for s in todos if s != '(sem cenário)']

    p('# Prévia da distribuição')
    p()
    p('Como ficaria o jogo se as 354 questões novas entrassem na proposta abaixo.')
    p('**Nada foi gravado** — este arquivo existe para a equipe conferir antes.')
    p()

    # ── 1. por faixa ────────────────────────────────────────────────
    hoje_n = Counter(q['nivel_etario'] for q in linhas)
    novas_n = Counter(x['nivel'] for x in propostas)

    p('## 1. Por faixa etária')
    p()
    p('| Faixa | Hoje | Entrando | Depois |')
    p('|---|---:|---:|---:|')
    for n in (1, 2, 3):
        p(f'| **Nível {n}** — {FAIXA_NOME[n]} | {hoje_n[n]} | +{novas_n[n]} | **{hoje_n[n] + novas_n[n]}** |')
    p(f'| **Total** | **{len(linhas)}** | **+{len(propostas)}** | **{len(linhas) + len(propostas)}** |')
    p()

    # ── 2. por cenário ──────────────────────────────────────────────
    p('## 2. Por cenário')
    p()
    p('| Cenário | 7–10 | 11–14 | 15–18 | Total | hoje → depois |')
    p('|---|---:|---:|---:|---:|---|')

    depois_tot = Counter()
    linhas_tab = []
    for slug in todos:
        hoje = sum(atual[slug].values())
        dep = [atual[slug][n] + novas_por[slug][n] for n in (1, 2, 3)]
        soma = sum(dep)
        for n in (1, 2, 3):
            depois_tot[n] += dep[n - 1]
        linhas_tab.append((soma, slug, hoje, dep))

    for soma, slug, hoje, dep in sorted(linhas_tab, reverse=True):
        seta = f'{hoje} → **{soma}**' + ('  🆕' if hoje == 0 else '')
        p(f'| `{slug}` | {dep[0]} | {dep[1]} | {dep[2]} | **{soma}** | {seta} |')

    p(f'| **Total** | **{depois_tot[1]}** | **{depois_tot[2]}** | **{depois_tot[3]}** '
      f'| **{sum(depois_tot.values())}** | |')
    p()
    p('🆕 = cenário que hoje está vazio e passaria a ter conteúdo.')
    p()

    # ── 3. buracos que fecham ───────────────────────────────────────
    p('## 3. Onde o professor conseguiria montar quiz')
    p()
    p(f'Um quiz precisa de pelo menos **{QTD_MIN} questões** da faixa da turma.')
    p()
    p('| Faixa | Cenários hoje | Cenários depois |')
    p('|---|---:|---:|')
    for n in (1, 2, 3):
        agora = sum(1 for s in todos if atual[s][n] >= QTD_MIN)
        dps = sum(1 for s in todos if atual[s][n] + novas_por[s][n] >= QTD_MIN)
        p(f'| Nível {n} — {FAIXA_NOME[n]} | {agora} de {len(todos)} | **{dps} de {len(todos)}** |')
    p()

    # ── 4. como cada uma foi decidida ───────────────────────────────
    motivos = Counter(x['motivo'] for x in propostas)
    p('## 4. Como cada questão foi classificada')
    p()
    p('| Critério | Questões | O que é |')
    p('|---|---:|---|')
    p(f'| bloco temático | {motivos["bloco"]} | a posição no documento: as questões vêm '
      'em blocos contíguos por assunto, e o bloco inteiro vai para o mesmo lugar |')
    p(f'| assunto | {motivos["assunto"]} | cauda do nível 3, estilo ENEM, sem bloco: '
      'decidida por palavra-chave do enunciado |')
    p(f'| padrão | {motivos["padrão"]} | ciência geral sem gancho de lugar — vai para a escola |')
    p()

    # ── 5. o que continua faltando ──────────────────────────────────
    buracos = []
    for slug in todos:
        for n in (1, 2, 3):
            if atual[slug][n] + novas_por[slug][n] < QTD_MIN:
                buracos.append((slug, n, atual[slug][n] + novas_por[slug][n]))

    p('## 5. O que continuaria faltando')
    p()
    if not buracos:
        p('Nada: todo cenário teria conteúdo suficiente em todas as faixas.')
    else:
        p(f'Mesmo com as {len(propostas)} questões novas, '
          f'**{len(buracos)} combinações de cenário × faixa** ficariam abaixo das '
          f'{QTD_MIN} questões que um quiz precisa — ou seja, o professor daquela turma '
          'abre o ponto no mapa e não consegue montar tarefa.')
        p()
        p('| Cenário | Faixa | Teria |')
        p('|---|---|---:|')
        for slug, n, q in sorted(buracos, key=lambda x: (x[1], x[0])):
            p(f'| `{slug}` | {FAIXA_NOME[n]} | {q} |')
        p()

    magros = sorted((sum(atual[s].values()) + sum(novas_por[s].values()), s) for s in todos)[:2]
    p('Os dois cenários mais magros continuariam sendo '
      + ' e '.join(f'**`{s}`** ({q})' for q, s in magros)
      + ' — o documento quase não traz conteúdo de cuidado infantil e primeira infância.')
    p()

    return L


def listar(propostas, alvo):
    print(f'\n── {alvo} ──\n')
    for x in propostas:
        if x['cenario'] != alvo:
            continue
        print(f"  nv{x['nivel']} #{x['posicao']:<4} [{x['motivo']:<7}] {x['q']['enunciado'][:86]}")


if __name__ == '__main__':
    propostas, atual, slug_de, linhas = classificar()

    if '--listar' in sys.argv:
        listar(propostas, sys.argv[sys.argv.index('--listar') + 1])
        sys.exit()

    L = relatorio(propostas, atual, slug_de, linhas)
    for linha in L:
        print('  ' + linha.replace('**', '').replace('`', ''))

    if '--md' in sys.argv:
        destino = sys.argv[sys.argv.index('--md') + 1]
        with open(destino, 'w', encoding='utf-8') as f:
            f.write('\n'.join(L) + '\n')
        print(f'\n  gravado em {destino}')
