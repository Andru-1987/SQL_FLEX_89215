CREATE DATABASE routines_databases;
USE routines_databases;

-- funciones personalizadas o CUSTOM FUNCTIONS
-- funciones built-in X 



-- como armo una funcion que al pasarle dos valores pueda calcular la cantidad de litros 
-- de pintura para una pared

CREATE TABLE routines_databases.dim_paredes (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	alto DECIMAL(12,2) DEFAULT 3.00,
    largo DECIMAL(12,2) DEFAULT 5.00,
    total_manos INT DEFAULT 2,
    precio_final DECIMAL(12,2)
);


INSERT INTO routines_databases.dim_paredes (alto, largo, total_manos, precio_final) VALUES
(2.80, 4.50, 2, 18000.00),
(3.00, 5.00, 2, 22000.00),
(2.60, 3.80, 3, 19500.00),
(3.20, 6.00, 2, 28000.00),
(2.50, 4.00, 1, 12000.00),
(2.90, 5.50, 2, 24000.00),
(3.00, 7.00, 3, 35000.00),
(2.70, 4.20, 2, 17500.00),
(3.10, 6.50, 2, 30000.00),
(2.40, 3.50, 1, 10000.00);


DELIMITER //

DROP FUNCTION IF EXISTS routines_databases.fn_calculo_litros_pintura //

CREATE FUNCTION routines_databases.fn_calculo_litros_pintura(
	-- variables de entrada --> argumentos
	_alto DECIMAL(12,2),
    _largo DECIMAL(12,2),
    _cantidad_manos_de_pintura INT,
    rendimiento DECIMAL(12,2)
) RETURNS DECIMAL(12,2) -- DTYPE
-- la funcion sera: 
DETERMINISTIC
BEGIN
	-- declare una variable
    DECLARE valor_de_retorno DECIMAL(12,2);
    
    IF rendimiento < 0 THEN
		SET valor_de_retorno = 0.0;
	ELSEIF rendimiento <=0.5 THEN 
		SET valor_de_retorno = (_alto * _largo) * _cantidad_manos_de_pintura * (rendimiento + 0.25) ; -- litros * m2
	ELSE
        SET valor_de_retorno = (_alto * _largo) * _cantidad_manos_de_pintura * rendimiento; 
	END IF;
		
	RETURN valor_de_retorno;

END//

DELIMITER ;


-- ser llamado --> contexto de query

SELECT routines_databases.fn_calculo_litros_pintura(3,3,2, RAND())  AS total_pintura;


SELECT 
	p.id,
    p.alto,
    p.largo,
    p.total_manos,
    routines_databases.fn_calculo_litros_pintura(p.alto,p.largo,p.total_manos, 0.5) AS total_litros,
    (p.precio_final / routines_databases.fn_calculo_litros_pintura(p.alto,p.largo,p.total_manos, 0.75)) AS precio_x_litro
FROM routines_databases.dim_paredes AS p;


-- PROCEDURES
--  ETL  -> EXTRACT TRANSFORM LOAD
-- ingrese el rendimiento de una marca --> marca , rendimiento
-- logica -> que me haga los calculos -> toda la tabla
-- si llega ser el caso que todos los valores de total_litros son 0 -->  quiere decir tengo un error! 
-- entonces que me lance un error
-- llevar a una tabla donde almacene esa informacion.

CREATE TABLE routines_databases.rendimiento_por_marcas(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	alto DECIMAL(12,2) DEFAULT 3.00,
    largo DECIMAL(12,2) DEFAULT 5.00,
    total_manos INT DEFAULT 2,
    total_litros DECIMAL(12,2),
    precio_x_litro DECIMAL(12,2),
    presupuesto_final DECIMAL(12,2),
    marca_de_pintura VARCHAR(200),
    rendimiento_por_litro DECIMAL(6,2)
);




DELIMITER //

DROP PROCEDURE IF EXISTS routines_databases.sp_generacion_presupuesto //


CREATE PROCEDURE routines_databases.sp_generacion_presupuesto
	( IN _marca VARCHAR(200), IN rendimiento DECIMAL(12,2) )
BEGIN
	
    IF rendimiento < 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Zapallo, como vas a tener rendimiento negativo?';
    END IF;
    
    DELETE FROM routines_databases.rendimiento_por_marcas
    WHERE marca_de_pintura = _marca;

	INSERT INTO routines_databases.rendimiento_por_marcas
	SELECT 
		NULL,
		p.alto,
		p.largo,
		p.total_manos,
		routines_databases.fn_calculo_litros_pintura(p.alto,p.largo,p.total_manos, rendimiento) AS total_litros,
		(p.precio_final / routines_databases.fn_calculo_litros_pintura(p.alto,p.largo,p.total_manos, rendimiento)) AS precio_x_litro,
		p.precio_final,
        _marca,
        rendimiento
    FROM routines_databases.dim_paredes AS p;


	SELECT * FROM routines_databases.rendimiento_por_marcas;

END //
    
DELIMITER ;
    

CALL routines_databases.sp_generacion_presupuesto(
	'TriColor', -0.75
);





