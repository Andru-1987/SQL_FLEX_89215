DROP DATABASE IF EXISTS dml_database;
CREATE DATABASE dml_database; 
USE dml_database;

-- CREATE TABLE
CREATE TABLE  dml_database.pizza (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200),
    precio DECIMAL(8,2) DEFAULT 20000.00
);


CREATE TABLE  dml_database.ingrediente (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200),
    costo DECIMAL(6,2)
);

ALTER TABLE 
	dml_database.ingrediente 
    ADD COLUMN costo DECIMAL(6,2) DEFAULT 3000.00;

SELECT * FROM  dml_database.ingrediente ;

CREATE TABLE  dml_database.receta (
	id_pizza INT,
    id_ingrediente INT,
    PRIMARY KEY(id_pizza,id_ingrediente),
    FOREIGN KEY(id_pizza) REFERENCES  dml_database.pizza(id) ON DELETE CASCADE,
	FOREIGN KEY(id_ingrediente) REFERENCES  dml_database.ingrediente(id)
);


-- ingresar o crear pizzas
INSERT INTO dml_database.pizza 
	VALUES
(DEFAULT, 'Muzzarella', DEFAULT);


INSERT INTO dml_database.pizza 
	VALUES
(NULL, 'Fugazzeta', DEFAULT);

INSERT INTO dml_database.pizza(nombre)
	VALUES
('Hawwaiana');

-- CSV 
-- batch
INSERT INTO dml_database.pizza(nombre)
VALUES
('Roquefort'),
('Anchoas'),
('Napolitana'),
('Calabresa');


SELECT * FROM dml_database.pizza ;



-- Insertar ingredientes comunes
INSERT INTO dml_database.ingrediente (nombre) VALUES
('Muzzarella'),
('Salsa de tomate'),
('Orégano'),
('Cebolla'),
('Jamón'),
('Ananá'),
('Roquefort'),
('Anchoas'),
('Tomate'),
('Ajo'),
('Calabresa'),
('Aceitunas'),
('Champiñones'),
('Albahaca'),
('Parmesano'),
('Provolone'),
('Pimiento'),
('Morrón'),
('Aceite de oliva'),
('Panceta');


-- Pizza Muzzarella (id: 1)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(1, 1),  -- Muzzarella
(1, 2),  -- Salsa de tomate
(1, 3);  -- Orégano

-- Pizza Fugazzeta (id: 2)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(2, 1),  -- Muzzarella
(2, 2),  -- Salsa de tomate
(2, 4),  -- Cebolla
(2, 19); -- Aceite de oliva

-- Pizza Hawwaiana (id: 3)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(3, 1),  -- Muzzarella
(3, 2),  -- Salsa de tomate
(3, 5),  -- Jamón
(3, 6);  -- Ananá

-- Pizza Roquefort (id: 4)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(4, 7),  -- Roquefort
(4, 1),  -- Muzzarella (mezcla)
(4, 2),  -- Salsa de tomate
(4, 12); -- Aceitunas

-- Pizza Anchoas (id: 5)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(5, 8),  -- Anchoas
(5, 1),  -- Muzzarella
(5, 2),  -- Salsa de tomate
(5, 4),  -- Cebolla
(5, 12); -- Aceitunas

-- Pizza Napolitana (id: 6)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(6, 1),  -- Muzzarella
(6, 2),  -- Salsa de tomate
(6, 9),  -- Tomate en rodajas
(6, 14), -- Albahaca
(6, 19); -- Aceite de oliva

-- Pizza Calabresa (id: 7)
INSERT INTO dml_database.receta (id_pizza, id_ingrediente) VALUES
(7, 11), -- Calabresa
(7, 1),  -- Muzzarella
(7, 2),  -- Salsa de tomate
(7, 4),  -- Cebolla
(7, 10), -- Ajo
(7, 17); -- Pimiento




SELECT * FROM dml_database.pizza;

--  ACTUALIZAR VALOR
-- auto off

SET autocommit = 0;
SET SQL_SAFE_UPDATES=0;

START TRANSACTION;

UPDATE dml_database.pizza AS p
	SET p.precio  = p.precio * 1.3
WHERE id IN (
-- subquery
	SELECT id_pizza AS cantidad_ingredientes FROM dml_database.receta 
    GROUP BY id_pizza HAVING COUNT(id_ingrediente) >=6
);
-- condiciones multiples-

