# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexto

**Heróis da Saúde** — jogo educativo web sobre saúde pública, SUS e Atenção Primária, para alunos de 7 a 18 anos. Projeto Interdisciplinar II unindo Ciência da Computação (PUC Minas) e Medicina (PUC Betim). Entrega final: 20/10/2026.

O idioma do projeto é **português (pt-BR)**: nomes de tabelas, colunas, variáveis, rotas e textos de UI seguem o português (`usuarios`, `missoes`, `resposta_correta`, `acertou`). Mantenha essa convenção em qualquer código novo.

## Arquitetura — híbrida

Front-end estático em `src/` **mais** um servidor Express em `server/`. A divisão é a coisa mais importante deste arquivo:

| O quê | Onde acontece | Por quê |
|---|---|---|
| Login e cadastro | navegador → Supabase Auth | o servidor não guarda senha nem tem sessão própria |
| Lista de escolas e turmas | navegador → Supabase | o aluno precisa escolher a escola **antes** de ter conta |
| Corrigir resposta, pontuar | navegador → **Express** → Supabase | é regra de jogo: não pode ficar na mão de quem joga |
| Painel do professor, admin | navegador → **Express** → Supabase | precisa ler linhas que não são de quem pediu |

O critério para decidir onde uma função nova vai: **se a resposta certa depender de uma regra do jogo, ela vai para o `server/`.** O RLS responde bem a "esta linha é sua?" e responde mal a "você merece estes pontos?".

O servidor usa a chave secreta e por isso **passa por cima do RLS**. Isso não dispensa o RLS: enquanto o navegador falar com o Supabase para qualquer coisa, a chave publishable continua utilizável direto. As duas trancas se somam — toda tabela nova continua precisando de RLS e políticas explícitas.

**O banco é PostgreSQL** (Supabase), não MySQL. Qualquer DDL novo precisa ser escrito em dialeto PostgreSQL. As dependências `ejs`, `mysql2` e `express-session` continuam no `package.json` mas são resquício da arquitetura antiga — não use. `express` e `dotenv` passaram a ser usados de verdade.

A fonte da verdade do banco é o projeto no dashboard do Supabase. Os arquivos em `db/` são o registro escrito dele.

## Estado atual do repositório

Implementado:

- `src/pages/index.html` — tela única de login e cadastro, com escola → turma em cascata e entrada por código de turma
- `src/js/supabase.js` — conexão única (`SUPA`) e autenticação (`AUTH`)
- `src/js/api.js` — camada de dados. As funções de escola/turma falam direto com o Supabase; todo o resto vai pelo Express, com o token da sessão no cabeçalho
- `server/` — o backend: `index.js` sobe o Express, `supabase.js` guarda o cliente com a chave secreta, `middleware/autenticar.js` valida o token, `rotas/jogo.js` e `rotas/professor.js` têm as rotas
- `src/js/auth.js` — controle da tela de login/cadastro
- `src/css/style.css` — a paleta inteira está em tokens no `:root` (`--primary`, `--radius-md`, `--font-display`…). Telas novas usam os tokens, não cores soltas.
- `db/setup.sql` — o banco inteiro num arquivo (PostgreSQL); `db/seed.sql` — os 7 cenários; `db/00-testSecurity.sql` — consultas de diagnóstico
- `teste-supabase.html`, na raiz — página solta de diagnóstico da conexão, fora do fluxo do jogo. Ela repete a URL e a chave em vez de importar `supabase.js`; ao trocar a chave, troque nos dois lugares.

Ainda vazios: `src/pages/mapa.html`, `src/pages/missao.html`, `src/pages/dashboard.html`, `src/js/quiz.js`, `src/js/mapa.js`, `docs/personas.md`, `docs/user-story-map.md`.

### Nenhuma função da camada de dados tem fallback

O `api.js` antigo devolvia dados de mentira (`API.MOCK`) sempre que uma chamada falhava, o que fazia toda falha parecer sucesso. Isso foi removido. Hoje **toda** função de `API` deixa o erro estourar, e é assim que deve continuar: quem chamou precisa ver que o servidor está fora do ar, não receber um ranking inventado.

O [README.md](README.md) é a **especificação** original e está desatualizado em relação à arquitetura: ele descreve Express + EJS + MySQL. Use-o para regras de negócio e escopo, não para stack nem para DDL.

## Autenticação

Quem guarda a senha é o **Supabase Auth**, na tabela interna `auth.users`. A tabela `usuarios` é um **perfil**: sua chave primária é um `uuid` que referencia `auth.users(id)`, e ela **não tem colunas `senha` nem `email`**. Não reintroduza essas colunas nem `bcryptjs`.

