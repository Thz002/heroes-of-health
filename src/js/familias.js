/* familias.js — o sobrenome da família que mora em cada casa do mapa.

   A chave é o número da casa: o campo `casa` dos HOTSPOTS em mapa.js,
   o mesmo que vai na URL da missão (?casa=3) e escolhe a imagem
   (src/imgs/familias/familia03.png). Mudar um número aqui troca a
   família de casa nas duas telas, no mapa e na missão.

   Lido por mapa.js ("Casa da família Alves") e por quiz.js
   ("Família Alves", embaixo da imagem). Carregue antes deles. */

window.FAMILIAS = Object.freeze({
  1: 'Alves',
  2: 'Souza',
  3: 'Silveira',
  4: 'Oliveira',
  5: 'Costa',
  6: 'Pereira',
  7: 'Rodrigues',
  8: 'Duarte',
  9: 'Lima',
  10: 'Ferreira',
  11: 'Silva',
  12: 'Motta',
  13: 'Albuquerque',
  14: 'Andrade',
  15: 'Carvalho',
  16: 'Ribeiro',
  17: 'Gomes',
  18: 'Martins',
  19: 'Barbosa',
  20: 'Nascimento',
});
