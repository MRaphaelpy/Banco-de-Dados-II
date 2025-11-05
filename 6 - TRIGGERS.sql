-- trigger: atualizar automaticamente o peso total de uma carga com o peso individual de
-- uma mercadoria

-- volume, carga

-- trigger quando novo volume é adicionado a uma carga

DELIMITER $$

CREATE TRIGGER trg_Volume_AfterInsert
AFTER INSERT ON volume
FOR EACH ROW
BEGIN
    UPDATE carga
    SET 
        peso_kg = peso_kg + NEW.peso_kg
    WHERE 
        id_carga = NEW.carga_id; 
END$$

DELIMITER ;

-- trigger quando um novo volume é removido de uma carga

DELIMITER $$

CREATE TRIGGER trg_Volume_AfterDelete
AFTER DELETE ON volume
FOR EACH ROW
BEGIN
    UPDATE carga
    SET 
        peso_kg = peso_kg - OLD.peso_kg
    WHERE 
        id_carga = OLD.carga_id; 
END$$

DELIMITER ;

-- trigger quando um volume existente é alterado

DELIMITER $$

CREATE TRIGGER trg_Volume_AfterUpdate
AFTER UPDATE ON volume
FOR EACH ROW
BEGIN
    IF NEW.peso_kg != OLD.peso_kg THEN
    
        UPDATE carga
        SET 
            peso_kg = (peso_kg - OLD.peso_kg) + NEW.peso_kg
        WHERE 
            id_carga = NEW.carga_id;
    END IF;
    
END$$

DELIMITER ;