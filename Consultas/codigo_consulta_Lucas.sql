-- ===================================================================
-- 1. LIMPEZA (Para poder re-executar o script)
-- (Ordem inversa da criação por causa das Foreign Keys)
-- ===================================================================
-- Desabilita a verificação de FK temporariamente para limpar
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE TABLE SINATRANS.parada_rota;
TRUNCATE TABLE SINATRANS.rota;
TRUNCATE TABLE SINATRANS.parada;
TRUNCATE TABLE SINATRANS.linha_transporte;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO 
    SINATRANS.linha_transporte (id_linha, codigo_linha, nome, tipo_linha, origem, destino, status) 
VALUES
    (10, 'L-10', 'Linha 10 - Centro/Leste', 'Urbana', 'Terminal Central', 'Terminal Leste', 'Ativa'),
    (20, 'L-20', 'Linha 20 - Leste/Norte', 'Urbana', 'Terminal Leste', 'Terminal Norte', 'Ativa'),
    (30, 'L-30', 'Linha 30 - Circular Centro', 'Circular', 'Terminal Central', 'Terminal Central', 'Ativa');


INSERT INTO 
    SINATRANS.parada (id_parada, codigo_parada, nome, tipo_parada, coordenada_latitude, coordenada_longitude, status) 
VALUES

    -- Nossos Terminais (IDs 1, 2, 3)
    (1, 'T-CENTRAL', 'Terminal Central', 'Terminal', -8.0, -35.0, 'Ativa'),
    (2, 'T-LESTE', 'Terminal Leste', 'Terminal', -8.1, -35.1, 'Ativa'),
    (3, 'T-NORTE', 'Terminal Norte', 'Rodoviária', -8.2, -35.2, 'Ativa'),

    -- Nossas Paradas Comuns (IDs 4, 5, 6)
    (4, 'P-FLORES', 'Parada Rua das Flores', 'Ponto de ônibus', -8.3, -35.3, 'Ativa'),
    (5, 'P-AVPRIN', 'Parada Av. Principal', 'Ponto de ônibus', -8.4, -35.4, 'Ativa'),
    (6, 'P-MATRIZ', 'Parada Praça da Matriz', 'Ponto de ônibus', -8.5, -35.5, 'Ativa');


INSERT INTO 
    SINATRANS.rota (id_rota, linha_id, nome, sentido) 
VALUES
    (101, 10, 'Rota 101 (Ida - Central > Leste)', 'Ida'),
    (102, 20, 'Rota 102 (Ida - Leste > Norte)', 'Ida'),
    (201, 10, 'Rota 201 (Volta - Leste > Central)', 'Volta'),
    (301, 30, 'Rota 301 (Circular Centro)', 'Circular');


INSERT INTO 
    SINATRANS.parada_rota (rota_id, parada_id, ordem_sequencial) 
VALUES
    -- Rota 101: T-CENTRAL (1) -> P-FLORES (4) -> T-LESTE (2)
    (101, 1, 1), -- Início no Terminal Central
    (101, 4, 2), -- Passa pela Rua Flores
    (101, 2, 3), -- Fim no Terminal Leste

    -- Rota 102: T-LESTE (2) -> P-AVPRIN (5) -> P-MATRIZ (6) -> T-NORTE (3)
    (102, 2, 1), -- Início no Terminal Leste
    (102, 5, 2), -- Passa pela Av. Principal
    (102, 6, 3), -- Passa pela Praça da Matriz
    (102, 3, 4), -- Fim no Terminal Norte
    
    -- Rota 201 (Volta): T-LESTE (2) -> P-FLORES (4) -> T-CENTRAL (1)
    (201, 2, 1), -- Início no Terminal Leste
    (201, 4, 2), -- Passa pela Rua Flores (mesma parada da Rota 101)
    (201, 1, 3), -- Fim no Terminal Central

    -- Rota 301 (Circular): T-CENTRAL (1) -> P-FLORES (4) -> P-AVPRIN (5) -> T-CENTRAL (1)
    (301, 1, 1), -- Início no Terminal Central
    (301, 4, 2), -- Passa pela Rua Flores
    (301, 5, 3), -- Passa pela Av. Principal
    (301, 1, 4); -- Fim no Terminal Central (o mesmo ID, mas ordem 4)


SET GLOBAL event_scheduler = ON;

