### **Ejercicios sobre FUNCTIONS**

#### **Ejercicio F1: Obtener el nombre completo de un usuario**

*   **Objetivo:** Crear una función que, dado el ID de un usuario, devuelva su nombre y apellido concatenados.
*   **Tabla:** `SYSTEM_USER` (columnas `id_system_user`, `first_name`, `last_name`)
*   **Consigna:**
    1.  Crea una función llamada `fn_nombre_completo_usuario`.
    2.  Debe recibir un parámetro de entrada `p_user_id` de tipo `INT`.
    3.  La función debe retornar un `VARCHAR(101)` (para que quepa el nombre, un espacio y el apellido).
    4.  Dentro de la función, declara una variable `v_nombre_completo VARCHAR(101)`.
    5.  Realiza un `SELECT` que concatene `first_name` y `last_name` (con un espacio en el medio) y guarda el resultado en la variable `v_nombre_completo`. Puedes usar la función `CONCAT(first_name, ' ', last_name)`.
    6.  Retorna la variable `v_nombre_completo`.
    7.  **Prueba:** Obtén el nombre completo del usuario con `id_system_user = 5`.

---

#### **Ejercicio F2: Calcular el promedio de votos de un juego**

*   **Objetivo:** Crear una función que, dado el ID de un juego, calcule el promedio de los votos que ha recibido.
*   **Tablas:** `GAME` y `VOTE` (columna `value` en `VOTE`, unida por `id_game`).
*   **Consigna:**
    1.  Crea una función llamada `fn_promedio_votos_juego`.
    2.  Debe recibir un parámetro de entrada `p_id_game` de tipo `INT`.
    3.  La función debe retornar un valor `DECIMAL(3,1)` (para mostrar un número como 8.5).
    4.  Dentro de la función, declara una variable `v_promedio DECIMAL(3,1)`.
    5.  Calcula el promedio de la columna `value` de la tabla `VOTE` para el `id_game` recibido y almacénalo en la variable. Usa la función de agregado `AVG()`. Ten en cuenta que un juego podría no tener votos, lo que podría devolver `NULL`.
    6.  Si el promedio es `NULL`, asigna el valor `0` a `v_promedio` usando la función `IFNULL()`.
    7.  Retorna `v_promedio`.
    8.  **Prueba:** Obtén el promedio de votos del juego con `id_game = 55` ("Kimetsu no Yaiba").

---

### **Ejercicios sobre STORED PROCEDURES**

#### **Ejercicio SP1: Listar juegos por nivel (con parámetro IN)**

*   **Objetivo:** Crear un procedimiento que muestre todos los juegos que pertenecen a un nivel específico.
*   **Tablas:** `GAME` (columna `id_level`), `LEVEL_GAME`.
*   **Consigna:**
    1.  Crea un procedimiento llamado `sp_juegos_por_nivel`.
    2.  Debe recibir un parámetro de entrada `IN p_id_level INT`.
    3.  El procedimiento debe realizar un `SELECT` que muestre el `id_game`, el `name` del juego y la `description` del nivel (obtenida de la tabla `LEVEL_GAME`).
    4.  Filtra los resultados para que solo se muestren los juegos cuyo `id_level` coincida con `p_id_level`.
    5.  **Prueba:** Ejecuta el procedimiento para listar todos los juegos de nivel 10 (`CALL sp_juegos_por_nivel(10);`).

---

#### **Ejercicio SP2: Insertar un nuevo comentario (con parámetros IN)**

*   **Objetivo:** Crear un procedimiento que permita a un usuario agregar un comentario sobre un juego. El procedimiento deberá insertar un registro en la tabla `COMMENT` y otro en la tabla `COMMENTARY`.
*   **Tablas:** `COMMENT` y `COMMENTARY`.
*   **Consigna:**
    1.  Crea un procedimiento llamado `sp_agregar_comentario`.
    2.  Debe recibir tres parámetros de entrada:
        *   `IN p_id_game INT`
        *   `IN p_id_system_user INT`
        *   `IN p_comentario VARCHAR(200)`
    3.  El procedimiento debe realizar dos inserciones:
        *   En la tabla `COMMENT`, asumiendo que es el primer comentario del usuario para ese juego, inserta una fila con `id_game`, `id_system_user`, `first_date` como la fecha actual (`CURDATE()`) y `last_date` como `NULL`.
        *   En la tabla `COMMENTARY`, necesitarás generar un nuevo `id_commentary`. Para simplificar, puedes obtener el máximo `id_commentary` de la tabla y sumarle 1, o declarar una variable para almacenar ese nuevo ID. Inserta una fila con ese nuevo ID, el `id_game`, el `id_system_user`, la fecha actual (`CURDATE()`) y el texto del comentario (`p_comentario`).
    4.  **Prueba:** Agrega un comentario para el juego con `id_game = 1` ("Forza Horizon 5") realizado por el usuario con `id_system_user = 10`. El comentario puede ser, por ejemplo, '"¡Me encanta este juego!"'.

