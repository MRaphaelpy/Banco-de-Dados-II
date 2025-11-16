CREATE TABLE
    linha_transporte (
        id_linha INT PRIMARY KEY AUTO_INCREMENT,
        codigo_linha VARCHAR(20) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        tipo_linha ENUM (
            'URBANA',
            'INTERMUNICIPAL',
            'INTERESTADUAL',
            'EXECUTIVA',
            'NOTURNA',
            'SELETIVA',
            'CIRCULAR'
        ) NOT NULL,
        origem VARCHAR(100) NOT NULL,
        destino VARCHAR(100) NOT NULL,
        extensao_km DECIMAL(8, 2),
        tempo_medio_minutos INT,
        intervalo_medio_minutos INT,
        empresa_operadora_id INT,
        status ENUM ('ATIVA', 'SUSPENSA', 'PLANEJADA', 'DESATIVADA') DEFAULT 'ATIVA',
        data_inicio_operacao DATE,
        data_fim_operacao DATE,
        observacoes TEXT
    );

CREATE TABLE
    rota (
        id_rota INT PRIMARY KEY AUTO_INCREMENT,
        linha_id INT NOT NULL,
        nome VARCHAR(100) NOT NULL,
        sentido ENUM ('IDA', 'VOLTA', 'CIRCULAR') NOT NULL,
        extensao_km DECIMAL(8, 2),
        tempo_estimado_minutos INT,
        horario_inicio_operacao TIME,
        horario_fim_operacao TIME,
        dias_operacao
        SET
            (
                'Segunda',
                'Terca',
                'Quarta',
                'Quinta',
                'Sexta',
                'Sabado',
                'Domingo',
                'Feriados'
            ),
            tipo_via_predominante ENUM ('URBANA', 'RURAL', 'RODOVIA', 'MISTA') DEFAULT 'URBANA',
            mapa_rota BLOB,
            arquivo_gpx TEXT,
            FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha)
    );

CREATE TABLE
    parada (
        id_parada INT PRIMARY KEY AUTO_INCREMENT,
        codigo_parada VARCHAR(20) UNIQUE NOT NULL,
        nome VARCHAR(100) NOT NULL,
        tipo_parada ENUM (
            'PONTO DE ONIBUS',
            'ESTACAO',
            'TERMINAL',
            'RODOVIARIA',
            'PARADA SOB DEMANDA'
        ) NOT NULL,
        endereco_id INT,
        coordenada_latitude DECIMAL(10, 8) NOT NULL,
        coordenada_longitude DECIMAL(11, 8) NOT NULL,
        coberta BOOLEAN DEFAULT FALSE,
        acessivel BOOLEAN DEFAULT FALSE,
        iluminacao BOOLEAN DEFAULT FALSE,
        bancos BOOLEAN DEFAULT FALSE,
        informacoes_horarios BOOLEAN DEFAULT FALSE,
        totem_eletronico BOOLEAN DEFAULT FALSE,
        wifi BOOLEAN DEFAULT FALSE,
        status ENUM ('ATIVA', 'MANUTENCAO', 'PLANEJADA', 'DESATIVADA') DEFAULT 'ATIVA',
        foto BLOB
    );

CREATE TABLE
    parada_rota (
        id_parada_rota INT PRIMARY KEY AUTO_INCREMENT,
        rota_id INT NOT NULL,
        parada_id INT NOT NULL,
        ordem_sequencial INT NOT NULL,
        tempo_ate_proxima_parada_minutos INT,
        distancia_ate_proxima_parada_km DECIMAL(5, 2),
        previsao_demanda ENUM ('BAIXA', 'MEDIA', 'ALTA', 'MUITO ALTA') DEFAULT 'MEDIA',
        horario_referencia TIME,
        embarque_permitido BOOLEAN DEFAULT TRUE,
        desembarque_permitido BOOLEAN DEFAULT TRUE,
        FOREIGN KEY (rota_id) REFERENCES rota (id_rota),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada),
        UNIQUE KEY (rota_id, parada_id, ordem_sequencial)
    );

CREATE TABLE
    horario (
        id_horario INT PRIMARY KEY AUTO_INCREMENT,
        rota_id INT NOT NULL,
        hora_partida TIME NOT NULL,
        hora_chegada TIME,
        dias_operacao
        SET
            (
                'Segunda',
                'Terca',
                'Quarta',
                'Quinta',
                'Sexta',
                'Sabado',
                'Domingo',
                'Feriados'
            ) NOT NULL,
            tipo_horario ENUM ('REGULAR', 'EXTRA', 'ESPECIAL', 'FERIADO') DEFAULT 'REGULAR',
            veiculos_necessarios INT DEFAULT 1,
            frequencia_minutos INT,
            periodo_vigencia_inicio DATE,
            periodo_vigencia_fim DATE,
            observacoes TEXT,
            FOREIGN KEY (rota_id) REFERENCES rota (id_rota)
    );

