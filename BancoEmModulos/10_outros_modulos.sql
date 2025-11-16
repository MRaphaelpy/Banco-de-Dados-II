CREATE TABLE
    usuario (
        id_usuario INT PRIMARY KEY AUTO_INCREMENT,
        username VARCHAR(50) NOT NULL UNIQUE,
        senha_hash VARCHAR(255) NOT NULL,
        nome_completo VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        funcionario_id INT,
        perfil_id INT,
        data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        ultimo_acesso DATETIME,
        ultimo_ip VARCHAR(45),
        status ENUM (
            'ATIVO',
            'INATIVO',
            'BLOQUEADO',
            'PENDENTE ATIVACAO'
        ) DEFAULT 'PENDENTE ATIVACAO',
        tentativas_login_falhas INT DEFAULT 0,
        bloqueado_ate DATETIME,
        trocar_senha_proximo_login BOOLEAN DEFAULT TRUE,
        data_ultima_troca_senha DATETIME,
        token_recuperacao VARCHAR(100),
        validade_token DATETIME,
        observacoes TEXT,
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    perfil_acesso (
        id_perfil INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(50) NOT NULL UNIQUE,
        descricao TEXT,
        nivel_acesso INT NOT NULL,
        ativo BOOLEAN DEFAULT TRUE,
        data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        criado_por_id INT,
        data_inativacao DATETIME,
        padrao_sistema BOOLEAN DEFAULT FALSE,
        observacoes TEXT
    );

CREATE TABLE
    permissao (
        id_permissao INT PRIMARY KEY AUTO_INCREMENT,
        codigo VARCHAR(50) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        modulo VARCHAR(50) NOT NULL,
        tipo ENUM (
            'CONSULTA',
            'INCLUSAO',
            'ALTERACAO',
            'EXCLUSAO',
            'APROVACAO',
            'RELATORIO',
            'ADMINISTRATIVO'
        ) NOT NULL,
        padrao_sistema BOOLEAN DEFAULT FALSE
    );

CREATE TABLE
    permissao_perfil (
        id_permissao_perfil INT PRIMARY KEY AUTO_INCREMENT,
        perfil_id INT NOT NULL,
        permissao_id INT NOT NULL,
        concedida_por_id INT,
        data_concessao DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (perfil_id) REFERENCES perfil_acesso (id_perfil),
        FOREIGN KEY (permissao_id) REFERENCES permissao (id_permissao),
        UNIQUE KEY (perfil_id, permissao_id)
    );

CREATE TABLE
    log_sistema (
        id_log BIGINT PRIMARY KEY AUTO_INCREMENT,
        usuario_id INT,
        data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        tipo_acao ENUM (
            'LOGIN',
            'LOGOUT',
            'INCLUSAO',
            'ALTERACAO',
            'EXCLUSAO',
            'CONSULTA',
            'ERRO',
            'ALERTA',
            'PROCESSO'
        ) NOT NULL,
        modulo VARCHAR(50) NOT NULL,
        tabela_afetada VARCHAR(50),
        registro_id VARCHAR(50),
        descricao TEXT,
        ip_origem VARCHAR(45),
        status ENUM ('SUCESSO', 'FALHA', 'ALERTA', 'BLOQUEIO') NOT NULL,
        dados_antigos TEXT,
        dados_novos TEXT,
        tempo_execucao_ms INT,
        FOREIGN KEY (usuario_id) REFERENCES usuario (id_usuario),
        INDEX idx_data_tipo (data_hora, tipo_acao),
        INDEX idx_usuario (usuario_id)
    );

CREATE TABLE
    configuracao_sistema (
        id_configuracao INT PRIMARY KEY AUTO_INCREMENT,
        chave VARCHAR(100) NOT NULL UNIQUE,
        valor TEXT,
        tipo_dado ENUM (
            'STRING',
            'INTEGER',
            'FLOAT',
            'BOOLEAN',
            'DATE',
            'DATETIME',
            'JSON',
            'XML'
        ) NOT NULL,
        descricao VARCHAR(255) NOT NULL,
        categoria VARCHAR(50) NOT NULL,
        nivel_acesso ENUM ('PUBLICO', 'USUARIO', 'ADMINISTRADOR', 'SISTEMA') DEFAULT 'ADMINISTRADOR',
        alteravel_usuario BOOLEAN DEFAULT FALSE,
        valor_padrao TEXT,
        data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        alterado_por_id INT,
        observacoes TEXT
    );

CREATE TABLE
    notificacao (
        id_notificacao BIGINT PRIMARY KEY AUTO_INCREMENT,
        usuario_id INT,
        tipo_notificacao ENUM (
            'SISTEMA',
            'ALERTA',
            'INFORMACAO',
            'SUCESSO',
            'ERRO',
            'APROVACAO',
            'VENCIMENTO',
            'OPERACIONAL'
        ) NOT NULL,
        titulo VARCHAR(100) NOT NULL,
        mensagem TEXT NOT NULL,
        data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        data_leitura DATETIME,
        data_expiracao DATETIME,
        nivel_urgencia ENUM ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') DEFAULT 'MEDIA',
        url_acao VARCHAR(255),
        requer_acao BOOLEAN DEFAULT FALSE,
        requer_confirmacao BOOLEAN DEFAULT FALSE,
        origem_sistema VARCHAR(50),
        FOREIGN KEY (usuario_id) REFERENCES usuario (id_usuario),
        INDEX idx_usuario_leitura (usuario_id, data_leitura)
    );

CREATE TABLE
    documento_sistema (
        id_documento INT PRIMARY KEY AUTO_INCREMENT,
        titulo VARCHAR(100) NOT NULL,
        tipo_documento ENUM (
            'MANUAL',
            'PROCEDIMENTO',
            'FORMULARIO',
            'POLITICA',
            'RELATORIO',
            'CONTRATO',
            'INSTRUCAO TRABALHO',
            'OUTRO'
        ) NOT NULL,
        categoria VARCHAR(50) NOT NULL,
        codigo_referencia VARCHAR(50),
        versao VARCHAR(20) NOT NULL,
        data_criacao DATE NOT NULL,
        data_ultima_revisao DATE,
        proxima_revisao_prevista DATE,
        responsavel_id INT,
        status ENUM (
            'RASCUNHO',
            'EM REVISAO',
            'APROVADO',
            'PUBLICADO',
            'OBSOLETO',
            'CANCELADO'
        ) DEFAULT 'RASCUNHO',
        arquivo BLOB,
        nome_arquivo VARCHAR(255),
        tamanho_arquivo INT,
        tipo_arquivo VARCHAR(50),
        observacoes TEXT,
        palavras_chave VARCHAR(255),
        restrito BOOLEAN DEFAULT FALSE,
        perfis_acesso VARCHAR(255)
    );

CREATE TABLE
    relatorio_salvo (
        id_relatorio INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        tipo_relatorio VARCHAR(50) NOT NULL,
        parametros TEXT,
        formato_saida ENUM ('PDF', 'EXCEL', 'CSV', 'HTML', 'JSON', 'XML') NOT NULL,
        agendamento BOOLEAN DEFAULT FALSE,
        frequencia_agendamento ENUM (
            'DIARIO',
            'SEMANAL',
            'QUINZENAL',
            'MENSAL',
            'TRIMESTRAL',
            'SEMESTRAL',
            'ANUAL'
        ) DEFAULT NULL,
        proxima_execucao DATETIME,
        ultima_execucao DATETIME,
        criado_por_id INT NOT NULL,
        data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        compartilhado BOOLEAN DEFAULT FALSE,
        compartilhado_com TEXT,
        favorito BOOLEAN DEFAULT FALSE,
        observacoes TEXT,
        FOREIGN KEY (criado_por_id) REFERENCES usuario (id_usuario)
    );

CREATE TABLE
    alerta_programado (
        id_alerta INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        tipo_alerta ENUM (
            'VENCIMENTO',
            'MANUTENCAO',
            'RENOVACAO',
            'PAGAMENTO',
            'RECEBIMENTO',
            'ESTOQUE',
            'OPERACIONAL',
            'SISTEMA'
        ) NOT NULL,
        data_referencia_campo VARCHAR(100) NOT NULL,
        tabela_monitorada VARCHAR(50) NOT NULL,
        condicao_sql TEXT,
        dias_antecedencia INT NOT NULL DEFAULT 7,
        destinatarios_ids VARCHAR(255),
        destinatarios_emails TEXT,
        template_mensagem TEXT,
        assunto_email VARCHAR(255),
        ativo BOOLEAN DEFAULT TRUE,
        ultima_verificacao DATETIME,
        proxima_verificacao DATETIME,
        criado_por_id INT,
        data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        observacoes TEXT
    );