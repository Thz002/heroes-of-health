# Ferramentas de conversão das perguntas

Estes dois scripts **não fazem parte do jogo** e nunca rodam junto com ele.
Não conectam no banco, não têm chave nenhuma. São conversores que rodam na
sua máquina e produzem um arquivo `.sql` — só isso.

```
.docx da Medicina  →  parser.py  →  questoes_extraidas.json  →  gerar_sql.py  →  .sql
                                                                                  ↓
                                                    você cola no SQL Editor do Supabase
```

## Quando usar

Praticamente nunca. Eles existem para **um lote novo de perguntas** — hoje
falta o nível 3 (15 a 18 anos), que a equipe ainda não escreveu.

```bash
python parser.py                       # usa OneDrive/Documentos/Questions
python parser.py "C:/outra/pasta"      # se os .docx mudarem de lugar
python gerar_sql.py ../importar-n3.sql # SEMPRE em um arquivo novo
```

## O que NÃO fazer

**Não gere por cima de `db/importar-questoes.sql`.** Aquele arquivo já é a
fonte da verdade das explicações, escritas à mão. Regenerar em cima devolve
todos os placeholders e apaga o trabalho da Medicina.

Para um lote novo, passe outro nome de arquivo — é o argumento do
`gerar_sql.py`.

## Por que guardar isso

O `parser.py` carrega conhecimento que não está escrito em lugar nenhum:
que a resposta certa está marcada **pela cor verde do texto**, que cada
`.docx` usa um verde diferente, e onde fica a linha do cenário em cada
formato. Sem ele, converter o próximo lote significa redescobrir tudo isso.

Requer Python 3 — que o resto do projeto não usa.

---

## Atualização: o segundo lote

Chegaram mais dois arquivos, em formatos diferentes dos primeiros, e por
isso existe o `parser_lote2.py`. O `parser.py` **não** entende esses.

```
parser.py        -> os 2 .docx originais   -> questoes_extraidas.json
parser_lote2.py  -> os lotes novos          -> novos_extraidos.json
                                                (precisa ser MESCLADO)
gerar_sql.py     -> questoes_extraidas.json -> db/importar-questoes.sql
```

### A regra que não pode ser esquecida

Cada questão carrega um campo **`codigo`** no JSON, e ele **nunca muda
depois de gravado no banco**. Antes o código vinha da posição na lista —
e isso quase causou um estrago: aceitar as questões de Verdadeiro/Falso
inseriu linhas no meio da lista, o que teria empurrado o código de todas
as seguintes. O import então sobrescreveria uma pergunta com o texto de
outra, em silêncio, e as respostas dos alunos passariam a apontar para
perguntas diferentes das que eles responderam.

Ao mesclar um lote novo: **acrescente no fim** e dê código apenas às que
ainda não têm. Nunca renumere.

### ⚠️ O `questoes_extraidas.json` virou insubstituível

O `.docx` de 7 a 10 anos **saiu da pasta do OneDrive**. As 76 questões
daquele lote existem hoje só dentro do JSON — não há como regerá-las.

Duas consequências: **o JSON é fonte, não cache** (versione, não apague),
e **guarde os `.docx` originais** em algum lugar estável.

---

## Atualização: o terceiro lote (outubro de 2026)

Três `.docx` novos (7–10, 11–14 e o primeiro nível 3), cada um num formato
diferente — e diferentes dos lotes anteriores também. O caminho agora tem
três passos, e a decisão de cenário e barra ficou num arquivo só dela:

```
parser_lote3.py  -> os 3 .docx               -> lote3_bruto.json   (só lê)
montar_lote3.py  -> lote3_bruto.json         -> questoes_extraidas.json
                    (cenário, barras, código; acrescenta no fim, com "lote": 3)
gerar_sql.py ../importar-lote3.sql --lote 3  -> db/importar-lote3.sql
```

O que estes arquivos ensinam, e que não estava escrito em lugar nenhum:

- **A resposta certa nem sempre é verde.** No 11–14 ela vem em **negrito**
  (o enunciado também é negrito; a certa é a única *outra* linha em negrito).
- **Verdadeiro/Falso pode vir sem alternativa nenhuma**: só a frase, pintada
  de verde (verdadeira) ou de vermelho (falsa).
- **Duas alternativas podem dividir um parágrafo** ("A) ... B) ..."), e a
  letra pode estar num pedaço de texto e o ")" no seguinte. Por isso o
  parser lê letra a letra, com o negrito e a cor de cada uma.
- **O nível 3 tem cinco alternativas (A a E)**, no formato do ENEM. O banco
  ganhou a coluna `opcao_e` para isso (`setup.sql`), e o `gerar_sql.py`
  aceita 2, 4 ou 5.

Sem `--lote`, o `gerar_sql.py` continua gerando só os dois primeiros lotes,
exatamente como antes — conferido: regerar o `importar-questoes.sql` dá o
mesmo arquivo, mudando só a coluna `opcao_e` (nula) nos inserts.

O `montar_lote3.py` recusa rodar duas vezes: os códigos já estão no JSON.
As duas questões que vieram sem resposta marcada (7–10, UBS nº 12 e UPA
nº 14) estão no JSON **sem código**; quando a Medicina marcar, preencha
`certa`, dê o próximo código livre do grupo e gere de novo.
