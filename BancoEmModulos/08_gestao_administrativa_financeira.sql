CREATE TABLE
    fornecedor (
        id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
        razao_social VARCHAR(100) NOT NULL,
        nome_fantasia VARCHAR(100),
        cnpj VARCHAR(18) UNIQUE NOT NULL,
        inscricao_estadual VARCHAR(20),
        endereco_id INT,
        telefone_principal VARCHAR(15) NOT NULL,
        telefone_secundario VARCHAR(15),
        email VARCHAR(100),
        website VARCHAR(255),
        ramo_atividade VARCHAR(100) NOT NULL,
        produtos_servicos TEXT NOT NULL,
        contato_nome VARCHAR(100),
        contato_telefone VARCHAR(15),
        contato_email VARCHAR(100),
        data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
        status ENUM ('ATIVO', 'INATIVO', 'SUSPENSO', 'EM ANALISE') DEFAULT 'ATIVO',
        avaliacao INT,
        observacoes TEXT
    );

CREATE TABLE
    contrato (
        id_contrato INT PRIMARY KEY AUTO_INCREMENT,
        numero_contrato VARCHAR(50) NOT NULL UNIQUE,
        tipo_contrato ENUM (
            'FORNECIMENTO',
            'SERVICO',
            'LOCACAO',
            'CONCESSAO',
            'OPERACAO',
            'PARCERIA',
            'SEGUROS',
            'MANUTENCAO'
        ) NOT NULL,
        parte_contratada_id INT,
        parte_contratante_id INT,
        objeto TEXT NOT NULL,
        valor_total DECIMAL(12, 2),
        data_assinatura DATE NOT NULL,
        data_inicio DATE NOT NULL,
        data_termino DATE NOT NULL,
        renovacao_automatica BOOLEAN DEFAULT FALSE,
        periodo_renovacao_meses INT,
        status ENUM (
            'EM VIGOR',
            'EM ELABORACAO',
            'ASSINADO',
            'ENCERRADO',
            'RESCINDIDO',
            'SUSPENSO'
        ) DEFAULT 'EM ELABORACAO',
        clausulas_principais TEXT,
        condicoes_pagamento TEXT,
        multa_rescisoria TEXT,
        responsavel_interno_id INT,
        arquivo_pdf BLOB,
        observacoes TEXT
    );

CREATE TABLE
    aditivo_contratual (
        id_aditivo INT PRIMARY KEY AUTO_INCREMENT,
        contrato_id INT NOT NULL,
        numero_aditivo INT NOT NULL,
        data_assinatura DATE NOT NULL,
        tipo_aditivo ENUM (
            'PRAZO',
            'VALOR',
            'OBJETO',
            'PRAZO E VALOR',
            'RESCISAO',
            'CONDICOES GERAIS'
        ) NOT NULL,
        nova_data_termino DATE,
        valor_alterado DECIMAL(12, 2),
        objeto_alterado TEXT,
        justificativa TEXT NOT NULL,
        aprovado_por_id INT,
        arquivo_pdf BLOB,
        FOREIGN KEY (contrato_id) REFERENCES contrato (id_contrato)
    );

CREATE TABLE
    ordem_compra (
        id_ordem_compra INT PRIMARY KEY AUTO_INCREMENT,
        numero_ordem VARCHAR(20) NOT NULL UNIQUE,
        fornecedor_id INT NOT NULL,
        data_emissao DATE NOT NULL,
        data_entrega_prevista DATE NOT NULL,
        valor_total DECIMAL(10, 2) NOT NULL,
        condicao_pagamento VARCHAR(50) NOT NULL,
        prazo_pagamento_dias INT NOT NULL,
        status ENUM (
            'ABERTA',
            'APROVADA',
            'PARCIALMENTE ENTREGUE',
            'ENTREGUE',
            'CANCELADA',
            'CONCLUIDA'
        ) DEFAULT 'ABERTA',
        tipo_frete ENUM (
            'CIF',
            'FOB',
            'POR CONTA DO EMITENTE',
            'POR CONTA DO DESTINATARIO',
            'POR CONTA DE TERCEIROS'
        ) NOT NULL,
        valor_frete DECIMAL(8, 2),
        requisitante_id INT NOT NULL,
        aprovador_id INT,
        data_aprovacao DATE,
        observacoes TEXT,
        FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id_fornecedor)
    );

