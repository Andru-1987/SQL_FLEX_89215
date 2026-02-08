## Resumen: Sublenguaje DML (Data Manipulation Language)

El DML es el componente de SQL encargado de manipular los datos dentro de las tablas de una base de datos. Sus operaciones fundamentales son **INSERT**, **UPDATE** y **DELETE**.

---

### Posta 1: Fundamentos de DML
**Objetivo:** Comprender y aplicar las sentencias básicas de manipulación de datos.

**Conceptos Clave:**
*   **INSERT:** Agrega nuevos registros a una tabla.
    ```sql
    INSERT INTO tabla (campo1, campo2) VALUES (valor1, valor2);
    ```
*   **UPDATE:** Modifica registros existentes.
    ```sql
    UPDATE tabla SET campo1 = nuevo_valor WHERE condición;
    ```
*   **DELETE:** Elimina registros.
    ```sql
    DELETE FROM tabla WHERE condición;
    ```

**Recomendaciones Críticas:**
1.  **Nunca olvides la cláusula `WHERE`** en `UPDATE` y `DELETE`. Su omisión afecta a **todos** los registros.
2.  **Valida siempre antes de modificar.** Ejecuta primero un `SELECT` con la misma condición para ver qué registros serán impactados.
3.  **Respeta la integridad referencial.** No podrás eliminar un registro si otra tabla hace referencia a él (clave foránea), a menos que uses `CASCADE` o elimines primero los registros dependientes.
4.  **Usa transacciones (`START TRANSACTION; ... COMMIT/ROLLBACK;`)** para agrupar operaciones que deben ejecutarse como una sola unidad atómica (todo o nada).

---

### Posta 2: DML Avanzado y Subconsultas
**Objetivo:** Realizar operaciones complejas integrando múltiples tablas y condiciones dinámicas.

**Conceptos Clave:**
*   **Subconsultas en DML:** Utiliza el resultado de un `SELECT` dentro de un `INSERT`, `UPDATE` o `DELETE`.
    ```sql
    -- INSERT con SELECT
    INSERT INTO tabla_destino (campo)
    SELECT campo_origen FROM tabla_fuente WHERE condición;

    -- UPDATE con subconsulta en WHERE
    UPDATE tabla1 SET campo = valor
    WHERE id IN (SELECT id FROM tabla2 WHERE condición);
    ```
*   **Manejo de Relaciones:** Para operaciones que involucran varias tablas relacionadas, planifica el orden (ej: insertar en la tabla "padre" antes que en la "hija") y usa transacciones para mantener la consistencia.

**Recomendaciones Críticas:**
1.  **Domina las subconsultas.** Son la herramienta principal para operaciones DML basadas en condiciones complejas o datos de otras tablas.
2.  **Piensa en la integridad.** Al diseñar una operación DML compleja, traza mentalmente el impacto en todas las tablas relacionadas.
3.  **Utiliza `COMMIT` y `ROLLBACK` estratégicamente.** Confirma (`COMMIT`) solo cuando todas las partes de la operación compleja estén listas. Ante un error, revierte (`ROLLBACK`) todo.

---

### Posta 3: Optimización y Buenas Prácticas en DML
**Objetivo:** Escribir sentencias DML eficientes y seguras para sistemas con grandes volúmenes de datos.

**Conceptos Clave:**
*   **Índices:** Son cruciales para el rendimiento de las condiciones `WHERE` en `UPDATE` y `DELETE`. Sin embargo, **añaden sobrecarga en operaciones `INSERT`** porque deben actualizarse.
*   **Cláusula `WHERE` Eficiente:**
    *   Sé lo más específico posible.
    *   Usa condiciones que aprovechen índices (evita aplicar funciones a la columna indexada, ej: `WHERE UPPER(nombre) = 'A'`).
*   **Operaciones Masivas:**
    *   Para muchas inserciones, usa una sola sentencia `INSERT` con múltiples `VALUES`.
    *   En actualizaciones/eliminaciones masivas, considera deshabilitar índices temporalmente (solo en mantenimiento controlado) y reactivarlos luego.

