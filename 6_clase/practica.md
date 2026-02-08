## **SUBLENGUAJE DML**

**Objetivos de la clase:**
- Reconocer e implementar las sentencias del sublenguaje DML (INSERT, UPDATE, DELETE).
- Identificar en qué situación usar cada sentencia.
- Implementar subconsultas para complementar las sentencias DML.

**Temas cubiertos:**

1. **Sentencia INSERT**
   - Inserción de registros completos y parciales.
   - Inserción múltiple de registros en una sola sentencia.
   - Uso de `NULL` para campos autoincrementables.

2. **Sentencia UPDATE**
   - Modificación de registros existentes.
   - Cláusula `WHERE` para especificar qué registros actualizar.
   - Actualizaciones masivas con condiciones.

3. **Sentencia DELETE**
   - Eliminación de registros específicos con `WHERE`.
   - Posibles errores por restricciones de clave foránea.
   - Diferencia entre `DELETE` y `TRUNCATE TABLE`.

4. **Subconsultas con DML**
   - Uso de subconsultas en operaciones `INSERT`, `UPDATE` y `DELETE`.
   - Inserción de datos derivados de otras tablas.
   - Eliminación condicional basada en relaciones entre tablas.

**Recomendaciones clave:**
- Siempre usar `WHERE` en `UPDATE` y `DELETE` para evitar modificaciones no deseadas.
- Verificar con `SELECT` antes de ejecutar `UPDATE` o `DELETE`.
- Considerar el uso de transacciones en operaciones críticas.
- Entender la integridad referencial al eliminar registros.

---

## **POSTAS DE CONOCIMIENTO CON EJERCICIOS Y SOLUCIONES**

### **POSTA 1: INSERCIÓN DE DATOS**

**Ejercicio 1.1: Inserción básica**
Inserta un nuevo tipo de usuario en la tabla `USER_TYPE`.
```sql
INSERT INTO USER_TYPE (id_user_type, description)
VALUES (3, 'Usuario Premium');
```

**Ejercicio 1.2: Inserción múltiple**
Inserta tres nuevos juegos en `GAME` en una sola sentencia.
```sql
INSERT INTO GAME (id_game, name, description, id_level, id_class) VALUES
(104, 'The Legend of Zelda', 'Aventura épica', 2, 1),
(105, 'Counter-Strike 2', 'Shooter táctico', 3, 2),
(106, 'The Sims 4', 'Simulación de vida', 1, 3);
```

**Ejercicio 1.3: Inserción parcial**
Inserta un registro en `COMMENT` sin especificar `last_date`.
```sql
INSERT INTO COMMENT (id_game, id_system_user, first_date)
VALUES (1, 1000, CURDATE());
```

---

### **POSTA 2: ACTUALIZACIÓN Y ELIMINACIÓN**

**Ejercicio 2.1: UPDATE con WHERE**
Actualiza el email de todos los usuarios cuyo ID sea mayor que 100.
```sql
UPDATE SYSTEM_USER
SET email = CONCAT(first_name, '.', last_name, '@coderhouse.com')
WHERE id_system_user > 100;
```

**Ejercicio 2.2: DELETE con condiciones**
Elimina todos los votos con valor menor a 3.
```sql
DELETE FROM VOTE
WHERE value < 3;
```

**Ejercicio 2.3: TRUNCATE vs DELETE**
Crea una tabla temporal, inserta datos y luego elimínalos con `TRUNCATE`.
```sql
CREATE TEMPORARY TABLE temp_games LIKE GAME;
INSERT INTO temp_games SELECT * FROM GAME LIMIT 5;
TRUNCATE TABLE temp_games; -- Elimina todos los registros rápidamente
DROP TEMPORARY TABLE temp_games;
```

---

### **POSTA 3: SUBCONSULTAS CON DML**

**Ejercicio 3.1: INSERT con subconsulta**
Inserta en `PLAY` todos los juegos existentes para el usuario con ID 1000.
```sql
INSERT INTO PLAY (id_game, id_system_user, completed)
SELECT id_game, 1000, false
FROM GAME
WHERE id_game NOT IN (SELECT id_game FROM PLAY WHERE id_system_user = 1000);
```

**Ejercicio 3.2: UPDATE con subconsulta**
Para todos los juegos que tienen más de 5 votos, actualiza su nivel a 5.
```sql
UPDATE GAME
SET id_level = 5
WHERE id_game IN (
    SELECT id_game
    FROM VOTE
    GROUP BY id_game
    HAVING COUNT(*) > 5
);
```

