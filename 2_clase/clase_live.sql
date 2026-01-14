-- me permite indicarle la base de datos que voy a trabajar
USE coderhouse_gamers;

DROP DATABASE `ola k ase`;

-- trae la data y la ordena de manera alfabetica asc por el campo nombre
SELECT * FROM `coderhouse_gamers`.`game`
ORDER BY name 
;


SELECT DISTINCT name  -- unique
FROM `coderhouse_gamers`.`game`
ORDER BY name ;



SELECT DISTINCT name, id_level 
FROM `coderhouse_gamers`.`game`
ORDER BY id_level DESC LIMIT 4;



SELECT DISTINCT name, id_level 
FROM `coderhouse_gamers`.`game`
-- WHERE id_level >= 5 AND id_level <= 6
WHERE id_level BETWEEN 5 AND 6
ORDER BY name;


-- challenge:  
-- Traer los usuarios y texto de aquellos comentarios sobre juegos 
-- cuyo código de juego (id_game) sea 73

SELECT 
	c.`commentary` AS comentario,
    s.`email` AS correo_electronico
    
FROM `coderhouse_gamers`.`commentary` AS c
-- union por columna
JOIN `coderhouse_gamers`.`system_user` AS s USING(id_system_user)
WHERE id_game = 73;

-- Quiero saber la cantidad de comentarios por cada usuario
SELECT 
	c.id_system_user,
	c.id_game,
	COUNT(*) AS feq_comentarios
FROM `coderhouse_gamers`.`commentary` AS c
GROUP BY c.id_system_user, c.id_game;

-- [] -> FILTRO (WHERE) -> LIMIT  -> SELECT columnas
