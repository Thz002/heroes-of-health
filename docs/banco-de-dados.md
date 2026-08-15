# Como o banco funciona — Heróis da Saúde

Documento de contexto do banco: o que existe hoje, por que foi desenhado assim,
e onde está incoerente.

**O banco hoje vive num arquivo só: `db/setup.sql`.** Ele é idempotente e
descreve tudo — tabelas, funções, gatilho, RLS e permissões por coluna. Para
mudar o banco, edite esse arquivo e rode de novo; não crie migrações
numeradas. Depois dele roda o `db/seed.sql`.

A §4 abaixo é o diagnóstico feito quando o banco ainda estava dividido em
`schema.sql` + `01-userAuth.sql` + `02-security.sql`. Esses arquivos foram para
`db/_historico/` e **não devem ser executados**. O diagnóstico continua no
documento porque explica *por que* o `setup.sql` é do jeito que é.

> **Aviso de validade:** este documento descreve os **arquivos do repositório**.
> A fonte da verdade é o projeto no dashboard do Supabase, e os dois podem ter
> divergido. A §5 traz as consultas para conferir qual dos dois está certo.

---

## 1. O desenho em uma frase

O navegador fala **direto** com o PostgreSQL do Supabase, sem servidor no meio.
Não existe nenhum lugar onde se possa escrever "se o usuário for professor,
deixe passar" — porque não existe código nosso rodando em lugar nenhum confiável.
Quem toma **todas** as decisões de permissão é o próprio banco, através do RLS
(Row Level Security).

Isso tem uma consequência que atravessa tudo o que vem abaixo:

> Qualquer coisa que o navegador consegue fazer, o aluno consegue fazer também —
> abrindo o console do navegador e chamando o Supabase na mão.
> A tela não protege nada. Só o RLS protege.

---

## 2. As duas metades do usuário

Esta é a parte que mais confunde, e é a origem do bug de cadastro.

Uma pessoa cadastrada existe em **dois lugares diferentes**, em duas tabelas
que vivem em schemas separados:

| Onde | Schema | O que guarda | Quem escreve |
|---|---|---|---|
| **Authentication → Users** | `auth.users` | e-mail, senha (hash), confirmação | o Supabase, sozinho |
| **Table Editor → usuarios** | `public.usuarios` | nome, tipo, idade, turma, escola | **o nosso código** |

As duas se amarram por um único campo: `usuarios.id` é `uuid` e tem
`references auth.users(id)`. É o mesmo identificador nas duas pontas.

Por que separado assim: senha só existe de um lado. `usuarios` **não tem**
coluna `senha` nem `email` de propósito — guardar senha em dois lugares é
exatamente o erro que este desenho evita. E como `auth.uid()` (a função que o
RLS usa para saber quem está pedindo) devolve o id de `auth.users`, é essa
amarração que faz toda a segurança funcionar.

### O caminho do cadastro, passo a passo

`AUTH.register()` em `src/js/supabase.js` faz **três escritas separadas**:

```
1. SUPA.auth.signUp()              -> cria a linha em auth.users     [o Supabase faz]
2. SUPA.from('escolas').insert()   -> só se for professor + escola nova
3. SUPA.from('usuarios').insert()  -> cria o perfil do jogo          [nós fazemos]
```

**Os três passos não são uma transação.** Se o 1 der certo e o 3 falhar, sobra
uma conta em `auth.users` sem perfil em `usuarios`. A pessoa consegue fazer
login, mas o jogo não sabe o nome dela, nem a idade, nem a turma.

**É exatamente esse o sintoma relatado:** o usuário aparece na aba *Users* do
Supabase e não aparece na tabela `usuarios`. O passo 3 está falhando.

### Por que o passo 3 falha — as três causas possíveis

**(a) "Confirm email" ligado no painel.** É a causa mais provável.
Com ela ligada, o `signUp` cria a conta mas **não devolve sessão** — a pessoa só
é considerada logada depois de clicar no link do e-mail. Sem sessão,
`auth.uid()` é nulo, e a policy `criar o proprio cadastro`
(`with check (auth.uid() = id)`) recusa o insert.
O código detecta esse caso e devolve a mensagem *"Conta criada, mas falta
confirmar o e-mail. Desligue 'Confirm email' no painel do Supabase."*
Se você viu essa mensagem, é essa a causa.
**Correção:** Authentication → Providers → Email → desligar *Confirm email*.

**(b) O RLS recusou por outro motivo.** A mensagem que aparece é
*"O banco recusou a operação por segurança."*

