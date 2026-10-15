# -*- coding: utf-8 -*-
"""
casar_com_banco.py — liga cada questão do documento à linha do banco

O documento da equipe de Medicina não tem id nem código: a única coisa
em comum com o banco é o TEXTO do enunciado. E o texto não bate letra a
letra — no caminho até o banco ele perdeu acentuação em alguns casos,
ganhou espaço duplo em outros, e às vezes foi cortado.

Então o casamento é por texto NORMALIZADO (sem acento, sem pontuação,
sem espaço repetido, em minúsculas) e, quando isso não basta, por
semelhança. Um casamento errado trocaria o feedback de uma questão pelo
de outra, então o limite de semelhança é alto e o que ficar em dúvida
sai no relatório em vez de ser adivinhado.

Uso:
    python db/ferramentas/casar_com_banco.py            # relatório
    python db/ferramentas/casar_com_banco.py --sql ARQ  # gera o UPDATE
"""

import difflib
import importlib.util
import json
import os
import re
import subprocess
import sys
import unicodedata
from collections import Counter

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(os.path.dirname(AQUI))

spec = importlib.util.spec_from_file_location('pu', os.path.join(AQUI, 'parser_unificado.py'))
pu = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pu)

# Abaixo disto o par não é aceito: é mais provável serem duas questões
# diferentes sobre o mesmo assunto do que a mesma questão reescrita.
LIMITE = 0.88

# Texto de marcação do documento que vazou para dentro de uma alternativa.
RE_MARCADOR = re.compile(r'gabarito|resposta\s+correta', re.I)


def normalizar(texto):
    t = texto or ''

    # Dois enunciados do banco vieram com as alternativas coladas dentro
    # ("…quer nos dizer que: A) Devemos passar o dia todo sentados…").
    # Para comparar, interessa só o que vem antes da primeira delas.
    corte = re.search(r'\s[A-E]\)\s+\S', t)
    if corte and corte.start() > 20:
        t = t[:corte.start()]

    t = unicodedata.normalize('NFD', t.lower())
    t = ''.join(c for c in t if unicodedata.category(c) != 'Mn')
    t = re.sub(r'verdadeiro ou falso\s*:?', ' ', t)
    t = re.sub(r'[^a-z0-9 ]', ' ', t)
    return re.sub(r'\s+', ' ', t).strip()


def enunciado_sujo(texto):
    """O enunciado do banco carrega alternativas coladas?"""
    m = re.search(r'\s[A-E]\)\s+\S', texto or '')
    return bool(m and m.start() > 20)


def alternativas_do_banco(linha):
    return [linha.get('opcao_' + L) for L in 'abcde' if linha.get('opcao_' + L)]


def alternativas_embaralhadas(linha, q):
    """
    A lista de alternativas do banco está estragada?

    Três questões do `praca` chegaram ao banco pelo parser antigo sem a
    primeira alternativa e com o nome do cenário no lugar da última
    ("…C) Movimentar o corpo é ruim. D) Escola e quadra"). Como as
    letras andaram uma casa, o gabarito passou a apontar a alternativa
    errada: o aluno respondia certo e o jogo dizia que não.

    Diferença de grafia não conta — num caso o documento tem o erro de
    digitação e o banco está melhor. Por isso a comparação é alternativa
    a alternativa: só reescreve quando alguma delas é outro texto, e não
    o mesmo texto escrito de outro jeito.
    """
    cruas = alternativas_do_banco(linha)
    banco = [normalizar(o) for o in cruas]
    doc = [normalizar(o) for o in q['opcoes']]

    # Uma alternativa que carrega "Gabarito: alternativa E" dentro de si
    # entrega a resposta ao aluno. É sempre errado, por mais parecida
    # que a frase seja com a do documento.
    if any(RE_MARCADOR.search(o) for o in cruas):
        return True

    if banco == doc:
        return False
    if len(banco) != len(doc):
        return True
    return any(difflib.SequenceMatcher(None, b, d).ratio() < 0.90
               for b, d in zip(banco, doc))


def ler_banco():
    """Puxa as questões pelo cliente do servidor, que já tem a chave."""
    script = r"""
require('dotenv').config({path: process.argv[1] + '/.env'});
const {admin} = require(process.argv[1] + '/server/supabase.js');
const {lerTudo} = require(process.argv[1] + '/server/lerTudo.js');
(async () => {
  const q = await lerTudo(() => admin.from('questoes')
    .select('id, enunciado, nivel_etario, resposta_correta, explicacao, cenario_id, ' +
            'codigo_externo, opcao_a, opcao_b, opcao_c, opcao_d, opcao_e')
    .order('id'));
  const c = await admin.from('cenarios').select('id, slug, nome');
  process.stdout.write('@@JSON@@' + JSON.stringify({questoes: q.data, cenarios: c.data}));
})();
"""
    r = subprocess.run(['node', '-e', script, RAIZ], capture_output=True, text=True,
                       encoding='utf-8', cwd=RAIZ,
                       env={**os.environ, 'NODE_PATH': os.path.join(RAIZ, 'node_modules')})
    if '@@JSON@@' not in r.stdout:
        print(r.stdout[-800:], r.stderr[-800:])
        sys.exit('não consegui ler o banco')
    return json.loads(r.stdout.split('@@JSON@@', 1)[1])