CREATE TABLE
    horario_parada (
        id_horario_parada INT PRIMARY KEY AUTO_INCREMENT,
        horario_id INT NOT NULL,
        parada_id INT NOT NULL,
        hora_prevista TIME NOT NULL,
        tolerancia_minutos INT DEFAULT 5,
        observacao VARCHAR(255),
        FOREIGN KEY (horario_id) REFERENCES horario (id_horario),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada)
    );

CREATE TABLE
    tarifa (
        id_tarifa INT PRIMARY KEY AUTO_INCREMENT,
        linha_id INT,
        valor DECIMAL(5, 2) NOT NULL,
        tipo_tarifa ENUM (
            'REGULAR',
            'ESTUDANTE',
            'IDOSO',
            'PCD',
            'INTEGRACAO',
            'EXECUTIVA',
            'PROMOCIONAL'
        ) NOT NULL,
        descricao VARCHAR(100),
        porcentagem_desconto DECIMAL(5, 2) DEFAULT 0.00,
        data_inicio_vigencia DATE NOT NULL,
        data_fim_vigencia DATE,
        horario_inicio TIME,
        horario_fim TIME,
        dias_aplicacao
        SET
            (
                'Segunda',
                'Terca',
                'Quarta',
                'Quinta',
                'Sexta',
                'Sabado',
                'Domingo',
                'Feriados'
            ),
            FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha)
    );

CREATE TABLE
    cartao_bilhetagem (
        id_cartao VARCHAR(50) PRIMARY KEY,
        passageiro_id INT,
        tipo_cartao ENUM (
            'COMUM',
            'ESTUDANTE',
            'IDOSO',
            'PCD',
            'VALE TRANSPORTE',
            'TURISTA'
        ) NOT NULL,
        data_emissao DATE NOT NULL,
        data_expiracao DATE,
        status ENUM (
            'ATIVO',
            'BLOQUEADO',
            'EXPIRADO',
            'PERDIDO',
            'CANCELADO'
        ) DEFAULT 'ATIVO',
        saldo DECIMAL(10, 2) DEFAULT 0.00,
        ultima_recarga DATETIME,
        ultima_utilizacao DATETIME,
        bloqueado BOOLEAN DEFAULT FALSE,
        motivo_bloqueio VARCHAR(255),
        FOREIGN KEY (passageiro_id) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    recarga (
        id_recarga INT PRIMARY KEY AUTO_INCREMENT,
        cartao_id VARCHAR(50) NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        data_hora_recarga DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        tipo_pagamento ENUM (
            'DINHEIRO',
            'CREDITO',
            'DEBITO',
            'PIX',
            'BOLETO',
            'APP',
            'DESCONTO EM FOLHA'
        ) NOT NULL,
        local_recarga ENUM (
            'TERMINAL',
            'POSTO AUTORIZADO',
            'APP',
            'WEBSITE',
            'ATM',
            'EMPRESA'
        ) NOT NULL,
        operador_id INT,
        comprovante VARCHAR(50),
        status ENUM ('COMPLETA', 'PENDENTE', 'CANCELADA', 'ESTORNADA') DEFAULT 'COMPLETA',
        observacoes TEXT,
        FOREIGN KEY (cartao_id) REFERENCES cartao_bilhetagem (id_cartao)
    );

CREATE TABLE
    utilizacao_cartao (
        id_utilizacao INT PRIMARY KEY AUTO_INCREMENT,
        cartao_id VARCHAR(50) NOT NULL,
        data_hora_utilizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        valor_cobrado DECIMAL(5, 2) NOT NULL,
        tipo_utilizacao ENUM (
            'EMBARQUE',
            'INTEGRACAO',
            'ACESSO ESTACAO',
            'SAIDA ESTACAO',
            'INSPECAO'
        ) NOT NULL,
        linha_id INT,
        veiculo_id INT,
        parada_id INT,
        terminal_id INT,
        validador_id VARCHAR(50),
        integracao_com_id INT,
        tempo_integracao_minutos INT,
        saldo_restante DECIMAL(10, 2),
        FOREIGN KEY (cartao_id) REFERENCES cartao_bilhetagem (id_cartao),
        FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada)
    );

CREATE TABLE
    validador (
        id_validador VARCHAR(50) PRIMARY KEY,
        numero_serie VARCHAR(50) NOT NULL,
        modelo VARCHAR(50),
        fabricante VARCHAR(50),
        firmware_versao VARCHAR(20),
        data_instalacao DATE,
        status ENUM ('ATIVO', 'MANUTENCAO', 'DESATIVADO', 'DEFEITUOSO') DEFAULT 'ATIVO',
        veiculo_id INT,
        parada_id INT,
        terminal_id INT,
        ultima_sincronizacao DATETIME,
        observacoes TEXT,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada)
    );

CREATE TABLE
    escala (
        id_escala INT PRIMARY KEY AUTO_INCREMENT,
        data_escala DATE NOT NULL,
        horario_id INT,
        veiculo_id INT,
        motorista_id INT,
        cobrador_id INT,
        status ENUM (
            'PROGRAMADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'CANCELADA',
            'MODIFICADA'
        ) DEFAULT 'PROGRAMADA',
        hora_inicio_prevista TIME NOT NULL,
        hora_fim_prevista TIME NOT NULL,
        hora_inicio_real TIME,
        hora_fim_real TIME,
        observacoes TEXT,
        FOREIGN KEY (horario_id) REFERENCES horario (id_horario),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista),
        FOREIGN KEY (cobrador_id) REFERENCES cobrador (id_cobrador)
    );

