-- ESQUEMA DO BANCO DE DADOS DO PROJETO



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