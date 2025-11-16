CREATE TABLE
    passageiro (
        id_passageiro INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        cpf VARCHAR(14) UNIQUE NOT NULL,
        data_nascimento DATE NOT NULL,
        email VARCHAR(100),
        telefone VARCHAR(15),
        endereco_id INT,
        tipo_passageiro ENUM ('REGULAR', 'ESTUDANTE', 'IDOSO', 'PCD') NOT NULL,
        data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
        ultima_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    passageiro_detalhe (
        id_passageiro INT PRIMARY KEY,
        foto BLOB,
        documento_identidade VARCHAR(20),
        numero_documento VARCHAR(30),
        orgao_emissor VARCHAR(10),
        data_emissao DATE,
        possui_biometria BOOLEAN DEFAULT FALSE,
        biometria_digital BLOB,
        biometria_facial BLOB,
        FOREIGN KEY (id_passageiro) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    passageiro_estudante (
        id_estudante INT PRIMARY KEY,
        instituicao_ensino VARCHAR(100) NOT NULL,
        curso VARCHAR(100),
        matricula VARCHAR(50) NOT NULL,
        nivel_ensino ENUM (
            'FUNDAMENTAL',
            'MEDIO',
            'SUPERIOR',
            'POS-GRADUACAO'
        ) NOT NULL,
        validade_carteira DATE NOT NULL,
        FOREIGN KEY (id_estudante) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    passageiro_pcd (
        id_pcd INT PRIMARY KEY,
        tipo_deficiencia VARCHAR(100) NOT NULL,
        laudo_medico BLOB,
        necessita_acompanhante BOOLEAN DEFAULT FALSE,
        validade_laudo DATE,
        observacoes TEXT,
        FOREIGN KEY (id_pcd) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    passageiro_idoso (
        id_idoso INT PRIMARY KEY,
        numero_beneficio_inss VARCHAR(20),
        carteira_idoso VARCHAR(20),
        FOREIGN KEY (id_idoso) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    funcionario (
        id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        cpf VARCHAR(14) UNIQUE NOT NULL,
        data_nascimento DATE NOT NULL,
        email VARCHAR(100),
        telefone VARCHAR(15),
        endereco_id INT,
        cargo_id INT,
        departamento_id INT,
        data_admissao DATE NOT NULL,
        status ENUM ('ATIVO', 'FERIAS', 'LICENCA', 'DESLIGADO') DEFAULT 'ATIVO',
        data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    motorista (
        id_motorista INT PRIMARY KEY,
        cnh VARCHAR(15) NOT NULL,
        categoria_cnh ENUM ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE') NOT NULL,
        validade_cnh DATE NOT NULL,
        curso_transporte_coletivo BOOLEAN DEFAULT FALSE,
        curso_transporte_cargas BOOLEAN DEFAULT FALSE,
        pontuacao_cnh INT DEFAULT 0,
        exame_toxicologico_validade DATE,
        curso_direcao_defensiva BOOLEAN DEFAULT FALSE,
        anos_experiencia INT DEFAULT 0,
        FOREIGN KEY (id_motorista) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    cobrador (
        id_cobrador INT PRIMARY KEY,
        treinamento_atendimento BOOLEAN DEFAULT FALSE,
        certificado_manuseio_dinheiro BOOLEAN DEFAULT FALSE,
        conhecimento_rotas BOOLEAN DEFAULT FALSE,
        treinamento_seguranca BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (id_cobrador) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    endereco (
        id_endereco INT PRIMARY KEY AUTO_INCREMENT,
        logradouro VARCHAR(100) NOT NULL,
        numero VARCHAR(10) NOT NULL,
        complemento VARCHAR(100),
        bairro VARCHAR(50) NOT NULL,
        cidade VARCHAR(50) NOT NULL,
        estado CHAR(2) NOT NULL,
        cep VARCHAR(9) NOT NULL,
        pais VARCHAR(50) DEFAULT 'Brasil',
        coordenada_latitude DECIMAL(10, 8),
        coordenada_longitude DECIMAL(11, 8)
    );

CREATE TABLE
    cargo (
        id_cargo INT PRIMARY KEY AUTO_INCREMENT,
        nome_cargo VARCHAR(50) NOT NULL,
        descricao TEXT,
        salario_base DECIMAL(10, 2) NOT NULL,
        carga_horaria_semanal INT NOT NULL,
        nivel_hierarquico INT NOT NULL
    );

CREATE TABLE
    departamento (
        id_departamento INT PRIMARY KEY AUTO_INCREMENT,
        nome_departamento VARCHAR(50) NOT NULL,
        descricao TEXT,
        gestor_id INT,
        localizacao_id INT,
        centro_custo VARCHAR(20)
    );

CREATE TABLE
    escala_trabalho (
        id_escala INT PRIMARY KEY AUTO_INCREMENT,
        tipo_escala ENUM ('6X1', '5X2', '12X36', 'PERSONALIZADO') NOT NULL,
        hora_inicio TIME,
        hora_fim TIME,
        descricao VARCHAR(100),
        intervalo_minutos INT DEFAULT 60
    );