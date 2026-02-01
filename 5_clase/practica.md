### **Manejo de Vistas**

Esta unidad veremos las **Vistas**, uno de los objetos más útiles y versátiles dentro de SQL. Una vista actúa como una "tabla virtual" que se genera a partir del resultado de una consulta `SELECT`. No almacena datos físicamente, sino que ofrece una perspectiva filtrada, segura y simplificada de los datos almacenados en las tablas reales.

Su principal objetivo es **abstraer la complejidad**, permitiendo a usuarios y desarrolladores interactuar con subconjuntos de datos específicos sin necesidad de conocer la estructura completa de la base de datos, al tiempo que se **mejora la seguridad** al restringir el acceso a información sensible.

#### **Puntos Principales**
*   **Definición y Propósito:** Objeto virtual que representa el resultado de una consulta. Sirve para simplificar consultas complejas, reforzar la seguridad y presentar datos de manera consistente.
*   **Creación:** Se utiliza la sentencia `CREATE VIEW`. Se puede crear desde una sola tabla o combinando múltiples tablas con `JOIN`.
*   **Tipos de Vistas Prácticas:**
    *   **Vista Simple:** Muestra columnas específicas de una sola tabla.
    *   **Vista con Filtro (`WHERE`):** Muestra un subconjunto de registros basado en una condición.
    *   **Vista con Orden (`ORDER BY`):** Presenta los datos ordenados.
    *   **Vista Multitabla:** Combina columnas de dos o más tablas relacionadas en una sola vista unificada.
*   **Modificación:** Para cambiar la definición de una vista existente, se usa `CREATE OR REPLACE VIEW`. Esto sobreescribe la vista anterior sin necesidad de eliminarla primero.
*   **Eliminación:** Se realiza con el comando `DROP VIEW nombre_vista;`. La acción es inmediata e irreversible.
*   **Uso Post-Creación:** Una vez creada, una vista se puede consultar (`SELECT`) y filtrar (`WHERE`, `ORDER BY`) exactamente igual que una tabla física.
*   **Ventajas Clave:**
    *   **Seguridad:** Oculta columnas o filas sensibles.
    *   **Simplicidad:** Encapsula consultas complejas en un objeto fácil de usar.
    *   **Mantenibilidad:** Si cambia la estructura de las tablas base, solo se actualiza la vista para mantener la compatibilidad con las aplicaciones que la usan.

---

#### **Tabla Resumen de la Unidad: Manejo de Vistas**

| **Tema** | **Concepto Clave** | **Sintaxis SQL (Ejemplo)** | **Utilidad Práctica** |
| :--- | :--- | :--- | :--- |
| **1. Definición** | Tabla virtual basada en una consulta `SELECT`. | - | Abstracción y seguridad de los datos. |
| **2. Creación** | Crea una nueva vista a partir de una consulta. | `CREATE VIEW vista_juegos AS SELECT nombre, descripcion FROM game;` | Guardar una perspectiva específica de los datos para reutilizar. |
| **3. Vista con Filtro** | La vista solo incluye registros que cumplan una condición. | `CREATE VIEW vista_callofduty AS SELECT * FROM game WHERE nombre LIKE '%Call of Duty%';` | Ofrecer acceso a subconjuntos de datos (ej: por departamento, categoría). |
| **4. Vista Multitabla** | Combina datos de varias tablas relacionadas. | `CREATE VIEW vista_detalle AS SELECT u.first_name, g.nombre FROM usuario u JOIN game g ON...;` | Simplificar consultas complejas que requieren `JOIN`. |
| **5. Modificación** | Reemplaza la definición de una vista ya existente. | `CREATE OR REPLACE VIEW vista_juegos AS SELECT id, nombre FROM game;` | Actualizar la lógica de la vista sin borrarla. |
| **6. Eliminación** | Elimina permanentemente una vista de la base de datos. | `DROP VIEW vista_juegos;` | Limpiar objetos que ya no son necesarios. |
| **7. Consulta** | Se usa como una tabla normal después de creada. | `SELECT * FROM vista_juegos WHERE nombre LIKE 'A%' ORDER BY nombre;` | Interactuar con los datos de forma simplificada y segura. |

---

#### **Ejercicios del Material (Prácticas con Vistas)**
Sobre el esquema `gamers`, crear las siguientes vistas:

1.  Muestra `first_name` y `last_name` de los usuarios cuyo email termine en `'webnode.com'`.
2.  Muestra **todos los datos** de los juegos que han sido marcados como finalizados.
3.  Muestra los nombres **distintos** de los juegos que han recibido una votación mayor a 9.
4.  Muestra el `nombre`, `apellido` y `email` de los usuarios que juegan al juego *'FIFA 22'*.

---

#### **Ejercicios Adicionales Propuestos**
Para profundizar en conceptos no explícitamente cubiertos en el material práctico:

