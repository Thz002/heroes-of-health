-- =====================================================================
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


-- ── ALTERNATIVAS REESCRITAS ──────────────────────────────────────
-- Chegaram ao banco com uma alternativa a menos e o nome do cenário
-- no lugar da última. As letras andaram uma casa e o gabarito passou
-- a apontar o texto errado.
--
--   id 120   nv1   Lucas terminou de brincar no parquinho e está na hora do lan…
--   id 121   nv1   SAMU quer ajudar o maior número de pessoas possível, mesmo e…
--   id 125   nv1   A frase "O corpo humano é uma máquina feita para o movimento…
--   id 497   nv3   A maior incidência de hepatite A em regiões com saneamento p…


update questoes set
  explicacao = 'Isso mesmo! O mosquito Aedes aegypti coloca os ovos em água parada. Quando você retira os recipientes que podem juntar água, ele não tem onde se reproduzir e o bairro fica mais protegido.',
  explicacao_erro = 'Quase lá! Pense: onde o mosquito da dengue deixa os ovos? Ele aproveita a água parada. Tente de novo, você consegue!'
where id = 1;

update questoes set
  explicacao = 'Correto! Depois da chuva, a água pode ficar parada em baldes, pneus e vasos, e esse é o lugar perfeito para o Aedes aegypti colocar ovos. Esvaziar os recipientes impede que ele se reproduza.',
  explicacao_erro = 'Boa tentativa! Lembre-se: o que o mosquito da dengue procura para colocar seus ovos? Releia a pergunta com calma. Vamos tentar novamente?'
where id = 2;

update questoes set
  explicacao = 'Excelente! De outubro a maio costuma ser mais quente e chover mais, e esse clima ajuda o Aedes aegypti a se reproduzir. Por isso, nessa época, precisamos redobrar os cuidados.',
  explicacao_erro = 'Quase! Pense no tempo: com calor e chuva, o que acontece com a água parada e com os mosquitos? Vamos tentar novamente?'
where id = 3;

update questoes set
  explicacao = 'Certo! Depois de comer, restos de comida ficam nos dentes e as bactérias podem estragá-los. Escovar sempre que comer e antes de dormir mantém os dentes fortes e saudáveis.',
  explicacao_erro = 'Não desanime! As bactérias adoram restos de comida. Pense: quando os dentes ficam sujos? E à noite, enquanto dormimos? Vamos tentar novamente?'
where id = 4;

update questoes set
  explicacao = 'Parabéns! Lavar as mãos é um ato de cuidado: protege você e também seus colegas, sua família e todos ao seu redor, porque os microrganismos não passam adiante.',
  explicacao_erro = 'Quase! Quando as mãos ficam limpas, os microrganismos deixam de passar para outras pessoas. Então, quem fica protegido? Vamos tentar novamente?'
where id = 5;

update questoes set
  explicacao = 'Isso! Para funcionar de verdade, é preciso usar água e sabão e esfregar bem todas as partes das mãos: palmas, costas, entre os dedos, unhas e polegares. Assim os microrganismos saem.',
  explicacao_erro = 'Não desista! Lavar muito rápido ou só com água não é suficiente. Pense num jeito cuidadoso de limpar todas as partes das mãos. Vamos tentar novamente?'
where id = 6;

update questoes set
  explicacao = 'Muito bem! Papel, metal, plástico e vidro podem ser reciclados. Restos de comida, terra e folhas seguem para outro tipo de descarte. Cada material no lugar certo!',
  explicacao_erro = 'Boa tentativa! Alguns materiais podem virar produtos novos. Quais são os quatro principais? Pense nas lixeiras coloridas da coleta seletiva. Vamos tentar novamente?'
where id = 7;

update questoes set
  explicacao = 'Isso! O vidro pode quebrar e machucar os trabalhadores da coleta. Por isso o cuidado mais importante é protegê-lo para evitar acidentes. Cuidar do outro também faz parte de reciclar!',
  explicacao_erro = 'Quase! Pense nas pessoas que recolhem o lixo: o que pode acontecer com elas se o vidro quebrar? Vamos tentar novamente?'
where id = 8;

update questoes set
  explicacao = 'Muito bem! Limpar as embalagens, tirando restos de comida e líquidos, evita mau cheiro e contaminação e ajuda na reciclagem.',
  explicacao_erro = 'Não desista! Embalagens com restos de comida atrapalham a reciclagem. O que devemos fazer com elas antes de separar? Vamos tentar novamente?'
where id = 9;

update questoes set
  explicacao = 'Correto! Na coleta "porta a porta", os moradores separam os recicláveis e deixam na calçada para o caminhão recolher. Fácil e prático!',
  explicacao_erro = 'Boa tentativa! "Porta a porta" quer dizer que o caminhão passa pelas ruas. Onde os moradores deixam os recicláveis para ele recolher? Vamos tentar novamente?'
where id = 10;

update questoes set
  explicacao = 'Certo! Durante o sono, o corpo recupera as energias e a mente descansa, para termos disposição no dia seguinte.',
  explicacao_erro = 'Boa tentativa! Dormir bem faz muito bem. Como você se sente depois de uma boa noite de sono? Vamos tentar novamente?'
where id = 11;

update questoes set
  explicacao = 'Isso! Um adulto de confiança é alguém responsável por você, como um familiar, um professor ou outro adulto em quem você confia, que escuta e cuida de você. Pedir ajuda é uma atitude corajosa.',
  explicacao_erro = 'Boa tentativa! Pense em pessoas que cuidam de você no dia a dia e que você conhece bem. Vamos tentar novamente?'
where id = 12;

update questoes set
  explicacao = 'Isso mesmo! Seu corpo merece respeito. Se uma situação deixar você inseguro ou desconfortável, peça ajuda a um adulto de confiança.',
  explicacao_erro = 'Quase! Procure a frase que lembra que o seu corpo merece respeito e que existe ajuda quando algo nos incomoda. Releia com calma. Vamos tentar novamente?'
where id = 13;

update questoes set
  explicacao = 'Muito bem! Mesmo que alguém faça ameaças, a criança deve contar para um adulto de confiança. Quem ameaça está errado, e os adultos podem proteger você.',
  explicacao_erro = 'Não desanime! Quem ameaça quer que a criança fique em silêncio. O que ajuda a criança a ficar segura? Vamos tentar novamente?'
where id = 14;

update questoes set
  explicacao = 'Muito bem! Se um adulto não acreditar de primeira, não desista: continue procurando e contando para outros adultos de confiança até alguém ajudar. Você merece ser ouvido.',
  explicacao_erro = 'Não desanime! Mesmo que a primeira pessoa não ajude, a culpa não é sua. O que você pode fazer para ser ouvido? Vamos tentar novamente?'
where id = 15;

update questoes set
  explicacao = 'Muito bem! O trabalho infantil tira o tempo da criança para estudar, brincar, descansar e crescer bem.',
  explicacao_erro = 'Quase! Pense no que a criança precisa para crescer bem: estudar, brincar e descansar. O que o trabalho tira dela? Vamos tentar novamente?'
where id = 16;

update questoes set
  explicacao = 'Certo! Organizar os próprios brinquedos e arrumar o quarto são tarefas leves, que ensinam autonomia e não atrapalham os estudos nem as brincadeiras.',
  explicacao_erro = 'Quase! Escolha a atividade que é saudável e leve para uma criança, sem tirar o tempo de estudar e de brincar. Vamos tentar novamente?'
where id = 17;

update questoes set
  explicacao = 'Isso! Quando a criança passa muitas horas em afazeres domésticos, ela perde o tempo de estudar, brincar e descansar. Ajudar um pouquinho em casa é bom, mas o excesso atrapalha.',
  explicacao_erro = 'Quase! Pense no que falta para uma criança que passa muitas horas fazendo tarefas de casa. Vamos tentar novamente?'
where id = 18;

update questoes set
  explicacao = 'Isso aí! O intestino grosso absorve a água que sobrou da digestão e compacta o que não foi aproveitado, formando as fezes.',
  explicacao_erro = 'Não foi dessa vez. Lembre-se de que a maior parte da digestão já aconteceu antes do intestino grosso. O que ele faz com o restante? Vamos tentar novamente?'
where id = 19;

update questoes set
  explicacao = 'Exato! Cada irmão herda uma combinação diferente dos genes de pai e mãe, por isso podem ser parecidos, mas nunca idênticos (exceto gêmeos idênticos).',
  explicacao_erro = 'Quase lá! Pense em como os genes do pai e da mãe se combinam em cada filho. Vamos tentar novamente?'
where id = 20;

update questoes set
  explicacao = 'Boa! O óleo usado deve ser guardado em garrafa fechada e levado a um ponto de coleta. Um litro de óleo pode poluir milhões de litros de água.',
  explicacao_erro = 'Quase! O óleo de cozinha polui rios e entope encanamentos. Qual é o destino correto? Vamos tentar novamente?'
where id = 21;

update questoes set
  explicacao = 'Correto! Pilhas, baterias e lâmpadas têm substâncias tóxicas e precisam de pontos de coleta específicos (logística reversa), para não contaminar solo e água.',
  explicacao_erro = 'Não foi dessa vez. Esses itens contêm substâncias perigosas. Onde devem ser descartados? Vamos tentar novamente?'
where id = 22;

update questoes set
  explicacao = 'Correto! Lavar as mãos de 40 a 60 segundos, esfregando palmas, dorso, entre os dedos, polegares e unhas, é a recomendação da Anvisa e da OMS.',
  explicacao_erro = 'Quase! Lavar bem leva mais tempo do que um instante, mas bem menos que minutos. Vamos tentar novamente?'
where id = 23;

update questoes set
  explicacao = 'Exato! Escova de dentes, toalha e lâmina de barbear têm contato com fluidos do corpo e podem transmitir germes. São itens de uso pessoal.',
  explicacao_erro = 'Não foi dessa vez. Pense em objetos de higiene pessoal que têm contato direto com o corpo. Vamos tentar novamente?'
where id = 24;

update questoes set
  explicacao = 'Correto! Escovar os dentes e usar fio dental removem a placa bacteriana e previnem cárie e doenças da gengiva.',
  explicacao_erro = 'Quase! Pense no que acontece com os dentes e gengivas quando a placa bacteriana se acumula. Vamos tentar novamente?'
where id = 25;

update questoes set
  explicacao = 'Correto! Quintal limpo, sem entulho, e ralos e frestas vedados, dificultam a entrada e o esconderijo de escorpiões.',
  explicacao_erro = 'Não foi dessa vez. Escorpiões procuram abrigo e alimento. O que dificultaria a vida deles? Vamos tentar novamente?'
where id = 26;

update questoes set
  explicacao = 'Correto! A pele é o maior órgão do corpo, protege contra germes e é responsável pelo tato.',
  explicacao_erro = 'Não foi dessa vez. Pense no órgão que cobre todo o corpo e nos permite sentir o toque. Vamos tentar novamente?'
where id = 27;

update questoes set
  explicacao = 'Boa! O coração é um músculo que bombeia o sangue para todo o corpo, levando oxigênio e nutrientes às células.',
  explicacao_erro = 'Quase! Pense no órgão muscular que bate sem parar e faz o sangue circular. Vamos tentar novamente?'
where id = 28;

update questoes set
  explicacao = 'Correto! Além da audição, a orelha interna participa do equilíbrio do corpo.',
  explicacao_erro = 'Não foi dessa vez. Dentro da orelha há estruturas que nos ajudam a não cair. Qual função é essa? Vamos tentar novamente?'
where id = 29;

update questoes set
  explicacao = 'Correto! Lavar as mãos várias vezes ao dia, principalmente antes de comer, tira os microrganismos que a gente não vê e protege você e as pessoas que estão perto.',
  explicacao_erro = 'Quase! As mãos encostam em muitas coisas durante o dia. Será que lavar uma vez só é suficiente? Pense em quando elas vão perto da boca. Vamos tentar novamente?'
where id = 30;

update questoes set
  explicacao = 'Isso! Lavar as mãos de forma correta e frequente é a medida mais importante para evitar que os microrganismos se espalhem. Um gesto simples que protege muita gente.',
  explicacao_erro = 'Boa tentativa! Os microrganismos ficam nas nossas mãos. Qual hábito simples, com água e sabão, os especialistas mais recomendam? Vamos tentar novamente?'
where id = 31;

update questoes set
  explicacao = 'Muito bem! Os microrganismos são tão pequenos que não conseguimos enxergar, mas eles continuam nas mãos mesmo quando elas parecem limpas. Por isso lavamos sempre.',
  explicacao_erro = 'Quase! Pense no tamanho dos microrganismos: dá para vê-los a olho nu? Vamos tentar novamente?'
where id = 32;

update questoes set
  explicacao = 'Muito bem! Os alunos são grandes aliados no combate à dengue. Colocar o lixo no lugar certo e evitar locais que juntam água tira os criadouros do mosquito e deixa a escola inteira mais segura.',
  explicacao_erro = 'Ainda não foi dessa vez, mas vale tentar outra vez! Pense no que os alunos podem fazer para que não sobre água parada nem lixo espalhado na escola.'
where id = 33;

update questoes set
  explicacao = 'Isso mesmo! Mesmo sem estar doente, mãos sujas podem carregar microrganismos. Lavar as mãos ajuda a evitar que eles passem de uma pessoa para outra.',
  explicacao_erro = 'Boa tentativa! Será que só quem está doente tem microrganismos nas mãos? Eles são tão pequenos que a gente não vê. Vamos tentar novamente?'
where id = 34;

update questoes set
  explicacao = 'Acertou! Cada um deve usar a sua garrafinha, o seu copo e os seus talheres. Assim os microrganismos não passam de uma criança para outra e todo mundo fica mais protegido.',
  explicacao_erro = 'Quase! Se um colega está com um microrganismo, o que acontece quando outra criança usa o mesmo copo? Pense nisso. Vamos tentar novamente?'
where id = 35;

update questoes set
  explicacao = 'Muito bem! Corrimãos e dinheiro passam por muitas mãos, e as mãos são o principal caminho dos microrganismos de uma pessoa para outra. Lavar depois de tocar nesses lugares nos protege.',
  explicacao_erro = 'Quase! Imagine quantas pessoas já tocaram nesse corrimão ou nessa nota. O que pode ter ficado nas mãos delas? Vamos tentar novamente?'
where id = 36;

update questoes set
  explicacao = 'Acertou! Dor de dente não é uma emergência para o SAMU. O melhor é procurar a UBS ou um dentista. Assim o SAMU pode atender quem mais precisa, como em queimaduras graves e afogamentos.',
  explicacao_erro = 'Boa tentativa! A pergunta pede a situação em que NÃO devemos chamar o SAMU. Qual dessas não é uma emergência com risco imediato? Vamos tentar novamente?'
where id = 37;

update questoes set
  explicacao = 'Muito bem! Em um acidente de moto, não devemos tocar na pessoa nem tirar o capacete dela, porque isso pode piorar machucados na cabeça e na coluna. O certo é ligar para o 192, observar se ela está consciente e esperar a ajuda.',
  explicacao_erro = 'Quase! A pergunta quer saber o que NÃO devemos fazer. Qual atitude pode machucar ainda mais a pessoa? Vamos tentar novamente?'
where id = 38;

update questoes set
  explicacao = 'Certo! O SAMU orienta não dar água, comida ou outros líquidos a acidentados, porque a pessoa pode se engasgar ou passar mal. O melhor é esperar a equipe chegar.',
  explicacao_erro = 'Boa tentativa! Mesmo com vontade de ajudar, algumas ajudas podem atrapalhar. Qual é a orientação do SAMU para acidentados? Vamos tentar novamente?'
where id = 39;

update questoes set
  explicacao = 'Muito bem! Informar quantas vítimas há, se elas estão conscientes e onde o acidente aconteceu ajuda a equipe do SAMU a chegar rápido e preparada.',
  explicacao_erro = 'Quase! Quem atende precisa saber o que aconteceu, quantas pessoas se machucaram e onde elas estão. Vamos tentar novamente?'
where id = 40;

update questoes set
  explicacao = 'Certo! Separar os recicláveis, limpá-los e colocá-los do jeito certo para a coleta ajuda esses materiais a serem reaproveitados de verdade.',
  explicacao_erro = 'Quase! Quem ajuda a coleta seletiva separa os materiais e cuida deles. Qual atitude faz isso? Vamos tentar novamente?'
where id = 41;

update questoes set
  explicacao = 'Correto! Restos de comida e líquidos sujam o papel e o plástico, causam contaminação e atrapalham a reciclagem.',
  explicacao_erro = 'Quase! O que acontece com um papel quando ele fica molhado e sujo de comida? Vamos tentar novamente?'
where id = 42;

update questoes set
  explicacao = 'Isso! Os recicláveis vão para as cooperativas, onde trabalhadores treinados fazem a triagem e separam cada material para ser aproveitado. É um trabalho muito importante!',
  explicacao_erro = 'Boa tentativa! Existe um lugar com trabalhadores preparados para separar os materiais. Qual é? Vamos tentar novamente?'
where id = 43;

update questoes set
  explicacao = 'Certo! O saco transparente é o mais indicado porque deixa ver o que tem dentro, o que facilita o trabalho de quem faz a triagem.',
  explicacao_erro = 'Quase! Pense em quem vai abrir o saco: o que ajuda essa pessoa a ver o que tem lá dentro? Vamos tentar novamente?'
where id = 44;

update questoes set
  explicacao = 'Isso! O caminhão compactador carrega muito material de uma vez, por isso a coleta fica mais rápida e atende mais pessoas.',
  explicacao_erro = 'Quase! Qual caminhão consegue carregar muito mais material e atender mais gente? Vamos tentar novamente?'
where id = 45;

update questoes set
  explicacao = 'Isso! Os sentidos ajudam o corpo a perceber o que acontece ao redor e a reagir, como se afastar de um perigo ou sentir um cheirinho gostoso.',
  explicacao_erro = 'Boa tentativa! Os sentidos servem para muito mais do que sentir sabores. Pense em tudo que eles nos contam sobre o ambiente. Vamos tentar novamente?'
where id = 46;

update questoes set
  explicacao = 'Correto! Para correr, músculos, ossos, coração e cérebro trabalham juntos. O corpo é uma equipe!',
  explicacao_erro = 'Quase! Correr não depende de uma parte só do corpo. Pense: quem mais ajuda nesse movimento? Vamos tentar novamente?'
where id = 47;

update questoes set
  explicacao = 'Muito bem! Quando o corpo está cansado, descansar e beber água ajudam a recuperar a energia. Escutar o corpo é uma forma de cuidar dele.',
  explicacao_erro = 'Quase! Quando o corpo pede um tempo, o que podemos fazer por ele? Pense no que ajuda a recuperar as energias. Vamos tentar novamente?'
where id = 48;

update questoes set
  explicacao = 'Isso! Lucas ouviu o barulho e reagiu na hora. Isso mostra que o corpo percebe o que acontece ao redor e reage para nos proteger.',
  explicacao_erro = 'Boa tentativa! Lucas ouviu um barulho e se afastou rapidamente. O que isso mostra sobre o nosso corpo? Vamos tentar novamente?'
where id = 49;

update questoes set
  explicacao = 'Acertou! O tato, que sentimos principalmente pela pele das mãos, nos conta se algo é áspero, liso, quente ou frio.',
  explicacao_erro = 'Quase! Pense com qual parte do corpo Caio pegou a pedra e qual sentido nos ajuda a sentir texturas. Vamos tentar novamente?'
where id = 50;

update questoes set
  explicacao = 'Isso! Quando a criança fica muito parada, o corpo pode ficar sem disposição e podem surgir problemas como falta de sono. Brincar e se mexer fazem bem!',
  explicacao_erro = 'Quase! Pense no que acontece com o corpo quando ele quase não se mexe. Vamos tentar novamente?'
where id = 51;

update questoes set
  explicacao = 'Muito bem! A comida entra pela boca, passa pelo estômago e seus nutrientes são aproveitados por todo o corpo para dar energia e força.',
  explicacao_erro = 'Quase! A comida faz uma viagem pelo corpo e os nutrientes ajudam todas as partes. Qual caminho está certo? Vamos tentar novamente?'
where id = 52;

update questoes set
  explicacao = 'Isso! Conhecer o corpo e cuidar dele com bons hábitos todos os dias, como alimentação, sono, higiene e movimento, ajuda a crescer com saúde.',
  explicacao_erro = 'Boa tentativa! Crescer com saúde exige cuidados todos os dias. O que as crianças devem aprender sobre o corpo? Vamos tentar novamente?'
where id = 53;

update questoes set
  explicacao = 'Muito bem! O tato e a dor funcionam como um alerta: quando Lucas sentiu o calor, puxou a mão rapidamente e se protegeu de uma queimadura.',
  explicacao_erro = 'Boa tentativa! Sentir calor e dor avisa o corpo de um perigo. Por que isso é tão útil? Vamos tentar novamente?'
where id = 54;

update questoes set
  explicacao = 'Muito bem! Quando algo deixa a gente assustado, desconfortável ou inseguro, o melhor é contar para um adulto de confiança e pedir ajuda. Você nunca está sozinho e nunca é culpado.',
  explicacao_erro = 'Quase! Quando algo nos deixa com medo ou desconforto, guardar sozinho pesa muito. Quem pode nos ajudar? Pense em um adulto em quem você confia. Vamos tentar novamente?'
where id = 55;

update questoes set
  explicacao = 'Isso! Respeitar os limites de uma criança é perguntar se ela está confortável e aceitar quando ela diz que não quer algo. O "não" de cada pessoa merece respeito.',
  explicacao_erro = 'Boa tentativa! Respeitar é escutar o que a criança sente e o que ela diz. Qual alternativa mostra isso? Vamos tentar novamente?'
where id = 56;

update questoes set
  explicacao = 'Correto! Abuso é quando alguém ultrapassa os limites da criança e desrespeita seu corpo ou sua segurança. A culpa nunca é da criança, e ela pode pedir ajuda.',
  explicacao_erro = 'Quase! Dar regras para proteger a criança é cuidado, não abuso. Pense no que significa desrespeitar o corpo e a segurança de alguém. Vamos tentar novamente?'
where id = 57;

update questoes set
  explicacao = 'Muito bem! Quando uma criança diz "não" sobre o próprio corpo, a outra pessoa deve respeitar e parar. O seu corpo é seu, e o seu "não" vale!',
  explicacao_erro = 'Quase! O corpo é de cada pessoa. O que deve acontecer quando alguém diz "não" sobre o próprio corpo? Vamos tentar novamente?'
where id = 58;

update questoes set
  explicacao = 'Parabéns! Ouvir o amigo com atenção e ajudá-lo a procurar um adulto de confiança é uma atitude de cuidado e coragem. Amigos protegem uns aos outros.',
  explicacao_erro = 'Quase! Um amigo com medo precisa de apoio. O que você pode fazer para ajudá-lo de verdade? Pense em ouvir e em buscar ajuda. Vamos tentar novamente?'
where id = 59;

update questoes set
  explicacao = 'Isso! Se afastar e procurar um adulto de confiança é uma atitude de proteção. Perceber que algo está errado e buscar ajuda é muito corajoso.',
  explicacao_erro = 'Quase! Perceber que algo está errado é o primeiro passo. E o próximo? Pense no que protege a criança. Vamos tentar novamente?'
where id = 60;

update questoes set
  explicacao = 'Correto! O seu corpo é seu, e ninguém pode tocar suas partes íntimas sem um motivo de saúde ou higiene. Se algo assim acontecer, conte para um adulto de confiança.',
  explicacao_erro = 'Quase! Pense em quem decide sobre o seu corpo e no que faz você se sentir seguro. Releia as opções. Vamos tentar novamente?'
where id = 61;

update questoes set
  explicacao = 'Muito bem! Abuso acontece quando alguém desrespeita o corpo ou a segurança da criança e a deixa assustada ou desconfortável. Regras para proteger e lição de casa não são abuso.',
  explicacao_erro = 'Quase! Algumas opções falam de regras e cuidados comuns da vida da criança. Qual fala de desrespeito ao corpo ou à segurança? Vamos tentar novamente?'
where id = 62;

update questoes set
  explicacao = 'Correto! Trabalho infantil é quando a criança realiza um trabalho que não deveria fazer pela sua idade. Criança tem direito de estudar, brincar, descansar e crescer com segurança.',
  explicacao_erro = 'Quase! Arrumar brinquedos e brincar não é trabalho infantil. Pense no que uma criança não deveria fazer pela sua idade. Vamos tentar novamente?'
where id = 63;

update questoes set
  explicacao = 'Isso! Vender produtos na rua durante parte do dia é trabalho infantil, porque tira o tempo de estudar, brincar e descansar. Ajudar a guardar os próprios brinquedos é bem diferente.',
  explicacao_erro = 'Boa tentativa! Ajudar a arrumar as próprias coisas faz parte do cuidado em casa. Qual situação é um trabalho que não deveria ser feito por criança? Vamos tentar novamente?'
where id = 64;

update questoes set
  explicacao = 'Isso! Brincar ajuda a criança a se desenvolver, aprender e conviver com outras pessoas, e é um direito dela.',
  explicacao_erro = 'Boa tentativa! Brincar é muito importante. O que a brincadeira ajuda a criança a fazer? Vamos tentar novamente?'
where id = 65;

update questoes set
  explicacao = 'Correto! Na escola a criança aprende, desenvolve habilidades e conhece seus direitos, e isso ajuda a prevenir o trabalho infantil.',
  explicacao_erro = 'Quase! Pense em tudo que a escola oferece para a criança além de passar o tempo. Vamos tentar novamente?'
where id = 66;

update questoes set
  explicacao = 'Muito bem! Quando tiver dúvidas sobre uma situação de trabalho, converse com um adulto de confiança para saber se ela é segura e adequada.',
  explicacao_erro = 'Quase! Quando temos dúvidas, é melhor procurar alguém de confiança do que decidir sozinho. Vamos tentar novamente?'
where id = 67;

update questoes set
  explicacao = 'Isso! Pelo ECA, o Estatuto da Criança e do Adolescente, as crianças têm direito de estudar, brincar e crescer com proteção e segurança.',
  explicacao_erro = 'Quase! O ECA é uma lei que protege as crianças. Pense no que ela garante a todas elas. Vamos tentar novamente?'
where id = 68;

