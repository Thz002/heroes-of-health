/** Lê uma consulta inteira, paginando (o PostgREST corta em 1000 linhas). A consulta precisa de .order(). */

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
