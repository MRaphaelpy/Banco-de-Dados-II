-- union all: lista de passageiros que tenham um ou mais beneficios

-- union all, group_by

-- passageiro, passageiro_estudante, passageiro_idoso, passageiro_pcd
SELECT
    beneficios.id_passageiro,
    beneficios.nome,
    beneficios.cpf,
    
    GROUP_CONCAT(beneficios.tipo_beneficio SEPARATOR ', ') AS lista_de_beneficios
    
FROM (
    SELECT 
        p.id_passageiro, p.nome, p.cpf, 
        'Estudante' AS tipo_beneficio 
    FROM 
        passageiro p
    JOIN 
        passageiro_estudante pe ON p.id_passageiro = pe.id_estudante

    UNION ALL

    SELECT 
        p.id_passageiro, p.nome, p.cpf, 
        'PCD' AS tipo_beneficio 
    FROM 
        passageiro p
    JOIN 
        passageiro_pcd pp ON p.id_passageiro = pp.id_pcd

    UNION ALL 

    SELECT 
        p.id_passageiro, p.nome, p.cpf, 
        'Idoso' AS tipo_beneficio
    FROM 
        passageiro p
    JOIN 
        passageiro_idoso pi ON p.id_passageiro = pi.id_idoso
        
) AS beneficios 

GROUP BY
    beneficios.id_passageiro, beneficios.nome, beneficios.cpf
ORDER BY
    beneficios.id_passageiro;
    
-- union: criar lista de funcionario que já foram alocados em qualquer tipo de operaçãoptimize

-- union, join

-- funcionario, cargo, viagem, operacao_carga

SELECT
    f.id_funcionario,
    f.nome,
    f.cpf,
    c.nome_cargo AS cargo_principal
FROM
    funcionario f
JOIN
    cargo c ON f.cargo_id = c.id_cargo
JOIN (
    SELECT motorista_id AS id_func FROM viagem WHERE motorista_id IS NOT NULL
    
    UNION 
 
    SELECT cobrador_id AS id_func FROM viagem WHERE cobrador_id IS NOT NULL
    
    UNION 
    
    SELECT motorista_id AS id_func FROM operacao_carga WHERE motorista_id IS NOT NULL
    
    UNION 
    
    SELECT ajudante_id AS id_func FROM operacao_carga WHERE ajudante_id IS NOT NULL

) AS pessoal_ativo ON f.id_funcionario = pessoal_ativo.id_func 

ORDER BY
    f.nome;