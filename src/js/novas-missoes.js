/**
 * novas-missoes.js — o aviso de que chegou missão nova
 *
 * As barras do aluno são relativas ao que ELE tem para fazer (GET
 * /api/meu-progresso). Quando o professor passa um quiz novo, a régua
 * cresce e a barra DESCE — e uma barra que desce sem explicação parece
 * castigo. Este arquivo transforma essa queda em notícia boa: "chegaram
 * missões novas, tem mais coisa para descobrir".
 *
 * Como sabe que a régua cresceu: guarda, no navegador, os
 * pontos_possiveis de cada área da última vez que o aluno DISPENSOU o
 * aviso, e compara com os de agora.
 *
 *   - primeira visita neste navegador: só guarda, sem aviso (não há com
 *     o que comparar, e "tudo é novo" não diz nada);
 *   - régua que encolheu (o professor apagou um quiz pendente): a
 *     memória desce junto, calada — senão um quiz novo que só
 *     devolvesse o tamanho antigo passaria sem aviso;
 *   - o aviso fica até a pessoa clicar em "Entendi" (ou "Ver missões"),
 *     então ele aparece tanto no mapa quanto na tela de progresso,
 *     onde ela olhar primeiro.
 *
 * A chave leva o id da conta: no laboratório da escola vários alunos
 * usam o mesmo computador. Se o navegador não deixar gravar (aba anônima,
 * bloqueio), o aviso simplesmente não aparece — nada mais depende dele.
 *
 * Expõe o objeto global NOVAS_MISSOES. Carregado antes do script da página.
 */
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

  /**
   * Compara a régua de agora com a última que este aluno viu.
   *   areas: a resposta de API.getMeuProgresso()
   * Devolve { novas: ['Saúde', ...], dispensar() }.
   */
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

  /**
   * O cartão do aviso.
   *   novas       nomes das áreas que ganharam conteúdo
   *   dispensar   o que conferir() devolveu
   *   linkMapa    true = mostra "Ver missões" (fora do mapa)
   */
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
