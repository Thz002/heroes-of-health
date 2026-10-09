# -*- coding: utf-8 -*-
"""Decide cenario e barras do terceiro lote e MESCLA no questoes_extraidas.json.

Passo 2 de 3:

  python parser_lote3.py    -> lote3_bruto.json         (so le os .docx)
  python montar_lote3.py    -> questoes_extraidas.json  (este arquivo)
  python gerar_sql.py ../importar-lote3.sql --lote 3

Tudo o que aqui e DECISAO esta escrito em tabela, e nao espalhado em if:
quem quiser mudar o cenario de uma questao muda uma linha e roda de novo
(antes de importar -- depois de importado o codigo nao muda mais).

De onde vieram as regras:

  - O que o proprio .docx diz em cada titulo de secao ("pontuacao em
    limpeza, felicidade", "mesma de 7-10", "ESCOLA E UBS - SAUDE...").
  - As duas instrucoes do topo do arquivo N3: vacinacao vai para a
    FARMACIA com pontos em Vacinacao; saneamento vai para o CORREGO com
    pontos em Limpeza.
  - O que nao tinha cenario (o bloco do N3 sem titulo) ou nao existe no
    jogo (o "Rio" do 11-14) foi para os cenarios e barras que estavam
    sem pergunta: Corrego e Terreno Baldio tinham zero, e as barras de
    Exercicios, Vetores e Limpeza eram as mais vazias.

So roda uma vez: se o lote 3 ja estiver no JSON, recusa. Os codigos
gravados no banco nunca podem mudar (ver LEIA-ME.md).
"""
import json, re, sys, os
from collections import Counter, defaultdict
sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))
LOTE = 3

bruto = json.load(open(os.path.join(AQUI, 'lote3_bruto.json'), encoding='utf-8'))
base_path = os.path.join(AQUI, 'questoes_extraidas.json')
base = json.load(open(base_path, encoding='utf-8'))

if any(x.get('lote') == LOTE for x in base):
    sys.exit('O lote 3 ja esta no questoes_extraidas.json. Nada a fazer.')


def texto_da_certa(q):
    """Enunciado + alternativa certa: e o que a questao ENSINA.

    As erradas ficam de fora da busca por palavra de proposito: "impedir
    qualquer proliferacao de vetores" e uma alternativa errada sobre
    lixo no rio, e nao faz da questao uma questao sobre vetores.
    """
    certa = q['alts'][q['certa']] if isinstance(q['certa'], int) else ''
    return (q['enunciado'] + ' ' + certa).lower()


VACINA = re.compile(r'vacin')
VETOR = re.compile(r'vetor|criadouro|água parada|acumul\w*\s+(de\s+)?água|acumulando água|recipiente')
MOVIMENTO = re.compile(r'atividade|exerc|moviment|caminhada|corrida|esport')
CONVIVIO = re.compile(r'conviv|comunit|social|emocion|conversar')


def com(q, regra, area):
    return [area] if regra.search(texto_da_certa(q)) else []


# ── 7 a 10 anos ───────────────────────────────────────────────────────
# "pontuacao em saude e felicidade (questoes que abordam vacinas ter
# vacinacao tbm)" -- vale para as tres secoes.
CENARIO_N1 = {'UBS': 'ubs', 'UPA': 'upa', 'FARMACIA': 'farmacia'}


def regra_n1(q):
    return [CENARIO_N1[q['secao']]], ['Saúde', 'Felicidade'] + com(q, VACINA, 'Vacinação')


# Erros de digitacao no texto que a crianca le. So nome trocado,
# concordancia e palavra repetida -- nada de conteudo.
CORRECOES = {
    (1, 'UBS', 7): ('O que pode acontecer com João?', 'O que pode acontecer com Caio?'),
    (1, 'UPA', 2): ('procurar uma uma Unidade', 'procurar uma Unidade'),
    (1, 'UPA', 4): ('precisa ser avaliado', 'precisa ser avaliada'),
    (1, 'FARMACIA', 8): ('disse que ela deveria tomar', 'disse que ele deveria tomar'),
}


