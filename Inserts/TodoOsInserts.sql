
--- =====================================================

USE SINATRANS;

-- =====================================================
-- MÓDULO: GESTÃO DE PESSOAS
-- =====================================================

-- Inserindo Endereços
INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep, pais, coordenada_latitude, coordenada_longitude)
VALUES 
('Avenida Paulista', '1000', 'Sala 101', 'Bela Vista', 'São Paulo', 'SP', '01310-100', 'Brasil', -23.5613900, -46.6565900),
('Rua Augusta', '500', NULL, 'Consolação', 'São Paulo', 'SP', '01305-000', 'Brasil', -23.5505199, -46.6626300),
('Avenida Jabaquara', '2000', 'Terminal', 'Jabaquara', 'São Paulo', 'SP', '04046-200', 'Brasil', -23.6360000, -46.6430000);

-- Inserindo Cargo
INSERT INTO cargo (nome_cargo, descricao, salario_base, carga_horaria_semanal, nivel_hierarquico)
VALUES ('Motorista de Ônibus', 'Responsável pela condução de veículos de transporte coletivo', 3500.00, 44, 3);
VALUES ('Cobrador de Ônibus', 'Responsável pela cobrança de tarifas e atendimento aos passageiros', 2200.00, 44, 4);
VALUES ('Supervisor de Operações', 'Responsável pela supervisão das operações de transporte', 5000.00, 44, 2);

-- Inserindo Departamento
INSERT INTO departamento (nome_departamento, descricao, gestor_id, localizacao_id, centro_custo)
VALUES ('Operações', 'Departamento responsável pelas operações de transporte', NULL, 1, 'CC001');
VALUES ('Recursos Humanos', 'Departamento responsável pela gestão de pessoas', NULL, 2, 'CC002');   

-- Inserindo Funcionários
INSERT INTO funcionario (nome, cpf, data_nascimento, email, telefone, endereco_id, cargo_id, departamento_id, data_admissao, status)
VALUES 
('João da Silva', '123.456.789-00', '1985-05-15', 'joao.silva@sinatrans.com', '(11) 98765-4321', 1, 1, 1, '2020-01-10', 'ATIVO'),
('Carlos Souza', '234.567.890-11', '1988-03-22', 'carlos.souza@sinatrans.com', '(11) 98765-4322', 2, 1, 1, '2019-06-15', 'ATIVO'),
('Pedro Santos', '345.678.901-22', '1990-11-10', 'pedro.santos@sinatrans.com', '(11) 98765-4323', 1, 1, 1, '2021-02-20', 'ATIVO'),
('Ana Maria', '456.789.012-33', '1992-07-18', 'ana.maria@sinatrans.com', '(11) 98765-4324', 1, 1, 1, '2020-08-12', 'ATIVO');

-- Inserindo Motoristas
INSERT INTO motorista (id_motorista, cnh, categoria_cnh, validade_cnh, curso_transporte_coletivo, curso_transporte_cargas, pontuacao_cnh, exame_toxicologico_validade, anos_experiencia)
VALUES 
(1, '12345678901', 'D', '2026-12-31', TRUE, FALSE, 0, '2025-06-30', 10),
(2, '12345678902', 'D', '2027-03-15', TRUE, FALSE, 0, '2025-09-15', 8),
(3, '12345678903', 'E', '2026-08-20', TRUE, TRUE, 0, '2025-12-20', 12);

-- Inserindo Cobradores
INSERT INTO cobrador (id_cobrador, treinamento_atendimento, certificado_manuseio_dinheiro, conhecimento_rotas, treinamento_seguranca)
VALUES 
(4, TRUE, TRUE, TRUE, TRUE);

-- Inserindo Escala de Trabalho
INSERT INTO escala_trabalho (tipo_escala, hora_inicio, hora_fim, descricao, intervalo_minutos)
VALUES ('6X1', '06:00:00', '14:00:00', 'Escala matutina 6x1', 60);
VALUES ('5X2', '14:00:00', '22:00:00', 'Escala vespertina 5x2', 60);

-- Inserindo Passageiro
INSERT INTO passageiro (nome, cpf, data_nascimento, email, telefone, endereco_id, tipo_passageiro)
VALUES ('Maria Santos', '987.654.321-00', '1990-08-20', 'maria.santos@email.com', '(11) 91234-5678', 1, 'REGULAR');
VALUES ('Lucas Oliveira', '876.543.210-11', '1985-12-05', 'lucas.oliveira@email.com', '(11) 92345-6789', 2, 'ESTUDANTE');

-- Inserindo Passageiro Detalhe
INSERT INTO passageiro_detalhe (id_passageiro, documento_identidade, numero_documento, orgao_emissor, data_emissao, possui_biometria)
VALUES (1, 'RG', '12.345.678-9', 'SSP-SP', '2015-03-10', FALSE);
VALUES (2, 'RG', '98.765.432-1', 'SSP-SP', '2010-07-22', TRUE);

-- Inserindo Passageiro Estudante
INSERT INTO passageiro_estudante (id_estudante, instituicao_ensino, curso, matricula, nivel_ensino, validade_carteira)
VALUES (1, 'Universidade de São Paulo', 'Engenharia Civil', 'USP2023001', 'SUPERIOR', '2025-12-31');
VALUES (2, 'Colégio Estadual São Paulo', 'Ensino Médio', 'CESP2022005', 'MÉDIO', '2024-12-31');

-- Inserindo Passageiro PCD
INSERT INTO passageiro_pcd (id_pcd, tipo_deficiencia, necessita_acompanhante, validade_laudo)
VALUES (1, 'Deficiência física - cadeirante', TRUE, '2026-06-30');
VALUES (2, 'Deficiência visual - baixa visão', FALSE, '2025-11-15');

-- Inserindo Passageiro Idoso
INSERT INTO passageiro_idoso (id_idoso, numero_beneficio_inss, carteira_idoso)
VALUES (1, '1234567890', 'IDO-2023-001');
VALUES (2, '0987654321', 'IDO-2023-002');

-- =====================================================
-- MÓDULO: VEÍCULOS E FROTA
-- =====================================================

-- Inserindo Modelo de Veículo
INSERT INTO modelo_veiculo (marca, nome_modelo, categoria, comprimento_metros, altura_metros, largura_metros, peso_kg, configuracao_assentos, acessibilidade, ar_condicionado)
VALUES 
('Mercedes-Benz', 'OF-1721', 'ONIBUS URBANO', 12.50, 3.20, 2.50, 15000.00, '2+2', TRUE, TRUE),
('Volkswagen', 'Volksbus 17.230', 'ONIBUS URBANO', 11.00, 3.10, 2.50, 14000.00, '2+2', TRUE, TRUE),
('Scania', 'K310', 'ONIBUS RODOVIARIO', 13.20, 3.50, 2.60, 16000.00, '2+2', TRUE, TRUE);

-- Inserindo Garagem
INSERT INTO garagem (nome, endereco_id, capacidade_veiculos, tipo_garagem, possui_oficina, possui_abastecimento, horario_funcionamento, telefone, responsavel_id)
VALUES 
('Garagem Central', 1, 50, 'URBANA', TRUE, TRUE, '24 horas', '(11) 3333-4444', 1),
('Garagem Sul', 3, 30, 'URBANA', TRUE, FALSE, '05:00 às 23:00', '(11) 3333-5555', 1);

