/**
 * server/erros.js — o erro de verdade vai para o terminal
 *
 * POR QUE ISTO EXISTE: o quiz do professor passou dias sem ser criado,
 * mostrando "Não foi possível criar o quiz". A causa real era uma coluna
 * que faltava no banco, e o Postgres dizia isso com todas as letras —
 * mas a rota engolia a mensagem e respondia a frase amigável.
 *
 * A tela continua educada com quem está usando. Quem precisa do detalhe
 * é quem está desenvolvendo, e o lugar dele é o terminal.
 */

/**
 * Registra a falha e responde a mensagem amigável.
 *
 *   if (r.error) return falhou(res, 500, 'Não foi possível criar o quiz.', r.error, 'POST /quizzes');
 *
 * @param {object} res      resposta do Express
 * @param {number} status   código HTTP
 * @param {string} mensagem o que a pessoa lê na tela
 * @param {object} erro     o erro do Supabase/Postgres (opcional)
 * @param {string} onde     rota ou operação, para achar no log
 */
function falhou(res, status, mensagem, erro, onde) {
  if (erro) {
    const detalhe = erro.message || String(erro);
    const dica = erro.hint ? ` | dica: ${erro.hint}` : '';
    const cod = erro.code ? ` [${erro.code}]` : '';
    console.error(`  ✖ ${onde || 'servidor'}${cod}: ${detalhe}${dica}`);
  }
  return res.status(status).json({ message: mensagem });
}

module.exports = { falhou };
