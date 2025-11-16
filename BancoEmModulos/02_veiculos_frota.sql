CREATE TABLE
    veiculo (
        id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
        placa VARCHAR(8) UNIQUE NOT NULL,
        renavam VARCHAR(11),
        chassi VARCHAR(17) UNIQUE NOT NULL,
        modelo_id INT NOT NULL,
        ano_fabricacao INT NOT NULL,
        ano_modelo INT NOT NULL,
        capacidade_passageiros INT,
        capacidade_carga_kg DECIMAL(10, 2),
        tipo_combustivel ENUM (
            'DIESEL',
            'GASOLINA',
            'ETANOL',
            'FLEX',
            'ELETRICO',
            'HIBRIDO',
            'GNV'
        ) NOT NULL,
        consumo_medio DECIMAL(5, 2),
        status_operacional ENUM ('ATIVO', 'EM MANUTENCAO', 'RESERVA', 'DESATIVADO') DEFAULT 'ATIVO',
        data_aquisicao DATE,
        quilometragem_atual INT DEFAULT 0,
        garagem_id INT
    );

CREATE TABLE
    modelo_veiculo (
        id_modelo INT PRIMARY KEY AUTO_INCREMENT,
        marca VARCHAR(50) NOT NULL,
        nome_modelo VARCHAR(50) NOT NULL,
        categoria ENUM (
            'ONIBUS URBANO',
            'ONIBUS RODOVIARIO',
            'MICROONIBUS',
            'VAN',
            'CAMINHAO',
            'TREM',
            'VLT',
            'METRO'
        ) NOT NULL,
        comprimento_metros DECIMAL(5, 2),
        altura_metros DECIMAL(4, 2),
        largura_metros DECIMAL(4, 2),
        peso_kg DECIMAL(8, 2),
        configuracao_assentos VARCHAR(50),
        acessibilidade BOOLEAN DEFAULT FALSE,
        ar_condicionado BOOLEAN DEFAULT FALSE
    );

CREATE TABLE
    garagem (
        id_garagem INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        endereco_id INT,
        capacidade_veiculos INT NOT NULL,
        tipo_garagem ENUM ('URBANA', 'RODOVIARIA', 'FERROVIARIA', 'MISTA') NOT NULL,
        possui_oficina BOOLEAN DEFAULT FALSE,
        possui_abastecimento BOOLEAN DEFAULT FALSE,
        horario_funcionamento VARCHAR(100),
        telefone VARCHAR(15),
        responsavel_id INT
    );

CREATE TABLE
    manutencao (
        id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT NOT NULL,
        tipo_manutencao ENUM ('PREVENTIVA', 'CORRETIVA', 'REVISAO', 'INSPECAO') NOT NULL,
        data_inicio DATETIME NOT NULL,
        data_fim DATETIME,
        quilometragem_veiculo INT NOT NULL,
        descricao TEXT NOT NULL,
        status ENUM (
            'AGENDADA',
            'EM EXECUCAO',
            'CONCLUIDA',
            'CANCELADA'
        ) DEFAULT 'AGENDADA',
        oficina_id INT,
        custo_total DECIMAL(10, 2),
        responsavel_tecnico VARCHAR(100),
        observacoes TEXT,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo)
    );

CREATE TABLE
    item_manutencao (
        id_item INT PRIMARY KEY AUTO_INCREMENT,
        manutencao_id INT NOT NULL,
        peca_id INT,
        servico_id INT,
        quantidade INT NOT NULL DEFAULT 1,
        valor_unitario DECIMAL(10, 2) NOT NULL,
        valor_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantidade * valor_unitario) STORED,
        garantia_dias INT,
        data_garantia_fim DATE,
        FOREIGN KEY (manutencao_id) REFERENCES manutencao (id_manutencao)
    );

CREATE TABLE
    peca (
        id_peca INT PRIMARY KEY AUTO_INCREMENT,
        codigo_peca VARCHAR(50) NOT NULL,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        fabricante VARCHAR(100),
        modelo_compativel VARCHAR(100),
        categoria_peca VARCHAR(50),
        unidade_medida ENUM (
            'UNIDADE',
            'PAR',
            'CONJUNTO',
            'LITRO',
            'METRO',
            'KG'
        ) DEFAULT 'UNIDADE',
        valor_medio DECIMAL(10, 2),
        foto BLOB,
        observacoes TEXT
    );

CREATE TABLE
    estoque_peca (
        id_estoque INT PRIMARY KEY AUTO_INCREMENT,
        peca_id INT NOT NULL,
        quantidade_atual INT NOT NULL DEFAULT 0,
        quantidade_minima INT DEFAULT 1,
        quantidade_maxima INT,
        localizacao_estoque VARCHAR(50),
        garagem_id INT,
        data_ultima_entrada DATE,
        data_ultima_saida DATE,
        valor_medio_compra DECIMAL(10, 2),
        FOREIGN KEY (peca_id) REFERENCES peca (id_peca),
        FOREIGN KEY (garagem_id) REFERENCES garagem (id_garagem)
    );

