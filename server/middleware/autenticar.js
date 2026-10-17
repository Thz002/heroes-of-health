/** Confere o token do Supabase (Authorization: Bearer) e carrega o perfil em req.usuario. */

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

  // O tipo da pessoa vem da tabela usuarios, nunca do navegador.
  const { data: perfil, error: erroPerfil } = await admin
    .from('usuarios')
    .select('id, nome, tipo, idade, turma_id, suspenso, suspenso_motivo')
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

  // Conta suspensa é bloqueada em toda chamada.
  if (perfil.suspenso) {
    return res.status(403).json({
      message: perfil.suspenso_motivo
        ? `Sua conta está suspensa: ${perfil.suspenso_motivo}`
        : 'Sua conta está suspensa. Fale com a equipe.',
      suspenso: true,
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