SELECT id_rastreamento, veiculo_gps_id, data_hora, latitude, longitude, altitude, velocidade, direcao, ignicao_ligada, hodometro, nivel_combustivel, temperatura_motor, parado_tempo_segundos, sinal_gsm, precisao_metros, satelites, evento_id
FROM SINATRANS.rastreamento_gps
WHERE veiculo_gps_id = 1 and latitude  = -8.05784000;

WITH UltimaLocalizacao AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY veiculo_gps_id ORDER BY data_hora DESC) as rn
    FROM SINATRANS.rastreamento_gps
)
SELECT * FROM UltimaLocalizacao WHERE rn = 1;



CREATE PROCEDURE sp_ArquivarRastreamentoGPS()
BEGIN
    START TRANSACTION;
    
    INSERT INTO SINATRANS.rastreamento_gps_historico 
        (SELECT * FROM rastreamento_gps 
         WHERE data_hora < CURDATE() - INTERVAL 180 DAY);
    
    DELETE FROM SINATRANS.rastreamento_gps 
    WHERE data_hora < CURDATE() - INTERVAL 180 DAY;
    
    COMMIT;
    

END;


CREATE EVENT historico_gps
ON SCHEDULE EVERY 1 DAY
    STARTS (DATE(CURRENT_TIMESTAMP()) + INTERVAL 1 DAY + INTERVAL 3 HOUR)
ON COMPLETION PRESERVE
DO
	CALL sp_ArquivarRastreamentoGPS();
	
 WITH MediaPorPergunta AS (
    SELECT questao_id, AVG(resposta_numerica) as media
    FROM SINATRANS.detalhe_resposta_pesquisa
    GROUP BY questao_id
)
SELECT q.texto_questao, m.media
FROM MediaPorPergunta m
JOIN SINATRANS.questao_pesquisa q ON q.id_questao = m.questao_id;

---------------------------------------------

WITH RECURSIVE ConexoesDeParada (
    parada_origem_id,
    parada_atual_id,
    rota_atual_id,
    nivel,
    caminho
) AS (
    SELECT
        p.id_parada AS parada_origem_id,
        p.id_parada AS parada_atual_id,
        pr.rota_id AS rota_atual_id,
        0 AS nivel,
        CAST(p.codigo_parada AS CHAR(1000)) AS caminho
    FROM
        SINATRANS.parada p
    JOIN 
        SINATRANS.parada_rota pr ON p.id_parada = pr.parada_id
    WHERE
        p.tipo_parada IN ('Terminal', 'Rodoviário', 'Multimodal')


    UNION ALL

    SELECT
        cte.parada_origem_id,
        proxima_parada.parada_id AS parada_atual_id,
        cte.rota_atual_id,
        cte.nivel + 1,
        CONCAT(cte.caminho, ' -> ', p_proxima.codigo_parada)
    FROM
        ConexoesDeParada cte 
    JOIN
        SINATRANS.parada_rota parada_atual ON parada_atual.rota_id = cte.rota_atual_id 
                                AND parada_atual.parada_id = cte.parada_atual_id
    JOIN
        SINATRANS.parada_rota proxima_parada ON proxima_parada.rota_id = parada_atual.rota_id 
                                  AND proxima_parada.ordem_sequencial = parada_atual.ordem_sequencial + 1
    JOIN
        SINATRANS.parada p_proxima ON p_proxima.id_parada = proxima_parada.parada_id
    WHERE
        
        cte.nivel < 50
)
SELECT
    p_origem.nome AS Terminal_Origem,
    p_destino.nome AS Terminal_Destino_Alcancavel,
    r.nome AS Pela_Rota,
    cte.nivel AS Paradas_No_Caminho,
    cte.caminho AS Sequencia_De_Paradas
FROM
    ConexoesDeParada cte
    
JOIN
    SINATRANS.parada p_origem ON cte.parada_origem_id = p_origem.id_parada
    
JOIN
    SINATRANS.parada p_destino ON cte.parada_atual_id = p_destino.id_parada
    
JOIN
    SINATRANS.rota r ON cte.rota_atual_id = r.id_rota
    
WHERE
    p_destino.tipo_parada IN ('Terminal', 'Rodoviário', 'Multimodal')
    AND cte.nivel > 0 
    
ORDER BY
    Terminal_Origem,
    Terminal_Destino_Alcancavel,
    nivel;

---------------------------

DELIMITER $$

CREATE EVENT evt_VerificarContasVencendo
ON SCHEDULE
    EVERY 1 DAY
    STARTS CONCAT(CURDATE(), ' 01:00:00')
