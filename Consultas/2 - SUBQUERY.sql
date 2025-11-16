-- subquery: lista de linhas de passageiros mais usadas

-- ultilizacao_cartao, linha_transporte

SELECT
    lt.codigo_linha,
    lt.nome,
    contagem_usos.total_viagens 
FROM
    linha_transporte lt
JOIN
    (
        SELECT
            linha_id,
            COUNT(id_utilizacao) AS total_viagens
        FROM
            utilizacao_cartao
        WHERE
            tipo_utilizacao = 'Embarque' 
        GROUP BY
            linha_id
            
    ) AS contagem_usos ON lt.id_linha = contagem_usos.linha_id 
    
ORDER BY
    contagem_usos.total_viagens DESC;
    
-- subquery: painel de saude da frota, com informações de uso de veiculos e revisão 

-- veiculo, manutencao, abastecimento
SELECT
    v.id_veiculo,
    v.placa,
    v.status_operacional,
    v.quilometragem_atual,
    
    (SELECT 
         MAX(m.data_inicio) 
     FROM 
         manutencao m 
     WHERE 
         m.veiculo_id = v.id_veiculo 
    ) AS data_ultima_manutencao,
    
    (SELECT 
         MAX(a.data_abastecimento) 
     FROM 
         abastecimento a 
     WHERE 
         a.veiculo_id = v.id_veiculo 
    ) AS data_ultimo_abastecimento
    
FROM
    veiculo v; 
