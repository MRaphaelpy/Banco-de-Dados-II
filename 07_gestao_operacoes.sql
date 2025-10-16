CREATE TABLE
    terminal (
        id_terminal INT PRIMARY KEY AUTO_INCREMENT,
        codigo VARCHAR(20) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        tipo_terminal ENUM (
            'Urbano',
            'Metropolitano',
            'Rodoviário',
            'Ferroviário',
            'Multimodal',
            'Estação',
            'Aeroporto',
            'Porto'
        ) NOT NULL,
        endereco_id INT,
        capacidade_veiculos INT,
        capacidade_passageiros INT,
        area_total_m2 DECIMAL(10, 2),
        horario_funcionamento_inicio TIME,
        horario_funcionamento_fim TIME,
        qtde_plataformas INT,
        qtde_bilheterias INT,
        qtde_sanitarios INT,
        acessibilidade BOOLEAN DEFAULT TRUE,
        wifi BOOLEAN DEFAULT FALSE,
        estacionamento BOOLEAN DEFAULT FALSE,
        praça_alimentação BOOLEAN DEFAULT FALSE,
        latitude DECIMAL(10, 8),
        longitude DECIMAL(11, 8),
        observacoes TEXT
    );

CREATE TABLE
    integracao_modal (
        id_integracao INT PRIMARY KEY AUTO_INCREMENT,
        terminal_id INT NOT NULL,
        modal_principal ENUM (
            'Ônibus Urbano',
            'Ônibus Intermunicipal',
            'Trem',
            'Metrô',
            'VLT',
            'Balsa',
            'Bicicleta',
            'Aeroporto'
        ) NOT NULL,
        modal_integrado ENUM (
            'Ônibus Urbano',
            'Ônibus Intermunicipal',
            'Trem',
            'Metrô',
            'VLT',
            'Balsa',
            'Bicicleta',
            'Aeroporto'
        ) NOT NULL,
        tempo_integracao_minutos INT NOT NULL,
        distancia_integracao_metros INT,
        gratuidade BOOLEAN DEFAULT FALSE,
        desconto_percentual DECIMAL(5, 2),
        horario_inicio TIME,
        horario_fim TIME,
        dias_funcionamento
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
            ) NOT NULL,
            observacoes TEXT,
            FOREIGN KEY (terminal_id) REFERENCES terminal (id_terminal)
    );

CREATE TABLE
    area_aluguel_terminal (
        id_area INT PRIMARY KEY AUTO_INCREMENT,
        terminal_id INT NOT NULL,
        identificacao VARCHAR(50) NOT NULL,
        tipo_area ENUM (
            'Loja',
            'Quiosque',
            'Guichê',
            'Bilheteria',
            'Espaço comercial',
            'Publicidade',
            'Praça alimentação'
        ) NOT NULL,
        area_m2 DECIMAL(8, 2) NOT NULL,
        valor_aluguel DECIMAL(10, 2) NOT NULL,
        ocupado BOOLEAN DEFAULT FALSE,
        locatario_atual VARCHAR(100),
        cnpj_locatario VARCHAR(18),
        inicio_contrato DATE,
        fim_contrato DATE,
        valor_condominio DECIMAL(10, 2),
        observacoes TEXT,
        FOREIGN KEY (terminal_id) REFERENCES terminal (id_terminal)
    );

CREATE TABLE
    guia_turistico (
        id_guia INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        registro_embratur VARCHAR(20) UNIQUE,
        cpf VARCHAR(14) UNIQUE NOT NULL,
        telefone VARCHAR(15) NOT NULL,
        email VARCHAR(100),
        idiomas
        SET
            (
                'Português',
                'Inglês',
                'Espanhol',
                'Francês',
                'Alemão',
                'Italiano',
                'Mandarim',
                'Japonês'
            ) NOT NULL,
            especializacao
        SET
            (
                'Cultural',
                'Ecoturismo',
                'Aventura',
                'Histórico',
                'Religioso',
                'Gastronômico'
            ) NOT NULL,
            disponibilidade
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
            ) NOT NULL,
            valor_hora DECIMAL(8, 2),
            status ENUM ('Ativo', 'Inativo', 'Suspenso', 'Em viagem') DEFAULT 'Ativo',
            observacoes TEXT
    );

CREATE TABLE
    roteiro_turistico (
        id_roteiro INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        duracao_horas DECIMAL(4, 1) NOT NULL,
        preco_adulto DECIMAL(8, 2) NOT NULL,
        preco_crianca DECIMAL(8, 2),
        preco_idoso DECIMAL(8, 2),
        pontos_visitados TEXT NOT NULL,
        nivel_dificuldade ENUM ('Fácil', 'Moderado', 'Difícil', 'Muito difícil') DEFAULT 'Moderado',
        acessibilidade BOOLEAN DEFAULT FALSE,
        tipo_roteiro
        SET
            (
                'Cultural',
                'Ecoturismo',
                'Aventura',
                'Histórico',
                'Religioso',
                'Gastronômico',
                'Compras'
            ) NOT NULL,
            dias_disponivel
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
            ) NOT NULL,
            horario_inicio TIME,
            horario_fim TIME,
            foto_capa BLOB,
            status ENUM ('Ativo', 'Inativo', 'Sazonal', 'Temporário') DEFAULT 'Ativo'
    );