**Recomendaciones Críticas:**
1.  **Analiza el plan de ejecución.** Antes de lanzar una operación DML compleja en producción, usa `EXPLAIN` (o la herramienta equivalente de tu motor) para prever su comportamiento y coste.
2.  **Equilibrio en los índices.** Indexa columnas usadas frecuentemente en `WHERE`, `JOIN` u `ORDER BY`, pero sé consciente de que ralentizarán ligeramente los `INSERT`.
3.  **Modo seguro (`SQL_SAFE_UPDATES`):** Actívalo en entornos de desarrollo. Te obligará a usar `WHERE` con claves, previniendo accidentes.
4.  **Copia de seguridad (Backup):** Realiza un backup o verifica puntos de restauración antes de ejecutar operaciones DML masivas o complejas en producción.

---

## Ejercicios Prácticos DML - Base `coderhouse_gamers`

### **Posta 1: Fundamentos de DML**

**Ejercicio 1.1 - INSERT básico**
1. Inserta un nuevo usuario en `SYSTEM_USER` con los siguientes datos:
   - `id_system_user`: 1000
   - `first_name`: 'Ana'
   - `last_name`: 'López'
   - `email`: 'ana.lopez@email.com'
   - `password`: 'pass123'
   - `id_user_type`: 1
2. Luego, verifica la inserción con un SELECT.

**Ejercicio 1.2 - INSERT múltiple**
1. Inserta tres nuevos juegos en la tabla `GAME` con una sola sentencia:
   - Juego 1: id_game=101, name='FIFA 23', description='Juego de fútbol', id_level=2, id_class=1
   - Juego 2: id_game=102, name='Minecraft', description='Mundo abierto', id_level=1, id_class=2
   - Juego 3: id_game=103, name='Cyberpunk 2077', description='RPG futurista', id_level=3, id_class=1

**Ejercicio 1.3 - UPDATE con WHERE**
1. Actualiza el email del usuario con `id_system_user` = 1000 a 'ana.lopez.nuevo@email.com'.
2. Cambia la descripción de todos los juegos del nivel 2 (`id_level=2`) a 'Juego para nivel intermedio'.

**Ejercicio 1.4 - DELETE con condiciones**
1. Elimina el juego con `id_game` = 103 que acabas de insertar.
2. Antes de eliminar, ejecuta un SELECT para verificar qué registro será afectado.

---

### **Posta 2: DML Avanzado y Subconsultas**

**Ejercicio 2.1 - INSERT con SELECT (Subconsulta)**
1. Inserta un nuevo registro en la tabla `PLAY` para el usuario recién creado (id_system_user=1000) jugando al juego 'Minecraft' (id_game=102), marcando como no completado.
   - Debes obtener el id_game mediante una subconsulta.
   
   ```sql
   INSERT INTO PLAY (id_game, id_system_user, completed)
   VALUES (
       (SELECT id_game FROM GAME WHERE name = 'Minecraft'),
       1000,
       false
   );
   ```

**Ejercicio 2.2 - UPDATE con Subconsulta**
1. Actualiza todos los juegos que han sido votados con valor mayor a 8, cambiando su nivel a 4.
   ```sql
   UPDATE GAME
   SET id_level = 4
   WHERE id_game IN (
       SELECT DISTINCT id_game 
       FROM VOTE 
       WHERE value > 8
   );
   ```

**Ejercicio 2.3 - DELETE con Subconsulta y Transacción**
1. Inicia una transacción.
2. Elimina todos los votos (`VOTE`) de usuarios cuyo email termine en '@olddomain.com'.
3. Luego, elimina esos usuarios de `SYSTEM_USER`.
4. Verifica con SELECT antes de cada DELETE.
5. Si todo está correcto, haz COMMIT; si hay error, ROLLBACK.

---

### **Posta 3: Optimización y Buenas Prácticas**

**Ejercicio 3.1 - Operación Masiva con Índices**
1. Crea un índice en la columna `email` de `SYSTEM_USER`:
   ```sql
   CREATE INDEX idx_user_email ON SYSTEM_USER(email);
   ```
