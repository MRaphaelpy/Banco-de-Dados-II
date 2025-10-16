CREATE TABLE
    cliente (
        id_cliente INT PRIMARY KEY AUTO_INCREMENT,
        tipo_pessoa ENUM ('Física', 'Jurídica') NOT NULL,
        nome_razao_social VARCHAR(100) NOT NULL,
        cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
        rg_inscricao_estadual VARCHAR(20),
        endereco_id INT,
        telefone VARCHAR(15),
        email VARCHAR(100),
        contato_nome VARCHAR(100),
        contato_telefone VARCHAR(15),
        segmento_atuacao VARCHAR(50),
        data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
        status_cliente ENUM ('Ativo', 'Inativo', 'Bloqueado', 'Prospecto') DEFAULT 'Ativo',
        limite_credito DECIMAL(10, 2) DEFAULT 0.00,
        observacoes TEXT
    );

CREATE TABLE
    tipo_carga (
        id_tipo_carga INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(50) NOT NULL,
        descricao TEXT,
        codigo_classificacao VARCHAR(20),
        requer_refrigeracao BOOLEAN DEFAULT FALSE,
        perigosa BOOLEAN DEFAULT FALSE,
        fragil BOOLEAN DEFAULT FALSE,
        perecivel BOOLEAN DEFAULT FALSE,
        temperatura_minima DECIMAL(5, 2),
        temperatura_maxima DECIMAL(5, 2),
        codigo_un_perigoso VARCHAR(10),
        classe_risco VARCHAR(10),
        exige_licenca_especial BOOLEAN DEFAULT FALSE,
        observacoes TEXT
    );

CREATE TABLE
    carga (
        id_carga INT PRIMARY KEY AUTO_INCREMENT,
        cliente_id INT NOT NULL,
        tipo_carga_id INT NOT NULL,
        descricao VARCHAR(255) NOT NULL,
        peso_kg DECIMAL(10, 3) NOT NULL,
        volume_m3 DECIMAL(10, 3),
        valor_declarado DECIMAL(10, 2),
        valor_frete DECIMAL(10, 2),
        seguro BOOLEAN DEFAULT FALSE,
        valor_seguro DECIMAL(10, 2),
        qtde_volumes INT DEFAULT 1,
        necessita_empilhadeira BOOLEAN DEFAULT FALSE,
        restricoes_manuseio TEXT,
        status_carga ENUM (
            'Registrada',
            'Coletada',
            'Em trânsito',
            'Em entrega',
            'Entregue',
            'Devolvida',
            'Extraviada',
            'Avariada'
        ) DEFAULT 'Registrada',
        observacoes TEXT,
        data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (cliente_id) REFERENCES cliente (id_cliente),
        FOREIGN KEY (tipo_carga_id) REFERENCES tipo_carga (id_tipo_carga)
    );

CREATE TABLE
    volume (
        id_volume INT PRIMARY KEY AUTO_INCREMENT,
        carga_id INT NOT NULL,
        codigo_barras VARCHAR(50) UNIQUE,
        sequencial INT NOT NULL,
        tipo_embalagem ENUM (
            'Caixa',
            'Pallet',
            'Container',
            'Saco',
            'Tambor',
            'Engradado',
            'Outro'
        ) NOT NULL,
        peso_kg DECIMAL(8, 3) NOT NULL,
        altura_cm DECIMAL(6, 2) NOT NULL,
        largura_cm DECIMAL(6, 2) NOT NULL,
        comprimento_cm DECIMAL(6, 2) NOT NULL,
        empilhavel BOOLEAN DEFAULT TRUE,
        quantidade_itens INT DEFAULT 1,
        etiqueta_impressa BOOLEAN DEFAULT FALSE,
        status_volume ENUM (
            'Registrado',
            'Coletado',
            'Armazenado',
            'Em transporte',
            'Entregue',
            'Avariado',
            'Extraviado'
        ) DEFAULT 'Registrado',
        observacoes TEXT,
        FOREIGN KEY (carga_id) REFERENCES carga (id_carga)
    );

CREATE TABLE
    ordem_transporte (
        id_ordem INT PRIMARY KEY AUTO_INCREMENT,
        codigo_ordem VARCHAR(20) UNIQUE NOT NULL,
        cliente_id INT NOT NULL,
        tipo_servico ENUM (
            'Coleta',
            'Entrega',
            'Coleta e Entrega',
            'Transferência',
            'Distribuição'
        ) NOT NULL,
        prioridade ENUM ('Baixa', 'Normal', 'Alta', 'Urgente') DEFAULT 'Normal',
        data_solicitacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        data_prevista_execucao DATE NOT NULL,
        horario_inicio_previsto TIME,
        horario_fim_previsto TIME,
        status_ordem ENUM (
            'Registrada',
            'Planejada',
            'Em andamento',
            'Concluída',
            'Cancelada',
            'Reprogramada'
        ) DEFAULT 'Registrada',
        observacoes TEXT,
        solicitante_nome VARCHAR(100),
        solicitante_contato VARCHAR(50),
        valor_total DECIMAL(10, 2),
        forma_pagamento VARCHAR(50),
        FOREIGN KEY (cliente_id) REFERENCES cliente (id_cliente)
    );