---

### **Ejercicios sobre PREPARED STATEMENT (dentro de Stored Procedures)**

#### **Ejercicio PS1: Consulta dinámica para ordenar juegos**

*   **Objetivo:** Crear un procedimiento que permita ordenar la lista de juegos por cualquier columna, de forma ascendente o descendente. Este ejercicio es muy similar al ejemplo práctico de la clase.
*   **Tabla:** `GAME`.
*   **Consigna:**
    1.  Crea un procedimiento llamado `sp_ordenar_juegos`.
    2.  Debe recibir dos parámetros de entrada:
        *   `IN p_columna VARCHAR(50)`: El nombre de la columna por la cual ordenar (ej. 'name', 'id_game').
        *   `IN p_direccion VARCHAR(4)`: La dirección del orden ('ASC' o 'DESC').
    3.  Dentro del procedimiento, declara una variable `@sql_query` para construir la consulta SQL como una cadena de texto.
    4.  Construye la cadena: `SET @sql_query = CONCAT('SELECT * FROM game ORDER BY ', p_columna, ' ', p_direccion);`
    5.  Prepara la sentencia SQL con `PREPARE stmt FROM @sql_query;`.
    6.  Ejecuta la sentencia con `EXECUTE stmt;`.
    7.  Finalmente, libera los recursos con `DEALLOCATE PREPARE stmt;`.
    8.  **Prueba:**
        *   `CALL sp_ordenar_juegos('name', 'ASC');` (Debería listar juegos ordenados alfabéticamente).
        *   `CALL sp_ordenar_juegos('id_game', 'DESC');` (Debería listar juegos del ID más reciente al más antiguo).

---

#### **Ejercicio PS2: Búsqueda flexible de usuarios por nombre**

*   **Objetivo:** Crear un procedimiento que busque usuarios cuyo nombre (`first_name`) contenga un texto específico, utilizando `LIKE` de forma dinámica.
*   **Tabla:** `SYSTEM_USER`.
*   **Consigna:**
    1.  Crea un procedimiento llamado `sp_buscar_usuarios`.
    2.  Debe recibir un parámetro de entrada `IN p_texto_busqueda VARCHAR(50)`.
    3.  Dentro del procedimiento, declara una variable `@sql_query`.
    4.  Construye una consulta SQL que seleccione `id_system_user`, `first_name` y `last_name` de la tabla `SYSTEM_USER`.
    5.  La cláusula `WHERE` debe ser dinámica: `WHERE first_name LIKE CONCAT('%', p_texto_busqueda, '%')`.
    6.  Prepara, ejecuta y libera la sentencia.
    7.  **Prueba:**
        *   `CALL sp_buscar_usuarios('a');` (Buscaría usuarios con una 'a' en su nombre, como 'Tyson', 'Tam', 'Rosamund').
        *   `CALL sp_buscar_usuarios('son');` (Buscaría usuarios como 'Tyson').


---

### **Ejercicios sobre FUNCTIONS**

#### **Ejercicio F1: Obtener el nombre completo de un usuario**

<details>
<summary>Solución F1</summary>

```sql
DELIMITER //

CREATE FUNCTION fn_nombre_completo_usuario(p_user_id INT)
RETURNS VARCHAR(101)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_nombre_completo VARCHAR(101);
    
    SELECT CONCAT(first_name, ' ', last_name) INTO v_nombre_completo
    FROM SYSTEM_USER
    WHERE id_system_user = p_user_id;
    
    RETURN v_nombre_completo;
END //

DELIMITER ;

-- Prueba: Obtener el nombre completo del usuario con id_system_user = 5
SELECT fn_nombre_completo_usuario(5) AS nombre_completo;
-- Resultado esperado: 'Averell Alliot'
```
</details>

