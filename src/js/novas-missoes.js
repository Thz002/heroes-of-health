/** novas-missoes.js — aviso de que chegou missão nova (a régua das barras cresceu).
    Compara com o que ficou no localStorage na última vez que o aluno dispensou. Global NOVAS_MISSOES. */
const NOVAS_MISSOES = (() => {
  'use strict';

  const PREFIXO = 'herois_pontos_possiveis:';

  function ler(usuarioId) {
    try { return JSON.parse(localStorage.getItem(PREFIXO + usuarioId)); }
    catch (_) { return null; }
  }

  function gravar(usuarioId, mapa) {
    try { localStorage.setItem(PREFIXO + usuarioId, JSON.stringify(mapa)); }
    catch (_) { /* sem armazenamento: fica sem aviso, e só */ }
  }

  /** Compara a régua atual com a última vista. Devolve { novas, dispensar() }. */
  function conferir(usuarioId, areas) {
    const agora = Object.fromEntries(areas.map(a => [a.area, a.pontos_possiveis || 0]));
    const antes = usuarioId ? ler(usuarioId) : null;

    if (!usuarioId) return { novas: [], dispensar() {} };

    if (!antes || typeof antes !== 'object') {
      gravar(usuarioId, agora);
      return { novas: [], dispensar() {} };
    }

    const novas = areas
      .filter(a => (a.pontos_possiveis || 0) > (antes[a.area] || 0))
      .map(a => a.area);

    let encolheu = false;
    const ajustado = { ...antes };
    for (const [area, valor] of Object.entries(agora)) {
      if (valor < (antes[area] || 0)) { ajustado[area] = valor; encolheu = true; }
    }
    if (encolheu) gravar(usuarioId, ajustado);

    return { novas, dispensar: () => gravar(usuarioId, agora) };
  }

  /** Cartão do aviso ({ novas, dispensar, linkMapa }). */
  function montarAviso({ novas, dispensar, linkMapa = false }) {
    const aviso = document.createElement('div');
    aviso.className = 'aviso-missoes';
    aviso.setAttribute('role', 'status');

    aviso.innerHTML = `
      <span class="aviso-missoes__icone" aria-hidden="true">✨</span>
      <div class="aviso-missoes__texto">
        <strong>Novas missões chegaram!</strong>
        <span></span>
      </div>
      <div class="aviso-missoes__acoes"></div>
    `;

    aviso.querySelector('.aviso-missoes__texto span').textContent =
      `Seu professor passou missões novas de ${juntar(novas)}. Por isso ${novas.length === 1 ? 'essa barra desceu' : 'essas barras desceram'} um pouco: tem mais coisa para descobrir!`;

    const acoes = aviso.querySelector('.aviso-missoes__acoes');

    const fechar = () => {
      dispensar();
      aviso.classList.add('aviso-missoes--saindo');
      setTimeout(() => aviso.remove(), 220);
    };

    if (linkMapa) {
      const ir = document.createElement('a');
      ir.href = 'mapa.html';
      ir.className = 'aviso-missoes__ir';
      ir.textContent = 'Ver missões';
      ir.addEventListener('click', () => dispensar());
      acoes.appendChild(ir);
    }

    const ok = document.createElement('button');
    ok.type = 'button';
    ok.className = 'aviso-missoes__ok';
    ok.textContent = 'Entendi';
    ok.addEventListener('click', fechar);
    acoes.appendChild(ok);

    return aviso;
  }

  /** ['Saúde', 'Vacinação', 'Limpeza'] -> 'Saúde, Vacinação e Limpeza' */
  function juntar(nomes) {
    if (nomes.length <= 1) return nomes[0] || '';
    return `${nomes.slice(0, -1).join(', ')} e ${nomes[nomes.length - 1]}`;
  }

  return { conferir, montarAviso };
})();
