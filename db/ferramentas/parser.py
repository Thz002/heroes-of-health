# -*- coding: utf-8 -*-
"""Le os .docx de perguntas da equipe de Medicina e extrai a estrutura.

Passo 1 de 2. Escreve questoes_extraidas.json aqui do lado; quem
transforma isso em SQL e o gerar_sql.py.

O que este arquivo sabe, e que nao esta escrito em lugar nenhum:
  - a resposta certa esta marcada pela COR VERDE do texto
  - cada .docx usa um verde diferente (4EA72E/47D459 num, 008000 no outro)
  - a linha do cenario vem DEPOIS da quarta alternativa (antes disso,
    uma alternativa que cite um lugar seria confundida com ela)
  - no arquivo 11-14 o cenario vem do cabecalho do bloco; no 7-10, por
    pergunta
  - a bibliografia ABNT no fim do arquivo tem de ser descartada

Uso:  python parser.py ["C:/pasta/com/os/docx"]
"""
import zipfile, re, sys, os, glob, json, unicodedata
sys.stdout.reconfigure(encoding='utf-8')

VERDES = {'4EA72E', '47D459', '008000', '00B050', '92D050', '70AD47'}

# tag no arquivo -> slug no banco
LUGARES = {
    'terreno baldio': 'terreno-baldio', 'baldio': 'terreno-baldio',
    'pracinha': 'praca', 'praca': 'praca',
    'escola': 'escola', 'casa': 'casa', 'ubs': 'ubs', 'upa': 'upa',
    'farmacia': 'farmacia', 'mercado': 'mercado', 'corrego': 'corrego',
    'quadra': 'quadra', 'creche': 'creche', 'parque': 'parque',
}
# palavra no arquivo -> nome exato da area no banco
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
        out.append({'t': t, 'verde': bool(cores & VERDES), 'neg': '<w:b/>' in p})
    return out

def achar_lugares(txt):
    """Devolve os slugs citados, na ordem em que aparecem no texto."""
    s = sem_acento(txt)
    achados = []
    for tag in sorted(LUGARES, key=len, reverse=True):
        pos = s.find(tag)
        if pos >= 0 and not any(tag in outro for _, outro in achados):
            achados.append((pos, tag))
    return [LUGARES[t] for _, t in sorted(achados)]

def achar_areas(txt):
    s = sem_acento(txt)
    out = []
    for chave in sorted(AREAS, key=len, reverse=True):
        if chave in s and AREAS[chave] not in out:
            if any(chave in c and c != chave for c in AREAS if c in s):
                continue
            out.append(AREAS[chave])
    return out

RE_Q = re.compile(r'^(\d{1,3})\s*[-–.)]\s*(.{10,})$')

def parsear(caminho, nivel):
    ps = paragrafos(caminho)
    questoes, atual = [], None
    areas_tema, lugar_tema = [], None

    for p in ps:
        t = p['t']
        eh_cabecalho = 'PONTUA' in t.upper() or ('PONT ' in t.upper() and len(t) < 90)

        if eh_cabecalho and len(t) < 200:
            a = achar_areas(t)
            if a:
                areas_tema = a
            l = achar_lugares(t)
            if l:
                lugar_tema = l[0]
            if atual:                      # ajuste tipo "PONT EM VACINACAO TBM!"
                atual['areas'] = sorted(set(atual['areas']) | set(a))
                if l and not atual['lugares']:
                    atual['lugares'] = l
            continue

        m = RE_Q.match(t)
        if m:
            if atual:
                questoes.append(atual)
            atual = {'num': int(m.group(1)), 'enunciado': m.group(2).strip(),
                     'alts': [], 'certa': None,
                     'lugares': [lugar_tema] if lugar_tema else [],
                     'areas': list(areas_tema), 'nivel': nivel,
                     'vf': bool(re.search(r'verdadeiro ou falso', t, re.I))}
            continue

        if not atual:
            continue

        lug = achar_lugares(t)
        curto = len(t) <= 55
        # linha de cenario: curta, cita lugar, e nao parece alternativa
        if lug and curto and not re.match(r'^[A-Da-d]\s*[\)\.]', t) and len(atual['alts']) >= 4:
            atual['lugares'] = lug
            continue

        if len(atual['alts']) >= 4:
            continue
        # linha de bibliografia: citacao ABNT costuma vir sem espacos
        if len(t) > 60 and t.count(' ') < len(t) / 25:
            continue
        alt = re.sub(r'^[A-Da-d]\s*[\)\.]\s*', '', t).strip()
        if alt:
            atual['alts'].append(alt)
            if p['verde'] and atual['certa'] is None:
                atual['certa'] = len(atual['alts']) - 1

    if atual:
        questoes.append(atual)
    return questoes

# Pasta dos .docx. Passe outra por argumento se mudarem de lugar.
PADRAO = os.path.join(os.path.expanduser('~'), 'OneDrive', 'Documentos', 'Questions')
d = sys.argv[1] if len(sys.argv) > 1 else PADRAO
AQUI = os.path.dirname(os.path.abspath(__file__))
arqs = sorted(glob.glob(os.path.join(d, '*.docx')))
if not arqs:
    raise SystemExit('Nenhum .docx encontrado em: %s' % d)
todas = []
for caminho, nivel in [(arqs[0], 2), (arqs[1], 1)]:
    qs = parsear(caminho, nivel)
    nome = os.path.basename(caminho)
    ok = [q for q in qs if len(q['alts']) == 4 and q['certa'] is not None and q['lugares'] and q['areas']]
    print('=' * 68)
    print(f'{nome}  (nivel {nivel})')
    print('=' * 68)
    print(f'  questoes encontradas .............. {len(qs)}')
    print(f'  PRONTAS (4 alts + certa + cenario + area) ... {len(ok)}')
    print(f'  sem resposta marcada em verde ..... {len([q for q in qs if q["certa"] is None])}')
    print(f'  sem 4 alternativas ................ {len([q for q in qs if len(q["alts"]) != 4])}')
    print(f'  sem cenario ....................... {len([q for q in qs if not q["lugares"]])}')
    print(f'  sem area .......................... {len([q for q in qs if not q["areas"]])}')
    from collections import Counter
    print('  cenarios:', dict(Counter(q['lugares'][0] for q in qs if q['lugares']).most_common()))
    print('  areas   :', dict(Counter(a for q in qs for a in q['areas']).most_common()))
    todas += qs

print()
print('=' * 68)
print(f'TOTAL: {len(todas)} questoes | PRONTAS: '
      f'{len([q for q in todas if len(q["alts"]) == 4 and q["certa"] is not None and q["lugares"] and q["areas"]])}')
print('=' * 68)
json.dump(todas, open(os.path.join(AQUI, 'questoes_extraidas.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('salvo em questoes_extraidas.json')