2. Realiza una actualización masiva: cambia el dominio de email de todos los usuarios de 'webnode.com' a 'newnode.com'.
3. Analiza el rendimiento con EXPLAIN antes y después del índice.

**Ejercicio 3.2 - Inserción Masiva Eficiente**
1. Inserta 500 votos simulados en la tabla `VOTE` usando una sola sentencia INSERT con múltiples VALUES (puedes generar datos ficticios o usar un script de generación).

**Ejercicio 3.3 - Mantenimiento con DML**
1. Realiza una limpieza de datos:
   - Marca como completados (`completed = true`) todos los juegos que tengan más de 10 votos con promedio mayor a 9.
   - Esto requiere subconsultas y posiblemente una tabla temporal.

---

### **Ejercicios de Integración Compleja**

**Ejercicio 4.1 - Proceso Completo de Registro**
Simula el registro de un nuevo usuario y sus primeras acciones:
1. Inserta un nuevo `USER_TYPE` si no existe.
2. Inserta un nuevo usuario en `SYSTEM_USER`.
3. Inserta que juega a 3 juegos diferentes en `PLAY`.
4. Inserta 2 votos en `VOTE` para juegos diferentes.
5. Inserta 1 comentario en `COMMENTARY`.
6. **Todo debe hacerse en una sola transacción.**

**Ejercicio 4.2 - Migración de Datos**
1. Crea una tabla temporal `OLD_GAMES` con la misma estructura que `GAME`.
2. Inserta algunos juegos antiguos en `OLD_GAMES`.
3. Actualiza `GAME` con datos de `OLD_GAMES` donde coincidan los nombres.
4. Inserta en `GAME` los juegos de `OLD_GAMES` que no existan en `GAME`.
5. Elimina la tabla temporal.

**Ejercicio 4.3 - Corrección Masiva con JOIN**
1. Actualiza la tabla `COMMENTARY` cambiando el comentario a '[MODERADO]' para todos los comentarios de usuarios que tengan menos de 3 juegos completados en `PLAY`.

---

### **Desafío Final: Simulación de Sistema**

**Escenario:** Eres administrador de la plataforma gamers.
1. **Tarea 1:** Elimina usuarios inactivos (sin `PLAY`, sin `VOTE`, sin `COMMENTARY` en los últimos 6 meses).
2. **Tarea 2:** Actualiza el nivel (`id_level`) de todos los juegos basado en su dificultad calculada:
   - Nivel 1: juegos con votación promedio < 5
   - Nivel 2: votación promedio entre 5 y 7
   - Nivel 3: votación promedio > 7
3. **Tarea 3:** Inserta 10 nuevos juegos de prueba en `GAME` obteniendo los `id_level` e `id_class` de juegos existentes similares.
4. **Tarea 4:** Crea una copia de seguridad de la tabla `VOTE` antes de eliminar votos anteriores al 2023.


<details>
<summary>Soluciones a los Ejercicios DML - Base `coderhouse_gamers`</summary>

### **Posta 1: Fundamentos de DML**

**Ejercicio 1.1 - INSERT básico**
```sql
-- 1. Inserción del usuario
INSERT INTO SYSTEM_USER (
    id_system_user, 
    first_name, 
    last_name, 
    email, 
    password, 
    id_user_type
) VALUES (
    1000,
    'Ana',
    'López',
    'ana.lopez@email.com',
    'pass123',
    1
);

-- 2. Verificación
SELECT * FROM SYSTEM_USER WHERE id_system_user = 1000;
```

**Ejercicio 1.2 - INSERT múltiple**
```sql
-- Inserción de tres juegos en una sola sentencia
INSERT INTO GAME (id_game, name, description, id_level, id_class) VALUES
(101, 'FIFA 23', 'Juego de fútbol', 2, 1),
(102, 'Minecraft', 'Mundo abierto', 1, 2),
(103, 'Cyberpunk 2077', 'RPG futurista', 3, 1);
```

