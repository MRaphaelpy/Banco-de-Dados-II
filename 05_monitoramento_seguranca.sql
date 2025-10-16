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
        status ENUM ('Ativo', 'Inativo', 'Manutenção', 'Desconectado') DEFAULT 'Ativo',
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
            'Partida',
            'Parada',
            'Excesso velocidade',
            'Desvio rota',
            'Botão pânico',
            'Cerca eletrônica',
            'Desconexão',
            'Falha técnica',
            'Jammer detectado',
            'Bateria baixa',
            'Parada não programada'
        ) NOT NULL,
        veiculo_gps_id INT NOT NULL,
        data_hora DATETIME NOT NULL,
        latitude DECIMAL(10, 8) NOT NULL,
        longitude DECIMAL(11, 8) NOT NULL,
        velocidade DECIMAL(6, 2),
        descricao VARCHAR(255),
        criticidade ENUM ('Baixa', 'Média', 'Alta', 'Crítica') NOT NULL,
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
            'Circular',
            'Poligonal',
            'Corredor',
            'Ponto de interesse'
        ) NOT NULL,
        raio_metros INT,
        coordenadas TEXT,
        referencia VARCHAR(255),
        tipo_alerta ENUM ('Entrada', 'Saída', 'Ambos') DEFAULT 'Ambos',
        status ENUM ('Ativa', 'Inativa', 'Temporária', 'Programada') DEFAULT 'Ativa',
        data_inicio_vigencia DATETIME,
        data_fim_vigencia DATETIME,
        horario_inicio_vigencia TIME,
        horario_fim_vigencia TIME,
        dias_semana
        SET
            (
                'Segunda',
                'Terça',
                'Quarta',
                'Quinta',
                'Sexta',
                'Sábado',
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
            'Analógica',
            'HD-SDI',
            'HD-TVI',
            'Térmica',
            '360°',
            'PTZ'
        ) NOT NULL,
        resolucao VARCHAR(20),
        fabricante VARCHAR(50),
        modelo VARCHAR(50),
        data_instalacao DATE,
        status ENUM ('Ativa', 'Manutenção', 'Desativada', 'Defeituosa') DEFAULT 'Ativa',
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
            'Automático',
            'Manual',
            'Evento',
            'Agendado',
            'Detecção movimento'
        ) DEFAULT 'Automático',
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
            'Assalto',
            'Agressão',
            'Acidente',
            'Vandalismo',
            'Invasão',
            'Tumulto',
            'Furto',
            'Arma branca',
            'Arma de fogo',
            'Ameaça',
            'Outros'
        ) NOT NULL,
        data_hora DATETIME NOT NULL,
        veiculo_id INT,
        parada_id INT,
        terminal_id INT,
        funcionario_id INT,
        linha_id INT,
        descricao TEXT NOT NULL,
        gravidade ENUM ('Baixa', 'Média', 'Alta', 'Crítica') NOT NULL,
        status ENUM (
            'Registrado',
            'Em investigação',
            'Encaminhado autoridades',
            'Solucionado',
            'Arquivado'
        ) DEFAULT 'Registrado',
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
            'Falha mecânica',
            'Acidente',
            'Vandalismo',
            'Limpeza',
            'Comportamento inadequado',
            'Excesso velocidade',
            'Frenagem brusca',
            'Desvio rota',
            'Lotação excessiva',
            'Reclamação passageiro'
        ) NOT NULL,
        localizacao_latitude DECIMAL(10, 8),
        localizacao_longitude DECIMAL(11, 8),
        descricao TEXT NOT NULL,
        gravidade ENUM ('Baixa', 'Média', 'Alta', 'Crítica') NOT NULL,
        status ENUM (
            'Registrada',
            'Em análise',
            'Em manutenção',
            'Resolvida',
            'Cancelada'
        ) DEFAULT 'Registrada',
        acao_tomada TEXT,
        tempo_resolucao_minutos INT,
        valor_prejuizo DECIMAL(10, 2),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista)
    );