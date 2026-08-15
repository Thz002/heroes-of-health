# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexto

**Heróis da Saúde** — jogo educativo web sobre saúde pública, SUS e Atenção Primária, para alunos de 7 a 18 anos. Projeto Interdisciplinar II unindo Ciência da Computação (PUC Minas) e Medicina (PUC Betim). Entrega final: 20/10/2026.

O idioma do projeto é **português (pt-BR)**: nomes de tabelas, colunas, variáveis, rotas e textos de UI seguem o português (`usuarios`, `missoes`, `resposta_correta`, `acertou`). Mantenha essa convenção em qualquer código novo.

## Arquitetura — decidida

**Front-end estático + Supabase.** Páginas `.html` soltas em `src/pages/`, JavaScript puro em `src/js/`, e o navegador conversa **direto** com o Supabase. Não há servidor próprio, e não deve ser criado sem alinhar antes.

**O banco é PostgreSQL** (Supabase), não MySQL. Qualquer DDL novo precisa ser escrito em dialeto PostgreSQL. As dependências `express`, `ejs`, `mysql2` e `express-session` continuam no `package.json` mas são resquício da arquitetura antiga — não use.

A fonte da verdade do banco é o projeto no dashboard do Supabase. Os arquivos em `db/` são o registro escrito dele.

## Estado atual do repositório

Implementado:

- `src/pages/index.html` — tela única de login e cadastro, com escola → turma em cascata e entrada por código de turma
- `src/js/supabase.js` — conexão única (`SUPA`) e autenticação (`AUTH`)
- `src/js/api.js` — camada de dados; as funções de escola/turma falam direto com o Supabase
- `src/js/auth.js` — controle da tela de login/cadastro
- `src/css/style.css`
- `db/schema.sql` (PostgreSQL), `db/seed.sql`, `db/01-userAuth.sql`, `db/02-security.sql`

Ainda vazios: `src/pages/mapa.html`, `src/pages/missao.html`, `src/pages/dashboard.html`, `src/js/quiz.js`, `src/js/mapa.js`, `docs/personas.md`, `docs/user-story-map.md`.

O [README.md](README.md) é a **especificação** original e está desatualizado em relação à arquitetura: ele descreve Express + EJS + MySQL. Use-o para regras de negócio e escopo, não para stack nem para DDL.

## Autenticação

Quem guarda a senha é o **Supabase Auth**, na tabela interna `auth.users`. A tabela `usuarios` é um **perfil**: sua chave primária é um `uuid` que referencia `auth.users(id)`, e ela **não tem colunas `senha` nem `email`**. Não reintroduza essas colunas nem `bcryptjs`.

Consequência prática: `auth.uid()` identifica quem está logado, e é isso que faz o **RLS (Row Level Security)** funcionar. Toda tabela nova precisa de RLS ligado e políticas explícitas — sem isso ela fica aberta a qualquer visitante com a chave publishable.

`escolas` e `turmas` são legíveis por `anon` de propósito: o aluno escolhe a escola **antes** de ter conta.

## Chaves e ambiente

O `.env` guarda `SUPABASE_URL` e `SUPABASE_ANON_KEY`, e está no `.gitignore`. Mas páginas estáticas não leem `.env` — a URL e a chave **publishable** ficam no topo de `src/js/supabase.js`, o que é o uso correto (essa chave é pública por design).

**Nunca** coloque a chave `sb_secret_` em nenhum arquivo do front-end. O Supabase bloqueia o uso dela no navegador, e ela dá acesso irrestrito ao banco.

## Comandos

Não há build nem servidor. As páginas abrem direto no navegador (`file://`), e a biblioteca do Supabase é carregada de `node_modules/@supabase/supabase-js/dist/umd/supabase.js`.

Os arquivos de `db/` rodam no **SQL Editor** do dashboard do Supabase, nesta ordem em um projeto novo: `schema.sql` → `02-security.sql` → `seed.sql`. Num banco já existente, escreva uma migração nova em vez de rodar o `schema.sql`. O número no começo do nome indica a ordem de execução — migrações já executadas nunca são alteradas.

## Modelo de domínio

Onze tabelas (DDL na §3 do README), organizadas em três eixos:

- **Institucional:** `escolas` → `turmas` → `usuarios` (`tipo` com check: ALUNO / PROFESSOR / ADMIN). `turmas` tem `codigo` (o código curto que o professor entrega à sala) e `professor_id`. `usuarios.escola_id` só é preenchido para PROFESSOR; para ALUNO a escola se deriva de `turma_id → turmas.escola_id`.
- **Conteúdo do jogo:** `cenarios` (pontos do bairro, identificados por `slug`: `ubs`, `mercado`, `farmacia`, `escola`…) → `missoes` (com `nivel_etario` 1–3 e flag `eh_especial`) → `questoes` (múltipla escolha A–D + `explicacao`).
- **Progresso do aluno:** `progresso_areas` (única por `usuario_id` + `area_nome`), `respostas_alunos` (histórico), `pacientes_virtuais` (1:1 com o aluno), `quizzes_professores` (quizzes ao vivo estilo Kahoot, com `tempo_limite_segundos`).

## Regras de negócio que atravessam o código

- **Pontuação multi-área:** um acerto distribui pontos entre 8 barras fixas em `progresso_areas` — *Saúde, Educação, Vacinação, Vetores, Limpeza, Alimentação, Exercícios, Felicidade*. Essa lista é fechada; use exatamente esses nomes em `area_nome`.
- **Filtro etário:** as missões de um cenário só aparecem se o `nivel_etario` for compatível com a idade do aluno. Nível 1 = 7–10 anos (higiene, Aedes, lixo), nível 2 = 11–14 (ISTs, SUS, primeiros socorros, saúde mental), nível 3 = 15–18 (microbiologia, imunologia, estilo ENEM).
- **Feedback educativo:** ao errar, exibir a `explicacao` da questão — escrita pela equipe de Medicina — em tom positivo e encorajando nova tentativa. O erro nunca é apresentado como punição.
- **Paciente virtual:** o `estado_saude` do paciente vinculado ao aluno evolui conforme ele avança nas missões da UBS e da Farmácia.
- **Acessibilidade:** as telas de missão devem ler as questões em voz alta via Web Speech API nativa (`window.speechSynthesis`) — sem biblioteca externa.

## Conteúdo pedagógico

As questões e explicações são produzidas pela equipe de Medicina. Não invente conteúdo clínico (doses, sintomas, condutas, prazos de vacinação) para popular o `seed.sql`; use dados claramente marcados como placeholder ou peça o material à equipe.
