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
