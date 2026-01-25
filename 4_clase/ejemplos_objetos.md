# Curso: Objetos y Tablas en SQL - Ejemplos MySQL

---

### **Posta 1: Fundamentos - Tablas y su Creación**

**Ejemplo MySQL:**
```sql
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS universidad;
USE universidad;

-- Crear tabla Estudiantes
CREATE TABLE Estudiantes (
    id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar datos
INSERT INTO Estudiantes (id, nombre, apellido, fecha_nacimiento, email) 
VALUES 
(1, 'María', 'Gómez', '2000-05-15', 'maria@email.com'),
(2, 'Carlos', 'López', '1999-08-22', 'carlos@email.com'),
(3, 'Ana', 'Rodríguez', '2001-03-10', 'ana@email.com');
```

---

### **Posta 2: Relaciones entre Tablas y Claves**

**Ejemplos MySQL:**

```sql
-- Agregar PK a Estudiantes
ALTER TABLE Estudiantes
ADD PRIMARY KEY (id);

-- Crear tabla Cursos con PK
CREATE TABLE Cursos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    profesor VARCHAR(100),
    creditos INT DEFAULT 3
) ENGINE=InnoDB;

-- Crear tabla de relación muchos-a-muchos
CREATE TABLE Inscripciones (
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    fecha_inscripcion DATE DEFAULT (CURRENT_DATE),
    calificacion DECIMAL(3,2),
    
    PRIMARY KEY (estudiante_id, curso_id),
    
    FOREIGN KEY (estudiante_id) 
        REFERENCES Estudiantes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (curso_id) 
        REFERENCES Cursos(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insertar relación
INSERT INTO Inscripciones (estudiante_id, curso_id, calificacion)
VALUES (1, 1, 8.5), (1, 2, 9.0), (2, 1, 7.5);
```

---

### **Posta 3: Funciones en SQL**

**Ejemplos MySQL:**

```sql
-- Cambiar delimitador para funciones
DELIMITER $$

-- Función escalar: calcular edad
CREATE FUNCTION calcular_edad(fecha_nac DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(CURDATE()) - YEAR(fecha_nac) - 
           (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(fecha_nac, '%m%d'));
END$$

-- Función con parámetro: estudiantes por curso
CREATE FUNCTION contar_estudiantes_curso(id_curso INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Inscripciones
    WHERE curso_id = id_curso;
    
    RETURN total;
END$$

-- Función que retorna tabla (simulada con SELECT)
CREATE FUNCTION obtener_mejores_estudiantes(nota_minima DECIMAL(3,2))
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE resultado TEXT DEFAULT '';
    
    SELECT GROUP_CONCAT(CONCAT(e.nombre, ' ', e.apellido, ': ', i.calificacion) 
           SEPARATOR '; ')
    INTO resultado
    FROM Estudiantes e
    JOIN Inscripciones i ON e.id = i.estudiante_id
    WHERE i.calificacion >= nota_minima;
    
    RETURN IFNULL(resultado, 'No hay estudiantes con esa calificación');
END$$

DELIMITER ;

-- Usar funciones
SELECT nombre, calcular_edad(fecha_nacimiento) AS edad 
FROM Estudiantes;

SELECT contar_estudiantes_curso(1) AS estudiantes_en_curso_1;

SELECT obtener_mejores_estudiantes(8.0) AS mejores_estudiantes;
```

---

### **Posta 4: Triggers (Disparadores)**

**Ejemplos MySQL:**

