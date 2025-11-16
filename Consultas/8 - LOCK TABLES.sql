-- LOCK TABLES: relatorio diario sobre bilhetagem de passageiros (depoisitos, usos, saldo anterior)

-- passageiro, cartao_bilhetagem, recarga, ultilizacao_cartao

LOCK TABLES 
    passageiro READ,
    cartao_bilhetagem READ,
    recarga READ,
    utilizacao_cartao READ;

SELECT
    p.id_passageiro,
    p.nome,
    p.cpf,
    cb.id_cartao,
    cb.saldo AS saldo_atual_registrado,
    
    (SELECT 
         COALESCE(SUM(r.valor), 0.00) 
     FROM recarga r 
     WHERE r.cartao_id = cb.id_cartao AND r.status = 'Completa'
    ) AS total_recarregado,
    
    (SELECT 
         COALESCE(SUM(u.valor_cobrado), 0.00) 
     FROM utilizacao_cartao u 
     WHERE u.cartao_id = cb.id_cartao
    ) AS total_gasto,
    
    (
        (SELECT COALESCE(SUM(r.valor), 0.00) FROM recarga r WHERE r.cartao_id = cb.id_cartao AND r.status = 'Completa')
        -
        (SELECT COALESCE(SUM(u.valor_cobrado), 0.00) FROM utilizacao_cartao u WHERE u.cartao_id = cb.id_cartao)
    ) AS saldo_calculado
    
FROM
    passageiro p
JOIN
    cartao_bilhetagem cb ON p.id_passageiro = cb.passageiro_id

HAVING
    saldo_atual_registrado != saldo_calculado;

UNLOCK TABLES;