update questoes set
  explicacao = 'Correto! No Brasil, a idade mínima para começar a trabalhar como aprendiz é 14 anos, com regras que protegem o estudo e a saúde do jovem. Antes disso, o lugar da criança é na escola e na brincadeira.',
  explicacao_erro = 'Boa tentativa! Pense em uma idade em que o jovem já é adolescente, mas ainda estuda. Vamos tentar novamente?'
where id = 69;

update questoes set
  explicacao = 'Muito bem! Programas como o PETI apoiam famílias quando as crianças frequentam a escola e participam das atividades educativas. Estudar é um caminho para um futuro melhor.',
  explicacao_erro = 'Quase! Esses programas querem proteger as crianças. O que a criança precisa fazer na rotina para a família receber o apoio? Vamos tentar novamente?'
where id = 70;

update questoes set
  explicacao = 'Isso! Conversar com um professor ou um adulto de confiança é o melhor jeito de ajudar um amigo que deixou a escola para trabalhar. Assim ele pode receber apoio.',
  explicacao_erro = 'Boa tentativa! Para ajudar um amigo, ficar quieto ou parar de estudar não resolve. Quem pode ajudar de verdade? Vamos tentar novamente?'
where id = 71;

update questoes set
  explicacao = 'Isso mesmo! A membrana plasmática funciona como uma “portaria” da célula: ela é seletiva e controla o que entra e o que sai, mantendo o equilíbrio interno.',
  explicacao_erro = 'Quase! Pense em qual estrutura envolve a célula e funciona como uma “portaria”. Releia as alternativas e tente de novo, você consegue!'
where id = 72;

update questoes set
  explicacao = 'Correto! Células com núcleo delimitado por membrana (o material genético fica protegido ali) são eucariontes, como as de animais, plantas e fungos.',
  explicacao_erro = 'Não foi dessa vez. Lembre-se: o prefixo “eu” indica “verdadeiro”. Qual tipo de célula tem núcleo verdadeiro? Vamos tentar novamente?'
where id = 73;

update questoes set
  explicacao = 'Muito bem! Os ribossomos leem as instruções genéticas e montam as proteínas, que são essenciais para crescer, se defender e se reparar.',
  explicacao_erro = 'Quase lá! Pense na organela que “monta” as proteínas seguindo as instruções do DNA. Vale tentar mais uma vez!'
where id = 74;

update questoes set
  explicacao = 'Exato! O citoplasma é o espaço gelatinoso da célula onde ficam as organelas e acontecem muitas reações químicas essenciais à vida.',
  explicacao_erro = 'Não foi dessa vez. O citoplasma é o “recheio” da célula, onde as organelas ficam e muita coisa acontece. Vamos tentar novamente?'
where id = 75;

update questoes set
  explicacao = 'Parabéns! A célula animal não tem parede celular. Plantas, fungos e bactérias têm essa camada extra de proteção e sustentação.',
  explicacao_erro = 'Quase! A parede celular dá rigidez a plantas, fungos e bactérias. Qual dos seres listados não tem essa estrutura? Vamos tentar novamente?'
where id = 76;

update questoes set
  explicacao = 'Correto! Os alvéolos são pequenos “saquinhos” nos pulmões onde o oxigênio entra no sangue e o gás carbônico sai, nas trocas gasosas.',
  explicacao_erro = 'Quase! Pense nas estruturas minúsculas no final dos brônquios, onde o ar encontra o sangue. Vamos tentar novamente?'
where id = 77;

update questoes set
  explicacao = 'Correto! A bile, produzida pelo fígado, ajuda a digerir as gorduras. Ela fica guardada na vesícula biliar até ser liberada no intestino.',
  explicacao_erro = 'Quase! O fígado produz uma substância que ajuda a “quebrar” as gorduras. Qual é? Vamos tentar novamente?'
where id = 78;

update questoes set
  explicacao = 'Muito bem! O sistema circulatório leva o oxigênio captado pelos pulmões até todas as células do corpo, trabalhando junto com o respiratório.',
  explicacao_erro = 'Não foi dessa vez. Pense em qual sistema tem o coração e os vasos que transportam o sangue. Vamos tentar novamente?'
where id = 79;

update questoes set
  explicacao = 'Correto! O DNA guarda as instruções genéticas que determinam como o organismo se forma e funciona, e são passadas dos pais aos filhos.',
  explicacao_erro = 'Não foi dessa vez. Pense na “receita” que guarda as informações hereditárias de cada ser vivo. Vamos tentar novamente?'
where id = 80;

update questoes set
  explicacao = 'Boa! Mutação é uma alteração no material genético. Algumas não causam efeito, outras podem trazer vantagens ou doenças e ajudam a explicar a evolução.',
  explicacao_erro = 'Quase! Mutação tem a ver com mudança no DNA. Qual alternativa fala disso? Vamos tentar novamente?'
where id = 81;

update questoes set
  explicacao = 'Isso mesmo! Os cromossomos, formados por DNA, ficam principalmente no núcleo das células eucariontes e carregam nossos genes.',
  explicacao_erro = 'Não foi dessa vez. Pense em qual parte da célula funciona como o “centro de comando” e guarda o DNA. Vamos tentar novamente?'
where id = 82;

update questoes set
  explicacao = 'Parabéns! Gregor Mendel, considerado o pai da genética, estudou a herança de características usando ervilhas, que são fáceis de cultivar e cruzar.',
  explicacao_erro = 'Quase! Mendel era monge e fez seus famosos cruzamentos com uma planta de jardim muito comum. Vamos tentar novamente?'
where id = 83;

update questoes set
  explicacao = 'Correto! A vacina contra o HPV é oferecida gratuitamente pelo SUS a adolescentes e previne o câncer do colo do útero, entre outros.',
  explicacao_erro = 'Não foi dessa vez. Há uma vacina no SUS para adolescentes contra um vírus ligado a verrugas genitais e câncer. Qual? Vamos tentar novamente?'
where id = 84;

update questoes set
  explicacao = 'Correto! O número do SAMU é 192. Em emergências médicas, ligar rápido e dar informações claras pode salvar vidas. A ligação é gratuita.',
  explicacao_erro = 'Quase! Cada serviço de emergência tem seu número: um deles é o do SAMU. Qual é? Vamos tentar novamente?'
where id = 85;

update questoes set
  explicacao = 'Muito bem! A leptospirose é transmitida pela urina de ratos, principalmente em enchentes. Manter o lixo bem guardado e evitar água de enchente ajuda a prevenir.',
  explicacao_erro = 'Quase! Dengue vem do mosquito. A doença ligada a ratos e enchentes é outra. Vamos tentar novamente?'
where id = 86;

update questoes set
  explicacao = 'Boa! Restos de comida, cascas de fruta e borra de café são resíduos orgânicos e podem virar adubo na compostagem.',
  explicacao_erro = 'Quase! Esses restos vêm de seres vivos e se decompõem naturalmente. Que tipo de lixo é esse? Vamos tentar novamente?'
where id = 87;

update questoes set
  explicacao = 'Correto! O Corpo de Bombeiros atende pelo 193, para incêndios, resgates e salvamentos. Vale decorar!',
  explicacao_erro = 'Não foi dessa vez. Alguns números são parecidos: 190 é Polícia, 192 é SAMU. Qual é o dos Bombeiros? Vamos tentar novamente?'
where id = 88;

update questoes set
  explicacao = 'Muito bem! Seu corpo é seu e suas partes íntimas são particulares: ninguém deve tocá-las ou pedir para vê-las. Em consultas, só com a presença e a autorização de um responsável.',
  explicacao_erro = 'Quase! Lembre-se: seu corpo pertence a você. Quem tem direito sobre suas partes íntimas? Vamos tentar novamente?'
where id = 89;

update questoes set
  explicacao = 'Correto! Segredo que causa desconforto ou medo não deve ser guardado. Contar a um adulto de confiança é a atitude certa, e você não tem culpa.',
  explicacao_erro = 'Não foi dessa vez. Guardar um segredo que assusta pode deixar a criança desprotegida. Qual atitude protege? Vamos tentar novamente?'
where id = 90;

update questoes set
  explicacao = 'Isso mesmo! O Disque 100 recebe denúncias de violações de direitos de crianças e adolescentes, é gratuito, sigiloso e funciona 24 horas. O Conselho Tutelar também ajuda.',
  explicacao_erro = 'Quase! Há um número nacional para denunciar violações de direitos humanos e infantis. Qual é? Vamos tentar novamente?'
where id = 91;

update questoes set
  explicacao = 'Correto! No Brasil, trabalhar é proibido antes dos 16 anos, ou aos 14 como aprendiz, pois o trabalho precoce prejudica estudos, saúde e desenvolvimento.',
  explicacao_erro = 'Não foi dessa vez. A lei protege crianças do trabalho precoce. Qual alternativa está de acordo com o ECA e a Constituição? Vamos tentar novamente?'
where id = 92;

update questoes set
  explicacao = 'Parabéns! As vacinas ensinam o corpo a se defender de doenças. Quando muita gente se vacina, as doenças circulam menos e até quem não pôde se vacinar fica mais protegido. Por isso a vacina é um cuidado de toda a comunidade.',
  explicacao_erro = 'Não desanime! A vacina é uma grande aliada da saúde, mas ela tem limites. Pense no que ela faz pelo corpo e pela comunidade e tente outra vez.'
where id = 93;

update questoes set
  explicacao = 'Boa! Frutas e verduras cruas devem ser lavadas em água corrente e higienizadas, para remover sujeira e microrganismos.',
  explicacao_erro = 'Não foi dessa vez. Só passar um pano ou comer direto não é seguro. Qual cuidado é correto? Vamos tentar novamente?'
where id = 95;

update questoes set
  explicacao = 'Correto! Sem predadores, a população de presas tende a crescer no início, o que pode depois desequilibrar o ambiente por falta de alimento.',
  explicacao_erro = 'Não foi dessa vez. Pense: se ninguém caça as presas, o que acontece com o número delas? Vamos tentar novamente?'
where id = 96;

update questoes set
  explicacao = 'Exato! Os decompositores (fungos e bactérias) transformam matéria morta em nutrientes que voltam ao solo e alimentam as plantas, fechando o ciclo.',
  explicacao_erro = 'Quase! Pense no que fungos e bactérias fazem com folhas e animais mortos. Vamos tentar novamente?'
where id = 97;

update questoes set
  explicacao = 'Muito bem! Os produtores, como as plantas, captam a energia do Sol. A cada nível da cadeia, parte dela se perde, então ela é maior na base.',
  explicacao_erro = 'Não foi dessa vez. Em uma cadeia alimentar, a energia começa na base e diminui a cada nível. Quem está na base? Vamos tentar novamente?'
where id = 98;

update questoes set
  explicacao = 'Correto! Os seres vivos estão interligados nas cadeias alimentares. Quando uma espécie some, outras que dependem dela também sofrem.',
  explicacao_erro = 'Quase! Pense em como os seres vivos dependem uns dos outros para se alimentar. Vamos tentar novamente?'
where id = 99;

update questoes set
  explicacao = 'Isso mesmo! Biodiversidade alta significa muitas espécies diferentes, sinal de um ambiente equilibrado e saudável.',
  explicacao_erro = 'Não foi dessa vez. Biodiversidade é a variedade de vida. O que ela indica sobre o ambiente? Vamos tentar novamente?'
where id = 100;

update questoes set
  explicacao = 'Correto! A clorofila é o pigmento verde que capta a luz do Sol, energia necessária para a fotossíntese.',
  explicacao_erro = 'Quase! Pense no pigmento verde das folhas e no que ele “captura” do Sol. Vamos tentar novamente?'
where id = 101;

update questoes set
  explicacao = 'Boa! Na fotossíntese, a energia da luz é transformada em energia química, guardada na glicose que a planta produz.',
  explicacao_erro = 'Não foi dessa vez. Na fotossíntese entra luz e sai alimento. Que tipo de energia fica guardada no alimento? Vamos tentar novamente?'
where id = 102;

update questoes set
  explicacao = 'Exato! Os estômatos são pequenos poros nas folhas que permitem a entrada de gás carbônico e a saída de oxigênio e vapor d’água.',
  explicacao_erro = 'Quase! Os estômatos são “portinhas” nas folhas. Pense no que passa por elas. Vamos tentar novamente?'
where id = 103;

update questoes set
  explicacao = 'Correto! A raiz fixa a planta e absorve a água e os sais minerais do solo, que ela precisa para viver.',
  explicacao_erro = 'Não foi dessa vez. Pense no que a planta retira do solo por baixo da terra. Vamos tentar novamente?'
where id = 104;

update questoes set
  explicacao = 'Muito bem! O xilema é o “encanamento” que leva água e sais minerais das raízes até as folhas. O açúcar viaja pelo floema.',
  explicacao_erro = 'Quase! O xilema leva do solo para as folhas aquilo que a raiz absorve. Vamos tentar novamente?'
where id = 105;

update questoes set
  explicacao = 'Muito bem! Na chuva, o vapor d’água esfria e se transforma em gotículas líquidas: é a condensação, etapa do ciclo da água.',
  explicacao_erro = 'Quase! Na formação da chuva, o vapor vira líquido. Como se chama essa mudança? Vamos tentar novamente?'
where id = 106;

update questoes set
  explicacao = 'Correto! O efeito estufa natural retém parte do calor do Sol e mantém a Terra numa temperatura adequada à vida.',
  explicacao_erro = 'Não foi dessa vez. Sem o efeito estufa natural, a Terra seria gelada demais. Qual é sua importância? Vamos tentar novamente?'
where id = 107;

update questoes set
  explicacao = 'Isso mesmo! O excesso de gás carbônico (CO₂), vindo de queimadas e combustíveis fósseis, intensifica o efeito estufa e aquece o planeta.',
  explicacao_erro = 'Quase! Pense no gás liberado ao queimar combustíveis e florestas. Vamos tentar novamente?'
where id = 108;

update questoes set
  explicacao = 'Correto! A energia solar é renovável porque o Sol não se esgota na escala humana. Petróleo, gás natural e carvão levam milhões de anos para se formar.',
  explicacao_erro = 'Não foi dessa vez. Recurso renovável é aquele que se refaz rápido ou não acaba. Qual deles atende a isso? Vamos tentar novamente?'
where id = 109;

update questoes set
  explicacao = 'Boa! A troposfera é a camada mais próxima de nós, onde ocorrem nuvens, chuvas, ventos e quase todos os fenômenos do tempo.',
  explicacao_erro = 'Quase! Pense na camada onde vivemos e onde se formam nuvens e chuva. Vamos tentar novamente?'
where id = 110;

update questoes set
  explicacao = 'Exato! Sem luz, a planta não consegue fazer fotossíntese direito e tem dificuldade de produzir o próprio alimento.',
  explicacao_erro = 'Não foi dessa vez. Lembre-se do que a planta precisa para fazer fotossíntese. Vamos tentar novamente?'
where id = 111;

update questoes set
  explicacao = 'Correto! A qualidade da água é essencial para os peixes. A poluição reduz o oxigênio dissolvido e pode intoxicar os animais aquáticos.',
  explicacao_erro = 'Quase! Pense no ambiente onde o peixe vive e o que o poluído prejudica nele. Vamos tentar novamente?'
where id = 112;

update questoes set
  explicacao = 'Muito bem! A água é a variável que o cientista altera para comparar o efeito entre as duas plantas. Isso é a base do método científico.',
  explicacao_erro = 'Não foi dessa vez. Em um experimento, o fator que é modificado de propósito se chama de uma forma específica. Vamos tentar novamente?'
where id = 113;

update questoes set
  explicacao = 'Correto! Desenvolvimento sustentável é usar os recursos de forma responsável, atendendo às necessidades de hoje sem comprometer as futuras gerações.',
  explicacao_erro = 'Quase! Pense em qual atitude cuida da natureza para que ela continue existindo. Vamos tentar novamente?'
where id = 114;

update questoes set
  explicacao = 'Isso mesmo! O morcego frugívoro leva sementes em suas fezes para outros lugares, ajudando novas plantas a nascerem: é um dispersor de sementes.',
  explicacao_erro = 'Não foi dessa vez. Pense no que acontece com as sementes depois que o morcego come o fruto. Vamos tentar novamente?'
where id = 115;

update questoes set
  explicacao = 'Isso mesmo! O Aedes aegypti transmite dengue, zika e chikungunya. Eliminar criadouros é a principal prevenção.',
  explicacao_erro = 'Quase! Qual das alternativas lista doenças transmitidas pelo mesmo mosquito? Vamos tentar novamente?'
where id = 116;

update questoes set
  explicacao = 'Isso mesmo! Saúde coletiva significa que a saúde de cada um depende também do ambiente e das atitudes da comunidade.',
  explicacao_erro = 'Quase! “Coletiva” lembra “em grupo”. A saúde depende só de cada pessoa? Vamos tentar novamente?'
where id = 117;

update questoes set
  explicacao = 'Correto! Separar o lixo permite reciclar, reduz a poluição e melhora o trabalho dos catadores. Pequenas atitudes fazem diferença!',
  explicacao_erro = 'Não foi dessa vez. Pense no impacto positivo para o meio ambiente e para as pessoas. Vamos tentar novamente?'
where id = 118;

update questoes set
  explicacao = 'Isso aí! Cuidar da saúde é também cuidar de quem mora perto de nós. Quando todos participam de ações de prevenção, como o combate à dengue e a vacinação, a comunidade inteira fica mais protegida. Isso é cuidado coletivo!',
  explicacao_erro = 'Quase! Saúde coletiva é a saúde de todo mundo junto. Pense em uma atitude que ajuda não só você, mas também seus vizinhos. Vamos tentar novamente?'
where id = 119;

update questoes set
  explicacao = 'Muito bem! Mãos que parecem limpas ainda podem ter microrganismos. Lavar com água e sabão antes de comer evita que eles entrem pela boca.',
  explicacao_erro = 'Quase! Depois de brincar no parquinho, as mãos tocaram em muita coisa. O que é mais seguro fazer antes de pegar o lanche? Vamos tentar novamente?',
  opcao_a = 'Comer logo, pois suas mãos parecem limpas.',
  opcao_b = 'Limpar as mãos na roupa e começar a comer.',
  opcao_c = 'Lavar as mãos com água e sabão antes de pegar o lanche.',
  opcao_d = 'Esperar terminar o lanche para lavar as mãos.',
  opcao_e = null,
  resposta_correta = 'C'
where id = 120;

update questoes set
  explicacao = 'Isso! Para chegar a todos os lugares, o SAMU também usa ambulanchas (barcos) em rios e aeromédicos (aviões e helicópteros) em lugares distantes. Assim, ninguém fica sem atendimento!',
  explicacao_erro = 'Boa tentativa! Alguns lugares ficam em rios ou muito longe. Que transportes o SAMU pode usar nesses casos? Vamos tentar novamente?',
  opcao_a = 'Patins e skates para ir mais rápido.',
  opcao_b = 'Ambulâncias (barcos) para atender em rios e aeromédicos (aviões ou helicópteros) para lugares distantes.',
  opcao_c = 'Carroças puxadas por cavalos.',
  opcao_d = 'Eles usam apenas um tipo de ambulância para todas as situações.',
  opcao_e = null,
  resposta_correta = 'B'
where id = 121;

update questoes set
  explicacao = 'Isso! A coleta seletiva separa papel, plástico, metal e vidro, que podem ser reaproveitados e reciclados. Assim, menos lixo vai para o aterro e a natureza agradece.',
  explicacao_erro = 'Quase! Pense no que acontece quando separamos o lixo: quais materiais podem ganhar uma nova vida? Vamos tentar novamente?'
where id = 122;

update questoes set
  explicacao = 'Muito bem! A coleta seletiva deixa a cidade mais organizada e permite reaproveitar materiais, diminuindo o lixo e cuidando do meio ambiente.',
  explicacao_erro = 'Não desanime! Pense nas vantagens de separar o lixo para a cidade e para a natureza. Qual alternativa mostra um benefício? Vamos tentar novamente?'
where id = 123;

update questoes set
  explicacao = 'Isso! O corpo é formado por partes que trabalham juntas e se relacionam com o ambiente, como quando mastigamos, engolimos e conversamos ao mesmo tempo.',
  explicacao_erro = 'Quase! Enquanto Pedro come e conversa, várias partes do corpo agem ao mesmo tempo. Será que elas funcionam sozinhas? Vamos tentar novamente?'
where id = 124;

update questoes set
  explicacao = 'Correto! A frase quer dizer que o corpo precisa de movimento, como correr, pular e dançar, para funcionar bem e ter saúde.',
  explicacao_erro = 'Quase! Se o corpo é feito para o movimento, o que isso nos ensina? Pense no significado da frase. Vamos tentar novamente?',
  opcao_a = 'Devemos passar o dia todo sentados vendo televisão.',
  opcao_b = 'Nosso corpo precisa de atividades físicas, como correr, pular e dançar, para funcionar bem e ter saúde.',
  opcao_c = 'O corpo humano é exatamente igual a um carro de metal.',
  opcao_d = 'Movimentar o corpo é ruim e nos deixa doentes.',
  opcao_e = null,
  resposta_correta = 'B'
where id = 125;

update questoes set
  explicacao = 'Boa! Durante o exercício, o coração acelera para bombear mais sangue e levar mais oxigênio aos músculos, que precisam de energia extra.',
  explicacao_erro = 'Não foi dessa vez. Pense no que os músculos precisam receber quando estamos correndo. Vamos tentar novamente?'
where id = 126;

update questoes set
  explicacao = 'Correto! O mosquito da dengue se reproduz em água parada. Eliminar esses locais é a melhor forma de combatê-lo.',
  explicacao_erro = 'Não foi dessa vez. O Aedes aegypti precisa de algo para se reproduzir. O que devemos evitar acumular? Vamos tentar novamente?'
where id = 127;

update questoes set
  explicacao = 'Correto! Na coleta seletiva, o azul é para papel e papelão, segundo a resolução CONAMA 275. Plástico é vermelho, vidro é verde e metal é amarelo.',
  explicacao_erro = 'Não foi dessa vez. Cada cor da coleta seletiva tem um material. Lembre-se do código das cores. Vamos tentar novamente?'
where id = 128;

update questoes set
  explicacao = 'Muito bem! Brincar, correr e dançar ajudam o corpo a funcionar bem e contribuem para o bem-estar, a alegria e a saúde.',
  explicacao_erro = 'Quase! Movimentar o corpo faz bem para muito mais coisas do que só os braços. Vamos tentar novamente?'
where id = 129;

update questoes set
  explicacao = 'Isso mesmo! Vetor é o ser vivo que carrega e transmite uma doença. No Brasil, a dengue é transmitida pela fêmea do mosquito Aedes aegypti quando ela pica uma pessoa.',
  explicacao_erro = 'Boa tentativa! Vetor é quem leva a doença de uma pessoa para outra. Qual bichinho transmite a dengue quando pica? Vamos tentar novamente?'
where id = 130;

update questoes set
  explicacao = 'Muito bem! Os cinco sentidos são visão, audição, olfato, paladar e tato. Com eles, o corpo percebe o mundo ao nosso redor.',
  explicacao_erro = 'Quase! Os sentidos nos ajudam a ver, ouvir, cheirar, sentir gostos e tocar. Qual alternativa tem os cinco? Vamos tentar novamente?'
where id = 131;

update questoes set
  explicacao = 'Correto! Antibióticos atuam contra bactérias. Eles não funcionam contra vírus, como os da gripe, e usá-los sem necessidade gera resistência bacteriana.',
  explicacao_erro = 'Não foi dessa vez. Antibióticos não servem para todos os microrganismos. Contra qual grupo eles agem? Vamos tentar novamente?'
where id = 132;

update questoes set
  explicacao = 'Isso mesmo! A vacina apresenta ao corpo uma versão segura do agente, que aprende a fazer anticorpos e guarda a “memória” para se defender depois.',
  explicacao_erro = 'Quase lá! Pense no que o sistema imunológico produz para combater invasores. Vamos tentar novamente?'
where id = 133;

update questoes set
  explicacao = 'Boa! Lavar as mãos e cobrir a boca ao tossir reduz a propagação de gotículas e microrganismos, protegendo você e os outros.',
  explicacao_erro = 'Não foi dessa vez. Pense em hábitos que evitam espalhar gotículas e germes. Vamos tentar novamente?'
where id = 134;

update questoes set
  explicacao = 'Correto! O ferro é essencial para a hemoglobina, que transporta oxigênio no sangue. Faltando ferro, pode surgir anemia.',
  explicacao_erro = 'Quase! O ferro faz parte da hemoglobina, nas hemácias. A falta dele causa qual condição? Vamos tentar novamente?'
where id = 135;

update questoes set
  explicacao = 'Exato! O excesso de raios UV, principalmente sem proteção, danifica a pele e aumenta o risco de câncer de pele. Use protetor solar e evite o sol forte.',
  explicacao_erro = 'Não foi dessa vez. Pense no que o excesso de sol sem proteção faz com a pele. Vamos tentar novamente?'
where id = 136;

update questoes set
  explicacao = 'Correto! IST significa Infecção Sexualmente Transmissível. É uma sigla importante para se informar e se prevenir.',
  explicacao_erro = 'Quase! Releia a sigla letra por letra: I, S, T. Vamos tentar novamente?'
where id = 137;

update questoes set
  explicacao = 'Boa! O preservativo é o único método que protege ao mesmo tempo contra ISTs e gravidez. Outros métodos evitam a gravidez, mas não as ISTs.',
  explicacao_erro = 'Não foi dessa vez. Apenas um método impede a gravidez e também barra o contato com agentes de ISTs. Vamos tentar novamente?'
where id = 138;

update questoes set
  explicacao = 'Exato! O HIV não é transmitido por abraços, beijos no rosto ou compartilhamento de copos. Isso ajuda a combater o preconceito contra quem vive com HIV.',
  explicacao_erro = 'Quase! Lembre-se: o HIV não passa pelo convívio social comum. Qual situação NÃO transmite? Vamos tentar novamente?'
where id = 139;

update questoes set
  explicacao = 'Muito bem! Muitas ISTs não dão sintomas, por isso exames regulares são a melhor forma de descobrir e tratar a tempo.',
  explicacao_erro = 'Quase! Nem toda IST dá sinais visíveis. Por que, então, os exames são importantes? Vamos tentar novamente?'
where id = 140;

