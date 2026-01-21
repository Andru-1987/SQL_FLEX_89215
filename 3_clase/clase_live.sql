-- union juntar dos tablas -->? de manera vertical
-- nombres del juego  | id_class

SELECT name, id_class FROM coderhouse_gamers.game
WHERE id_level = 2
UNION -- ALL
SELECT id_class, name FROM coderhouse_gamers.game -- gamedos
WHERE id_level = 2;


SELECT id_level, name, id_class FROM coderhouse_gamers.game
WHERE 
-- id_level = 2 OR id_level = 7
-- id_level IN (2,7)
id_level BETWEEN 2 AND 7 ;
    
-- ISO 8601 para las fechas

SELECT 
	(1 != 1) AS campo_numerico,
    "hola mundo " AS texto_varchar,
    DATE("2025-01-01") AS fecha,
    DATE("01/01/2025") AS fecha_con_fmt_raro,
    CAST( (21/3) AS UNSIGNED) AS numero,
    CURRENT_DATE() AS fecha_actual,
    NOW() AS fecha_hora_actual
    ;


-- COMMENTARY

SELECT 
	* ,
	YEAR(comment_date) AS comment_year,
    (CURRENT_DATE() - comment_date / 365 * 24 * 60 *60) ,
    (DATEDIFF(CURRENT_DATE,comment_date) / 365) AS years,
    CONCAT( 10000 * ( id_system_user / (SELECT SUM(id_system_user) FROM coderhouse_gamers.commentary )) , " %")AS total_puntos
FROM coderhouse_gamers.commentary;



SELECT * FROM coderhouse_gamers.system_user
WHERE email LIKE '%.gov' AND last_name LIKE "c_n%"
;


-- juegos jugados por jugador
-- quiero ver el jugador con mas cantidad de juegos jugados

-- valor max de juegos

-- tablas CTES
SELECT  id_system_user, COUNT(id_game) AS freq_games 
	FROM coderhouse_gamers.play
GROUP BY id_system_user
HAVING COUNT(id_game) = (
-- subquery para comparar
	SELECT DISTINCT freq_games
	FROM (
    -- subquery para generar una tabla temporal
    SELECT  id_system_user, COUNT(id_game) AS freq_games 
		FROM coderhouse_gamers.play
	GROUP BY id_system_user) AS temp_conteo
	ORDER BY freq_games DESC
	LIMIT 1
    );
    
    
-- DDL --> DATA DEFINTION LANGUAGE  --> PARA PODER CREAR OBJETOS EN LAS BASES

-- TABLAS | BASES DATOS , CAMPOS, PK, FK
-- DEFINIR UNA TABLA DONDE TENGA  4 campos -

-- Entidad Persona
-- id -> auto incremental PK --> definicion no es null y ademas no se repite
-- email -> unique, char | varchar
-- DOB --> DATE
-- texto_personal TEXT



CREATE TABLE IF NOT EXISTS 
	coderhouse_gamers.persona(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    dob DATE NOT NULL DEFAULT '1987-01-01',
    text_personal TEXT
    );


CREATE TABLE IF NOT EXISTS 
	coderhouse_gamers.cuenta_bancaria(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cbu VARCHAR(22),
    id_persona INT,
    FOREIGN KEY (id_persona) REFERENCES persona(id)
    );







