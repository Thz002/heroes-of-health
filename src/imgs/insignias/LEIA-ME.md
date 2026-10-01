# Artes das insígnias

Esta pasta guarda o desenho de cada insígnia da estante
(`src/pages/conquistas.html`).

## Como ligar uma arte a uma insígnia

A tela **não tem lista de arquivos escrita em lugar nenhum**. Ela lê a
coluna `imagem` da tabela `insignias`, no banco. Então são dois passos:

1. Salvar o arquivo aqui, com o nome igual ao `codigo` da insígnia.
2. Preencher a coluna no banco:

```sql
update insignias set imagem = 'centuriao.png' where codigo = 'centuriao';
```

Enquanto `imagem` for nulo, a tela desenha um espaço vazio com a inicial
do nome — a estante funciona sem arte nenhuma, e cada arquivo que chega
substitui um espaço.

## Os códigos que existem hoje

| arquivo esperado | insígnia | conquista-se com |
|---|---|---|
| `primeiros-passos.png` | Primeiros Passos | 10 perguntas certas |
| `pe-na-estrada.png` | Pé na Estrada | 25 perguntas certas |
| `meio-caminho.png` | Meio Caminho | 50 perguntas certas |
| `centuriao.png` | Centurião | 100 perguntas certas |
| `enciclopedia.png` | Enciclopédia | 200 perguntas certas |
| `de-volta.png` | De Volta | 3 dias seguidos |
| `semana-cheia.png` | Semana Cheia | 7 dias seguidos |
| `presenca-de-ouro.png` | Presença de Ouro | 30 dias seguidos |
| `primeira-missao.png` | Primeira Missão | 1 tarefa concluída |
| `missao-cumprida.png` | Missão Cumprida | 10 tarefas concluídas |

A lista de verdade é a tabela. Para conferir:

```sql
select codigo, nome, descricao, regra, alvo, imagem
  from insignias order by publico, ordem;
```

## Especificação do arquivo

| | |
|---|---|
| Formato | **PNG com fundo transparente** |
| Tamanho | **256 × 256 px** |
| Área segura | o desenho deve caber num círculo de 230 px no centro |
| Peso | até ~80 KB por arquivo |

**Por que transparente e quadrado:** a tela recorta a imagem num círculo
e desenha o anel dourado por fora. Um fundo opaco apareceria como um
quadrado dentro do círculo; uma imagem retangular ficaria esticada.

**Por que a área segura:** a insígnia bloqueada é desenhada menor e com
um anel de progresso por cima da borda. Desenho que encosta na margem
fica cortado nesse estado.

## Os dois estados

A mesma arte serve para os dois — a tela aplica os efeitos sozinha:

- **Conquistada** — cores cheias, anel dourado, leve brilho
- **Bloqueada** — a mesma imagem em silhueta escura e sem cor
  (`filter: grayscale(1) brightness(0.4)`), com o anel mostrando quanto
  falta

Então **não é preciso entregar duas versões**. Mas vale testar a arte em
silhueta: um desenho que depende só de cor para ser reconhecido vira uma
mancha quando fica cinza. Formas com contorno claro funcionam melhor.

## Estante do professor

Existe e está vazia de propósito: as regras dele (`QUIZZES` e
`ACERTOS_TURMA`) já são aceitas pelo banco, mas nenhuma insígnia foi
combinada ainda. Quando forem, entram como linhas novas em `insignias`
com `publico = 'PROFESSOR'`, e as artes vêm para esta mesma pasta.
