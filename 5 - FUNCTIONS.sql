-- functions: calcular o custo total de manutenção de um veiculo 

-- item_manutencao

DELIMITER $$

CREATE FUNCTION f_GetCustoTotalManutencao(
    p_manutencao_id INT 
)
RETURNS DECIMAL(10, 2) DETERMINISTIC READS SQL DATA

BEGIN
    DECLARE v_custo_total DECIMAL(10, 2);

    SELECT 
        SUM(im.valor_total)
    INTO 
        v_custo_total
    FROM 
        item_manutencao im
    WHERE 
        im.manutencao_id = p_manutencao_id; 

    RETURN COALESCE(v_custo_total, 0.00);

END$$

DELIMITER ;

-- usando a function

SELECT
    m.id_manutencao,
    m.descricao,
    m.data_fim,
    m.custo_total AS custo_registrado_na_os,
    f_GetCustoTotalManutencao(m.id_manutencao) AS custo_calculado_dos_itens
    
FROM
    manutencao m
WHERE
    m.status = 'Concluída';
