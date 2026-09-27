/**
 * navbar.js — a mesma barra, dois menus
 *
 * O professor e o aluno usam as mesmas páginas de estrutura, mas não têm
 * o que fazer nos mesmos lugares: "Turmas" e "Quizes" são do professor,
 * "Mapa" e "Missões" são do aluno.
 *
 * Em vez de escrever duas barras e mantê-las em sincronia, cada item do
 * menu declara para quem ele é:
 *
 *     <li data-perfil="PROFESSOR">...</li>
 *     <li data-perfil="ALUNO">...</li>
 *     <li data-perfil="PROFESSOR ALUNO">...</li>   (os dois)
 *
 * e este arquivo apaga o que não pertence a quem está logado. Item sem
 * data-perfil fica para todo mundo.
 *
 * Carregado DEPOIS de supabase.js (usa AUTH) e antes do script da página.
 */
(() => {
  'use strict';

  ajustar();

  async function ajustar() {
    const itens = document.querySelectorAll('[data-perfil]');
    if (!itens.length) return;

    // Em dúvida, não esconde nada: uma barra cheia demais é um incômodo,
    // uma barra vazia é a pessoa achando que o sistema quebrou.
    const tipo = String(await descobrirTipo() || '').trim().toUpperCase();
    if (!tipo) return;

    itens.forEach(item => {
      // 'PROFESSOR ALUNO' vira ['PROFESSOR','ALUNO']
      const permitidos = item.dataset.perfil.trim().toUpperCase().split(/\s+/);

      // ADMIN é a equipe do projeto: vê tudo, sem exceção.
      const pode = tipo === 'ADMIN' || permitidos.includes(tipo);
      if (!pode) item.remove();
    });
  }

  /**
   * O tipo lembrado no navegador responde na hora e evita a barra
   * "piscar" com os itens errados enquanto o banco responde. Se não
   * houver nada lembrado, aí sim pergunta ao banco.
   */
  async function descobrirTipo() {
    const lembrado = AUTH.tipoLembrado && AUTH.tipoLembrado();
    if (lembrado) return lembrado;

    try {
      const perfil = await AUTH.perfilAtual();
      if (perfil && perfil.tipo) {
        if (AUTH.lembrarTipo) AUTH.lembrarTipo(perfil.tipo);
        return perfil.tipo;
      }
    } catch (_) { /* sem sessão: a própria página cuida do redirecionamento */ }

    return null;
  }
})();