-- Inserindo Veículo
INSERT INTO veiculo (placa, renavam, chassi, modelo_id, ano_fabricacao, ano_modelo, capacidade_passageiros, capacidade_carga_kg, tipo_combustivel, consumo_medio, status_operacional, data_aquisicao, quilometragem_atual, garagem_id)
VALUES 
('ABC1D23', '12345678901', '9BM123456789ABCDE', 1, 2022, 2023, 80, 0.00, 'DIESEL', 3.50, 'ATIVO', '2022-06-15', 45000, 1),
('DEF2E34', '12345678902', '9BW223456789ABCDF', 2, 2021, 2022, 75, 0.00, 'DIESEL', 3.30, 'ATIVO', '2021-08-20', 62000, 1),
('GHI3F45', '12345678903', '9SC323456789ABCDG', 3, 2023, 2024, 45, 0.00, 'DIESEL', 4.00, 'ATIVO', '2023-03-10', 18000, 2);

-- Inserindo Manutenção
INSERT INTO manutencao (veiculo_id, tipo_manutencao, data_inicio, quilometragem_veiculo, descricao, status, custo_total, responsavel_tecnico)
VALUES (1, 'PREVENTIVA', '2025-01-15 08:00:00', 45000, 'Revisão programada dos 45.000 km', 'CONCLUIDA', 1500.00, 'Carlos Mecânico');

-- Inserindo Peça
INSERT INTO peca (codigo_peca, nome, descricao, fabricante, modelo_compativel, categoria_peca, unidade_medida, valor_medio)
VALUES ('FLT001', 'Filtro de Óleo', 'Filtro de óleo para motor diesel', 'Mann Filter', 'OF-1721', 'Filtros', 'UNIDADE', 45.00);

-- Inserindo Serviço de Manutenção
INSERT INTO servico_manutencao (nome_servico, descricao, tempo_estimado_minutos, valor_padrao, categoria_servico, requer_especialista)
VALUES ('Troca de Óleo', 'Substituição do óleo lubrificante do motor', 60, 250.00, 'Preventiva', FALSE);

-- Inserindo Item de Manutenção
INSERT INTO item_manutencao (manutencao_id, peca_id, servico_id, quantidade, valor_unitario, garantia_dias, data_garantia_fim)
VALUES (1, 1, 1, 2, 45.00, 90, '2025-04-15');

-- Inserindo Estoque de Peça
INSERT INTO estoque_peca (peca_id, quantidade_atual, quantidade_minima, quantidade_maxima, localizacao_estoque, garagem_id, data_ultima_entrada, valor_medio_compra)
VALUES (1, 50, 10, 100, 'Prateleira A-12', 1, '2025-01-10', 42.00);
VALUES (1, 30, 10, 80, 'Prateleira B-05', 2, '2025-01-12', 43.00);

-- Inserindo Movimentação de Estoque
INSERT INTO movimentacao_estoque (peca_id, tipo_movimentacao, quantidade, data_movimentacao, responsavel_id, manutencao_id, valor_unitario, motivo)
VALUES (1, 'SAIDA', 2, '2025-01-15 09:30:00', 1, 1, 45.00, 'Utilização em manutenção preventiva');
VALUES (1, 'ENTRADA', 20, '2025-01-10 14:00:00', 1, NULL, 42.00, 'Reabastecimento de estoque');

-- Inserindo Posto de Abastecimento
INSERT INTO posto_abastecimento (nome, endereco_id, cnpj, tipo_posto, contato_nome, contato_telefone, combustiveis_disponiveis, horario_funcionamento, convenio_ativo, data_inicio_convenio)
VALUES ('Posto Central', 1, '12.345.678/0001-90', 'CONVENIADO', 'Pedro Gerente', '(11) 4444-5555', 'Diesel,Gasolina,Etanol', '24 horas', TRUE, '2020-01-01');

-- Inserindo Abastecimento
INSERT INTO abastecimento (veiculo_id, data_abastecimento, tipo_combustivel, quantidade, valor_unitario, quilometragem_veiculo, posto_id, responsavel_id, forma_pagamento, tanque_completo)
VALUES (1, '2025-01-20 07:30:00', 'DIESEL', 150.00, 5.50, 45200, 1, 1, 'Cartão Convênio', TRUE);

-- Inserindo Pneu
INSERT INTO pneu (codigo_barras, marca, modelo, dimensao, tipo, data_fabricacao, data_compra, valor_compra, vida_util_estimada_km, garantia_km)
VALUES ('7891234567890', 'Pirelli', 'Formula Driver', '275/80R22.5', 'RADIAL', '2024-01-15', '2024-02-10', 1200.00, 80000, 60000);

-- Inserindo Posição de Pneu
INSERT INTO posicao_pneu (veiculo_id, pneu_id, posicao, data_instalacao, quilometragem_instalacao, profundidade_sulco_instalacao, ativo)
VALUES (1, 1, 'Dianteiro Esquerdo', '2024-02-15 10:00:00', 35000, 16.00, TRUE);

-- Inserindo Histórico de Calibragem
INSERT INTO historico_calibragem (posicao_pneu_id, data_calibragem, pressao_psi, temperatura_pneu_celsius, responsavel_id)
VALUES (1, '2025-01-20 08:00:00', 110.00, 25.00, 1);

-- =====================================================
-- MÓDULO: OPERAÇÃO DE TRANSPORTE
-- =====================================================

-- Inserindo Empresa Operadora
INSERT INTO empresa_operadora (razao_social, nome_fantasia, cnpj, inscricao_estadual, endereco_id, responsavel_nome, responsavel_contato, email, telefone, data_inicio_operacao, status)
VALUES ('Transportes São Paulo Ltda', 'TransSP', '11.222.333/0001-44', '123.456.789.012', 1, 'Roberto Diretor', '(11) 5555-6666', 'contato@transsp.com', '(11) 5555-6666', '2015-01-01', 'ATIVA');

-- Inserindo Linha de Transporte
INSERT INTO linha_transporte (codigo_linha, nome, tipo_linha, origem, destino, extensao_km, tempo_medio_minutos, intervalo_medio_minutos, empresa_operadora_id, status, data_inicio_operacao)
VALUES ('100', 'Terminal Jabaquara - Praça da Sé', 'URBANA', 'Terminal Jabaquara', 'Praça da Sé', 15.5, 45, 10, 1, 'ATIVA', '2015-06-01');

