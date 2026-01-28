CREATE DATABASE IF NOT EXISTS escuelita;

USE escuelita;

-- Transformar nuestro mini DER en tablitas.
CREATE TABLE IF NOT EXISTS escuelita.estudiante(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(120) UNIQUE
); 

CREATE TABLE IF NOT EXISTS escuelita.curso(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) DEFAULT 'NO DEFINIDO',
    profesor INT
);

CREATE TABLE IF NOT EXISTS escuelita.inscripcion(
	id_estudiante INT,
    id_curso INT,
	FOREIGN KEY (id_estudiante) REFERENCES escuelita.estudiante(id),
	FOREIGN KEY (id_curso) REFERENCES escuelita.curso(id),
    PRIMARY KEY (id_estudiante,id_curso)
);




-- Insertar 5 Estudiantes
INSERT INTO escuelita.estudiante (id, nombre, apellido, email) VALUES
(1, 'Juan', 'Perez', 'juan.perez@email.com'),
(2, 'Maria', 'Gonzalez', 'maria.gonzalez@email.com'),
(3, 'Carlos', 'Lopez', 'carlos.lopez@email.com'),
(4, 'Ana', 'Martinez', 'ana.martinez@email.com'),
(5, 'Luis', 'Rodriguez', 'luis.rodriguez@email.com');

-- Insertar 5 Cursos
INSERT INTO escuelita.curso (id, nombre, profesor) VALUES
(1, 'Matematicas Avanzadas', 101),
(2, 'Historia Universal', 102),
(3, 'Física I', 103),
(4, 'Literatura Latinoamericana', 104),
(5, 'Programación Básica', 105);

-- Insertar 5 Inscripciones (Relacionando los IDs anteriores)
INSERT INTO escuelita.inscripcion (id_estudiante, id_curso) VALUES
(1, 1), -- Juan se inscribe en Matemáticas
(2, 2), -- Maria se inscribe en Historia
(3, 3), -- Carlos se inscribe en Física
(4, 4), -- Ana se inscribe en Literatura
(5, 5); -- Luis se inscribe en Programación


-- function -> 
-- SELECT LENGTH('ola ka ase?');

DELIMITER $$

CREATE FUNCTION escuelita.fn_count_longitud( variable VARCHAR(100))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE valor_retorno INT;
    
    SELECT LENGTH(variable) INTO valor_retorno;
    
    RETURN valor_retorno;
END$$

DELIMITER  ;


SELECT fn_count_longitud('ola k ase?') AS total_chars ;

SELECT 
	e.*, 
    fn_count_longitud(e.nombre) AS total_chars_nombre
FROM escuelita.estudiante AS e;



CREATE DATABASE IF NOT EXISTS biblioteca_otto;
USE biblioteca_otto;

CREATE TABLE IF NOT EXISTS biblioteca_otto.prestamo(
	id_usuario INT,
    id_libro INT,
    fecha DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS biblioteca_otto.libro(
	id INT NOT NULL,
    titulo VARCHAR(200),
    autor VARCHAR(200) DEFAULT 'Desconocido',
    fecha_publicacion DATE
);

CREATE TABLE IF NOT EXISTS biblioteca_otto.usuario(
	id INT NOT NULL,
    nombre VARCHAR(200),
    email VARCHAR(200) UNIQUE,
    telefono VARCHAR(200)
);


ALTER TABLE biblioteca_otto.usuario
	MODIFY id INT AUTO_INCREMENT;

ALTER TABLE biblioteca_otto.usuario
	ADD PRIMARY KEY (id) ;


ALTER TABLE biblioteca_otto.libro
	DROP COLUMN id;

ALTER TABLE biblioteca_otto.libro
	ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;


ALTER TABLE biblioteca_otto.prestamo
	ADD FOREIGN KEY (id_usuario) REFERENCES biblioteca_otto.usuario(id);

ALTER TABLE biblioteca_otto.prestamo
	ADD FOREIGN KEY (id_libro) REFERENCES biblioteca_otto.libro(id);

ALTER TABLE biblioteca_otto.prestamo
	ADD PRIMARY KEY (id_usuario,id_libro,fecha);