DO
BEGIN
    DECLARE v_dias_aviso INT;
    SET v_dias_aviso = 3;

    INSERT INTO SINATRANS.notificacao (
        usuario_id,
        tipo_notificacao,
        titulo,
        mensagem,
        nivel_urgencia,
        url_acao,
        origem_sistema
    )
    SELECT
        u_financeiro.id_usuario,
        'Vencimento',
        'Alerta: Conta a Pagar Vencendo',
        CONCAT(
            'A conta "', cp.descricao, '" (ID: ', cp.id_conta_pagar, ') no valor de R$ ', 
            FORMAT(cp.valor, 2, 'pt_BR'), 
            ' vence em ', DATE_FORMAT(cp.data_vencimento, '%d/%m/%Y'), '.'
        ),
        'Alta',
        CONCAT('app/financeiro/pagar?id=', cp.id_conta_pagar),
        'Eventos_Financeiro'
    FROM
        SINATRANS.conta_pagar cp
    CROSS JOIN
        (SELECT 
            u.id_usuario 
         FROM 
            SINATRANS.usuario u
         JOIN 
            SINATRANS.funcionario f ON u.funcionario_id = f.id_funcionario 
         JOIN 
            SINATRANS.departamento d ON f.departamento_id = d.id_departamento
         WHERE 
            d.nome_departamento = 'Financeiro' 
            ) AS u_financeiro
    WHERE
        cp.status IN ('Aberta', 'Parcialmente paga')
        AND cp.data_vencimento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY);


    INSERT INTO SINATRANS.notificacao (
        usuario_id,
        tipo_notificacao,
        titulo,
        mensagem,
        nivel_urgencia,
        url_acao,
        origem_sistema
    )
    SELECT
        u_financeiro.id_usuario,
        'Vencimento',
        'Alerta: Conta a Receber Vencendo',
        CONCAT(
            'A conta "', cr.descricao, '" (ID: ', cr.id_conta_receber, ') no valor de R$ ', 
            FORMAT(cr.valor, 2, 'pt_BR'), 
            ' vence em ', DATE_FORMAT(cr.data_vencimento, '%d/%m/%Y'), '.'
        ),
        'Média',
        CONCAT('app/financeiro/receber?id=', cr.id_conta_receber),
        'Eventos_Financeiro'
    FROM
        SINATRANS.conta_receber cr
    CROSS JOIN
        (SELECT 
            u.id_usuario 
         FROM 
            SINATRANS.usuario u
         JOIN 
            SINATRANS.funcionario f ON u.funcionario_id = f.id_funcionario
         JOIN 
            SINATRANS.departamento d ON f.departamento_id = d.id_departamento
         WHERE 
            d.nome_departamento = 'Financeiro'
        ) AS u_financeiro
    WHERE
        cr.status IN ('Aberta', 'Parcialmente recebida', 'Em cobrança')
        AND cr.data_vencimento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY);

END$$

DELIMITER ;


---------------------
DELIMITER $$

CREATE EVENT evt_ControlarVencimentosRH
ON SCHEDULE
    EVERY 1 WEEK
    STARTS NEXT_DAY(CURDATE(), 'MONDAY') + INTERVAL '02:00:00' HOUR_SECOND