update questoes set
  explicacao = 'Correto! O bebê se desenvolve no útero, órgão muscular que cresce durante a gestação.',
  explicacao_erro = 'Não foi dessa vez. Pense no órgão do sistema reprodutor feminino que abriga o bebê. Vamos tentar novamente?'
where id = 141;

update questoes set
  explicacao = 'Isso mesmo! O espermatozoide é a célula reprodutora masculina, produzida nos testículos. Ao se unir ao óvulo, pode formar um embrião.',
  explicacao_erro = 'Quase! Pense na célula reprodutora masculina, que se une ao óvulo. Vamos tentar novamente?'
where id = 142;

update questoes set
  explicacao = 'Boa! Se não há gravidez, o revestimento interno do útero se desprende e sai pela vagina. É um processo natural do ciclo menstrual.',
  explicacao_erro = 'Não foi dessa vez. A menstruação é um processo natural do corpo, ligado ao útero. Vamos tentar novamente?'
where id = 143;

update questoes set
  explicacao = 'Exato! Todas essas mudanças são normais na puberdade, causadas pelos hormônios. Cada pessoa tem seu ritmo, e está tudo bem.',
  explicacao_erro = 'Quase! Pense bem: todas as alternativas descrevem mudanças comuns nessa fase. Vamos tentar novamente?'
where id = 144;

update questoes set
  explicacao = 'Correto! Os ovários produzem os óvulos e hormônios, como estrogênio e progesterona, importantes para o desenvolvimento e o ciclo menstrual.',
  explicacao_erro = 'Não foi dessa vez. Pense no órgão que produz os óvulos. Vamos tentar novamente?'
where id = 145;

update questoes set
  explicacao = 'Boa! Água corrente fria por alguns minutos alivia a dor e reduz o dano na queimadura leve. Nada de pasta de dente, manteiga ou óleo, e não estoure bolhas.',
  explicacao_erro = 'Não foi dessa vez. Substâncias caseiras podem piorar a queimadura e causar infecção. O que é mais seguro e está sempre à mão? Vamos tentar novamente?'
where id = 146;

update questoes set
  explicacao = 'Muito bem! Diabetes e hipertensão não são contagiosas e podem ser controladas com hábitos saudáveis e acompanhamento na UBS, em qualquer idade.',
  explicacao_erro = 'Não foi dessa vez. Pense: essas doenças passam de pessoa para pessoa? E elas têm tratamento? Vamos tentar novamente?'
where id = 147;

update questoes set
  explicacao = 'Muito bem! O SAMU 192 atende emergências, como acidentes com produtos perigosos, em que a vida ou a saúde estão em risco. Casos mais leves podem ser cuidados na UBS ou na UPA.',
  explicacao_erro = 'Quase! O SAMU é chamado em emergências, quando a situação é muito séria e não pode esperar. Qual dessas opções é a mais perigosa? Vamos tentar novamente?'
where id = 148;

update questoes set
  explicacao = 'Isso! O SAMU funciona todos os dias, a qualquer hora, e a ligação para o número 192 é gratuita. Guarde esse número!',
  explicacao_erro = 'Boa tentativa! Releia o começo da pergunta: ele traz pistas importantes sobre o número, o custo e os dias de funcionamento do SAMU. Vamos tentar novamente?'
where id = 149;

update questoes set
  explicacao = 'Correto! Choque elétrico pode ser grave, mesmo quando a pessoa parece estar bem. Ligar para o SAMU no 192 é o primeiro passo, e os profissionais orientam o que fazer até a equipe chegar.',
  explicacao_erro = 'Não desanime! Choque elétrico pode ser muito perigoso e esperar pode piorar a situação. Qual serviço de emergência devemos chamar? Vamos tentar novamente?'
where id = 150;

update questoes set
  explicacao = 'Isso! Quando ligamos para o 192, os profissionais do SAMU fazem perguntas sobre o que aconteceu e podem orientar os primeiros cuidados até a ajuda chegar.',
  explicacao_erro = 'Quase! Os profissionais do SAMU estão ali para ajudar. O que será que eles fazem quando atendem a ligação? Vamos tentar novamente?'
where id = 151;

update questoes set
  explicacao = 'Muito bem! Se a pessoa tosse forte e respira, o corpo está conseguindo desobstruir sozinho. Incentive a tossir e peça ajuda de um adulto, sem bater nas costas nem pôr o dedo na boca.',
  explicacao_erro = 'Quase! Quando a pessoa ainda tosse forte e respira, a melhor ajuda é não interferir demais. Qual atitude faz isso? Vamos tentar novamente?'
where id = 152;

update questoes set
  explicacao = 'Correto! Em sangramento intenso, pressione o local com um pano limpo e procure ajuda. Pó de café, terra ou esfregar podem causar infecção.',
  explicacao_erro = 'Não foi dessa vez. Pense em como estancar o sangue de forma limpa e segura, pedindo ajuda. Vamos tentar novamente?'
where id = 153;

update questoes set
  explicacao = 'Exato! Em caso de desmaio, deite a pessoa de costas, eleve as pernas, afrouxe roupas apertadas e chame ajuda. Não dê comida ou bebida.',
  explicacao_erro = 'Quase! O objetivo é facilitar a circulação do sangue ao cérebro e pedir ajuda. Qual alternativa faz isso? Vamos tentar novamente?'
where id = 154;

update questoes set
  explicacao = 'Muito bem! Ao ligar para o SAMU, informe endereço completo, o que aconteceu e quantas pessoas precisam de ajuda para que o socorro chegue mais rápido.',
  explicacao_erro = 'Quase! O atendente precisa saber onde ir e o que está acontecendo. Quais informações são essenciais? Vamos tentar novamente?'
where id = 155;

update questoes set
  explicacao = 'Isso mesmo! Mantenha a calma, responda às perguntas e só desligue quando o atendente autorizar. Informações verdadeiras salvam vidas.',
  explicacao_erro = 'Quase! O atendente guia você e precisa de informações corretas. Como se portar na ligação? Vamos tentar novamente?'
where id = 156;

update questoes set
  explicacao = 'Isso mesmo! Organizar a rotina, manter atividades prazerosas e buscar apoio são estratégias saudáveis contra o estresse.',
  explicacao_erro = 'Não foi dessa vez. Evitar problemas ou se isolar tende a piorar o estresse. Qual alternativa cuida de você? Vamos tentar novamente?'
where id = 186;

update questoes set
  explicacao = 'Muito bem! Ouvir com atenção e se oferecer para procurar ajuda juntos demonstra cuidado e acolhimento, sem minimizar o que o amigo sente.',
  explicacao_erro = 'Quase! Pense em qual resposta acolhe o amigo, sem minimizar o problema nem pedir segredo. Vamos tentar novamente?'
where id = 187;

update questoes set
  explicacao = 'Correto! Sono regular, boa alimentação, atividade física e amizades fortalecem a saúde mental.',
  explicacao_erro = 'Não foi dessa vez. Pense nos hábitos que cuidam do corpo e das relações. Vamos tentar novamente?'
where id = 188;

update questoes set
  explicacao = 'Boa! Rever o conteúdo que consome e definir limites de uso das redes ajuda a proteger a autoestima. Redes mostram só recortes da vida real.',
  explicacao_erro = 'Quase! Qual atitude reduz a comparação e cuida da sua autoestima? Vamos tentar novamente?'
where id = 189;

update questoes set
  explicacao = 'Correto! O sono participa da memória, da atenção e da regulação das emoções, e é especialmente importante na adolescência.',
  explicacao_erro = 'Não foi dessa vez. O sono não elimina todo o estresse, mas ajuda funções importantes do cérebro. Quais? Vamos tentar novamente?'
where id = 190;

update questoes set
  explicacao = 'Isso mesmo! Quando o sofrimento persiste ou atrapalha a vida cotidiana, buscar ajuda psicológica ou médica pode ser muito importante.',
  explicacao_erro = 'Quase! Não é preciso esperar chegar ao limite para pedir ajuda. Em que situação ela é importante? Vamos tentar novamente?'
where id = 191;

update questoes set
  explicacao = 'Correto! Relações baseadas em respeito, confiança e escuta formam uma boa rede de apoio, com quem contar nos momentos difíceis.',
  explicacao_erro = 'Não foi dessa vez. Uma rede de apoio é construída com vínculos de confiança. Qual comportamento ajuda nisso? Vamos tentar novamente?'
where id = 192;

update questoes set
  explicacao = 'Correto! Quando o desânimo dura semanas e atrapalha a rotina, o melhor é falar com alguém de confiança e buscar ajuda profissional. Pedir ajuda é um ato de coragem.',
  explicacao_erro = 'Quase! Esperar passar, esconder ou se automedicar não costumam ajudar. Qual atitude traz apoio de verdade? Vamos tentar novamente?'
where id = 256;

update questoes set
  explicacao = 'Muito bem! Olhar os vários aspectos da situação e buscar apoio quando necessário é a melhor estratégia. Remédios por conta própria e isolamento não ajudam.',
  explicacao_erro = 'Quase! Problemas emocionais e escolares se influenciam. Qual abordagem considera tudo e busca apoio? Vamos tentar novamente?'
where id = 257;

update questoes set
  explicacao = 'Correto! A escola pode estimular escolhas saudáveis e ampliar o conhecimento sobre alimentação, junto com a família e os serviços de saúde.',
  explicacao_erro = 'Quase! A escola colabora, mas não substitui ninguém. Qual alternativa descreve o papel dela? Vamos tentar novamente?'
where id = 258;

update questoes set
  explicacao = 'Muito bem! Uma fruta com um copo de leite tem nutrientes que dão energia por mais tempo. O biscoito recheado tem muito açúcar e pouco alimento de verdade, por isso a fome volta rápido.',
  explicacao_erro = 'Quase! O biscoito recheado dá pouca energia por pouco tempo. Qual opção tem alimentos de verdade, que sustentam por mais tempo? Vamos tentar novamente?'
where id = 261;

update questoes set
  explicacao = 'Correto! Cada tipo de alimento ajuda o corpo de um jeito diferente: frutas e verduras trazem vitaminas, carnes ajudam o corpo a crescer e cereais dão energia. Um prato variado é um prato completo!',
  explicacao_erro = 'Quase! O motivo vai além do prato bonito ou barato. Pense no que cada alimento faz dentro do nosso corpo. Vamos tentar novamente?'
where id = 262;

update questoes set
  explicacao = 'Isso! Uma fruta, um pão e um suco natural formam um lanche equilibrado, com energia e vitaminas para estudar e brincar.',
  explicacao_erro = 'Boa tentativa! Qual lanche tem alimentos que fazem bem ao corpo, em vez de muito açúcar e sal? Vamos tentar novamente?'
where id = 263;

update questoes set
  explicacao = 'Muito bem! Besteiras enchem a barriga sem nutrir o corpo direito e tiram a vontade de comer a comida saudável da refeição principal.',
  explicacao_erro = 'Quase! Pense: o que acontece com a fome quando a gente come besteira antes do almoço? Isso nutre o corpo? Vamos tentar novamente?'
where id = 264;

update questoes set
  explicacao = 'Correto! O suco feito na hora com fruta de verdade costuma ser mais saudável, porque tem menos açúcar e aditivos e mantém os nutrientes da fruta.',
  explicacao_erro = 'Quase! Pense no que tem dentro de cada suco: fruta de verdade ou muito açúcar e aditivos? Vamos tentar novamente?'
where id = 265;

update questoes set
  explicacao = 'Falso, muito bem! Variar entre frutas, verduras, carnes e cereais é melhor, porque cada alimento dá ao corpo algo diferente.',
  explicacao_erro = 'Quase! Será que comer sempre a mesma coisa dá ao corpo tudo o que ele precisa? Vamos tentar novamente?'
where id = 266;

update questoes set
  explicacao = 'Verdadeiro! O refrigerante tem muito açúcar e não hidrata como a água, então a criança pode sentir mais sede. A água é a melhor amiga contra a sede!',
  explicacao_erro = 'Quase! Será que o refrigerante é a melhor opção para matar a sede? Pense no que realmente hidrata o corpo. Vamos tentar novamente?'
where id = 267;

update questoes set
  explicacao = 'Verdadeiro! O biscoito recheado pouco antes do almoço tira a fome, e a criança tende a comer menos do prato principal, que tem os nutrientes de que o corpo precisa.',
  explicacao_erro = 'Quase! Pense no que acontece com a fome depois de comer biscoito pouco antes do almoço. Vamos tentar novamente?'
where id = 268;

update questoes set
  explicacao = 'Falso, parabéns! Lavar frutas e verduras tira sujeira e microrganismos e ajuda a proteger a saúde. É um cuidado importante antes de comer.',
  explicacao_erro = 'Ops! Frutas e verduras vêm da terra e passam por muitas mãos. Será que lavar não faz diferença? Vamos tentar novamente?'
where id = 269;

update questoes set
  explicacao = 'Correto! Variar os alimentos e priorizar alimentos in natura ou minimamente processados é o caminho da alimentação saudável, segundo o Guia Alimentar.',
  explicacao_erro = 'Não foi dessa vez. O Guia Alimentar recomenda variedade e comida de verdade. Qual alternativa segue isso? Vamos tentar novamente?'
where id = 271;

update questoes set
  explicacao = 'Boa! Comer muitos ultraprocessados no dia a dia favorece excesso de açúcar, sal e gordura, e pouca fibra e nutrientes.',
  explicacao_erro = 'Quase! Qual hábito atrapalha a alimentação saudável? Vamos tentar novamente?'
where id = 272;

update questoes set
  explicacao = 'Muito bem! Mudanças graduais e orientação profissional, quando necessário, são mais seguras e duradouras do que dietas extremas.',
  explicacao_erro = 'Não foi dessa vez. Dietas radicais podem prejudicar a saúde. Qual alternativa é mais cuidadosa? Vamos tentar novamente?'
where id = 273;

update questoes set
  explicacao = 'Correto! A água é a bebida ideal para hidratação diária. Energéticos e refrigerantes têm açúcar, cafeína ou outros aditivos.',
  explicacao_erro = 'Quase! Qual bebida simples e saudável deve ser a principal? Vamos tentar novamente?'
where id = 274;

update questoes set
  explicacao = 'Isso mesmo! Consumir muito ultraprocessados aumenta a ingestão de açúcar e sódio, que em excesso fazem mal à saúde.',
  explicacao_erro = 'Não foi dessa vez. Qual comportamento traz açúcar e sal escondidos em excesso? Vamos tentar novamente?'
where id = 275;

update questoes set
  explicacao = 'Muito bem! Hábitos equilibrados e sem práticas extremas cuidam da saúde física e emocional. Escutar fome e saciedade também ajuda.',
  explicacao_erro = 'Não foi dessa vez. Proibir alimentos ou se comparar com padrões das redes pode fazer mal. Qual alternativa é saudável? Vamos tentar novamente?'
where id = 276;

update questoes set
  explicacao = 'Isso mesmo! Alimentação saudável envolve variedade, qualidade e adequação à realidade de cada pessoa, sem regras rígidas para todos.',
  explicacao_erro = 'Não foi dessa vez. Evite alternativas com “exatamente”, “exclusivamente” ou “permanentemente”. Vamos tentar novamente?'
where id = 277;

update questoes set
  explicacao = 'Correto! Atividades prazerosas e adequadas à idade e às condições de cada um são mais fáceis de manter na rotina.',
  explicacao_erro = 'Quase! Qual forma de se movimentar é possível e agradável no dia a dia? Vamos tentar novamente?'
where id = 278;

update questoes set
  explicacao = 'Boa! A atividade física regular contribui para a saúde do coração, do corpo e da mente, mas não evita todas as doenças.',
  explicacao_erro = 'Não foi dessa vez. Atenção às afirmações exageradas. Qual benefício é realista? Vamos tentar novamente?'
where id = 279;

update questoes set
  explicacao = 'Exato! Comportamento sedentário é passar longos períodos sentado, como usando telas por muito tempo. Fazer pausas e se movimentar ajuda.',
  explicacao_erro = 'Quase! Sedentário é quem se movimenta pouco. Qual situação mostra isso? Vamos tentar novamente?'
where id = 280;

update questoes set
  explicacao = 'Muito bem! Os carboidratos são a principal fonte de energia rápida, presentes em pães, arroz, massas e frutas.',
  explicacao_erro = 'Quase! Pense no nutriente que o corpo usa primeiro para ter energia. Vamos tentar novamente?'
where id = 281;

update questoes set
  explicacao = 'Correto! Ultraprocessados são industrializados, com muitos aditivos, açúcar, sódio e gordura. Vale reduzir o consumo e priorizar alimentos de verdade.',
  explicacao_erro = 'Não foi dessa vez. “Ultra” indica muita transformação industrial. Vamos tentar novamente?'
where id = 282;

update questoes set
  explicacao = 'Isso mesmo! O rótulo mostra a quantidade de sódio, que vem do sal. Ler o rótulo ajuda a escolher alimentos melhores.',
  explicacao_erro = 'Quase! Qual informação do rótulo está ligada ao sal? Vamos tentar novamente?'
where id = 283;

update questoes set
  explicacao = 'Correto! Ovos, feijão e carnes são ricos em proteínas, que ajudam a construir e reparar músculos e tecidos.',
  explicacao_erro = 'Não foi dessa vez. Arroz e massas são ricos em carboidratos. Qual grupo traz mais proteínas? Vamos tentar novamente?'
where id = 284;

update questoes set
  explicacao = 'Verdadeiro, parabéns! Frutas, legumes e verduras in natura costumam ter mais vitaminas, minerais e fibras que os ultraprocessados.',
  explicacao_erro = 'Não foi dessa vez. Pense nos nutrientes de uma fruta comparados aos de um salgadinho. Vamos tentar novamente?'
where id = 285;

update questoes set
  explicacao = 'Falso, acertou! Muito sódio aumenta o risco de pressão alta e doenças do coração e dos rins. Convém moderar o sal.',
  explicacao_erro = 'Quase! O excesso de sal faz mal à saúde. Releia a afirmação. Vamos tentar novamente?'
where id = 286;

update questoes set
  explicacao = 'Verdadeiro, correto! As fibras, presentes em feijão, frutas e verduras, ajudam o intestino a funcionar bem.',
  explicacao_erro = 'Não foi dessa vez. Pense no papel das fibras na digestão. Vamos tentar novamente?'
where id = 287;

update questoes set
  explicacao = 'Falso, muito bem! Pular refeições não dá mais energia e pode causar cansaço, irritação e exageros depois. Manter horários regulares ajuda.',
  explicacao_erro = 'Quase! Pular refeições costuma deixar o corpo com menos energia, não com mais. Vamos tentar novamente?'
where id = 288;

update questoes set
  explicacao = 'Verdadeiro, correto! Ler o rótulo mostra ingredientes, açúcar, sal e gorduras, ajudando a escolher melhor.',
  explicacao_erro = 'Não foi dessa vez. Pense no que o rótulo revela sobre o alimento. Vamos tentar novamente?'
where id = 289;

update questoes set
  explicacao = 'Parabéns! O Guia recomenda que a alimentação seja baseada em alimentos in natura e minimamente processados, como frutas, verduras, legumes, feijão, arroz e ovos. Quando possível, prepare suas refeições com ingredientes frescos.',
  explicacao_erro = 'Quase! Pense nos alimentos mais próximos de como são encontrados na natureza, como frutas, legumes e feijão. Qual alternativa os descreve? Vamos tentar novamente.'
where id = 290;

update questoes set
  explicacao = 'Muito bem! Deserto alimentar é a área onde é difícil encontrar alimentos frescos e saudáveis por preço acessível, o que influencia diretamente a qualidade da alimentação e a saúde da população.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Pense na ideia de “deserto”: lugar onde algo escasseia. O que falta nessas áreas? Vamos tentar novamente.'
where id = 291;

update questoes set
  explicacao = 'Correto! Os ultraprocessados costumam ter muito açúcar, sódio e gorduras e pouca fibra, o que se associa a obesidade, diabetes tipo 2 e doenças do coração. Priorizar comida de verdade ajuda a proteger a saúde.',
  explicacao_erro = 'Quase! Pense nos ingredientes típicos dos ultraprocessados e no que o excesso deles causa a longo prazo. Qual alternativa aponta um risco? Vamos tentar novamente.'
where id = 292;

update questoes set
  explicacao = 'Isso mesmo! A rotulagem frontal brasileira usa uma lupa preta com a informação do nutriente em excesso (açúcar adicionado, gordura saturada ou sódio) para ajudar o consumidor a decidir com mais clareza.',
  explicacao_erro = 'Não desanime! Lembre-se do selo que aparece na frente das embalagens em preto e branco, com o formato de uma lupa. Qual alternativa o descreve? Vamos tentar novamente.'
where id = 293;

update questoes set
  explicacao = 'Acertou! A renda da família e o preço dos alimentos frescos em comparação aos ultraprocessados pesam muito nas escolhas alimentares. Por isso políticas públicas de acesso a alimentos saudáveis são tão importantes.',
  explicacao_erro = 'Quase! Pense no que mais pesa na hora de decidir o que comprar para casa. Qual fator é realmente socioeconômico? Tente novamente.'
where id = 294;

update questoes set
  explicacao = 'Correto! Segurança alimentar significa ter acesso regular a alimentos em quantidade e também em qualidade adequadas. Comer o suficiente com uma dieta pobre em nutrientes também é uma forma de insegurança alimentar.',
  explicacao_erro = 'Quase lá! Lembre-se de que o conceito vai além da fome: ele inclui a qualidade nutricional do que se come. Releia a afirmação e Vamos tentar novamente.'
where id = 295;

update questoes set
  explicacao = 'Muito bem! O SUS conta com ações de alimentação e nutrição, como a Política Nacional de Alimentação e Nutrição, o Guia Alimentar e o acompanhamento nutricional na atenção básica.',
  explicacao_erro = 'Não foi dessa vez, mas continue! Pense em programas e orientações de alimentação e nutrição presentes nas unidades de saúde. O SUS realmente não tem nada nessa área? Tente novamente.'
where id = 296;

update questoes set
  explicacao = 'Acertou! A rotulagem frontal sinaliza de forma clara o alto teor de açúcar adicionado, gordura saturada e sódio, facilitando escolhas mais conscientes.',
  explicacao_erro = 'Quase! Pense no propósito do selo na frente da embalagem: informar de modo rápido sobre nutrientes em excesso. A afirmação descreve isso? Vamos tentar novamente.'
where id = 297;

update questoes set
  explicacao = 'Correto! Pesquisas mostram que o consumo de ultraprocessados cresceu nas últimas décadas no Brasil, o que preocupa pela relação com as DCNT. Por isso o Guia Alimentar recomenda evitá-los.',
  explicacao_erro = 'Não desanime! Os estudos de consumo alimentar apontam para qual tendência: aumento ou queda dos ultraprocessados? Releia e tente novamente.'
where id = 298;

update questoes set
  explicacao = 'Muito bem! Impostos sobre bebidas açucaradas encarecem o produto e desestimulam o consumo, ajudando a combater a obesidade e o diabetes. É um exemplo de política pública de saúde baseada em evidências.',
  explicacao_erro = 'Quase! Pense no objetivo de aumentar o preço de bebidas muito açucaradas: incentivar ou reduzir o consumo? Vamos tentar novamente.'
where id = 299;

update questoes set
  explicacao = 'Muito bem! Comece escolhendo atividades adequadas e aumente a prática aos poucos, para evitar lesões e manter a motivação.',
  explicacao_erro = 'Não foi dessa vez. Copiar atleta ou começar no máximo pode causar lesões. Qual é a atitude mais segura? Vamos tentar novamente?'
where id = 335;

update questoes set
  explicacao = 'Correto! A atividade física pode favorecer bem-estar, disposição e redução do estresse, mas não substitui o acompanhamento profissional quando necessário.',
  explicacao_erro = 'Quase! O exercício ajuda a saúde mental, mas com limites realistas. Qual alternativa é equilibrada? Vamos tentar novamente?'
where id = 336;

update questoes set
  explicacao = 'Isso mesmo! Dor persistente é um sinal do corpo. Interrompa ou adapte a atividade e busque avaliação, se necessário.',
  explicacao_erro = 'Não foi dessa vez. Ignorar a dor pode piorar uma lesão. Qual atitude respeita seu corpo? Vamos tentar novamente?'
where id = 337;

update questoes set
  explicacao = 'Correto! Algumas ISTs ficam sem sintomas por um tempo, por isso a testagem e a prevenção são tão importantes.',
  explicacao_erro = 'Não foi dessa vez. Será que toda IST aparece logo? Vamos tentar novamente?'
where id = 356;

update questoes set
  explicacao = 'Correto! Usar o preservativo corretamente e manter acompanhamento de saúde é a estratégia mais relevante. Antibiótico antes ou higiene depois não previnem ISTs.',
  explicacao_erro = 'Quase! Qual método é realmente comprovado para reduzir o risco de ISTs? Vamos tentar novamente?'
where id = 357;

update questoes set
  explicacao = 'Isso mesmo! A vacina contra o HPV, oferecida pelo SUS conforme o calendário do Programa Nacional de Imunizações, é a principal estratégia de prevenção.',
  explicacao_erro = 'Não foi dessa vez. Existe uma vacina específica para prevenir o HPV. Qual alternativa a menciona? Vamos tentar novamente?'
where id = 358;

update questoes set
  explicacao = 'Muito bem! Cada método contraceptivo funciona de um jeito e deve ser escolhido com orientação, conforme cada situação. Só o preservativo também protege contra ISTs.',
  explicacao_erro = 'Quase! Os métodos não são todos iguais e nem todos protegem contra ISTs. Vamos tentar novamente?'
where id = 359;

update questoes set
  explicacao = 'Correto! Consentimento é concordar de forma livre, consciente e sem pressão. Um “sim” dado sob coerção não vale, e pode ser retirado a qualquer momento.',
  explicacao_erro = 'Não foi dessa vez. Consentimento só existe quando a escolha é livre. Qual alternativa descreve isso? Vamos tentar novamente?'
where id = 360;

update questoes set
  explicacao = 'Boa! Diante de suspeita de IST, procure um serviço de saúde para avaliação, orientação e testagem. Não use remédios de outra pessoa.',
  explicacao_erro = 'Quase! Qual atitude garante diagnóstico e tratamento corretos, sem riscos? Vamos tentar novamente?'
where id = 361;

update questoes set
  explicacao = 'Correto! Buscar informação confiável e conversar sobre prevenção e consentimento é uma atitude responsável e respeitosa.',
  explicacao_erro = 'Não foi dessa vez. Responsabilidade envolve informação segura e diálogo. Qual alternativa mostra isso? Vamos tentar novamente?'
