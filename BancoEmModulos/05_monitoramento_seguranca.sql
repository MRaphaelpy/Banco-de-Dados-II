CREATE TABLE
    veiculo_gps (
        id_veiculo_gps INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT NOT NULL UNIQUE,
        dispositivo_id VARCHAR(50) NOT NULL,
        modelo_dispositivo VARCHAR(50),
        chip_numero VARCHAR(20),
        operadora VARCHAR(30),
        data_instalacao DATE,
        intervalo_transmissao_segundos INT DEFAULT 30,
        status ENUM ('ATIVO', 'INATIVO', 'MANUTENCAO', 'DESCONECTADO') DEFAULT 'ATIVO',
        ultima_manutencao DATE,
        observacoes TEXT,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo)
    );

CREATE TABLE
    rastreamento_gps (
        id_rastreamento BIGINT PRIMARY KEY AUTO_INCREMENT,
        veiculo_gps_id INT NOT NULL,
        data_hora DATETIME NOT NULL,
        latitude DECIMAL(10, 8) NOT NULL,
        longitude DECIMAL(11, 8) NOT NULL,
        altitude DECIMAL(8, 2),
        velocidade DECIMAL(6, 2),
        direcao INT,
        ignicao_ligada BOOLEAN,
        hodometro DECIMAL(10, 2),
        nivel_combustivel DECIMAL(5, 2),
        temperatura_motor DECIMAL(5, 2),
        parado_tempo_segundos INT,
        sinal_gsm INT,
        precisao_metros DECIMAL(5, 2),
        satelites INT,
        evento_id INT,
        FOREIGN KEY (veiculo_gps_id) REFERENCES veiculo_gps (id_veiculo_gps),
        INDEX idx_veiculo_data (veiculo_gps_id, data_hora)
    );

CREATE TABLE
    evento_gps (
        id_evento INT PRIMARY KEY AUTO_INCREMENT,
        tipo_evento ENUM (
            'PARTIDA',
            'PARADA',
            'EXCESSO VELOCIDADE',
            'DESVIO ROTA',
            'BOTAO PANICO',
            'CERCA ELETRONICA',
            'DESCONEXAO',
            'FALHA TECNICA',
            'JAMMER DETECTADO',
            'BATERIA BAIXA',
            'PARADA NAO PROGRAMADA'
        ) NOT NULL,
        veiculo_gps_id INT NOT NULL,
        data_hora DATETIME NOT NULL,
        latitude DECIMAL(10, 8) NOT NULL,
        longitude DECIMAL(11, 8) NOT NULL,
        velocidade DECIMAL(6, 2),
        descricao VARCHAR(255),
        criticidade ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') NOT NULL,
        resolvido BOOLEAN DEFAULT FALSE,
        resolucao_data_hora DATETIME,
        resolucao_descricao TEXT,
        operador_id INT,
        FOREIGN KEY (veiculo_gps_id) REFERENCES veiculo_gps (id_veiculo_gps)
    );

CREATE TABLE
    cerca_eletronica (
        id_cerca INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        tipo_cerca ENUM (
            'CIRCULAR',
            'POLIGONAL',
            'CORREDOR',
            'PONTO DE INTERESSE'
        ) NOT NULL,
        raio_metros INT,
        coordenadas TEXT,
        referencia VARCHAR(255),
        tipo_alerta ENUM ('ENTRADA', 'SAIDA', 'AMBOS') DEFAULT 'AMBOS',
        status ENUM ('ATIVA', 'INATIVA', 'TEMPORARIA', 'PROGRAMADA') DEFAULT 'ATIVA',
        data_inicio_vigencia DATETIME,
        data_fim_vigencia DATETIME,
        horario_inicio_vigencia TIME,
        horario_fim_vigencia TIME,
        dias_semana
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
            observacoes TEXT
    );

CREATE TABLE
    veiculo_cerca (
        id_veiculo_cerca INT PRIMARY KEY AUTO_INCREMENT,
        cerca_id INT NOT NULL,
        veiculo_id INT NOT NULL,
        FOREIGN KEY (cerca_id) REFERENCES cerca_eletronica (id_cerca),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        UNIQUE KEY (cerca_id, veiculo_id)
    );

