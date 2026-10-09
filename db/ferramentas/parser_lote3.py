# -*- coding: utf-8 -*-
"""Extrai o TERCEIRO lote de perguntas (outubro/2026).

Tres .docx, tres formatos diferentes -- nenhum dos parsers anteriores
entende estes:

  Perguntas Jogo 7 a 10 ...  -> nivel 1. Cenario em titulo de secao
                                (UBS, UPA, Farmacia). Resposta em VERDE.
                                Verdadeiro/Falso vem como UMA frase solta,
                                pintada de verde (verdadeira) ou vermelho
                                (falsa), sem alternativas.
  11-14.docx                 -> nivel 2. Cenario em "CENARIO X -- NOME".
                                Resposta em NEGRITO (o enunciado tambem e
                                negrito; a alternativa certa e a unica
                                outra linha em negrito). Duas alternativas
                                as vezes dividem o mesmo paragrafo.
  Questoes N3 prontas.docx   -> nivel 3. Secoes em CAIXA ALTA ("UBS -
                                SAUDE"), blocos separados por "———",
                                resposta em VERDE, e CINCO alternativas
                                (A a E) na maioria das questoes.

NAO gera SQL e NAO decide cenario nem area: so le. Escreve
lote3_bruto.json, com a secao de onde cada questao veio, para o passo
seguinte (montar_lote3.py) decidir.
"""
import zipfile, re, sys, os, json
from xml.etree import ElementTree as ET
sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))
DIR = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
    os.path.expanduser('~'), 'Documents', 'new quest')

W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
VERDES = {'70AD47', '8DD873', '84E290', '47D459', '4EA72E', '008000', '00B050', '92D050'}
VERMELHOS = {'FF0000', 'C00000', 'EE0000'}


def paragrafos(caminho):
    """Cada paragrafo como lista de letras, cada letra com seus atributos.

    Letra a letra, e nao run a run, porque o Word quebra os runs onde
    quer: "E" num run e ") Zika" no seguinte, ou duas alternativas
    inteiras dentro de um mesmo run. Com a marcacao por letra, cortar o
    paragrafo em qualquer ponto preserva o negrito e a cor de cada lado.
    """
    xml = zipfile.ZipFile(caminho).read('word/document.xml').decode('utf-8')
    # Figuras e caixas de texto carregam paragrafos proprios (e, no
    # AlternateContent, em dobro). Nenhuma questao mora nelas.
    xml = re.sub(r'<mc:AlternateContent>.*?</mc:AlternateContent>', '', xml, flags=re.S)
    xml = re.sub(r'<w:drawing>.*?</w:drawing>', '', xml, flags=re.S)
    xml = re.sub(r'<w:pict>.*?</w:pict>', '', xml, flags=re.S)
    corpo = ET.fromstring(xml).find(W + 'body')

    for p in corpo.iter(W + 'p'):
        letras = []
        for r in p.iter(W + 'r'):
            rpr = r.find(W + 'rPr')
            negrito, cor = False, ''
            if rpr is not None:
                b = rpr.find(W + 'b')
                negrito = b is not None and b.get(W + 'val') not in ('0', 'false')
                c = rpr.find(W + 'color')
                cor = (c.get(W + 'val') or '').upper() if c is not None else ''
            for el in r:
                if el.tag == W + 't':
                    letras += [(ch, negrito, cor) for ch in (el.text or '')]
                elif el.tag in (W + 'tab', W + 'br', W + 'cr'):
                    letras.append((' ', negrito, cor))
        lista = p.find(f'{W}pPr/{W}numPr') is not None
        yield letras, lista


def texto(letras):
    return ''.join(c for c, _, _ in letras).strip()


def marcas(letras):
    visiveis = [(b, cor) for c, b, cor in letras if not c.isspace()]
    return {'negrito': any(b for b, _ in visiveis),
            'verde': any(cor in VERDES for _, cor in visiveis),
            'vermelho': any(cor in VERMELHOS for _, cor in visiveis)}


# "A) ", "B ) ", e tambem quando a letra veio grudada no fim da frase
# anterior: "...tratar doencas.D) Nao, porque..."
RE_ALT_INICIO = re.compile(r'^\s*([A-Ea-e])\s*\)\s*')
RE_ALT_MEIO = re.compile(r'(?<=[.!?;:”"\s])[B-E]\s?\)\s')


def cortar_alternativas(letras):
    """Um paragrafo com duas alternativas vira dois pedacos."""
    t = ''.join(c for c, _, _ in letras)
    cortes = [m.start() for m in RE_ALT_MEIO.finditer(t) if len(t[:m.start()].strip()) >= 3]
    pedacos, ini = [], 0
    for c in cortes:
        pedacos.append(letras[ini:c])
        ini = c
    pedacos.append(letras[ini:])
    return [p for p in pedacos if texto(p)]


def sem_letra(t):
    return RE_ALT_INICIO.sub('', t).strip()


# ── 7 a 10 anos ────────────────────────────────────────────────────────
SECOES_N1 = {'unidade básica de saúde': 'UBS',
             'unidade de pronto atendimento (upa)': 'UPA',
             'farmácia': 'FARMACIA'}
RE_Q_N1 = re.compile(r'^(\d{1,2})\s*[-.–]\s*(.+)$')


