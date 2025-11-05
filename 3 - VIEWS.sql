-- view: lista de paradas de um determinado trajeto realizado por um veiculo

-- linha_transporte, rota, parada_rota, parada

CREATE VIEW v_itinerario_linha AS
SELECT
    l.id_linha,
    l.codigo_linha,
    l.nome AS nome_linha,
    r.sentido,
    pr.ordem_sequencial, 
    p.id_parada,
    p.codigo_parada,
    p.nome AS nome_parada,
    p.coordenada_latitude,
    p.coordenada_longitude
FROM
    linha_transporte l
JOIN
    rota r ON l.id_linha = r.linha_id
JOIN
    parada_rota pr ON r.id_rota = pr.rota_id
JOIN
    parada p ON pr.parada_id = p.id_parada;