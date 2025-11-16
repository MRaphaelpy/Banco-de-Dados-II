CREATE TABLE
    treinamento (
        id_treinamento INT PRIMARY KEY AUTO_INCREMENT,
        titulo VARCHAR(100) NOT NULL,
        descricao TEXT,
        tipo_treinamento ENUM (
            'PRESENCIAL',
            'ONLINE',
            'HIBRIDO',
            'EM CAMPO',
            'WORKSHOP',
            'PALESTRA'
        ) NOT NULL,
        carga_horaria_total INT NOT NULL,
        area_conhecimento VARCHAR(100) NOT NULL,
        instituicao VARCHAR(100),
        instrutor VARCHAR(100),
        custo_por_participante DECIMAL(10, 2),
        certificado BOOLEAN DEFAULT TRUE,
        data_inicio DATE,
        data_fim DATE,
        horario VARCHAR(100),
        local_realizacao VARCHAR(255),
        publico_alvo VARCHAR(255),
        pre_requisitos TEXT,
        status ENUM (
            'PLANEJADO',
            'EM ANDAMENTO',
            'CONCLUIDO',
            'CANCELADO',
            'ADIADO'
        ) DEFAULT 'PLANEJADO',
        material_didatico TEXT,
        avaliacao_media DECIMAL(3, 1),
        observacoes TEXT
    );

CREATE TABLE
    participante_treinamento (
        id_participante INT PRIMARY KEY AUTO_INCREMENT,
        treinamento_id INT NOT NULL,
        funcionario_id INT NOT NULL,
        data_inscricao DATE NOT NULL,
        aprovado_por_id INT,
        status_participacao ENUM (
            'INSCRITO',
            'CONFIRMADO',
            'CONCLUIDO',
            'REPROVADO',
            'AUSENTE',
            'CANCELADO'
        ) DEFAULT 'INSCRITO',
        data_conclusao DATE,
        nota_final DECIMAL(4, 1),
        percentual_presenca DECIMAL(5, 2),
        certificado_emitido BOOLEAN DEFAULT FALSE,
        data_emissao_certificado DATE,
        avaliacao_reacao INT,
        comentarios TEXT,
        FOREIGN KEY (treinamento_id) REFERENCES treinamento (id_treinamento),
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario),
        UNIQUE KEY (treinamento_id, funcionario_id)
    );

