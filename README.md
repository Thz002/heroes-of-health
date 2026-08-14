# 🦸‍♂️ Heróis da Saúde — Documento de Contexto Técnico & Arquitetura de Software

> **Documentação de Contexto do Sistema para o Claude Code / Agentes de IA**  
> **Projeto Interdisciplinar II** | Ciência da Computação (PUC Minas - 2º Período) & Medicina (PUC Betim - 2º Período)  
> **Prazo de Entrega Final:** 20 de Outubro de 2026  
> **Stack Principal:** Node.js (JavaScript puro + Express + EJS) + MySQL (`mysql2`) + Bootstrap / CSS3

---

## 📋 Sumário
1. [Visão Geral e Contexto do Projeto](#1-visão-geral-e-contexto-do-projeto)
2. [Arquitetura Simplificada do Sistema](#2-arquitetura-simplificada-do-sistema)
3. [Modelagem do Banco de Dados Relacional (MySQL)](#3-modelagem-do-banco-de-dados-relacional-mysql)
4. [Estrutura de Pastas no VS Code](#4-estrutura-de-pastas-no-vs-code)
5. [Regras de Negócio e Mecânicas do Jogo](#5-regras-de-negócio-e-mecânicas-do-jogo)
6. [Instruções para o Claude Code (Padrões de Código)](#6-instruções-para-o-claude-code-padrões-de-código)
7. [Guia de Configuração e Execução Local](#7-guia-de-configuração-e-execução-local)

---

## 1. Visão Geral e Contexto do Projeto

O **Heróis da Saúde** é um jogo educativo web e interativo desenvolvido no âmbito do **Projeto Interdisciplinar II**, unindo estudantes de **Ciência da Computação da PUC Minas** e **Medicina da PUC Betim**.

### 1.1 Propósito e Objetivos
- **Educação em Saúde Infantojuvenil:** Apresentar temas de saúde pública, higiene, prevenção de doenças e imunização de forma lúdica (para idades de 7 a 18 anos).
- **Inclusão do SUS e Atenção Primária:** Ensinar o papel da Unidade Básica de Saúde (UBS) e de seus profissionais (Médico de Família, Enfermeiro, Técnico de Enfermagem, ACS, Psicólogo, Nutricionista e Dentista).
- **Abordagem Pedagógica por Níveis:**
  - **Nível 1 (7 a 10 anos):** Higiene pessoal, combate ao Aedes aegypti, descarte de lixo e noções básicas do corpo.
  - **Nível 2 (11 a 14 anos):** ISTs, sistema reprodutor, introdução ao SUS, primeiros socorros e saúde mental.
  - **Nível 3 (15 a 18 anos):** Microbiologia, imunologia, parasitologia, fisiologia e questões estilo ENEM.
- **Painel do Professor:** Acompanhamento do progresso de turmas e alunos, criação de quizzes rápidos (estilo Kahoot) e dinâmicas coletivas.

---

## 2. Arquitetura Simplificada do Sistema

A aplicação adota o modelo **MVC (Model-View-Controller)** dentro de um projeto Node.js único e monolítico:

```
  ┌─────────────────────────────────────────────────────────────┐
  │                 Navegador (HTML5 / Bootstrap / JS)           │
  └──────────────────────────────┬──────────────────────────────┘
                                 │ Requisições HTTP (GET/POST)
                                 ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                 Servidor Node.js + Express                  │
  │   - Mapeamento de Rotas (routes/)                           │
  │   - Regras de Negócio / Lógica do Jogo (controllers/)       │
  │   - Renderização de Telas EJS (views/)                      │
  └──────────────────────────────┬──────────────────────────────┘
                                 │ Consultas SQL (Driver mysql2)
                                 ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                   Banco de Dados MySQL                      │
  └─────────────────────────────────────────────────────────────┘
```

---

## 3. Modelagem do Banco de Dados Relacional (MySQL)

Script SQL completo para criação do banco de dados `herois_da_saude`:

```sql
CREATE DATABASE IF NOT EXISTS herois_da_saude DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE herois_da_saude;

-- Tabela de Escolas
CREATE TABLE IF NOT EXISTS escolas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Turmas
CREATE TABLE IF NOT EXISTS turmas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, -- Ex: '7º Ano B'
    escola_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (escola_id) REFERENCES escolas(id) ON DELETE CASCADE
);

-- Tabela de Usuários (Alunos e Professores)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('ALUNO', 'PROFESSOR', 'ADMIN') DEFAULT 'ALUNO',
    idade INT NULL,
    turma_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (turma_id) REFERENCES turmas(id) ON DELETE SET NULL
);

-- Tabela de Progresso por Área Temática do Jogo
CREATE TABLE IF NOT EXISTS progresso_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    area_nome VARCHAR(50) NOT NULL, -- Saúde, Educação, Vacinação, Vetores, Limpeza, Alimentação, Exercícios, Felicidade
    porcentagem FLOAT DEFAULT 0.0,
    pontos INT DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE KEY uq_usuario_area (usuario_id, area_nome)
);

-- Tabela de Cenários do Mapa (Bairro)
CREATE TABLE IF NOT EXISTS cenarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL, -- ex: 'ubs', 'mercado', 'farmacia', 'escola'
    nome VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL
);

-- Tabela de Missões do Jogo
CREATE TABLE IF NOT EXISTS missoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cenario_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,
    nivel_etario INT NOT NULL DEFAULT 1, -- 1 (7-10 anos), 2 (11-14 anos), 3 (15-18 anos)
    eh_especial BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (cenario_id) REFERENCES cenarios(id) ON DELETE CASCADE
);

-- Tabela de Questões/Perguntas
CREATE TABLE IF NOT EXISTS questoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    missao_id INT NOT NULL,
    enunciado TEXT NOT NULL,
    opcao_a VARCHAR(255) NOT NULL,
    opcao_b VARCHAR(255) NOT NULL,
    opcao_c VARCHAR(255) NOT NULL,
    opcao_d VARCHAR(255) NOT NULL,
    resposta_correta CHAR(1) NOT NULL, -- 'A', 'B', 'C' ou 'D'
    explicacao TEXT NOT NULL, -- Feedback educativo após responder
    FOREIGN KEY (missao_id) REFERENCES missoes(id) ON DELETE CASCADE
);

-- Tabela de Histórico de Respostas dos Alunos
CREATE TABLE IF NOT EXISTS respostas_alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    questao_id INT NOT NULL,
    acertou BOOLEAN NOT NULL,
    data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (questao_id) REFERENCES questoes(id) ON DELETE CASCADE
);

-- Tabela do Paciente Virtual
CREATE TABLE IF NOT EXISTS pacientes_virtuais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL,
    nome_paciente VARCHAR(100) NOT NULL,
    idade_paciente INT NOT NULL,
    estado_saude VARCHAR(100) DEFAULT 'Estável',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabela de Quizzes Customizados criados pelo Professor
CREATE TABLE IF NOT EXISTS quizzes_professores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    turma_id INT NOT NULL,
    professor_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    tempo_limite_segundos INT DEFAULT 15,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (turma_id) REFERENCES turmas(id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
```

---

## 4. Estrutura de Pastas no VS Code

```text
herois-da-saude/
├── src/
│   ├── pages/               # Cada tela .html
│   │   ├── index.html       # Login
│   │   ├── mapa.html        # Bairro interativo
│   │   └── missao.html      # Tela de quiz
│   ├── css/
│   │   └── style.css        # Estilos próprios (
│   ├── js/
│   │   ├── supabase.js      # Cliente Supabase (config única, importada por todos)
│   │   ├── auth.js          # Login, cadastro, logout
│   │   ├── api.js           # Todas as queries ao banco ficam aqui
│   │   ├── quiz.js          # Lógica do jogo (pontuação, streak, validação)
│   │   └── mapa.js          # Interações do mapa
│   └── assets/
│       ├── img/
│       └── audio/           # Sons de acerto/erro
│
├── db/
│   ├── schema.sql           # Criação das tabelas (versionado!)
│   └── seed.sql             # Dados iniciais (perguntas, doenças)
│
├── docs/                    # Entregáveis da disciplina
│   ├── personas.md
│   └── user-story-map.md
│
├── .env.example             # Modelo das variáveis (sem as chaves reais!)
├── .gitignore
└── README.md
```

---

## 5. Regras de Negócio e Mecânicas do Jogo

1. **Atribuição de Pontuação Multi-Área:**
   Ao responder corretamente uma questão de missão, o controlador distribui pontos nas 8 barras de progresso (`progresso_areas`): *Saúde, Educação, Vacinação, Vetores, Limpeza, Alimentação, Exercícios e Felicidade*.
2. **Navegação do Bairro:**
   A página `mapa.ejs` renderiza o bairro com pontos clicáveis (UBS, Escola, Mercado, Farmácia, Córrego, Terreno Baldio, etc.). Clicar em um cenário abre as missões compatíveis com a faixa etária/nível do aluno.
3. **Mecanismo de Feedback Educativo:**
   Caso o aluno erre uma pergunta, a aplicação exibe a explicação elaborada pela equipe de Medicina de forma positiva e motivadora, incentivando a nova tentativa.
4. **Paciente Virtual:**
   Cada aluno é vinculado a um paciente virtual. O sistema registra o status do paciente à medida que o aluno avança nas missões da UBS e da Farmácia.
5. **Acessibilidade Nativa no Front-end:**
   Implementação de Web Speech API (JavaScript nativo `window.speechSynthesis`) nas páginas de missão para leitura em áudio das questões para deficientes visuais.

---

## 6. Guia de Configuração e Execução Local

### 6.1 Instalação de Dependências
No terminal da raiz do projeto, instale as dependências essenciais:
```bash
npm init -y
npm install express ejs mysql2 dotenv express-session bcryptjs
npm install --save-dev nodemon
```

### 6.2 Arquivo de Configuração `.env`
Crie o arquivo `.env` com as configurações do MySQL local:
```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASS=sua_senha
DB_NAME=herois_da_saude
SESSION_SECRET=chave_secreta_herois
```

### 6.3 Execução
1. Importe o arquivo `schema.sql` no seu MySQL (via MySQL Workbench, phpMyAdmin ou linha de comando).
2. Inicie o servidor em modo de desenvolvimento:
```bash
npx nodemon server.js
```
3. Acesse `http://localhost:3000` no seu navegador.