where id = 362;

update questoes set
  explicacao = 'Exato! O preservativo, usado corretamente, ajuda a prevenir a gravidez e várias ISTs. Deve ser usado em toda relação e nunca reutilizado.',
  explicacao_erro = 'Quase! O preservativo tem mais de uma função de proteção. Qual alternativa está completa e correta? Vamos tentar novamente?'
where id = 363;

update questoes set
  explicacao = 'Muito bem! Com vacinas atrasadas, o primeiro passo é ir à unidade de saúde para verificar e atualizar, sem precisar recomeçar do zero.',
  explicacao_erro = 'Não foi dessa vez. Quem pode avaliar sua situação vacinal e atualizar suas doses? Vamos tentar novamente?'
where id = 364;

update questoes set
  explicacao = 'Correto! A vacinação estimula o corpo a criar proteção contra doenças imunopreveníveis, antes de adoecer. Não é tratamento e não garante imunidade total.',
  explicacao_erro = 'Quase! Vacina serve para prevenir, não para tratar uma doença já instalada. Qual alternativa diz isso? Vamos tentar novamente?'
where id = 365;

update questoes set
  explicacao = 'Isso mesmo! A vacina HPV é indicada para crianças e adolescentes conforme faixa etária e histórico vacinal. Procure a UBS para saber da sua situação.',
  explicacao_erro = 'Não foi dessa vez. A vacina é indicada na infância e adolescência, antes do contato com o vírus. Qual alternativa diz isso? Vamos tentar novamente?'
where id = 366;

update questoes set
  explicacao = 'Correto! Na adolescência há vacinas e reforços indicados. Manter o cartão em dia protege você e a comunidade.',
  explicacao_erro = 'Quase! A vacinação continua importante nessa fase da vida. Por quê? Vamos tentar novamente?'
where id = 367;

update questoes set
  explicacao = 'Boa! Sarampo, hepatite B e tétano são doenças que a vacinação previne. As demais alternativas não são prevenidas por vacinas.',
  explicacao_erro = 'Não foi dessa vez. Procure o grupo em que todas as doenças têm vacina disponível. Vamos tentar novamente?'
where id = 368;

update questoes set
  explicacao = 'Muito bem! A fonte mais confiável é o cartão de vacinação e os registros dos serviços de saúde, não redes sociais ou memória de terceiros.',
  explicacao_erro = 'Quase! Qual fonte oficial guarda o histórico real das vacinas? Vamos tentar novamente?'
where id = 369;

update questoes set
  explicacao = 'Correto! Manter a própria vacinação atualizada protege você e ajuda a proteger toda a comunidade, inclusive quem não pode se vacinar.',
  explicacao_erro = 'Não foi dessa vez. A proteção coletiva depende de cada um manter as vacinas em dia. Vamos tentar novamente?'
where id = 370;

update questoes set
  explicacao = 'Isso mesmo! A proteção depende da vacina, do esquema de doses e da situação de cada pessoa. Nenhuma vacina protege contra tudo.',
  explicacao_erro = 'Quase! Cuidado com afirmações absolutas como “todas” ou “nunca”. Qual alternativa é mais realista? Vamos tentar novamente?'
where id = 371;

update questoes set
  explicacao = 'Correto! A obesidade envolve fatores biológicos, comportamentais, sociais e ambientais. Não é só “culpa” da pessoa, e o cuidado deve ser acolhedor.',
  explicacao_erro = 'Quase! A obesidade tem várias causas combinadas. Qual alternativa reconhece isso? Vamos tentar novamente?'
where id = 372;

update questoes set
  explicacao = 'Acertou! A caixa-d''água bem fechada e vedada impede que o mosquito entre e coloque ovos na água. É um cuidado simples que protege a sua família e os vizinhos.',
  explicacao_erro = 'Quase! O mosquito procura água parada para colocar os ovos. O que a família pode fazer com a caixa-d''água para ele não conseguir entrar? Vamos tentar novamente?'
where id = 426;

update questoes set
  explicacao = 'Muito bem! Limpar as embalagens, tirando restos de comida e líquidos, evita mau cheiro e contaminação e ajuda na reciclagem.',
  explicacao_erro = 'Não desista! Embalagens com restos de comida atrapalham a reciclagem. O que devemos fazer com elas antes de separar? Vamos tentar novamente?'
where id = 427;

update questoes set
  explicacao = 'Certo! Durante o sono, o corpo recupera as energias e a mente descansa, para termos disposição no dia seguinte.',
  explicacao_erro = 'Boa tentativa! Dormir bem faz muito bem. Como você se sente depois de uma boa noite de sono? Vamos tentar novamente?'
where id = 428;

update questoes set
  explicacao = 'Falso, muito bem! Sono e descanso são tão importantes quanto estudar. Passar a noite inteira acordado cansa o corpo e a mente.',
  explicacao_erro = 'Quase! Será que ficar a noite inteira acordado faz bem? Pense no que o corpo precisa para ter energia. Vamos tentar novamente?'
where id = 429;

update questoes set
  explicacao = 'Verdadeiro, parabéns! Frutas, legumes e verduras têm nutrientes que o corpo usa para ter energia e força. Quanto mais variada a alimentação, melhor!',
  explicacao_erro = 'Quase! Pense: será que alimentos variados dão ao corpo tudo o que ele precisa? Vamos tentar novamente?'
where id = 430;

update questoes set
  explicacao = 'Isso! Quando a criança passa muitas horas em afazeres domésticos, ela perde o tempo de estudar, brincar e descansar. Ajudar um pouquinho em casa é bom, mas o excesso atrapalha.',
  explicacao_erro = 'Quase! Pense no que falta para uma criança que passa muitas horas fazendo tarefas de casa. Vamos tentar novamente?'
where id = 431;

update questoes set
  explicacao = 'Muito bem! Moradia, saneamento, renda, educação e acesso aos serviços são determinantes sociais da saúde e influenciam quem adoece e como. Cuidar da saúde também é cuidar das condições de vida.',
  explicacao_erro = 'Quase! Pense em como saneamento, moradia e renda afetam a saúde das pessoas. Eles influenciam ou não? Releia com calma as alternativas e tente novamente.'
where id = 432;

update questoes set
  explicacao = 'Correto! O tratamento de esgoto reduz a contaminação do ambiente por resíduos e microrganismos, protegendo rios, solo e a saúde das pessoas.',
  explicacao_erro = 'Não foi dessa vez. Pense no que acontece com a água e o ambiente quando o esgoto é tratado. Vamos tentar novamente?'
where id = 433;

update questoes set
  explicacao = 'Isso mesmo! Esgoto sem tratamento contamina a água e o solo, espalhando microrganismos que podem causar doenças.',
  explicacao_erro = 'Quase! Pense no que o esgoto cheio de microrganismos faz ao ser lançado direto na natureza. Vamos tentar novamente?'
where id = 434;

update questoes set
  explicacao = 'Muito bem! O saneamento básico (água tratada, esgoto, lixo) previne doenças e protege a população.',
  explicacao_erro = 'Não foi dessa vez. O saneamento vai muito além da aparência da cidade. Vamos tentar novamente?'
where id = 435;

update questoes set
  explicacao = 'Correto! Beber água contaminada aumenta o risco de doenças transmitidas pela água, como diarreias, hepatite A e leptospirose.',
  explicacao_erro = 'Quase! Pense no risco de beber água com microrganismos. Vamos tentar novamente?'
where id = 436;

update questoes set
  explicacao = 'Exato! Esgoto a céu aberto expõe as pessoas a microrganismos e atrai vetores, representando risco à saúde.',
  explicacao_erro = 'Não foi dessa vez. Procure a situação que NÃO é uma boa prática de saneamento. Vamos tentar novamente?'
where id = 437;

update questoes set
  explicacao = 'Boa! Água e ambiente são recursos compartilhados: um córrego contaminado pode afetar toda a comunidade que o utiliza.',
  explicacao_erro = 'Quase! Pense em quantas pessoas dependem do mesmo córrego. Vamos tentar novamente?'
where id = 438;

update questoes set
  explicacao = 'Correto! Saneamento adequado protege a saúde coletiva. As outras relações apresentam causa e efeito invertidos.',
  explicacao_erro = 'Não foi dessa vez. Observe qual relação liga uma ação positiva a um efeito positivo. Vamos tentar novamente?'
where id = 439;

update questoes set
  explicacao = 'Muito bem! O saneamento é preventivo porque reduz a exposição da população a agentes causadores de doenças, antes que as pessoas adoeçam.',
  explicacao_erro = 'Quase! Prevenir é agir antes da doença. Como o saneamento faz isso? Vamos tentar novamente?'
where id = 440;

update questoes set
  explicacao = 'Correto! Na água contaminada podem existir microrganismos capazes de provocar doenças, e muitos só aparecem ao microscópio.',
  explicacao_erro = 'Não foi dessa vez. Nem todo microrganismo é inofensivo. Vamos tentar novamente?'
where id = 441;

update questoes set
  explicacao = 'Isso mesmo! Melhorar a coleta e o tratamento do esgoto resolve a origem do problema, e não só os sintomas.',
  explicacao_erro = 'Quase! Qual medida ataca a causa do esgoto a céu aberto? Vamos tentar novamente?'
where id = 442;

update questoes set
  explicacao = 'Correto! Saneamento mostra que a saúde também depende das condições ambientais e sociais, e das políticas públicas.',
  explicacao_erro = 'Não foi dessa vez. A saúde não depende só de consultas ou da genética. Vamos tentar novamente?'
where id = 443;

update questoes set
  explicacao = 'Exato! Jogar resíduos direto nos córregos polui a água e não ajuda a protegê-la. As demais atitudes ajudam.',
  explicacao_erro = 'Quase! Atenção: a pergunta pede a atitude que NÃO ajuda. Vamos tentar novamente?'
where id = 444;

update questoes set
  explicacao = 'Muito bem! Uma doença ligada à água contaminada pode atingir muita gente, e isso mostra a importância da saúde pública e do saneamento.',
  explicacao_erro = 'Não foi dessa vez. Quando muita gente adoece pela mesma causa, o assunto é coletivo. Vamos tentar novamente?'
where id = 445;

update questoes set
  explicacao = 'Correto! Água transparente pode conter contaminantes invisíveis. Só o tratamento e análises garantem que é segura.',
  explicacao_erro = 'Quase! Cor e cheiro nem sempre mostram a contaminação. Vamos tentar novamente?'
where id = 446;

update questoes set
  explicacao = 'Isso mesmo! Esgoto sem tratamento leva à contaminação ambiental e aumenta o risco de doenças: é uma cadeia de risco.',
  explicacao_erro = 'Não foi dessa vez. Procure a sequência que mostra causa, consequência e risco de doença. Vamos tentar novamente?'
where id = 447;

update questoes set
  explicacao = 'Correto! A qualidade da água e do ambiente influencia a saúde das comunidades. Cuidar dos rios é cuidar de pessoas.',
  explicacao_erro = 'Quase! Pense em como o rio se liga à saúde de quem vive perto dele. Vamos tentar novamente?'
where id = 448;

update questoes set
  explicacao = 'Isso mesmo! Lixo no rio favorece poluição e problemas ambientais, prejudicando seres vivos e pessoas.',
  explicacao_erro = 'Não foi dessa vez. O que o lixo causa na água? Vamos tentar novamente?'
where id = 449;

update questoes set
  explicacao = 'Boa! Dar destino adequado aos resíduos evita a poluição e protege os rios.',
  explicacao_erro = 'Quase! Qual ação cuida do rio, em vez de poluí-lo? Vamos tentar novamente?'
where id = 450;

update questoes set
  explicacao = 'Correto! Um rio poluído afeta diferentes seres vivos e o equilíbrio ambiental, como uma teia ligada.',
  explicacao_erro = 'Não foi dessa vez. A poluição não atinge só um grupo. Vamos tentar novamente?'
where id = 451;

update questoes set
  explicacao = 'Muito bem! Meio ambiente e saúde humana se relacionam de várias maneiras, e não só em casos específicos.',
  explicacao_erro = 'Quase! Evite alternativas com “somente” ou “completamente independentes”. Vamos tentar novamente?'
where id = 452;

update questoes set
  explicacao = 'Correto! Poluição da água aumenta os riscos ambientais e à saúde.',
  explicacao_erro = 'Não foi dessa vez. Poluir deixa a água mais segura ou mais arriscada? Vamos tentar novamente?'
where id = 453;

update questoes set
  explicacao = 'Isso mesmo! Participar de mutirões de limpeza é uma ação de cuidado ambiental e comunitário, com benefícios para a saúde de todos.',
  explicacao_erro = 'Quase! Mutirão é mais do que lazer ou estética. Qual o valor dele? Vamos tentar novamente?'
where id = 454;

update questoes set
  explicacao = 'Correto! Resíduos despejados no rio podem causar consequências em outras partes do ambiente, rio abaixo.',
  explicacao_erro = 'Não foi dessa vez. A água corre e leva a poluição consigo. Vamos tentar novamente?'
where id = 455;

update questoes set
  explicacao = 'Muito bem! Preservar rios mantém o equilíbrio ambiental e protege a água de que dependemos.',
  explicacao_erro = 'Quase! Qual benefício vem de cuidar dos rios? Vamos tentar novamente?'
where id = 456;

update questoes set
  explicacao = 'Exato! Ambientes saudáveis contribuem para comunidades mais saudáveis: esse é o conceito de saúde ambiental.',
  explicacao_erro = 'Não foi dessa vez. Pense na relação entre ambiente e bem-estar. Vamos tentar novamente?'
where id = 457;

update questoes set
  explicacao = 'Correto! Alguns contaminantes não são vistos a olho nu. Um rio aparentemente limpo pode estar poluído.',
  explicacao_erro = 'Quase! Aparência nem sempre mostra a qualidade da água. Vamos tentar novamente?'
where id = 458;

update questoes set
  explicacao = 'Muito bem! Responsabilidade coletiva é evitar a poluição e colaborar na conservação, sem esperar só pelos outros.',
  explicacao_erro = 'Não foi dessa vez. Pequenas ações somadas fazem diferença. Qual atitude é responsável? Vamos tentar novamente?'
where id = 459;

update questoes set
  explicacao = 'Correto! Esgoto despejado em rios prejudica a qualidade da água e a saúde ambiental.',
  explicacao_erro = 'Quase! O esgoto causa danos além da aparência. Vamos tentar novamente?'
where id = 460;

update questoes set
  explicacao = 'Isso mesmo! Proteger um rio beneficia ecossistemas e diferentes comunidades humanas, perto e longe dele.',
  explicacao_erro = 'Não foi dessa vez. O benefício de um rio protegido é bem amplo. Vamos tentar novamente?'
where id = 461;

update questoes set
  explicacao = 'Correto! Proteger recursos naturais também protege a saúde, pois ambiente saudável e pessoas saudáveis andam juntos.',
  explicacao_erro = 'Quase! Qual conclusão liga meio ambiente e saúde? Vamos tentar novamente?'
where id = 462;

update questoes set
  explicacao = 'Correto! A vacina estimula a produção de anticorpos que atuam antes de a doença se instalar, podendo impedir a infecção já na entrada das larvas pela pele. O tratamento tradicional, ao contrário, só age depois que o parasita já está no corpo.',
  explicacao_erro = 'Não desanime! Compare: o remédio age depois da infecção, enquanto a vacina prepara o corpo antes. Qual alternativa descreve uma ação na porta de entrada do parasita? Releia e tente novamente.'
where id = 463;

update questoes set
  explicacao = 'Correto! Como os fármacos são estáveis e resistem aos tratamentos convencionais, é preciso desenvolver novos processos nas estações de tratamento para removê-los da água. Descartar medicamentos corretamente em pontos de coleta também ajuda.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! O texto diz que os fármacos são estáveis e persistem mesmo no esgoto. Qual medida atuaria justamente na remoção desses compostos? Tente novamente.'
where id = 464;

update questoes set
  explicacao = 'Certo! A higiene oral, ou seja, escovar os dentes, também é fundamental. Dentes limpos evitam cáries e problemas na boca que podem afetar a saúde do corpo inteiro.',
  explicacao_erro = 'Quase! Procure o hábito que cuida do corpo, assim como lavar as mãos. Qual dessas opções é um cuidado de higiene? Vamos tentar novamente?'
where id = 465;

update questoes set
  explicacao = 'Verdadeiro, muito bem! Lavar as mãos é simples, barato e evita que muitas doenças, até as mais graves, se espalhem pelo mundo. Um pequeno gesto com um grande efeito!',
  explicacao_erro = 'Ops! Pense: lavar as mãos só precisa de água e sabão, algo bem simples. Será que isso ajuda a evitar doenças? Vamos tentar novamente?'
where id = 466;

update questoes set
  explicacao = 'Verdadeiro, parabéns! Fala diferente de repente ou perda de força em um lado do corpo podem ser sinais de AVC, um problema sério no cérebro. Ligar rápido para o 192 faz toda a diferença.',
  explicacao_erro = 'Ops! Mudanças repentinas na fala ou na força do corpo são sinais de que algo sério pode estar acontecendo. Será que dá para esperar? Vamos tentar novamente?'
where id = 467;

update questoes set
  explicacao = 'Certo! Cabeça, tronco, braços e pernas são as grandes partes em que dividimos o corpo humano.',
  explicacao_erro = 'Quase! Lembre-se das grandes partes em que dividimos o corpo: a parte de cima, o meio e os membros. Vamos tentar novamente?'
where id = 468;

update questoes set
  explicacao = 'Isso! Quando a criança fica muito parada, o corpo pode ficar sem disposição e podem surgir problemas como falta de sono. Brincar e se mexer fazem bem!',
  explicacao_erro = 'Quase! Pense no que acontece com o corpo quando ele quase não se mexe. Vamos tentar novamente?'
where id = 469;

update questoes set
  explicacao = 'Correto! Abuso é quando alguém ultrapassa os limites da criança e desrespeita seu corpo ou sua segurança. A culpa nunca é da criança, e ela pode pedir ajuda.',
  explicacao_erro = 'Quase! Dar regras para proteger a criança é cuidado, não abuso. Pense no que significa desrespeitar o corpo e a segurança de alguém. Vamos tentar novamente?'
where id = 470;

update questoes set
  explicacao = 'Verdadeiro! A escola é um lugar seguro, onde professores e funcionários ajudam a identificar situações perigosas e acolhem quem precisa de ajuda.',
  explicacao_erro = 'Ops! Pense nas pessoas da escola que cuidam de você. Será que a escola pode ser um lugar de proteção e de ajuda? Vamos tentar novamente?'
where id = 471;

update questoes set
  explicacao = 'Verdadeiro! O Maio Laranja é uma campanha nacional que acontece em maio, no Brasil, para ensinar a proteger crianças e adolescentes contra o abuso e a exploração sexual. Todo mundo pode participar!',
  explicacao_erro = 'Quase! No Brasil existe uma campanha anual, ligada à cor laranja, para proteger as crianças. Vamos tentar novamente?'
where id = 472;

update questoes set
  explicacao = 'Isso! Toda criança tem direito de ser protegida contra qualquer tipo de violência e de crescer em um ambiente seguro. Esse direito está garantido no ECA.',
  explicacao_erro = 'Boa tentativa! Crianças têm direitos importantes, como proteção e segurança. Qual alternativa fala disso? Vamos tentar novamente?'
where id = 473;

update questoes set
  explicacao = 'Falso, muito bem! No Brasil o trabalho infantil não é permitido, e a lei protege o direito da criança de estudar e brincar. É o estudo, e não o trabalho, que abre caminho para um futuro melhor.',
  explicacao_erro = 'Quase! A frase diz que o trabalho infantil é permitido. Será que isso protege as crianças? Pense no que a lei diz. Vamos tentar novamente?'
where id = 474;

update questoes set
  explicacao = 'Muito bem! A UPA estabiliza o paciente, cuida da emergência e o encaminha ao hospital quando ele precisa de cirurgia ou internação.',
  explicacao_erro = 'Quase! A UPA cuida primeiro da urgência e depois leva o paciente para onde ele precisa. Qual é o papel dela? Vamos tentar novamente?'
where id = 475;

update questoes set
  explicacao = 'Verdadeiro, correto! Bullying é agressão ou humilhação repetida que causa sofrimento. Reconhecê-lo é o primeiro passo para combatê-lo.',
  explicacao_erro = 'Não foi dessa vez. Pense em agressões e humilhações que se repetem e machucam. Vamos tentar novamente?'
where id = 476;

update questoes set
  explicacao = 'Verdadeiro, muito bem! O cyberbullying acontece em redes sociais, aplicativos de mensagens, jogos online e outras plataformas digitais, e também machuca de verdade.',
  explicacao_erro = 'Quase! O bullying também pode acontecer no ambiente digital. Vamos tentar novamente?'
where id = 477;

update questoes set
  explicacao = 'Verdadeiro, isso mesmo! Brincadeira de verdade é boa para todos. Se alguém sofre e a situação continua mesmo após mostrar desconforto, deixou de ser brincadeira.',
  explicacao_erro = 'Não foi dessa vez. Brincadeira saudável respeita o limite do outro. Vamos tentar novamente?'
where id = 478;

update questoes set
  explicacao = 'Verdadeiro, correto! Compartilhar imagem íntima sem autorização é violência e pode causar danos graves, inclusive com consequências legais. Se isso acontecer, procure um adulto de confiança.',
  explicacao_erro = 'Quase! Divulgar imagens íntimas sem permissão viola a privacidade e machuca. Vamos tentar novamente?'
where id = 479;

update questoes set
  explicacao = 'Falso, muito bem! Responder com agressão piora a situação. O melhor é buscar ajuda de um adulto de confiança, professores ou da direção da escola.',
  explicacao_erro = 'Não foi dessa vez. Violência gera mais violência. Qual caminho é mais seguro para resolver? Vamos tentar novamente?'
where id = 480;

update questoes set
  explicacao = 'Verdadeiro, correto! A cultura de paz valoriza respeito, diálogo, prevenção de conflitos e direitos humanos.',
  explicacao_erro = 'Quase! Pense no que significa construir um ambiente de paz. Vamos tentar novamente?'
where id = 481;

update questoes set
  explicacao = 'Verdadeiro, isso mesmo! Preconceito e discriminação podem causar sofrimento, ansiedade e prejuízos à saúde física e mental.',
  explicacao_erro = 'Não foi dessa vez. Ser tratado com desrespeito afeta o corpo e a mente. Vamos tentar novamente?'
where id = 482;

update questoes set
  explicacao = 'Falso, correto! A vítima nunca é culpada pela violência sofrida. A responsabilidade é de quem agride. Quem sofre violência deve receber apoio.',
  explicacao_erro = 'Quase! Quem sofre violência merece proteção e acolhimento, não culpa. Vamos tentar novamente?'
where id = 483;

update questoes set
  explicacao = 'Verdadeiro, muito bem! Ao presenciar violência, procurar um adulto ou serviço responsável é uma forma de proteger quem está sofrendo. O Disque 100 recebe denúncias.',
  explicacao_erro = 'Não foi dessa vez. Pedir ajuda não é “dedurar”, é proteger. Vamos tentar novamente?'
where id = 484;

update questoes set
  explicacao = 'Verdadeiro, correto! Pensar diferente é normal. Relações saudáveis lidam com divergências com respeito e diálogo.',
  explicacao_erro = 'Quase! Relações saudáveis admitem opiniões diferentes, desde que haja respeito. Vamos tentar novamente?'
where id = 485;

update questoes set
  explicacao = 'Verdadeiro, isso mesmo! Cuidar da saúde é reconhecer riscos, ter hábitos saudáveis e procurar ajuda quando preciso. Autocuidado também é prevenção.',
  explicacao_erro = 'Não foi dessa vez. Cuidar da saúde vai além de ir ao médico só quando adoece. Vamos tentar novamente?'
where id = 486;

update questoes set
  explicacao = 'Falso, muito bem! Saúde integral envolve o bem-estar físico, mental, emocional e social, e não apenas a ausência de doenças.',
  explicacao_erro = 'Quase! A saúde tem várias dimensões, não só a física. Vamos tentar novamente?'
where id = 487;

update questoes set
  explicacao = 'Parabéns, resposta certa! Dengue, zika e chikungunya compartilham o mosquito Aedes aegypti, mas são vírus distintos: a imunidade criada contra um deles não protege contra os outros. Por isso, prevenir os criadouros do mosquito continua sendo a melhor defesa para todas.',
  explicacao_erro = 'Quase lá, não desanime! Pense assim: se os vírus são de famílias diferentes, os anticorpos feitos contra um deles reconhecem os outros? Releia o enunciado com essa ideia em mente e tente novamente.'
where id = 488;

update questoes set
  explicacao = 'Muito bem! O vírus da dengue possui quatro sorotipos (DENV-1 a DENV-4). A infecção por um deles gera imunidade duradoura apenas contra aquele sorotipo, então a pessoa pode adoecer até quatro vezes.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Lembre-se de que o vírus da dengue não é um só: ele aparece em variações. Pense em quantas são e no que isso muda para a imunidade, e tente de novo.'
where id = 489;

update questoes set
  explicacao = 'Excelente! Na segunda infecção por um sorotipo diferente, os anticorpos da primeira vez podem não neutralizar bem o novo vírus e favorecer formas mais graves da doença. Por isso, qualquer suspeita de dengue merece atenção médica, principalmente em quem já teve a doença.',
  explicacao_erro = 'Ainda não, mas vale insistir! Pense no que acontece quando o corpo já conhece um sorotipo e encontra outro diferente. Releia com calma as alternativas e tente novamente.'
where id = 490;

update questoes set
  explicacao = 'Correto! A Wolbachia reduz a multiplicação do vírus dentro do mosquito, diminuindo sua capacidade de transmitir a dengue. Ela é passada de geração em geração entre os insetos, o que torna o método sustentável.',
  explicacao_erro = 'Quase! Foque no que a bactéria faz com o vírus dentro do mosquito, e não no humano nem na vida do inseto. Vamos tentar novamente.'
where id = 491;

