/**
 * referencias.js — a busca da página de referências
 *
 * A lista inteira já está no HTML; aqui só se escondem as linhas que
 * não casam com o que foi digitado. Nada de servidor: a bibliografia
 * não muda com o que o aluno faz, e a página precisa abrir mesmo com o
 * Express fora do ar.
 *
 * Esta é a única tela do jogo que NÃO exige login — a fonte do que se
 * ensina tem de estar aberta a quem quiser conferir, inclusive a quem
 * nunca criou conta.
 *
 * Carregado depois de supabase.js, api.js e navbar.js.
 */
(() => {
  'use strict';

  const campo = document.getElementById('refs-busca');
  const nada = document.getElementById('refs-nada');
  const linhas = Array.from(document.querySelectorAll('.ref'));
  const atalhos = document.querySelector('.refs__letras');

  if (!campo || !linhas.length) return;

  // Sem acento e em minúscula dos dois lados: quem procura "saude"
  // precisa achar "Saúde", e ninguém digita acento numa busca.
  const achatar = (t) => t.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();

  const indice = linhas.map(li => achatar(li.textContent));

  function filtrar() {
    const termo = achatar(campo.value.trim());

    // Cada palavra digitada precisa aparecer, em qualquer ordem:
    // "ministerio dengue" acha a referência mesmo com dez palavras
    // entre as duas.
    const pedacos = termo.split(/\s+/).filter(Boolean);
    let visiveis = 0;

    linhas.forEach((li, i) => {
      const bate = pedacos.every(p => indice[i].includes(p));
      li.hidden = !bate;
      if (bate) visiveis++;
    });

    nada.hidden = visiveis > 0;

    // Os atalhos de letra não fazem sentido com a lista filtrada: eles
    // levariam a uma referência escondida.
    if (atalhos) atalhos.hidden = pedacos.length > 0;
  }

  campo.addEventListener('input', filtrar);

  // Esc limpa, que é o reflexo de quem usa busca.
  campo.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') { campo.value = ''; filtrar(); }
  });
})();
