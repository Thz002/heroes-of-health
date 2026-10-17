/** Registra o erro real no terminal e responde uma mensagem amigável. */

/** Registra a falha e responde a mensagem amigável. */
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