update questoes set
  explicacao = 'Isso mesmo! O zika vírus na gestação está associado à microcefalia e a outras alterações neurológicas no bebê, a chamada síndrome congênita do zika. Por isso gestantes devem reforçar a proteção contra o mosquito.',
  explicacao_erro = 'Não foi essa, mas você está aprendendo! Lembre-se da epidemia de 2015 e 2016 no Brasil, que chamou atenção para bebês nascidos com microcefalia. Qual arbovirose esteve ligada a isso? Vamos tentar novamente.'
where id = 492;

update questoes set
  explicacao = 'Muito bom! O Aedes aegypti se reproduz em água parada, e a chuva aumenta o número de recipientes que acumulam água. Mais criadouros significam mais mosquitos e, consequentemente, mais casos.',
  explicacao_erro = 'Não desanime! Pense em onde o mosquito Aedes deposita seus ovos e no que a chuva provoca nesses locais. Releia com calma as alternativas e tente novamente.'
where id = 493;

update questoes set
  explicacao = 'Acertou! A vacina contra febre amarela é eficaz e oferecida gratuitamente, mas surtos acontecem onde parte da população não se vacinou. Manter a cobertura vacinal alta é o que protege indivíduos e comunidades.',
  explicacao_erro = 'Quase! Se a vacina é eficaz e está disponível, o que pode estar faltando para que ela proteja todas as pessoas de uma região? Pense nisso e tente de novo.'
where id = 494;

update questoes set
  explicacao = 'Perfeito! A malária é transmitida por mosquitos do gênero Anopheles e é causada por protozoários do gênero Plasmodium. Já dengue, zika, chikungunya e febre amarela urbana são transmitidas pelo Aedes aegypti.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Atenção ao “NÃO” no enunciado: procure a doença que tem outro mosquito como vetor e é causada por um protozoário. Vamos tentar novamente.'
where id = 495;

update questoes set
  explicacao = 'Isso aí! O RNA mensageiro entrega às células a instrução para fabricar uma proteína viral por pouco tempo, e o sistema imune aprende a reconhecê-la. O RNAm não entra no núcleo nem altera o DNA.',
  explicacao_erro = 'Quase lá! Lembre-se de que a vacina de RNAm não contém o vírus inteiro e não modifica o DNA. Ela entrega uma instrução temporária às células. Vamos tentar novamente.'
where id = 496;

update questoes set
  explicacao = 'Correto! A hepatite A se espalha pela via fecal-oral, por água e alimentos contaminados. Saneamento básico, higiene das mãos e vacinação são as principais formas de prevenção.',
  explicacao_erro = 'Não foi essa, mas siga firme! Pense em como a hepatite A chega ao organismo e no papel da água e dos alimentos nisso. Vamos tentar novamente.',
  opcao_a = 'A hepatite A é transmitida só por transfusão de sangue',
  opcao_b = 'As três hepatites têm exatamente a mesma via de transmissão',
  opcao_c = 'A hepatite A não tem relação com condições sanitárias, sendo exclusiva de fatores internos',
  opcao_d = 'A hepatite A é transmitida apenas por contato sexual',
  opcao_e = 'A hepatite A é transmitida por via fecal-oral, dependendo diretamente da qualidade d’água e dos alimentos',
  resposta_correta = 'E'
where id = 497;

update questoes set
  explicacao = 'Muito bem! A vacinação em massa das crianças, mantida por décadas, interrompeu a circulação do poliovírus selvagem no Brasil. O sucesso depende de manter as coberturas altas para evitar o retorno da doença.',
  explicacao_erro = 'Quase! Lembre-se de que a poliomielite é causada por um vírus, então antibióticos não resolvem, e que não existe tratamento que cure a paralisia. Qual medida preventiva foi decisiva? Vamos tentar novamente.'
where id = 498;

update questoes set
  explicacao = 'Acertou! Como o vírus da raiva demora a chegar ao sistema nervoso, há uma janela de tempo para a profilaxia pós-exposição (vacina e, quando indicado, soro). A raiva é quase sempre fatal depois que os sintomas aparecem, por isso procurar atendimento logo após a mordida é essencial.',
  explicacao_erro = 'Não desanime! Pense no que a demora do vírus para causar sintomas permite fazer logo depois da mordida. Releia com calma as alternativas e tente novamente.'
where id = 499;

update questoes set
  explicacao = 'Excelente! O HPV pode permanecer sem sintomas por muitos anos, e lesões que levam ao câncer de colo do útero também evoluem em silêncio. Por isso o exame preventivo periódico é fundamental, mesmo para quem se vacinou.',
  explicacao_erro = 'Quase! Se o vírus pode ficar anos sem dar sinais, esperar sintomas é uma boa estratégia? Releia com calma as alternativas e tente novamente.'
where id = 500;

update questoes set
  explicacao = 'Correto! Quando muitas pessoas estão imunizadas, o vírus encontra poucos suscetíveis e a transmissão diminui, protegendo também quem não pode se vacinar. No sarampo, que é muito contagioso, é preciso manter a cobertura em torno de 95%.',
  explicacao_erro = 'Não foi dessa vez, mas continue! Imagine o vírus tentando passar de pessoa em pessoa: quando ele encontra mais barreiras? Releia com calma as alternativas e tente novamente.'
where id = 501;

update questoes set
  explicacao = 'Muito bem! O vírus influenza muda com frequência, e a vacina é reformulada a cada ano para proteger contra as cepas mais prováveis. Por isso vale se vacinar todos os anos.',
  explicacao_erro = 'Quase lá! O ponto-chave é o comportamento do vírus influenza ao longo do tempo. Ele muda ou permanece sempre igual? Releia e Vamos tentar novamente.'
where id = 502;

update questoes set
  explicacao = 'Acertou! Como a hepatite C costuma ser silenciosa, só o teste revela a infecção. Hoje existe tratamento com alta taxa de cura, e quanto mais cedo o diagnóstico, menores os riscos de cirrose e câncer.',
  explicacao_erro = 'Não foi essa, mas você consegue! Se a doença evolui sem avisar, como é possível descobri-la a tempo? Releia com calma as alternativas e tente novamente.'
where id = 503;

update questoes set
  explicacao = 'Correto! Os antibióticos atacam alvos específicos das bactérias, como a parede celular e os ribossomos bacterianos, que os vírus não possuem. Por isso gripe e resfriado não se tratam com antibiótico.',
  explicacao_erro = 'Não desanime! Lembre-se de que vírus não são células e não têm parede celular nem metabolismo próprio. Em que os antibióticos atuam? Releia com calma as alternativas e tente novamente.'
where id = 504;

update questoes set
  explicacao = 'Muito bem! A bactéria Leptospira é eliminada na urina de roedores e, nas enchentes, se espalha na água e na lama, penetrando pela pele, principalmente se houver feridas. Evite contato com a água de enchente e procure atendimento se tiver febre depois.',
  explicacao_erro = 'Quase! Pense em quem elimina a bactéria da leptospirose e no que a enchente faz com esse material. Vamos tentar novamente.'
where id = 505;

update questoes set
  explicacao = 'Perfeito! A meningite bacteriana pode piorar em poucas horas e causar sequelas ou morte, por isso o tratamento com antibióticos deve começar o mais rápido possível. A meningite viral costuma ter evolução mais branda.',
  explicacao_erro = 'Não foi essa, mas siga em frente! Compare a gravidade das duas formas: qual delas pode piorar rapidamente e deixar sequelas? Tente novamente.'
where id = 506;

update questoes set
  explicacao = 'Acertou! A uretra feminina é mais curta e fica próxima à região anal, o que facilita a chegada de bactérias à bexiga. Beber água, urinar com regularidade e manter hábitos de higiene ajudam na prevenção.',
  explicacao_erro = 'Quase! Pense na anatomia: o que muda na uretra feminina em comparação à masculina e como isso afeta o caminho das bactérias? Vamos tentar novamente.'
where id = 507;

update questoes set
  explicacao = 'Excelente! A sífilis tem tratamento eficaz e gratuito no SUS (penicilina). Diagnosticar cedo impede as fases graves, protege o bebê na gestação e interrompe a transmissão para outras pessoas.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Lembre-se de que a sífilis tem cura quando tratada. O que o diagnóstico precoce muda na evolução da doença e na transmissão? Tente novamente.'
where id = 508;

update questoes set
  explicacao = 'Muito bem! O medo do preconceito levava pessoas a esconder as manchas e a demorar a procurar ajuda, o que atrasava o tratamento e mantinha a transmissão. Hoje a hanseníase tem cura e o tratamento é gratuito pelo SUS.',
  explicacao_erro = 'Quase! Pense no efeito do preconceito sobre quem tem sintomas: a pessoa procura ajuda mais rápido ou mais devagar? Releia com calma as alternativas e tente novamente.'
where id = 509;

update questoes set
  explicacao = 'Correto! A Salmonella se espalha por alimentos mal conservados, mal cozidos ou manipulados sem higiene, como ovos, carnes e maionese. Em eventos com muita comida, cuidados com temperatura e higiene são essenciais.',
  explicacao_erro = 'Não foi essa, mas continue! Pense nos cuidados de higiene, conservação e cozimento dos alimentos servidos para muita gente. Vamos tentar novamente.'
where id = 510;

update questoes set
  explicacao = 'Muito bem! Água tratada e esgoto bem destinado reduzem a exposição a micro-organismos causadores de diarreias, cólera, febre tifoide e leptospirose. O saneamento é uma das medidas de saúde pública mais eficazes.',
  explicacao_erro = 'Quase! Pense no caminho do micro-organismo: o saneamento aproxima ou afasta as pessoas da água contaminada? Vamos tentar novamente.'
where id = 511;

update questoes set
  explicacao = 'Acertou! O ciclo da esquistossomose depende de ovos nas fezes chegando à água e infectando caramujos. Com esgoto tratado, o ciclo é interrompido. O tratamento dos doentes continua importante, mas não substitui o saneamento.',
  explicacao_erro = 'Não desanime! Relembre o ciclo do parasita: os ovos saem nas fezes e precisam chegar à água para infectar o caramujo. O que o saneamento faz com esse caminho? Vamos tentar novamente.'
where id = 512;

update questoes set
  explicacao = 'Correto! O Toxoplasma gondii pode atravessar a placenta e causar desde alterações leves até lesões graves no bebê. Por isso o pré-natal inclui exames e orientações, como evitar carne crua e cuidar da higiene com gatos e hortaliças.',
  explicacao_erro = 'Quase lá! Lembre-se de que o parasita pode passar da mãe para o bebê durante a gravidez. Isso muda a importância da prevenção na gestação? Releia com calma as alternativas e tente novamente.'
where id = 513;

update questoes set
  explicacao = 'Muito bem! A giardíase é causada pela Giardia lamblia e a amebíase pela Entamoeba histolytica, dois protozoários distintos. Ambas se transmitem por água e alimentos contaminados.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Giardia e Entamoeba são seres unicelulares eucariontes, parasitas intestinais. A que grupo eles pertencem? Vamos tentar novamente.'
where id = 514;

update questoes set
  explicacao = 'Acertou! Ovos e cistos de parasitas, e bactérias presentes no esgoto, podem chegar às hortaliças pela água de irrigação ou pelo solo. Lavar bem e higienizar as verduras e proteger as hortas do esgoto reduz o risco.',
  explicacao_erro = 'Quase! Pense no caminho que o esgoto pode fazer até a horta: pela água de irrigação ou pelo solo. Esse contato aumenta ou diminui o risco? Tente de novo.'
where id = 515;

update questoes set
  explicacao = 'Correto! Sentir ansiedade antes de uma prova é normal. Quando os sintomas são intensos, persistentes e atrapalham a rotina, pode ser um transtorno e vale buscar ajuda profissional.',
  explicacao_erro = 'Quase! Pense em quando a ansiedade deixa de ser uma reação passageira e passa a atrapalhar a vida. O que muda: intensidade, duração ou os dois? Vamos tentar novamente.'
where id = 516;

update questoes set
  explicacao = 'Muito bem! No ambiente digital, as ofensas se espalham rápido, ficam registradas e podem chegar à vítima a qualquer hora, até dentro de casa. Se presenciar ou sofrer cyberbullying, guarde provas e procure um adulto de confiança.',
  explicacao_erro = 'Não desanime! Pense no que a internet muda: o alcance, o horário e o lugar onde a agressão pode acontecer. Releia e tente novamente.'
where id = 517;

update questoes set
  explicacao = 'Acertou! Telas à noite atrapalham a rotina de descanso, e o fluxo constante de estímulos e comparações nas redes pode aumentar a ansiedade. Desligar os aparelhos antes de dormir ajuda o sono.',
  explicacao_erro = 'Quase! Pense nos estímulos contínuos das telas e no que eles fazem com o descanso e com a mente. Vamos tentar novamente.'
where id = 518;

update questoes set
  explicacao = 'Correto! O burnout resulta de sobrecarga prolongada e causa exaustão, desmotivação e queda no desempenho, e não se resolve com uma noite de descanso. Ele também pode atingir estudantes.',
  explicacao_erro = 'Não foi dessa vez, mas continue! Compare: o estresse de uma prova passa depois dela, e o burnout vem de um desgaste longo. Qual alternativa descreve isso? Vamos tentar novamente.'
where id = 519;

update questoes set
  explicacao = 'Muito bem! Em um espaço acolhedor, os jovens falam sobre o que sentem, percebem que não estão sozinhos e dificuldades podem ser identificadas cedo. Elas complementam, e não substituem, o cuidado clínico.',
  explicacao_erro = 'Quase! Pense no valor de ter um espaço seguro para falar sobre emoções. Isso ajuda a perceber problemas mais cedo? Releia com calma as alternativas e tente novamente.'
where id = 520;

update questoes set
  explicacao = 'Correto! Transtornos como anorexia e bulimia resultam da combinação de fatores biológicos, psicológicos e sociais, e não de uma simples escolha. O tratamento costuma envolver equipe multiprofissional.',
  explicacao_erro = 'Não desanime! “Multifatorial” quer dizer que há várias causas atuando juntas. Qual alternativa reúne mais de um tipo de fator? Tente novamente.'
where id = 521;

update questoes set
  explicacao = 'Acertou! Todo mundo sente tristeza em algum momento. Na depressão, os sintomas duram semanas ou mais e prejudicam o estudo, o trabalho e as relações. Se isso estiver acontecendo, procurar ajuda é um ato de cuidado.',
  explicacao_erro = 'Quase! Pense em quanto tempo os sintomas duram e no quanto atrapalham o dia a dia. Releia e Vamos tentar novamente.'
where id = 522;

update questoes set
  explicacao = 'Muito bem! Profissionais de saúde mental avaliam, orientam e tratam, e quanto antes a ajuda chega, melhores as chances de recuperação. Pedir ajuda não é sinal de fraqueza.',
  explicacao_erro = 'Não foi essa, mas você está quase lá! Se o sofrimento continua por muito tempo, esperar passar sozinho é a melhor saída? Pense no papel do profissional e tente novamente.'
where id = 523;

update questoes set
  explicacao = 'Correto! Quem sofre bullying pode desenvolver ansiedade, depressão e isolamento, e quem pratica pode consolidar comportamentos agressivos. Por isso a prevenção deve envolver os dois lados.',
  explicacao_erro = 'Quase! O bullying não é só brincadeira: pense nos efeitos sobre quem sofre e também sobre quem agride. Vamos tentar novamente.'
where id = 524;

update questoes set
  explicacao = 'Muito bem! Perder o controle do tempo de uso, se isolar e dormir mal são sinais de alerta. Se perceber isso em você ou em alguém, converse com alguém de confiança e busque orientação.',
  explicacao_erro = 'Não desanime! Procure a alternativa que descreve prejuízos causados pelo uso exagerado, e não benefícios. Vamos tentar novamente.'
where id = 525;

update questoes set
  explicacao = 'Correto! Na inclusão, a escola muda (estrutura, métodos, atitudes) para receber todos os estudantes. Na integração, o estudante é quem precisa se ajustar ao que já existe. A inclusão é o modelo defendido hoje.',
  explicacao_erro = 'Quase! Pense em quem precisa mudar em cada modelo: o estudante ou o ambiente? Releia com calma as alternativas e tente novamente.'
where id = 526;

update questoes set
  explicacao = 'Muito bem! Os homens (XY) têm só um X, então um único alelo recessivo já se manifesta. As mulheres (XX) precisam ter o alelo nos dois cromossomos para serem afetadas, por isso as duas condições são mais frequentes nos homens.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Compare homens (XY) e mulheres (XX): em quem um único alelo recessivo no X aparece sem “reserva” de um segundo X? Tente novamente.'
where id = 527;

update questoes set
  explicacao = 'Correto! O diabetes está ligado à falta de insulina (tipo 1) ou à má resposta a ela (tipo 2). Como a insulina é um hormônio produzido pelo pâncreas, o diabetes é uma doença endócrina.',
  explicacao_erro = 'Quase! Pense em qual hormônio controla a glicose no sangue e no que acontece quando ele falta ou não funciona bem. Vamos tentar novamente.'
where id = 528;

update questoes set
  explicacao = 'Acertou! Na alergia, o sistema imune ataca como se fosse uma ameaça substâncias comuns, como pólen, poeira ou alguns alimentos. Evitar o alérgeno e buscar orientação médica são as principais medidas.',
  explicacao_erro = 'Não desanime! Alergia envolve o sistema imunológico em ação, e não parado. Como ele reage a algo inofensivo? Releia e tente novamente.'
where id = 529;

update questoes set
  explicacao = 'Muito bem! O antibiótico usado de forma errada elimina as bactérias sensíveis e deixa as resistentes se multiplicarem, o que é seleção natural em ação. Usar apenas com prescrição e completar o tratamento reduz esse risco.',
  explicacao_erro = 'Quase! Pense em quais bactérias sobrevivem a um antibiótico usado de forma incorreta e no que elas fazem depois. Vamos tentar novamente.'
where id = 530;

update questoes set
  explicacao = 'Correto! A resistência natural é característica da espécie desde sempre, e a adquirida surge depois, por mutações ou troca de genes, sendo favorecida pela pressão do uso de antibióticos. Por isso o uso racional desses medicamentos é tão importante.',
  explicacao_erro = 'Não foi dessa vez, mas continue! Pense no sentido de “adquirida”: algo que surge depois, e não que já existia desde a origem. Qual alternativa descreve isso? Tente novamente.'
where id = 531;

update questoes set
  explicacao = 'Muito bem! Doença ocupacional é aquela causada ou agravada pelas condições de trabalho, como a perda auditiva induzida por ruído. O uso de protetores e a organização do ambiente ajudam a preveni-la.',
  explicacao_erro = 'Quase! Procure a alternativa em que a causa está diretamente ligada ao ambiente ou à atividade de trabalho. Vamos tentar novamente.'
where id = 532;

update questoes set
  explicacao = 'Correto! Produtos químicos podem causar intoxicações, e movimentos repetitivos podem causar lesões como a tendinite (LER/DORT). Equipamentos de proteção, pausas e boa ergonomia são medidas essenciais.',
  explicacao_erro = 'Não desanime! Pense nos riscos de repetir o mesmo movimento por anos ou de lidar com substâncias tóxicas sem proteção. Eles ficam sem efeito? Tente novamente.'
where id = 533;

update questoes set
  explicacao = 'Acertou! Nessas doenças, os neurônios e suas conexões vão sendo perdidos aos poucos, e por isso os sintomas pioram com o tempo. O Alzheimer, por exemplo, afeta principalmente a memória e outras funções cognitivas.',
  explicacao_erro = 'Quase! O nome já ajuda: neurodegenerativas são doenças em que os neurônios se degeneram. O que isso significa para a evolução ao longo do tempo? Vamos tentar novamente.'
where id = 534;

update questoes set
  explicacao = 'Muito bem! Em geral há uma predisposição genética que se manifesta sob influência do ambiente e dos hábitos de vida, como alimentação, sedentarismo e estresse. Por isso a prevenção continua valendo, mesmo com histórico familiar.',
  explicacao_erro = 'Não foi essa, mas você consegue! Evite respostas com “exclusivamente”: pense em como genes e ambiente podem atuar juntos. Vamos tentar novamente.'
where id = 535;

update questoes set
  explicacao = 'Muito bem! O vapor dos cigarros eletrônicos contém nicotina e outras substâncias tóxicas, que causam dependência e podem prejudicar os pulmões, principalmente em adolescentes. No Brasil, a venda é proibida pela Anvisa.',
  explicacao_erro = 'Não desanime! O “vapor” desses aparelhos é só água? Pense no que existe nos líquidos usados e nos efeitos da nicotina. Tente novamente.'
where id = 536;

update questoes set
  explicacao = 'Perfeito! Dizer “não” e manter a decisão é um exemplo de autonomia, e buscar apoio de um adulto de confiança fortalece essa escolha. Amizades de verdade respeitam os limites de cada um.',
  explicacao_erro = 'Quase! Autonomia é decidir por si mesmo, sem se deixar levar pela pressão. Qual alternativa mostra isso? Releia com calma as alternativas e tente novamente.'
where id = 537;

update questoes set
  explicacao = 'Correto! O álcool reduz reflexos e atenção, e dirigir depois de beber é uma das principais causas de acidentes graves. Se beber, não dirija: peça a um motorista sóbrio ou use outro transporte.',
  explicacao_erro = 'Não foi essa, mas siga firme! Atenção: três opções são formas seguras de voltar para casa. Qual delas coloca a vida em risco? Tente novamente.'
where id = 538;

update questoes set
  explicacao = 'Muito bem! Acolher sem julgar e incentivar a procura por um profissional, como no CAPS ou na unidade de saúde, é a forma mais eficaz de ajudar. Ameaças e segredos costumam afastar a pessoa do tratamento.',
  explicacao_erro = 'Quase! Pense em uma atitude que ajude de verdade, com acolhimento e orientação profissional, em vez de ameaçar, esconder ou trocar uma substância por outra. Vamos tentar novamente.'
where id = 539;

update questoes set
  explicacao = 'Excelente! A prevenção funciona melhor com informação de qualidade, habilidades para decidir e uma rede de apoio forte. Falar abertamente sobre o tema protege mais do que o silêncio.',
  explicacao_erro = 'Não desanime! Pense no que realmente protege: silêncio, remédio sem avaliação ou conselhos de colegas, ou informação confiável e apoio? Tente novamente.'
where id = 540;

update questoes set
  explicacao = 'Correto! O cyberbullying pode acontecer em qualquer ambiente digital, inclusive em jogos on-line. Se for vítima ou testemunha, guarde as provas e converse com um adulto de confiança.',
  explicacao_erro = 'Quase! Pense em onde as pessoas se comunicam on-line hoje: redes, mensagens, jogos... A agressão fica restrita a um único lugar? Releia com calma as alternativas e tente novamente.'
where id = 541;

update questoes set
  explicacao = 'Muito bem! Divulgar imagens íntimas sem consentimento causa grande sofrimento e é crime no Brasil. Respeitar a privacidade do outro é fundamental, e vítimas devem buscar apoio e denunciar.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Pense no impacto de expor a intimidade de alguém sem permissão. Isso é inofensivo ou violência? Tente novamente.'
where id = 542;

update questoes set
  explicacao = 'Correto! A cultura de paz se constrói no dia a dia, com respeito, diálogo e cuidado com os direitos de todas as pessoas. A escola é um espaço importante para praticá-la.',
  explicacao_erro = 'Quase! Releia os elementos citados: respeito, diálogo, prevenção de conflitos e direitos humanos. Eles combinam com a ideia de paz? Vamos tentar novamente.'
where id = 543;

update questoes set
  explicacao = 'Muito bem! Pedir ajuda a um adulto de confiança ou a um serviço responsável protege a vítima e a você. Não precisa enfrentar a situação sozinho.',
  explicacao_erro = 'Não desanime! Em situações de violência, procurar ajuda de um adulto ou de um serviço adequado é arriscado ou protetor? Releia e tente novamente.'
where id = 544;

update questoes set
  explicacao = 'Correto! Discordar faz parte de qualquer relação. O que torna uma relação saudável é o respeito e a capacidade de conversar e resolver conflitos sem violência.',
  explicacao_erro = 'Quase! Pense nas suas relações: pessoas que se respeitam nunca discordam, ou conseguem discordar com respeito? Releia com calma as alternativas e tente novamente.'
where id = 545;

update questoes set
  explicacao = 'Acertou! Curtidas medem popularidade, e não veracidade. Confira sempre a informação em fontes oficiais, como Ministério da Saúde, OMS e profissionais habilitados.',
  explicacao_erro = 'Quase! Muitas curtidas garantem que uma informação seja verdadeira? Pense em como confirmar uma informação de saúde de maneira segura. Vamos tentar novamente.'
where id = 546;

update questoes set
  explicacao = 'Muito bem! Fontes oficiais e profissionais qualificados oferecem informação confiável, o que ajuda a decidir com segurança sobre a própria saúde. Buscar boa informação é um sinal de autonomia.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Pense na qualidade das informações vindas de fontes oficiais e de profissionais de saúde. Elas ajudam nas decisões? Tente novamente.'
where id = 547;

update questoes set
  explicacao = 'Excelente! Em cada célula das mulheres, um dos cromossomos X é inativado de forma aleatória. Se nas duas gêmeas essa inativação ocorreu depois da separação dos embriões, cada uma pode ter ficado com proporções diferentes de células com o X mutante ativo, e por isso uma manifestou a doença e a outra não.',
  explicacao_erro = 'Não desanime! Lembre-se de que as gêmeas monozigóticas têm o mesmo genótipo, então a diferença não está nos genes, e sim em qual X ficou ativo nas células. Pense na inativação do X e tente novamente.'
where id = 548;

update questoes set
  explicacao = 'Excelente! Se O = 25%, então r = 0,5; se A homozigoto = 16%, então p = 0,4; logo q = 0,1. O grupo B (q² + 2qr) é 0,01 + 0,10 = 11%, e doadores compatíveis para o grupo B são B e O: 11% + 25% = 36%.',
  explicacao_erro = 'Não desanime! Comece achando as frequências: r² = 0,25 dá r = 0,5, e p² = 0,16 dá p = 0,4, então q = 1 − 0,4 − 0,5 = 0,1. Doadores compatíveis para B são os grupos B e O. Some as duas frequências. Vamos tentar novamente.'
where id = 549;

update questoes set
  explicacao = 'Muito bem! Como a inativação do X é aleatória, cada mulher heterozigota pode ter proporções diferentes de células com o alelo recessivo ativo, e a doença se manifesta com intensidade variável. Isso é expressividade variável.',
  explicacao_erro = 'Não desanime! Como o X inativado varia de uma mulher para outra, a proporção de células afetadas muda. Que termo descreve a variação na intensidade com que um genótipo se manifesta? Tente novamente.'
