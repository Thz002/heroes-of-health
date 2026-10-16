# Artes das insígnias

Esta pasta guarda o desenho de cada insígnia da estante
(`src/pages/conquistas.html`) e do resumo dela no perfil.

## Como ligar uma arte a uma insígnia

A tela **não tem lista de arquivos escrita em lugar nenhum**. Ela lê a
coluna `imagem` da tabela `insignias`, no banco, e quem preenche essa
coluna é o **`db/insignias.sql`**, junto com o resto do catálogo.

Para trocar ou acrescentar uma arte:

1. Salvar o arquivo aqui.
2. Pôr o nome dele na linha da insígnia em `db/insignias.sql`.
3. Rodar o `db/insignias.sql` de novo no SQL Editor do Supabase.

O nome do arquivo **não precisa** ser igual ao `codigo` da insígnia: a
ligação é a coluna `imagem`. Enquanto ela for nula, a tela desenha a
inicial do nome no lugar da arte.

## As séries de arquivos

| arquivos | insígnias | regra | marcos |
|---|---|---|---|
| `perguntas1..5.png` | Primeiros Passos, Pé na Estrada, Meio Caminho, Centurião, Enciclopédia | perguntas certas, em qualquer lugar | 10, 25, 50, 100, 200 |
| `diaria1..3.png` | De Volta, Semana Cheia, Presença de Ouro | dias seguidos de entrada | 3, 7, 30 |
| `missoes1..4.png` | Primeira Parada, Volta no Quarteirão, Conhece Cada Esquina, Mapa na Cabeça | missões concluídas pelos lugares | 1, 5, 25, 50 |
| `tvs.png`, `hqs.png`, `all-hqs.png`, `calendar.png` | Sintonizado, Balão de Fala, Até a Última Página, Toda Cor Tem Causa | segredos achados no mapa (regra `DESCOBERTA`) | — |
| `<lugar>1..3.png` | três por lugar, tabela abaixo | perguntas certas naquele lugar | 5, 25, 50 |

"Missão concluída pelos lugares" é cada lugar de um quiz concluído: um
quiz com perguntas da UBS, da Escola e do Mercado vale 3.

### Os segredos do mapa

Objetos clicáveis dentro das fotos da banca e da farmácia. Cada um dá a
sua insígnia na hora em que é achado — não há contagem:

| arquivo | insígnia | segredo |
|---|---|---|
| `tvs.png` | Sintonizado | a TV da banca (os vídeos da Fiocruz) |
| `hqs.png` | Balão de Fala | as HQs, nas pilhas de jornal da banca |
| `all-hqs.png` | Até a Última Página | chegar à última HQ |
| `calendar.png` | Toda Cor Tem Causa | o Calendário das Cores, na farmácia |

Enquanto não as tem, quem abre a banca ou a farmácia vê uma dica com a
arte em silhueta — por isso vale a mesma regra da estante: o desenho
precisa se reconhecer sem cor.

### Os lugares: três degraus que se sobrepõem

Cada lugar do bairro é **uma peça só** na estante. Os três degraus
(5, 25 e 50 acertos) ficam no mesmo `grupo`, e a estante mostra o mais
alto já conquistado, com a arte dele. Três pontinhos embaixo do nome
dizem quantos degraus já caíram.

| arquivos | lugar (slug) | 5 / 25 / 50 acertos |
|---|---|---|
| `ubs1..3.png` | UBS (`ubs`) | Porta de Entrada / Prontuário em Dia / Coração do SUS |
| `escola1..3.png` | Escola (`escola`) | Lição Aprendida / Nota Dez / Quadro de Honra |
| `casa1..3.png` | Casa (`casa`) | Porta Aberta / Visita em Dia / Gente de Casa |
| `mercado1..3.png` | Mercado (`mercado`) | Lista de Compras / Rótulo Decifrado / Prato Colorido |
| `farmacia1..3.png` | Farmácia (`farmacia`) | Receita Certa / Dose Exata / Carteirinha em Dia |
| `upa1..3.png` | UPA (`upa`) | Sinal de Alerta / Triagem Afiada / Sangue Frio |
| `creche1..3.png` | Creche (`creche`) | Primeiros Cuidados / Caderneta em Dia / Colo Seguro |
| `praca1..3.png` | Pracinha (`praca`) | Sombra e Água Fresca / Roda de Conversa / Alma da Praça |
| `campo-lazer1..3.png` | Campo de lazer (`quadra`) | Aquecimento / Segundo Tempo / Camisa 10 |
| `parque1..3.png` | Parque (`parque`) | Trilha Limpa / Lixeira Certa / Pulmão Verde |
| `corrego1..3.png` | Córrego (`corrego`) | Fio d'Água / Correnteza / Nascente Protegida |
| `terreno-baldio1..3.png` | Terreno baldio (`terreno-baldio`) | Lixo no Lugar / Fim do Foco / Terreno Transformado |
| `rio1..3.png` | Rio (`rio`) | Margem Limpa / Mutirão / Rio Vivo |
| `ruas1..3.png` | Ruas (`ruas`) | Passo a Passo / Lixo por Cor / Rua Exemplar |
| `banca1..3.png` | Banca de jornal (`banca`) | Leitura do Dia / Fato ou Fake / Primeira Página |
| `centro-religioso1..3.png` | Centro religioso (`igreja`) | Escuta Atenta / Ombro Amigo / Porto Seguro |

Rio, Ruas, Banca e Centro religioso ainda não são cenário no banco nem
têm perguntas, então as peças deles aparecem bloqueadas até isso mudar.

## Especificação do arquivo

| | |
|---|---|
| Formato | **PNG com fundo transparente** |
| Proporção | livre — a medalha é encaixada inteira num quadrado de 74 px, sem esticar e sem recorte |
| Tamanho | ~300 px no lado maior basta (a tela desenha a 74 px) |
| Peso | o menor possível: a estante carrega uma arte por peça de uma vez |

## Os dois estados

A mesma arte serve para os dois — a tela aplica os efeitos sozinha:

- **Conquistada** — cores cheias, anel dourado, leve brilho
- **Bloqueada** — a mesma imagem em silhueta escura e sem cor
  (`filter: grayscale(1) brightness(0.4)`), com o anel mostrando quanto
  falta

Então **não é preciso entregar duas versões**. Mas vale testar a arte em
silhueta: um desenho que depende só de cor para ser reconhecido vira uma
mancha quando fica cinza.

## Estante do professor

Existe e está vazia de propósito: as regras dele (`QUIZZES` e
`ACERTOS_TURMA`) já são aceitas pelo banco, mas nenhuma insígnia foi
combinada ainda. Quando forem, entram como linhas novas em
`db/insignias.sql` com `publico = 'PROFESSOR'`, e as artes vêm para esta
mesma pasta.
