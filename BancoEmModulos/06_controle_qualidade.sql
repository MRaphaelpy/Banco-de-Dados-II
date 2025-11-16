CREATE TABLE
    indicador_desempenho (
        id_indicador INT PRIMARY KEY AUTO_INCREMENT,
        codigo VARCHAR(20) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        unidade_medida VARCHAR(20) NOT NULL,
        formula TEXT NOT NULL,
        tipo_indicador ENUM (
            'OPERACIONAL',
            'FINANCEIRO',
            'QUALIDADE',
            'SEGURANCA',
            'AMBIENTAL',
            'RH',
            'MANUTENCAO'
        ) NOT NULL,
        periodicidade ENUM (
            'DIARIO',
            'SEMANAL',
            'MENSAL',
            'TRIMESTRAL',
            'SEMESTRAL',
            'ANUAL'
        ) NOT NULL,
        meta_valor DECIMAL(10, 2),
        limite_inferior DECIMAL(10, 2),
        limite_superior DECIMAL(10, 2),
        peso_avaliacao INT DEFAULT 1,
        responsavel_id INT,
        ativo BOOLEAN DEFAULT TRUE
    );

CREATE TABLE
    medicao_indicador (
        id_medicao INT PRIMARY KEY AUTO_INCREMENT,
        indicador_id INT NOT NULL,
        periodo_inicio DATE NOT NULL,
        periodo_fim DATE NOT NULL,
        valor_medido DECIMAL(10, 2) NOT NULL,
        meta_periodo DECIMAL(10, 2),
        percentual_atingimento DECIMAL(6, 2),
        status_medicao ENUM (
            'DENTRO META',
            'ACIMA META',
            'ABAIXO META',
            'CRITICO'
        ) NOT NULL,
        observacoes TEXT,
        data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
        registrado_por INT,
        FOREIGN KEY (indicador_id) REFERENCES indicador_desempenho (id_indicador)
    );

CREATE TABLE
    pesquisa_satisfacao (
        id_pesquisa INT PRIMARY KEY AUTO_INCREMENT,
        titulo VARCHAR(100) NOT NULL,
        descricao TEXT,
        data_inicio DATE NOT NULL,
        data_fim DATE NOT NULL,
        publico_alvo ENUM (
            'PASSAGEIROS',
            'CLIENTES CARGA',
            'COLABORADORES',
            'FORNECEDORES',
            'PUBLICO GERAL'
        ) NOT NULL,
        tipo_pesquisa ENUM (
            'ONLINE',
            'PRESENCIAL',
            'TELEFONICA',
            'APP',
            'SMS',
            'MISTA'
        ) NOT NULL,
        status ENUM (
            'PLANEJADA',
            'EM ANDAMENTO',
            'FINALIZADA',
            'CANCELADA',
            'EM ANALISE'
        ) DEFAULT 'PLANEJADA',
        quantidade_questoes INT NOT NULL,
        quantidade_respondentes INT DEFAULT 0,
        nota_media DECIMAL(3, 1),
        responsavel_id INT,
        observacoes TEXT
    );

CREATE TABLE
    questao_pesquisa (
        id_questao INT PRIMARY KEY AUTO_INCREMENT,
        pesquisa_id INT NOT NULL,
        texto_questao TEXT NOT NULL,
        tipo_questao ENUM (
            'MULTIPLA ESCOLHA',
            'UNICA ESCOLHA',
            'ESCALA LIKERT',
            'ABERTA',
            'SIM/NAO',
            'ESCALA NUMERICA'
        ) NOT NULL,
        obrigatoria BOOLEAN DEFAULT TRUE,
        ordem INT NOT NULL,
        opcoes TEXT,
        peso_questao DECIMAL(5, 2) DEFAULT 1.00,
        FOREIGN KEY (pesquisa_id) REFERENCES pesquisa_satisfacao (id_pesquisa)
    );

CREATE TABLE
    resposta_pesquisa (
        id_resposta INT PRIMARY KEY AUTO_INCREMENT,
        pesquisa_id INT NOT NULL,
        respondente_id INT,
        data_resposta DATETIME NOT NULL,
        canal ENUM (
            'WEBSITE',
            'APP',
            'TERMINAL FISICO',
            'PAPEL',
            'TELEFONE',
            'EMAIL',
            'SMS',
            'WHATSAPP'
        ) NOT NULL,
        localizacao_resposta VARCHAR(100),
        linha_id INT,
        veiculo_id INT,
        terminal_id INT,
        pontuacao_geral DECIMAL(5, 2),
        tempo_resposta_segundos INT,
        validada BOOLEAN DEFAULT TRUE,
        observacoes TEXT,
        FOREIGN KEY (pesquisa_id) REFERENCES pesquisa_satisfacao (id_pesquisa),
        FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo)
    );

CREATE TABLE
    detalhe_resposta_pesquisa (
        id_detalhe INT PRIMARY KEY AUTO_INCREMENT,
        resposta_id INT NOT NULL,
        questao_id INT NOT NULL,
        resposta_texto TEXT,
        resposta_numerica DECIMAL(5, 2),
        opcao_selecionada VARCHAR(100),
        FOREIGN KEY (resposta_id) REFERENCES resposta_pesquisa (id_resposta),
        FOREIGN KEY (questao_id) REFERENCES questao_pesquisa (id_questao)
    );