where id = 550;

update questoes set
  explicacao = 'Correto! O texto diz que os micronúcleos são fragmentos de DNA. Na divisão celular, fragmentos de cromossomos que não se ligam ao fuso ficam para trás e são encapsulados, formando os micronúcleos.',
  explicacao_erro = 'Quase! Releia: micronúcleos são fragmentos de DNA vindos da divisão celular. Qual estrutura contém o DNA organizado e se separa durante a mitose? Vamos tentar novamente.'
where id = 551;

update questoes set
  explicacao = 'Excelente! Cada pessoa com trissomia produz gametas com um ou com dois cromossomos 21. Combinando os gametas do casal: 1+1 = 2 (normal), 1+2 = 3 (trissômico) e 2+2 = 4 (tetrassômico). Logo, os três tipos de zigoto são possíveis.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Cada pai pode formar gametas com 1 ou com 2 cromossomos 21. Faça todas as combinações possíveis entre os gametas do casal e conte quantos cromossomos 21 cada zigoto terá. Vamos tentar novamente.'
where id = 552;

update questoes set
  explicacao = 'Muito bem! A RT-PCR parte do RNA mensageiro para produzir cDNA. Como só existe RNAm de genes que estão sendo transcritos, a técnica detecta genes expressos em determinado momento.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! A transcriptase reversa trabalha com RNA, e só genes ativos geram RNAm. Qual alternativa se refere a genes que estão sendo transcritos? Tente novamente.'
where id = 553;

update questoes set
  explicacao = 'Correto! Os lisossomos contêm enzimas ácidas que digerem moléculas dentro da célula, como a lipase ácida. Se a enzima falta, lipídios se acumulam: é uma doença de depósito lisossômico.',
  explicacao_erro = 'Quase! A enzima chama-se lipase ácida e degrada lipídios dentro da célula. Qual organela é a “central de digestão” celular, com enzimas que funcionam em pH ácido? Vamos tentar novamente.'
where id = 554;

update questoes set
  explicacao = 'Muito bem! A vitamina A é essencial para a visão, e sua carência causa cegueira noturna e outros problemas oculares. O arroz dourado é um exemplo de alimento transgênico criado para combater essa deficiência.',
  explicacao_erro = 'Não desanime! O betacaroteno é precursor da vitamina A. Qual doença da lista está ligada à falta dessa vitamina e à visão? Lembre-se: escorbuto é falta de vitamina C e raquitismo, de vitamina D. Tente novamente.'
where id = 555;

update questoes set
  explicacao = 'Muito bem! O SUS, Sistema Único de Saúde, cuida da saúde de todos os brasileiros e oferece atendimento, vacinas e remédios gratuitos. O Brasil foi o primeiro país do mundo a oferecer a vacina contra a dengue em um sistema público de saúde.',
  explicacao_erro = 'Não desista! Esse sistema tem uma sigla de três letras e é responsável por postos de saúde, vacinas gratuitas e muito mais. Vamos tentar novamente?'
where id = 556;

update questoes set
  explicacao = 'Muito bem! Na farmácia encontramos medicamentos e vacinas e podemos receber orientações do farmacêutico sobre como usá-los.',
  explicacao_erro = 'Quase! A farmácia é um lugar de cuidado, com orientação, e não de pegar qualquer remédio. O que o farmacêutico faz por nós? Vamos tentar novamente?'
where id = 557;

update questoes set
  explicacao = 'Correto! O farmacêutico orienta sobre o uso correto do medicamento e esclarece dúvidas sobre o tratamento.',
  explicacao_erro = 'Quase! O farmacêutico é um profissional de saúde que ajuda quem tem dúvidas. Qual atitude ajuda a mãe de Lucas? Vamos tentar novamente?'
where id = 558;

update questoes set
  explicacao = 'Isso! O farmacêutico ajuda orientando sobre o uso correto dos medicamentos. Cada profissional de saúde tem a sua função.',
  explicacao_erro = 'Boa tentativa! Cada profissional tem suas funções e seus limites. O que faz parte do trabalho do farmacêutico? Vamos tentar novamente?'
where id = 559;

update questoes set
  explicacao = 'Muito bem! Propaganda não é receita. O mais seguro é conversar com um adulto e buscar a orientação de um profissional de saúde antes de usar qualquer medicamento.',
  explicacao_erro = 'Quase! Remédio não deve ser tomado só porque a propaganda disse que funciona. Qual é a atitude mais segura? Vamos tentar novamente?'
where id = 560;

update questoes set
  explicacao = 'Correto! Cada profissional de saúde tem suas responsabilidades e limites de atuação. O farmacêutico não faz tudo o que o médico faz, mas eles trabalham juntos pela nossa saúde.',
  explicacao_erro = 'Quase! Médico, farmacêutico, enfermeiro: cada um estudou uma área. Será que todos fazem exatamente a mesma coisa? Vamos tentar novamente?'
where id = 561;

update questoes set
  explicacao = 'Isso! Conversar com o farmacêutico ajuda a usar o medicamento corretamente e a saber os cuidados necessários, dentro da área de atuação dele.',
  explicacao_erro = 'Boa tentativa! O farmacêutico ajuda muito, mas não substitui o médico nem a receita. O que ele pode fazer por nós? Vamos tentar novamente?'
where id = 562;

update questoes set
  explicacao = 'Muito bem! Para o tratamento funcionar, usamos o medicamento certo, na quantidade e pelo tempo indicados.',
  explicacao_erro = 'Quase! Remédio é coisa séria. O que Ana deve fazer para usá-lo do jeito certo? Vamos tentar novamente?'
where id = 563;

update questoes set
  explicacao = 'Correto! Cada pessoa é diferente, e um remédio que ajudou uma colega pode fazer mal a outra. Antes de usar qualquer medicamento, peça orientação a um adulto e a um profissional de saúde.',
  explicacao_erro = 'Quase! Um remédio que funciona para uma pessoa pode não servir para outra. O que Pedro deve fazer antes de usar? Vamos tentar novamente?'
where id = 564;

update questoes set
  explicacao = 'Verdadeiro! Tomar o medicamento nas doses e nos intervalos corretos faz com que ele funcione como planejado e com segurança.',
  explicacao_erro = 'Ops! Será que tomar menos ou mais do que o profissional indicou é seguro? Vamos tentar novamente?'
where id = 565;

update questoes set
  explicacao = 'Falso, muito bem! Antibióticos e outros medicamentos controlados exigem prescrição médica e dispensação orientada na farmácia, porque o uso errado pode fazer mal.',
  explicacao_erro = 'Quase! Antibióticos são remédios fortes. Será que qualquer pessoa pode usá-los sem receita? Vamos tentar novamente?'
where id = 566;

update questoes set
  explicacao = 'Verdadeiro! A distribuição gratuita e organizada de medicamentos na Atenção Primária faz parte da assistência farmacêutica do SUS, que garante acesso a remédios importantes.',
  explicacao_erro = 'Quase! O SUS oferece remédios gratuitos nas UBS. Isso faz parte do cuidado com a saúde? Vamos tentar novamente?'
where id = 567;

update questoes set
  explicacao = 'Isso! Tomar remédio por conta própria ou por conselho de vizinho pode causar reações ruins ou intoxicação. Só um profissional de saúde sabe qual remédio é certo para cada pessoa.',
  explicacao_erro = 'Boa tentativa! Cada remédio tem seu uso e seus riscos. O que pode acontecer se usarmos o remédio errado? Vamos tentar novamente?'
where id = 568;

update questoes set
  explicacao = 'Falso, parabéns! Mesmo que a febre ou a dor passem, é preciso tomar o antibiótico até o fim do prazo indicado pelo médico, para não deixar os microrganismos voltarem mais fortes.',
  explicacao_erro = 'Quase! Sentir-se melhor não quer dizer que o tratamento acabou. O que o médico orienta fazer? Vamos tentar novamente?'
where id = 569;

update questoes set
  explicacao = 'Verdadeiro! Tomar o remédio no horário certinho e na quantidade indicada ajuda o corpo a se curar com segurança.',
  explicacao_erro = 'Ops! O médico marca horário e quantidade por um motivo. Seguir essa orientação ajuda ou atrapalha? Vamos tentar novamente?'
where id = 570;

update questoes set
  explicacao = 'Muito bem! Mesmo melhorando no 3º dia, é preciso continuar tomando o remédio até completar os 7 dias, como o médico orientou.',
  explicacao_erro = 'Quase! O médico disse 7 dias. Melhorar antes do fim não muda o tratamento. Qual é a atitude certa? Vamos tentar novamente?'
where id = 571;

update questoes set
  explicacao = 'Correto! Na UBS, a farmácia garante a distribuição de remédios essenciais e orienta como usá-los com segurança.',
  explicacao_erro = 'Quase! A farmácia da UBS cuida dos remédios e das orientações de uso. Qual alternativa descreve o seu papel? Vamos tentar novamente?'
where id = 572;

update questoes set
  explicacao = 'Correto! Automedicação é usar remédios por conta própria, sem orientação adequada, o que traz riscos como intoxicação e mascarar doenças.',
  explicacao_erro = 'Quase! “Auto” lembra “por conta própria”. Qual alternativa descreve isso? Vamos tentar novamente?'
where id = 573;

update questoes set
  explicacao = 'Isso mesmo! O uso inadequado de medicamentos pode trazer riscos à saúde, por isso é preciso cuidado e orientação.',
  explicacao_erro = 'Não foi dessa vez. Todo remédio tem efeitos no corpo. Por que o cuidado é necessário? Vamos tentar novamente?'
where id = 574;

update questoes set
  explicacao = 'Muito bem! Remédio que funcionou para um amigo pode não servir para você. Busque orientação adequada e não use o antibiótico de outra pessoa.',
  explicacao_erro = 'Quase! Cada pessoa e situação são diferentes. Qual atitude é segura? Vamos tentar novamente?'
where id = 575;

update questoes set
  explicacao = 'Correto! Seguir a orientação, inclusive os horários, garante que o tratamento funcione e seja seguro.',
  explicacao_erro = 'Não foi dessa vez. Os horários fazem parte da orientação do tratamento. Vamos tentar novamente?'
where id = 576;

update questoes set
  explicacao = 'Boa! Seguir as orientações dos profissionais de saúde é o uso responsável de medicamentos.',
  explicacao_erro = 'Quase! Aumentar dose, dividir remédio ou parar antes pode ser perigoso. Qual é a prática correta? Vamos tentar novamente?'
where id = 577;

update questoes set
  explicacao = 'Correto! A farmácia pode orientar a população e participar de campanhas de saúde, além de vender produtos.',
  explicacao_erro = 'Não foi dessa vez. A farmácia faz mais que vender. Vamos tentar novamente?'
where id = 578;

update questoes set
  explicacao = 'Isso mesmo! As vacinas têm como principal objetivo contribuir para a prevenção de determinadas doenças.',
  explicacao_erro = 'Quase! Vacina previne, não trata uma doença já instalada. Vamos tentar novamente?'
where id = 579;

update questoes set
  explicacao = 'Muito bem! A dose faz parte da orientação para o uso seguro. Mais ou menos que o indicado pode causar riscos ou falhar no tratamento.',
  explicacao_erro = 'Não foi dessa vez. Alterar a dose por conta própria é arriscado. Por quê? Vamos tentar novamente?'
where id = 580;

update questoes set
  explicacao = 'Correto! Usar o medicamento indicado para outra pessoa é a atitude de maior risco.',
  explicacao_erro = 'Quase! A pergunta pede o maior risco. Qual atitude ignora a orientação personalizada? Vamos tentar novamente?'
where id = 581;

update questoes set
  explicacao = 'Isso mesmo! Manter as vacinas em dia faz parte das medidas de prevenção de doenças, e vale para todas as idades.',
  explicacao_erro = 'Não foi dessa vez. Vacinar não é só para a infância nem só para viagens. Vamos tentar novamente?'
where id = 582;

update questoes set
  explicacao = 'Correto! O que ajuda uma pessoa pode não ser apropriado para outra, por causa de idade, peso, doenças e alergias.',
  explicacao_erro = 'Quase! Cada pessoa é única. Qual alternativa reconhece isso? Vamos tentar novamente?'
where id = 583;

update questoes set
  explicacao = 'Muito bem! Manter a vacinação em dia é prevenção. As outras opções são práticas arriscadas.',
  explicacao_erro = 'Não foi dessa vez. Qual atitude evita doenças antes de elas aparecerem? Vamos tentar novamente?'
where id = 584;

update questoes set
  explicacao = 'Correto! Medicamentos e vacinas são recursos de saúde com finalidades diferentes: um trata e outro previne.',
  explicacao_erro = 'Quase! Eles se complementam, mas não são iguais. Vamos tentar novamente?'
where id = 585;

update questoes set
  explicacao = 'Isso mesmo! Mesmo vendido na farmácia, todo produto de saúde exige uso responsável e orientado.',
  explicacao_erro = 'Não foi dessa vez. Vender na farmácia não significa que é livre de risco. Vamos tentar novamente?'
where id = 586;

update questoes set
  explicacao = 'Correto! Medicamentos podem ser úteis, mas seu uso precisa ser seguro e orientado.',
  explicacao_erro = 'Quase! Qual princípio equilibra benefício e cuidado? Vamos tentar novamente?'
where id = 587;

update questoes set
  explicacao = 'Isso mesmo! O uso excessivo ou incorreto de antibióticos elimina as bactérias sensíveis e deixa sobreviver as resistentes, que se multiplicam. Só tome antibiótico com prescrição e siga o tratamento até o fim.',
  explicacao_erro = 'Quase! Pense na seleção natural: quando os antibióticos são usados de forma inadequada, quais bactérias sobrevivem? Vamos tentar novamente.'
where id = 588;

update questoes set
  explicacao = 'Correto! Mesmo remédios comuns podem causar reações, mascarar sintomas e interagir com outros medicamentos. Use medicamentos apenas com orientação de um profissional de saúde.',
  explicacao_erro = 'Não desanime! Todo medicamento tem riscos além dos benefícios. Usar sem orientação pode causar problemas? Releia a frase e tente novamente.'
where id = 589;

update questoes set
  explicacao = 'Correto! Os antibióticos atuam diretamente sobre as bactérias, por exemplo danificando a parede celular ou bloqueando os ribossomos bacterianos, sem afetar as células humanas. É essa seletividade que os torna úteis.',
  explicacao_erro = 'Quase! Pense no alvo dos antibióticos: eles agem sobre o organismo do paciente ou sobre a própria bactéria? Procure a alternativa que fala de estruturas da célula bacteriana. Vamos tentar novamente.'
where id = 590;

update questoes set
  explicacao = 'Muito bem! A transfusão de sangue introduz células novas (como hemácias e plaquetas) no organismo para tratar enfermidades, sendo uma forma antiga e rotineira de terapia celular. Doar sangue salva vidas!',
  explicacao_erro = 'Quase! O texto fala em introduzir células novas em um tecido. Qual dessas técnicas coloca células de outra pessoa no corpo? Vamos tentar novamente.'
where id = 591;

update questoes set
  explicacao = 'Muito bem! Sem o fluxo de prótons pela ATP sintase, a célula produz menos ATP e precisa consumir mais nutrientes para tentar compensar, o que explica o efeito emagrecedor. Mas o DNP é perigoso e seu uso é proibido.',
  explicacao_erro = 'Quase! Se os prótons não passam pela enzima que produz ATP, o que acontece com a produção de energia e, para compensar, com o consumo de nutrientes? Vamos tentar novamente.'
where id = 592;

update questoes set
  explicacao = 'Correto! O estômago é muito ácido, e o revestimento só se dissolve em pH próximo do neutro, como no intestino. Assim, o fármaco atravessa o estômago protegido das secreções gástricas e é liberado no local certo.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! O revestimento só libera o fármaco em pH próximo da neutralidade. Qual parte do trato digestivo é muito ácida e qual é quase neutra? Pense nisso e tente de novo.'
where id = 593;

update questoes set
  explicacao = 'Correto! O vírus funciona como transportador: leva uma cópia normal do gene para as células da retina, que passam a expressá-lo e a produzir a enzima funcional. A terapia gênica não entrega a proteína pronta, e sim o gene que a produz.',
  explicacao_erro = 'Quase! O vírus entrega uma cópia do gene normal. O que as células fazem com essa cópia para resolver o problema? Pense em expressão gênica. Vamos tentar novamente.'
where id = 594;

update questoes set
  explicacao = 'Correto! O RNAm da vacina age no citoplasma, onde os ribossomos o traduzem em proteína viral (como a espícula), e o sistema imune reage a essa proteína, criando memória imunológica sem causar a doença.',
  explicacao_erro = 'Quase! O texto diz que o RNAm atua “no mesmo compartimento celular de sempre”, ou seja, onde acontece a síntese de proteínas. O que os ribossomos fazem com o RNAm? Vamos tentar novamente.'
where id = 595;

update questoes set
  explicacao = 'Muito bem! A proteína espícula funciona como antígeno: o sistema imune a reconhece e produz anticorpos específicos, além de células de memória. É imunidade ativa, que o corpo constrói por conta própria.',
  explicacao_erro = 'Não desanime! A espícula é o antígeno da vacina. Qual é a resposta do sistema imune quando entra em contato com um antígeno? Lembre-se de que a vacina gera imunidade ativa. Tente novamente.'
where id = 596;

update questoes set
  explicacao = 'Muito bem! O antígeno da vacina não combate o vírus diretamente: ele estimula o organismo a produzir anticorpos, que são proteínas neutralizadoras, e células de memória. Assim, o corpo reage rápido se encontrar o vírus de verdade.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! O antígeno não é uma defesa pronta, e sim um estímulo para o corpo produzir a própria defesa. Qual alternativa descreve isso? Tente novamente.'
where id = 597;

update questoes set
  explicacao = 'Verdadeiro! O sono permite que o corpo recupere as energias e ajuda o cérebro a guardar o que aprendemos. Dormir bem ajuda a estudar!',
  explicacao_erro = 'Ops! Pense no que acontece com o corpo e com o cérebro quando a gente dorme bem. Será que isso ajuda a lembrar o que estudou? Vamos tentar novamente?'
where id = 598;

update questoes set
  explicacao = 'Verdadeiro! Um lanche com fruta e pão alimenta melhor o corpo do que um lanche só de salgadinho, que tem poucos nutrientes.',
  explicacao_erro = 'Quase! Pense em qual lanche tem alimentos de verdade e qual tem poucos nutrientes. Vamos tentar novamente!'
where id = 599;

update questoes set
  explicacao = 'Boa! Cada alimento fornece nutrientes diferentes, então variar o prato ajuda o corpo a receber tudo de que precisa.',
  explicacao_erro = 'Quase! Pense no que cada alimento oferece de diferente ao corpo. Vamos tentar novamente?'
where id = 600;

update questoes set
  explicacao = 'Correto! A obesidade favorece a resistência à insulina, o aumento da pressão arterial e alterações nas gorduras do sangue, elevando o risco de diabetes tipo 2 e doenças do coração. Cuidar da alimentação e da atividade física é cuidar da saúde como um todo.',
  explicacao_erro = 'Quase! A obesidade vai muito além da estética. Pense em quais doenças crônicas ela costuma acompanhar. Releia e Vamos tentar novamente.'
where id = 601;

update questoes set
  explicacao = 'Muito bem! As enzimas do acrossomo digerem as camadas que envolvem o ovócito, a corona radiata e a zona pelúcida, permitindo que o espermatozoide chegue até a membrana do óvulo. Sem elas, ele não consegue atravessar essas barreiras.',
  explicacao_erro = 'Não desanime! Pense no papel das enzimas do acrossomo: elas digerem as camadas que protegem o ovócito. Qual alternativa fala dessa passagem? Vamos tentar novamente.'
where id = 602;

update questoes set
  explicacao = 'Muito bem! O açúcar dissolvido aumenta a massa de soluto na mesma quantidade de líquido, o que torna o refrigerante comum mais denso. Por isso a lata de refrigerante comum afunda na água e a diet flutua!',
  explicacao_erro = 'Não desanime! A diferença entre as duas versões é a grande massa de açúcar do refrigerante comum. Como mais soluto dissolvido muda a densidade, a viscosidade e a temperatura de congelamento? Tente novamente.'
where id = 603;

update questoes set
  explicacao = 'Correto! A palidez é um sinal clássico de anemia, e o ferro é necessário para formar a hemoglobina. Cozinhar em panela de ferro acrescenta ferro à comida e ajuda a prevenir a anemia ferropriva.',
  explicacao_erro = 'Quase! A palidez e o mineral ferro dão uma pista: o ferro faz parte da hemoglobina do sangue. Qual doença está relacionada à falta dele? Vamos tentar novamente.'
where id = 604;

update questoes set
  explicacao = 'Isso mesmo! Um parque oferece espaço para movimento, lazer e contato com a natureza, e faz bem à saúde.',
  explicacao_erro = 'Quase! Parques ajudam, mas não substituem serviços de saúde. Vamos tentar novamente?'
where id = 605;

update questoes set
  explicacao = 'Correto! Preservar áreas verdes cuida do ambiente e da qualidade dos espaços comunitários.',
  explicacao_erro = 'Não foi dessa vez. Áreas verdes servem a todos, não só à beleza da cidade. Vamos tentar novamente?'
where id = 606;

update questoes set
  explicacao = 'Muito bem! Separar o lixo corretamente ajuda no cuidado com o ambiente e com a comunidade.',
  explicacao_erro = 'Quase! Separar o lixo tem benefícios além da aparência. Vamos tentar novamente?'
where id = 607;

update questoes set
  explicacao = 'Boa! Caminhar em um parque é uma forma de atividade física.',
  explicacao_erro = 'Não foi dessa vez. Caminhar é movimento. Que tipo de atividade é? Vamos tentar novamente?'
where id = 608;

update questoes set
  explicacao = 'Correto! O contato com espaços agradáveis pode contribuir para o bem-estar.',
  explicacao_erro = 'Quase! Ambientes agradáveis influenciam como nos sentimos. Vamos tentar novamente?'
where id = 609;

update questoes set
  explicacao = 'Isso mesmo! Resíduos no chão prejudicam o ambiente e a qualidade do espaço coletivo.',
  explicacao_erro = 'Não foi dessa vez. Lixo no chão melhora ou piora o lugar? Vamos tentar novamente?'
where id = 610;

update questoes set
  explicacao = 'Muito bem! Usar as lixeiras e preservar as áreas verdes é cidadania ambiental.',
  explicacao_erro = 'Quase! Qual atitude cuida do espaço de todos? Vamos tentar novamente?'
where id = 611;

update questoes set
  explicacao = 'Correto! Um parque limpo beneficia a comunidade e o ambiente.',
  explicacao_erro = 'Não foi dessa vez. Um parque limpo faz bem a mais gente do que parece. Vamos tentar novamente?'
where id = 612;

update questoes set
  explicacao = 'Boa! Saúde ambiental é reconhecer que as condições do ambiente podem influenciar a saúde e o bem-estar.',
  explicacao_erro = 'Quase! Poluição não é só estética. Qual afirmação liga ambiente e saúde? Vamos tentar novamente?'
where id = 613;

update questoes set
  explicacao = 'Isso mesmo! Fazer uma caminhada e descartar os resíduos corretamente une saúde física e ambiental.',
  explicacao_erro = 'Não foi dessa vez. Procure a atividade que cuida do corpo e do ambiente. Vamos tentar novamente?'
where id = 614;

update questoes set
  explicacao = 'Correto! Espaços públicos são compartilhados e seu estado afeta muitas pessoas, por isso o cuidado é coletivo.',
  explicacao_erro = 'Quase! Pense em quem usa um parque. Vamos tentar novamente?'
where id = 615;

update questoes set
  explicacao = 'Muito bem! Áreas verdes oferecem espaços onde caminhadas e outras atividades podem ser realizadas.',
  explicacao_erro = 'Não foi dessa vez. Parques incentivam, mas não obrigam nem substituem tudo. Vamos tentar novamente?'
where id = 616;

update questoes set
  explicacao = 'Isso mesmo! Lixo acumulado em um parque é problema ambiental e atrapalha o uso saudável do espaço.',
  explicacao_erro = 'Quase! Lixo é mais que um problema visual. Vamos tentar novamente?'
where id = 617;

update questoes set
  explicacao = 'Correto! O cuidado com parques relaciona meio ambiente, saúde e cidadania.',
  explicacao_erro = 'Não foi dessa vez. Esse tema envolve mais de uma área. Vamos tentar novamente?'
where id = 618;

update questoes set
  explicacao = 'Boa! Cuidar dos espaços verdes é também cuidar da qualidade de vida da comunidade.',
  explicacao_erro = 'Quase! Qual frase resume a ligação entre natureza e saúde? Vamos tentar novamente?'
where id = 619;

update questoes set
  explicacao = 'Verdadeiro, muito bem! Quando todos os vizinhos eliminam a água parada, o mosquito perde os lugares onde se reproduz e a transmissão da dengue diminui. Quando a gente se une, o cuidado fica muito mais forte!',
  explicacao_erro = 'Ops, não foi dessa vez! Imagine um bairro em que todo mundo cuida do seu quintal. Isso ajuda ou atrapalha no combate ao mosquito? Pense mais um pouquinho. Vamos tentar novamente?'
where id = 620;

update questoes set
  explicacao = 'Correto! Uma pracinha favorece movimento, convivência e atividades comunitárias, promovendo saúde.',
  explicacao_erro = 'Quase! Espaços públicos fazem muito mais que servir de descanso. Vamos tentar novamente?'
where id = 621;

update questoes set
  explicacao = 'Isso mesmo! Em dias quentes, mantenha a hidratação e cuide da exposição ao calor.',
  explicacao_erro = 'Não foi dessa vez. No calor, o corpo perde água. Como se proteger? Vamos tentar novamente?'
where id = 622;

update questoes set
  explicacao = 'Muito bem! A transpiração participa da regulação da temperatura corporal, resfriando o corpo.',
  explicacao_erro = 'Quase! O suor tem a ver com manter o corpo na temperatura adequada. Vamos tentar novamente?'
where id = 623;

