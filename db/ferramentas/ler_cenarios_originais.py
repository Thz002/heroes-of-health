# -*- coding: utf-8 -*-
"""
ler_cenarios_originais.py — recupera o cenário e a pontuação dos
arquivos que a equipe de Medicina mandou aos poucos

CONTEXTO
--------
O arquivo "todas as questões.docx" foi montado só para acrescentar os
feedbacks de acerto e erro. Ele não tem cenário nenhum. Mas as questões
já tinham chegado antes, em arquivos menores, e NESSES o cenário está
escrito — junto com as áreas que cada questão pontua.

ONDE A MARCA FICA
-----------------
Numa linha curta e solta, logo DEPOIS das alternativas:

    TEMA 1 — ISTs, … – PONTUAÇÃO EM SAÚDE, EDUCAÇÃO     <- bloco
    1. O que significa a sigla "IST"?
    A) …
    D) Infecção Sexualmente Transmissível
    UBS                                                  <- cenário desta questão
    2. Qual é o único método que protege …
    …
    UBS + PONT EM VACINACAO                              <- cenário + área extra

Ou seja: a marca vem depois, não antes. E às vezes nomeia mais de um
lugar ("PARQUE E PRACINHA") ou exclui um ("Sem casa e ESCOLA+ UBS").
Quando há mais de um, o primeiro vale como principal e o resto fica
registrado — a tabela `questoes` só tem lugar para um.

Uso:
    python db/ferramentas/ler_cenarios_originais.py
    python db/ferramentas/ler_cenarios_originais.py --json ARQ
"""

import glob
import json
import os
import re
import shutil
import sys
import tempfile
import unicodedata
import zipfile
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

PASTA = r'C:\Users\duart\OneDrive\Documentos\Questions'
CONSOLIDADO = 'todas as questões.docx'

# Como cada lugar é escrito nos arquivos, e o slug dele no banco.
# A ordem importa: "campo de lazer" antes de "campo", "terreno baldio"
# antes de "terreno".
LUGARES = [
    (r'terreno\s*-?\s*baldio', 'terreno-baldio'),
    (r'campo\s+de\s+lazer',    'quadra'),
    (r'\bpracinha\b',          'praca'),
    (r'\bpra[cç]a\b',          'praca'),
    (r'\bc[oó]rrego\b',        'corrego'),
    (r'\bfarm[aá]cia\b',       'farmacia'),
    (r'\bmercado\b',           'mercado'),
    (r'\bescola\b',            'escola'),
    (r'\bparque\b',            'parque'),
    (r'\bcreche\b',            'creche'),
    (r'\bquadra\b',            'quadra'),
    (r'\bcasa\b',              'casa'),
    (r'\bubs\b',               'ubs'),
    (r'\bupa\b',               'upa'),
    (r'unidade\s+b[aá]sica',   'ubs'),
    (r'pronto\s+atendimento',  'upa'),
]

AREAS = [
    (r'sa[uú]de',      'Saúde'),
    (r'educa[cç][aã]o', 'Educação'),
    (r'vacina[cç][aã]o|vacinacao', 'Vacinação'),
    (r'vetor(?:es)?',  'Vetores'),
    (r'limpeza',       'Limpeza'),
    (r'alimenta[cç][aã]o', 'Alimentação'),
    (r'exerc[ií]cios?', 'Exercícios'),
    (r'felicidade',    'Felicidade'),
]

RE_OPCAO = re.compile(r'^\(?([A-E])\s*[)\.\-]\s*\S')
RE_QUESTAO = re.compile(r'^(\d{1,3})\s*[-.)]\s+(\S.+)$')
RE_REF = re.compile(r'\b(ed\.|S[aã]o Paulo|Rio de Janeiro|Porto Alegre|Bras[ií]lia|'
                    r'Dispon[ií]vel em|Acesso em|BNCC)\b', re.I)


def sem_acento(s):
    t = unicodedata.normalize('NFD', (s or '').lower())
    return ''.join(c for c in t if unicodedata.category(c) != 'Mn')


