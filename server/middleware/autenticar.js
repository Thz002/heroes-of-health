/**
 * server/middleware/autenticar.js
 *
 * Descobre QUEM está fazendo o pedido, e recusa quem não souber provar.
 *
 * Como funciona o modelo híbrido: o login continua acontecendo no
 * navegador, direto com o Supabase Auth. O navegador recebe de lá um
 * token assinado e o manda para cá no cabeçalho Authorization. O
 * servidor pergunta ao Supabase se aquele token é legítimo.
 *
 * Ou seja: o servidor não guarda senha e não tem sessão própria. Ele só
 * confere o crachá que o Supabase emitiu.
 */

const { admin } = require('../supabase');

async function autenticar(req, res, next) {
  const cabecalho = req.headers.authorization || '';
  const token = cabecalho.startsWith('Bearer ') ? cabecalho.slice(7) : null;

  if (!token) {
    return res.status(401).json({ message: 'Você precisa estar logado.' });
  }

  // Quem valida o token é o Supabase — nunca decodifique na mão.
  const { data, error } = await admin.auth.getUser(token);

  if (error || !data?.user) {
    return res.status(401).json({ message: 'Sua sessão expirou. Entre de novo.' });
  }

  // O token diz apenas quem a pessoa é. O que ela É no jogo (aluno,
  // professor, admin) vem da tabela usuarios — nunca do que o navegador
  // afirmou, que é informação que a própria pessoa controla.
  const { data: perfil, error: erroPerfil } = await admin
    .from('usuarios')
    .select('id, nome, tipo, idade, escola_id, turma_id')
    .eq('id', data.user.id)
    .maybeSingle();

  if (erroPerfil) {
    return res.status(500).json({ message: 'Não foi possível carregar seu cadastro.' });
  }

  if (!perfil) {
    // O gatilho da migração 03 deveria tornar isto impossível.
    return res.status(403).json({
      message: 'Sua conta existe, mas o cadastro do jogo não foi criado. Avise o professor.'
    });
  }

  req.usuario = perfil;
  next();
}

/** Trava uma rota para certos perfis. Uso: exigirTipo('PROFESSOR', 'ADMIN') */
function exigirTipo(...tipos) {
  return (req, res, next) => {
    if (!tipos.includes(req.usuario.tipo)) {
      return res.status(403).json({ message: 'Você não tem acesso a esta área.' });
    }
    next();
  };
}

module.exports = { autenticar, exigirTipo };