**(c) A migração `01-userAuth.sql` nunca rodou nesse projeto.** Aí a tabela
`usuarios` ainda é a versão antiga, com `id` numérico e colunas `senha`/`email`
obrigatórias, e o insert de um `uuid` quebra por tipo.

A §5 tem a consulta que distingue as três.

### A correção de raiz: parar de depender do passo 3

Enquanto o perfil for criado por uma segunda chamada do navegador, ele vai
falhar às vezes — por rede caída, aba fechada no meio, ou RLS. O padrão do
Supabase para isso é **um gatilho no banco**: quando nasce uma linha em
`auth.users`, o próprio banco cria a linha correspondente em `usuarios`, numa
função `security definer` (que roda ignorando o RLS).

Os dados extras (nome, tipo, idade, turma) viajam junto no `signUp`, dentro de
`options.data`, e o gatilho os lê de `raw_user_meta_data`. Assim vira **uma
escrita só**, atômica, que não depende de sessão nem de RLS.

---

## 3. As três camadas de tabelas

**Institucional — quem é quem**

```
escolas ──< turmas ──< usuarios
   ▲                      │
   └──────────────────────┘  (só PROFESSOR preenche escola_id)
```

- `escolas.nome` é `unique`, porque quem cadastra é o professor e sem isso o
  banco encheria de duplicata ("Santa Maria", "Colegio Santa Maria"...).
- `turmas.codigo` é o código curto ('7B-K3M9') que o professor entrega à sala.
- `turmas.professor_id` aponta para `usuarios` — a FK é criada **depois** das
  duas tabelas, porque elas dependem uma da outra.
- `usuarios.escola_id` só vale para PROFESSOR. Para ALUNO a escola se descobre
  por `turma_id → turmas.escola_id`. **Nunca preencha os dois no aluno.**
- `usuarios.idade` tem `check (idade between 7 and 18)`: o banco recusa sozinho,
  mesmo que a tela deixe passar.

**Conteúdo do jogo — só leitura pelo site**

```
cenarios ──< missoes ──< questoes
```

Ninguém cria conteúdo pelo jogo. Missões e questões são escritas pela equipe de
Medicina e entram pelo painel. O `seed.sql` planta só os 7 cenários
(`ubs`, `escola`, `mercado`, `farmacia`, `praca`, `corrego`, `terreno-baldio`).

**Progresso — uma linha por aluno**

- `progresso_areas` — as 8 barras, `unique (usuario_id, area_nome)`
- `respostas_alunos` — histórico, uma linha por resposta
- `pacientes_virtuais` — 1:1 com o aluno
- `quizzes_professores` — quiz ao vivo, pendurado na turma

Nenhuma dessas quatro é criada no cadastro. Um aluno recém-cadastrado tem zero
linhas nas três primeiras — quem cria é o jogo, na primeira vez que precisar.

---

## 4. Catálogo de incoerências

Em ordem de gravidade. As marcadas 🔴 tinham consequência de segurança real.

> **Estado:** os itens 1 a 9 estão corrigidos dentro de `db/setup.sql`. Rodar
> aquele arquivo resolve todos. Cada item mantém aqui o diagnóstico original,
> para que a próxima pessoa entenda *por que* a correção é do jeito que é —
> onde se lê "Correção:", o `setup.sql` já faz.
>
> Uma incoerência **continua aberta** e não foi corrigida aqui: qualquer pessoa
> se cadastra como PROFESSOR marcando o rádio na tela, e professor lê os dados
> dos alunos das turmas dele. Fechar isso exige decisão de produto (código de
> convite? aprovação por admin? domínio de e-mail?), então ficou registrado em
> vez de resolvido por conta própria.

### 🔴 1. A tabela `usuarios` fica sem RLS na instalação documentada

O `enable row level security` de `usuarios` existe **só** dentro de
`01-userAuth.sql` (linha 184), junto com as três policies básicas.
O `02-security.sql` liga o RLS das outras nove tabelas e **não liga o de
`usuarios`** — mas na linha 167 cria uma policy para ela.

Policy em tabela com RLS desligado é aceita sem erro e **não faz nada**.

Então a ordem que o `schema.sql` e o `CLAUDE.md` mandam seguir num projeto novo
(`schema.sql` → `02-security.sql` → `seed.sql`) produz um banco onde `usuarios`
está **totalmente aberta**: qualquer visitante com a chave publishable lê nome,
idade e turma de todos os alunos, e também escreve.