# ── 11 a 14 anos ──────────────────────────────────────────────────────
# A ordem importa: "CENARIO" contem "RIO", por isso o Rio so casa depois
# do travessao.
CENARIO_N2 = [
    (r'CÓRREGO', 'corrego'),
    (r'—\s*RIO\b', 'corrego'),          # nao existe cenario Rio no jogo
    (r'FARMÁCIA', 'farmacia'),
    (r'TERRENO BALDIO', 'terreno-baldio'),
    (r'CAMPO DE LAZER', 'quadra'),      # o slug do Campo de lazer e "quadra"
    (r'PRACINHA', 'praca'),
    (r'PARQUE', 'parque'),
    (r'—\s*UBS', 'ubs'),
    (r'—\s*UPA', 'upa'),
]


def regra_n2(q):
    slug = next(s for padrao, s in CENARIO_N2 if re.search(padrao, q['secao']))

    if slug in ('corrego', 'terreno-baldio'):
        # "limpeza, felicidade (as q falam de vetor, colocar controle de vetores)"
        areas = ['Limpeza', 'Felicidade'] + com(q, VETOR, 'Vetores')
    elif slug in ('farmacia', 'ubs', 'upa'):
        # "mesma pontuacao q coloquei de 7-10"
        areas = ['Saúde', 'Felicidade'] + com(q, VACINA, 'Vacinação')
    elif slug == 'quadra':
        areas = ['Felicidade', 'Exercícios']
    elif slug == 'parque':
        areas = ['Limpeza', 'Felicidade', 'Saúde']
    else:
        # Pracinha veio sem barra no titulo. O conteudo e movimento,
        # calor e convivencia -- e Exercicios era a barra sem nenhuma
        # questao no banco.
        areas = ['Saúde'] + com(q, MOVIMENTO, 'Exercícios') + com(q, CONVIVIO, 'Felicidade')
    return [slug], areas


# ── 15 a 18 anos ──────────────────────────────────────────────────────
# Por secao. Secao com DOIS lugares ("UBS E ESCOLA") alterna entre eles,
# para os dois receberem nivel 3 -- uma questao so pode ter um cenario.
SECOES_N3 = {
    'CONTROLE DE VETORES, SAÚDE E EDUCAÇÃO - ESCOLA': (['escola'], ['Saúde', 'Educação']),
    'UBS - SAÚDE': (['ubs'], ['Saúde']),
    'UBS E ESCOLA - SAÚDE E EDUCAÇÃO': (['ubs', 'escola'], ['Saúde', 'Educação']),
    'UBS - SAÚDE E EDUCAÇÃO': (['ubs'], ['Saúde', 'Educação']),
    'ESCOLA E CASAS - PONTUAÇÃO EM SAÚDE': (['escola', 'casa'], ['Saúde']),
    'ESCOLA E UBS - PONTUAÇÃO EM SAÚDE, EDUCAÇÃO E FELICIDADE':
        (['escola', 'ubs'], ['Saúde', 'Educação', 'Felicidade']),
}

# As que saem da regra da secao, pelo numero da questao no arquivo N3.
VACINACAO = (['farmacia'], ['Vacinação', 'Saúde'])
SANEAMENTO = (['corrego'], ['Limpeza', 'Saúde'])
EXCECOES_N3 = {
    # Arboviroses: as unicas do bloco da escola que falam de vetor.
    1: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    2: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    3: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    4: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    5: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    6: (['escola'], ['Vetores', 'Saúde', 'Educação']),
    8: (['escola'], ['Vetores', 'Saúde', 'Educação']),

    # "Questoes de vacinacao adicionar na farmacia e pontuacao em vacinacao"
    7: (['farmacia'], ['Vacinação', 'Vetores', 'Saúde']),   # febre amarela
    9: VACINACAO,     # RNA mensageiro
    11: VACINACAO,    # poliomielite
    12: VACINACAO,    # raiva, vacina pos-exposicao
    14: VACINACAO,    # sarampo, imunidade de rebanho
    15: VACINACAO,    # gripe
    38: VACINACAO,    # programa de vacinacao contra o HPV

    # "Questoes que falam de saneamento basico adicionar no corrego e
    # pontuacao em limpeza"
    10: SANEAMENTO,   # hepatite A

    # O bloco SEM titulo (depois do primeiro "———"): distribuido pelos
    # cenarios sem nivel 3, cada uma onde o assunto acontece.
    17: (['farmacia'], ['Saúde']),                          # superbacterias
    18: (['farmacia'], ['Saúde', 'Educação']),              # antibiotico x virus
    19: SANEAMENTO,                                         # leptospirose, enchentes
    20: (['upa'], ['Saúde']),                               # meningite, urgencia
    21: (['ubs'], ['Saúde']),                               # infeccao urinaria
    22: (['ubs'], ['Saúde']),                               # sifilis, diagnostico
    23: (['ubs'], ['Saúde', 'Educação']),                   # hanseniase, estigma
    24: (['mercado'], ['Alimentação', 'Saúde']),            # salmonelose
    25: SANEAMENTO,                                         # agua tratada e esgoto
    26: SANEAMENTO,                                         # esquistossomose
    27: (['ubs'], ['Saúde']),                               # toxoplasmose, pre-natal
    28: SANEAMENTO,                                         # giardiase e amebiase
    29: (['corrego'], ['Limpeza', 'Alimentação', 'Saúde']), # esgoto perto da horta
}


