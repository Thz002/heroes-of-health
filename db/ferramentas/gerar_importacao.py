import importlib.util
import os
import re
import sys
import unicodedata
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

AQUI = os.path.dirname(os.path.abspath(__file__))


def carregar(nome):
    spec = importlib.util.spec_from_file_location(nome[:-3], os.path.join(AQUI, nome))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


cc = carregar('conferir_cenarios.py')
cb = cc.cb
mc = cc.mc

CRIADOR_SISTEMA = '00000000-0000-0000-0000-000000000000'
LETRAS = 'ABCDE'

PONTOS_PRINCIPAL = 10
PONTOS_SECUNDARIA = 5

# Áreas padrão por cenário, quando o arquivo original não diz.
AREAS_PADRAO = {
    'casa':           ['Saúde', 'Educação', 'Felicidade'],
    'creche':         ['Saúde', 'Felicidade', 'Limpeza'],
    'escola':         ['Educação', 'Saúde', 'Felicidade'],
    'farmacia':       ['Saúde', 'Educação', 'Vacinação'],
    'mercado':        ['Alimentação', 'Saúde', 'Educação'],
    'parque':         ['Saúde', 'Educação', 'Felicidade'],
    'praca':          ['Felicidade', 'Saúde', 'Educação'],
    'quadra':         ['Exercícios', 'Saúde', 'Felicidade'],
    'ubs':            ['Saúde', 'Educação', 'Vacinação'],
    'upa':            ['Saúde', 'Educação'],
    'corrego':        ['Limpeza', 'Saúde', 'Vetores'],
    'terreno-baldio': ['Limpeza', 'Vetores', 'Saúde'],
}


def aspas(s):
    if s is None:
        return 'null'
    return "'" + str(s).replace("'", "''") + "'"


def sigla(slug):
    """'terreno-baldio' -> 'TERRENO'. O código externo não leva hífen."""
    return re.sub(r'[^A-Z]', '', unicodedata.normalize('NFD', slug.upper()))[:9] or 'X'


def codigos_de(arquivo):
    """
    Os `codigo_externo` que uma geração anterior já escreveu.

    Depois que a importação roda, o banco deixa de saber o que faltava —
    e o gerador, que escolhe pela ausência, passaria a produzir um
    arquivo vazio. Com a lista de códigos do arquivo antigo ele refaz o
    MESMO conjunto, o que é o que se quer quando a correção foi no
    parser e não na escolha das questões.
    """
    with open(arquivo, encoding='utf-8') as f:
        return set(re.findall(r"^select '([A-Z]+-N\d-\d+)'", f.read(), re.M))


def montar(refazer=None):
    doc, originais, achadas, perdidas, sobrando, minha, atual, no_banco, propostas = cc.cruzar()

    cenario_da_equipe = {}
    areas_da_equipe = {}
    for q, o in achadas:
        if o['cenarios']:
            cenario_da_equipe[id(q)] = o['cenarios'][0]
        if o['areas']:
            areas_da_equipe[id(q)] = o['areas']

    # Pula o que já está no banco (exceto o que a geração anterior inseriu).
    ja_tem = {cb.normalizar(l['enunciado']) for l in no_banco
              if not (refazer and l.get('codigo_externo') in refazer)}

    # Ao refazer, reaproveita código e cenário da geração anterior; a chave inclui o nível.
    antes = {}
    if refazer:
        for l in no_banco:
            if l.get('codigo_externo') in refazer:
                antes[(l['nivel_etario'], cb.normalizar(l['enunciado']))] = (
                    l['codigo_externo'], cc.SLUG_POR_ID.get(l['cenario_id']))

    # Próximo número livre de cada (cenário, nível), lendo o que já existe.
    usado = defaultdict(int)
    for l in no_banco:
        codigo = l.get('codigo_externo') or ''
        if refazer and codigo in refazer:
            continue
        m = re.match(r'^([A-Z]+)-N(\d)-(\d+)$', codigo)
        if m:
            chave = (m.group(1), int(m.group(2)))
            usado[chave] = max(usado[chave], int(m.group(3)))

    novas, fontes = [], Counter()

    for q in doc:
        if cb.normalizar(q['enunciado']) in ja_tem:
            continue

        gravado = antes.get((q['nivel'], cb.normalizar(q['enunciado'])))

        slug = cenario_da_equipe.get(id(q))
        if slug:
            fontes['equipe'] += 1
        else:
            slug = (gravado[1] if gravado else None) or minha.get(cb.normalizar(q['enunciado']))
            fontes['deduzido'] += 1

        if not slug:
            fontes['sem cenário'] += 1
            continue

        areas = areas_da_equipe.get(id(q)) or AREAS_PADRAO.get(slug) or ['Saúde', 'Educação']

        if gravado:
            codigo = gravado[0]
        else:
            chave = (sigla(slug), q['nivel'])
            usado[chave] += 1
            codigo = f'{chave[0]}-N{q["nivel"]}-{usado[chave]:03d}'

        novas.append({
            'codigo': codigo,
            'cenario': slug, 'nivel': q['nivel'],
            'enunciado': q['enunciado'],
            'opcoes': q['opcoes'], 'resposta': q['resposta'],
            'acerto': q['acerto'], 'erro': q['erro'],
            'areas': areas,
            'origem': 'equipe' if id(q) in cenario_da_equipe else 'deduzido',
        })

    return novas, fontes, atual