**Ejercicio 1.3 - UPDATE con WHERE**
```sql
-- 1. Actualizar el email del usuario 1000
UPDATE SYSTEM_USER
SET email = 'ana.lopez.nuevo@email.com'
WHERE id_system_user = 1000;

-- 2. Cambiar la descripción de los juegos de nivel 2
UPDATE GAME
SET description = 'Juego para nivel intermedio'
WHERE id_level = 2;
```

**Ejercicio 1.4 - DELETE con condiciones**
```sql
-- 1. Primero, verificar el registro a eliminar
SELECT * FROM GAME WHERE id_game = 103;

-- 2. Luego, eliminar
DELETE FROM GAME WHERE id_game = 103;
```

---

### **Posta 2: DML Avanzado y Subconsultas**

**Ejercicio 2.1 - INSERT con SELECT (Subconsulta)**
```sql
-- Insertar en PLAY usando subconsulta para obtener el id_game de 'Minecraft'
INSERT INTO PLAY (id_game, id_system_user, completed)
VALUES (
    (SELECT id_game FROM GAME WHERE name = 'Minecraft'),
    1000,
    false
);
```

**Ejercicio 2.2 - UPDATE con Subconsulta**
```sql
-- Actualizar juegos con votación mayor a 8 a nivel 4
UPDATE GAME
SET id_level = 4
WHERE id_game IN (
    SELECT DISTINCT id_game 
    FROM VOTE 
    WHERE value > 8
);
```

**Ejercicio 2.3 - DELETE con Subconsulta y Transacción**
```sql
-- Iniciar transacción
START TRANSACTION;

-- Verificar los votos a eliminar
SELECT * FROM VOTE 
WHERE id_system_user IN (
    SELECT id_system_user 
    FROM SYSTEM_USER 
    WHERE email LIKE '%@olddomain.com'
);

-- Eliminar votos
DELETE FROM VOTE 
WHERE id_system_user IN (
    SELECT id_system_user 
    FROM SYSTEM_USER 
    WHERE email LIKE '%@olddomain.com'
);

-- Verificar usuarios a eliminar
SELECT * FROM SYSTEM_USER 
WHERE email LIKE '%@olddomain.com';

-- Eliminar usuarios
DELETE FROM SYSTEM_USER 
WHERE email LIKE '%@olddomain.com';

-- Confirmar transacción (si todo está bien)
COMMIT;

-- En caso de error, se puede deshacer con:
-- ROLLBACK;
```

---

### **Posta 3: Optimización y Buenas Prácticas**

**Ejercicio 3.1 - Operación Masiva con Índices**
```sql
-- 1. Crear índice
CREATE INDEX idx_user_email ON SYSTEM_USER(email);

-- 2. Actualizar dominio de email
UPDATE SYSTEM_USER
SET email = REPLACE(email, 'webnode.com', 'newnode.com')
WHERE email LIKE '%@webnode.com';

-- 3. Analizar con EXPLAIN (antes y después del índice)
-- Antes (sin índice) se puede ver con:
EXPLAIN UPDATE SYSTEM_USER
SET email = REPLACE(email, 'webnode.com', 'newnode.com')
WHERE email LIKE '%@webnode.com';

-- Después (con índice) se espera que el tipo de acceso sea por índice.
```

**Ejercicio 3.2 - Inserción Masiva Eficiente**
```sql
-- Inserción de 500 votos (ejemplo con 5, para no hacerlo muy largo)
-- Se puede usar un procedimiento o generar con un script, aquí un ejemplo con 5 votos:
INSERT INTO VOTE (id_vote, value, id_game, id_system_user) VALUES
(1, 8, 101, 1000),
(2, 9, 102, 1000),
(3, 7, 101, 1000),
(4, 10, 102, 1000),
(5, 6, 101, 1000);
-- ... y así hasta 500. En la práctica, se puede generar con un bucle o desde un archivo.
```