CREATE TABLE
    viagem (
        id_viagem INT PRIMARY KEY AUTO_INCREMENT,
        escala_id INT,
        rota_id INT NOT NULL,
        veiculo_id INT NOT NULL,
        motorista_id INT NOT NULL,
        cobrador_id INT,
        data_viagem DATE NOT NULL,
        hora_partida_prevista TIME NOT NULL,
        hora_chegada_prevista TIME NOT NULL,
        hora_partida_real TIME,
        hora_chegada_real TIME,
        km_inicial INT,
        km_final INT,
        status_viagem ENUM (
            'PROGRAMADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'CANCELADA',
            'ATRASADA',
            'INTERROMPIDA'
        ) DEFAULT 'PROGRAMADA',
        total_passageiros INT,
        ocupacao_maxima INT,
        observacoes TEXT,
        FOREIGN KEY (escala_id) REFERENCES escala (id_escala),
        FOREIGN KEY (rota_id) REFERENCES rota (id_rota),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista),
        FOREIGN KEY (cobrador_id) REFERENCES cobrador (id_cobrador)
    );

CREATE TABLE
    ponto_viagem (
        id_ponto_viagem INT PRIMARY KEY AUTO_INCREMENT,
        viagem_id INT NOT NULL,
        parada_id INT NOT NULL,
        sequencia INT NOT NULL,
        horario_previsto TIME NOT NULL,
        horario_real TIME,
        atraso_minutos INT DEFAULT 0,
        passageiros_embarcados INT DEFAULT 0,
        passageiros_desembarcados INT DEFAULT 0,
        motivo_atraso VARCHAR(255),
        ocupacao_momento INT,
        status ENUM (
            'NAO REALIZADA',
            'REALIZADA',
            'ATRASADA',
            'CANCELADA',
            'NAO INFORMADA'
        ) DEFAULT 'NAO REALIZADA',
        FOREIGN KEY (viagem_id) REFERENCES viagem (id_viagem),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada),
        UNIQUE KEY (viagem_id, parada_id, sequencia)
    );

CREATE TABLE
    controle_ocupacao (
        id_ocupacao INT PRIMARY KEY AUTO_INCREMENT,
        viagem_id INT NOT NULL,
        data_hora DATETIME NOT NULL,
        parada_id INT,
        localizacao_latitude DECIMAL(10, 8),
        localizacao_longitude DECIMAL(11, 8),
        passageiros_atual INT NOT NULL,
        capacidade_total INT NOT NULL,
        percentual_ocupacao DECIMAL(5, 2) GENERATED ALWAYS AS (passageiros_atual * 100.0 / capacidade_total) STORED,
        status_lotacao ENUM ('VAZIO', 'BAIXA', 'MEDIA', 'ALTA', 'LOTADO') NOT NULL,
        em_pico BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (viagem_id) REFERENCES viagem (id_viagem),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada)
    );

CREATE TABLE
    empresa_operadora (
        id_empresa INT PRIMARY KEY AUTO_INCREMENT,
        razao_social VARCHAR(100) NOT NULL,
        nome_fantasia VARCHAR(100),
        cnpj VARCHAR(18) NOT NULL UNIQUE,
        inscricao_estadual VARCHAR(20),
        endereco_id INT,
        responsavel_nome VARCHAR(100),
        responsavel_contato VARCHAR(50),
        email VARCHAR(100),
        telefone VARCHAR(15),
        site VARCHAR(100),
        data_inicio_operacao DATE,
        status ENUM ('ATIVA', 'SUSPENSA', 'INATIVA', 'EM ANALISE') DEFAULT 'ATIVA',
        areas_atuacao TEXT,
        observacoes TEXT
    );

CREATE TABLE
    consorcio (
        id_consorcio INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        data_inicio DATE NOT NULL,
        data_fim DATE,
        status ENUM ('ATIVO', 'ENCERRADO', 'SUSPENSO', 'EM FORMACAO') DEFAULT 'ATIVO',
        representante_nome VARCHAR(100),
        representante_contato VARCHAR(50),
        area_geografica_atuacao TEXT
    );

CREATE TABLE
    empresa_consorcio (
        id_empresa_consorcio INT PRIMARY KEY AUTO_INCREMENT,
        empresa_id INT NOT NULL,
        consorcio_id INT NOT NULL,
        data_entrada DATE NOT NULL,
        data_saida DATE,
        participacao_percentual DECIMAL(5, 2),
        status ENUM ('Ativa', 'Desligada', 'Suspensa') DEFAULT 'Ativa',
        observacoes TEXT,
        FOREIGN KEY (empresa_id) REFERENCES empresa_operadora (id_empresa),
        FOREIGN KEY (consorcio_id) REFERENCES consorcio (id_consorcio),
        UNIQUE KEY (empresa_id, consorcio_id)
    );