def ler_n1(caminho):
    out, atual, secao, refs = [], None, None, False
    for letras, lista in paragrafos(caminho):
        t = texto(letras)
        if not t:
            continue
        if t.lower() in SECOES_N1:
            secao, refs, atual = SECOES_N1[t.lower()], False, None
            continue
        if t.startswith('Referência'):
            refs, atual = True, None
            continue
        if refs or not secao:
            continue

        m = RE_Q_N1.match(t)
        if m:
            atual = {'nivel': 1, 'secao': secao, 'num': int(m.group(1)),
                     'enunciado': m.group(2).strip(), 'alts': [], 'certa': None,
                     'marcas': marcas(letras)}
            out.append(atual)
            continue
        if not atual:
            continue

        if RE_ALT_INICIO.match(t) or lista:
            atual['alts'].append(sem_letra(t))
            if marcas(letras)['verde'] and atual['certa'] is None:
                atual['certa'] = len(atual['alts']) - 1
        elif not atual['alts']:
            # Caso em mais de uma linha (UPA 8: Joao..., Maria..., Qual...?)
            atual['enunciado'] += ' ' + t

    # Verdadeiro/Falso: a frase sem alternativa, e a cor e a resposta.
    for q in out:
        if not q['alts']:
            q['vf'] = True
            q['alts'] = ['Verdadeiro', 'Falso']
            q['certa'] = 0 if q['marcas']['verde'] else (1 if q['marcas']['vermelho'] else None)
        else:
            q['vf'] = False
        del q['marcas']
    return out


# ── 11 a 14 anos ───────────────────────────────────────────────────────
RE_Q_N2 = re.compile(r'^(\d{1,2})\.\s+(.+)$')


def ler_n2(caminho):
    out, atual, secao = [], None, None
    for letras, _ in paragrafos(caminho):
        t = texto(letras)
        if not t:
            continue
        if 'CENÁRIO' in t:          # maiusculo: "o cenário relaciona..." nao e titulo
            secao, atual = t, None
            continue
        if t.startswith('Referências'):
            break
        m = RE_Q_N2.match(t)
        if m and marcas(letras)['negrito']:
            atual = {'nivel': 2, 'secao': secao, 'num': int(m.group(1)),
                     'enunciado': m.group(2).strip(), 'alts': [], 'certa': None, 'vf': False}
            out.append(atual)
            continue
        if not atual:
            continue        # a linha de descricao logo abaixo do titulo
        for pedaco in cortar_alternativas(letras):
            atual['alts'].append(sem_letra(texto(pedaco)))
            if marcas(pedaco)['negrito']:
                atual['certa'] = len(atual['alts']) - 1 if atual['certa'] is None else 'DUAS'
    return out


# ── 15 a 18 anos ───────────────────────────────────────────────────────
def caixa_alta(t):
    letras = [c for c in t if c.isalpha()]
    return letras and sum(c.isupper() for c in letras) / len(letras) > 0.8


def ler_n3(caminho):
    out, atual, secao, comecou = [], None, None, False
    for letras, _ in paragrafos(caminho):
        t = texto(letras)
        if not t:
            continue
        if t.startswith('Referências'):
            break
        if set(t) <= set('—–-_ '):
            # O separador: o bloco que vem depois NAO tem cabecalho.
            secao, atual = 'SEM CABECALHO', None
            continue
        if caixa_alta(t) and not RE_ALT_INICIO.match(t) and len(t) < 100:
            secao, atual, comecou = t, None, True
            continue
        if not comecou:
            continue        # o titulo e as instrucoes do topo
        if RE_ALT_INICIO.match(t):
            if atual is None:
                continue
            atual['alts'].append(sem_letra(t))
            if marcas(letras)['verde']:
                atual['certa'] = len(atual['alts']) - 1 if atual['certa'] is None else 'DUAS'
        elif atual is None or atual['alts']:
            atual = {'nivel': 3, 'secao': secao, 'num': None, 'enunciado': t,
                     'alts': [], 'certa': None, 'vf': False}
            out.append(atual)
        else:
            atual['enunciado'] += ' ' + t
    for i, q in enumerate(out, 1):
        q['num'] = i
    return out


if __name__ == '__main__':
    arquivos = sorted(os.listdir(DIR))
    def achar(trecho):
        return os.path.join(DIR, next(a for a in arquivos if trecho.lower() in a.lower()))

    todas = (ler_n1(achar('7 a 10')) + ler_n2(achar('11-14')) + ler_n3(achar('N3')))
    json.dump(todas, open(os.path.join(AQUI, 'lote3_bruto.json'), 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)

    from collections import Counter
    print('questoes:', len(todas))
    print('por nivel:', dict(Counter(q['nivel'] for q in todas)))
    print('alternativas:', dict(Counter((q['nivel'], len(q['alts'])) for q in todas)))
    print('sem resposta:', [(q['nivel'], q['secao'], q['num']) for q in todas if q['certa'] is None])
    print('duas marcadas:', [(q['nivel'], q['secao'], q['num']) for q in todas if q['certa'] == 'DUAS'])
    print('por secao:')
    for (n, s), c in Counter((q['nivel'], q['secao']) for q in todas).items():
        print('  n%d %-70s %d' % (n, s, c))