CREATE TABLE
    item_ordem_compra (
        id_item INT PRIMARY KEY AUTO_INCREMENT,
        ordem_compra_id INT NOT NULL,
        produto_id INT,
        servico_id INT,
        descricao VARCHAR(255) NOT NULL,
        quantidade DECIMAL(10, 3) NOT NULL,
        unidade_medida VARCHAR(20) NOT NULL,
        valor_unitario DECIMAL(10, 2) NOT NULL,
        valor_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantidade * valor_unitario) STORED,
        data_entrega_prevista DATE,
        percentual_desconto DECIMAL(5, 2) DEFAULT 0,
        local_entrega VARCHAR(100),
        status ENUM (
            'PENDENTE',
            'ENTREGUE',
            'PARCIALMENTE ENTREGUE',
            'CANCELADO'
        ) DEFAULT 'PENDENTE',
        FOREIGN KEY (ordem_compra_id) REFERENCES ordem_compra (id_ordem_compra)
    );

CREATE TABLE
    nota_fiscal (
        id_nota_fiscal INT PRIMARY KEY AUTO_INCREMENT,
        numero_nota VARCHAR(20) NOT NULL,
        serie VARCHAR(5) NOT NULL,
        tipo_nota ENUM ('ENTRADA', 'SAIDA', 'SERVICO', 'CONSUMIDOR') NOT NULL,
        data_emissao DATE NOT NULL,
        fornecedor_id INT,
        cliente_id INT,
        valor_total DECIMAL(10, 2) NOT NULL,
        valor_produtos DECIMAL(10, 2) NOT NULL,
        valor_servicos DECIMAL(10, 2) DEFAULT 0.00,
        valor_frete DECIMAL(8, 2) DEFAULT 0.00,
        valor_desconto DECIMAL(8, 2) DEFAULT 0.00,
        valor_impostos DECIMAL(8, 2),
        forma_pagamento VARCHAR(50),
        chave_nfe VARCHAR(44),
        xml_nfe TEXT,
        pdf_nfe BLOB,
        status ENUM (
            'REGISTRADA',
            'CONFERIDA',
            'LANCADA',
            'PAGA',
            'CANCELADA'
        ) DEFAULT 'REGISTRADA',
        ordem_compra_id INT,
        observacoes TEXT,
        FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id_fornecedor),
        FOREIGN KEY (cliente_id) REFERENCES cliente (id_cliente),
        FOREIGN KEY (ordem_compra_id) REFERENCES ordem_compra (id_ordem_compra)
    );

CREATE TABLE
    item_nota_fiscal (
        id_item INT PRIMARY KEY AUTO_INCREMENT,
        nota_fiscal_id INT NOT NULL,
        codigo_produto VARCHAR(20),
        descricao VARCHAR(255) NOT NULL,
        ncm VARCHAR(8),
        cfop VARCHAR(4) NOT NULL,
        quantidade DECIMAL(10, 3) NOT NULL,
        unidade_medida VARCHAR(10) NOT NULL,
        valor_unitario DECIMAL(10, 2) NOT NULL,
        valor_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantidade * valor_unitario) STORED,
        valor_desconto DECIMAL(8, 2) DEFAULT 0.00,
        aliquota_icms DECIMAL(5, 2),
        aliquota_ipi DECIMAL(5, 2),
        aliquota_pis DECIMAL(5, 2),
        aliquota_cofins DECIMAL(5, 2),
        cst_icms VARCHAR(3),
        cst_ipi VARCHAR(2),
        cst_pis VARCHAR(2),
        cst_cofins VARCHAR(2),
        FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal (id_nota_fiscal)
    );

CREATE TABLE
    conta_pagar (
        id_conta_pagar INT PRIMARY KEY AUTO_INCREMENT,
        fornecedor_id INT,
        nota_fiscal_id INT,
        contrato_id INT,
        descricao VARCHAR(255) NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        data_emissao DATE NOT NULL,
        data_vencimento DATE NOT NULL,
        data_pagamento DATE,
        forma_pagamento VARCHAR(50),
        status ENUM (
            'ABERTA',
            'VENCIDA',
            'PAGA',
            'PARCIALMENTE PAGA',
            'CANCELADA'
        ) DEFAULT 'ABERTA',
        centro_custo VARCHAR(20),
        conta_contabil VARCHAR(20),
        numero_parcela INT,
        total_parcelas INT,
        valor_pago DECIMAL(10, 2) DEFAULT 0.00,
        juros_mora DECIMAL(8, 2) DEFAULT 0.00,
        multa DECIMAL(8, 2) DEFAULT 0.00,
        desconto DECIMAL(8, 2) DEFAULT 0.00,
        observacoes TEXT,
        FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id_fornecedor),
        FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal (id_nota_fiscal),
        FOREIGN KEY (contrato_id) REFERENCES contrato (id_contrato)
    );

