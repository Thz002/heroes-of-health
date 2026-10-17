import difflib
import importlib.util
import os
import sys
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))


def carregar(nome):
    spec = importlib.util.spec_from_file_location(nome[:-3], os.path.join(AQUI, nome))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


cb = carregar('casar_com_banco.py')
lc = carregar('ler_cenarios_originais.py')
mc = carregar('mapear_cenarios.py')

FAIXA = {1: '7 a 10 anos', 2: '11 a 14 anos', 3: '15 a 18 anos'}
QTD_MIN = 3
LIMITE = 0.88


def slug_de_cenario(linha, atual):
    """O slug do cenário de uma questão que já está no banco."""
    return SLUG_POR_ID.get(linha['cenario_id'])


SLUG_POR_ID = {}


def cruzar():
    doc, _ = cb.pu.extrair()                 # 580 do consolidado
    originais = lc.ler_todos()               # 476 dos arquivos soltos
    propostas, atual, slug_de, no_banco = mc.classificar()
    SLUG_POR_ID.update(slug_de)

    # O que eu havia proposto, por enunciado.
    minha = {cb.normalizar(x['q']['enunciado']): x['cenario'] for x in propostas}

    # Índice dos originais por texto normalizado.
    por_texto = defaultdict(list)
    for q in originais:
        por_texto[cb.normalizar(q['enunciado'])].append(q)

    achadas, perdidas, usados = [], [], set()

    for q in doc:
        chave = cb.normalizar(q['enunciado'])
        cands = [c for c in por_texto.get(chave, []) if id(c) not in usados]

        if not cands:
            # Sem casamento exato: o mais parecido, com limite alto.
            melhor, nota = None, 0.0
            for o in originais:
                if id(o) in usados:
                    continue
                n = difflib.SequenceMatcher(None, chave, cb.normalizar(o['enunciado'])).ratio()
                if n > nota:
                    melhor, nota = o, n
            cands = [melhor] if melhor and nota >= LIMITE else []

        if cands:
            usados.add(id(cands[0]))
            achadas.append((q, cands[0]))
        else:
            perdidas.append(q)

    sobrando = [o for o in originais if id(o) not in usados]
    return doc, originais, achadas, perdidas, sobrando, minha, atual, no_banco, propostas


