/** Função do Vercel: toda /api/... chega aqui (rewrite do vercel.json) e vai para o Express. */

module.exports = require('../server/app');