def regras_n3(questoes):
    vez = Counter()
    for q in questoes:
        if q['num'] in EXCECOES_N3:
            lugares, areas = EXCECOES_N3[q['num']]
        else:
            lugares, areas = SECOES_N3[q['secao']]
            if len(lugares) > 1:
                i = vez[q['secao']] % len(lugares)
                vez[q['secao']] += 1
                lugares = lugares[i:] + lugares[:i]   # o da vez fica em primeiro
        yield q, list(lugares), list(areas)


# ── Montagem ─────────────────────────────────────────────────────────
def proximo_codigo():
    """O proximo numero livre de cada grupo, contando o que ja existe."""
    maior = defaultdict(int)
    for x in base:
        m = re.match(r'^(.+-N\d)-(\d+)$', x.get('codigo') or '')
        if m:
            maior[m.group(1)] = max(maior[m.group(1)], int(m.group(2)))

    def dar(slug, nivel):
        grupo = '%s-N%d' % (slug.upper().replace('-', ''), nivel)
        maior[grupo] += 1
        return '%s-%03d' % (grupo, maior[grupo])
    return dar


codigo = proximo_codigo()

decididas = [(q, *regra_n1(q)) for q in bruto if q['nivel'] == 1]
decididas += [(q, *regra_n2(q)) for q in bruto if q['nivel'] == 2]
decididas += list(regras_n3([q for q in bruto if q['nivel'] == 3]))

novas, fora = [], []
for q, lugares, areas in decididas:
    chave = (q['nivel'], q['secao'], q['num'])
    if chave in CORRECOES:
        errado, certo = CORRECOES[chave]
        assert errado in q['enunciado'], chave
        q['enunciado'] = q['enunciado'].replace(errado, certo)

    item = {'num': q['num'], 'enunciado': q['enunciado'], 'alts': q['alts'],
            'certa': q['certa'], 'lugares': lugares, 'areas': areas,
            'nivel': q['nivel'], 'vf': q['vf'], 'lote': LOTE}

    # Sem resposta marcada: entra no JSON (para nao se perder), mas SEM
    # codigo -- e o gerar_sql.py so importa quem tem codigo. Quando a
    # Medicina marcar, preencha "certa" e de o codigo do fim da fila.
    if isinstance(q['certa'], int):
        item['codigo'] = codigo(lugares[0], q['nivel'])
    else:
        fora.append(item)
    novas.append(item)

base += novas
json.dump(base, open(base_path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

print('mescladas: %d (%d com codigo, %d sem resposta marcada)'
      % (len(novas), len(novas) - len(fora), len(fora)))
for x in fora:
    print('  SEM RESPOSTA: nivel %d, %s nº %d -- %s'
          % (x['nivel'], x['lugares'][0], x['num'], x['enunciado'][:70]))
print()
print('por cenario x nivel:')
for (s, n), c in sorted(Counter((x['lugares'][0], x['nivel']) for x in novas if x.get('codigo')).items()):
    print('  %-15s n%d  %3d' % (s, n, c))
print()
print('por barra:', dict(Counter(a for x in novas if x.get('codigo') for a in x['areas'])))
