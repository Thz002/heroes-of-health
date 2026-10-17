# -*- coding: utf-8 -*-
"""
parser_unificado.py — lê "todas as questões.docx" da equipe de Medicina

É o documento ÚNICO que substituiu os quatro arquivos soltos de antes.
Traz as três faixas etárias num arquivo só e, o que é novo, traz DOIS
feedbacks por questão: um para quem acerta e um para quem erra.

TRÊS FORMATOS NO MESMO ARQUIVO
------------------------------
O documento foi montado por pessoas diferentes e cada faixa ficou com
uma convenção. Nenhuma está errada; o parser é que precisa aceitar as
três.

  nível 1   A) texto … D) texto      a certa em NEGRITO
            Resposta correta: Falso  (nas de Verdadeiro ou Falso)
            Se acertar: …  /  Se errar: …

  nível 2   alternativas como LISTA do Word, sem letra nenhuma
            Gabarito: D
            ✔ Se acertar: …  /  ✘ Se errar: …

  nível 3   mistura: as primeiras com letra, o resto como lista
            Gabarito: alternativa A      (cinco alternativas, estilo ENEM)
            SE ACERTAR …  /  SE ERRAR …

POR ISSO AS ALTERNATIVAS SÃO LIDAS POR POSIÇÃO, e não pela letra: a
primeira é A, a segunda é B, e assim por diante. Quando a letra vem
escrita, ela serve de conferência — e o relatório avisa se discordar da
posição.

A ordem de confiança para o gabarito é: a linha "Gabarito"/"Resposta
correta" primeiro, o negrito depois. A linha é explícita; o negrito é
formatação, e formatação se perde num copiar-e-colar.

Uso:
    python db/ferramentas/parser_unificado.py            # só o relatório
    python db/ferramentas/parser_unificado.py --json ARQ # grava o extrato
"""

import json
import os
import re
import sys
import zipfile
from collections import Counter

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

DOCX = r'C:\Users\duart\OneDrive\Documentos\Questions\todas as questões.docx'

LETRAS = 'ABCDE'

FAIXAS = [
    (re.compile(r'PERGUNTAS\s+7\s+A\s+10\s+ANOS', re.I), 1),
    (re.compile(r'PERGUNTAS\s+DE?\s*11\s+A\s+14\s+ANOS', re.I), 2),
    (re.compile(r'PERGUNTAS\s+15\s+A\s+18\s+ANOS', re.I), 3),
]

RE_QUESTAO  = re.compile(r'^(\d{1,3})\s*[.)]\s+(.+)$', re.S)
RE_LETRADA  = re.compile(r'^([A-E])\s*[)\.]\s*(.+)$', re.S)
RE_ACERTO   = re.compile(r'^[^\wÀ-ÿ]*SE\s+ACERTAR\s*[:\-–]?\s*(.*)$', re.I | re.S)
RE_ERRO     = re.compile(r'^[^\wÀ-ÿ]*SE\s+ERRAR\s*[:\-–]?\s*(.*)$', re.I | re.S)
RE_GABARITO = re.compile(r'^[^\wÀ-ÿ]*(?:Gabarito|Resposta\s+correta)\s*[:\-–]?\s*(.+)$', re.I | re.S)
RE_VF       = re.compile(r'verdadeiro\s+ou\s+falso', re.I)

# Gabarito grudado no fim da última alternativa.
RE_GAB_COLADO = re.compile(
    r'\s+(?:Gabarito|Resposta\s+correta)\s*[:\-–]?\s*'
    r'((?:alternativa\s+|letra\s+)?[A-E]|Verdadeiro|Falso)\s*\.?\s*$', re.I)


def abrir(caminho):
    """
    O .docx aberto no Word fica com bloqueio exclusivo e o zipfile não
    consegue lê-lo. Em vez de pedir para fechar o Word, copia para um
    temporário e lê a cópia — ler é o que este programa faz, e nada do
    que ele faz precisa do arquivo original.
    """
    try:
        return zipfile.ZipFile(caminho)
    except PermissionError:
        import shutil, tempfile
        copia = os.path.join(tempfile.gettempdir(), 'questoes-copia.docx')
        shutil.copyfile(caminho, copia)
        print(f'  (documento aberto no Word; lendo uma cópia)')
        return zipfile.ZipFile(copia)