---

#### **Ejercicio F2: Calcular el promedio de votos de un juego**

<details>
<summary>Solución F2</summary>

```sql
DELIMITER //

CREATE FUNCTION fn_promedio_votos_juego(p_id_game INT)
RETURNS DECIMAL(3,1)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(3,1);
    
    SELECT IFNULL(AVG(value), 0) INTO v_promedio
    FROM VOTE
    WHERE id_game = p_id_game;
    
    RETURN v_promedio;
END //

DELIMITER ;

-- Prueba: Obtener el promedio de votos del juego con id_game = 55
SELECT fn_promedio_votos_juego(55) AS promedio_votos;
-- Resultado esperado: El promedio de votos del juego "Kimetsu no Yaiba - The Hinokami Chronicles"
```
</details>

---

### **Ejercicios sobre STORED PROCEDURES**

#### **Ejercicio SP1: Listar juegos por nivel (con parámetro IN)**

<details>
<summary>Solución SP1</summary>

```sql
DELIMITER //

CREATE PROCEDURE sp_juegos_por_nivel(IN p_id_level INT)
BEGIN
    SELECT g.id_game, 
           g.name AS nombre_juego, 
           lg.description AS nivel
    FROM GAME g
    INNER JOIN LEVEL_GAME lg ON g.id_level = lg.id_level
    WHERE g.id_level = p_id_level;
END //

DELIMITER ;

-- Prueba: Listar todos los juegos de nivel 10
CALL sp_juegos_por_nivel(10);
-- Resultado esperado: Juegos como 'Kimetsu no Yaiba', 'Elden Ring', 'Lost Ark', etc.
```
</details>

---

#### **Ejercicio SP2: Insertar un nuevo comentario (con parámetros IN)**

<details>
<summary>Solución SP2</summary>

```sql
DELIMITER //

CREATE PROCEDURE sp_agregar_comentario(
    IN p_id_game INT,
    IN p_id_system_user INT,
    IN p_comentario VARCHAR(200)
)
BEGIN
    DECLARE v_nuevo_id_commentary INT;
    
    -- Verificar si ya existe un registro en COMMENT para este usuario y juego
    -- Si no existe, lo creamos
    INSERT INTO COMMENT (id_game, id_system_user, first_date, last_date)
    VALUES (p_id_game, p_id_system_user, CURDATE(), NULL)
    ON DUPLICATE KEY UPDATE last_date = CURDATE();
    
    -- Obtener el nuevo ID para el comentario
    SELECT IFNULL(MAX(id_commentary), 0) + 1 INTO v_nuevo_id_commentary
    FROM COMMENTARY;
    
    -- Insertar el comentario en COMMENTARY
    INSERT INTO COMMENTARY (id_commentary, id_game, id_system_user, comment_date, commentary)
    VALUES (v_nuevo_id_commentary, p_id_game, p_id_system_user, CURDATE(), p_comentario);
    
    SELECT 'Comentario agregado correctamente' AS mensaje;
END //

DELIMITER ;

-- Prueba: Agregar un comentario para el juego con id_game = 1, usuario id_system_user = 10
CALL sp_agregar_comentario(1, 10, '¡Me encanta este juego!');

-- Verificar que se haya insertado correctamente
SELECT * FROM COMMENTARY WHERE id_game = 1 AND id_system_user = 10;
```
</details>

---

### **Ejercicios sobre PREPARED STATEMENT (dentro de Stored Procedures)**

#### **Ejercicio PS1: Consulta dinámica para ordenar juegos**

<details>
<summary>Solución PS1</summary>

```sql
DELIMITER //

CREATE PROCEDURE sp_ordenar_juegos(
    IN p_columna VARCHAR(50),
    IN p_direccion VARCHAR(4)
)
BEGIN
    -- Variable para almacenar la consulta SQL dinámica
    SET @sql_query = CONCAT('SELECT * FROM game ORDER BY ', p_columna, ' ', p_direccion);
    
    -- Preparar y ejecutar la consulta
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- Prueba 1: Ordenar juegos por nombre alfabéticamente
CALL sp_ordenar_juegos('name', 'ASC');

-- Prueba 2: Ordenar juegos del ID más reciente al más antiguo
CALL sp_ordenar_juegos('id_game', 'DESC');
```
</details>

---

#### **Ejercicio PS2: Búsqueda flexible de usuarios por nombre**