def paragrafos(caminho):
    try:
        z = zipfile.ZipFile(caminho)
    except PermissionError:
        copia = os.path.join(tempfile.gettempdir(), 'c_' + os.path.basename(caminho))
        shutil.copyfile(caminho, copia)
        z = zipfile.ZipFile(copia)

    xml = z.read('word/document.xml').decode('utf-8')
    saida = []

    for p in re.findall(r'<w:p[ >].*?</w:p>', xml, re.S):
        texto = ''.join(re.findall(r'<w:t[^>]*>(.*?)</w:t>', p, re.S))
        for de, para in [('&amp;', '&'), ('&lt;', '<'), ('&gt;', '>'),
                         ('&quot;', '"'), ('&apos;', "'")]:
            texto = texto.replace(de, para)
        texto = re.sub(r'<[^>]+>', ' ', texto)      # tags soltas dentro do texto
        texto = re.sub(r'\s+', ' ', texto).strip()
        if texto:
            saida.append(texto)

    return saida


def lugares_em(texto):
    """Os cenários nomeados numa linha, na ordem em que aparecem.

    'Sem casa e ESCOLA+ UBS' exclui a casa: a palavra 'sem' antes de um
    lugar vira exclusão, não escolha."""
    t = sem_acento(texto)
    achados, excluidos = [], set()

    for padrao, slug in LUGARES:
        for m in re.finditer(padrao, t):
            antes = t[max(0, m.start() - 12):m.start()]
            if re.search(r'\bsem\s*$', antes):
                excluidos.add(slug)
            else:
                achados.append((m.start(), slug))

    achados.sort()
    vistos, ordem = set(), []
    for _, slug in achados:
        if slug not in vistos and slug not in excluidos:
            vistos.add(slug)
            ordem.append(slug)
    return ordem


def areas_em(texto):
    t = sem_acento(texto)
    return [nome for padrao, nome in AREAS if re.search(padrao, t)]


def eh_marcador(texto):
    """Linha curta que só nomeia lugares (e talvez pontuação)."""
    if len(texto) > 90 or RE_OPCAO.match(texto) or RE_QUESTAO.match(texto):
        return False
    if RE_REF.search(texto):
        return False
    lugares = lugares_em(texto)
    if not lugares:
        return False

    # Sobrou muito texto além dos nomes de lugar e das palavras de
    # pontuação? Então é frase, não marcador.
    resto = sem_acento(texto)
    for padrao, _ in LUGARES:
        resto = re.sub(padrao, ' ', resto)
    for padrao, _ in AREAS:
        resto = re.sub(padrao, ' ', resto)
    resto = re.sub(r'[^a-z]+|pont\w*|tema|\d+|sem|adicionar|em|e|no|na|de|do|da|questoes?|'
                   r'controle|so|esse|apenas', ' ', resto)
    return len(resto.strip()) <= 12


def classificar_linhas(linhas):
    """Cada parágrafo vira ('cabecalho'|'marca'|'questao'|'texto', conteúdo)."""
    fora = []
    for texto in linhas:
        t = sem_acento(texto)

        # Cabeçalho de bloco. O "CENÁRIO <n> —" com travessão é o que
        # separa um cabeçalho de verdade de uma questão que por acaso
        # fala a palavra:
        #
        #   ⚽ CENÁRIO 8 — CAMPO DE LAZER – felicidade   <- cabeçalho
        #   15. Qual princípio resume melhor o cenário Farmácia?  <- questão
        #   O cenário Rio conecta preservação ambiental…          <- descrição
        #
        # Vários cabeçalhos começam com emoji e NÃO trazem a palavra
        # "pontuação" ("🏥 CENÁRIO 12 — UBS – mesma de 7-10"). Exigir
        # "pontuação" fazia o bloco anterior vazar para o seguinte: as
        # questões de atividade física herdavam o córrego.
        if (re.search(r'\bcenario\b\s*\d*\s*[—–:-]|pontua|^tema\b', t)
                and (lugares_em(texto) or areas_em(texto))):
            fora.append(('cabecalho', texto))
            continue

        if eh_marcador(texto):
            fora.append(('marca', texto))
            continue

        m = RE_QUESTAO.match(texto)
        if m:
            fora.append(('questao', m.group(2).strip()))
            continue

        fora.append(('texto', texto))
    return fora


def convencao(tokens):
    """
    Os arquivos discordam sobre ONDE o nome do cenário fica.

      MAIS Questões Jogos 11 e 14      a marca vem ANTES da questão
      Cópia de Perguntas 7 a 10 anos   a marca vem DEPOIS das alternativas

    As duas são legítimas e nenhuma está escrita em lugar nenhum. O que
    desempata é a primeira ocorrência: se a primeira marca do arquivo
    aparece antes da primeira questão, o arquivo é do tipo "antes".
    """
    for tipo, _ in tokens:
        if tipo == 'marca':
            return 'antes'
        if tipo == 'questao':
            return 'depois'
    return 'depois'