**Ejercicio 3.3: DELETE con subconsulta**
Elimina todos los comentarios de usuarios que no han jugado ningún juego.
```sql
DELETE FROM COMMENTARY
WHERE id_system_user IN (
    SELECT id_system_user
    FROM SYSTEM_USER
    WHERE id_system_user NOT IN (SELECT DISTINCT id_system_user FROM PLAY)
);
```

---

### **POSTA 4: CASOS INTEGRADOS Y MANEJO DE ERRORES**

**Ejercicio 4.1: Proceso completo con transacción**
Simula el registro de un nuevo usuario con todas sus operaciones en una transacción.
```sql
START TRANSACTION;

INSERT INTO SYSTEM_USER (id_system_user, first_name, last_name, email, password, id_user_type)
VALUES (2000, 'Laura', 'Martínez', 'laura.m@email.com', 'pass456', 2);

INSERT INTO PLAY (id_game, id_system_user, completed)
VALUES (1, 2000, true), (2, 2000, false);

INSERT INTO VOTE (id_vote, value, id_game, id_system_user)
VALUES (100, 9, 1, 2000);

COMMIT;
-- En caso de error: ROLLBACK;
```

**Ejercicio 4.2: Manejo de error por clave foránea**
Intenta eliminar un nivel de juego que está siendo usado en la tabla `GAME`.
```sql
-- Esto generará un error 1451
DELETE FROM LEVEL_GAME WHERE id_level = 1;

-- Solución: Primero actualizar o eliminar los juegos que dependen de ese nivel
UPDATE GAME SET id_level = NULL WHERE id_level = 1;
DELETE FROM LEVEL_GAME WHERE id_level = 1;
```

**Ejercicio 4.3: Creación de tabla e inserción con subconsulta**
Crea una tabla `TOP_GAMES` e inserta los 10 juegos mejor votados.
```sql
CREATE TABLE TOP_GAMES (
    id_game INT PRIMARY KEY,
    name VARCHAR(100),
    avg_vote DECIMAL(3,2)
);

INSERT INTO TOP_GAMES (id_game, name, avg_vote)
SELECT g.id_game, g.name, AVG(v.value) as avg_vote
FROM GAME g
JOIN VOTE v ON g.id_game = v.id_game
GROUP BY g.id_game, g.name
ORDER BY avg_vote DESC
LIMIT 10;
```

---

## **RESUMEN DE PUNTOS VISTOS**

### **COMANDOS DML:**
1. **INSERT:** Agrega nuevos registros.
   - `INSERT INTO tabla (campos) VALUES (valores);`
   - Inserción múltiple: `VALUES (val1), (val2), ...`
   - Inserción con subconsulta: `INSERT INTO tabla SELECT ...`

2. **UPDATE:** Modifica registros existentes.
   - `UPDATE tabla SET campo = valor WHERE condición;`
   - Actualización condicional con subconsultas.

3. **DELETE:** Elimina registros.
   - `DELETE FROM tabla WHERE condición;`
   - Eliminación con subconsultas.
   - Diferencia con `TRUNCATE TABLE`: elimina todos los registros sin condiciones y reinicia autoincrementables.

### **CONCEPTOS CLAVE:**
- **Cláusula WHERE:** Esencial para dirigir operaciones `UPDATE` y `DELETE`.
- **Integridad referencial:** Las operaciones `DELETE` pueden fallar si existen claves foráneas dependientes.
- **Subconsultas:** Permiten operaciones DML basadas en datos de otras tablas.
- **Transacciones:** Agrupan operaciones para ejecutarse de forma atómica (`START TRANSACTION`, `COMMIT`, `ROLLBACK`).
- **Buenas prácticas:** Verificar con `SELECT` antes de modificar, usar condiciones específicas, respetar relaciones entre tablas.

### **ERRORES COMUNES Y SOLUCIONES:**
- **Error 1451:** Violación de clave foránea. Solución: eliminar/actualizar registros dependientes primero.
- **Olvidar WHERE en UPDATE/DELETE:** Modifica todos los registros. Prevención: usar modo seguro (`SET SQL_SAFE_UPDATES=1`).
- **Inserción de tipos de datos incorrectos:** Asegurar que los valores coincidan con el tipo de columna.

### **MATERIAL ADICIONAL RECOMENDADO:**
- **Documentación oficial MySQL:** [Data Manipulation Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-data-manipulation-statements.html)
- **Libro:** "SQL in 10 Minutes" - Capítulos sobre INSERT, UPDATE, DELETE.
- **Práctica:** Crear scripts que simulen operaciones comunes de mantenimiento en bases de datos.