A instalação só fica correta por acidente, se alguém rodar o `01` — que é
justamente o arquivo que a documentação manda pular, porque ele dá `drop` em
5 tabelas.

**Correção:** mover o `enable` e as três policies de `usuarios` para o
`02-security.sql` (ou para uma migração 03), deixando o `01` como registro
histórico.

### 🔴 2. O código da turma não é segredo nenhum

```sql
create policy "qualquer um le as turmas"
  on turmas for select to anon, authenticated using (true);
```

A policy libera a **linha inteira**, e a linha inclui `codigo`. Qualquer pessoa,
sem conta, faz `select codigo from turmas` e recebe todos os códigos de todas as
escolas — mais o `professor_id` de cada uma.

O código foi pensado como uma credencial que o professor entrega à sala. Como
está, ele não filtra ninguém: dá para entrar em qualquer turma de qualquer
escola.

**Correção:** `anon` precisa enxergar apenas `id`, `nome` e `escola_id` — nunca
`codigo`. Isso se resolve com uma view sem a coluna, ou trocando a busca por
código por uma função no banco que recebe o código e devolve só a turma
correspondente.

### 🔴 3. O aluno é dono da própria pontuação

```sql
create policy "altera o proprio progresso"
  on progresso_areas for update to authenticated using (auth.uid() = usuario_id);
```

Está correta no sentido de "cada um só mexe no que é seu". Mas *o que é seu*
inclui a coluna `pontos`. Pelo console do navegador, o aluno faz
`update progresso_areas set pontos = 999999` na própria linha e o banco aceita —
é a linha dele.

O mesmo vale para `respostas_alunos`: o aluno insere `acertou = true` sem nunca
ter respondido nada.

Enquanto a pontuação for escrita pelo navegador, ela é sugestão, não fato.

**Correção:** o aluno perde o direito de escrever nessas tabelas. Quem escreve é
uma função no banco (`security definer`) ou o backend — ver §6.

### 🔴 4. O gabarito viaja para o navegador

Já registrado em `db/02-security.sql:99`. A policy de `questoes` libera a linha
inteira, e a linha tem `resposta_correta`. Dá para ler a resposta certa antes de
responder.

**Correção:** o navegador nunca deve receber essa coluna. A conferência acontece
do lado do banco, e a resposta que volta é só `acertou` + `explicacao`.

### 🟡 5. O painel do professor não tem como existir

O `02-security.sql` abre uma exceção para o professor ler os **alunos** das
turmas dele (linha 167). Mas parou aí. Não existe policy equivalente em
`progresso_areas` nem em `respostas_alunos` — as duas só permitem
`auth.uid() = usuario_id`.

Resultado: o professor vê a lista de nomes da turma e **nenhum dado de
desempenho**. O dashboard, que é um entregável do projeto, está bloqueado pelo
banco.

**Correção:** replicar a exceção do professor nas duas tabelas de progresso.

### 🟡 6. ADMIN é uma palavra sem nenhum poder

`tipo` aceita `'ADMIN'` no check, em `schema.sql:73` e `01-userAuth.sql:100`.
E é só isso. Uma busca no repositório inteiro mostra que `ADMIN` aparece
**apenas** dentro dessas duas constraints e no README.

Não existe: policy que dê qualquer permissão extra ao admin, tela de admin,
caminho de cadastro que crie um admin, nem checagem de `tipo === 'ADMIN'` em
lugar nenhum do front-end.

Hoje um ADMIN é, na prática, um ALUNO sem turma: ele enxerga só o próprio
cadastro. **A lógica de administrador não existe — ela precisa ser desenhada
do zero**, e as perguntas a responder são:

- Admin é da escola ou do sistema inteiro?
- Quem promove alguém a admin? (não pode ser a tela de cadastro: qualquer um
  escolheria "ADMIN" no formulário)
- O que ele faz que o professor não faz? (corrigir nome de escola errada,
  remover turma, revisar conteúdo, ver todas as escolas?)

### 🟡 7. Qualquer pessoa logada cria escola

```sql
-- comentário diz: "É o professor, no cadastro dele."
create policy "logado cria escola"
  on escolas for insert to authenticated with check (true);
```

O comentário e a regra discordam. `with check (true)` significa qualquer conta,
inclusive um aluno de 8 anos.

Só que aqui existe um nó real: no fluxo de cadastro, a escola é criada **antes**
da linha em `usuarios` existir. Uma policy que exigisse `tipo = 'PROFESSOR'`
consultaria uma linha que ainda não foi criada, e o cadastro do professor
quebraria.