update questoes set
  explicacao = 'Correto! O corpo perde água, inclusive pelo suor, e precisa repô-la, principalmente em dias quentes.',
  explicacao_erro = 'Não foi dessa vez. Pense na água perdida ao suar. Vamos tentar novamente?'
where id = 624;

update questoes set
  explicacao = 'Exato! O excesso de calor pode causar mal-estar e riscos como desidratação e insolação.',
  explicacao_erro = 'Quase! Calor em excesso faz bem ou mal ao corpo? Vamos tentar novamente?'
where id = 625;

update questoes set
  explicacao = 'Boa! Medidas de proteção contra o sol e evitar exposição excessiva ajudam a prevenir problemas de saúde.',
  explicacao_erro = 'Não foi dessa vez. Qual atitude protege do sol e do calor? Vamos tentar novamente?'
where id = 626;

update questoes set
  explicacao = 'Correto! Conversar e participar de atividades comunitárias contribui para os aspectos sociais e emocionais da saúde.',
  explicacao_erro = 'Quase! Pense no efeito de estar em contato com outras pessoas. Vamos tentar novamente?'
where id = 627;

update questoes set
  explicacao = 'Isso mesmo! A pele é uma importante barreira entre o corpo e o ambiente, protegendo contra agentes externos.',
  explicacao_erro = 'Não foi dessa vez. Pense no órgão que fica em contato direto com o ambiente. Vamos tentar novamente?'
where id = 628;

update questoes set
  explicacao = 'Muito bem! Atividade ao ar livre exige atenção às condições ambientais e aos sinais do corpo.',
  explicacao_erro = 'Quase! Além do exercício em si, o que mais importa ao ar livre? Vamos tentar novamente?'
where id = 629;

update questoes set
  explicacao = 'Correto! A saúde comunitária aparece quando o espaço recebe atividades e ações voltadas à população.',
  explicacao_erro = 'Não foi dessa vez. Qual situação mostra o espaço sendo usado pela comunidade? Vamos tentar novamente?'
where id = 630;

update questoes set
  explicacao = 'Boa! Diante de mal-estar no calor, interrompa a atividade e procure ajuda adequada, sem insistir.',
  explicacao_erro = 'Quase! Ignorar o mal-estar pode ser perigoso. Qual é a atitude correta? Vamos tentar novamente?'
where id = 631;

update questoes set
  explicacao = 'Isso mesmo! Uma caminhada comunitária adequada e segura combina saúde física e social.',
  explicacao_erro = 'Não foi dessa vez. Procure a situação que une movimento e convivência com segurança. Vamos tentar novamente?'
where id = 632;

update questoes set
  explicacao = 'Correto! A sede pode indicar necessidade de repor líquidos. Escute esse sinal do corpo.',
  explicacao_erro = 'Quase! A sede é um aviso do corpo. O que ele indica? Vamos tentar novamente?'
where id = 633;

update questoes set
  explicacao = 'Muito bem! O organismo precisa manter a temperatura dentro de limites adequados, por isso devemos evitar longos períodos sob calor intenso.',
  explicacao_erro = 'Não foi dessa vez. O corpo produz calor sim, e precisa regulá-lo. Vamos tentar novamente?'
where id = 634;

update questoes set
  explicacao = 'Correto! A promoção da saúde também acontece nos espaços públicos da comunidade, não só em hospitais.',
  explicacao_erro = 'Quase! Saúde não se promove apenas em serviços de saúde. Vamos tentar novamente?'
where id = 635;

update questoes set
  explicacao = 'Correto! A atividade física contribui para a saúde de músculos, ossos e sistema cardiovascular.',
  explicacao_erro = 'Quase! Os benefícios do exercício vão além do cabelo ou de um só sistema. Vamos tentar novamente?'
where id = 636;

update questoes set
  explicacao = 'Muito bem! Durante a corrida, o coração trabalha mais para levar oxigênio e nutrientes aos músculos.',
  explicacao_erro = 'Não foi dessa vez. O coração não para na corrida. O que ele faz? Vamos tentar novamente?'
where id = 637;

update questoes set
  explicacao = 'Isso mesmo! Esportes em grupo também beneficiam a convivência e a saúde social.',
  explicacao_erro = 'Quase! Além do corpo, o esporte coletivo ajuda em outro aspecto da saúde. Vamos tentar novamente?'
where id = 638;

update questoes set
  explicacao = 'Correto! Na atividade, o organismo precisa de mais oxigênio e por isso a respiração acelera.',
  explicacao_erro = 'Não foi dessa vez. Os pulmões e o sangue continuam trabalhando. Vamos tentar novamente?'
where id = 639;

update questoes set
  explicacao = 'Boa! Respeitar os limites do corpo e manter cuidados, como hidratação, torna a atividade segura.',
  explicacao_erro = 'Quase! Ignorar sinais do corpo é perigoso. Qual atitude é segura? Vamos tentar novamente?'
where id = 640;

update questoes set
  explicacao = 'Correto! Ossos e músculos atuam em conjunto para produzir movimentos, coordenados pelo sistema nervoso.',
  explicacao_erro = 'Não foi dessa vez. Eles trabalham juntos. Vamos tentar novamente?'
where id = 641;

update questoes set
  explicacao = 'Isso mesmo! A atividade física regular é um dos fatores que contribuem para uma vida saudável, mas não garante que nunca adoeça.',
  explicacao_erro = 'Quase! Ela ajuda, mas não substitui sono e alimentação. Vamos tentar novamente?'
where id = 642;

update questoes set
  explicacao = 'Muito bem! O sistema cardiovascular (coração e vasos) transporta oxigênio e nutrientes pelo corpo.',
  explicacao_erro = 'Não foi dessa vez. Pense no sistema que tem coração e vasos sanguíneos. Vamos tentar novamente?'
where id = 643;

update questoes set
  explicacao = 'Correto! Os sistemas do corpo trabalham de forma integrada, e por isso uma partida envolve vários deles ao mesmo tempo.',
  explicacao_erro = 'Quase! Nenhum sistema funciona isolado. Vamos tentar novamente?'
where id = 644;

update questoes set
  explicacao = 'Isso mesmo! Movimentar-se pode contribuir para o bem-estar e o humor, embora não impeça emoções negativas.',
  explicacao_erro = 'Não foi dessa vez. Cuidado com “impedir qualquer” ou “substituir”. Vamos tentar novamente?'
where id = 645;

update questoes set
  explicacao = 'Correto! Os músculos se contraem para gerar movimento, como o bíceps ao dobrar o braço.',
  explicacao_erro = 'Quase! Pense no que os músculos fazem quando nos movimentamos. Vamos tentar novamente?'
where id = 646;

update questoes set
  explicacao = 'Boa! Incorporar mais movimento adequado à rotina é uma mudança saudável e possível de manter.',
  explicacao_erro = 'Não foi dessa vez. Evite atitudes radicais, como treinar sem preparo ou dormir menos. Vamos tentar novamente?'
where id = 647;

update questoes set
  explicacao = 'Correto! Atividades coletivas favorecem interação, cooperação e convivência, que fazem bem à saúde social.',
  explicacao_erro = 'Quase! Qual benefício vem de estar com outras pessoas? Vamos tentar novamente?'
where id = 648;

update questoes set
  explicacao = 'Muito bem! Diferentes formas de movimento contribuem para a saúde, não só os esportes competitivos.',
  explicacao_erro = 'Não foi dessa vez. Atividade física não é só competição nem só para adultos. Vamos tentar novamente?'
where id = 649;

update questoes set
  explicacao = 'Isso mesmo! A saúde tem várias dimensões (corpo, mente e convivência) que se relacionam.',
  explicacao_erro = 'Quase! Corpo, mente e convivência estão ligados. Qual afirmação mostra isso? Vamos tentar novamente?'
where id = 650;

update questoes set
  explicacao = 'Muito bem! A EPO estimula a produção de hemácias, que transportam oxigênio. Com mais oxigênio chegando aos músculos, aumenta a produção de ATP na respiração aeróbica e o desempenho em provas de resistência.',
  explicacao_erro = 'Quase! Eritrócitos são as hemácias. Qual substância elas transportam e por que ela é importante para gerar energia nos músculos? Vamos tentar novamente.'
where id = 651;

update questoes set
  explicacao = 'Correto! A eritropoiese é a produção de hemácias. Com mais hemácias, o sangue transporta mais oxigênio aos músculos, melhorando a resistência. Esse tipo de doping é proibido e traz riscos à saúde, como trombose.',
  explicacao_erro = 'Quase! Eritropoiese é a produção de glóbulos vermelhos. Qual é a principal função dessas células no sangue? Vamos tentar novamente.'
where id = 652;

update questoes set
  explicacao = 'Correto! Fibras brancas têm poucas mitocôndrias e geram força rápida e explosiva por pouco tempo, ideal para provas curtas e intensas, como o salto em altura. Provas de resistência favorecem as fibras vermelhas.',
  explicacao_erro = 'Quase! Fibras brancas fazem esforços rápidos e curtos, com pouca resistência. Qual prova exige um esforço explosivo e rápido, e não longa duração? Vamos tentar novamente.'
where id = 653;

update questoes set
  explicacao = 'Correto! Um terreno baldio com lixo favorece riscos ambientais e à saúde, como a proliferação de vetores.',
  explicacao_erro = 'Quase! O lixo acumulado melhora ou piora o ambiente? Vamos tentar novamente?'
where id = 654;

update questoes set
  explicacao = 'Isso mesmo! Recipientes que acumulam água podem virar criadouros de mosquitos, como o Aedes aegypti.',
  explicacao_erro = 'Não foi dessa vez. Pense no que os mosquitos precisam para se reproduzir. Vamos tentar novamente?'
where id = 655;

update questoes set
  explicacao = 'Muito bem! O descarte correto previne problemas ambientais e de saúde, e vai muito além da aparência.',
  explicacao_erro = 'Quase! Descartar corretamente traz benefícios amplos. Vamos tentar novamente?'
where id = 656;

update questoes set
  explicacao = 'Correto! Vetor é um organismo que participa da transmissão de um agente infeccioso, como o mosquito da dengue.',
  explicacao_erro = 'Não foi dessa vez. O vetor leva o agente, mas não é necessariamente o causador. Vamos tentar novamente?'
where id = 657;

update questoes set
  explicacao = 'Exato! Pneus e recipientes acumulando água merecem atenção, pois podem abrigar larvas de mosquitos.',
  explicacao_erro = 'Quase! Procure a situação que representa risco. Vamos tentar novamente?'
where id = 658;

update questoes set
  explicacao = 'Boa! Limpar terrenos reduz condições favoráveis a vetores e outros riscos. Não elimina todos os insetos, mas ajuda muito.',
  explicacao_erro = 'Não foi dessa vez. Cuidado com afirmações absolutas, como “elimina todas”. Vamos tentar novamente?'
where id = 659;

update questoes set
  explicacao = 'Correto! Descartar entulho em terreno vazio é inadequado e cria problemas ambientais e de saúde.',
  explicacao_erro = 'Quase! A pergunta pede a atitude inadequada. Vamos tentar novamente?'
where id = 660;

update questoes set
  explicacao = 'Isso mesmo! Lixo acumulado pode aumentar o risco de acidentes, além de atrair animais e vetores.',
  explicacao_erro = 'Não foi dessa vez. Pense nos perigos de áreas cheias de lixo. Vamos tentar novamente?'
where id = 661;

update questoes set
  explicacao = 'Muito bem! Riscos ambientais de um terreno mal cuidado podem atingir pessoas da comunidade, por isso é questão de saúde coletiva.',
  explicacao_erro = 'Quase! Evite exageros como “tudo” ou “qualquer”. Qual afirmação é equilibrada? Vamos tentar novamente?'
where id = 662;

update questoes set
  explicacao = 'Correto! Lixo acumulado somado a recipientes com água parada é a combinação de maior risco.',
  explicacao_erro = 'Não foi dessa vez. Procure a mistura que favorece mais os mosquitos. Vamos tentar novamente?'
where id = 663;

update questoes set
  explicacao = 'Boa! Se ainda há recipientes que acumulam chuva, o problema não foi totalmente resolvido: eles podem virar criadouros.',
  explicacao_erro = 'Quase! Limpar o lixo é ótimo, mas ainda falta algo. O quê? Vamos tentar novamente?'
where id = 664;

update questoes set
  explicacao = 'Correto! A prevenção pode envolver mudanças ambientais que reduzam locais favoráveis aos vetores.',
  explicacao_erro = 'Não foi dessa vez. Prevenir é agir sobre o ambiente, não só tratar quem adoeceu. Vamos tentar novamente?'
where id = 665;

update questoes set
  explicacao = 'Isso mesmo! Cuidar de terrenos mostra que ações comunitárias e ambientais também interferem na saúde.',
  explicacao_erro = 'Quase! Ambiente e saúde estão ligados. Qual alternativa mostra isso? Vamos tentar novamente?'
where id = 666;

update questoes set
  explicacao = 'Muito bem! Alguns vetores usam pequenos acúmulos de água, como uma tampinha com água de chuva.',
  explicacao_erro = 'Não foi dessa vez. O Aedes se reproduz até em pouca água. Vamos tentar novamente?'
where id = 667;

update questoes set
  explicacao = 'Correto! Manter o local limpo e eliminar acúmulos de água é a melhor estratégia preventiva.',
  explicacao_erro = 'Quase! Qual estratégia age antes de surgirem casos? Vamos tentar novamente?'
where id = 668;

update questoes set
  explicacao = 'Isso mesmo! O Aedes aegypti deposita seus ovos em água parada, e eliminar pratos de vaso, pneus, garrafas e outros recipientes reduz muito os criadouros. Cada casa faz diferença no combate à dengue.',
  explicacao_erro = 'Não foi dessa vez, mas continue! Lembre-se de onde o Aedes se reproduz: água parada. Eliminar esses recipientes ajuda ou não? Tente novamente.'
where id = 669;

update questoes set
  explicacao = 'Muito bem! Os antirretrovirais, como os usados contra o HIV, interferem em etapas da reprodução do retrovírus, como a transcrição reversa, e permitem que as pessoas vivam bem por muitos anos.',
  explicacao_erro = 'Quase! O enunciado fala de medicamentos para tratar a infecção, e o HIV não tem vetor nem vacina disponível. Qual alternativa trata de medicamentos que atuam na reprodução do vírus? Vamos tentar novamente.'
where id = 670;

update questoes set
  explicacao = 'Muito bem! O protozoário modificado apresenta ao sistema imune a molécula tumoral como antígeno, e as células de defesa aprendem a reconhecê-la e passam a destruir as células do tumor. É a base da imunoterapia contra o câncer.',
  explicacao_erro = 'Não foi dessa vez, mas continue! O texto diz que o sistema imune passa a “ver” a molécula tumoral como indicador do protozoário. Qual processo apresenta um antígeno às células de defesa? Tente novamente.'
where id = 671;

update questoes set
  explicacao = 'Muito bem! O texto indica que tanto a bactéria quanto o vírus precisam entrar nas células para se reproduzir, o que leva a uma competição no hospedeiro e reduz a carga viral no mosquito. Esse é o princípio do Método Wolbachia.',
  explicacao_erro = 'Não desanime! O texto diz que a Wolbachia reduz a carga viral e que a bactéria e o vírus precisam das mesmas células para se reproduzir. O que isso sugere sobre a relação entre os dois? Releia e tente novamente.'
where id = 672;

update questoes set
  explicacao = 'Muito bem! A filariose é transmitida por mosquitos (Culex) e a leishmaniose, por flebotomíneos (mosquito-palha). Em ambas, controlar os vetores é uma medida preventiva comum.',
  explicacao_erro = 'Não foi dessa vez, mas continue! As duas doenças são transmitidas por insetos. Qual medida atua sobre esses transmissores? Releia e tente novamente.'
where id = 673;

update questoes set
  explicacao = 'Correto! A transmissão é indireta, pela picada do flebotomíneo (mosquito-palha), que se infecta ao sugar o sangue do cão contendo o protozoário. Por isso o sangue é o material de risco, e não urina, saliva ou fezes.',
  explicacao_erro = 'Quase! O texto diz que a transmissão é feita por um vetor, um inseto que pica. De qual material do cão esse inseto se alimenta e pode se infectar? Tente novamente.'
where id = 674;

update questoes set
  explicacao = 'Correto! A urbanização desordenada, com acúmulo de água em lixo, pneus e recipientes e falta de saneamento, cria criadouros dentro das cidades e aproxima as pessoas dos mosquitos transmissores de arboviroses.',
  explicacao_erro = 'Quase! O enunciado trata de doenças transmitidas por mosquitos. Qual alternativa relaciona a urbanização a esses insetos, e não a outros problemas ambientais? Vamos tentar novamente.'
where id = 675;

update questoes set
  explicacao = 'Falso, parabéns! A vacina é um reforço importante, mas o controle do mosquito continua sendo o principal método de prevenção. Ela sozinha não acaba com os mosquitos, então a água parada nos pratinhos de plantas e nos pneus continua sendo um perigo.',
  explicacao_erro = 'Quase! A vacina ajuda muito, mas será que ela faz os mosquitos sumirem? Pense nos pratinhos de plantas e nos pneus. Vamos tentar novamente?'
where id = 676;

update questoes set
  explicacao = 'Muito bem! A UBS, o posto de saúde, é um serviço que cuida da saúde das pessoas e da comunidade, com vacinas, consultas, orientações e prevenção de doenças.',
  explicacao_erro = 'Quase! A UBS é o posto de saúde do bairro e faz muito mais do que exames ou ensino. Pense no que um posto de saúde faz pela comunidade. Vamos tentar novamente?'
where id = 677;

update questoes set
  explicacao = 'Isso! A UBS ajuda as pessoas a cuidar da saúde, prevenir doenças e receber orientações de profissionais de saúde, perto de casa.',
  explicacao_erro = 'Boa tentativa! A UBS não serve só para quem está muito doente. Pense nos vários cuidados que ela oferece. Vamos tentar novamente?'
where id = 678;

update questoes set
  explicacao = 'Correto! Conversar com os profissionais da UBS ajuda a entender melhor como cuidar da saúde e tirar dúvidas. Perguntar é um jeito de se cuidar!',
  explicacao_erro = 'Quase! Conversar ajuda, mas não substitui tratamentos. O que a gente ganha ao tirar dúvidas com quem entende de saúde? Vamos tentar novamente?'
where id = 679;

update questoes set
  explicacao = 'Muito bem! Na UBS, cada profissional contribui com seus conhecimentos e ajuda em diferentes necessidades de saúde. Trabalhar em equipe cuida melhor das pessoas.',
  explicacao_erro = 'Quase! Cada profissional estudou uma área diferente. Por que é bom ter vários profissionais juntos? Vamos tentar novamente?'
where id = 680;

update questoes set
  explicacao = 'Isso! Ouvir as pessoas ajuda a UBS a conhecer as dúvidas, necessidades e dificuldades da comunidade e a cuidar melhor de todos.',
  explicacao_erro = 'Boa tentativa! Quando a equipe escuta a comunidade, ela aprende coisas importantes. O que as pessoas podem contar? Vamos tentar novamente?'
where id = 681;

update questoes set
  explicacao = 'Correto! Tratar as pessoas com respeito e conversar com elas cria confiança entre a comunidade e os profissionais da UBS.',
  explicacao_erro = 'Quase! Confiança nasce quando alguém se sente escutado e respeitado. Qual atitude faz isso? Vamos tentar novamente?'
where id = 682;

update questoes set
  explicacao = 'Muito bem! Quando a equipe escuta com atenção e explica tudo com carinho, a pessoa pode passar a confiar mais nos profissionais e a se sentir à vontade para cuidar da saúde.',
  explicacao_erro = 'Quase! A equipe conversou com atenção e respondeu às perguntas. Como ele pode se sentir depois disso? Vamos tentar novamente?'
where id = 683;

update questoes set
  explicacao = 'Isso! Quando a equipe percebe que as crianças têm dúvidas, pode conversar com a comunidade e criar atividades para ensinar sobre prevenção. É a educação em saúde!',
  explicacao_erro = 'Boa tentativa! Quando as crianças têm dificuldade para entender algo importante, o que ajuda? Pense em ensinar e conversar. Vamos tentar novamente?'
where id = 684;

update questoes set
  explicacao = 'Correto! O pré-natal, o acompanhamento da gestante e do bebê, é feito na UBS, perto de casa. Consultas regulares ajudam a mamãe e o bebê a ficarem saudáveis.',
  explicacao_erro = 'Quase! As consultas de rotina da gravidez são feitas em um serviço que acompanha a saúde no dia a dia. Qual é ele? Vamos tentar novamente?'
where id = 685;

update questoes set
  explicacao = 'Muito bem! Na UBS, o SUS oferece vacinas e remédios de graça, como a vacina da gripe e os medicamentos indicados pelo médico.',
  explicacao_erro = 'Quase! Vacinas e remédios gratuitos do SUS estão no posto de saúde do bairro. Qual lugar é esse? Vamos tentar novamente?'
where id = 686;

update questoes set
  explicacao = 'Verdadeiro, muito bem! A UBS fica perto da comunidade, cuida das famílias no próprio bairro, ajuda a prevenir doenças e acompanha os moradores de forma contínua.',
  explicacao_erro = 'Ops! Pense: a UBS está no bairro, perto das famílias. Isso é importante para a sociedade? Vamos tentar novamente?'
where id = 687;

update questoes set
  explicacao = 'Verdadeiro, parabéns! A UBS é a porta de entrada do SUS e atende a região onde os moradores vivem, com vacinas, remédios gratuitos, exames e atendimento de vários profissionais.',
  explicacao_erro = 'Quase! Pense no papel da UBS: ela é o primeiro lugar onde a comunidade procura cuidado. Releia a frase. Vamos tentar novamente?'
where id = 688;

update questoes set
  explicacao = 'Falso, muito bem! As visitas dos agentes comunitários de saúde aproximam os moradores da equipe e ajudam a conhecer a realidade da comunidade. Eles são a ponte entre a UBS e as famílias!',
  explicacao_erro = 'Quase! Os agentes comunitários vão de casa em casa. Será que isso afasta ou aproxima as pessoas da equipe de saúde? Vamos tentar novamente?'
where id = 689;

update questoes set
  explicacao = 'Isso! Quando a UBS está fechada, como à noite e nos fins de semana, a UPA 24h atende as urgências.',
  explicacao_erro = 'Quase! A UBS está fechada no domingo à noite. Qual serviço de saúde funciona 24 horas? Vamos tentar novamente?'
where id = 690;

update questoes set
  explicacao = 'Isso mesmo! A unidade de saúde faz avaliação, testagem e tratamento de forma gratuita e sigilosa, e a procura precoce protege você e as pessoas com quem se relaciona.',
  explicacao_erro = 'Não desanime! Pense em quem pode avaliar a situação com segurança. Medicamento de outra pessoa ou esperar os sintomas são boas opções? Releia com calma as alternativas e tente novamente.'
where id = 691;

update questoes set
  explicacao = 'Correto! Não é preciso estar doente para ir à UBS: ela atua também na prevenção e promoção da saúde.',
  explicacao_erro = 'Quase! A UBS cuida de você antes mesmo de adoecer. Vamos tentar novamente?'
where id = 692;

update questoes set
  explicacao = 'Isso mesmo! UBS significa Unidade Básica de Saúde, a “porta de entrada” do SUS.',
  explicacao_erro = 'Não foi dessa vez. A sigla UBS significa Unidade Básica de Saúde. Vamos tentar novamente?'
where id = 693;

update questoes set
  explicacao = 'Muito bem! A UBS faz vacinação, orientações e acompanhamento de saúde.',
  explicacao_erro = 'Quase! A UBS cuida do dia a dia da saúde, não só de casos graves. Vamos tentar novamente?'
where id = 694;

update questoes set
  explicacao = 'Correto! A vacinação é principalmente uma ação de prevenção de doenças.',
  explicacao_erro = 'Não foi dessa vez. Vacina age antes da doença. Que tipo de ação é? Vamos tentar novamente?'
where id = 695;

update questoes set
  explicacao = 'Boa! Acompanhamento ao longo do tempo é acompanhar as necessidades de saúde em diferentes momentos da vida.',
  explicacao_erro = 'Quase! Pense em cuidado contínuo, que não se limita a uma única consulta. Vamos tentar novamente?'
where id = 696;

update questoes set
  explicacao = 'Isso mesmo! Participar de vacinação e receber orientações combina com o papel preventivo da UBS.',
  explicacao_erro = 'Não foi dessa vez. Prevenir é agir antes da doença. Vamos tentar novamente?'
where id = 697;

update questoes set
  explicacao = 'Correto! Prevenção e acompanhamento podem reduzir riscos e identificar necessidades, mas não garantem que ninguém adoeça.',
  explicacao_erro = 'Quase! Acompanhar a saúde antes dos problemas traz vantagens. Quais? Vamos tentar novamente?'
where id = 698;

update questoes set
  explicacao = 'Muito bem! A UBS faz parte da rede de cuidados de saúde da população.',
  explicacao_erro = 'Não foi dessa vez. Ela não é do sistema escolar nem só privada. Vamos tentar novamente?'
where id = 699;

update questoes set
  explicacao = 'Correto! A promoção da saúde busca favorecer saúde e prevenção antes dos problemas, e não depende de remédios.',
  explicacao_erro = 'Quase! Qual é a diferença entre cuidar antes e tratar depois? Vamos tentar novamente?'
where id = 700;

update questoes set
  explicacao = 'Isso mesmo! Educação e prevenção também fazem parte do cuidado, e adolescentes saudáveis podem participar das atividades na UBS.',
  explicacao_erro = 'Não foi dessa vez. A UBS atende pessoas de todas as idades e promove educação em saúde. Vamos tentar novamente?'
where id = 701;

update questoes set
  explicacao = 'Correto! Cuidado contínuo acompanha diferentes necessidades ao longo da vida.',
  explicacao_erro = 'Quase! Cuidado contínuo não é só emergência ou uma consulta só. Vamos tentar novamente?'
where id = 702;

update questoes set
  explicacao = 'Boa! Receber orientações sobre hábitos saudáveis é promoção da saúde.',
  explicacao_erro = 'Não foi dessa vez. Procure a atitude que cuida da saúde de forma preventiva. Vamos tentar novamente?'
where id = 703;

update questoes set
  explicacao = 'Muito bem! Campanhas de vacinação beneficiam as pessoas e ajudam a proteger toda a comunidade.',
  explicacao_erro = 'Quase! A vacinação beneficia mais do que um grupo restrito. Vamos tentar novamente?'