-- simple y no recomendada:  --> esto repite la misma operacion
START TRANSACTION;

UPDATE dml_database.pizza AS p
SET p.precio = p.precio *
	CASE 
		WHEN (SELECT COUNT(id_ingrediente) FROM dml_database.receta WHERE id_pizza = p.id) = 3 THEN 1.1
        WHEN (SELECT COUNT(id_ingrediente) FROM dml_database.receta WHERE id_pizza = p.id) = 4 THEN 1.2
        WHEN (SELECT COUNT(id_ingrediente) FROM dml_database.receta WHERE id_pizza = p.id) = 5 THEN 1.3
        WHEN (SELECT COUNT(id_ingrediente) FROM dml_database.receta WHERE id_pizza = p.id) >= 6  THEN 1.4
		ELSE 1
	END
WHERE EXISTS (SELECT 1 FROM dml_database.receta WHERE id_pizza = p.id);

SELECT * FROM dml_database.pizza;

ROLLBACK;

-- mejor y optimizada a multiples casos
START TRANSACTION;

UPDATE dml_database.pizza  AS p
INNER JOIN
	(
		SELECT id_pizza, COUNT(id_ingrediente) AS q
		FROM dml_database.receta
		GROUP BY id_pizza
    ) AS counter ON p.id = counter.id_pizza
SET p.precio = p.precio * 
					CASE
						WHEN counter.q = 3 THEN 1.1
                        WHEN counter.q = 4 THEN 1.2
                        WHEN counter.q = 5 THEN 1.3
                        WHEN counter.q >= 6 THEN 1.4
                        ELSE 1
					END;


SELECT * FROM dml_database.pizza;					
ROLLBACK;




SELECT * FROM dml_database.pizza ;
-- COMMIT!
COMMIT;

ROLLBACK;


START TRANSACTION;
DELETE FROM dml_database.pizza 
WHERE nombre LIKE '%Hawwaiana%';

SELECT * FROM  dml_database.receta;

ROLLBACK;


--  CUANDO INGRESAR REGISTROS --> YA EXISTENTES en otra tabla. ...... tenga valores agrupados o valores calculados

CREATE TABLE dml_database.margen_ganancia (
	id_pizza INT NOT NULL, 
	venta_valor DECIMAL(10,2),
    ingredientes_valor DECIMAL(10,2),
    rentabilidad DECIMAL(3,2) 
);




START TRANSACTION;
INSERT INTO dml_database.margen_ganancia
	(id_pizza, venta_valor, ingredientes_valor, rentabilidad)
    
SELECT 
-- hago los calculos de los valores de la pizza en venta y los de costo de produccion
	p.id,
    p.precio,
    costos_por_pizza.sum_costo, 
    (p.precio - costos_por_pizza.sum_costo) /  costos_por_pizza.sum_costo
    
FROM dml_database.pizza AS p
LEFT JOIN (
 -- buscando el valor de los ingredientes y sumando su costo por pizza
	SELECT 
		r.id_pizza,
		SUM(i.costo) AS sum_costo
    FROM dml_database.receta AS r
    LEFT JOIN dml_database.ingrediente AS i  ON r.id_ingrediente = i.id
    GROUP BY id_pizza
) AS costos_por_pizza ON p.id =  costos_por_pizza.id_pizza;



SELECT * FROM dml_database.margen_ganancia;




CREATE TABLE dml_database.margen_no_restric AS
SELECT 
-- hago los calculos de los valores de la pizza en venta y los de costo de produccion
	p.id,
    p.precio AS venta,
    costos_por_pizza.sum_costo AS produccion, 
    (p.precio - costos_por_pizza.sum_costo) /  costos_por_pizza.sum_costo AS margen
    
FROM dml_database.pizza AS p
LEFT JOIN (
 -- buscando el valor de los ingredientes y sumando su costo por pizza
	SELECT 
		r.id_pizza,
		SUM(i.costo) AS sum_costo
    FROM dml_database.receta AS r
    LEFT JOIN dml_database.ingrediente AS i  ON r.id_ingrediente = i.id
    GROUP BY id_pizza
) AS costos_por_pizza ON p.id =  costos_por_pizza.id_pizza;

SELECT * FROM dml_database.margen_no_restric ;