**Ejercicio 3.3 - Mantenimiento con DML**
```sql
-- Marcar como completados los juegos con más de 10 votos y promedio > 9
UPDATE PLAY
SET completed = true
WHERE id_game IN (
    SELECT id_game
    FROM VOTE
    GROUP BY id_game
    HAVING COUNT(*) > 10 AND AVG(value) > 9
);
```

---

### **Ejercicios de Integración Compleja**

**Ejercicio 4.1 - Proceso Completo de Registro**
```sql
-- Iniciar transacción
START TRANSACTION;

-- 1. Insertar un nuevo tipo de usuario si no existe (por ejemplo, tipo 3: 'Premium')
INSERT INTO USER_TYPE (id_user_type, description)
SELECT 3, 'Premium'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM USER_TYPE WHERE id_user_type = 3);

-- 2. Insertar nuevo usuario (id 1001)
INSERT INTO SYSTEM_USER (id_system_user, first_name, last_name, email, password, id_user_type)
VALUES (1001, 'Carlos', 'García', 'carlos.garcia@email.com', 'clave456', 3);

-- 3. Insertar que juega a 3 juegos diferentes (supongamos juegos con id 1, 2, 3)
INSERT INTO PLAY (id_game, id_system_user, completed) VALUES
(1, 1001, false),
(2, 1001, false),
(3, 1001, false);

-- 4. Insertar 2 votos
INSERT INTO VOTE (id_vote, value, id_game, id_system_user) VALUES
(6, 9, 1, 1001),
(7, 8, 2, 1001);

-- 5. Insertar un comentario (primero en COMMENT y luego en COMMENTARY, según estructura)
-- Primero, insertar en COMMENT (relación entre juego y usuario)
INSERT INTO COMMENT (id_game, id_system_user, first_date, last_date)
VALUES (1, 1001, CURDATE(), NULL);

-- Luego, insertar en COMMENTARY (el comentario específico)
INSERT INTO COMMENTARY (id_commentary, id_game, id_system_user, comment_date, commentary)
VALUES (1, 1, 1001, CURDATE(), 'Excelente juego, lo recomiendo');

-- Confirmar transacción
COMMIT;
```

**Ejercicio 4.2 - Migración de Datos**
```sql
-- 1. Crear tabla temporal
CREATE TEMPORARY TABLE OLD_GAMES (
    id_game INT,
    name VARCHAR(100),
    description VARCHAR(300),
    id_level INT,
    id_class INT
);

-- 2. Insertar algunos juegos antiguos
INSERT INTO OLD_GAMES (id_game, name, description, id_level, id_class) VALUES
(200, 'Pacman', 'Juego clásico de arcade', 1, 1),
(201, 'Tetris', 'Rompecabezas de bloques', 1, 2);

-- 3. Actualizar GAME con datos de OLD_GAMES donde coincidan los nombres
UPDATE GAME g
JOIN OLD_GAMES og ON g.name = og.name
SET g.description = og.description,
    g.id_level = og.id_level,
    g.id_class = og.id_class;

-- 4. Insertar en GAME los juegos de OLD_GAMES que no existan en GAME
INSERT INTO GAME (id_game, name, description, id_level, id_class)
SELECT og.id_game, og.name, og.description, og.id_level, og.id_class
FROM OLD_GAMES og
LEFT JOIN GAME g ON og.name = g.name
WHERE g.id_game IS NULL;

-- 5. Eliminar tabla temporal
DROP TEMPORARY TABLE OLD_GAMES;
```

**Ejercicio 4.3 - Corrección Masiva con JOIN**
```sql
-- Actualizar comentarios de usuarios con menos de 3 juegos completados
UPDATE COMMENTARY c
JOIN (
    SELECT p.id_system_user, COUNT(*) as completados
    FROM PLAY p
    WHERE p.completed = true
    GROUP BY p.id_system_user
    HAVING COUNT(*) < 3
) AS usuarios ON c.id_system_user = usuarios.id_system_user
SET c.commentary = '[MODERADO]';
```

---

### **Desafío Final: Simulación de Sistema**