def relatorio(dados):
    doc, originais, achadas, perdidas, sobrando, minha, atual, no_banco, propostas = dados
    L = []
    def p(s=''): L.append(s)

    p('# Conferência: consolidado × arquivos originais')
    p()
    p('O `todas as questões.docx` serviu para acrescentar os feedbacks e **não tem cenário**.')
    p('Os arquivos mandados aos poucos **têm** — e trazem também as áreas de pontuação.')
    p('Esta conferência cruza os dois pelo texto do enunciado.')
    p()

    # ── 1. os arquivos ──────────────────────────────────────────────
    p('## 1. O que cada arquivo tem')
    p()
    p('| Arquivo | Questões | Com cenário |')
    p('|---|---:|---:|')
    por_arq = Counter(q['arquivo'] for q in originais)
    com_cen = Counter(q['arquivo'] for q in originais if q['cenarios'])
    for nome, quantas in sorted(por_arq.items()):
        p(f'| `{nome}` | {quantas} | {com_cen[nome]} |')
    p(f'| **Total** | **{len(originais)}** | **{sum(com_cen.values())}** |')
    p()
    p(f'O consolidado tem **{len(doc)}** questões.')
    p()

    # ── 2. a batida ─────────────────────────────────────────────────
    p('## 2. A quantidade bate?')
    p()
    p('| | Questões |')
    p('|---|---:|')
    p(f'| No consolidado | {len(doc)} |')
    p(f'| Encontradas nos arquivos originais (**têm cenário**) | **{len(achadas)}** |')
    p(f'| Só no consolidado (**sem cenário de origem**) | **{len(perdidas)}** |')
    p(f'| Só nos arquivos originais (ficaram de fora do consolidado) | {len(sobrando)} |')
    p()

    faltam_n = Counter(q['nivel'] for q in perdidas)
    if perdidas:
        p('As que estão só no consolidado, por faixa: '
          + ', '.join(f'**nível {n}**: {faltam_n[n]}' for n in (1, 2, 3) if faltam_n[n]) + '.')
        p()

    # 3. Concordância entre o cenário do banco/proposta e o da equipe.
    cen_no_banco = {cb.normalizar(l['enunciado']): slug_de_cenario(l, atual)
                    for l in no_banco}

    banco_ok, banco_dif, meu_ok, meu_dif = [], [], [], []

    for q, o in achadas:
        if not o['cenarios']:
            continue
        chave = cb.normalizar(q['enunciado'])
        deles = o['cenarios'][0]

        if chave in cen_no_banco:
            (banco_ok if cen_no_banco[chave] == deles else banco_dif).append(
                (q, o, cen_no_banco[chave]))
        else:
            meu = minha.get(chave)
            if meu:
                (meu_ok if meu == deles else meu_dif).append((q, o, meu))

    p('## 3. Conferindo as classificações')
    p()

    tb = len(banco_ok) + len(banco_dif)
    if tb:
        pb = round(100 * len(banco_ok) / tb)
        p(f'**O que já está no jogo.** Das {tb} questões que estão no banco e também nos '
          f'arquivos originais, o cenário gravado bate com o da equipe em '
          f'**{len(banco_ok)} ({pb}%)**.')
        p()
        if banco_dif:
            p('| No banco | A equipe marcou | Questões |')
            p('|---|---|---:|')
            for (b, d), n in Counter((m, o['cenarios'][0]) for _, o, m in banco_dif).most_common(12):
                p(f'| `{b}` | `{d}` | {n} |')
            p()

    tm = len(meu_ok) + len(meu_dif)
    if tm:
        pm = round(100 * len(meu_ok) / tm)
        p(f'**O que eu havia proposto.** Das {tm} questões novas que aparecem nos arquivos '
          f'originais, a minha classificação por assunto bateu em **{len(meu_ok)} ({pm}%)**.')
        p()
        if meu_dif:
            p('| Eu propus | A equipe marcou | Questões |')
            p('|---|---|---:|')
            for (m, d), n in Counter((m, o['cenarios'][0]) for _, o, m in meu_dif).most_common(12):
                p(f'| `{m}` | `{d}` | {n} |')
            p()
        p('Onde houver divergência, **vale a da equipe**: quem escreveu a questão sabe para '
          'onde ela foi pensada. A minha proposta só é usada nas que não estão em arquivo nenhum.')
        p()

    # ── 4. distribuição final ───────────────────────────────────────
    p('## 4. Como ficaria usando o cenário da equipe')
    p()

    # Cenário final: o da equipe, ou a proposta quando não houver.
    cen_de, origem = {}, Counter()
    for q, o in achadas:
        if o['cenarios']:
            cen_de[id(q)] = o['cenarios'][0]
            origem['equipe'] += 1
    for q in doc:
        if id(q) not in cen_de:
            cen_de[id(q)] = minha.get(cb.normalizar(q['enunciado']))
            if cen_de[id(q)]:
                origem['proposta'] += 1

    novas_por = defaultdict(Counter)
    ja_no_banco = {cb.normalizar(l['enunciado']) for l in no_banco}
    for q in doc:
        if cb.normalizar(q['enunciado']) in ja_no_banco:
            continue
        slug = cen_de.get(id(q))
        if slug:
            novas_por[slug][q['nivel']] += 1

    todos = sorted(set(list(atual.keys()) + list(novas_por.keys())))
    todos = [s for s in todos if s and s != '(sem cenário)']

    p('| Cenário | 7–10 | 11–14 | 15–18 | Total | hoje → depois |')
    p('|---|---:|---:|---:|---:|---|')
    tot = Counter()
    linhas_t = []
    for slug in todos:
        hoje = sum(atual[slug].values())
        dep = [atual[slug][n] + novas_por[slug][n] for n in (1, 2, 3)]
        for n in (1, 2, 3):
            tot[n] += dep[n - 1]
        linhas_t.append((sum(dep), slug, hoje, dep))

    for soma, slug, hoje, dep in sorted(linhas_t, reverse=True):
        p(f'| `{slug}` | {dep[0]} | {dep[1]} | {dep[2]} | **{soma}** | '
          f'{hoje} → **{soma}**' + ('  🆕' if hoje == 0 else '') + ' |')
    p(f'| **Total** | **{tot[1]}** | **{tot[2]}** | **{tot[3]}** | **{sum(tot.values())}** | |')
    p()
    p(f'Cenário vindo da equipe: **{origem["equipe"]}** questões. '
      f'Da minha proposta (as que não estão nos arquivos originais): **{origem["proposta"]}**.')
    p()

    p('## 5. Onde o professor conseguiria montar quiz')
    p()
    p(f'Mínimo de **{QTD_MIN} questões** por quiz.')
    p()
    p('| Faixa | Hoje | Depois |')
    p('|---|---:|---:|')
    for n in (1, 2, 3):
        a = sum(1 for s in todos if atual[s][n] >= QTD_MIN)
        d = sum(1 for s in todos if atual[s][n] + novas_por[s][n] >= QTD_MIN)
        p(f'| Nível {n} — {FAIXA[n]} | {a} de {len(todos)} | **{d} de {len(todos)}** |')
    p()

    # ── 6. áreas de pontuação ───────────────────────────────────────
    p('## 6. Pontuação que os arquivos originais indicam')
    p()
    p('Os arquivos dizem em que áreas cada bloco pontua. Isso alimenta `questoes_areas`,')
    p('que hoje é preenchida por estimativa.')
    p()
    p('| Área | Questões que a citam |')
    p('|---|---:|')
    for a, n in Counter(x for q in originais for x in q['areas']).most_common():
        p(f'| {a} | {n} |')
    p()

    return L


if __name__ == '__main__':
    dados = cruzar()

    if '--divergencias' in sys.argv:
        doc, originais, achadas, perdidas, sobrando, minha, *_ = dados
        for q, o in achadas:
            if not o['cenarios']:
                continue
            meu = minha.get(cb.normalizar(q['enunciado']))
            if meu != o['cenarios'][0]:
                print(f"  nv{q['nivel']}  eu:{meu:<15} equipe:{','.join(o['cenarios']):<22} "
                      f"{q['enunciado'][:62]}")
        sys.exit()

    L = relatorio(dados)
    for linha in L:
        print('  ' + linha.replace('**', '').replace('`', ''))

    if '--md' in sys.argv:
        destino = sys.argv[sys.argv.index('--md') + 1]
        with open(destino, 'w', encoding='utf-8') as f:
            f.write('\n'.join(L) + '\n')
        print(f'\n  gravado em {destino}')