CREATE TABLE
    item_ordem_transporte (
        id_item_ordem INT PRIMARY KEY AUTO_INCREMENT,
        ordem_id INT NOT NULL,
        carga_id INT NOT NULL,
        endereco_origem_id INT NOT NULL,
        endereco_destino_id INT NOT NULL,
        data_coleta_prevista DATETIME,
        data_entrega_prevista DATETIME,
        data_coleta_realizada DATETIME,
        data_entrega_realizada DATETIME,
        status_item ENUM (
            'Pendente',
            'Coletado',
            'Em transporte',
            'Em distribuição',
            'Entregue',
            'Cancelado',
            'Com problema'
        ) DEFAULT 'Pendente',
        responsavel_origem VARCHAR(100),
        responsavel_destino VARCHAR(100),
        observacoes TEXT,
        FOREIGN KEY (ordem_id) REFERENCES ordem_transporte (id_ordem),
        FOREIGN KEY (carga_id) REFERENCES carga (id_carga)
    );

CREATE TABLE
    rota_carga (
        id_rota_carga INT PRIMARY KEY AUTO_INCREMENT,
        codigo_rota VARCHAR(20) NOT NULL,
        descricao VARCHAR(255) NOT NULL,
        tipo_rota ENUM (
            'Urbana',
            'Intermunicipal',
            'Interestadual',
            'Internacional',
            'Mista'
        ) NOT NULL,
        cidade_origem VARCHAR(100) NOT NULL,
        uf_origem CHAR(2) NOT NULL,
        cidade_destino VARCHAR(100) NOT NULL,
        uf_destino CHAR(2) NOT NULL,
        distancia_km DECIMAL(10, 2) NOT NULL,
        tempo_estimado_horas DECIMAL(6, 2) NOT NULL,
        pedágios INT DEFAULT 0,
        requer_autorizacao_especial BOOLEAN DEFAULT FALSE,
        observacoes TEXT,
        mapa_rota BLOB,
        status_rota ENUM ('Ativa', 'Inativa', 'Em manutenção', 'Planejada') DEFAULT 'Ativa'
    );

CREATE TABLE
    trecho_rota_carga (
        id_trecho INT PRIMARY KEY AUTO_INCREMENT,
        rota_carga_id INT NOT NULL,
        sequencia INT NOT NULL,
        ponto_origem VARCHAR(255) NOT NULL,
        ponto_destino VARCHAR(255) NOT NULL,
        distancia_km DECIMAL(8, 2) NOT NULL,
        tempo_estimado_minutos INT NOT NULL,
        tipo_via ENUM ('Urbana', 'Rodovia', 'Estrada', 'Balsa', 'Outro') NOT NULL,
        condicao_via ENUM ('Ótima', 'Boa', 'Regular', 'Ruim', 'Péssima') DEFAULT 'Boa',
        pedagio BOOLEAN DEFAULT FALSE,
        valor_pedagio DECIMAL(6, 2),
        restricao_horario VARCHAR(100),
        observacoes TEXT,
        FOREIGN KEY (rota_carga_id) REFERENCES rota_carga (id_rota_carga),
        UNIQUE KEY (rota_carga_id, sequencia)
    );

CREATE TABLE
    operacao_carga (
        id_operacao INT PRIMARY KEY AUTO_INCREMENT,
        ordem_transporte_id INT NOT NULL,
        rota_carga_id INT,
        veiculo_id INT NOT NULL,
        motorista_id INT NOT NULL,
        ajudante_id INT,
        data_inicio DATETIME NOT NULL,
        data_fim DATETIME,
        km_inicial INT NOT NULL,
        km_final INT,
        status_operacao ENUM (
            'Planejada',
            'Em andamento',
            'Concluída',
            'Cancelada',
            'Com problema'
        ) DEFAULT 'Planejada',
        observacoes TEXT,
        custo_combustivel DECIMAL(10, 2),
        custo_pedagio DECIMAL(10, 2),
        custo_diaria DECIMAL(10, 2),
        outros_custos DECIMAL(10, 2),
        FOREIGN KEY (ordem_transporte_id) REFERENCES ordem_transporte (id_ordem),
        FOREIGN KEY (rota_carga_id) REFERENCES rota_carga (id_rota_carga),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista)
    );

CREATE TABLE
    ocorrencia_operacao (
        id_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
        operacao_id INT NOT NULL,
        tipo_ocorrencia ENUM (
            'Atraso',
            'Acidente',
            'Avaria',
            'Roubo',
            'Problema mecânico',
            'Retenção fiscal',
            'Bloqueio via',
            'Condição climática',
            'Outro'
        ) NOT NULL,
        data_hora DATETIME NOT NULL,
        localizacao VARCHAR(255),
        coordenada_latitude DECIMAL(10, 8),
        coordenada_longitude DECIMAL(11, 8),
        descricao TEXT NOT NULL,
        tempo_parada_minutos INT,
        responsavel VARCHAR(100),
        providencias_tomadas TEXT,
        status ENUM (
            'Registrada',
            'Em atendimento',
            'Resolvida',
            'Cancelada',
            'Pendente documentação'
        ) DEFAULT 'Registrada',
        fotos BLOB,
        FOREIGN KEY (operacao_id) REFERENCES operacao_carga (id_operacao)
    );