# Clase 2 -> Sentencias y SubLenguaje

[_Documentacion de  clase_](https://docs.google.com/presentation/d/1gFvZmx7TiA0U8dj0nSiT1BjX7rdUF3rjWIDC2gkmn3A/edit?slide=id.p1#slide=id.p1)

## Breve repaso del material On-Demand

## Lenguaje SQL: Cómo se Lee y Cómo Debería Leerse

SQL (Structured Query Language) es el lenguaje estándar para interactuar con bases de datos relacionales. Una característica importante es entender cómo interpretar sus sentencias:

**Cómo se lee tradicionalmente:** Muchos principiantes leen SQL de forma literal, palabra por palabra, de izquierda a derecha, lo cual puede resultar confuso porque el orden sintáctico no siempre coincide con el orden lógico de ejecución.

**Cómo debería leerse (orden lógico de ejecución):** Para comprender realmente qué hace una consulta SQL, es mejor entender el orden en que el motor de base de datos procesa las cláusulas:

1. FROM - identifica las tablas fuente
2. WHERE - filtra filas antes de agrupar
3. GROUP BY - agrupa los datos
4. HAVING - filtra grupos después de agrupar
5. SELECT - proyecta las columnas deseadas
6. ORDER BY - ordena el resultado final

Por ejemplo, aunque escribimos SELECT primero, el motor realmente comienza procesando FROM y WHERE antes de determinar qué columnas mostrar.

## Tipos de SubLenguaje SQL

SQL se divide en varios sublenguajes según el tipo de operación que realizan:

**DDL (Data Definition Language):** Define y modifica la estructura de la base de datos. Incluye comandos como CREATE, ALTER, DROP, TRUNCATE para crear o modificar tablas, índices y esquemas.

**DML (Data Manipulation Language):** Manipula los datos dentro de las tablas. Los comandos principales son SELECT, INSERT, UPDATE y DELETE para consultar y modificar registros.

**DCL (Data Control Language):** Controla los permisos y accesos. Utiliza GRANT y REVOKE para otorgar o revocar privilegios a usuarios.

**TCL (Transaction Control Language):** Gestiona las transacciones para mantener la integridad de datos. Incluye COMMIT (confirmar cambios), ROLLBACK (revertir cambios) y SAVEPOINT (puntos de restauración).

## Actividad de Clase: Creación de un DER

El Diagrama Entidad-Relación (DER o ERD en inglés) es una herramienta visual fundamental para el diseño de bases de datos. En la actividad práctica se trabaja en:

- Identificar las entidades principales del sistema (representadas como rectángulos)
- Definir los atributos de cada entidad (óvalos conectados a las entidades)
- Establecer las relaciones entre entidades (rombos que conectan entidades)
- Determinar la cardinalidad de las relaciones (1:1, 1:N, N:M)
- Identificar claves primarias y foráneas

Esta actividad permite traducir requisitos de negocio en un modelo conceptual que posteriormente se implementará en SQL usando DDL.
