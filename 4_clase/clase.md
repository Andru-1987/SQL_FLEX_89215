# Resumento del material on demand: Objetos y Fundamentos de Bases de Datos Relacionales

## **Posta 1: Fundamentos Absolutos - La Tabla**

**Resumen Teórico:**
La tabla es la unidad fundamental de almacenamiento en una base de datos relacional. Está compuesta por columnas (atributos con un tipo de dato definido) y filas (registros individuales). Cada tabla representa una entidad del mundo real (ej: `Clientes`, `Productos`).

**Material Bibliográfico Ampliado:**
- **Estructura de una Tabla:** Profundizar en los tipos de datos SQL (INT, VARCHAR, DATE, DECIMAL, etc.). Es crucial entender que los tipos disponibles pueden variar según el Sistema Gestor de Bases de Datos (DBMS) como MySQL, PostgreSQL, Oracle o SQL Server. Consultar la documentación oficial del motor elegido es esencial.
- **Creación Básica (DDL - Lenguaje de Definición de Datos):**
    ```sql
    CREATE TABLE Empleados (
        id INT,
        nombre VARCHAR(100),
        fecha_ingreso DATE
    );
    ```
- **Clave Primaria (PK):** Su propósito es identificar de forma única cada fila. Se implementa con la restricción `PRIMARY KEY`. Una tabla solo puede tener una PK.
    ```sql
    CREATE TABLE Empleados (
        id INT PRIMARY KEY,
        nombre VARCHAR(100)
    );
    ```
- **Bibliografía Recomendada:**
    - Capítulo 3, "SQL Fundamentals", de *"SQL in 10 Minutes, SAMS Teach Yourself"* de Ben Forta.
    - Documentación oficial: "CREATE TABLE Statement" en los manuales de MySQL o PostgreSQL.

---

## **Posta 2: Relacionando el Mundo - Claves Foráneas y Relaciones**

**Resumen Teórico:**
Las tablas rara vez existen aisladas. La potencia del modelo relacional radica en vincularlas mediante **claves foráneas (FK)**. Una FK en una tabla (hija) referencia a la PK de otra tabla (padre), estableciendo una relación que garantiza la **integridad referencial**: no se puede insertar un valor en la FK que no exista en la PK referenciada.

**Tipos de Relaciones:**
1.  **Uno a Muchos (1:N):** La más común. Ej: Un `Departamento` (1) tiene muchos `Empleados` (N). La FK (`departamento_id`) va en la tabla `Empleados`.
2.  **Muchos a Muchos (N:M):** Ej: Un `Alumno` puede cursar muchos `Cursos`, y un `Curso` tiene muchos alumnos. Se implementa con una **tabla intermedia** (puente) que contiene las FK a ambas tablas. Esta tabla suele tener una PK compuesta por dichas FK.
    ```sql
    CREATE TABLE Inscripciones (
        alumno_id INT,
        curso_id INT,
        fecha_inscripcion DATE,
        PRIMARY KEY (alumno_id, curso_id),
        FOREIGN KEY (alumno_id) REFERENCES Alumnos(id),
        FOREIGN KEY (curso_id) REFERENCES Cursos(id)
    );
    ```
3.  **Uno a Uno (1:1):** Menos frecuente. Ej: Datos de un `Empleado` y su `InformaciónConfidencial`. Se puede implementar con una FK que también sea PK o UNIQUE en la tabla secundaria.

**Bibliografía Recomendada:**
    - Capítulo 15, "Joining Tables", de *"SQL for Dummies"* de Allen G. Taylor.
    - Sección "Referential Integrity" en la documentación de su DBMS.

---

## **Posta 3: Más Allá de las Tablas - Vistas, Procedimientos y Funciones**

**Resumen Teórico:**
La base de datos ofrece objetos programáticos para encapsular lógica, mejorar la seguridad y la reutilización del código.

1.  **Vistas:** Tablas virtuales basadas en el resultado de una consulta `SELECT`. No almacenan datos físicamente.
    - **Uso:** Simplificar consultas complejas, ocultar columnas sensibles, presentar datos transformados.
    - **Ejemplo:**
        ```sql
        CREATE VIEW Vista_Empleados_Activos AS
        SELECT id, nombre, departamento
        FROM Empleados
        WHERE estado = 'ACTIVO';
        ```

2.  **Procedimientos Almacenados:** Bloques de código SQL que se ejecutan como una unidad. Pueden recibir parámetros y contener lógica compleja (bucles, condicionales). Se invocan con `CALL` o `EXECUTE`.
    - **Uso:** Automatizar tareas, implementar lógica de negocio en el servidor, reducir tráfico red.

