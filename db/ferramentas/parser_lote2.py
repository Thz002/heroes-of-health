# -*- coding: utf-8 -*-
"""Extrai os lotes com CABECALHO POR QUESTAO (2o formato recebido).

O parser.py entende o formato dos dois primeiros .docx. Estes dois vieram
diferentes, e por isso existe este arquivo:

Formatos diferentes dos dois primeiros lotes:

  MAIS Questoes 11 e 14 -> cabecalho ANTES de cada questao, no formato
                           "AREAS - LOCAL". Nivel 2 (vem do nome).
  qst de alimentacao    -> um cabecalho unico no topo (mercado, Alimentacao)
                           e SECOES de nivel dentro do arquivo
                           ("7 a 10 anos", "11 a 14 anos", "15 a 18 anos").

O que este arquivo sabe, e que nao esta escrito em lugar nenhum:
  - o verde muda a cada lote; ja apareceram 4EA72E, 47D459, 008000 e 70AD47
  - cabecalho se distingue de alternativa pela CAIXA ALTA: uma alternativa
    pode citar "saude" sem ser cabecalho
  - Verdadeiro/Falso vem como UMA linha com a resposta ("VERDADEIRO"),
    nao como alternativas -- vira questao de 2 opcoes, e o banco aceita
    porque opcao_c e opcao_d sao nulaveis

NAO gera SQL: escreve novos_extraidos.json, que precisa ser MESCLADO ao
questoes_extraidas.json antes de rodar o gerar_sql.py. A mesclagem tem uma
regra que nao pode ser esquecida: cada questao carrega um campo "codigo"
fixo, e ele NUNCA muda depois de gravado no banco -- e ele que impede o
import de sobrescrever uma pergunta com o texto de outra.
"""
import zipfile, re, sys, os, json, unicodedata
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')

DIR = os.path.join(os.path.expanduser('~'), 'OneDrive', 'Documentos', 'Questions')
VERDES = {'70AD47', '8DD873', '84E290', '47D459', '4EA72E', '008000', '00B050', '92D050'}

LUGARES = {
    'terreno baldio': 'terreno-baldio', 'baldio': 'terreno-baldio',
    'pracinha': 'praca', 'praca': 'praca',
    'escola': 'escola', 'casa': 'casa', 'ubs': 'ubs', 'upa': 'upa',
    'farmacia': 'farmacia', 'mercado': 'mercado', 'corrego': 'corrego',
    'quadra': 'quadra', 'creche': 'creche', 'parque': 'parque',
}
AREAS = {
    'saude': 'Saúde', 'educacao': 'Educação', 'vacinacao': 'Vacinação',
    'controle de vetores': 'Vetores', 'vetores': 'Vetores',
    'limpeza': 'Limpeza', 'alimentacao': 'Alimentação',
    'exercicios': 'Exercícios', 'felicidade': 'Felicidade',
}


def sem_acento(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s.lower())
                   if unicodedata.category(c) != 'Mn')


def paragrafos(caminho):
    xml = zipfile.ZipFile(caminho).read('word/document.xml').decode('utf-8')
    out = []
    for p in re.findall(r'<w:p[ >].*?</w:p>', xml, re.S):
        t = re.sub(r'<[^>]+>', '', p).strip()
        if not t:
            continue
        cores = {c.upper() for c in re.findall(r'<w:color w:val="([0-9A-Fa-f]{6})"', p)}
        out.append({'t': t, 'verde': bool(cores & VERDES)})
    return out


def acha_areas(txt):
    s = sem_acento(txt)
    out = []
    for chave in sorted(AREAS, key=len, reverse=True):
        if chave in s and AREAS[chave] not in out:
            out.append(AREAS[chave])
    return out


def acha_lugares(txt):
    s = sem_acento(txt)
    achados = []
    for tag in sorted(LUGARES, key=len, reverse=True):
        pos = s.find(tag)
        if pos >= 0 and LUGARES[tag] not in [LUGARES[t] for _, t in achados]:
            achados.append((pos, tag))
    return [LUGARES[t] for _, t in sorted(achados)]


def maiusculo(txt):
    """Fracao de letras em caixa alta — separa cabecalho de alternativa."""
    letras = [c for c in txt if c.isalpha()]
    if not letras:
        return 0
    return sum(1 for c in letras if c.isupper()) / len(letras)


