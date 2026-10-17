# -*- coding: utf-8 -*-
"""
estatisticas.py — o inventário do conteúdo do jogo

  1. Quantas questões a equipe de Medicina já produziu


As duas contagens são diferentes de propósito. O documento é o que foi
escrito; o banco é o que o aluno encontra ao abrir o mapa. A distância
entre eles é justamente o que precisa de decisão.

"""

import importlib.util
import os
import sys
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))

spec = importlib.util.spec_from_file_location('cb', os.path.join(AQUI, 'casar_com_banco.py'))
cb = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cb)

FAIXA = {1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos'}

# Quantas questões um quiz precisa ter, no mínimo (server/rotas/professor.js).
QTD_MIN = 3


def montar():
    doc, avisos = cb.pu.extrair()
    banco = cb.ler_banco()
    # Casa por texto e faixa etária.
    pares = {(q['nivel'], cb.normalizar(q['enunciado']))
             for _, q, _ in cb.casar()[0]}

    cenarios = {c['id']: c for c in banco['cenarios']}
    questoes = banco['questoes']

    # cenário -> nível -> quantas
    grade = defaultdict(lambda: Counter())
    for q in questoes:
        slug = cenarios.get(q['cenario_id'], {}).get('slug', '(sem cenário)')
        grade[slug][q['nivel_etario']] += 1

    return doc, questoes, cenarios, grade, avisos, pares


def linhas_relatorio():
    doc, questoes, cenarios, grade, avisos, pares = montar()
    L = []
    def p(s=''): L.append(s)

    doc_por_nivel = Counter(q['nivel'] for q in doc)
    banco_por_nivel = Counter(q['nivel_etario'] for q in questoes)

    p('# Inventário das questões')
    p()
    p('Fonte: `todas as questões.docx` (equipe de Medicina) e o banco do jogo.')
    p()

    p('## 1. Por faixa etária')
    p()
    # Conta as questões do documento que ficaram de fora do banco.
    fora = Counter(q['nivel'] for q in doc
                   if (q['nivel'], cb.normalizar(q['enunciado'])) not in pares)

    p('| Faixa | No documento | No jogo | Fora do jogo |')
    p('|---|---:|---:|---:|')
    for n in (1, 2, 3):
        p(f'| **Nível {n}** — {FAIXA[n]} | {doc_por_nivel[n]} | {banco_por_nivel[n]} '
          f'| {fora[n]} |')
    p(f'| **Total** | **{len(doc)}** | **{len(questoes)}** '
      f'| **{sum(fora.values())}** |')
    p()
    if fora:
        p(f'As **{sum(fora.values())}** que ficaram de fora são enunciados que o documento '
          'repete nas duas faixas mais velhas. Estão no jogo uma vez, na faixa de 11 a 14 — '
          'levá-las também para 15 a 18 é decisão de conteúdo, não falha de importação.')
        p()

    p('## 2. Por cenário — o que está no jogo')
    p()
    p('| Cenário | 7–10 | 11–14 | 15–18 | Total |')
    p('|---|---:|---:|---:|---:|')

    ordenados = sorted(grade.items(), key=lambda kv: -sum(kv[1].values()))
    tot = Counter()
    for slug, por_nivel in ordenados:
        soma = sum(por_nivel.values())
        for n in (1, 2, 3):
            tot[n] += por_nivel[n]
        marca = ' ⚠' if soma == 0 else ''
        p(f'| `{slug}`{marca} | {por_nivel[1]} | {por_nivel[2]} | {por_nivel[3]} | **{soma}** |')

    # Cenários cadastrados que não têm questão nenhuma.
    sem_nada = [c['slug'] for c in cenarios.values() if c['slug'] not in grade]
    for slug in sorted(sem_nada):
        p(f'| `{slug}` ⚠ | 0 | 0 | 0 | **0** |')

    p(f'| **Total** | **{tot[1]}** | **{tot[2]}** | **{tot[3]}** '
      f'| **{sum(tot.values())}** |')
    p()
    p('⚠ = cenário sem nenhuma questão: o aluno abre o ponto no mapa e não encontra nada.')
    p()

    p('## 3. Onde o professor consegue montar quiz')
    p()
    p(f'Um quiz precisa de pelo menos **{QTD_MIN} questões** da faixa da turma.')
    p()
    for n in (1, 2, 3):
        podem = sorted(((s, c[n]) for s, c in grade.items() if c[n] >= QTD_MIN),
                       key=lambda x: -x[1])
        curtos = sorted((s, c[n]) for s, c in grade.items() if 0 < c[n] < QTD_MIN)

        p(f'**Nível {n} ({FAIXA[n]})** — {tot[n]} questões em '
          f'{len(podem)} {"cenário" if len(podem) == 1 else "cenários"}')
        p()
        if podem:
            p('> ' + ', '.join(f'`{s}` ({q})' for s, q in podem))
        else:
            p('> *nenhum cenário tem conteúdo suficiente*')
        if curtos:
            p('>')
            p('> Abaixo do mínimo: ' + ', '.join(f'`{s}` ({q})' for s, q in curtos))
        p()

    return L, doc, questoes, grade, avisos


def imprimir(L):
    for linha in L:
        print('  ' + linha.replace('**', '').replace('`', ''))


if __name__ == '__main__':
    L, doc, questoes, grade, avisos = linhas_relatorio()
    imprimir(L)

    if '--md' in sys.argv:
        destino = sys.argv[sys.argv.index('--md') + 1]
        with open(destino, 'w', encoding='utf-8') as f:
            f.write('\n'.join(L) + '\n')
        print(f'\n  gravado em {destino}')