CREATE TABLE
    conta_receber (
        id_conta_receber INT PRIMARY KEY AUTO_INCREMENT,
        cliente_id INT,
        contrato_id INT,
        nota_fiscal_id INT,
        descricao VARCHAR(255) NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        data_emissao DATE NOT NULL,
        data_vencimento DATE NOT NULL,
        data_recebimento DATE,
        forma_recebimento VARCHAR(50),
        status ENUM (
            'ABERTA',
            'VENCIDA',
            'RECEBIDA',
            'PARCIALMENTE RECEBIDA',
            'CANCELADA',
            'EM COBRANCA'
        ) DEFAULT 'ABERTA',
        centro_receita VARCHAR(20),
        conta_contabil VARCHAR(20),
        numero_parcela INT,
        total_parcelas INT,
        valor_recebido DECIMAL(10, 2) DEFAULT 0.00,
        juros_mora DECIMAL(8, 2) DEFAULT 0.00,
        multa DECIMAL(8, 2) DEFAULT 0.00,
        desconto DECIMAL(8, 2) DEFAULT 0.00,
        observacoes TEXT,
        FOREIGN KEY (cliente_id) REFERENCES cliente (id_cliente),
        FOREIGN KEY (contrato_id) REFERENCES contrato (id_contrato),
        FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal (id_nota_fiscal)
    );

CREATE TABLE
    folha_pagamento (
        id_folha INT PRIMARY KEY AUTO_INCREMENT,
        periodo_referencia VARCHAR(7) NOT NULL,
        tipo_folha ENUM (
            'NORMAL',
            'ADIANTAMENTO',
            '13O SALARIO',
            'FERIAS',
            'RESCISAO'
        ) NOT NULL,
        data_pagamento DATE NOT NULL,
        quantidade_funcionarios INT NOT NULL,
        valor_total_bruto DECIMAL(12, 2) NOT NULL,
        valor_total_descontos DECIMAL(12, 2) NOT NULL,
        valor_total_liquido DECIMAL(12, 2) NOT NULL,
        status ENUM (
            'EM CALCULO',
            'CALCULADA',
            'APROVADA',
            'PAGA',
            'CANCELADA'
        ) DEFAULT 'EM CALCULO',
        responsavel_calculo_id INT,
        responsavel_aprovacao_id INT,
        data_aprovacao DATE,
        observacoes TEXT
    );