**Tarea 1: Eliminar usuarios inactivos**
```sql
-- Crear una copia de seguridad de los usuarios inactivos (opcional)
CREATE TABLE backup_inactive_users AS
SELECT * FROM SYSTEM_USER
WHERE id_system_user NOT IN (
    SELECT DISTINCT id_system_user FROM PLAY
    UNION
    SELECT DISTINCT id_system_user FROM VOTE
    UNION
    SELECT DISTINCT id_system_user FROM COMMENTARY
    WHERE comment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- Eliminar usuarios inactivos
DELETE FROM SYSTEM_USER
WHERE id_system_user NOT IN (
    SELECT DISTINCT id_system_user FROM PLAY
    UNION
    SELECT DISTINCT id_system_user FROM VOTE
    UNION
    SELECT DISTINCT id_system_user FROM COMMENTARY
    WHERE comment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);
```

**Tarea 2: Actualizar nivel de juegos basado en votación**
```sql
-- Actualizar el nivel de los juegos según la votación promedio
UPDATE GAME g
JOIN (
    SELECT id_game, AVG(value) as promedio
    FROM VOTE
    GROUP BY id_game
) v ON g.id_game = v.id_game
SET g.id_level = CASE
    WHEN v.promedio < 5 THEN 1
    WHEN v.promedio BETWEEN 5 AND 7 THEN 2
    WHEN v.promedio > 7 THEN 3
    ELSE g.id_level  -- Mantener el nivel actual si no entra en los rangos
END;
```

**Tarea 3: Insertar 10 nuevos juegos de prueba**
```sql
-- Insertar 10 juegos de prueba, tomando id_level e id_class de juegos existentes similares
-- Supongamos que tomamos los datos de los primeros 10 juegos existentes y los duplicamos con nombres modificados
INSERT INTO GAME (id_game, name, description, id_level, id_class)
SELECT 
    (SELECT MAX(id_game) FROM GAME) + ROW_NUMBER() OVER() as new_id,
    CONCAT('Test Game ', ROW_NUMBER() OVER()),
    CONCAT('Descripción de prueba para juego ', ROW_NUMBER() OVER()),
    id_level,
    id_class
FROM GAME
LIMIT 10;
```

**Tarea 4: Copia de seguridad de VOTE antes de eliminar registros antiguos**
```sql
-- Crear tabla de backup
CREATE TABLE backup_votes_pre_2023 AS
SELECT * FROM VOTE
WHERE id_vote IN (
    SELECT v.id_vote
    FROM VOTE v
    JOIN PLAY p ON v.id_game = p.id_game AND v.id_system_user = p.id_system_user
    JOIN COMMENT c ON v.id_game = c.id_game AND v.id_system_user = c.id_system_user
    WHERE c.first_date < '2023-01-01'
);

-- Eliminar votos anteriores a 2023 (asumiendo que la fecha está en COMMENT.first_date)
DELETE v FROM VOTE v
JOIN PLAY p ON v.id_game = p.id_game AND v.id_system_user = p.id_system_user
JOIN COMMENT c ON v.id_game = c.id_game AND v.id_system_user = c.id_system_user
WHERE c.first_date < '2023-01-01';
```

---

### **Notas Importantes sobre las Soluciones:**

1. **Orden de ejecución:** Ejecutar los ejercicios en orden, ya que algunos dependen de datos creados anteriormente.
2. **Verificación:** Siempre incluir SELECT de verificación antes y después de operaciones críticas.
3. **Transacciones:** En producción, asegurarse de manejar correctamente COMMIT y ROLLBACK.
4. **Índices:** Los índices mejoran lecturas pero ralentizan inserciones. Evaluar según el caso.
5. **Integridad referencial:** Respetar las claves foráneas y el orden de eliminación (primero tablas hijas, luego padres).
6. **Rendimiento:** Para operaciones masivas, considerar deshabilitar temporalmente índices y restricciones.

**Consejo para estudiantes:** Ejecuten cada sentencia paso a paso, verifiquen los resultados intermedios y comprendan cómo cada operación afecta a los datos. La práctica con DML es fundamental para administrar bases de datos de manera efectiva.
</details>