CREATE TABLE
    excursao (
        id_excursao INT PRIMARY KEY AUTO_INCREMENT,
        roteiro_id INT NOT NULL,
        data_saida DATE NOT NULL,
        hora_saida TIME NOT NULL,
        data_retorno DATE NOT NULL,
        hora_retorno TIME NOT NULL,
        veiculo_id INT NOT NULL,
        motorista_id INT NOT NULL,
        guia_id INT,
        vagas_totais INT NOT NULL,
        vagas_disponiveis INT NOT NULL,
        preco DECIMAL(8, 2) NOT NULL,
        status ENUM (
            'Agendada',
            'Confirmada',
            'Em andamento',
            'Concluída',
            'Cancelada'
        ) DEFAULT 'Agendada',
        local_saida VARCHAR(255) NOT NULL,
        local_retorno VARCHAR(255) NOT NULL,
        observacoes TEXT,
        FOREIGN KEY (roteiro_id) REFERENCES roteiro_turistico (id_roteiro),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista),
        FOREIGN KEY (guia_id) REFERENCES guia_turistico (id_guia)
    );

CREATE TABLE
    participante_excursao (
        id_participante INT PRIMARY KEY AUTO_INCREMENT,
        excursao_id INT NOT NULL,
        passageiro_id INT,
        nome VARCHAR(100) NOT NULL,
        documento VARCHAR(20) NOT NULL,
        telefone VARCHAR(15),
        email VARCHAR(100),
        tipo_passageiro ENUM ('Adulto', 'Criança', 'Idoso', 'PCD') NOT NULL,
        valor_pago DECIMAL(8, 2) NOT NULL,
        forma_pagamento ENUM (
            'Dinheiro',
            'Crédito',
            'Débito',
            'PIX',
            'Boleto',
            'Transferência'
        ) NOT NULL,
        assento_reservado VARCHAR(10),
        check_in BOOLEAN DEFAULT FALSE,
        necessidades_especiais TEXT,
        observacoes TEXT,
        FOREIGN KEY (excursao_id) REFERENCES excursao (id_excursao),
        FOREIGN KEY (passageiro_id) REFERENCES passageiro (id_passageiro)
    );

CREATE TABLE
    ponto_turistico (
        id_ponto INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        tipo_atracao ENUM (
            'Natural',
            'Histórico',
            'Cultural',
            'Religioso',
            'Arquitetônico',
            'Lazer',
            'Comercial',
            'Gastronômico'
        ) NOT NULL,
        endereco_id INT,
        descricao TEXT NOT NULL,
        horario_funcionamento TEXT,
        preco_entrada DECIMAL(8, 2),
        entrada_gratuita BOOLEAN DEFAULT FALSE,
        tempo_medio_visita_minutos INT,
        acessibilidade BOOLEAN DEFAULT FALSE,
        estacionamento BOOLEAN DEFAULT FALSE,
        foto BLOB,
        website VARCHAR(255),
        telefone VARCHAR(15),
        classificacao DECIMAL(2, 1),
        latitude DECIMAL(10, 8),
        longitude DECIMAL(11, 8),
        observacoes TEXT
    );

CREATE TABLE
    ponto_roteiro (
        id_ponto_roteiro INT PRIMARY KEY AUTO_INCREMENT,
        roteiro_id INT NOT NULL,
        ponto_turistico_id INT NOT NULL,
        ordem_visita INT NOT NULL,
        tempo_permanencia_minutos INT NOT NULL,
        horario_previsto TIME,
        observacoes TEXT,
        FOREIGN KEY (roteiro_id) REFERENCES roteiro_turistico (id_roteiro),
        FOREIGN KEY (ponto_turistico_id) REFERENCES ponto_turistico (id_ponto),
        UNIQUE KEY (roteiro_id, ponto_turistico_id)
    );

CREATE TABLE
    evento_especial (
        id_evento INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        data_inicio DATE NOT NULL,
        data_fim DATE NOT NULL,
        hora_inicio TIME,
        hora_fim TIME,
        local_id INT,
        endereco_id INT,
        tipo_evento ENUM (
            'Show',
            'Esportivo',
            'Cultural',
            'Religioso',
            'Corporativo',
            'Feriado',
            'Festival'
        ) NOT NULL,
        publico_estimado INT,
        impacto_transporte ENUM ('Baixo', 'Médio', 'Alto', 'Crítico') NOT NULL,
        plano_contingencia BOOLEAN DEFAULT FALSE,
        plano_contingencia_descricao TEXT,
        operacao_especial BOOLEAN DEFAULT FALSE,
        linhas_especiais TEXT,
        status ENUM (
            'Programado',
            'Em preparação',
            'Em andamento',
            'Concluído',
            'Cancelado'
        ) DEFAULT 'Programado',
        observacoes TEXT
    );

CREATE TABLE
    planejamento_evento (
        id_planejamento INT PRIMARY KEY AUTO_INCREMENT,
        evento_id INT NOT NULL,
        tipo_planejamento ENUM (
            'Aumento frota',
            'Linha especial',
            'Desvio rota',
            'Extensão horário',
            'Equipe especial'
        ) NOT NULL,
        descricao TEXT NOT NULL,
        horario_inicio TIME NOT NULL,
        horario_fim TIME NOT NULL,
        qtde_veiculos_adicional INT,
        qtde_funcionarios_adicional INT,
        custo_estimado DECIMAL(10, 2),
        responsavel_id INT,
        aprovado_por_id INT,
        status_aprovacao ENUM (
            'Aguardando',
            'Aprovado',
            'Rejeitado',
            'Em revisão'
        ) DEFAULT 'Aguardando',
        observacoes TEXT,
        FOREIGN KEY (evento_id) REFERENCES evento_especial (id_evento)
    );