def gerar(novas, destino):
    L = ["""-- =====================================================================
--  AS QUESTÕES QUE FALTAVAM — gerado por db/ferramentas/gerar_importacao.py
--
--  NÃO EDITE À MÃO. Para refazer:
--      python db/ferramentas/gerar_importacao.py --sql db/importar-faltantes.sql
--
--  TRÊS FONTES JUNTAS:
--    "todas as questões.docx"  enunciado, alternativas, gabarito e os
--                              dois feedbacks (acerto e erro)
--    os arquivos soltos        o cenário e as áreas de pontuação
--    o banco                   o que já estava lá, para não duplicar
--
--  O cenário vem do arquivo original sempre que a questão aparece em
--  algum deles. Para as que não aparecem em nenhum, vem da dedução por
--  assunto — essas estão marcadas com "deduzido" no comentário da linha.
--
--  IDEMPOTENTE: a chave é `codigo_externo`. Rodar duas vezes atualiza as
--  mesmas linhas em vez de criar cópias.
--
--  Onde rodar: SQL Editor do Supabase, COM NADA SELECIONADO.
--  Antes dele, rode db/feedback-questoes.sql (cria explicacao_erro).
-- =====================================================================

"""]

    por_cenario = defaultdict(list)
    for n in novas:
        por_cenario[n['cenario']].append(n)

    for slug in sorted(por_cenario):
        grupo = por_cenario[slug]
        equipe = sum(1 for g in grupo if g['origem'] == 'equipe')

        L.append(f"\n-- ── {slug.upper()} — {len(grupo)} questões "
                 f"({equipe} com cenário da equipe, {len(grupo) - equipe} deduzidas) ──\n")

        for n in grupo:
            ops = list(n['opcoes']) + [None] * (5 - len(n['opcoes']))
            marca = '' if n['origem'] == 'equipe' else '   -- cenário deduzido'

            L.append(f"""insert into questoes
  (codigo_externo, cenario_id, nivel_etario, enunciado,
   opcao_a, opcao_b, opcao_c, opcao_d, opcao_e,
   resposta_correta, explicacao, explicacao_erro, criado_por)
select {aspas(n['codigo'])}, c.id, {n['nivel']}, {aspas(n['enunciado'])},{marca}
  {aspas(ops[0])}, {aspas(ops[1])}, {aspas(ops[2])}, {aspas(ops[3])}, {aspas(ops[4])},
  {aspas(n['resposta'])}, {aspas(n['acerto'])}, {aspas(n['erro'])},
  {aspas(CRIADOR_SISTEMA)}
from cenarios c where c.slug = {aspas(slug)}
on conflict (codigo_externo) do update set
  enunciado = excluded.enunciado,
  opcao_a = excluded.opcao_a, opcao_b = excluded.opcao_b,
  opcao_c = excluded.opcao_c, opcao_d = excluded.opcao_d,
  opcao_e = excluded.opcao_e,
  resposta_correta = excluded.resposta_correta,
  explicacao = excluded.explicacao,
  explicacao_erro = excluded.explicacao_erro;
""")

    # ── as áreas ────────────────────────────────────────────────────
    L.append("""

-- =====================================================================
--  EM QUE BARRAS CADA QUESTÃO PONTUA
--
--  Sem uma linha aqui, acertar a questão não move barra nenhuma — e sem
--  erro nenhum, só silêncio. A primeira área vale 10 pontos e as demais
--  5; a calibragem final não depende desses números, porque
--  recalcular_metas() refaz as metas no fim do arquivo.
-- =====================================================================
""")

    for slug in sorted(por_cenario):
        for n in por_cenario[slug]:
            for i, area in enumerate(n['areas']):
                pts = PONTOS_PRINCIPAL if i == 0 else PONTOS_SECUNDARIA
                L.append(
                    f"insert into questoes_areas (questao_id, area_nome, pontos)\n"
                    f"select q.id, {aspas(area)}, {pts} from questoes q "
                    f"where q.codigo_externo = {aspas(n['codigo'])}\n"
                    f"on conflict (questao_id, area_nome) do update set pontos = excluded.pontos;\n")

    L.append("""

-- As metas das oito barras são a soma de tudo o que cada área pode
-- render. Com conteúdo novo entrando, elas precisam ser refeitas — e as
-- porcentagens de quem já jogou vão junto, senão um aluno fica com 100%
-- numa barra cuja régua acabou de crescer.
select public.recalcular_metas();

notify pgrst, 'reload schema';
""")

    with open(destino, 'w', encoding='utf-8') as f:
        f.write('\n'.join(L))


if __name__ == '__main__':
    refazer = None
    if '--refazer' in sys.argv:
        refazer = codigos_de(sys.argv[sys.argv.index('--refazer') + 1])
        print(f'\n  refazendo o mesmo conjunto: {len(refazer)} códigos')

    novas, fontes, atual = montar(refazer)

    print('\n╔══ A IMPORTAÇÃO ═════════════════════════════════════════╗\n')
    print(f'  questões a inserir : {len(novas)}')
    print(f'    cenário da equipe: {fontes["equipe"]}')
    print(f'    cenário deduzido : {fontes["deduzido"]}')
    if fontes['sem cenário']:
        print(f'    SEM cenário      : {fontes["sem cenário"]}  (não entram)')

    print('\n  por cenário e nível:')
    grade = defaultdict(Counter)
    for n in novas:
        grade[n['cenario']][n['nivel']] += 1
    for slug in sorted(grade, key=lambda s: -sum(grade[s].values())):
        c = grade[slug]
        print(f'      {slug:<16} nv1:{c[1]:>4}  nv2:{c[2]:>4}  nv3:{c[3]:>4}   total {sum(c.values()):>4}')

    if '--sql' in sys.argv:
        destino = sys.argv[sys.argv.index('--sql') + 1]
        gerar(novas, destino)
        tam = os.path.getsize(destino)
        print(f'\n  gravado: {destino}  ({tam // 1024} KB)')