def paragrafos(caminho):
    """(texto, todo_em_negrito, é_item_de_lista) na ordem do documento."""
    xml = abrir(caminho).read('word/document.xml').decode('utf-8')
    saida = []

    for p in re.findall(r'<w:p[ >].*?</w:p>', xml, re.S):
        trechos = []
        for r in re.findall(r'<w:r[ >].*?</w:r>', p, re.S):
            texto = ''.join(re.findall(r'<w:t[^>]*>(.*?)</w:t>', r, re.S))
            if not texto:
                continue
            props = re.search(r'<w:rPr>.*?</w:rPr>', r, re.S)
            negrito = bool(props and re.search(r'<w:b/>|<w:b\s', props.group(0)))
            trechos.append((texto, negrito))

        inteiro = desescapar(''.join(t for t, _ in trechos)).strip()
        if not inteiro:
            continue

        # Negrito só conta como gabarito se cobrir o texto inteiro.
        com_letra = [(t, b) for t, b in trechos if t.strip()]
        todo_negrito = bool(com_letra) and all(b for _, b in com_letra)

        saida.append((inteiro, todo_negrito, bool(re.search(r'<w:numPr>', p))))

    return saida


def desescapar(s):
    for de, para in [('&amp;', '&'), ('&lt;', '<'), ('&gt;', '>'),
                     ('&quot;', '"'), ('&apos;', "'")]:
        s = s.replace(de, para)
    return re.sub(r'\s+', ' ', s)


RE_SO_VF = re.compile(r'^\s*verdadeiro\s+ou\s+falso\s*\??\s*$', re.I)
RE_VF_COLADO = re.compile(r'^\s*verdadeiro\s+ou\s+falso\s*\?\s*((?:Gabarito|Resposta\s+correta).+)$', re.I)


def marcador_vf_logo_abaixo(linhas, i, alcance=3):
    """
    O "Verdadeiro ou falso?" costuma vir na linha seguinte ao enunciado,
    mas num bloco do nível 3 ele aparece DEPOIS dos feedbacks:

        A rotulagem nutricional frontal… tem como objetivo alertar…
        SE ACERTAR …
        SE ERRAR …
        Verdadeiro ou falso? Gabarito: Verdadeiro      <- só aqui

    Olhar só a linha de baixo perdia esse caso, e o enunciado virava
    alternativa da questão anterior. A janela para no primeiro item de
    lista ou enunciado numerado: se outro apareceu antes do marcador, o
    marcador é dele, não deste.
    """
    for j in range(i + 1, min(i + 1 + alcance, len(linhas))):
        texto, _, lista = linhas[j]
        if RE_SO_VF.match(texto):
            return True
        if lista or RE_QUESTAO.match(texto):
            return False
    return False


def marcar_sem_numero(linhas):
    """
    Nem toda questão do documento tem número.

    Em blocos inteiros do nível 2, o enunciado é só um item de lista em
    NEGRITO, e as alternativas são os itens de lista sem negrito logo
    abaixo:

        ✘ Se errar: …                              (fim da questão anterior)
        **Comer muito sódio não traz risco.**      (item de lista, NEGRITO)
        Verdadeiro ou falso?
        Gabarito: Falso
        ✔ Se acertar: …

    Sem tratar isso, o parser ingênuo pendurava esses enunciados como
    alternativas da questão anterior — foi o que produziu uma "questão"
    com vinte e uma alternativas.

    A REGRA, E POR QUE ELA PRECISA DO "DEPOIS DO FEEDBACK": negrito num
    item de lista quer dizer coisas diferentes em cada faixa. No nível 2
    marca o enunciado de uma questão nova; no nível 3 marca a
    alternativa CERTA, no meio das outras. O que separa os dois casos é
    a posição: a questão nova aparece logo após o feedback da anterior,
    quando nenhuma pergunta está aberta; a alternativa certa aparece no
    meio de um bloco de alternativas.
    """
    # Passo 1: separa "Verdadeiro ou falso? Gabarito: X" da mesma linha.
    partidas = []
    for texto, negrito, lista in linhas:
        m = RE_VF_COLADO.match(texto)
        if m:
            partidas.append(('Verdadeiro ou falso?', negrito, lista))
            partidas.append((m.group(1).strip(), negrito, False))
        else:
            partidas.append((texto, negrito, lista))

    # Passo 2: promove a enunciado os itens em negrito ou seguidos de "Verdadeiro ou falso?".
    saida = []
    fechada = True          # nenhuma questão aberta neste ponto

    for i, (texto, negrito, lista) in enumerate(partidas):
        if RE_SO_VF.match(texto):
            continue        # rótulo: o enunciado veio acima, o gabarito vem abaixo

        proxima_e_vf = marcador_vf_logo_abaixo(partidas, i)

        if lista and (proxima_e_vf or (negrito and fechada)):
            saida.append((f'0. {texto}', negrito, False))
            fechada = False
            continue

        if RE_QUESTAO.match(texto) and not lista:
            fechada = False
        elif RE_ACERTO.match(texto) or RE_ERRO.match(texto):
            fechada = True

        saida.append((texto, negrito, lista))

    return saida