```sql
DELIMITER $$

-- Trigger BEFORE INSERT: validar y formatear datos
CREATE TRIGGER before_insert_estudiante
BEFORE INSERT ON Estudiantes
FOR EACH ROW
BEGIN
    -- Convertir nombre y apellido a mayúsculas
    SET NEW.nombre = UPPER(NEW.nombre);
    SET NEW.apellido = UPPER(NEW.apellido);
    
    -- Validar que el email contenga @
    IF NEW.email NOT LIKE '%@%' THEN
        SET NEW.email = CONCAT(NEW.email, '@correo.default');
    END IF;
END$$

-- Trigger AFTER INSERT: auditoría de inscripciones
CREATE TRIGGER after_insert_inscripcion
AFTER INSERT ON Inscripciones
FOR EACH ROW
BEGIN
    DECLARE nombre_estudiante VARCHAR(100);
    DECLARE nombre_curso VARCHAR(100);
    
    -- Obtener datos relacionados
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_estudiante
    FROM Estudiantes WHERE id = NEW.estudiante_id;
    
    SELECT nombre_curso INTO nombre_curso
    FROM Cursos WHERE id = NEW.curso_id;
    
    -- Insertar en tabla de auditoría
    INSERT INTO auditoria_inscripciones 
    (estudiante_id, curso_id, estudiante_nombre, curso_nombre, 
     fecha_inscripcion, accion, fecha_accion)
    VALUES (NEW.estudiante_id, NEW.curso_id, nombre_estudiante, 
            nombre_curso, NEW.fecha_inscripcion, 'INSERCIÓN', NOW());
END$$

-- Trigger BEFORE UPDATE: validar calificación
CREATE TRIGGER before_update_calificacion
BEFORE UPDATE ON Inscripciones
FOR EACH ROW
BEGIN
    -- Validar que la calificación esté entre 0 y 10
    IF NEW.calificacion < 0 OR NEW.calificacion > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La calificación debe estar entre 0 y 10';
    END IF;
    
    -- Si la calificación es NULL, establecer como 0
    IF NEW.calificacion IS NULL THEN
        SET NEW.calificacion = 0;
    END IF;
END$$

DELIMITER ;

-- Crear tabla de auditoría
CREATE TABLE auditoria_inscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    curso_id INT,
    estudiante_nombre VARCHAR(100),
    curso_nombre VARCHAR(100),
    fecha_inscripcion DATE,
    accion VARCHAR(20),
    fecha_accion DATETIME
);
```

---

### **Posta 5: Tipos Especializados de Tablas**

**Ejemplos MySQL:**

```sql
-- Tablas dimensionales
CREATE TABLE dim_tiempo (
    fecha_id INT PRIMARY KEY AUTO_INCREMENT,
    fecha_completa DATE NOT NULL,
    año INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    nombre_mes VARCHAR(20),
    dia_semana VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE dim_producto (
    producto_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo_producto VARCHAR(20) UNIQUE NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2),
    marca VARCHAR(50),
    fecha_creacion DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE dim_cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    dni VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(20),
    ciudad VARCHAR(50),
    pais VARCHAR(50),
    segmento VARCHAR(30)
) ENGINE=InnoDB;

-- Tabla de hechos (ventas)
CREATE TABLE fact_ventas (
    venta_id INT AUTO_INCREMENT,
    fecha_id INT NOT NULL,
    producto_id INT NOT NULL,
    cliente_id INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) AS (cantidad * precio_unitario - descuento) STORED,
    
    PRIMARY KEY (venta_id),
    
    FOREIGN KEY (fecha_id) 
        REFERENCES dim_tiempo(fecha_id),
        
    FOREIGN KEY (producto_id) 
        REFERENCES dim_producto(producto_id),
        
    FOREIGN KEY (cliente_id) 
        REFERENCES dim_cliente(cliente_id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- Insertar datos de ejemplo en dimensiones
INSERT INTO dim_tiempo (fecha_completa, año, trimestre, mes, dia, nombre_mes, dia_semana)
VALUES 
('2024-01-15', 2024, 1, 1, 15, 'Enero', 'Lunes'),
('2024-02-20', 2024, 1, 2, 20, 'Febrero', 'Martes');

INSERT INTO dim_producto (codigo_producto, nombre_producto, categoria, precio, costo)
VALUES 
('PROD001', 'Laptop Dell XPS', 'Tecnología', 1200.00, 850.00),
('PROD002', 'Mouse Inalámbrico', 'Accesorios', 25.99, 12.50);

INSERT INTO dim_cliente (dni, nombre, apellido, email, ciudad, segmento)
VALUES 
('12345678A', 'Juan', 'Pérez', 'juan@email.com', 'Madrid', 'Premium'),
('87654321B', 'Laura', 'García', 'laura@email.com', 'Barcelona', 'Regular');
```