-- Inserindo Rota
INSERT INTO rota (linha_id, nome, sentido, extensao_km, tempo_estimado_minutos, horario_inicio_operacao, horario_fim_operacao, dias_operacao, tipo_via_predominante)
VALUES (1, 'Jabaquara - Sé (Ida)', 'IDA', 15.5, 45, '05:00:00', '23:30:00', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado', 'URBANA');

-- Inserindo Parada
INSERT INTO parada (codigo_parada, nome, tipo_parada, endereco_id, coordenada_latitude, coordenada_longitude, coberta, acessivel, iluminacao, bancos, informacoes_horarios, totem_eletronico, wifi, status)
VALUES ('P001', 'Terminal Jabaquara', 'TERMINAL', 1, -23.6360000, -46.6430000, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 'ATIVA');

-- Inserindo Parada Rota
INSERT INTO parada_rota (rota_id, parada_id, ordem_sequencial, tempo_ate_proxima_parada_minutos, distancia_ate_proxima_parada_km, previsao_demanda, embarque_permitido, desembarque_permitido)
VALUES (1, 1, 1, 5, 1.2, 'ALTA', TRUE, TRUE);

-- Inserindo Horário
INSERT INTO horario (rota_id, hora_partida, hora_chegada, dias_operacao, tipo_horario, veiculos_necessarios, frequencia_minutos, periodo_vigencia_inicio)
VALUES (1, '06:00:00', '06:45:00', 'Segunda,Terça,Quarta,Quinta,Sexta', 'REGULAR', 1, 10, '2025-01-01');

-- Inserindo Horário Parada
INSERT INTO horario_parada (horario_id, parada_id, hora_prevista, tolerancia_minutos)
VALUES (1, 1, '06:00:00', 5);

-- Inserindo Tarifa
INSERT INTO tarifa (linha_id, valor, tipo_tarifa, descricao, porcentagem_desconto, data_inicio_vigencia)
VALUES (1, 4.40, 'REGULAR', 'Tarifa regular para linha urbana', 0.00, '2025-01-01');

-- Inserindo Cartão de Bilhetagem
INSERT INTO cartao_bilhetagem (id_cartao, passageiro_id, tipo_cartao, data_emissao, data_expiracao, status, saldo)
VALUES ('1234567890123456', 1, 'COMUM', '2024-01-15', '2029-01-15', 'ATIVO', 50.00);

-- Inserindo Recarga
INSERT INTO recarga (cartao_id, valor, data_hora_recarga, tipo_pagamento, local_recarga, operador_id, status)
VALUES ('1234567890123456', 50.00, '2025-01-20 08:00:00', 'PIX', 'APP', 1, 'COMPLETA');

-- Inserindo Validador
INSERT INTO validador (id_validador, numero_serie, modelo, fabricante, firmware_versao, data_instalacao, status, veiculo_id, ultima_sincronizacao)
VALUES ('VAL001', 'SN123456789', 'ValidPro 2000', 'TechValid', 'v2.5.1', '2024-01-10', 'ATIVO', 1, '2025-01-20 23:00:00');

-- Inserindo Utilização de Cartão
INSERT INTO utilizacao_cartao (cartao_id, data_hora_utilizacao, valor_cobrado, tipo_utilizacao, linha_id, veiculo_id, parada_id, validador_id, saldo_restante)
VALUES ('1234567890123456', '2025-01-20 08:15:00', 4.40, 'EMBARQUE', 1, 1, 1, 'VAL001', 45.60);

-- Inserindo Escala
INSERT INTO escala (data_escala, horario_id, veiculo_id, motorista_id, cobrador_id, status, hora_inicio_prevista, hora_fim_prevista, hora_inicio_real, hora_fim_real)
VALUES ('2025-01-20', 1, 1, 1, 4, 'CONCLUIDA', '06:00:00', '14:00:00', '05:58:00', '14:05:00');

-- Inserindo Viagem
INSERT INTO viagem (escala_id, rota_id, veiculo_id, motorista_id, cobrador_id, data_viagem, hora_partida_prevista, hora_chegada_prevista, hora_partida_real, hora_chegada_real, km_inicial, km_final, status_viagem, total_passageiros, ocupacao_maxima)
VALUES (1, 1, 1, 1, 4, '2025-01-20', '06:00:00', '06:45:00', '06:00:00', '06:47:00', 45000, 45015, 'CONCLUIDA', 45, 60);

-- Inserindo Ponto de Viagem
INSERT INTO ponto_viagem (viagem_id, parada_id, sequencia, horario_previsto, horario_real, atraso_minutos, passageiros_embarcados, passageiros_desembarcados, ocupacao_momento, status)
VALUES (1, 1, 1, '06:00:00', '06:00:00', 0, 25, 0, 25, 'REALIZADA');

-- Inserindo Controle de Ocupação
INSERT INTO controle_ocupacao (viagem_id, data_hora, parada_id, localizacao_latitude, localizacao_longitude, passageiros_atual, capacidade_total, status_lotacao, em_pico)
VALUES (1, '2025-01-20 06:00:00', 1, -23.6360000, -46.6430000, 25, 80, 'BAIXA', FALSE);

-- Inserindo Consórcio
INSERT INTO consorcio (nome, descricao, data_inicio, status, representante_nome, representante_contato, area_geografica_atuacao)
VALUES ('Consórcio Transporte Metropolitano', 'Consórcio de empresas de transporte da região metropolitana', '2015-01-01', 'ATIVO', 'Carlos Presidente', '(11) 6666-7777', 'Região Metropolitana de São Paulo');

-- Inserindo Empresa Consórcio
INSERT INTO empresa_consorcio (empresa_id, consorcio_id, data_entrada, participacao_percentual, status)
VALUES (1, 1, '2015-01-01', 35.00, 'Ativa');

-- =====================================================
-- MÓDULO: LOGÍSTICA DE CARGAS
-- =====================================================

-- Inserindo Cliente
INSERT INTO cliente (tipo_pessoa, nome_razao_social, cpf_cnpj, endereco_id, telefone, email, contato_nome, data_cadastro, status_cliente, limite_credito)
VALUES ('JURIDICA', 'Indústria ABC Ltda', '22.333.444/0001-55', 1, '(11) 7777-8888', 'contato@industriaabc.com', 'Fernando Compras', '2024-06-01 10:00:00', 'ATIVO', 50000.00);

-- Inserindo Tipo de Carga
INSERT INTO tipo_carga (nome, descricao, codigo_classificacao, requer_refrigeracao, perigosa, fragil, perecivel, exige_licenca_especial)
VALUES ('Alimentos Perecíveis', 'Produtos alimentícios que necessitam refrigeração', 'TP001', TRUE, FALSE, TRUE, TRUE, FALSE);

-- Inserindo Carga
INSERT INTO carga (cliente_id, tipo_carga_id, descricao, peso_kg, volume_m3, valor_declarado, valor_frete, seguro, valor_seguro, qtde_volumes, necessita_empilhadeira, status_carga, data_registro)
VALUES (1, 1, 'Carregamento de frutas e verduras', 500.000, 3.500, 5000.00, 800.00, TRUE, 250.00, 10, FALSE, 'REGISTRADA', '2025-01-20 09:00:00');

-- Inserindo Volume
INSERT INTO volume (carga_id, codigo_barras, sequencial, tipo_embalagem, peso_kg, altura_cm, largura_cm, comprimento_cm, empilhavel, quantidade_itens, status_volume)
VALUES (1, '789123456789', 1, 'CAIXA', 50.000, 40.00, 60.00, 80.00, TRUE, 1, 'REGISTRADO');

-- Inserindo Ordem de Transporte
INSERT INTO ordem_transporte (codigo_ordem, cliente_id, tipo_servico, prioridade, data_solicitacao, data_prevista_execucao, horario_inicio_previsto, status_ordem, solicitante_nome, solicitante_contato, valor_total, forma_pagamento)
VALUES ('OT-2025-001', 1, 'COLETA E ENTREGA', 'NORMAL', '2025-01-20 09:00:00', '2025-01-21', '08:00:00', 'REGISTRADA', 'Fernando Compras', '(11) 7777-8888', 800.00, 'Faturado');

-- Inserindo Item Ordem de Transporte
INSERT INTO item_ordem_transporte (ordem_id, carga_id, endereco_origem_id, endereco_destino_id, data_coleta_prevista, data_entrega_prevista, status_item, responsavel_origem, responsavel_destino)
VALUES (1, 1, 1, 1, '2025-01-21 08:00:00', '2025-01-21 14:00:00', 'PENDENTE', 'Expedição', 'Recebimento');

-- Inserindo Rota de Carga
INSERT INTO rota_carga (codigo_rota, descricao, tipo_rota, cidade_origem, uf_origem, cidade_destino, uf_destino, distancia_km, tempo_estimado_horas, pedagios, status_rota)
VALUES ('RC-001', 'São Paulo - Campinas', 'INTERMUNICIPAL', 'São Paulo', 'SP', 'Campinas', 'SP', 95.00, 1.50, 2, 'ATIVA');

-- Inserindo Trecho de Rota de Carga
INSERT INTO trecho_rota_carga (rota_carga_id, sequencia, ponto_origem, ponto_destino, distancia_km, tempo_estimado_minutos, tipo_via, condicao_via, pedagio, valor_pedagio)
VALUES (1, 1, 'São Paulo - Marginal Tietê', 'Campinas - Via Anhanguera', 95.00, 90, 'RODOVIA', 'BOA', TRUE, 25.60);

-- Inserindo Operação de Carga
INSERT INTO operacao_carga (ordem_transporte_id, rota_carga_id, veiculo_id, motorista_id, data_inicio, km_inicial, status_operacao, custo_combustivel, custo_pedagio, custo_diaria)
VALUES (1, 1, 3, 3, '2025-01-21 08:00:00', 18000, 'PLANEJADA', 250.00, 51.20, 150.00);

-- Inserindo Ocorrência de Operação
INSERT INTO ocorrencia_operacao (operacao_id, tipo_ocorrencia, data_hora, localizacao, coordenada_latitude, coordenada_longitude, descricao, tempo_parada_minutos, responsavel, providencias_tomadas, status)
VALUES (1, 'CONDICAO CLIMATICA', '2025-01-21 10:30:00', 'Rodovia Anhanguera Km 45', -23.2500000, -46.8500000, 'Chuva forte causando redução de velocidade', 15, 'João da Silva', 'Redução de velocidade e aumento da distância de segurança', 'RESOLVIDA');

-- =====================================================
-- MÓDULO: MONITORAMENTO E SEGURANÇA
-- =====================================================

-- Inserindo Veículo GPS
INSERT INTO veiculo_gps (veiculo_id, dispositivo_id, modelo_dispositivo, chip_numero, operadora, data_instalacao, intervalo_transmissao_segundos, status, ultima_manutencao)
VALUES (1, 'GPS001', 'Tracker Pro 5000', '11987654321', 'Vivo', '2024-01-15', 30, 'ATIVO', '2024-12-01');

-- Inserindo Rastreamento GPS
INSERT INTO rastreamento_gps (veiculo_gps_id, data_hora, latitude, longitude, altitude, velocidade, direcao, ignicao_ligada, hodometro, nivel_combustivel, temperatura_motor, parado_tempo_segundos, sinal_gsm, precisao_metros, satelites)
VALUES (1, '2025-01-20 08:30:00', -23.5613900, -46.6565900, 750.00, 45.00, 90, TRUE, 45015.00, 85.00, 85.00, 0, 25, 5.00, 8);

-- Inserindo Evento GPS
INSERT INTO evento_gps (tipo_evento, veiculo_gps_id, data_hora, latitude, longitude, velocidade, descricao, criticidade, resolvido)
VALUES ('PARTIDA', 1, '2025-01-20 06:00:00', -23.5613900, -46.6565900, 0.00, 'Veículo iniciou operação', 'BAIXA', TRUE);

-- Inserindo Cerca Eletrônica
INSERT INTO cerca_eletronica (nome, tipo_cerca, raio_metros, coordenadas, referencia, tipo_alerta, status, data_inicio_vigencia, dias_semana)
VALUES ('Cerca Garagem Central', 'CIRCULAR', 500, '-23.5613900,-46.6565900', 'Garagem Central', 'SAIDA', 'ATIVA', '2024-01-01 00:00:00', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado,Domingo');

-- Inserindo Veículo Cerca
INSERT INTO veiculo_cerca (cerca_id, veiculo_id)
VALUES (1, 1);

-- =====================================================
-- MÓDULO: GESTÃO DE OPERAÇÕES
-- =====================================================

-- Inserindo Terminal
INSERT INTO terminal (codigo, nome, tipo_terminal, endereco_id, capacidade_veiculos, capacidade_passageiros, area_total_m2, horario_funcionamento_inicio, horario_funcionamento_fim, qtde_plataformas, qtde_bilheterias, qtde_sanitarios, acessibilidade, wifi, estacionamento, praca_alimentacao, latitude, longitude)
VALUES ('TERM001', 'Terminal Jabaquara', 'URBANO', 3, 30, 5000, 15000.00, '04:00:00', '00:30:00', 15, 5, 8, TRUE, TRUE, TRUE, TRUE, -23.6360000, -46.6430000);

-- Inserindo Cameras
INSERT INTO camera (veiculo_id, codigo, posicao, tipo, resolucao, fabricante, modelo, data_instalacao, status, armazenamento_dias, angulo_cobertura, visao_noturna, deteccao_movimento)
VALUES 
(1, 'CAM001', 'Frontal Interna', 'IP', '1080p', 'Hikvision', 'DS-2CD2143G0', '2024-01-15', 'ATIVA', 30, 120, TRUE, TRUE),
(1, 'CAM002', 'Traseira Interna', 'IP', '1080p', 'Hikvision', 'DS-2CD2143G0', '2024-01-15', 'ATIVA', 30, 120, TRUE, TRUE),
(1, 'CAM003', 'Lateral Direita', 'IP', '720p', 'Intelbras', 'VIP 1220', '2024-01-15', 'ATIVA', 30, 90, TRUE, TRUE);

-- Inserindo Gravação
INSERT INTO gravacao (camera_id, data_hora_inicio, data_hora_fim, duracao_segundos, tamanho_mb, caminho_arquivo, gatilho, retencao_dias, marcada_relevante)
VALUES (1, '2025-01-20 06:00:00', '2025-01-20 14:00:00', 28800, 5120.00, '/storage/recordings/2025/01/20/CAM001_060000.mp4', 'AUTOMATICO', 30, FALSE);

-- Inserindo Incidente de Segurança
INSERT INTO incidente_seguranca (tipo_incidente, data_hora, veiculo_id, linha_id, descricao, gravidade, status, bo_registrado)
VALUES ('ACIDENTE', '2025-01-15 16:30:00', 1, 1, 'Colisão leve no trânsito sem vítimas', 'MEDIA', 'SOLUCIONADO', TRUE);

-- Inserindo Ocorrência de Veículo
INSERT INTO ocorrencia_veiculo (veiculo_id, motorista_id, data_hora, tipo_ocorrencia, localizacao_latitude, localizacao_longitude, descricao, gravidade, status, acao_tomada, tempo_resolucao_minutos)
VALUES (1, 1, '2025-01-18 10:00:00', 'FALHA MECANICA', -23.5613900, -46.6565900, 'Problema no sistema de freios', 'ALTA', 'RESOLVIDA', 'Veículo encaminhado para manutenção emergencial', 180);

-- =====================================================
-- MÓDULO: CONTROLE DE QUALIDADE
-- =====================================================

-- Inserindo Indicador de Desempenho
INSERT INTO indicador_desempenho (codigo, nome, descricao, unidade_medida, formula, tipo_indicador, periodicidade, meta_valor, limite_inferior, limite_superior, peso_avaliacao, ativo)
VALUES ('IND001', 'IPK - Índice de Passageiros por Quilômetro', 'Mede a quantidade média de passageiros transportados por quilômetro rodado', 'Passageiros/Km', 'Total de passageiros / Total de quilômetros rodados', 'OPERACIONAL', 'MENSAL', 2.50, 2.00, 3.00, 5, TRUE);

-- Inserindo Medição de Indicador
INSERT INTO medicao_indicador (indicador_id, periodo_inicio, periodo_fim, valor_medido, meta_periodo, percentual_atingimento, status_medicao, observacoes, registrado_por)
VALUES (1, '2025-01-01', '2025-01-31', 2.35, 2.50, 94.00, 'ABAIXO META', 'Resultado abaixo da meta, porém dentro do limite aceitável', 1);

-- Inserindo Pesquisa de Satisfação
INSERT INTO pesquisa_satisfacao (titulo, descricao, data_inicio, data_fim, publico_alvo, tipo_pesquisa, status, quantidade_questoes, quantidade_respondentes, nota_media, responsavel_id)
VALUES ('Pesquisa de Satisfação - Janeiro 2025', 'Avaliação da qualidade dos serviços de transporte', '2025-01-01', '2025-01-31', 'PASSAGEIROS', 'ONLINE', 'FINALIZADA', 10, 1500, 4.2, 1);

-- Inserindo Questão de Pesquisa
INSERT INTO questao_pesquisa (pesquisa_id, texto_questao, tipo_questao, obrigatoria, ordem, opcoes, peso_questao)
VALUES (1, 'Como você avalia a pontualidade dos ônibus?', 'ESCALA LIKERT', TRUE, 1, 'Muito insatisfeito,Insatisfeito,Neutro,Satisfeito,Muito satisfeito', 1.00);

-- Inserindo Resposta de Pesquisa
INSERT INTO resposta_pesquisa (pesquisa_id, respondente_id, data_resposta, canal, localizacao_resposta, linha_id, veiculo_id, pontuacao_geral, tempo_resposta_segundos, validada)
VALUES (1, 1, '2025-01-15 10:30:00', 'APP', 'Terminal Jabaquara', 1, 1, 4.5, 180, TRUE);

-- Inserindo Detalhe de Resposta de Pesquisa
INSERT INTO detalhe_resposta_pesquisa (resposta_id, questao_id, resposta_texto, resposta_numerica, opcao_selecionada)
VALUES (1, 1, NULL, 4.0, 'Satisfeito');

-- Inserindo Reclamação/Sugestão
INSERT INTO reclamacao_sugestao (tipo, data_registro, passageiro_id, nome_manifestante, contato, assunto, descricao, linha_id, veiculo_id, motorista_id, data_ocorrencia, hora_ocorrencia, local_ocorrencia, status, prioridade, prazo_resposta_dias)
VALUES ('RECLAMACAO', '2025-01-18 14:30:00', 1, 'Maria Santos', '(11) 91234-5678', 'Atraso no horário', 'Ônibus atrasou 20 minutos no ponto de embarque', 1, 1, 1, '2025-01-18', '07:15:00', 'Terminal Jabaquara', 'REGISTRADA', 'MEDIA', 5);

-- Inserindo Acompanhamento de Manifestação
INSERT INTO acompanhamento_manifestacao (manifestacao_id, data_acompanhamento, tipo_acompanhamento, responsavel_id, descricao, visivel_manifestante, resposta_enviada, canal_resposta)
VALUES (1, '2025-01-19 09:00:00', 'ANALISE', 1, 'Manifestação recebida e encaminhada para análise do departamento operacional', TRUE, TRUE, 'EMAIL');

-- Inserindo Auditoria Interna
INSERT INTO auditoria_interna (codigo_auditoria, tipo_auditoria, data_inicio, data_fim, auditor_responsavel, setor_auditado, objetivo, escopo, status, qtde_nao_conformidades, qtde_observacoes, qtde_recomendacoes, nota_geral, proxima_auditoria_data)
VALUES ('AUD-2025-001', 'OPERACIONAL', '2025-01-10', '2025-01-15', 'Carlos Auditor', 'Operações', 'Verificar conformidade dos processos operacionais', 'Processos de manutenção, escalas e viagens', 'CONCLUIDA', 2, 5, 3, 8.5, '2025-07-10');

-- Inserindo Não Conformidade
INSERT INTO nao_conformidade (auditoria_id, data_registro, tipo_nc, descricao, area_responsavel, responsavel_id, causa_raiz, prazo_correcao, status)
VALUES (1, '2025-01-15 14:00:00', 'MENOR', 'Falta de registro de calibragem de pneus em 3 veículos', 'Manutenção', 1, 'Falha no processo de documentação', '2025-02-15', 'EM CORRECAO');

-- Inserindo Ação Corretiva/Preventiva
INSERT INTO acao_corretiva_preventiva (nao_conformidade_id, tipo_acao, descricao, responsavel_id, data_inicio, prazo_conclusao, status)
VALUES (1, 'CORRETIVA', 'Implementar checklist obrigatório de calibragem com registro digital', 1, '2025-01-20', '2025-02-15', 'EM ANDAMENTO');

-- Inserindo Integração Modal
INSERT INTO integracao_modal (terminal_id, modal_principal, modal_integrado, tempo_integracao_minutos, distancia_integracao_metros, gratuidade, horario_inicio, horario_fim, dias_funcionamento)
VALUES (1, 'ONIBUS URBANO', 'METRO', 120, 150, TRUE, '05:00:00', '00:00:00', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado,Domingo');

-- Inserindo Área de Aluguel Terminal
INSERT INTO area_aluguel_terminal (terminal_id, identificacao, tipo_area, area_m2, valor_aluguel, ocupado, locatario_atual, cnpj_locatario, inicio_contrato, fim_contrato, valor_condominio)
VALUES (1, 'Loja 01', 'LOJA', 25.00, 2500.00, TRUE, 'Café Expresso Ltda', '33.444.555/0001-66', '2024-01-01', '2026-12-31', 500.00);

-- Inserindo Guia Turístico
INSERT INTO guia_turistico (nome, registro_embratur, cpf, telefone, email, idiomas, especializacao, disponibilidade, valor_hora, status)
VALUES ('Ana Paula Costa', 'GUIA-2024-001', '111.222.333-44', '(11) 99999-8888', 'ana.guia@email.com', 'Português,Inglês,Espanhol', 'Cultural,Histórico', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado,Domingo', 150.00, 'ATIVO');

-- Inserindo Roteiro Turístico
INSERT INTO roteiro_turistico (nome, descricao, duracao_horas, preco_adulto, preco_crianca, preco_idoso, pontos_visitados, nivel_dificuldade, acessibilidade, tipo_roteiro, dias_disponivel, horario_inicio, horario_fim, status)
VALUES ('City Tour São Paulo', 'Passeio pelos principais pontos turísticos de São Paulo', 4.0, 120.00, 60.00, 90.00, 'MASP, Avenida Paulista, Parque Ibirapuera, Centro Histórico', 'FACIL', TRUE, 'Cultural,Histórico', 'Terça,Quarta,Quinta,Sexta,Sábado,Domingo', '09:00:00', '13:00:00', 'ATIVO');

-- Inserindo Ponto Turístico
INSERT INTO ponto_turistico (nome, tipo_atracao, endereco_id, descricao, horario_funcionamento, preco_entrada, entrada_gratuita, tempo_medio_visita_minutos, acessibilidade, estacionamento, telefone, classificacao, latitude, longitude)
VALUES ('MASP - Museu de Arte de São Paulo', 'CULTURAL', 1, 'Principal museu de arte do Brasil', 'Terça a Domingo, 10h às 18h', 50.00, FALSE, 120, TRUE, TRUE, '(11) 3149-5959', 4.8, -23.5613900, -46.6558900);

-- Inserindo Excursão
INSERT INTO excursao (roteiro_id, data_saida, hora_saida, data_retorno, hora_retorno, veiculo_id, motorista_id, guia_id, vagas_totais, vagas_disponiveis, preco, status, local_saida, local_retorno)
VALUES (1, '2025-02-15', '09:00:00', '2025-02-15', '13:00:00', 1, 1, 1, 40, 15, 120.00, 'CONFIRMADA', 'Terminal Jabaquara', 'Terminal Jabaquara');

-- Inserindo Participante de Excursão
INSERT INTO participante_excursao (excursao_id, passageiro_id, nome, documento, telefone, email, tipo_passageiro, valor_pago, forma_pagamento, assento_reservado, check_in)
VALUES (1, 1, 'Maria Santos', '12.345.678-9', '(11) 91234-5678', 'maria.santos@email.com', 'ADULTO', 120.00, 'PIX', 'A12', TRUE);

-- Inserindo Ponto Roteiro
INSERT INTO ponto_roteiro (roteiro_id, ponto_turistico_id, ordem_visita, tempo_permanencia_minutos, horario_previsto)
VALUES (1, 1, 1, 60, '09:30:00');

-- Inserindo Evento Especial
INSERT INTO evento_especial (nome, descricao, data_inicio, data_fim, hora_inicio, hora_fim, endereco_id, tipo_evento, publico_estimado, impacto_transporte, plano_contingencia, operacao_especial, status)
VALUES ('São Paulo Fashion Week', 'Semana de moda de São Paulo', '2025-03-10', '2025-03-15', '14:00:00', '23:00:00', 1, 'CULTURAL', 50000, 'ALTO', TRUE, TRUE, 'PROGRAMADO');

-- Inserindo Planejamento de Evento
INSERT INTO planejamento_evento (evento_id, tipo_planejamento, descricao, horario_inicio, horario_fim, qtde_veiculos_adicional, qtde_funcionarios_adicional, custo_estimado, responsavel_id, status_aprovacao)
VALUES (1, 'AUMENTO FROTA', 'Reforço de 10 veículos adicionais para atender aumento de demanda', '14:00:00', '00:00:00', 10, 20, 15000.00, 1, 'APROVADO');

-- =====================================================
-- MÓDULO: GESTÃO ADMINISTRATIVA E FINANCEIRA
-- =====================================================

-- Inserindo Fornecedor
INSERT INTO fornecedor (razao_social, nome_fantasia, cnpj, inscricao_estadual, endereco_id, telefone_principal, email, website, ramo_atividade, produtos_servicos, contato_nome, contato_telefone, contato_email, status, avaliacao)
VALUES ('Distribuidora de Peças Brasil Ltda', 'Peças Brasil', '44.555.666/0001-77', '987.654.321.012', 2, '(11) 8888-9999', 'vendas@pecasbrasil.com', 'www.pecasbrasil.com', 'Autopeças', 'Fornecimento de peças para veículos pesados', 'Ricardo Vendas', '(11) 98888-9999', 'ricardo@pecasbrasil.com', 'ATIVO', 5);

-- Inserindo Contrato
INSERT INTO contrato (numero_contrato, tipo_contrato, parte_contratada_id, objeto, valor_total, data_assinatura, data_inicio, data_termino, renovacao_automatica, periodo_renovacao_meses, status, responsavel_interno_id)
VALUES ('CONT-2024-001', 'FORNECIMENTO', 1, 'Fornecimento de peças automotivas para manutenção da frota', 150000.00, '2024-01-15', '2024-02-01', '2025-01-31', TRUE, 12, 'EM VIGOR', 1);

-- Inserindo Aditivo Contratual
INSERT INTO aditivo_contratual (contrato_id, numero_aditivo, data_assinatura, tipo_aditivo, nova_data_termino, valor_alterado, justificativa, aprovado_por_id)
VALUES (1, 1, '2024-12-01', 'PRAZO E VALOR', '2026-01-31', 180000.00, 'Aumento da frota e consequente aumento da demanda por peças', 1);

-- Inserindo Ordem de Compra
INSERT INTO ordem_compra (numero_ordem, fornecedor_id, data_emissao, data_entrega_prevista, valor_total, condicao_pagamento, prazo_pagamento_dias, status, tipo_frete, valor_frete, requisitante_id)
VALUES ('OC-2025-001', 1, '2025-01-10', '2025-01-20', 8500.00, '30 dias', 30, 'ENTREGUE', 'CIF', 350.00, 1);

-- Inserindo Item de Ordem de Compra
INSERT INTO item_ordem_compra (ordem_compra_id, produto_id, descricao, quantidade, unidade_medida, valor_unitario, data_entrega_prevista, local_entrega, status)
VALUES (1, 1, 'Filtros de óleo Mann Filter FLT001', 50.000, 'Unidade', 42.00, '2025-01-20', 'Garagem Central', 'ENTREGUE');

-- Inserindo Nota Fiscal
INSERT INTO nota_fiscal (numero_nota, serie, tipo_nota, data_emissao, fornecedor_id, valor_total, valor_produtos, valor_servicos, valor_frete, valor_desconto, valor_impostos, forma_pagamento, chave_nfe, status, ordem_compra_id)
VALUES ('000123', '1', 'ENTRADA', '2025-01-18', 1, 8500.00, 8150.00, 0.00, 350.00, 0.00, 1530.00, 'Faturado 30 dias', '35250112345678000144550010001230001234567890', 'CONFERIDA', 1);

-- Inserindo Item de Nota Fiscal
INSERT INTO item_nota_fiscal (nota_fiscal_id, codigo_produto, descricao, ncm, cfop, quantidade, unidade_medida, valor_unitario, valor_desconto, aliquota_icms, aliquota_ipi, aliquota_pis, aliquota_cofins, cst_icms, cst_ipi, cst_pis, cst_cofins)
VALUES (1, 'FLT001', 'Filtro de óleo Mann Filter', '84212300', '5102', 50.000, 'UN', 42.00, 0.00, 18.00, 0.00, 1.65, 7.60, '000', '99', '01', '01');

-- Inserindo Conta a Pagar
INSERT INTO conta_pagar (fornecedor_id, nota_fiscal_id, descricao, valor, data_emissao, data_vencimento, forma_pagamento, status, centro_custo, conta_contabil, numero_parcela, total_parcelas, valor_pago)
VALUES (1, 1, 'Pagamento NF 000123 - Peças automotivas', 8500.00, '2025-01-18', '2025-02-17', 'Boleto Bancário', 'ABERTA', 'CC001', '2.1.01.001', 1, 1, 0.00);

-- Inserindo Conta a Receber
INSERT INTO conta_receber (cliente_id, descricao, valor, data_emissao, data_vencimento, forma_recebimento, status, centro_receita, conta_contabil, numero_parcela, total_parcelas, valor_recebido)
VALUES (1, 'Frete transporte cargas - Ordem OT-2025-001', 800.00, '2025-01-21', '2025-02-20', 'Boleto Bancário', 'ABERTA', 'CR001', '1.1.02.001', 1, 1, 0.00);

-- Inserindo Centro de Custo
INSERT INTO centro_custo (codigo, nome, descricao, responsavel_id, tipo, ativo, data_criacao, nivel)
VALUES ('CC001', 'Operações', 'Centro de custo do departamento de operações', 1, 'OPERACIONAL', TRUE, '2024-01-01', 1);

-- Inserindo Plano de Contas
INSERT INTO plano_contas (codigo, nome, tipo, natureza, nivel, aceita_lancamentos, data_criacao, ativo)
VALUES ('1.1.01.001', 'Caixa', 'ATIVO', 'DEVEDORA', 4, TRUE, '2024-01-01', TRUE);

-- Inserindo Movimentação Contábil
INSERT INTO movimentacao_contabil (tipo_movimento, data_movimento, valor, conta_debito_id, conta_credito_id, centro_custo_id, numero_documento, descricao, origem_lancamento, usuario_lancamento)
VALUES ('LANCAMENTO', '2025-01-20', 4500.00, 1, 1, 1, 'REC-001', 'Recebimento de tarifa de transporte', 'Sistema Bilhetagem', 1);

-- Inserindo Folha de Pagamento
INSERT INTO folha_pagamento (periodo_referencia, tipo_folha, data_pagamento, quantidade_funcionarios, valor_total_bruto, valor_total_descontos, valor_total_liquido, status, responsavel_calculo_id)
VALUES ('2025-01', 'NORMAL', '2025-02-05', 1, 3500.00, 875.00, 2625.00, 'CALCULADA', 1);

-- Inserindo Pagamento de Funcionário
INSERT INTO pagamento_funcionario (folha_id, funcionario_id, salario_base, horas_normais, valor_horas_normais, horas_extras, valor_horas_extras, adicional_noturno_horas, valor_adicional_noturno, inss, irrf, fgts, vale_transporte, vale_refeicao, plano_saude, valor_total_bruto, valor_total_descontos, valor_liquido, conta_bancaria, forma_pagamento, status)
VALUES (1, 1, 3500.00, 176.00, 3500.00, 0.00, 0.00, 0.00, 0.00, 385.00, 150.00, 280.00, 132.00, 400.00, 0.00, 3500.00, 875.00, 2625.00, '12345-6 / AG 0001', 'DEPOSITO', 'CALCULADO');

-- Inserindo Orçamento
INSERT INTO orcamento (ano, mes, centro_custo_id, conta_id, valor_previsto, valor_realizado, status, responsavel_id, aprovador_id, data_aprovacao)
VALUES (2025, 1, 1, 1, 50000.00, 35000.00, 'EM EXECUCAO', 1, 1, '2024-12-15');

-- =====================================================
-- MÓDULO: RECURSOS HUMANOS
-- =====================================================

-- Inserindo Treinamento
INSERT INTO treinamento (titulo, descricao, tipo_treinamento, carga_horaria_total, area_conhecimento, instituicao, instrutor, custo_por_participante, certificado, data_inicio, data_fim, horario, local_realizacao, publico_alvo, status, avaliacao_media)
VALUES ('Direção Defensiva para Motoristas', 'Curso de direção defensiva e primeiros socorros', 'PRESENCIAL', 16, 'Segurança no Trânsito', 'SENAI', 'José Instrutor', 350.00, TRUE, '2025-02-10', '2025-02-11', '08:00 às 17:00', 'Garagem Central - Sala de Treinamento', 'Motoristas', 'PLANEJADO', NULL);

-- Inserindo Participante de Treinamento
INSERT INTO participante_treinamento (treinamento_id, funcionario_id, data_inscricao, aprovado_por_id, status_participacao)
VALUES (1, 1, '2025-01-20', 1, 'CONFIRMADO');

-- Inserindo Exame Médico
INSERT INTO exame_medico (funcionario_id, tipo_exame, data_realizacao, data_validade, medico_responsavel, crm_medico, clinica, resultado, status)
VALUES (1, 'PERIODICO', '2025-01-10', '2026-01-10', 'Dr. Paulo Medicina', 'CRM 123456', 'Clínica Saúde Total', 'APTO', 'AVALIADO');

-- Inserindo Documento de Funcionário
INSERT INTO documento_funcionario (funcionario_id, tipo_documento, numero_documento, data_emissao, data_validade, orgao_emissor, descricao, nome_arquivo, tipo_arquivo, data_upload)
VALUES (1, 'CNH', '12345678901', '2020-01-15', '2030-01-15', 'DETRAN-SP', 'Carteira Nacional de Habilitação categoria D', 'cnh_joao_silva.pdf', 'application/pdf', '2025-01-05 10:00:00');

-- Inserindo Dependente
INSERT INTO dependente (funcionario_id, nome, data_nascimento, parentesco, cpf, sexo, ir_beneficiario, plano_saude_beneficiario, salario_familia)
VALUES (1, 'Pedro da Silva', '2015-03-20', 'FILHO(A)', '555.666.777-88', 'MASCULINO', TRUE, TRUE, TRUE);

-- Inserindo Habilidade de Funcionário
INSERT INTO habilidade_funcionario (funcionario_id, habilidade, nivel, certificado, data_certificacao, instituicao_certificadora, anos_experiencia)
VALUES (1, 'Condução de Ônibus Articulado', 'AVANCADO', TRUE, '2022-05-15', 'SENAI Transportes', 8);

-- Inserindo Férias
INSERT INTO ferias (funcionario_id, periodo_aquisitivo_inicio, periodo_aquisitivo_fim, data_inicio_gozo, data_fim_gozo, qtde_dias_gozo, qtde_dias_abono, valor_ferias, valor_abono, valor_1terco, data_pagamento, status, aprovado_por_id, data_aprovacao)
VALUES (1, '2024-01-10', '2025-01-09', '2025-07-01', '2025-07-30', 30, 0, 3500.00, 0.00, 1166.67, '2025-06-20', 'PROGRAMADA', 1, '2025-01-15');

-- Inserindo Advertência/Suspensão
INSERT INTO advertencia_suspensao (funcionario_id, tipo, data_ocorrencia, motivo, descricao_detalhada, gestor_responsavel_id, ciencia_funcionario, data_ciencia, registrado_por_id)
VALUES (1, 'ADVERTENCIA VERBAL', '2024-11-15', 'Atraso não justificado', 'Funcionário chegou 30 minutos atrasado sem justificativa prévia', 1, TRUE, '2024-11-15', 1);

-- Inserindo Avaliação de Desempenho
INSERT INTO avaliacao_desempenho (funcionario_id, avaliador_id, periodo_referencia, tipo_avaliacao, data_avaliacao, nota_geral, produtividade, qualidade, assiduidade, pontualidade, relacionamento, conhecimento_tecnico, iniciativa, comunicacao, comprometimento, pontos_fortes, pontos_melhoria, plano_desenvolvimento, status)
VALUES (1, 1, '2024-12', 'PERIODICA', '2025-01-05', 8.5, 9.0, 8.5, 8.0, 7.5, 9.0, 8.5, 8.0, 8.5, 9.0, 'Excelente relacionamento com passageiros e colegas, alta produtividade', 'Melhorar pontualidade', 'Participar de treinamento de gestão de tempo', 'CONCLUIDA');

-- Inserindo Requisição de Pessoal
INSERT INTO requisicao_pessoal (solicitante_id, data_solicitacao, departamento_id, cargo_id, quantidade, tipo_contratacao, motivo, perfil_desejado, atividades, requisitos_obrigatorios, faixa_salarial_min, faixa_salarial_max, prazo_contratacao, status)
VALUES (1, '2025-01-10 09:00:00', 1, 1, 2, 'CLT', 'AUMENTO QUADRO', 'Motorista experiente com CNH categoria D', 'Condução de ônibus urbano, atendimento ao público', 'CNH D válida, experiência mínima de 2 anos', 3200.00, 4000.00, '2025-03-01', 'APROVADA');

-- =====================================================
-- MÓDULO: OUTROS (SISTEMA, SEGURANÇA, CONFIGURAÇÕES)
-- =====================================================

-- Inserindo Perfil de Acesso
INSERT INTO perfil_acesso (nome, descricao, nivel_acesso, ativo, data_criacao, padrao_sistema)
VALUES 
('Administrador', 'Perfil com acesso total ao sistema', 10, TRUE, '2024-01-01 00:00:00', TRUE),
('Operador', 'Perfil para operadores do sistema', 5, TRUE, '2024-01-01 00:00:00', TRUE),
('Visualizador', 'Perfil apenas para consultas', 2, TRUE, '2024-01-01 00:00:00', TRUE);

-- Inserindo Usuário
INSERT INTO usuario (username, senha_hash, nome_completo, email, funcionario_id, perfil_id, data_criacao, status, trocar_senha_proximo_login)
VALUES ('joao.silva', '$2y$10$abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGH', 'João da Silva', 'joao.silva@sinatrans.com', 1, 1, '2024-01-10 10:00:00', 'ATIVO', FALSE);

-- Inserindo Permissão
INSERT INTO permissao (codigo, nome, descricao, modulo, tipo, padrao_sistema)
VALUES ('VEI_CONSULTA', 'Consultar Veículos', 'Permite consultar informações de veículos', 'Veículos', 'CONSULTA', TRUE);

-- Inserindo Permissão de Perfil
INSERT INTO permissao_perfil (perfil_id, permissao_id, concedida_por_id, data_concessao)
VALUES (1, 1, 1, '2024-01-10 10:30:00');

-- Inserindo Log do Sistema
INSERT INTO log_sistema (usuario_id, data_hora, tipo_acao, modulo, tabela_afetada, registro_id, descricao, ip_origem, status, tempo_execucao_ms)
VALUES (1, '2025-01-20 08:00:00', 'LOGIN', 'Autenticação', NULL, NULL, 'Usuário realizou login no sistema', '192.168.1.100', 'SUCESSO', 125);

-- Inserindo Configuração do Sistema
INSERT INTO configuracao_sistema (chave, valor, tipo_dado, descricao, categoria, nivel_acesso, alteravel_usuario, valor_padrao)
VALUES ('SISTEMA_NOME', 'SINATRANS - Sistema Nacional de Transporte', 'STRING', 'Nome do sistema exibido na interface', 'Geral', 'ADMINISTRADOR', TRUE, 'SINATRANS - Sistema Nacional de Transporte');

-- Inserindo Notificação
INSERT INTO notificacao (usuario_id, tipo_notificacao, titulo, mensagem, data_criacao, data_expiracao, nivel_urgencia, requer_acao, requer_confirmacao, origem_sistema)
VALUES (1, 'ALERTA', 'CNH Próxima do Vencimento', 'Sua CNH vence em 30 dias. Providencie a renovação.', '2025-01-20 08:00:00', '2025-02-20 23:59:59', 'ALTA', TRUE, FALSE, 'Módulo RH');

-- Inserindo Documento do Sistema
INSERT INTO documento_sistema (titulo, tipo_documento, categoria, codigo_referencia, versao, data_criacao, responsavel_id, status, nome_arquivo, tipo_arquivo, restrito)
VALUES ('Manual do Usuário - SINATRANS', 'MANUAL', 'Documentação Técnica', 'DOC-2024-001', '1.0', '2024-01-15', 1, 'PUBLICADO', 'manual_usuario_v1.pdf', 'application/pdf', FALSE);

-- Inserindo Relatório Salvo
INSERT INTO relatorio_salvo (nome, descricao, tipo_relatorio, parametros, formato_saida, agendamento, frequencia_agendamento, criado_por_id, data_criacao, compartilhado, favorito)
VALUES ('Relatório de Viagens Mensal', 'Relatório consolidado de todas as viagens realizadas no mês', 'Operacional', '{"periodo":"mensal","incluir_graficos":true}', 'PDF', TRUE, 'MENSAL', 1, '2024-06-15 10:00:00', TRUE, TRUE);

-- Inserindo Alerta Programado
-- TABELA alerta_programado NÃO EXISTE - INSERTS COMENTADOS
-- INSERT INTO alerta_programado (nome, descricao, tipo_alerta, data_referencia_campo, tabela_monitorada, dias_antecedencia, destinatarios_ids, template_mensagem, assunto_email, ativo, criado_por_id, data_criacao)
-- VALUES 
-- ('Alerta de Vencimento de CNH', 'Notifica motoristas sobre vencimento da CNH', 'VENCIMENTO', 'validade_cnh', 'motorista', 30, '1', 'Sua CNH vence em {dias} dias. Data de vencimento: {data_vencimento}', 'Alerta: CNH próxima do vencimento', TRUE, 1, '2024-01-15 00:00:00'),
-- ('Alerta de Manutenção Preventiva', 'Notifica sobre veículos próximos da quilometragem de manutenção', 'MANUTENCAO', 'quilometragem_atual', 'veiculo', 7, '1', 'Veículo {placa} atingirá em breve a quilometragem de manutenção preventiva', 'Alerta: Manutenção preventiva programada', TRUE, 1, '2024-01-15 00:00:00');

-- =====================================================
-- INSERTS ADICIONAIS PARA TABELAS IMPORTANTES
-- =====================================================

-- Inserindo mais dados para Ponto Turistico (tabela sem insert)
INSERT INTO ponto_turistico (nome, tipo_atracao, endereco_id, descricao, horario_funcionamento, preco_entrada, entrada_gratuita, tempo_medio_visita_minutos, acessibilidade, estacionamento, telefone, classificacao, latitude, longitude)
VALUES 
('Parque Ibirapuera', 'LAZER', 1, 'Principal parque urbano de São Paulo', 'Diariamente, 05h às 00h', 0.00, TRUE, 180, TRUE, TRUE, '(11) 5574-5045', 4.7, -23.5873500, -46.6579200),
('Catedral da Sé', 'RELIGIOSO', 1, 'Principal catedral católica de São Paulo', 'Diariamente, 08h às 18h', 0.00, TRUE, 60, TRUE, FALSE, '(11) 3107-6832', 4.6, -23.5505199, -46.6333094);

-- Inserindo mais Rotas de Carga
INSERT INTO rota_carga (codigo_rota, descricao, tipo_rota, cidade_origem, uf_origem, cidade_destino, uf_destino, distancia_km, tempo_estimado_horas, pedagios, status_rota)
VALUES 
('RC-002', 'São Paulo - Santos', 'INTERMUNICIPAL', 'São Paulo', 'SP', 'Santos', 'SP', 72.00, 1.20, 3, 'ATIVA'),
('RC-003', 'São Paulo - Rio de Janeiro', 'INTERESTADUAL', 'São Paulo', 'SP', 'Rio de Janeiro', 'RJ', 429.00, 5.50, 7, 'ATIVA');

-- Inserindo Integrações Modais
INSERT INTO integracao_modal (terminal_id, modal_principal, modal_integrado, tempo_integracao_minutos, distancia_integracao_metros, gratuidade, horario_inicio, horario_fim, dias_funcionamento)
VALUES 
(1, 'ONIBUS URBANO', 'METRO', 120, 150, TRUE, '05:00:00', '00:00:00', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado,Domingo'),
(1, 'ONIBUS URBANO', 'TREM', 120, 200, TRUE, '05:00:00', '00:00:00', 'Segunda,Terça,Quarta,Quinta,Sexta,Sábado,Domingo');

-- Inserindo Evento Especial (sem insert original)
INSERT INTO evento_especial (nome, descricao, data_inicio, data_fim, hora_inicio, hora_fim, endereco_id, tipo_evento, publico_estimado, impacto_transporte, plano_contingencia, operacao_especial, status)
VALUES 
('Carnaval de Rua 2025', 'Blocos de carnaval nas ruas de São Paulo', '2025-02-28', '2025-03-04', '10:00:00', '22:00:00', 1, 'CULTURAL', 500000, 'CRITICO', TRUE, TRUE, 'PROGRAMADO'),
('Jogo do Corinthians - Final', 'Final do campeonato paulista', '2025-04-20', '2025-04-20', '16:00:00', '22:00:00', 1, 'ESPORTIVO', 40000, 'ALTO', TRUE, TRUE, 'PROGRAMADO');

-- =====================================================
-- FIM DOS INSERTS
-- =====================================================