RE_COLADA = re.compile(r'^(.{3,}?[a-zà-ÿ.)])\s*([B-E])\)\s+(\S.*)$')


def separar_colada(texto, posicao):
    """
    "InsulinaD) Bile" são DUAS alternativas que perderam a quebra de
    linha no documento. Separa só quando a letra embutida é exatamente a
    próxima da sequência — assim um "(ver item B) abaixo" no meio de um
    texto não vira alternativa.
    """
    m = RE_COLADA.match(texto)
    if not m:
        return [texto]

    esperada = LETRAS[posicao + 1] if posicao + 1 < len(LETRAS) else None
    if m.group(2) != esperada:
        return [texto]

    return [m.group(1).strip(), m.group(3).strip()]


def letra_do_gabarito(bruto, opcoes):
    """'alternativa C' -> 'C'. 'Verdadeiro' -> a opção que casar."""
    g = bruto.strip().rstrip('.').strip()

    m = re.match(r'^(?:alternativa\s+|letra\s+)?([A-E])\b', g, re.I)
    if m:
        return m.group(1).upper(), None

    # Verdadeiro ou Falso sem alternativas escritas: o parser cria as duas.
    if re.match(r'^(verdadeiro|falso)$', g, re.I):
        return ('A' if g[0].lower() == 'v' else 'B'), ['Verdadeiro', 'Falso']

    # O gabarito veio pelo TEXTO da alternativa.
    alvo = g.lower()
    for i, corpo in enumerate(opcoes):
        if corpo.rstrip('.').lower() == alvo:
            return LETRAS[i], None

    return None, None


def extrair(caminho=DOCX):
    questoes, atual, nivel = [], None, None

    def fechar():
        if atual and atual['enunciado'] and (atual['opcoes'] or atual['gabarito_bruto']):
            questoes.append(atual)

    for texto, negrito, lista in marcar_sem_numero(paragrafos(caminho)):
        faixa = next((n for rx, n in FAIXAS if rx.search(texto)), None)
        if faixa:
            fechar()
            atual, nivel = None, faixa
            continue

        if nivel is None:
            continue

        if atual:
            m = RE_ACERTO.match(texto)
            if m:
                atual['acerto'] = m.group(1).strip()
                atual['ultimo'] = 'acerto'
                continue

            m = RE_ERRO.match(texto)
            if m:
                atual['erro'] = m.group(1).strip()
                atual['ultimo'] = 'erro'
                continue

            m = RE_GABARITO.match(texto)
            if m:
                atual['gabarito_bruto'] = m.group(1).strip()
                continue

            # Gabarito grudado no fim da linha, sem parágrafo próprio.
            m = RE_GAB_COLADO.search(texto)
            if m:
                atual['gabarito_bruto'] = m.group(1).strip()
                texto = texto[:m.start()].rstrip()
                if not texto:
                    continue

        # Alternativa: item de lista ou linha com letra.
        if atual is not None:
            m = RE_LETRADA.match(texto)
            if lista or m:
                corpo = m.group(2).strip() if m else texto
                if m:
                    atual['letras_escritas'].append((len(atual['opcoes']), m.group(1)))

                # Uma linha pode trazer duas alternativas coladas.
                for pedaco in separar_colada(corpo, len(atual['opcoes'])):
                    atual['opcoes'].append(pedaco)
                    if negrito:
                        atual['negrito'].append(len(atual['opcoes']) - 1)
                continue

        m = RE_QUESTAO.match(texto)
        if m and not lista:
            fechar()
            atual = {
                'numero': int(m.group(1)), 'nivel': nivel,
                'enunciado': m.group(2).strip(),
                'opcoes': [], 'letras_escritas': [], 'negrito': [],
                'acerto': None, 'erro': None, 'gabarito_bruto': None,
                'ultimo': 'enunciado',
            }
            continue

        # Parágrafo solto continua o último campo aberto.
        if atual and len(texto) > 3:
            campo = atual['ultimo']
            if campo == 'enunciado' and atual['opcoes']:
                continue
            atual[campo] = ((atual[campo] or '') + ' ' + texto).strip()

    fechar()
    return resolver(questoes)