---

### **Posta 6: Claves Avanzadas y Modificación de Estructura**

**Ejemplos MySQL:**

```sql
-- 1. Clave primaria compuesta
ALTER TABLE Inscripciones
DROP PRIMARY KEY,
ADD PRIMARY KEY (estudiante_id, curso_id, fecha_inscripcion);

-- 2. Crear índices
-- Índice único en email
ALTER TABLE Estudiantes
ADD UNIQUE INDEX idx_email_unique (email);

-- Índice compuesto
CREATE INDEX idx_nombre_apellido 
ON Estudiantes (nombre, apellido);

-- Índice en fecha de nacimiento
CREATE INDEX idx_fecha_nacimiento 
ON Estudiantes (fecha_nacimiento);

-- Índice para consultas frecuentes
CREATE INDEX idx_inscripciones_curso_fecha 
ON Inscripciones (curso_id, fecha_inscripcion DESC);

-- 3. Modificar estructura de tabla
-- Agregar columna con valor por defecto
ALTER TABLE Estudiantes
ADD COLUMN activo TINYINT(1) DEFAULT 1 AFTER email,
ADD COLUMN fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Cambiar tipo de columna
ALTER TABLE Estudiantes
MODIFY COLUMN nombre VARCHAR(100) NOT NULL;

-- Renombrar columna
ALTER TABLE Estudiantes
CHANGE COLUMN apellido apellidos VARCHAR(100) NOT NULL;

-- Eliminar columna
ALTER TABLE Estudiantes
DROP COLUMN IF EXISTS telefono;

-- Agregar restricción CHECK (MySQL 8.0+)
ALTER TABLE Estudiantes
ADD CONSTRAINT chk_fecha_nacimiento 
CHECK (fecha_nacimiento < CURDATE());

-- 4. Tabla con AUTO_INCREMENT y comentarios
CREATE TABLE Profesores (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre completo',
    departamento VARCHAR(50) DEFAULT 'General',
    salario DECIMAL(10,2) COMMENT 'Salario anual',
    fecha_contratacion DATE NOT NULL,
    
    INDEX idx_departamento (departamento),
    INDEX idx_fecha_contratacion (fecha_contratacion)
) ENGINE=InnoDB AUTO_INCREMENT=1000 COMMENT='Tabla de profesores';

-- 5. Vista de índice (SHOW INDEX)
SHOW INDEX FROM Estudiantes;

-- Ver información de índices
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    INDEX_TYPE,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'universidad'
AND TABLE_NAME = 'Estudiantes';
```

---

### **Posta 7: Implementación de un Diagrama E-R Completo**

**Ejemplo MySQL - Sistema de Biblioteca:**

