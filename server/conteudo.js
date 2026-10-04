/**
 * server/conteudo.js — quem escreveu cada questão
 *
 * questoes.criado_por guarda o id do professor que criou a questão no
 * painel, ou este código para as questões DO SISTEMA (as da equipe de
 * Medicina, que entram pelo db/importar-questoes.sql). É o mesmo valor
 * do default da coluna em db/setup.sql — se mudar lá, mude aqui.
 *
 * Um uuid de zeros nunca colide com um usuário de verdade: o Supabase
 * gera ids aleatórios (v4), e o uuid nulo não é um deles.
 */

const CRIADOR_SISTEMA = '00000000-0000-0000-0000-000000000000';

module.exports = { CRIADOR_SISTEMA };