def resolver(questoes):
    """Decide a resposta de cada questão e junta os avisos."""
    avisos = []

    for q in questoes:
        q['vf'] = bool(RE_VF.search(q['enunciado']))
        q['resposta'] = None
        q['origem'] = None

        # 1. A linha explícita manda.
        if q['gabarito_bruto']:
            letra, criadas = letra_do_gabarito(q['gabarito_bruto'], q['opcoes'])
            if criadas:
                q['opcoes'] = criadas
            if letra:
                q['resposta'], q['origem'] = letra, 'gabarito'

        # 2. Senão, o negrito.
        if not q['resposta'] and len(q['negrito']) == 1:
            q['resposta'], q['origem'] = LETRAS[q['negrito'][0]], 'negrito'

        # Conferências
        if not q['resposta']:
            motivo = ('sem linha de gabarito e sem negrito' if not q['negrito']
                      else f'{len(q["negrito"])} alternativas em negrito')
            avisos.append(('SEM GABARITO', q, motivo))

        elif q['resposta'] not in LETRAS[:len(q['opcoes'])]:
            avisos.append(('GABARITO FORA', q,
                           f'aponta {q["resposta"]} mas há {len(q["opcoes"])} alternativas'))

        # A letra escrita bate com a posição?
        for pos, letra in q['letras_escritas']:
            if LETRAS[pos] != letra.upper():
                avisos.append(('LETRA TROCADA', q,
                               f'a {pos + 1}ª alternativa está escrita como {letra}'))
                break

        if q['resposta'] and q['origem'] == 'gabarito' and len(q['negrito']) == 1:
            if LETRAS[q['negrito'][0]] != q['resposta']:
                avisos.append(('NEGRITO DISCORDA', q,
                               f'linha diz {q["resposta"]}, negrito diz {LETRAS[q["negrito"][0]]}'))

        if not q['acerto'] or not q['erro']:
            falta = [n for n, v in (('acerto', q['acerto']), ('erro', q['erro'])) if not v]
            avisos.append(('SEM FEEDBACK', q, 'falta ' + ' e '.join(falta)))

        if len(q['opcoes']) < 2:
            avisos.append(('POUCAS OPÇÕES', q, f'{len(q["opcoes"])} alternativas'))

    return questoes, avisos


def relatorio(questoes, avisos):
    nomes = {1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos'}
    por_nivel = Counter(q['nivel'] for q in questoes)

    print('\n╔══ O DOCUMENTO DA EQUIPE DE MEDICINA ════════════════════╗\n')
    for n in (1, 2, 3):
        print(f'  Nível {n} ({nomes[n]:<13}): {por_nivel[n]:4d} questões')
    print(f'  {"TOTAL":<28}: {len(questoes):4d}')

    ok = sum(1 for q in questoes if q['resposta'])
    print(f'\n  gabarito resolvido       : {ok:4d}  '
          f'(linha: {sum(1 for q in questoes if q["origem"] == "gabarito")}, '
          f'negrito: {sum(1 for q in questoes if q["origem"] == "negrito")})')
    print(f'  com feedback de ACERTO   : {sum(1 for q in questoes if q["acerto"]):4d}')
    print(f'  com feedback de ERRO     : {sum(1 for q in questoes if q["erro"]):4d}')
    print(f'  Verdadeiro ou Falso      : {sum(1 for q in questoes if q["vf"]):4d}')

    quantas = Counter(len(q['opcoes']) for q in questoes)
    print('\n  alternativas por questão :',
          ', '.join(f'{k}: {v}' for k, v in sorted(quantas.items())))

    tipos = Counter(t for t, _, _ in avisos)
    if tipos:
        print('\n╔══ O QUE PRECISA DE OLHO ════════════════════════════════╗\n')
        for tipo, quantos in tipos.most_common():
            print(f'  {tipo:<18} {quantos:4d}')
            for t, q, motivo in [a for a in avisos if a[0] == tipo][:6]:
                print(f'       nv{q["nivel"]} q{q["numero"]:<4} {motivo:<42} {q["enunciado"][:44]}…')
            if quantos > 6:
                print(f'       … e mais {quantos - 6}')


if __name__ == '__main__':
    questoes, avisos = extrair()
    relatorio(questoes, avisos)

    if '--json' in sys.argv:
        destino = sys.argv[sys.argv.index('--json') + 1]
        with open(destino, 'w', encoding='utf-8') as f:
            json.dump(questoes, f, ensure_ascii=False, indent=1)
        print(f'\n  extrato gravado em {destino}')