CREATE TABLE
    camera (
        id_camera INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT,
        parada_id INT,
        terminal_id INT,
        codigo VARCHAR(50) NOT NULL UNIQUE,
        posicao VARCHAR(50),
        tipo ENUM (
            'IP',
            'ANALOGICA',
            'HD-SDI',
            'HD-TVI',
            'TERMICA',
            '360°',
            'PTZ'
        ) NOT NULL,
        resolucao VARCHAR(20),
        fabricante VARCHAR(50),
        modelo VARCHAR(50),
        data_instalacao DATE,
        status ENUM ('ATIVA', 'MANUTENCAO', 'DESATIVADA', 'DEFEITUOSA') DEFAULT 'ATIVA',
        armazenamento_dias INT DEFAULT 30,
        angulo_cobertura INT,
        visao_noturna BOOLEAN DEFAULT FALSE,
        deteccao_movimento BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada)
    );

CREATE TABLE
    gravacao (
        id_gravacao INT PRIMARY KEY AUTO_INCREMENT,
        camera_id INT NOT NULL,
        data_hora_inicio DATETIME NOT NULL,
        data_hora_fim DATETIME,
        duracao_segundos INT,
        tamanho_mb DECIMAL(10, 2),
        caminho_arquivo VARCHAR(255),
        gatilho ENUM (
            'AUTOMATICO',
            'MANUAL',
            'EVENTO',
            'AGENDADO',
            'DETECCAO MOVIMENTO'
        ) DEFAULT 'AUTOMATICO',
        evento_relacionado_id INT,
        retencao_dias INT DEFAULT 30,
        hash_arquivo VARCHAR(128),
        marcada_relevante BOOLEAN DEFAULT FALSE,
        motivo_relevancia TEXT,
        FOREIGN KEY (camera_id) REFERENCES camera (id_camera)
    );

CREATE TABLE
    incidente_seguranca (
        id_incidente INT PRIMARY KEY AUTO_INCREMENT,
        tipo_incidente ENUM (
            'ASSALTO',
            'AGRESSAO',
            'ACIDENTE',
            'VANDALISMO',
            'INVASAO',
            'TUMULTO',
            'FURTO',
            'ARMA BRANCA',
            'ARMA DE FOGO',
            'AMEACA',
            'OUTROS'
        ) NOT NULL,
        data_hora DATETIME NOT NULL,
        veiculo_id INT,
        parada_id INT,
        terminal_id INT,
        funcionario_id INT,
        linha_id INT,
        descricao TEXT NOT NULL,
        gravidade ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') NOT NULL,
        status ENUM (
            'REGISTRADO',
            'EM INVESTIGACAO',
            'ENCAMINHADO AUTORIDADES',
            'SOLUCIONADO',
            'ARQUIVADO'
        ) DEFAULT 'REGISTRADO',
        bo_registrado BOOLEAN DEFAULT FALSE,
        numero_bo VARCHAR(50),
        relatorio_interno BOOLEAN DEFAULT FALSE,
        testemunhas TEXT,
        observacoes TEXT,
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (parada_id) REFERENCES parada (id_parada),
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario),
        FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha)
    );

CREATE TABLE
    ocorrencia_veiculo (
        id_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
        veiculo_id INT NOT NULL,
        motorista_id INT,
        data_hora DATETIME NOT NULL,
        tipo_ocorrencia ENUM (
            'FALHA MECANICA',
            'ACIDENTE',
            'VANDALISMO',
            'LIMPEZA',
            'COMPORTAMENTO INADEQUADO',
            'EXCESSO VELOCIDADE',
            'FRENAGEM BRUSCA',
            'DESVIO ROTA',
            'LOTACAO EXCESSIVA',
            'RECLAMACAO PASSAGEIRO'
        ) NOT NULL,
        localizacao_latitude DECIMAL(10, 8),
        localizacao_longitude DECIMAL(11, 8),
        descricao TEXT NOT NULL,
        gravidade ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') NOT NULL,
        status ENUM (
            'REGISTRADA',
            'EM ANALISE',
            'EM MANUTENCAO',
            'RESOLVIDA',
            'CANCELADA'
        ) DEFAULT 'REGISTRADA',
        acao_tomada TEXT,
        tempo_resolucao_minutos INT,
        valor_prejuizo DECIMAL(10, 2),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista)
    );