def ler_arquivo(caminho):
    """[{enunciado, cenarios, areas, arquivo}] de um .docx."""
    nome = os.path.basename(caminho)
    tokens = classificar_linhas(paragrafos(caminho))
    marca_antes = convencao(tokens) == 'antes'

    questoes = []
    atual = None
    padrao_lugares, padrao_areas = [], []
    pendente = None          # marca lida esperando a próxima questão

    def fechar():
        # Duas alternativas é o mínimo: menos que isso é parágrafo solto
        # que só pareceu enunciado.
        if atual and atual['enunciado'] and atual['opcoes'] >= 2:
            questoes.append(atual)

    def abrir(enunciado):
        lugares = (pendente or {}).get('cenarios') or padrao_lugares
        areas = sorted(set(padrao_areas) | set((pendente or {}).get('areas') or []))
        return {'enunciado': enunciado, 'opcoes': 0,
                'cenarios': list(lugares), 'areas': areas, 'arquivo': nome}

    for tipo, texto in tokens:
        if tipo == 'cabecalho':
            fechar()
            atual, pendente = None, None
            if lugares_em(texto):
                padrao_lugares = lugares_em(texto)
            padrao_areas = areas_em(texto) or padrao_areas
            continue

        if tipo == 'marca':
            if marca_antes:
                pendente = {'cenarios': lugares_em(texto), 'areas': areas_em(texto)}
                # A marca também vira o padrão do trecho: em
                # "Perguntas Jogo 7 a 10 ubs, upa e farmacia" um único
                # "Unidade Básica de Saúde" abre uma seção inteira, e não
                # só a questão seguinte.
                padrao_lugares = pendente['cenarios'] or padrao_lugares
            elif atual:
                atual['cenarios'] = lugares_em(texto)
                atual['areas'] = sorted(set(atual['areas']) | set(areas_em(texto)))
            else:
                padrao_lugares = lugares_em(texto)
            continue

        if tipo == 'questao':
            fechar()
            atual = abrir(texto)
            pendente = None
            continue

        # 'texto': alternativa da questão aberta, ou enunciado sem número.
        #
        # Boa parte dos arquivos escreve as alternativas SEM letra, como
        # linhas soltas — e em "Questões N3 prontas" as QUESTÕES é que
        # não têm número. Com as duas coisas juntas não há marca
        # tipográfica para separar uma da outra.
        #
        # O que separa é a CONTAGEM: nenhuma questão do material passa de
        # cinco alternativas. Então, a partir da quinta linha solta, a
        # próxima é enunciado novo.
        if atual is not None and (RE_OPCAO.match(texto) or atual['opcoes'] < 4):
            atual['opcoes'] += 1
            continue

        if len(texto) > 25 and not RE_REF.search(texto):
            fechar()
            atual = abrir(texto)
            pendente = None

    fechar()
    return questoes


def ler_todos():
    tudo = []
    for caminho in sorted(glob.glob(os.path.join(PASTA, '*.docx'))):
        if os.path.basename(caminho) == CONSOLIDADO:
            continue
        tudo.extend(ler_arquivo(caminho))
    return tudo


if __name__ == '__main__':
    questoes = ler_todos()

    print('\n╔══ OS ARQUIVOS INDIVIDUAIS ══════════════════════════════╗\n')
    por_arquivo = Counter(q['arquivo'] for q in questoes)
    com_cen = Counter(q['arquivo'] for q in questoes if q['cenarios'])

    for nome, quantas in sorted(por_arquivo.items()):
        print(f'  {nome[:48]:<50} {quantas:4d} questões, {com_cen[nome]:4d} com cenário')
    print(f'  {"TOTAL":<50} {len(questoes):4d} questões, '
          f'{sum(com_cen.values()):4d} com cenário')

    print('\n  cenários encontrados:')
    for slug, n in Counter(q['cenarios'][0] for q in questoes if q['cenarios']).most_common():
        print(f'      {slug:<16} {n:4d}')

    print('\n  áreas de pontuação citadas:')
    for a, n in Counter(a for q in questoes for a in q['areas']).most_common():
        print(f'      {a:<16} {n:4d}')

    if '--json' in sys.argv:
        destino = sys.argv[sys.argv.index('--json') + 1]
        with open(destino, 'w', encoding='utf-8') as f:
            json.dump(questoes, f, ensure_ascii=False, indent=1)
        print(f'\n  gravado em {destino}')
