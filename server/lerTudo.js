/**
 * server/lerTudo.js — lê uma consulta inteira, página por página
 *
 * O PostgREST (a API do Supabase) devolve no máximo 1000 linhas por
 * consulta e corta o resto SEM erro nenhum. questoes_areas tem uma linha
 * por questão × área — com o conteúdo de hoje são 999, e o próximo lote
 * de perguntas passa disso. Sem isto, o painel do mapa e o sorteio do
 * quiz perderiam linhas em silêncio.
 *
 * `montar` é uma função que devolve a consulta NOVA a cada chamada, e
 * ela precisa ter .order(): sem ordem fixa, a página 2 pode repetir ou
 * pular linhas da página 1.
 *
 *   const { data, error } = await lerTudo(() =>
 *     admin.from('questoes_areas').select('questao_id, area_nome')
 *       .order('questao_id').order('area_nome'));
 */

const POR_PAGINA = 1000;

async function lerTudo(montar) {
  const linhas = [];

  for (let de = 0; ; de += POR_PAGINA) {
    const { data, error } = await montar().range(de, de + POR_PAGINA - 1);
    if (error) return { data: null, error };

    linhas.push(...data);
    if (data.length < POR_PAGINA) return { data: linhas, error: null };
  }
}

module.exports = { lerTudo };