CREATE TABLE
    pagamento_funcionario (
        id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
        folha_id INT NOT NULL,
        funcionario_id INT NOT NULL,
        salario_base DECIMAL(10, 2) NOT NULL,
        horas_normais DECIMAL(6, 2) NOT NULL,
        valor_horas_normais DECIMAL(10, 2) NOT NULL,
        horas_extras DECIMAL(6, 2) DEFAULT 0.00,
        valor_horas_extras DECIMAL(10, 2) DEFAULT 0.00,
        adicional_noturno_horas DECIMAL(6, 2) DEFAULT 0.00,
        valor_adicional_noturno DECIMAL(10, 2) DEFAULT 0.00,
        adicional_periculosidade DECIMAL(10, 2) DEFAULT 0.00,
        adicional_insalubridade DECIMAL(10, 2) DEFAULT 0.00,
        valor_ferias DECIMAL(10, 2) DEFAULT 0.00,
        valor_13_salario DECIMAL(10, 2) DEFAULT 0.00,
        outros_proventos DECIMAL(10, 2) DEFAULT 0.00,
        descricao_outros_proventos TEXT,
        inss DECIMAL(10, 2) DEFAULT 0.00,
        irrf DECIMAL(10, 2) DEFAULT 0.00,
        fgts DECIMAL(10, 2) DEFAULT 0.00,
        vale_transporte DECIMAL(10, 2) DEFAULT 0.00,
        vale_refeicao DECIMAL(10, 2) DEFAULT 0.00,
        vale_alimentacao DECIMAL(10, 2) DEFAULT 0.00,
        plano_saude DECIMAL(10, 2) DEFAULT 0.00,
        faltas_atrasos DECIMAL(10, 2) DEFAULT 0.00,
        outros_descontos DECIMAL(10, 2) DEFAULT 0.00,
        descricao_outros_descontos TEXT,
        pensao_alimenticia DECIMAL(10, 2) DEFAULT 0.00,
        valor_total_bruto DECIMAL(10, 2) NOT NULL,
        valor_total_descontos DECIMAL(10, 2) NOT NULL,
        valor_liquido DECIMAL(10, 2) NOT NULL,
        conta_bancaria VARCHAR(50),
        forma_pagamento ENUM (
            'DEPOSITO',
            'PIX',
            'CHEQUE',
            'DINHEIRO',
            'TRANSFERENCIA'
        ) DEFAULT 'DEPOSITO',
        data_credito DATE,
        status ENUM ('CALCULADO', 'APROVADO', 'PAGO', 'CANCELADO') DEFAULT 'CALCULADO',
        observacoes TEXT,
        FOREIGN KEY (folha_id) REFERENCES folha_pagamento (id_folha),
        FOREIGN KEY (funcionario_id) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE
    centro_custo (
        id_centro_custo INT PRIMARY KEY AUTO_INCREMENT,
        codigo VARCHAR(20) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        descricao TEXT,
        centro_pai_id INT,
        responsavel_id INT,
        tipo ENUM (
            'ADMINISTRATIVO',
            'OPERACIONAL',
            'COMERCIAL',
            'FINANCEIRO',
            'MARKETING',
            'RH',
            'TI',
            'MANUTENCAO'
        ) NOT NULL,
        ativo BOOLEAN DEFAULT TRUE,
        data_criacao DATE NOT NULL,
        data_encerramento DATE,
        orcamento_anual DECIMAL(12, 2),
        nivel INT NOT NULL,
        FOREIGN KEY (centro_pai_id) REFERENCES centro_custo (id_centro_custo)
    );

CREATE TABLE
    plano_contas (
        id_conta INT PRIMARY KEY AUTO_INCREMENT,
        codigo VARCHAR(20) NOT NULL UNIQUE,
        nome VARCHAR(100) NOT NULL,
        tipo ENUM (
            'RECEITA',
            'DESPESA',
            'ATIVO',
            'PASSIVO',
            'PATRIMONIO LIQUIDO'
        ) NOT NULL,
        natureza ENUM ('DEVEDORA', 'CREDORA') NOT NULL,
        conta_pai_id INT,
        nivel INT NOT NULL,
        aceita_lancamentos BOOLEAN DEFAULT TRUE,
        data_criacao DATE NOT NULL,
        data_inativacao DATE,
        ativo BOOLEAN DEFAULT TRUE,
        observacoes TEXT,
        FOREIGN KEY (conta_pai_id) REFERENCES plano_contas (id_conta)
    );

CREATE TABLE
    movimentacao_contabil (
        id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
        tipo_movimento ENUM (
            'LANCAMENTO',
            'ESTORNO',
            'TRANSFERENCIA',
            'AJUSTE',
            'FECHAMENTO'
        ) NOT NULL,
        data_movimento DATE NOT NULL,
        valor DECIMAL(12, 2) NOT NULL,
        conta_debito_id INT NOT NULL,
        conta_credito_id INT NOT NULL,
        centro_custo_id INT,
        numero_documento VARCHAR(50),
        descricao VARCHAR(255) NOT NULL,
        origem_lancamento VARCHAR(50) NOT NULL,
        usuario_lancamento INT NOT NULL,
        data_lancamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        estornado BOOLEAN DEFAULT FALSE,
        estorno_id INT,
        observacoes TEXT,
        FOREIGN KEY (conta_debito_id) REFERENCES plano_contas (id_conta),
        FOREIGN KEY (conta_credito_id) REFERENCES plano_contas (id_conta),
        FOREIGN KEY (centro_custo_id) REFERENCES centro_custo (id_centro_custo),
        FOREIGN KEY (estorno_id) REFERENCES movimentacao_contabil (id_movimentacao)
    );

CREATE TABLE
    orcamento (
        id_orcamento INT PRIMARY KEY AUTO_INCREMENT,
        ano INT NOT NULL,
        mes INT NOT NULL,
        centro_custo_id INT NOT NULL,
        conta_id INT NOT NULL,
        valor_previsto DECIMAL(12, 2) NOT NULL,
        valor_realizado DECIMAL(12, 2) DEFAULT 0.00,
        percentual_realizado DECIMAL(6, 2) GENERATED ALWAYS AS (
            CASE
                WHEN valor_previsto > 0 THEN (valor_realizado / valor_previsto) * 100
                ELSE 0
            END
        ) STORED,
        status ENUM (
            'PLANEJADO',
            'APROVADO',
            'EM EXECUCAO',
            'CONCLUIDO',
            'REVISADO'
        ) DEFAULT 'PLANEJADO',
        responsavel_id INT NOT NULL,
        aprovador_id INT,
        data_aprovacao DATE,
        observacoes TEXT,
        FOREIGN KEY (centro_custo_id) REFERENCES centro_custo (id_centro_custo),
        FOREIGN KEY (conta_id) REFERENCES plano_contas (id_conta),
        UNIQUE KEY (ano, mes, centro_custo_id, conta_id)
    );