<details>
<summary>Solución PS2</summary>

```sql
DELIMITER //

CREATE PROCEDURE sp_buscar_usuarios(
    IN p_texto_busqueda VARCHAR(50)
)
BEGIN
    -- Variable para almacenar la consulta SQL dinámica
    SET @sql_query = CONCAT(
        'SELECT id_system_user, first_name, last_name, email ',
        'FROM SYSTEM_USER ',
        'WHERE first_name LIKE ''%', p_texto_busqueda, '%'''
    );
    
    -- Preparar y ejecutar la consulta
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- Prueba 1: Buscar usuarios con 'a' en su nombre
CALL sp_buscar_usuarios('a');
-- Resultado esperado: Usuarios como 'Tyson', 'Tam', 'Rosamund', etc.

-- Prueba 2: Buscar usuarios con 'son' en su nombre
CALL sp_buscar_usuarios('son');
-- Resultado esperado: Usuarios como 'Tyson'
```
</details>

---

### **Ejercicio Extra (Desafío): Stored Procedure con PREPARE y validación**

Este ejercicio combina los conceptos de parámetros, `PREPARE` y validación de datos, similar a la actividad en clase del PDF.

#### **Ejercicio Extra: Insertar un nuevo juego con verificación**

*   **Objetivo:** Crear un procedimiento que inserte un nuevo juego en la tabla `GAME`, pero solo si el nombre del juego no existe previamente. Debe usar `PREPARE` para construir la consulta de verificación.
*   **Tabla:** `GAME`.
*   **Consigna:**
    1.  Crea un procedimiento llamado `sp_insertar_juego_seguro`.
    2.  Debe recibir los parámetros necesarios para insertar un juego (`p_name`, `p_description`, `p_id_level`, `p_id_class`).
    3.  El procedimiento debe:
        *   Verificar si ya existe un juego con el mismo `name` en la tabla.
        *   Si **no existe**, generar un nuevo `id_game` (obteniendo el máximo + 1) e insertar el nuevo juego. Devolver un mensaje de éxito.
        *   Si **existe**, devolver un mensaje de error: `'ERROR: Ya existe un juego con ese nombre'`.
    4.  Utiliza `PREPARE` para construir y ejecutar la consulta de verificación.

<details>
<summary>Solución Ejercicio Extra</summary>

```sql
DELIMITER //

CREATE PROCEDURE sp_insertar_juego_seguro(
    IN p_name VARCHAR(100),
    IN p_description VARCHAR(300),
    IN p_id_level INT,
    IN p_id_class INT
)
BEGIN
    DECLARE v_existe INT;
    DECLARE v_nuevo_id INT;
    
    -- Construir consulta dinámica para verificar si el juego ya existe
    SET @sql_check = CONCAT(
        'SELECT COUNT(*) INTO @existe FROM game WHERE name = ''', 
        p_name, ''''
    );
    
    -- Preparar y ejecutar la verificación
    PREPARE stmt_check FROM @sql_check;
    EXECUTE stmt_check;
    DEALLOCATE PREPARE stmt_check;
    
    -- Obtener el resultado de la variable de usuario a una variable local
    SET v_existe = @existe;
    
    -- Validar el resultado
    IF v_existe > 0 THEN
        SELECT 'ERROR: Ya existe un juego con ese nombre' AS mensaje;
    ELSE
        -- Generar nuevo ID
        SELECT IFNULL(MAX(id_game), 0) + 1 INTO v_nuevo_id FROM game;
        
        -- Insertar el nuevo juego
        INSERT INTO game (id_game, name, description, id_level, id_class)
        VALUES (v_nuevo_id, p_name, p_description, p_id_level, p_id_class);
        
        SELECT CONCAT('Juego "', p_name, '" insertado correctamente con ID: ', v_nuevo_id) AS mensaje;
    END IF;
END //

DELIMITER ;

-- Prueba 1: Intentar insertar un juego que ya existe
CALL sp_insertar_juego_seguro('Elden Ring', 'Juego de prueba', 10, 5);
-- Resultado esperado: Mensaje de error

-- Prueba 2: Insertar un juego nuevo
CALL sp_insertar_juego_seguro('Mi Nuevo Juego', 'Descripción de prueba', 5, 10);
-- Resultado esperado: Mensaje de éxito con el nuevo ID
```
</details>