where id = 704;

update questoes set
  explicacao = 'Correto! A UBS aproxima cuidado, prevenção e acompanhamento da comunidade, o que é muito importante para o bairro.',
  explicacao_erro = 'Não foi dessa vez. A UBS não substitui hospitais nem é só emergência. Vamos tentar novamente?'
where id = 705;

update questoes set
  explicacao = 'Isso mesmo! Atenção Primária é cuidar da saúde com prevenção e acompanhamento próximo da comunidade.',
  explicacao_erro = 'Quase! Qual frase mostra o cuidado preventivo e próximo? Vamos tentar novamente?'
where id = 706;

update questoes set
  explicacao = 'Isso mesmo! Para acompanhamento preventivo e vacinação, o serviço indicado é a UBS.',
  explicacao_erro = 'Não foi dessa vez. Qual serviço faz prevenção e vacinação? Vamos tentar novamente?'
where id = 707;

update questoes set
  explicacao = 'Correto! Fungos crescem bem em locais quentes e úmidos, como entre os dedos dos pés e dobras da pele. Secar bem o corpo, usar calçados arejados e evitar compartilhar toalhas ajuda a prevenir.',
  explicacao_erro = 'Não foi essa, mas siga firme! Pense nas condições de que os fungos gostam para crescer. Calor e umidade ajudam ou atrapalham? Tente novamente.'
where id = 708;

update questoes set
  explicacao = 'Muito bem! Os antibióticos eliminam também bactérias benéficas que controlam a Candida. Sem essa competição, o fungo se multiplica em excesso. Mais um motivo para só usar antibióticos com indicação médica.',
  explicacao_erro = 'Quase! Lembre-se de que antibióticos atuam contra bactérias, inclusive as benéficas. O que acontece com o fungo quando as bactérias que o controlam diminuem? Vamos tentar novamente.'
where id = 709;

update questoes set
  explicacao = 'Excelente! Muitos fungos convivem com nosso corpo sem causar problemas porque a imunidade os controla. Quando as defesas estão baixas, como na aids ou em quimioterapia, eles podem causar doenças graves, as infecções oportunistas.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Pense no papel do sistema imune: quando ele está enfraquecido, o controle sobre os micro-organismos aumenta ou diminui? Tente novamente.'
where id = 710;

update questoes set
  explicacao = 'Correto! O preservativo, usado corretamente em todas as relações, funciona como barreira física e reduz bastante o risco de várias ISTs e de gravidez. Ele complementa, e não substitui, a vacinação e o acompanhamento de saúde.',
  explicacao_erro = 'Quase! Pense no que o preservativo faz fisicamente durante a relação sexual. Ele cura, ou impede o contato com fluidos e lesões? Vamos tentar novamente.'
where id = 711;

update questoes set
  explicacao = 'Muito bem! Soropositivo é quem tem o HIV; a aids é a fase avançada, em que a imunidade fica muito comprometida. Com o tratamento antirretroviral, muitas pessoas vivem bem por décadas sem desenvolver a síndrome.',
  explicacao_erro = 'Não foi essa, mas você está no caminho! Pense na ordem dos acontecimentos: primeiro vem a infecção, depois, se não tratada, o enfraquecimento do sistema imune. Tente novamente.'
where id = 712;

update questoes set
  explicacao = 'Acertou! Quem tem uma IST assintomática pode transmiti-la sem saber e sofrer complicações, como infertilidade. Testar regularmente permite tratar cedo e proteger a si e aos outros.',
  explicacao_erro = 'Quase! Se a infecção pode não dar sinais, esperar sintomas é um bom plano? Pense em como descobrir e tratar a tempo e tente de novo.'
where id = 713;

update questoes set
  explicacao = 'Correto! As duas são ISTs bacterianas, com sintomas parecidos e que muitas vezes aparecem juntas. Sem exame específico é difícil diferenciá-las, por isso são abordadas em conjunto.',
  explicacao_erro = 'Não desanime! Lembre-se de que as duas são ISTs bacterianas, causadas por bactérias diferentes, e que podem aparecer ao mesmo tempo com sinais parecidos. Releia e tente novamente.'
where id = 714;

update questoes set
  explicacao = 'Muito bem! Na sífilis, as feridas iniciais somem sozinhas, mas a bactéria continua no corpo e pode causar, anos depois, lesões graves em coração, cérebro e outros órgãos. Sumiu o sintoma não significa que a doença foi curada.',
  explicacao_erro = 'Quase! Pense na característica traiçoeira da sífilis: os sinais podem desaparecer, mas a bactéria continua ali? Vamos tentar novamente.'
where id = 715;

update questoes set
  explicacao = 'Excelente! Vacinar antes da exposição ao vírus impede a infecção, o que caracteriza a prevenção primária. A vacina contra o HPV está disponível no SUS para meninas e meninos na faixa etária indicada.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Prevenção primária atua antes de a doença ou a infecção surgir. Qual alternativa descreve isso? Tente novamente.'
where id = 716;

update questoes set
  explicacao = 'Correto! O vírus permanece no organismo, mas os antivirais reduzem a frequência, a duração e a intensidade das crises e diminuem o risco de transmissão. Controlar não é o mesmo que curar.',
  explicacao_erro = 'Quase! Pense na diferença entre eliminar o vírus e controlar os sintomas. Qual alternativa descreve o que o tratamento realmente faz? Vamos tentar novamente.'
where id = 717;

update questoes set
  explicacao = 'Muito bem! Sem medo de julgamento, as pessoas procuram testagem e tratamento mais cedo, o que reduz a transmissão. Acolhimento e informação são ferramentas de saúde pública.',
  explicacao_erro = 'Não desanime! Imagine alguém com medo de ser julgado: ele procura o serviço de saúde com facilidade? Releia com calma as alternativas e tente novamente.'
where id = 718;

update questoes set
  explicacao = 'Muito bem! Mesmo sem excesso de peso, a falta de atividade física prejudica o metabolismo e a capacidade do coração e dos pulmões. Movimentar-se é protetor para todos.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Lembre-se de que o peso não é o único fator: o sedentarismo também afeta o metabolismo e o condicionamento do corpo. Vamos tentar novamente.'
where id = 719;

update questoes set
  explicacao = 'Acertou! A pressão alta muitas vezes não dá sintomas, mas vai lesionando coração, rins, cérebro e vasos. Por isso é importante medir a pressão regularmente.',
  explicacao_erro = 'Quase! Pense no sentido de “silenciosa”: a doença avisa que está presente, ou age sem dar sinais? Tente novamente.'
where id = 720;

update questoes set
  explicacao = 'Muito bem! Esses hábitos juntos favorecem pressão alta, resistência à insulina e alterações do colesterol, que são os principais fatores de risco para infarto e AVC. Pequenas mudanças diárias já ajudam muito.',
  explicacao_erro = 'Não desanime! Pense nos efeitos desses três fatores no coração e nos vasos sanguíneos. Eles protegem ou aumentam o risco? Vamos tentar novamente.'
where id = 721;

update questoes set
  explicacao = 'Correto! O ferro é essencial para produzir hemoglobina. Quando a ingestão é insuficiente ou há perda de sangue, a hemoglobina diminui e surge a anemia. Feijão, carnes e folhas verde-escuras são boas fontes.',
  explicacao_erro = 'Quase! Pense no nome da doença: anemia por deficiência de ferro. O problema está no excesso ou na falta do mineral? Releia e tente novamente.'
where id = 722;

update questoes set
  explicacao = 'Excelente! Tabagismo e excesso de sol sem proteção são fatores de risco que podemos evitar, ao contrário de idade, sexo e histórico familiar. Parar de fumar e usar protetor solar reduzem o risco de vários tipos de câncer.',
  explicacao_erro = 'Não foi essa, mas continue! A pergunta pede fatores que a pessoa pode evitar. Idade, sexo e genética dão para mudar? Pense em hábitos e exposições e tente novamente.'
where id = 723;

update questoes set
  explicacao = 'Muito bem! Na resistência à insulina, as células respondem mal ao hormônio, a glicose fica no sangue e a glicemia sobe. Alimentação equilibrada e atividade física melhoram a sensibilidade à insulina.',
  explicacao_erro = 'Quase lá! Pense na função da insulina: ajudar a glicose a entrar nas células. Se as células não respondem a ela, o que acontece com a glicose no sangue? Vamos tentar novamente.'
where id = 724;

update questoes set
  explicacao = 'Correto! Na síndrome metabólica, esses fatores se associam e se reforçam, elevando bastante o risco de doenças cardiovasculares e diabetes. Por isso são avaliados em conjunto.',
  explicacao_erro = 'Não desanime! Pense na palavra “síndrome”: um conjunto de alterações que aparecem juntas. Elas são independentes ou se reforçam? Tente novamente.'
where id = 725;

update questoes set
  explicacao = 'Acertou! Os hormônios da tireoide são essenciais para o crescimento e o desenvolvimento do cérebro. Por isso existe o teste do pezinho, que detecta o hipotireoidismo congênito logo nos primeiros dias de vida.',
  explicacao_erro = 'Quase! Lembre-se de que os hormônios da tireoide atuam no crescimento e no desenvolvimento do sistema nervoso. O que a falta deles pode causar na infância? Vamos tentar novamente.'
where id = 726;

update questoes set
  explicacao = 'Muito bem! Praças, parques e quadras incentivam a atividade física, que protege contra diabetes, hipertensão e outras DCNT. Ambientes saudáveis facilitam escolhas saudáveis.',
  explicacao_erro = 'Não foi essa, mas você consegue! Pense no que um parque ou uma quadra estimulam nas pessoas e como isso se relaciona com o sedentarismo. Vamos tentar novamente.'
where id = 727;

update questoes set
  explicacao = 'Perfeito! Consentimento é um “sim” livre, consciente e sem pressão, que pode ser retirado a qualquer momento. Sem consentimento, não há relação, e isso vale para qualquer tipo de relacionamento.',
  explicacao_erro = 'Quase! Para existir consentimento, a concordância precisa ser livre. Pressão, medo de conflito ou “já aconteceu antes” contam como um sim verdadeiro? Tente novamente.'
where id = 728;

update questoes set
  explicacao = 'Boa! Diante de suspeita de IST, procure um serviço de saúde para avaliação, orientação e testagem. Não use remédios de outra pessoa.',
  explicacao_erro = 'Quase! Qual atitude garante diagnóstico e tratamento corretos, sem riscos? Vamos tentar novamente?'
where id = 729;

update questoes set
  explicacao = 'Muito bem! A hemofilia é uma doença genética em que a coagulação do sangue é deficiente, e a plaqueta artificial ajudaria a formar o coágulo e estancar sangramentos. Plaquetas e fatores de coagulação são peças-chave nesse processo.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! A plaqueta artificial atua na coagulação. Qual das doenças listadas tem como problema central a dificuldade de coagular o sangue? Vamos tentar novamente.'
where id = 730;

update questoes set
  explicacao = 'Correto! Os cones são as células responsáveis pela visão colorida e funcionam melhor com muita luz. Sua degeneração compromete a percepção das cores. Já os bastonetes atuam em pouca luz.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! O enunciado diz que os cones convertem diferentes comprimentos de onda da luz em sinais. Pense: comprimentos de onda diferentes correspondem a quê na nossa percepção? Tente novamente.'
where id = 731;

update questoes set
  explicacao = 'Correto! Quando os raios incidem quase paralelos ao eixo óptico, o desvio causado pela refração diminui, e a imagem se forma com mais nitidez na retina. Por isso a pupila reduzida melhora a acuidade visual debaixo d''água.',
  explicacao_erro = 'Não desanime! Raios que incidem quase paralelos ao eixo óptico sofrem pouco desvio ao mudar de meio. Qual fenômeno físico está ligado a esse desvio da luz? Releia o texto e tente novamente.'
where id = 732;

update questoes set
  explicacao = 'Muito bem! O rim filtra o sangue e remove resíduos como a ureia, função que a hemodiálise também realiza. O rim biônico substituiria essa filtração de forma contínua e mais prática para o paciente.',
  explicacao_erro = 'Quase! Pense na função principal dos rins e da hemodiálise: filtrar o sangue e eliminar quais resíduos nitrogenados? Vamos tentar novamente.'
where id = 733;

update questoes set
  explicacao = 'Muito bem! A técnica une luz (foto), anticorpos (imuno) e tratamento (terapia): daí o nome fotoimunoterapia. Decompor o nome ajuda a descobrir a resposta!',
  explicacao_erro = 'Quase! A técnica usa dois elementos: luz infravermelha e anticorpos. Qual nome combina os dois? Vamos tentar novamente.'
where id = 734;

update questoes set
  explicacao = 'Correto! Bastonetes respondem à quantidade de fótons, ou seja, à intensidade da luz. Quanto mais sensíveis, melhor o animal enxerga com pouca luz, como acontece com animais de hábitos noturnos.',
  explicacao_erro = 'Quase! O texto associa os bastonetes à quantidade de fótons, isto é, à intensidade luminosa. Bastonetes mais sensíveis ajudam em ambientes com muita ou com pouca luz? Vamos tentar novamente.'
where id = 735;

update questoes set
  explicacao = 'Correto! A PCR amplifica DNA, mas o SARS-CoV-2 tem RNA. Por isso, antes da reação, a transcriptase reversa converte o RNA viral em DNA complementar (cDNA), que então pode ser amplificado.',
  explicacao_erro = 'Quase! A polimerase da PCR trabalha com DNA, e o vírus tem RNA. Que etapa transforma RNA em DNA antes da amplificação? Vamos tentar novamente.'
where id = 736;

update questoes set
  explicacao = 'Correto! O ozônio é um oxidante muito forte: é isso que o torna um bom sanitizante, mas também o que o torna tóxico para os tecidos humanos, como o pulmão. Concentração e precauções importam!',
  explicacao_erro = 'Quase! O poder de “desinfetar” vem da capacidade de reagir fortemente com outras substâncias, retirando elétrons delas. Qual termo descreve essa ação química? Vamos tentar novamente.'
where id = 737;

update questoes set
  explicacao = 'Muito bem! Se não há fecundação, o corpo lúteo regride no final do ciclo e deixa de produzir progesterona e estrógeno. Essa queda hormonal antecede a menstruação e está ligada aos sintomas da TPM.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! Depois da ovulação, o corpo lúteo produz progesterona. O que acontece com ele no fim do ciclo, quando não há gravidez? Vamos tentar novamente.'
where id = 738;

update questoes set
  explicacao = 'Correto! O HTLV-1 estimula a multiplicação dos linfócitos T, e o aumento descontrolado de células pode levar a leucemias e linfomas, que são tipos de câncer. A aids, ao contrário, vem da destruição dessas células pelo HIV.',
  explicacao_erro = 'Quase! O texto diz que o HTLV-1 aumenta a produção de linfócitos T. O que costuma acontecer quando as células se multiplicam de forma descontrolada? Vamos tentar novamente.'
where id = 739;

update questoes set
  explicacao = 'Muito bem! O ácido clorídrico faz parte do suco gástrico, produzido no estômago. É lá que o nitrito das carnes processadas reage com ele e dá início à formação dos compostos nitrosos. Moderar o consumo de embutidos é uma boa prática.',
  explicacao_erro = 'Não desanime! A reação precisa de ácido clorídrico. Em qual órgão do sistema digestivo o HCl é produzido? Vamos tentar novamente.'
where id = 740;

update questoes set
  explicacao = 'Isso! O SAMU funciona todos os dias, a qualquer hora, e a ligação para o número 192 é gratuita. Guarde esse número!',
  explicacao_erro = 'Boa tentativa! Releia o começo da pergunta: ele traz pistas importantes sobre o número, o custo e os dias de funcionamento do SAMU. Vamos tentar novamente?'
where id = 741;

update questoes set
  explicacao = 'Isso! Quando ligamos para o 192, os profissionais do SAMU fazem perguntas sobre o que aconteceu e podem orientar os primeiros cuidados até a ajuda chegar.',
  explicacao_erro = 'Quase! Os profissionais do SAMU estão ali para ajudar. O que será que eles fazem quando atendem a ligação? Vamos tentar novamente?'
where id = 742;

update questoes set
  explicacao = 'Certo! Dificuldade para respirar, como no engasgo ou no sufocamento, é uma urgência. Ligar rápido para o 192 pode salvar uma vida, e o SAMU orienta o que fazer enquanto a ajuda chega.',
  explicacao_erro = 'Não desanime! Respirar é essencial para o nosso corpo. Se alguém não consegue respirar direito, dá para esperar? Vamos tentar novamente?'
where id = 743;

update questoes set
  explicacao = 'Isso! A UBS funciona, em geral, de segunda a sexta-feira, em horário comercial, para o cuidado do dia a dia. Vale confirmar o horário da UBS do seu bairro.',
  explicacao_erro = 'Quase! A UBS cuida da saúde do dia a dia, e não funciona 24 horas. Pense em horários de dias de trabalho. Vamos tentar novamente?'
where id = 744;

update questoes set
  explicacao = 'Correto! Uma dor de cabeça fraca sem gravidade pode ser atendida na UBS. A UPA fica para urgências.',
  explicacao_erro = 'Quase! A dor de Camila é leve e não é uma emergência. Qual serviço cuida desses casos do dia a dia? Vamos tentar novamente?'
where id = 745;

update questoes set
  explicacao = 'Muito bem! A UPA é um serviço de saúde preparado para atender urgências, funciona 24 horas e recebe pessoas de todas as idades.',
  explicacao_erro = 'Quase! O nome já dá uma dica: "pronto atendimento". Para que tipo de situação ele serve? Vamos tentar novamente?'
where id = 746;

update questoes set
  explicacao = 'Isso! Procuramos a UPA quando precisamos de atendimento de urgência e não dá para esperar por uma consulta de rotina.',
  explicacao_erro = 'Boa tentativa! A UPA não é para conversar, vacinar ou fazer exames de rotina. Quando ela é necessária? Vamos tentar novamente?'
where id = 747;

update questoes set
  explicacao = 'Correto! Depois do atendimento de urgência na UPA, o acompanhamento da saúde pode continuar na UBS, quando necessário. Os dois serviços se complementam.',
  explicacao_erro = 'Quase! A UPA resolve a urgência, mas depois o cuidado continua. Onde fica o acompanhamento do dia a dia? Vamos tentar novamente?'
where id = 748;

update questoes set
  explicacao = 'Muito bem! Uma dor forte que começou de repente precisa ser avaliada rápido, e a UPA está preparada para esse tipo de urgência.',
  explicacao_erro = 'Quase! A dor de Maria é forte e começou de repente. Qual serviço atende urgências? Vamos tentar novamente?'
where id = 749;

update questoes set
  explicacao = 'Isso! Quando a UPA e a UBS conversam, as informações importantes sobre o cuidado da pessoa são compartilhadas e o tratamento continua sem falhas.',
  explicacao_erro = 'Boa tentativa! Pense no que acontece quando dois serviços trocam informações sobre o mesmo paciente. Isso ajuda ou atrapalha? Vamos tentar novamente?'
where id = 750;

update questoes set
  explicacao = 'Correto! Às vezes as pessoas procuram a UPA por dúvida sobre qual serviço escolher ou por dificuldade de conseguir atendimento em outros lugares. Por isso é bom conhecer o papel de cada serviço.',
  explicacao_erro = 'Quase! Nem todo mundo sabe qual serviço procurar ou consegue atendimento com facilidade. Qual alternativa explica isso? Vamos tentar novamente?'
where id = 751;

update questoes set
  explicacao = 'Muito bem! A UBS acompanha a saúde e previne doenças no dia a dia, e a UPA atende situações que precisam de cuidado urgente. Cada uma tem o seu papel!',
  explicacao_erro = 'Quase! UBS e UPA são serviços diferentes. Qual alternativa explica o papel de cada uma? Vamos tentar novamente?'
where id = 752;

update questoes set
  explicacao = 'Parabéns! João, com dor de garganta leve, pode ir à UBS. Maria, com muita dor e sem conseguir mexer o braço, precisa da UPA. Saber escolher ajuda a ser atendido mais rápido.',
  explicacao_erro = 'Quase! Veja a gravidade de cada caso: um é leve e o outro é urgente. Onde cada um deve procurar atendimento? Vamos tentar novamente?'
where id = 753;

update questoes set
  explicacao = 'Correto! O pré-natal é na UBS, mas, em caso de dores fortes e urgentes, a UPA atende 24 horas e encaminha para o hospital se for preciso.',
  explicacao_erro = 'Quase! O pré-natal é feito na UBS, mas uma urgência precisa de atendimento 24 horas. Qual serviço faz isso? Vamos tentar novamente?'
where id = 754;

update questoes set
  explicacao = 'Muito bem! Em uma emergência com corte profundo, a família deve ir imediatamente à UPA 24h, que atende urgências a qualquer hora.',
  explicacao_erro = 'Quase! Um corte profundo é urgente e não pode esperar até o dia seguinte. Para onde a família deve ir? Vamos tentar novamente?'
where id = 755;

update questoes set
  explicacao = 'Isso! Dor forte no peito e falta de ar repentina são sinais graves, e a UPA está preparada para atender. Também é possível ligar para o SAMU, no 192.',
  explicacao_erro = 'Quase! Dor forte no peito e falta de ar são sinais graves. Qual serviço atende urgências? Vamos tentar novamente?'
where id = 756;

update questoes set
  explicacao = 'Correto! Vômitos constantes por várias horas precisam de atendimento rápido, porque o corpo pode ficar sem líquidos. A UPA pode cuidar da Aninha.',
  explicacao_erro = 'Quase! Vomitar sem parar por horas é uma urgência. Qual serviço atende rapidamente? Vamos tentar novamente?'
where id = 757;

update questoes set
  explicacao = 'Certo! Em casos de intoxicação, o socorro imediato é na UPA. Também se pode ligar para o SAMU, no 192, e seguir a orientação dos profissionais.',
  explicacao_erro = 'Quase! Intoxicação é uma urgência e não pode esperar. Qual unidade do SUS atende urgências? Vamos tentar novamente?'
where id = 758;

update questoes set
  explicacao = 'Correto! UPA significa Unidade de Pronto Atendimento.',
  explicacao_erro = 'Não foi dessa vez. Pense na unidade que presta atendimento rápido. Vamos tentar novamente?'
where id = 759;

update questoes set
  explicacao = 'Isso mesmo! A UPA atende problemas que exigem avaliação e cuidado com maior urgência.',
  explicacao_erro = 'Quase! A UPA tem foco na urgência. Vamos tentar novamente?'
where id = 760;

update questoes set
  explicacao = 'Muito bem! UBS e UPA fazem parte da rede de saúde, mas têm papéis diferentes.',
  explicacao_erro = 'Não foi dessa vez. Elas se complementam em vez de competir. Vamos tentar novamente?'
where id = 761;

update questoes set
  explicacao = 'Correto! Reconhecer situações urgentes ajuda a procurar o serviço certo sem atrasar o cuidado.',
  explicacao_erro = 'Quase! Nem todo sintoma é emergência, e saber a diferença ajuda. Vamos tentar novamente?'
where id = 762;

update questoes set
  explicacao = 'Boa! A UPA é o serviço do cenário voltado a problemas que exigem avaliação mais urgente.',
  explicacao_erro = 'Quase! Escola, mercado e parque não são serviços de saúde. Vamos tentar novamente?'
where id = 763;

update questoes set
  explicacao = 'Correto! UBS e UPA desempenham funções diferentes dentro da rede de cuidados.',
  explicacao_erro = 'Não foi dessa vez. Ambos são serviços de saúde, mas com funções distintas. Vamos tentar novamente?'
where id = 764;

update questoes set
  explicacao = 'Muito bem! Em uma rede de saúde, diferentes serviços têm funções que se complementam.',
  explicacao_erro = 'Quase! “Rede” indica cooperação entre serviços diferentes. Vamos tentar novamente?'
where id = 765;

update questoes set
  explicacao = 'Isso mesmo! Acompanhamento preventivo e orientações combinam com cuidado contínuo, e não com pronto atendimento.',
  explicacao_erro = 'Não foi dessa vez. Procure a situação ligada a acompanhamento, e não a urgência. Vamos tentar novamente?'
where id = 766;

update questoes set
  explicacao = 'Correto! A escolha do serviço depende do tipo e da urgência da necessidade.',
  explicacao_erro = 'Quase! Nem sempre dá para usar o mesmo serviço. O que influencia a escolha? Vamos tentar novamente?'
where id = 767;

update questoes set
  explicacao = 'Muito bem! A UPA não substitui a UBS: cada uma tem seu papel no cuidado.',
  explicacao_erro = 'Não foi dessa vez. As funções são diferentes. Vamos tentar novamente?'
where id = 768;

update questoes set
  explicacao = 'Correto! A UBS não substitui a UPA, pois, algumas situações exigem atendimento com maior urgência.',
  explicacao_erro = 'Quase! Algumas situações não podem esperar. Vamos tentar novamente?'
where id = 769;

update questoes set
  explicacao = 'Isso mesmo! Conhecer os serviços do SUS ajuda a população a procurar o cuidado mais adequado.',
  explicacao_erro = 'Não foi dessa vez. Esse conhecimento é útil para todas as pessoas. Vamos tentar novamente?'
where id = 770;

update questoes set
  explicacao = 'Correto! UBS: prevenção e acompanhamento; UPA: situações de maior urgência.',
  explicacao_erro = 'Quase! Cuidado com associações trocadas. Qual está certa? Vamos tentar novamente?'
where id = 771;

update questoes set
  explicacao = 'Excelente! O cenário busca reconhecer a importância da urgência e entender os diferentes papéis da rede de saúde.',
  explicacao_erro = 'Não foi dessa vez. O objetivo é saber usar bem cada serviço. Qual alternativa expressa isso? Vamos tentar novamente?'
where id = 772;

update questoes set
  explicacao = 'Muito bem! O veneno de cascavel causa hemorragia por interferir na coagulação, e a molécula derivada modula esse processo. Uma aplicação potencial é impedir a formação de trombos (coágulos), que podem causar AVC.',
  explicacao_erro = 'Não foi dessa vez, mas você consegue! A molécula modula a coagulação do sangue. Qual das situações descritas tem como problema a formação de coágulos que entopem vasos? Tente novamente.'
where id = 773;


notify pgrst, 'reload schema';