RE_Q = re.compile(r'^(\d{1,3})\s*[.)\-–]\s*(.{10,})$')
RE_NIVEL = re.compile(r'(\d+)\s*a\s*(\d+)\s*anos', re.I)


def parsear(caminho, nivel_padrao):
    ps = paragrafos(caminho)
    questoes, atual = [], None
    areas_ctx, lugar_ctx, nivel_ctx = [], None, nivel_padrao

    for p in ps:
        t = p['t']

        # Secao de nivel dentro do arquivo ("7 a 10 anos")
        m = RE_NIVEL.search(t)
        if m and len(t) < 40 and not RE_Q.match(t):
            ini = int(m.group(1))
            nivel_ctx = 1 if ini <= 10 else (2 if ini <= 14 else 3)
            continue

        # Cabecalho: cita area, e esta em CAIXA ALTA (o que o separa de
        # uma alternativa que por acaso mencione "saude")
        a = acha_areas(t)
        if a and len(t) < 90 and not RE_Q.match(t) and (maiusculo(t) > 0.6 or 'PONTUA' in t.upper()):
            areas_ctx = a
            l = acha_lugares(t)
            if l:
                lugar_ctx = l[0]
            continue

        m = RE_Q.match(t)
        if m:
            if atual:
                questoes.append(atual)
            atual = {'num': int(m.group(1)), 'enunciado': m.group(2).strip(),
                     'alts': [], 'certa': None,
                     'lugares': [lugar_ctx] if lugar_ctx else [],
                     'areas': list(areas_ctx), 'nivel': nivel_ctx, 'vf': False}
            continue

        if not atual or len(atual['alts']) >= 4:
            continue

        alt = re.sub(r'^[A-Da-d]\s*[)\.]\s*', '', t).strip()
        if alt:
            atual['alts'].append(alt)
            if p['verde'] and atual['certa'] is None:
                atual['certa'] = len(atual['alts']) - 1

    if atual:
        questoes.append(atual)

    # Verdadeiro/Falso: a resposta vem como UMA linha ("VERDADEIRO" ou
    # "FALSO"), nao como quatro alternativas. Vira uma questao de duas
    # opcoes -- o banco aceita, e a tela ja pula opcao vazia.
    for q in questoes:
        if len(q['alts']) == 1 and q['alts'][0].strip().upper() in ('VERDADEIRO', 'FALSO'):
            certa = 0 if q['alts'][0].strip().upper() == 'VERDADEIRO' else 1
            q['alts'] = ['Verdadeiro', 'Falso']
            q['certa'] = certa
            q['vf'] = True

    return questoes


novos = []
for nome, nivel in [('MAIS Questões Jogos 11 e 14.docx', 2), ('qst de alimentação.docx', 1)]:
    qs = parsear(os.path.join(DIR, nome), nivel)
    ok = [q for q in qs if len(q['alts']) in (2, 4) and q['certa'] is not None
          and q['lugares'] and q['areas']]
    print('=' * 68)
    print(nome)
    print('=' * 68)
    print(f'  questoes encontradas ......... {len(qs)}')
    print(f'  PRONTAS ...................... {len(ok)}')
    print(f'  sem resposta em verde ........ {len([q for q in qs if q["certa"] is None])}')
    print(f'  fora de 2 ou 4 alternativas .. {len([q for q in qs if len(q["alts"]) not in (2, 4)])}')
    print(f'  verdadeiro/falso ............. {len([q for q in qs if q.get("vf")])}')
    print(f'  sem cenario .................. {len([q for q in qs if not q["lugares"]])}')
    print(f'  sem area ..................... {len([q for q in qs if not q["areas"]])}')
    print('  niveis  :', dict(Counter(q['nivel'] for q in qs)))
    print('  cenarios:', dict(Counter(q['lugares'][0] for q in qs if q['lugares'])))
    print('  areas   :', dict(Counter(a for q in qs for a in q['areas'])))
    print()
    novos += qs

json.dump(novos, open('novos_extraidos.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)
print(f'TOTAL novos: {len(novos)} | salvos em novos_extraidos.json')
