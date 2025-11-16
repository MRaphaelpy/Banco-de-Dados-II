-- transaction:  alterar o status de uma viagem de agendada para em andamento 

-- escala, viagem, veiculo, funcionario

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_IniciarViagem; $$

CREATE PROCEDURE sp_IniciarViagem(
    IN p_viagem_id INT
)
BEGIN
    DECLARE v_veiculo_id INT;
    DECLARE v_motorista_id INT;
    DECLARE v_cobrador_id INT;
    DECLARE v_escala_id INT;
    
    DECLARE v_status_viagem VARCHAR(20);
    DECLARE v_status_veiculo VARCHAR(20);
    DECLARE v_status_motorista ENUM('Ativo', 'Férias', 'Licenca', 'Desligado');
    DECLARE v_status_cobrador ENUM('Ativo', 'Férias', 'Licenca', 'Desligado');

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    SELECT 
        escala_id, veiculo_id, motorista_id, cobrador_id, status_viagem
    INTO 
        v_escala_id, v_veiculo_id, v_motorista_id, v_cobrador_id, v_status_viagem
    FROM 
        viagem
    WHERE 
        id_viagem = p_viagem_id
    FOR UPDATE;

    IF v_status_viagem != 'Programada' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = CONCAT('ERRO: Esta viagem não está "Programada". Status atual: ', v_status_viagem);
    END IF;

    SELECT status_operacional INTO v_status_veiculo FROM veiculo WHERE id_veiculo = v_veiculo_id FOR UPDATE;
    IF v_status_veiculo != 'Ativo' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = CONCAT('ERRO: Veículo (ID ', v_veiculo_id, ') não está "Ativo". Status atual: ', v_status_veiculo);
    END IF;

    SELECT status INTO v_status_motorista FROM funcionario WHERE id_funcionario = v_motorista_id FOR UPDATE;
    IF v_status_motorista != 'Ativo' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = CONCAT('ERRO: Motorista (ID ', v_motorista_id, ') não está "Ativo". Status atual: ', v_status_motorista);
    END IF;
    
    IF v_cobrador_id IS NOT NULL THEN
        SELECT status INTO v_status_cobrador FROM funcionario WHERE id_funcionario = v_cobrador_id FOR UPDATE;
        IF v_status_cobrador != 'Ativo' THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = CONCAT('ERRO: Cobrador (ID ', v_cobrador_id, ') não está "Ativo". Status atual: ', v_status_cobrador);
        END IF;
    END IF;

    UPDATE viagem
    SET 
        status_viagem = 'Em andamento',
        hora_partida_real = NOW()
    WHERE 
        id_viagem = p_viagem_id;

    IF v_escala_id IS NOT NULL THEN
        UPDATE escala
        SET 
            status = 'Em andamento',
            hora_inicio_real = NOW()
        WHERE 
            id_escala = v_escala_id;
    END IF;
    
    UPDATE veiculo
    SET 
        status_operacional = 'Em rota'
    WHERE 
        id_veiculo = v_veiculo_id;
        
    UPDATE funcionario
    SET 
        status = 'Ativo'
    WHERE 
        id_funcionario = v_motorista_id;
        
    IF v_cobrador_id IS NOT NULL THEN
        UPDATE funcionario
        SET 
            status = 'Ativo'
        WHERE 
            id_funcionario = v_cobrador_id;
    END IF;
        
    COMMIT;
    
    SELECT 'Viagem iniciada com sucesso. Recursos (Veículo, Motorista e Cobrador) validados e alocados.' AS status;

END$$

DELIMITER ;