def casar():
    doc, _ = pu.extrair()
    banco = ler_banco()
    linhas, cenarios = banco['questoes'], banco['cenarios']

    nome_cenario = {c['id']: c['slug'] for c in cenarios}

    # Índice do documento por texto normalizado.
    por_texto = {}
    for q in doc:
        por_texto.setdefault(normalizar(q['enunciado']), []).append(q)

    pares, sem_par, duvidosos = [], [], []
    usados = set()

    for linha in linhas:
        chave = normalizar(linha['enunciado'])
        candidatos = por_texto.get(chave)

        if candidatos:
            q = next((c for c in candidatos if id(c) not in usados), candidatos[0])
            usados.add(id(q))
            pares.append((linha, q, 1.0))
            continue

        # Sem casamento exato: procura o mais parecido do mesmo nível.
        mesmo_nivel = [q for q in doc if q['nivel'] == linha['nivel_etario'] and id(q) not in usados]
        melhor, nota = None, 0.0
        for q in mesmo_nivel:
            n = difflib.SequenceMatcher(None, chave, normalizar(q['enunciado'])).ratio()
            if n > nota:
                melhor, nota = q, n

        if melhor and nota >= LIMITE:
            usados.add(id(melhor))
            pares.append((linha, melhor, nota))
        elif melhor and nota >= 0.72:
            duvidosos.append((linha, melhor, nota))
        else:
            sem_par.append(linha)

    novas = [q for q in doc if id(q) not in usados]
    return pares, sem_par, duvidosos, novas, nome_cenario, doc, linhas


def diferencas(linha, q):
    """O que mudou entre o banco e o documento, para esta questão."""
    mudou = []
    if linha['resposta_correta'] != q['resposta']:
        mudou.append(f"gabarito {linha['resposta_correta']} -> {q['resposta']}")
    if normalizar(linha['explicacao'] or '') != normalizar(q['acerto'] or ''):
        mudou.append('texto do acerto')
    return mudou


def aspas(s):
    """Texto para dentro do SQL. Aspas simples dobradas, como manda o padrão."""
    return "'" + (s or '').replace("'", "''") + "'"


def gerar_sql(pares, destino):
    """
    Monta o arquivo que acrescenta a coluna nova e atualiza os dois
    feedbacks de cada questão já existente.

    Por `id` e não por texto: o casamento pelo enunciado já foi feito
    aqui, com conferência; repetir isso dentro do SQL seria refazer no
    banco um trabalho que já está conferido, e com menos cuidado.
    """
    linhas_sql = ["""-- =====================================================================
--  FEEDBACK DAS QUESTÕES — gerado por db/ferramentas/casar_com_banco.py
--
--  NÃO EDITE À MÃO. Para refazer:
--      python db/ferramentas/casar_com_banco.py --sql db/feedback-questoes.sql
--
--  O que este arquivo faz:
--    1. cria a coluna explicacao_erro
--    2. preenche os DOIS feedbacks das questões que já estavam no banco
--    3. corrige gabaritos, enunciados e alternativas que divergiam do
--       documento — inclusive as questões cujas alternativas chegaram
--       ao banco fora de ordem, com a letra certa apontando o texto
--       errado
--
--  A fonte é "todas as questões.docx", da equipe de Medicina, onde cada
--  questão traz "Se acertar:" e "Se errar:".
--
--  Onde rodar: SQL Editor do Supabase, COM NADA SELECIONADO.
--  Pode rodar mais de uma vez: só faz update, nunca insert.
-- =====================================================================


-- O feedback de quem ERRA. É texto diferente do de quem acerta: um
-- confirma e aprofunda, o outro dá a pista sem entregar a resposta —
-- a ideia é que a pessoa tente de novo sabendo mais, e não que copie.
--
-- `explicacao` continua sendo o feedback de ACERTO, como já era.
alter table questoes add column if not exists explicacao_erro text;

"""]

    corrigidos_gab, corrigidos_enun, corrigidas_alt = [], [], []

    for linha, q, _ in pares:
        campos = [f'explicacao = {aspas(q["acerto"])}',
                  f'explicacao_erro = {aspas(q["erro"])}']

        if linha['resposta_correta'] != q['resposta']:
            campos.append(f'resposta_correta = {aspas(q["resposta"])}')
            corrigidos_gab.append((linha, q))

        if enunciado_sujo(linha['enunciado']):
            campos.append(f'enunciado = {aspas(q["enunciado"])}')
            corrigidos_enun.append(linha)

        # Alternativas fora de lugar levam o gabarito junto: a letra
        # continua a mesma e passa a apontar outro texto. Por isso a
        # lista é reescrita inteira, e a resposta junto com ela.
        if alternativas_embaralhadas(linha, q):
            ops = list(q['opcoes']) + [None] * (5 - len(q['opcoes']))
            for i, letra in enumerate('abcde'):
                campos.append(f'opcao_{letra} = '
                              + (aspas(ops[i]) if ops[i] else 'null'))
            if f'resposta_correta = {aspas(q["resposta"])}' not in campos:
                campos.append(f'resposta_correta = {aspas(q["resposta"])}')
            corrigidas_alt.append((linha, q))

        linhas_sql.append(f'update questoes set\n  ' + ',\n  '.join(campos)
                          + f'\nwhere id = {linha["id"]};\n')

    if corrigidas_alt:
        linhas_sql.insert(1, '-- ── ALTERNATIVAS REESCRITAS ──────────────────────────────────────\n'
                             '-- Chegaram ao banco com uma alternativa a menos e o nome do cenário\n'
                             '-- no lugar da última. As letras andaram uma casa e o gabarito passou\n'
                             '-- a apontar o texto errado.\n--\n'
                          + ''.join(f'--   id {l["id"]:<5} nv{l["nivel_etario"]}   {l["enunciado"][:60]}…\n'
                                    for l, _ in corrigidas_alt)
                          + '\n')

    if corrigidos_gab:
        linhas_sql.insert(1, '-- ── GABARITOS CORRIGIDOS ─────────────────────────────────────────\n'
                             '-- O banco apontava a alternativa errada. Quem respondia certo estava\n'
                             '-- sendo marcado como errado, e perdia o ponto.\n--\n'
                          + ''.join(f'--   id {l["id"]:<5} nv{l["nivel_etario"]}  {l["resposta_correta"]} -> {q["resposta"]}'
                                    f'   {l["enunciado"][:56]}…\n' for l, q in corrigidos_gab)
                          + '\n')

    linhas_sql.append('\nnotify pgrst, \'reload schema\';\n')

    with open(destino, 'w', encoding='utf-8') as f:
        f.write('\n'.join(linhas_sql))

    return corrigidos_gab, corrigidos_enun, corrigidas_alt


