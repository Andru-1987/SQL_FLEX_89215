USE coderhouse_gamers ;

-- UNIR  (join) los datos de los games de call of duty -> con los comentarios 
CREATE VIEW
	coderhouse_gamers.view_call_of_duty_marketing AS
SELECT 
	g.name,
    g.description,
    c.comment_date,
    c.commentary
FROM coderhouse_gamers.GAME AS g
INNER JOIN coderhouse_gamers.COMMENTARY AS c
	ON g.id_game = c.id_game
WHERE g.name LIKE '%Call of Duty%';


-- update de la query- view

CREATE OR REPLACE VIEW
	coderhouse_gamers.view_call_of_duty_marketing AS
SELECT 
	g.name,
    g.description,
    c.comment_date,
    YEAR(c.comment_date) AS year_commentary,
    c.commentary
FROM coderhouse_gamers.GAME AS g
INNER JOIN coderhouse_gamers.COMMENTARY AS c
	ON g.id_game = c.id_game
WHERE g.name LIKE '%Call of Duty%';


SELECT 
	name AS nombre_juego,
    year_commentary,
    COUNT(commentary) AS total_comentarios
FROM coderhouse_gamers.view_call_of_duty_marketing 
-- agrupando --> 
GROUP BY 1,2 ;


-- Muestre nombre, apellido y mail de los usuarios que juegan al juego FIFA 22.

CREATE OR REPLACE VIEW coderhouse_gamers.view_fifa_marketing AS
SELECT 
	-- query que tiene los datos de la gente que juega al fifa
	s.first_name,
	s.last_name,
    s.email ,
    g.id_game
FROM coderhouse_gamers.SYSTEM_USER AS s
LEFT JOIN coderhouse_gamers.PLAY AS p ON s.id_system_user = p.id_system_user  -- no aparece el usuario 
LEFT JOIN coderhouse_gamers.GAME AS g USING(id_game)
WHERE g.name LIKE '%FIFA 22%';

SELECT * FROM coderhouse_gamers.view_fifa_marketing ; -- pbi --> 

-- funciones de tabla! --> big query --> (param -> ) table filtrada por arg! no en mysql
-- PG

-- BREAK -> RLS -> 

/*
.edu role -> educativo
.info role -> AGIP
.org role -> ong
else -> comun
*/

CREATE OR REPLACE VIEW coderhouse_gamers.view_con_roles AS 
SELECT 
	s.*,
	CASE
		WHEN s.email LIKE '%.info' THEN 'AGIP'
		WHEN s.email LIKE '%.org' THEN  'ONG'
		WHEN s.email LIKE '%.edu' THEN  'EDUCACION'
    ELSE 'ALL' END AS role
 FROM coderhouse_gamers.SYSTEM_USER AS s;



CREATE OR REPLACE VIEW coderhouse_gamers.view_ongs AS 
SELECT 
	id_system_user,
    first_name,
    last_name,
    email,
    id_user_type
FROM coderhouse_gamers.view_con_roles
WHERE role = "ONG";
    

SELECT * FROM coderhouse_gamers.view_ongs;


-- ENTREGA --> 

Se debe entregar

-- Descripción de la temática de la base de datos

-- Diagramas de entidad relación de la base de datos --> EXCALIDRAW - MIRO  -> cuando armen el sql DDL base entera.. DER 

-- Listado de las tablas que comprenden la base de datos, con descripción de cada tabla, listado de campos, abreviaturas de nombres de campos, nombres completos de campos, tipos de datos, tipo de clave (foránea, primaria, índice(s))

tablas : nombre
campos -> dtype  default ---
descripcion -> acumula usuarios , acumula transacciones


Un archivo .sql que contenga:

Script en SQL de creación de la base de datos y tablas. Este puede estar publicado en un repositorio github, con lo cual el documento presentacion o pdf debe contener los links de las publicaciones.


-- carpeta en google drive  > presentacion + sql + imagenss --> la carpeta debe ser si y solo si ! PUBLICA!!!! 