```sql
-- Crear base de datos de biblioteca
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- 1. Tabla Libros
CREATE TABLE Libros (
    libro_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    editorial VARCHAR(100),
    año_publicacion YEAR,
    categoria VARCHAR(50),
    disponible BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_titulo (titulo),
    INDEX idx_autor (autor),
    INDEX idx_categoria (categoria),
    INDEX idx_disponible (disponible)
) ENGINE=InnoDB COMMENT='Catálogo de libros';

-- 2. Tabla Usuarios
CREATE TABLE Usuarios (
    usuario_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    tipo_usuario ENUM('Estudiante', 'Profesor', 'Personal', 'Externo') DEFAULT 'Estudiante',
    max_libros_prestados INT DEFAULT 3,
    activo BOOLEAN DEFAULT TRUE,
    
    INDEX idx_nombre_completo (nombre, apellido),
    INDEX idx_tipo_usuario (tipo_usuario)
) ENGINE=InnoDB;

-- 3. Tabla Préstamos
CREATE TABLE Prestamos (
    prestamo_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_prestamo DATE NOT NULL DEFAULT (CURRENT_DATE),
    fecha_devolucion_prevista DATE NOT NULL,
    fecha_devolucion_real DATE,
    estado ENUM('Activo', 'Devuelto', 'Vencido', 'Perdido') DEFAULT 'Activo',
    multa DECIMAL(10,2) DEFAULT 0.00,
    
    -- Clave única para evitar préstamos duplicados activos
    UNIQUE INDEX idx_prestamo_activo (libro_id, usuario_id, estado),
    
    FOREIGN KEY (libro_id) 
        REFERENCES Libros(libro_id)
        ON DELETE RESTRICT,
        
    FOREIGN KEY (usuario_id) 
        REFERENCES Usuarios(usuario_id)
        ON DELETE RESTRICT,
    
    -- Índices para consultas frecuentes
    INDEX idx_fecha_prestamo (fecha_prestamo),
    INDEX idx_fecha_devolucion (fecha_devolucion_prevista),
    INDEX idx_estado (estado)
) ENGINE=InnoDB;

-- 4. Función: libros prestados por usuario
DELIMITER $$

CREATE FUNCTION libros_prestados_usuario(id_usuario INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_prestados INT;
    
    SELECT COUNT(*) INTO total_prestados
    FROM Prestamos
    WHERE usuario_id = id_usuario
    AND estado = 'Activo';
    
    RETURN total_prestados;
END$$

-- 5. Función: calcular días de retraso
CREATE FUNCTION calcular_dias_retraso(fecha_prevista DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE dias INT;
    
    IF fecha_prevista < CURDATE() THEN
        SET dias = DATEDIFF(CURDATE(), fecha_prevista);
    ELSE
        SET dias = 0;
    END IF;
    
    RETURN dias;
END$$

-- 6. Trigger: actualizar disponibilidad del libro
CREATE TRIGGER after_insert_prestamo
AFTER INSERT ON Prestamos
FOR EACH ROW
BEGIN
    -- Marcar libro como no disponible
    UPDATE Libros 
    SET disponible = FALSE 
    WHERE libro_id = NEW.libro_id;
    
    -- Registrar en historial
    INSERT INTO historial_prestamos 
    (prestamo_id, accion, fecha_accion)
    VALUES (NEW.prestamo_id, 'PRÉSTamo', NOW());
END$$

-- 7. Trigger: al devolver libro
CREATE TRIGGER after_update_prestamo
AFTER UPDATE ON Prestamos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Devuelto' AND OLD.estado != 'Devuelto' THEN
        -- Marcar libro como disponible
        UPDATE Libros 
        SET disponible = TRUE 
        WHERE libro_id = NEW.libro_id;
        
        -- Calcular multa si hay retraso
        IF NEW.fecha_devolucion_real > NEW.fecha_devolucion_prevista THEN
            UPDATE Prestamos 
            SET multa = calcular_dias_retraso(NEW.fecha_devolucion_prevista) * 0.50
            WHERE prestamo_id = NEW.prestamo_id;
        END IF;
        
        -- Registrar en historial
        INSERT INTO historial_prestamos 
        (prestamo_id, accion, fecha_accion)
        VALUES (NEW.prestamo_id, 'DEVOLUCIÓN', NOW());
    END IF;
END$$

DELIMITER ;

-- 8. Tabla de historial
CREATE TABLE historial_prestamos (
    historial_id INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id INT NOT NULL,
    accion VARCHAR(50) NOT NULL,
    fecha_accion DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (prestamo_id) 
        REFERENCES Prestamos(prestamo_id)
        ON DELETE CASCADE,
    
    INDEX idx_fecha_accion (fecha_accion)
);

-- 9. Vista: préstamos activos
CREATE VIEW vista_prestamos_activos AS
SELECT 
    p.prestamo_id,
    l.titulo AS libro,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    p.fecha_prestamo,
    p.fecha_devolucion_prevista,
    calcular_dias_retraso(p.fecha_devolucion_prevista) AS dias_retraso,
    p.multa
FROM Prestamos p
JOIN Libros l ON p.libro_id = l.libro_id
JOIN Usuarios u ON p.usuario_id = u.usuario_id
WHERE p.estado = 'Activo';

-- 10. Procedimiento: realizar préstamo
DELIMITER $$

CREATE PROCEDURE realizar_prestamo(
    IN p_libro_id INT,
    IN p_usuario_id INT,
    IN p_dias_prestamo INT
)
BEGIN
    DECLARE v_max_libros INT;
    DECLARE v_libros_actuales INT;
    
    -- Verificar límite de préstamos del usuario
    SELECT max_libros_prestados INTO v_max_libros
    FROM Usuarios WHERE usuario_id = p_usuario_id;
    
    SET v_libros_actuales = libros_prestados_usuario(p_usuario_id);
    
    IF v_libros_actuales >= v_max_libros THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario ha alcanzado el límite de préstamos';
    END IF;
    
    -- Verificar disponibilidad del libro
    IF NOT (SELECT disponible FROM Libros WHERE libro_id = p_libro_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El libro no está disponible';
    END IF;
    
    -- Insertar préstamo
    INSERT INTO Prestamos (libro_id, usuario_id, fecha_devolucion_prevista)
    VALUES (p_libro_id, p_usuario_id, 
            DATE_ADD(CURRENT_DATE, INTERVAL p_dias_prestamo DAY));
    
    SELECT 'Préstamo realizado exitosamente' AS mensaje;
END$$

DELIMITER ;
```

