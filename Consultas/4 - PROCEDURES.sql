-- procedures: registrar atualizações de recarga de cartão de transporte

-- cartao_bilhetagem, recarga

DELIMITER $$

CREATE PROCEDURE sp_RegistrarRecarga(
    IN p_cartao_id VARCHAR(50),
    IN p_valor DECIMAL(10, 2),
    IN p_tipo_pagamento ENUM('Dinheiro', 'Crédito', 'Débito', 'PIX', 'Boleto', 'App', 'Desconto em folha'),
    IN p_local_recarga ENUM('Terminal', 'Posto autorizado', 'App', 'Website', 'ATM', 'Empresa'),
    IN p_operador_id INT
)
BEGIN
    DECLARE v_status_cartao ENUM('Ativo', 'Bloqueado', 'Expirado', 'Perdido', 'Cancelado');

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT 
        status INTO v_status_cartao
    FROM 
        cartao_bilhetagem
    WHERE 
        id_cartao = p_cartao_id;

    IF v_status_cartao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO: Cartão não encontrado.';
    ELSEIF v_status_cartao IN ('Bloqueado', 'Cancelado', 'Expirado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO: Cartão não está Ativo e não pode ser recarregado.';
    END IF;

    START TRANSACTION;
    
    INSERT INTO recarga (
        cartao_id, 
        valor, 
        data_hora_recarga, 
        tipo_pagamento, 
        local_recarga, 
        operador_id,
        status
    )
    VALUES (
        p_cartao_id,
        p_valor,
        NOW(),
        p_tipo_pagamento,
        p_local_recarga,
        p_operador_id,
        'Completa'
    );
    
    UPDATE cartao_bilhetagem
    SET
        saldo = saldo + p_valor,
        ultima_recarga = NOW(),
        status = 'Ativo' 
    WHERE
        id_cartao = p_cartao_id;
        
    COMMIT;
    
    SELECT 
        'Recarga realizada com sucesso.' AS status,
        (SELECT saldo FROM cartao_bilhetagem WHERE id_cartao = p_cartao_id) AS novo_saldo;

END$$

DELIMITER ;

-- usando a procedure (caso de uso)

CALL sp_RegistrarRecarga (
	'AA-BB-CC-01',
    20.00,
    'PIX',
    'App',
    NULL
    );