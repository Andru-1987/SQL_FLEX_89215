# Curso: Objetos y Tablas en SQL - Organizado en Postas de Conocimiento

[_Material en clase_](https://docs.google.com/presentation/d/1VvWb1N2wBdfwxN4-fvEe3u0Lz9Eo9iCQ5seBm1PS24M/edit?slide=id.p118#slide=id.p118)

### **Posta 1: Fundamentos - Tablas y su Creación**

**Resumen Teórico:**
La tabla es el objeto fundamental de almacenamiento en una base de datos. Consiste en filas (registros) y columnas (campos con tipos de datos definidos). Se crean mediante la sentencia `CREATE TABLE`.

**Puntos Clave:**
- Sintaxis básica de `CREATE TABLE`.
- Definición de columnas con sus tipos de datos (INT, VARCHAR, DATE, etc.).
- Creación de tablas en un esquema específico.

**Ejemplo Práctico en Clase:**
Creación de la tabla `Friend` en el esquema `Gammers`:
```sql
CREATE TABLE Friend (
    id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    troop INT
);
```

**Ejercicio Práctico:**
1. Crea una tabla llamada `Estudiantes` con las columnas: `id` (INT), `nombre` (VARCHAR), `apellido` (VARCHAR), `fecha_nacimiento` (DATE).
2. Inserta 3 registros de ejemplo en la tabla.
3. Crea una segunda tabla llamada `Cursos` con: `id` (INT), `nombre_curso` (VARCHAR), `profesor` (VARCHAR).

---

### **Posta 2: Relaciones entre Tablas y Claves**

**Resumen Teórico:**
Las tablas pueden relacionarse entre sí mediante claves. La **clave primaria (PK)** identifica de manera única cada registro. La **clave foránea (FK)** establece una relación entre dos tablas, vinculando un campo de una tabla con la PK de otra.

**Puntos Clave:**
- Una PK es única y no nula.
- Una FK debe referenciar una PK existente en otra tabla.
- Integridad referencial: no se puede eliminar un registro referenciado por una FK.

**Ejemplo en Clase:**
Tablas `Friend` y `Troops`:
- `Friend.troop` podría ser FK que referencia `Troops.id`
- Eliminar un `Friend` es posible, pero eliminar un `Troop` que está referenciado puede violar la integridad.

**Ejercicio Práctico:**
1. Agrega una PK a la tabla `Estudiantes` (columna `id`).
2. Agrega una PK a la tabla `Cursos` (columna `id`).
3. Crea una tabla intermedia `Inscripciones` que relacione estudiantes con cursos, usando FK hacia ambas tablas.

---

### **Posta 3: Funciones en SQL**

**Resumen Teórico:**
Las funciones son objetos que encapsulan lógica SQL y devuelven un valor. Se almacenan en la base de datos y pueden ser reutilizadas.

**Puntos Clave:**
- Se crean con `CREATE FUNCTION`.
- Pueden recibir parámetros.
- Devuelven un valor único (escalar) o un conjunto de resultados.
- Están disponibles solo en el esquema donde se crean.

**Ejemplo en Clase:**
Función que retorna la cantidad de integrantes de una troop:
```sql
CREATE FUNCTION contar_integrantes(troop_id INT)
RETURNS INT
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad FROM Friend WHERE troop = troop_id;
    RETURN cantidad;
END;
```

**Ejercicio Práctico:**
1. Crea una función `promedio_edad_estudiantes()` que calcule y retorne la edad promedio de todos los estudiantes.
2. Crea una función `estudiantes_por_curso(curso_id INT)` que retorne la cantidad de estudiantes inscritos en un curso específico.

---

### **Posta 4: Triggers (Disparadores)**

**Resumen Teórico:**
Los triggers son objetos que se ejecutan automáticamente antes o después de un evento (INSERT, UPDATE, DELETE) en una tabla.

**Puntos Clave:**
- `BEFORE`: se ejecuta antes de la operación.
- `AFTER`: se ejecuta después de la operación.
- Útiles para validación, auditoría, mantenimiento de datos derivados.

**Ejemplo en Clase:**
Trigger que asigna un valor por defecto a `description` si es NULL al insertar:
```sql
CREATE TRIGGER tr_troops_default_description
BEFORE INSERT ON troops
FOR EACH ROW
BEGIN
    IF NEW.description IS NULL THEN
        SET NEW.description = 'default description';
    END IF;
END;
```

**Ejercicio Práctico:**
1. Crea un trigger `before_insert_estudiante` que asegure que el nombre y apellido del estudiante estén en mayúsculas al insertar.
2. Crea un trigger `after_insert_inscripcion` que registre en una tabla de auditoría cada vez que se inscribe un estudiante a un curso.

---

### **Posta 5: Tipos Especializados de Tablas**

**Resumen Teórico:**
Existen tablas especializadas para diferentes propósitos:
- **Tablas de Hecho:** Almacenan eventos o transacciones (ej: ventas, juegos completados).
- **Tablas Dimensionales:** Contienen atributos descriptivos que contextualizan los hechos (ej: productos, clientes, tiempos).

**Puntos Clave:**
- Modelo dimensional común en Business Intelligence.
- Las tablas de hecho contienen métricas y claves foráneas a dimensiones.
- Las dimensiones contienen atributos descriptivos.

**Ejemplo en Clase:**
Tabla de hecho `games_completed` con datos de jugadores y juegos completados, relacionada con tablas dimensionales de jugadores y juegos.

**Ejercicio Práctico:**
1. Diseña un esquema dimensional para un sistema de ventas:
   - Tabla de hecho: `Ventas` (con id_venta, fecha_id, producto_id, cliente_id, cantidad, monto)
   - Tablas dimensionales: `Tiempo`, `Producto`, `Cliente`
2. Crea las sentencias SQL para las tablas dimensionales con sus PK.

---

### **Posta 6: Claves Avanzadas y Modificación de Estructura**

**Resumen Teórico:**
- **Clave Primaria Compuesta:** Formada por dos o más columnas (ej: en tabla `Play`: PK en `id_game, id_system_user`).
- **Modificación de tablas:** Uso de `ALTER TABLE` para agregar/eliminar columnas, PK, FK, índices.

**Puntos Clave:**
- Una PK compuesta asegura unicidad en la combinación de columnas.
- Las FK pueden ser simples o compuestas.
- Los índices mejoran el rendimiento de consultas.

**Ejemplo en Clase:**
Tabla `Play` con PK compuesta y FK hacia `Game` y `System_User`.

**Ejercicio Práctico:**
1. Agrega una PK compuesta a tu tabla `Inscripciones` usando `id_estudiante, id_curso`.
2. Agrega índices a las columnas frecuentemente usadas en WHERE (ej: `Estudiantes.nombre`).
3. Modifica la tabla `Estudiantes` para agregar una columna `email` con restricción UNIQUE.

---

### **Posta 7: Implementación de un Diagrama E-R Completo**

**Resumen Teórico:**
Un Diagrama Entidad-Relación (E-R) es una representación gráfica de las entidades y sus relaciones. La implementación física implica:
1. Crear tablas para cada entidad.
2. Definir PK para cada entidad.
3. Establecer FK para las relaciones.
4. Agregar restricciones e índices.

**Puntos Clave:**
- Las entidades se convierten en tablas.
- Los atributos se convierten en columnas.
- Las relaciones se implementan con FK.
- La cardinalidad (1:1, 1:N, N:M) determina el diseño.

**Ejercicio Final Integrador:**
Implementa el siguiente diagrama E-R para un sistema de biblioteca:

**Entidades:**
- `Libro` (id, titulo, autor, año_publicacion)
- `Usuario` (id, nombre, email, telefono)
- `Prestamo` (id, fecha_prestamo, fecha_devolucion)

**Relaciones:**
- Un Usuario puede tener muchos Préstamos (1:N)
- Un Libro puede estar en muchos Préstamos (1:N) a lo largo del tiempo
- Un Préstamo específico es de un Usuario y de un Libro

**Tareas:**
1. Crea las 3 tablas con sus PK.
2. Agrega las FK necesarias.
3. Crea un índice en `Libro.titulo` y `Usuario.nombre`.
4. Crea una función `libros_prestados_por_usuario(usuario_id)`.
5. Crea un trigger que actualice un campo `disponible` en `Libro` después de un préstamo.

---

### **Material Complementario Sugerido:**
- **Reverse Engineering con MySQL Workbench:** Recuperar el diagrama E-R a partir de una base de datos existente.
- **Videos recomendados:** 
  - "Cómo funcionan los FOREIGN KEY" por Vida MRR
  - "Base de Datos - Relación Muchos a Muchos - Clave primaria compuesta" por Programación y más