if __name__ == '__main__':
    pares, sem_par, duvidosos, novas, cen, doc, linhas = casar()

    if '--sql' in sys.argv:
        destino = sys.argv[sys.argv.index('--sql') + 1]
        gab, enun, alt = gerar_sql(pares, destino)
        print(f'\n  {destino}')
        print(f'    {len(pares)} questões com os dois feedbacks')
        print(f'    {len(gab)} gabaritos corrigidos, {len(enun)} enunciados limpos')
        print(f'    {len(alt)} questões com as alternativas reescritas')
        for l, _ in alt:
            print(f'      id {l["id"]:<5} nv{l["nivel_etario"]}  {l["enunciado"][:58]}')
        sys.exit()

    print('\n╔══ DOCUMENTO × BANCO ════════════════════════════════════╗\n')
    print(f'  questões no documento : {len(doc):4d}')
    print(f'  questões no banco     : {len(linhas):4d}')
    print(f'  casadas               : {len(pares):4d}'
          f'  (exatas: {sum(1 for _, _, n in pares if n == 1.0)},'
          f' por semelhança: {sum(1 for _, _, n in pares if n < 1.0)})')
    print(f'  no banco e não no doc : {len(sem_par):4d}')
    print(f'  no doc e não no banco : {len(novas):4d}')
    print(f'  duvidosas             : {len(duvidosos):4d}')

    gabarito_mudou = [(l, q) for l, q, _ in pares if l['resposta_correta'] != q['resposta']]
    print(f'\n  ⚠ gabarito DIFERENTE do banco: {len(gabarito_mudou)}')
    for l, q in gabarito_mudou[:15]:
        print(f'      id {l["id"]:<5} nv{l["nivel_etario"]}  banco={l["resposta_correta"]}  '
              f'doc={q["resposta"]}   {l["enunciado"][:58]}…')
    if len(gabarito_mudou) > 15:
        print(f'      … e mais {len(gabarito_mudou) - 15}')

    if duvidosos:
        print(f'\n  ⚠ pares duvidosos (não serão usados):')
        for l, q, n in duvidosos[:10]:
            print(f'      {n:.2f}  banco id {l["id"]}: {l["enunciado"][:50]}…')
            print(f'            doc nv{q["nivel"]} q{q["numero"]}: {q["enunciado"][:50]}…')

    if sem_par:
        print(f'\n  ⚠ no banco mas fora do documento ({len(sem_par)}):')
        for l in sem_par[:10]:
            print(f'      id {l["id"]:<5} nv{l["nivel_etario"]} {cen.get(l["cenario_id"], "?"):<14} {l["enunciado"][:52]}…')
        if len(sem_par) > 10:
            print(f'      … e mais {len(sem_par) - 10}')

    print(f'\n  questões novas por nível: '
          + ', '.join(f'nv{n}: {c}' for n, c in sorted(Counter(q["nivel"] for q in novas).items())))
