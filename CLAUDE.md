# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexto

**Heróis da Saúde** — jogo educativo web sobre saúde pública, SUS e Atenção Primária, para alunos de 7 a 18 anos. Projeto Interdisciplinar II unindo Ciência da Computação (PUC Minas) e Medicina (PUC Betim). Entrega final: 20/10/2026.

O idioma do projeto é **português (pt-BR)**: nomes de tabelas, colunas, variáveis, rotas e textos de UI seguem o português (`usuarios`, `missoes`, `resposta_correta`, `acertou`). Mantenha essa convenção em qualquer código novo.

## Estado atual do repositório

**O projeto ainda é um esqueleto.** Todos os arquivos abaixo existem mas estão **vazios (0 bytes)**:

- `src/pages/index.html`, `src/pages/mapa.html`, `src/pages/missao.html`
- `src/css/style.css`
- `src/js/api.js`, `src/js/auth.js`, `src/js/quiz.js`, `src/js/mapa.js`
- `db/schema.sql`, `.env`, `.gitignore`
- `docs/` (diretório vazio)

Não existe `server.js`, nem `routes/`, `controllers/`, `views/`, `db/seed.sql` ou `.env.example`. As dependências já estão instaladas em `node_modules/`.

O [README.md](README.md) é a **especificação** do sistema, não a descrição do que existe. Trate-o como fonte da verdade para schema, regras de negócio e escopo — e confirme na árvore de arquivos antes de assumir que algo foi implementado.

## Ambiguidade de arquitetura a resolver

O README se contradiz e isso muda materialmente o que deve ser escrito. Antes de implementar a camada de dados ou as telas, alinhe com o usuário:

| Fonte | Arquitetura descrita |
|---|---|
| Cabeçalho + §2 + §6 do README, e as dependências instaladas | Monolito **MVC server-side**: Express + EJS (`routes/`, `controllers/`, `views/`), MySQL via `mysql2`, sessão via `express-session`, `npx nodemon server.js` |
| §4 do README e os arquivos já criados em `src/` | **Front-end estático**: páginas `.html` soltas, `src/js/supabase.js` como cliente único, Tailwind |

A stack instalada (`express`, `ejs`, `mysql2`, `express-session`, `bcryptjs`) só sustenta a primeira opção — **não há Supabase nem Tailwind no `package.json`**, e o cabeçalho do README diz Bootstrap, não Tailwind. Assuma MVC com Express + EJS + MySQL a menos que o usuário diga o contrário, e não introduza Supabase.

## Comandos

Não há scripts npm úteis definidos (`npm test` apenas falha com `exit 1`). O README documenta:

```bash
npm install                      # dependências já constam no package.json
npx nodemon server.js            # dev server, http://localhost:3000
```

O `db/schema.sql` está vazio; o DDL completo vive na §3 do README e precisa ser copiado para lá antes de importar no MySQL (Workbench, phpMyAdmin ou `mysql -u root -p < db/schema.sql`).

Variáveis de `.env` esperadas: `PORT`, `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME`, `SESSION_SECRET`.

O `.gitignore` está vazio e o repositório ainda não é um repo git — `node_modules/` e `.env` precisam ser ignorados antes do primeiro commit.

## Modelo de domínio

Onze tabelas (DDL na §3 do README), organizadas em três eixos:

- **Institucional:** `escolas` → `turmas` → `usuarios` (ENUM `tipo`: ALUNO / PROFESSOR / ADMIN; senha com `bcryptjs`).
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