3.  **Funciones:** Similar a un procedimiento, pero **siempre retorna un valor único** (escalar) o un conjunto de resultados (tabla). Se pueden usar dentro de una consulta `SELECT`.
    - **Uso:** Cálculos reutilizables (ej: calcular IVA), transformación de datos.

4.  **Triggers (Disparadores):** Código que se ejecuta **automáticamente** ante un evento (INSERT, UPDATE, DELETE) en una tabla.
    - **Uso:** Auditoría (`LOG` de cambios), mantener datos derivados automáticamente, validación compleja.

**Bibliografía Recomendada:**
    - Capítulos sobre "Views", "Stored Procedures", y "Triggers" en *"SQL Cookbook"* de Anthony Molinaro.
    - Guías de programación en T-SQL (SQL Server) o PL/pgSQL (PostgreSQL).

---

## **Posta 4: Diseño Robusto - Normalización y Formas Normales**

**Resumen Teórico:**
La normalización es un proceso sistemático para organizar las tablas y sus atributos con el fin de **minimizar la redundancia** y las anomalías de inserción, actualización y borrado. Se basa en "Formas Normales" (FN).

**Formas Normales Fundamentales (Para Primeros y Segundos Pasos):**
1.  **1FN (Primera Forma Normal):** Los atributos deben ser atómicos (indivisibles) y la tabla debe tener una PK. Elimina grupos repetitivos.
    > **Ejemplo:** No tener una columna `Telefonos` con valores como "555-1234, 555-5678". En su lugar, crear una tabla separada de `Telefonos` relacionada.

2.  **2FN (Segunda Forma Normal):** Debe estar en 1FN y **todos los atributos no clave deben depender por completo de la PK total** (si es compuesta). Elimina dependencias parciales.
    > **Ejemplo:** En una tabla `Pedido_Detalle (id_pedido, id_producto, nombre_producto, cantidad)`, `nombre_producto` solo depende de `id_producto`, no de la PK compuesta. Se debe mover a una tabla `Productos`.

3.  **3FN (Tercera Forma Normal):** Debe estar en 2FN y **ningún atributo no clave debe depender de otro atributo no clave** (dependencia transitiva). Elimina dependencias transitivas.
    > **Ejemplo:** En `Empleado (id, nombre, id_departamento, nombre_departamento, ubicacion)`, `ubicacion` depende de `nombre_departamento`. Se deben separar en `Empleados` y `Departamentos`.

**Objetivo del Diseño:** Lograr un esquema donde cada dato esté almacenado una sola vez, las relaciones se manejen con claves y la integridad sea fácil de mantener.

**Bibliografía Recomendada:**
    - Capítulo 5, "Database Design and Normalization", de *"Database Systems: A Practical Approach to Design, Implementation, and Management"* de Connolly & Begg.

---

## **Posta 5: Conceptos Avanzados de Claves y Optimización**

**Resumen Teórico:**
Profundización en las claves y estructuras que mejoran el rendimiento.

1.  **Claves Candidatas:** Son todos los conjuntos de columnas que *podrían* actuar como PK porque identifican un registro de forma única (ej: `ID_Empleado`, `DNI`, `Email` en una tabla de empleados). De entre ellas, se elige una como PK. Las demás se declaran como **claves únicas (UNIQUE)**.

2.  **Claves Compuestas (o Concatenadas):** Una PK formada por dos o más columnas. Útil en tablas intermedias de relaciones N:M o cuando la identidad natural de un registro depende de varios atributos.

3.  **Índices:** Estructuras separadas que permiten localizar datos rápidamente sin escanear toda la tabla. Se crean automáticamente para las PK y las claves únicas.
    - **Cuándo usarlos:** En columnas usadas frecuentemente en cláusulas `WHERE`, `JOIN` y `ORDER BY`.
    - **Costo:** Ocupan espacio y pueden ralentizar operaciones de escritura (`INSERT`, `UPDATE`, `DELETE`), ya que el índice también debe actualizarse.
    - **Ejemplo:**
        ```sql
        CREATE INDEX idx_empleado_departamento ON Empleados(departamento_id);
        ```

**Síntesis Final:** Un diseño de base de datos eficiente se logra comprendiendo y aplicando jerárquicamente estos conceptos: desde la creación correcta de tablas con claves apropiadas, pasando por la normalización para evitar redundancias, hasta el uso de objetos programáticos y la indexación estratégica para optimizar el rendimiento en producción.