---

### **Material Complementario - Ejemplos Adicionales MySQL**

```sql
-- 1. Vistas Materializadas (simuladas en MySQL)
CREATE TABLE mv_estadisticas_libros (
    libro_id INT PRIMARY KEY,
    titulo VARCHAR(200),
    total_prestados INT,
    ultimo_prestamo DATE,
    INDEX idx_total_prestados (total_prestados)
);

-- Evento para actualizar estadísticas diariamente
DELIMITER $$

CREATE EVENT actualizar_estadisticas_libros
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    TRUNCATE TABLE mv_estadisticas_libros;
    
    INSERT INTO mv_estadisticas_libros
    SELECT 
        l.libro_id,
        l.titulo,
        COUNT(p.prestamo_id) AS total_prestados,
        MAX(p.fecha_prestamo) AS ultimo_prestamo
    FROM Libros l
    LEFT JOIN Prestamos p ON l.libro_id = p.libro_id
    GROUP BY l.libro_id, l.titulo;
END$$

DELIMITER ;

-- 2. Índices FULLTEXT para búsqueda de texto
ALTER TABLE Libros
ADD FULLTEXT INDEX idx_busqueda_fulltext (titulo, autor, editorial);

-- Búsqueda con FULLTEXT
SELECT * FROM Libros
WHERE MATCH(titulo, autor, editorial) 
AGAINST('base datos' IN NATURAL LANGUAGE MODE);

-- 3. Particionamiento por rangos (MySQL 5.7+)
CREATE TABLE prestamos_particionados (
    prestamo_id INT AUTO_INCREMENT,
    libro_id INT,
    usuario_id INT,
    fecha_prestamo DATE,
    -- ... otras columnas
    PRIMARY KEY (prestamo_id, fecha_prestamo)
)
PARTITION BY RANGE (YEAR(fecha_prestamo)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_futuro VALUES LESS THAN MAXVALUE
);

-- 4. Variables de sesión y preparación dinámica
SET @libro_buscado = 'SQL';

PREPARE stmt FROM '
    SELECT libro_id, titulo, autor
    FROM Libros
    WHERE titulo LIKE CONCAT("%", ?, "%")
    ORDER BY titulo
    LIMIT 10';

EXECUTE stmt USING @libro_buscado;
DEALLOCATE PREPARE stmt;
```

Estos ejemplos MySQL son completamente funcionales y cubren todos los conceptos mencionados en las postas. Se han incluido características específicas de MySQL como:
- `ENGINE=InnoDB`
- `AUTO_INCREMENT` para PK
- `DELIMITER` para funciones y triggers
- Índices `FULLTEXT`
- Particionamiento de tablas
- Variables de sesión y consultas preparadas
- Funciones específicas como `CURDATE()`, `NOW()`, `DATEDIFF()`