Consequência prática: `auth.uid()` identifica quem está logado, e é isso que faz o **RLS (Row Level Security)** funcionar. Toda tabela nova precisa de RLS ligado e políticas explícitas — sem isso ela fica aberta a qualquer visitante com a chave publishable.

`escolas` e `turmas` são legíveis por `anon` de propósito: o aluno escolhe a escola **antes** de ter conta.

O cadastro depende de uma configuração do painel: **"Confirm email" precisa estar desligado** em Authentication → Providers. Com ele ligado, o `signUp` não devolve sessão, o `insert` em `usuarios` cai no RLS e o cadastro trava — os e-mails escolares muitas vezes não recebem a mensagem de confirmação. O `AUTH.register` detecta esse caso e explica o que fazer.

## Chaves e ambiente

O `.env` está no `.gitignore`; o modelo comentado é o `.env.example`. Ele guarda três coisas: `SUPABASE_URL`, `SUPABASE_ANON_KEY` e `SUPABASE_SERVICE_KEY`.

Páginas estáticas não leem `.env` — a URL e a chave **publishable** ficam no topo de `src/js/supabase.js`, o que é o uso correto (essa chave é pública por design).

A chave `sb_secret_` é lida **apenas** por `server/supabase.js`, que é o único arquivo do projeto autorizado a tocá-la. Ela passa por cima de todo o RLS, e é isso que permite ao servidor enxergar `questoes.resposta_correta`. **Nunca** a coloque em nada dentro de `src/` — nem em HTML, nem em JS que o navegador baixe. O `server/supabase.js` recusa subir se receber a publishable no lugar dela.

## Comandos

Não há build e não há testes (`npm test` só devolve erro). As páginas continuam abrindo direto no navegador (`file://`) — não há bundler.

```
npm install     # obrigatório, ver abaixo
npm run dev     # sobe o Express na porta 3000 com nodemon
npm start       # o mesmo, sem recarregar
```

`npm install` é obrigatório mesmo para só abrir a tela de login: a biblioteca do Supabase é carregada de `node_modules/@supabase/supabase-js/dist/umd/supabase.js`, e `node_modules/` está no `.gitignore`. Sem instalar, `supabase` não existe no navegador e a página quebra no primeiro `createClient`.

O servidor **recusa subir** sem `SUPABASE_SERVICE_KEY` no `.env`, com uma mensagem dizendo onde achar a chave. A tela de login funciona sem ele; o mapa, o quiz e o painel do professor não.

Para conferir se o servidor está no ar: `http://localhost:3000/api/saude`.

Não há bundler nem ES modules — cada arquivo expõe um objeto global e a **ordem das tags `<script>` é um contrato**. Toda página nova repete a ordem de `index.html`:

```html
<script src="../../node_modules/@supabase/supabase-js/dist/umd/supabase.js"></script>
<script src="../js/supabase.js" defer></script>   <!-- define SUPA e AUTH -->
<script src="../js/api.js"      defer></script>   <!-- define API, usa SUPA -->
<script src="../js/auth.js"     defer></script>   <!-- usa API -->
```

### O banco é um arquivo só

`db/setup.sql` descreve o banco inteiro — tabelas, funções, gatilho, RLS e permissões por coluna. Roda no **SQL Editor** do dashboard, e depois `db/seed.sql` (os 7 cenários). São esses dois, nessa ordem, e mais nada.

**Não crie migrações numeradas.** Quando o banco precisar mudar, **edite o `setup.sql` e rode de novo** — ele é idempotente (`if not exists`, `drop … if exists`, `create or replace`) e não apaga dado. Histórico de migração serve para proteger dado de produção que não pode ser perdido; este projeto não tem isso, e a pilha de arquivos numerados só multiplica a chance de rodar na ordem errada.

`db/00-testSecurity.sql` não altera nada: são as consultas de diagnóstico para quando algo falhar. `db/_historico/` guarda as migrações antigas (`01`…`04` e o antigo `schema.sql`) apenas como registro — **nunca rode nada de lá**, em especial o `01`, que dá `drop` em 5 tabelas.

O funcionamento completo do banco, o histórico das incoerências e as consultas de diagnóstico estão em [docs/banco-de-dados.md](docs/banco-de-dados.md).

## Modelo de domínio

Onze tabelas (DDL na §3 do README), organizadas em três eixos:

