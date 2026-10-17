/* familias.js — sobrenome da família de cada casa (chave = número da casa, o `casa` de mapa.js).
   Usado por mapa.js e quiz.js; carregue antes deles. */

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

/* Descrição de cada família para o modal da casa (mesma chave). */
window.FAMILIAS_DESCRICAO = Object.freeze({
  1: 'É uma família animada que gosta muito de brincar e passear com seu cachorrinho Toddy, composta pela Amanda, Pedro e o Caio, filho deles de 7 anos. Eles gostam muito de sair no final de semana, passear na pracinha e jogarem futebol juntos.',
  2: 'É uma família tranquila e acolhedora, composta pelo Sr. Roberto e pela Sra. Márcia, um casal de idosos que gostam muito de passar tempo juntos e cuidar do seu gatinho Mike. Nos momentos de lazer, gostam de assistir televisão, participar das atividades físicas da UBS e fazer caminhadas pelo bairro.',
  3: 'É uma família alegre e unida, composta pelo Vinícios, Lívia e suas duas filhas, Maria, de 8 anos, e Luiza, de 4 anos. Eles gostam muito de passear em família, brincar com as crianças do bairro e aproveitar os finais de semana juntos.',
  4: 'É uma família carinhosa e divertida, composta pelo casal Ludmila e Isadora, com seu filho Lucas. Gostam muito de passar tempo juntos, assistir filmes e irem a oficinas de pintura na UBS nos finais de semana.',
  5: 'É uma família jovem e cheia de energia, composta por Thiago, Juliana e seus filhos, Sofia, de 10 anos, e Miguel, de 7 anos. Eles gostam muito de ouvir música, andar de skate na pracinha e jogar videogame juntos nos finais de semana.',
  6: 'É uma família afetuosa e cheia de histórias, composta pelos avós José e Cida, que cuidam com muito carinho dos netos Davi, de 8 anos, e Alice, de 6 anos. Eles gostam muito de cozinhar juntos, cuidar da hortinha do quintal e ouvir as histórias que o vovô conta depois do jantar.',
  7: 'É uma família carinhosa e animada, composta por André, Paula e seus filhos, Laura, de 6 anos, e o pequeno Theo, de 2 anos. Eles gostam muito de brincar no parquinho da pracinha, fazer piquenique no parque e contar histórias antes de dormir.',
  8: 'É uma família unida e descontraída, composta por Camila, Daniel e seu filho adolescente de 14 anos. Eles gostam muito de assistir filmes e séries juntos e sair para o museu ou parque de diversões nos finais de semana.',
  9: 'É uma família acolhedora e de muita fé, composta por Rafael, que trabalha como técnico de manutenção, Samira e seus filhos, Yasmin, de 9 anos, e Omar, de 6 anos. Eles gostam muito de preparar receitas tradicionais em família, receber os vizinhos para o jantar e passear no parque nos finais de semana.',
  10: 'É uma família grande, alegre e bastante unida, composta por Marcelo, Marina e seus quatro filhos: Pedro, de 7 anos, João, de 8 anos, que é atleta paraolímpico de basquete, Luana, de 5 anos, e Clara, de 4 anos. Eles gostam muito de brincar juntos, assistir filmes e fazer passeios em família nos finais de semana.',
  11: 'É uma família alegre e bastante unida, composta por Vitória (mãe solteira) e seus três filhos: Gabriel, de 7 anos, Amanda, de 5 anos, e Jennifer, de 3 anos. Eles gostam muito de brincar juntos, passear pela pracinha e aproveitar os momentos em família.',
  12: 'É uma família tranquila e companheira, composta pelo casal de idosos Bruno e Terezinha. Eles gostam de aproveitar o tempo juntos, cuidar da casa e fazer caminhadas pelo bairro 5 vezes por semana.',
  13: 'É uma família jovem e independente, composta pelo casal Lucas e Larissa, que são advogados. Nos momentos de lazer, gostam de viajar, conhecer lugares novos e sair para jantar juntos.',
  14: 'É uma família carinhosa e unida, composta pelo casal Antônio e Beatriz e suas filhas: Isabela de 13 anos e Ana de 9 anos, que possui deficiência visual. Eles gostam muito de ouvir música, passear em família e ler livros juntos no final de semana.',
  15: 'É uma família descolada e criativa, composta por Diego, Raquel e seus filhos, Valentina, de 9 anos, e Enzo, de 7 anos. Eles adoram rock, tocar instrumentos juntos na garagem de casa e ir a shows e feiras de quadrinhos nos finais de semana.',
  16: 'É uma família simples e trabalhadora, que veio do interior, composta por Joaquim, Rosa e seus filhos, Arthur, de 9 anos, e Cecília, de 6 anos. Eles gostam muito de música sertaneja, cuidar das plantas do quintal e participar das festas juninas da escola do bairro.',
  17: 'É uma família curiosa e estudiosa, composta por Ricardo, que é professor, Helena, que é bibliotecária, e seus filhos, Heitor, de 9 anos, e Manuela, de 6 anos. Eles gostam muito de visitar a biblioteca, montar quebra-cabeças e participar das feiras de ciências da escola do bairro.',
  18: 'É uma família esportista e animada, composta por Jorge, Tatiane e seus filhos, Kaique, de 8 anos, e Ayla, de 6 anos. Eles gostam muito de jogar basquete no campo de lazer, dançar juntos e torcer pelo time do bairro nos campeonatos.',
  19: 'É uma família tranquila e organizada, composta por Fernando, Carolina e seus filhos, Bernardo, de 9 anos, e Lara, de 7 anos. Eles gostam muito de cozinhar receitas saudáveis juntos, fazer as compras no mercado do bairro e andar de bicicleta no parque nos finais de semana.',
  20: 'É uma família alegre e festiva, composta por Sérgio, Daniela e seus filhos, Samuel, de 9 anos, e Luna, de 6 anos. Eles gostam muito de ir à praia, dançar forró nas festas da pracinha e nadar juntos nos finais de semana.',
});