CREATE TABLE
    reclamacao_sugestao (
        id_manifestacao INT PRIMARY KEY AUTO_INCREMENT,
        tipo ENUM (
            'RECLAMACAO',
            'SUGESTAO',
            'ELOGIO',
            'DUVIDA',
            'SOLICITACAO'
        ) NOT NULL,
        data_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        passageiro_id INT,
        nome_manifestante VARCHAR(100),
        contato VARCHAR(100),
        assunto VARCHAR(100) NOT NULL,
        descricao TEXT NOT NULL,
        linha_id INT,
        veiculo_id INT,
        motorista_id INT,
        cobrador_id INT,
        data_ocorrencia DATE,
        hora_ocorrencia TIME,
        local_ocorrencia VARCHAR(255),
        status ENUM (
            'REGISTRADA',
            'EM ANALISE',
            'RESPONDIDA',
            'CONCLUIDA',
            'CANCELADA'
        ) DEFAULT 'REGISTRADA',
        prioridade ENUM ('BAIXA', 'MEDIA', 'ALTA', 'URGENTE') DEFAULT 'MEDIA',
        prazo_resposta_dias INT DEFAULT 5,
        FOREIGN KEY (passageiro_id) REFERENCES passageiro (id_passageiro),
        FOREIGN KEY (linha_id) REFERENCES linha_transporte (id_linha),
        FOREIGN KEY (veiculo_id) REFERENCES veiculo (id_veiculo),
        FOREIGN KEY (motorista_id) REFERENCES motorista (id_motorista),
        FOREIGN KEY (cobrador_id) REFERENCES cobrador (id_cobrador)
    );

CREATE TABLE
    acompanhamento_manifestacao (
        id_acompanhamento INT PRIMARY KEY AUTO_INCREMENT,
        manifestacao_id INT NOT NULL,
        data_acompanhamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        tipo_acompanhamento ENUM (
            'ANALISE',
            'ENCAMINHAMENTO',
            'RESPOSTA',
            'CONCLUSAO',
            'REABERTURA'
        ) NOT NULL,
        responsavel_id INT NOT NULL,
        setor_encaminhado INT,
        descricao TEXT NOT NULL,
        visivel_manifestante BOOLEAN DEFAULT FALSE,
        resposta_enviada BOOLEAN DEFAULT FALSE,
        canal_resposta ENUM (
            'EMAIL',
            'SMS',
            'WHATSAPP',
            'CARTA',
            'TELEFONE',
            'PESSOALMENTE'
        ),
        data_resposta DATETIME,
        FOREIGN KEY (manifestacao_id) REFERENCES reclamacao_sugestao (id_manifestacao)
    );

CREATE TABLE
    auditoria_interna (
        id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
        codigo_auditoria VARCHAR(20) NOT NULL,
        tipo_auditoria ENUM (
            'OPERACIONAL',
            'SEGURANCA',
            'QUALIDADE',
            'AMBIENTAL',
            'FINANCEIRA',
            'PROCESSOS',
            'TI'
        ) NOT NULL,
        data_inicio DATE NOT NULL,
        data_fim DATE NOT NULL,
        auditor_responsavel VARCHAR(100) NOT NULL,
        setor_auditado VARCHAR(100) NOT NULL,
        objetivo TEXT NOT NULL,
        escopo TEXT,
        status ENUM (
            'PLANEJADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'CANCELADA',
            'SUSPENSA'
        ) DEFAULT 'PLANEJADA',
        resultado_geral TEXT,
        nota_geral DECIMAL(3, 1),
        qtde_nao_conformidades INT DEFAULT 0,
        qtde_observacoes INT DEFAULT 0,
        qtde_recomendacoes INT DEFAULT 0,
        relatorio_final TEXT,
        proxima_auditoria_data DATE
    );

CREATE TABLE
    nao_conformidade (
        id_nao_conformidade INT PRIMARY KEY AUTO_INCREMENT,
        auditoria_id INT,
        incidente_id INT,
        reclamacao_id INT,
        data_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        tipo_nc ENUM ('CRITICA', 'MAIOR', 'MENOR', 'OBSERVACAO') NOT NULL,
        descricao TEXT NOT NULL,
        area_responsavel VARCHAR(100) NOT NULL,
        responsavel_id INT,
        causa_raiz TEXT,
        prazo_correcao DATE NOT NULL,
        status ENUM (
            'REGISTRADA',
            'EM ANALISE',
            'EM CORRECAO',
            'VERIFICADA',
            'ENCERRADA',
            'REABERTA'
        ) DEFAULT 'REGISTRADA',
        data_encerramento DATE,
        verificado_por INT,
        observacoes TEXT,
        FOREIGN KEY (auditoria_id) REFERENCES auditoria_interna (id_auditoria),
        FOREIGN KEY (incidente_id) REFERENCES incidente_seguranca (id_incidente),
        FOREIGN KEY (reclamacao_id) REFERENCES reclamacao_sugestao (id_manifestacao)
    );

CREATE TABLE
    acao_corretiva_preventiva (
        id_acao INT PRIMARY KEY AUTO_INCREMENT,
        nao_conformidade_id INT,
        tipo_acao ENUM (
            'CORRETIVA',
            'PREVENTIVA',
            'MELHORIA',
            'CONTENCAO'
        ) NOT NULL,
        descricao TEXT NOT NULL,
        responsavel_id INT NOT NULL,
        data_inicio DATE NOT NULL,
        prazo_conclusao DATE NOT NULL,
        status ENUM (
            'PLANEJADA',
            'EM ANDAMENTO',
            'CONCLUIDA',
            'ATRASADA',
            'CANCELADA',
            'VERIFICADA'
        ) DEFAULT 'PLANEJADA',
        data_conclusao DATE,
        eficacia BOOLEAN,
        avaliacao_eficacia TEXT,
        data_avaliacao DATE,
        avaliador_id INT,
        observacoes TEXT,
        FOREIGN KEY (nao_conformidade_id) REFERENCES nao_conformidade (id_nao_conformidade)
    );