CREATE TABLE
    movimentacao_estoque (
        id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
        peca_id INT NOT NULL,
        tipo_movimentacao ENUM ('ENTRADA', 'SAIDA', 'AJUSTE', 'TRANSFERENCIA') NOT NULL,
        quantidade INT NOT NULL,
        data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        responsavel_id INT,
        manutencao_id INT,
        garagem_origem_id INT,
        garagem_destino_id INT,
        valor_unitario DECIMAL(10, 2),
        motivo TEXT,
        FOREIGN KEY (peca_id) REFERENCES peca (id_peca),
        FOREIGN KEY (manutencao_id) REFERENCES manutencao (id_manutencao),
        FOREIGN KEY (garagem_origem_id) REFERENCES garagem (id_garagem),
        FOREIGN KEY (garagem_destino_id) REFERENCES garagem (id_garagem)
    );

CREATE TABLE
    servico_manutencao (
        id_servico INT PRIMARY KEY AUTO_INCREMENT,
        nome_servico VARCHAR(100) NOT NULL,
        descricao TEXT,
        tempo_estimado_minutos INT,
        valor_padrao DECIMAL(10, 2),
        categoria_servico VARCHAR(50),
        requer_especialista BOOLEAN DEFAULT FALSE,
        instrucoes_execucao TEXT
    );

CREATE TABLE
    abastecimento (
        id_abastecimento INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT NOT NULL,
        data_abastecimento DATETIME NOT NULL,
        tipo_combustivel ENUM (
            'DIESEL',
            'GASOLINA',
            'ETANOL',
            'GNV',
            'ELETRICIDADE'
        ) NOT NULL,
        quantidade DECIMAL(10, 2) NOT NULL,
        valor_unitario DECIMAL(5, 2) NOT NULL,
        valor_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantidade * valor_unitario) STORED,
        quilometragem_veiculo INT NOT NULL,
        posto_id INT,
        responsavel_id INT,
        forma_pagamento VARCHAR(50),
        nota_fiscal VARCHAR(50),
        tanque_completo BOOLEAN DEFAULT TRUE,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo)
    );

CREATE TABLE
    posto_abastecimento (
        id_posto INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        endereco_id INT,
        cnpj VARCHAR(18),
        tipo_posto ENUM ('INTERNO', 'CONVENIADO', 'PUBLICO') NOT NULL,
        contato_nome VARCHAR(100),
        contato_telefone VARCHAR(15),
        combustiveis_disponiveis
        SET
            (
                'Diesel',
                'Gasolina',
                'Etanol',
                'GNV',
                'Eletricidade'
            ),
            horario_funcionamento VARCHAR(100),
            convenio_ativo BOOLEAN DEFAULT TRUE,
            data_inicio_convenio DATE,
            data_fim_convenio DATE
    );

CREATE TABLE
    pneu (
        id_pneu INT PRIMARY KEY AUTO_INCREMENT,
        codigo_barras VARCHAR(50) UNIQUE,
        marca VARCHAR(50) NOT NULL,
        modelo VARCHAR(50) NOT NULL,
        dimensao VARCHAR(20) NOT NULL,
        tipo ENUM ('RADIAL', 'DIAGONAL', 'SEM CAMARA', 'COM CAMARA') NOT NULL,
        data_fabricacao DATE,
        data_compra DATE,
        valor_compra DECIMAL(10, 2),
        fornecedor_id INT,
        vida_util_estimada_km INT,
        garantia_km INT,
        observacoes TEXT
    );

CREATE TABLE
    posicao_pneu (
        id_posicao_pneu INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT NOT NULL,
        pneu_id INT NOT NULL,
        posicao VARCHAR(20) NOT NULL,
        data_instalacao DATETIME NOT NULL,
        quilometragem_instalacao INT NOT NULL,
        data_remocao DATETIME,
        quilometragem_remocao INT,
        motivo_remocao VARCHAR(100),
        profundidade_sulco_instalacao DECIMAL(4, 2),
        profundidade_sulco_remocao DECIMAL(4, 2),
        ativo BOOLEAN DEFAULT TRUE,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (pneu_id) REFERENCES pneu (id_pneu)
    );

CREATE TABLE
    historico_calibragem (
        id_calibragem INT PRIMARY KEY AUTO_INCREMENT,
        posicao_pneu_id INT NOT NULL,
        data_calibragem DATETIME NOT NULL,
        pressao_psi DECIMAL(5, 2) NOT NULL,
        temperatura_pneu_celsius DECIMAL(5, 2),
        responsavel_id INT,
        observacoes TEXT,
        FOREIGN KEY (posicao_pneu_id) REFERENCES posicao_pneu (id_posicao_pneu)
    );