**Ejercicio 5: Vista con Agregación (GROUP BY)**
*   **Objetivo:** Practicar el uso de funciones de agregación en vistas.
*   **Enunciado:** Crea una vista llamada `resumen_votos` que muestre, para cada juego (`id_game`), el **promedio** de sus votaciones y la **cantidad total** de votos recibidos.

**Ejercicio 6: Vista Actualizable (Concepto Teórico-Práctico)**
*   **Objetivo:** Comprender las limitaciones y el uso de vistas actualizables.
*   **Enunciado:**
    1.  Crea una vista simple llamada `vista_usuarios_basica` que muestre solo las columnas `id_usuario`, `first_name` y `last_name` de la tabla `usuario`.
    2.  Intenta ejecutar un `INSERT` en esta vista para agregar un nuevo usuario. ¿Funciona? Investiga y explica **qué condiciones** debe cumplir una vista para ser actualizable (que permita `INSERT`, `UPDATE`, `DELETE`).

**Ejercicio 7: Seguridad mediante Vistas (Caso de Uso)**
*   **Objetivo:** Diseñar una vista pensando en control de acceso.
*   **Enunciado:** Eres el administrador de la base de datos. Necesitas que el equipo de soporte vea la información de los usuarios para ayudarlos, pero **sin poder acceder a sus contraseñas (`password`)** ni a su **fecha de registro exacta (`created_at`)**. Suponiendo que existe una columna `role` en la tabla `usuario`, crea una vista llamada `vista_soporte_usuarios` que solo muestre a los usuarios con `role = 'player'` y oculte las columnas sensibles mencionadas.


<details>
    <summary><b>Resolución de Ejercicios Propuestos</b></summary>


**1. Vista con usuarios cuyo email termina en 'webnode.com':**
```sql
CREATE VIEW vista_webnode_usuarios AS
SELECT first_name, last_name
FROM usuario
WHERE email LIKE '%@webnode.com';
```

**2. Vista con todos los datos de juegos finalizados:**
```sql
CREATE VIEW vista_juegos_finalizados AS
SELECT *
FROM game
WHERE esta_completado = 1; -- Asume que 1 significa "completado"
```

**3. Vista con juegos que tuvieron votación > 9:**
```sql
CREATE VIEW vista_juegos_excelentes AS
SELECT DISTINCT g.nombre
FROM game g
JOIN votacion v ON g.id_game = v.id_game
WHERE v.puntuacion > 9;
```

**4. Vista de usuarios que juegan a 'FIFA 22':**
```sql
CREATE VIEW vista_jugadores_fifa22 AS
SELECT u.first_name AS nombre, u.last_name AS apellido, u.email
FROM usuario u
JOIN usuario_juega uj ON u.id_usuario = uj.id_usuario
JOIN game g ON uj.id_game = g.id_game
WHERE g.nombre = 'FIFA 22';
```

**5. Vista con Agregación (GROUP BY):**
```sql
CREATE VIEW resumen_votos AS
SELECT id_game,
       AVG(puntuacion) AS promedio_votacion,
       COUNT(*) AS total_votos
FROM votacion
GROUP BY id_game;
```

**6. Vista Actualizable:**

**Parte 1 - Crear la vista:**
```sql
CREATE VIEW vista_usuarios_basica AS
SELECT id_usuario, first_name, last_name
FROM usuario;
```

**Parte 2 - Probar INSERT y condiciones:**
1.  **Probar el INSERT:**
    ```sql
    INSERT INTO vista_usuarios_basica (id_usuario, first_name, last_name)
    VALUES (999, 'Juan', 'Perez');
    ```
    *Esto **fallará** si la tabla `usuario` tiene otras columnas `NOT NULL` sin valor por defecto (como `email` o `password`).*

2.  **Condiciones para que una vista sea actualizable en MySQL:**
    *   **Basada en una sola tabla:** No puede contener `JOIN`, `UNION`, etc.
    *   **Sin funciones de agregación:** No puede usar `GROUP BY`, `DISTINCT`, `HAVING`, funciones como `SUM()`, `COUNT()`, etc.
    *   **Sin subconsultas en la lista de selección o WHERE:** Que hagan referencia a la misma tabla.
    *   **Sin `LIMIT` u `ORDER BY`** en ciertos contextos (para `INSERT`).
    *   **Debe incluir todas las columnas `NOT NULL`** de la tabla base que no tengan un valor por defecto, o el `INSERT` fallará.

**7. Vista para Seguridad (Control de Acceso):**
```sql
CREATE VIEW vista_soporte_usuarios AS
SELECT id_usuario,
       first_name,
       last_name,
       email,
       role,
       DATE(created_at) AS fecha_registro_dia -- Enmascara la hora exacta
FROM usuario
WHERE role = 'player';
-- Nota: La columna `password` se omite por completo
```

**Explicación de la vista de seguridad:**
*   **Filtro (`WHERE`):** Solo muestra usuarios con `role = 'player'`.
*   **Ocultación de columnas:** No se selecciona la columna `password`.
*   **Enmascaramiento de datos:** Se usa `DATE(created_at)` para mostrar solo la fecha, no la hora exacta del registro.
</details>