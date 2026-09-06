// loading.js — o menu inicial do aluno (src/pages/loading.html)
//
// É a primeira tela depois do login. Só tem duas responsabilidades:
// barrar quem não está logado, e levar ao mapa quando a pessoa mandar.
//
// Repare que esta página NÃO carrega o auth.js. Ele é o controlador da
// tela de login e leva junto a entrada automática, que mandaria o aluno
// já logado para cá — daqui para cá, em loop.

(() => {
  'use strict';

  const btnJogar = document.getElementById('btn-jogar');
  const btnSair = document.getElementById('btn-sair');
  const saudacao = document.getElementById('menu-saudacao');

  iniciar();

  async function iniciar() {
    const conta = await AUTH.exigirLogin();
    if (!conta) return;

    // O nome é enfeite: se a consulta falhar, a tela continua servindo.
    if (!saudacao) return;
    try {
      const perfil = await AUTH.perfilAtual();
      if (perfil && perfil.nome) {
        const primeiro = perfil.nome.trim().split(' ')[0];
        saudacao.textContent = `Bom te ver, ${primeiro}!`;
      }
    } catch (_) { /* segue sem o nome */ }
  }

  btnJogar?.addEventListener('click', () => {
    window.location.href = 'mapa.html';
  });

  btnSair?.addEventListener('click', async () => {
    await AUTH.logout();
    window.location.href = 'index.html';
  });
})();