CREATE TABLE
    exame_medico (
        id_exame INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        tipo_exame ENUM (
            'ADMISSIONAL',
            'PERIODICO',
            'RETORNO AO TRABALHO',
            'MUDANCA FUNCAO',
            'DEMISSIONAL',
            'COMPLEMENTAR'
        ) NOT NULL,
        data_realizacao DATE NOT NULL,
        data_validade DATE,
        medico_responsavel VARCHAR(100) NOT NULL,
        crm_medico VARCHAR(20) NOT NULL,
        clinica VARCHAR(100),
        resultado ENUM (
            'APTO',
            'INAPTO',
            'APTO COM RESTRICOES',
            'PENDENTE COMPLEMENTACAO'
        ) NOT NULL,
        restricoes TEXT,
        observacoes_medicas TEXT,
        exames_realizados TEXT,
        encaminhamentos TEXT,
        documento_resultado BLOB,
        status ENUM (
            'AGENDADO',
            'REALIZADO',
            'AVALIADO',
            'CANCELADO',
            'NAO COMPARECEU'
        ) DEFAULT 'AGENDADO',
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    documento_funcionario (
        id_documento INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        tipo_documento ENUM (
            'RG',
            'CPF',
            'CNH',
            'CTPS',
            'TITULO ELEITOR',
            'PIS/PASEP',
            'CERTIDAO NASCIMENTO',
            'CERTIDAO CASAMENTO',
            'COMPROVANTE ENDERECO',
            'CERTIFICADO RESERVISTA',
            'DIPLOMA',
            'CERTIFICADO',
            'ATESTADO MEDICO',
            'CONTRATO TRABALHO',
            'OUTROS'
        ) NOT NULL,
        numero_documento VARCHAR(50),
        data_emissao DATE,
        data_validade DATE,
        orgao_emissor VARCHAR(50),
        descricao VARCHAR(255),
        arquivo BLOB,
        nome_arquivo VARCHAR(255),
        tamanho_arquivo INT,
        tipo_arquivo VARCHAR(50),
        data_upload DATETIME DEFAULT CURRENT_TIMESTAMP,
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    dependente (
        id_dependente INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        nome VARCHAR(100) NOT NULL,
        data_nascimento DATE NOT NULL,
        parentesco ENUM (
            'CONJUGE',
            'FILHO(A)',
            'PAI',
            'MAE',
            'IRMAO(A)',
            'AVO(O)',
            'OUTRO'
        ) NOT NULL,
        cpf VARCHAR(14) UNIQUE NOT NULL,
        sexo ENUM ('MASCULINO', 'FEMININO', 'OUTRO') NOT NULL,
        ir_beneficiario BOOLEAN DEFAULT FALSE,
        plano_saude_beneficiario BOOLEAN DEFAULT FALSE,
        plano_odonto_beneficiario BOOLEAN DEFAULT FALSE,
        auxilio_creche BOOLEAN DEFAULT FALSE,
        salario_familia BOOLEAN DEFAULT FALSE,
        possui_deficiencia BOOLEAN DEFAULT FALSE,
        tipo_deficiencia VARCHAR(100),
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    habilidade_funcionario (
        id_habilidade_funcionario INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        habilidade VARCHAR(100) NOT NULL,
        nivel ENUM (
            'BASICO',
            'INTERMEDIARIO',
            'AVANCADO',
            'ESPECIALISTA'
        ) NOT NULL,
        certificado BOOLEAN DEFAULT FALSE,
        data_certificacao DATE,
        instituicao_certificadora VARCHAR(100),
        anos_experiencia INT,
        ultima_utilizacao DATE,
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario),
        UNIQUE KEY (funcionario_id, habilidade)
    );

CREATE TABLE
    ferias (
        id_ferias INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        periodo_aquisitivo_inicio DATE NOT NULL,
        periodo_aquisitivo_fim DATE NOT NULL,
        data_inicio_gozo DATE,
        data_fim_gozo DATE,
        qtde_dias_gozo INT,
        qtde_dias_abono INT DEFAULT 0,
        valor_ferias DECIMAL(10, 2),
        valor_abono DECIMAL(10, 2),
        valor_1terco DECIMAL(10, 2),
        data_pagamento DATE,
        status ENUM (
            'PROGRAMADA',
            'APROVADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'CANCELADA'
        ) DEFAULT 'PROGRAMADA',
        aprovado_por_id INT,
        data_aprovacao DATE,
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    advertencia_suspensao (
        id_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        tipo ENUM (
            'ADVERTENCIA VERBAL',
            'ADVERTENCIA ESCRITA',
            'SUSPENSAO'
        ) NOT NULL,
        data_ocorrencia DATE NOT NULL,
        motivo TEXT NOT NULL,
        descricao_detalhada TEXT,
        dias_suspensao INT,
        valor_desconto DECIMAL(10, 2),
        gestor_responsavel_id INT NOT NULL,
        testemunhas TEXT,
        ciencia_funcionario BOOLEAN DEFAULT FALSE,
        data_ciencia DATE,
        contestacao TEXT,
        documento BLOB,
        data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
        registrado_por_id INT NOT NULL,
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    avaliacao_desempenho (
        id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
        funcionario_id INT NOT NULL,
        avaliador_id INT NOT NULL,
        periodo_referencia VARCHAR(7) NOT NULL,
        tipo_avaliacao ENUM (
            'PERIODICA',
            'EXPERIENCIA',
            'PROMOCAO',
            'DESLIGAMENTO',
            '360 GRAUS'
        ) NOT NULL,
        data_avaliacao DATE NOT NULL,
        nota_geral DECIMAL(3, 1) NOT NULL,
        produtividade DECIMAL(3, 1),
        qualidade DECIMAL(3, 1),
        assiduidade DECIMAL(3, 1),
        pontualidade DECIMAL(3, 1),
        relacionamento DECIMAL(3, 1),
        lideranca DECIMAL(3, 1),
        conhecimento_tecnico DECIMAL(3, 1),
        iniciativa DECIMAL(3, 1),
        comunicacao DECIMAL(3, 1),
        comprometimento DECIMAL(3, 1),
        pontos_fortes TEXT,
        pontos_melhoria TEXT,
        plano_desenvolvimento TEXT,
        feedback_funcionario TEXT,
        data_ciencia_funcionario DATE,
        status ENUM (
            'REALIZADA',
            'EM ANDAMENTO',
            'AGUARDANDO CIENCIA',
            'CONCLUIDA',
            'CANCELADA'
        ) DEFAULT 'EM ANDAMENTO',
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario),
        FOREIGN KEY (avaliador_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    requisicao_pessoal (
        id_requisicao INT PRIMARY KEY AUTO_INCREMENT,
        solicitante_id INT NOT NULL,
        data_solicitacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        departamento_id INT NOT NULL,
        cargo_id INT NOT NULL,
        quantidade INT NOT NULL DEFAULT 1,
        tipo_contratacao ENUM (
            'CLT',
            'TEMPORARIO',
            'ESTAGIO',
            'TERCEIRIZADO',
            'PJ',
            'APRENDIZ'
        ) NOT NULL,
        motivo ENUM (
            'AUMENTO QUADRO',
            'SUBSTITUICAO',
            'TEMPORARIO',
            'PROJETO ESPECIFICO'
        ) NOT NULL,
        perfil_desejado TEXT,
        atividades TEXT NOT NULL,
        requisitos_obrigatorios TEXT,
        requisitos_desejaveis TEXT,
        faixa_salarial_min DECIMAL(10, 2),
        faixa_salarial_max DECIMAL(10, 2),
        beneficios TEXT,
        prazo_contratacao DATE,
        status ENUM (
            'SOLICITADA',
            'EM ANALISE',
            'APROVADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'CANCELADA',
            'SUSPENSA'
        ) DEFAULT 'SOLICITADA',
        aprovador_id INT,
        data_aprovacao DATE,
        observacoes TEXT,
        FOREIGN KEY (solicitante_id) REFERENCES funcionario (id_funcionario),
        FOREIGN KEY (departamento_id) REFERENCES departamento (id_departamento),
        FOREIGN KEY (cargo_id) REFERENCES cargo (id_cargo)
    );