**Correção:** a criação da escola sai do cadastro e vira parte do gatilho da §2,
ou passa por uma função no banco que cria escola e perfil na mesma transação.

### 🟡 8. Nada pode ser apagado, nunca

Não existe **uma única** policy `for delete` no projeto inteiro. Com RLS ligado,
o que não tem policy é proibido.

Efeitos práticos: o professor não apaga uma turma criada errada nem um quiz;
uma escola cadastrada com erro de digitação fica no banco para sempre — e como
`escolas.nome` é `unique`, o nome certo continua livre, mas o errado nunca sai
da lista que todos os alunos veem.

**Correção:** decidir caso a caso. Boa parte disso é melhor resolvida com uma
coluna `ativo boolean` (arquivar) do que com `delete` de verdade.

### 🔵 9. Divergências entre `schema.sql` e as migrações

Coisas que não quebram nada hoje, mas confundem a próxima migração:

- O cabeçalho do `schema.sql` (linha 12) manda rodar `migracao-02-seguranca.sql`.
  Esse arquivo não existe — o nome é `02-security.sql`.
- `schema.sql` cria as restrições de `turmas` inline (`codigo varchar(12) unique`,
  `unique (escola_id, nome)`), gerando os nomes automáticos `turmas_codigo_key` e
  `turmas_escola_id_nome_key`. O `01-userAuth.sql` cria as mesmas restrições como
  índices chamados `turmas_codigo_unico` e `turmas_nome_por_escola`.
  Um banco novo e um banco migrado ficam com **nomes diferentes** para a mesma
  regra — e um `drop constraint` escrito para um não funciona no outro.
- As três policies de `usuarios` no `01` não têm cláusula `to`, então valem
  `to public` (inclui `anon`). Não é explorável, porque `auth.uid()` é nulo para
  visitante, mas destoa das outras nove tabelas, que usam `to authenticated`.

---

## 5. Como conferir o banco de verdade

Rode no **SQL Editor** do dashboard. Estas consultas dizem qual é o estado real,
que pode não ser o dos arquivos.

**Quais tabelas estão desprotegidas** — a coluna `rowsecurity` precisa ser `true`
em todas as onze:

```sql
select tablename, rowsecurity
from pg_tables
where schemaname = 'public'
order by rowsecurity, tablename;
```

**Quais policies existem, por tabela:**

```sql
select tablename, policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public'
order by tablename, cmd;
```

**Contas sem perfil** — é a consulta do bug do cadastro. Toda linha que aparecer
aqui é alguém que entrou em `auth.users` e não chegou em `usuarios`:

```sql
select u.id, u.email, u.created_at, u.email_confirmed_at
from auth.users u
left join public.usuarios p on p.id = u.id
where p.id is null
order by u.created_at desc;
```

Se `email_confirmed_at` vier nulo nessas linhas, a causa é a **(a)** da §2:
"Confirm email" está ligado.

**A tabela `usuarios` é a versão nova?** — a coluna `id` precisa ser `uuid`, e
não pode existir coluna `senha` nem `email`:

```sql
select column_name, data_type
from information_schema.columns
where table_schema = 'public' and table_name = 'usuarios'
order by ordinal_position;
```

---

## 6. O que muda com um backend Express

Vale registrar por que a decisão de colocar um servidor no meio resolve as
incoerências 🔴 3 e 🔴 4, que o RLS sozinho não resolve bem.

O RLS responde bem à pergunta *"esta linha é sua?"*. Ele responde mal à pergunta
*"você merece estes pontos?"* — porque a segunda depende de regra de jogo, não de
propriedade da linha. Hoje, como só o navegador conhece a regra do jogo, é o
navegador que decide a pontuação, e ele está na mão do aluno.

Com um servidor, o desenho vira:

```
navegador ──► Express (chave secreta) ──► Supabase
    │
    └── continua falando direto com o Supabase Auth para login
```

O aluno manda "respondi B na questão 12". O servidor — que é o único que enxerga
`resposta_correta` — confere, calcula os pontos pelas regras das 8 áreas, grava,
e devolve apenas `acertou` + `explicacao`.

O que **não** muda: o RLS continua necessário. Ele vira a segunda tranca, para o
caso de a chave publishable ser usada direto, o que continua possível enquanto o
navegador falar com o Supabase para qualquer coisa. Backend não substitui RLS —
os dois se somam.