DO
BEGIN
    DECLARE v_dias_aviso INT;
    SET v_dias_aviso = 30;


    INSERT INTO SINATRANS.notificacao (
        usuario_id, tipo_notificacao, titulo, mensagem, 
        nivel_urgencia, url_acao, origem_sistema
    )
    SELECT
        u_rh.id_usuario,
        'Vencimento',
        'Vencimento de Exame Médico',
        CONCAT(
            'O exame (', em.tipo_exame, ') de ', f.nome, 
            ' (Depto: ', d.nome_departamento, ')',
            ' vence em: ', DATE_FORMAT(em.data_validade, '%d/%m/%Y'), '.'
        ),
        'Alta',
        CONCAT('app/rh/exames?id=', em.id_exame),
        'Eventos_RH'
    FROM
        SINATRANS.exame_medico em
    JOIN
        SINATRANS.funcionario f ON em.funcionario_id = f.id_funcionario
    JOIN
        SINATRANS.departamento d ON f.departamento_id = d.id_departamento
    CROSS JOIN
        (SELECT 
            u.id_usuario 
         FROM 
            SINATRANS.usuario u
         JOIN 
            SINATRANS.funcionario f ON u.funcionario_id = f.id_funcionario
         JOIN 
            SINATRANS.departamento d ON f.departamento_id = d.id_departamento
         WHERE 
            d.nome_departamento = 'Recursos Humanos' 
           ) AS u_rh
    WHERE
        em.data_validade BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY)
        AND f.status = 'Ativo';

   
    INSERT INTO SINATRANS.notificacao (
        usuario_id, tipo_notificacao, titulo, mensagem, 
        nivel_urgencia, url_acao, origem_sistema
    )
    SELECT
        u_gestor.id_usuario, -- O ID do usuário do GESTOR
        'Vencimento',
        'Vencimento de Exame (Equipe)',
        CONCAT(
            'O exame médico (', em.tipo_exame, ') de ', 
            f.nome, ' vence em: ', DATE_FORMAT(em.data_validade, '%d/%m/%Y'), '.'
        ),
        'Média',
        CONCAT('app/equipe/exames?id=', em.id_exame),
        'Eventos_RH'
    FROM
        SINATRANS.exame_medico em
    JOIN
        SINATRANS.funcionario f ON em.funcionario_id = f.id_funcionario
    JOIN
        SINATRANS.departamento d ON f.departamento_id = d.id_departamento
    JOIN
        SINATRANS.usuario u_gestor ON u_gestor.funcionario_id = d.gestor_id 
    WHERE
        em.data_validade BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY)
        AND f.status = 'Ativo'
        AND d.gestor_id IS NOT NULL; 

   
    INSERT INTO SINATRANS.notificacao (
        usuario_id, tipo_notificacao, titulo, mensagem, 
        nivel_urgencia, url_acao, origem_sistema
    )
    SELECT
        u_rh.id_usuario,
        'Vencimento',
        'Período Aquisitivo Vencendo',
        CONCAT(
            'Período aquisitivo de férias de ', f.nome, 
            ' (Gestor: ', g.nome, ')',
            ' encerra em: ', DATE_FORMAT(fer.periodo_aquisitivo_fim, '%d/%m/%Y'), '.'
        ),
        'Alta',
        CONCAT('app/rh/ferias?id=', fer.id_ferias),
        'Eventos_RH'
    FROM
        SINATRANS.ferias fer
    JOIN
        SINATRANS.funcionario f ON fer.funcionario_id = f.id_funcionario
    JOIN
        SINATRANS.departamento d ON f.departamento_id = d.id_departamento
    LEFT JOIN 
        SINATRANS.funcionario g ON d.gestor_id = g.id_funcionario
    CROSS JOIN
        (SELECT 
            u.id_usuario 
         FROM 
            SINATRANS.usuario u
         JOIN 
            SINATRANS.funcionario f ON u.funcionario_id = f.id_funcionario
         JOIN 
            SINATRANS.departamento d ON f.departamento_id = d.id_departamento
         WHERE 
            d.nome_departamento = 'Recursos Humanos'
        ) AS u_rh
    WHERE
        fer.periodo_aquisitivo_fim BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY)
        AND fer.status <> 'Concluída'
        AND f.status = 'Ativo';

    INSERT INTO SINATRANS.notificacao (
        usuario_id, tipo_notificacao, titulo, mensagem, 
        nivel_urgencia, url_acao, origem_sistema
    )
    SELECT
        u_gestor.id_usuario,
        'Vencimento',
        'Agendamento de Férias (Equipe)',
        CONCAT(
            'O período aquisitivo de férias de ', f.nome, 
            ' encerra em: ', DATE_FORMAT(fer.periodo_aquisitivo_fim, '%d/%m/%Y'), '. Favor programar.'
        ),
        'Média',
        CONCAT('app/equipe/ferias?id=', fer.id_ferias),
        'Eventos_RH'
    FROM
        SINATRANS.ferias fer
    JOIN
        SINATRANS.funcionario f ON fer.funcionario_id = f.id_funcionario
    JOIN
        SINATRANS.departamento d ON f.departamento_id = d.id_departamento
    JOIN 
        SINATRANS.usuario u_gestor ON u_gestor.funcionario_id = d.gestor_id -- Relação ASSUMIDA
    WHERE
        fer.periodo_aquisitivo_fim BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL v_dias_aviso DAY)
        AND fer.status <> 'Concluída'
        AND f.status = 'Ativo'
        AND d.gestor_id IS NOT NULL;

END$$

DELIMITER ;