- **Institucional:** `escolas` → `turmas` → `usuarios` (`tipo` com check: ALUNO / PROFESSOR / ADMIN). `turmas` tem `codigo` (o código curto que o professor entrega à sala) e `professor_id`. `usuarios.escola_id` só é preenchido para PROFESSOR; para ALUNO a escola se deriva de `turma_id → turmas.escola_id`.
- **Conteúdo do jogo:** `cenarios` (pontos do bairro, identificados por `slug`: `ubs`, `mercado`, `farmacia`, `escola`…) → `missoes` (com `nivel_etario` 1–3 e flag `eh_especial`) → `questoes` (múltipla escolha A–D + `explicacao`).
- **Progresso do aluno:** `progresso_areas` (única por `usuario_id` + `area_nome`), `respostas_alunos` (histórico), `pacientes_virtuais` (1:1 com o aluno), `quizzes_professores` (quizzes ao vivo estilo Kahoot, com `tempo_limite_segundos`).

## Regras de negócio que atravessam o código

- **Pontuação multi-área:** um acerto distribui pontos entre 8 barras fixas em `progresso_areas` — *Saúde, Educação, Vacinação, Vetores, Limpeza, Alimentação, Exercícios, Felicidade*. A lista é fechada e agora vive na tabela `areas`, com `progresso_areas.area_nome` apontando para ela por FK. **Quais barras cada missão alimenta está em `missao_areas`** (`missao_id`, `area_nome`, `pontos`) — sem uma linha lá, acertar a questão não pontua nada. Quem soma é a função `somar_pontos`, chamada só pelo servidor, e só no primeiro acerto de cada questão.
- **Filtro etário:** as missões de um cenário só aparecem se o `nivel_etario` for compatível com a idade do aluno. Nível 1 = 7–10 anos (higiene, Aedes, lixo), nível 2 = 11–14 (ISTs, SUS, primeiros socorros, saúde mental), nível 3 = 15–18 (microbiologia, imunologia, estilo ENEM).
- **Feedback educativo:** ao errar, exibir a `explicacao` da questão — escrita pela equipe de Medicina — em tom positivo e encorajando nova tentativa. O erro nunca é apresentado como punição.
- **Paciente virtual:** o `estado_saude` do paciente vinculado ao aluno evolui conforme ele avança nas missões da UBS e da Farmácia.
- **Acessibilidade:** as telas de missão devem ler as questões em voz alta via Web Speech API nativa (`window.speechSynthesis`) — sem biblioteca externa.

## Papéis e permissões

`usuarios.tipo` aceita ALUNO, PROFESSOR e ADMIN. O que cada um pode:

- **ALUNO** — lê o próprio cadastro e o próprio progresso. **Não escreve** em `progresso_areas`, `respostas_alunos` nem `pacientes_virtuais`: quem escreve é o servidor. Isso é deliberado; antes o aluno dava `update` na própria pontuação pelo console.
- **PROFESSOR** — tudo do aluno, mais as turmas que ele criou e o desempenho dos alunos delas. O `codigo` da turma só chega até ele pelo servidor ou pela função `minhas_turmas()`.
- **ADMIN** — a equipe do projeto. Lê e corrige qualquer cadastro, escola, turma e o conteúdo do jogo (`cenarios`, `missoes`, `questoes`).

**Ninguém vira ADMIN pela tela.** O gatilho `criar_perfil_do_novo_usuario` rebaixa para ALUNO qualquer cadastro que se declare ADMIN, porque o `tipo` chega do navegador e é informação que a própria pessoa controla. Promover é manual, no SQL Editor:

```sql
update usuarios set tipo = 'ADMIN' where id = '...';
```

### Pendência aberta: qualquer um se cadastra como PROFESSOR

O gatilho barra ADMIN, mas continua aceitando PROFESSOR — basta marcar o rádio na tela de cadastro. E professor lê os dados dos alunos das turmas dele. Isso não é regressão (sempre foi assim), mas é um buraco real que precisa de decisão de produto: código de convite da escola, aprovação por um admin, ou domínio de e-mail institucional. Não invente a regra sem alinhar.

## Conteúdo pedagógico

As questões e explicações são produzidas pela equipe de Medicina. Não invente conteúdo clínico (doses, sintomas, condutas, prazos de vacinação) para popular o `seed.sql`; use dados claramente marcados como placeholder ou peça o material à equipe.

Por isso o `seed.sql` planta **só os 7 cenários** (`ubs`, `escola`, `mercado`, `farmacia`, `praca`, `corrego`, `terreno-baldio`), que são estrutura do jogo. `missoes` e `questoes` ficam de fora esperando o material da Medicina; `escolas`, `turmas` e `usuarios` também, porque quem cria são as próprias pessoas pelo site. Num banco recém-semeado a lista de escolas aparece vazia — isso é o esperado, não um bug.
