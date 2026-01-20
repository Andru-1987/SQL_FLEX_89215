# Mapa de Temas: Unidad 03 - Consultas, Subconsultas y DDL

## **Índice de Temas Principales**
1. UNION - Combinación de resultados
2. Tipos de Datos en SQL - Fundamentos
3. Operador LIKE - Búsqueda por patrones
4. Subconsultas SQL - Consultas anidadas
5. Funciones Escalares - Manipulación de datos
6. DDL (Lenguaje de Definición de Datos) - Estructura de base de datos

---

## **1. UNION - Combinación de resultados**
**Concepto:** Unir resultados de múltiples consultas en un solo conjunto.

**Ejemplo Único:**
```sql
-- Combinar juegos de nivel 1 y nivel 2
SELECT id_game, name, description, id_level, id_class 
FROM game WHERE id_level = 1
UNION
SELECT id_game, name, description, id_level, id_class 
FROM game WHERE id_level = 2;
```

---

## **2. Tipos de Datos en SQL**
**Concepto:** Definición del formato de almacenamiento de cada columna.

**Ejemplo Único:**
```sql
CREATE TABLE Ejemplo_Tipos (
    id INT,                    -- Número entero
    nombre VARCHAR(100),       -- Texto variable (hasta 100 caracteres)
    fecha_nacimiento DATE,     -- Solo fecha
    precio DECIMAL(10,2),      -- Decimal con 10 dígitos totales, 2 decimales
    activo BOOLEAN             -- Verdadero/Falso
);
```

---

## **3. Operador LIKE - Búsqueda por patrones**
**Concepto:** Buscar texto utilizando comodines para patrones.

**Ejemplo Único:**
```sql
-- Buscar juegos cuyo nombre comience con 'FIFA'
SELECT id_game, name, description
FROM game
WHERE name LIKE 'FIFA%';
```

**Variantes de comodines:**
- `%` : Cualquier número de caracteres
- `_` : Un solo carácter
- `[A-B]%` : Que comience con A o B
- `[^DV]%` : Que NO comience con D ni V

---

## **4. Subconsultas SQL**
**Concepto:** Consulta dentro de otra consulta, usualmente en WHERE.

**Ejemplo Único:**
```sql
-- Usuarios con el tipo de usuario máximo
SELECT id_system_user, last_name 
FROM system_user 
WHERE id_user_type = (
    SELECT MAX(id_user_type) 
    FROM user_type
);
```

---

## **5. Funciones Escalares**
**Concepto:** Funciones que operan sobre valores individuales.

### **5.1 Funciones de Cadena - Ejemplo:**
```sql
-- Concatenar nombre y apellido
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM system_user;
```

### **5.2 Funciones Numéricas - Ejemplo:**
```sql
-- Operaciones aritméticas básicas
SELECT (21 / 3) AS division,
       (7 * 3) AS multiplicacion,
       (18 + 3) AS suma,
       (30 - 9) AS resta;
```

### **5.3 Funciones de Fecha - Ejemplo:**
```sql
-- Obtener fecha y hora actual
SELECT CURDATE() AS fecha_actual,
       CURTIME() AS hora_actual,
       NOW() AS fecha_hora_actual;
```

---

## **6. DDL (Lenguaje de Definición de Datos)**
**Concepto:** Comandos para definir la estructura de la base de datos.

**Ejemplo Único:**
```sql
-- Crear, modificar y eliminar tabla
CREATE TABLE Friend (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Modificar tabla (agregar columna)
ALTER TABLE Friend ADD COLUMN email VARCHAR(150);

-- Eliminar todos los datos de la tabla
TRUNCATE TABLE Friend;
```

---

## **Ejercicios Propuestos en el Material**

### **Ejercicio 1: Operador LIKE** (Página 23)
Buscar en la tabla SYSTEM_USER:
1. Usuarios cuyo nombre comience con la letra 'J'
2. Usuarios cuyo apellido contenga la letra 'W'
3. Usuarios cuyo nombre contenga la letra 'i' en segundo lugar
4. Usuarios cuyo nombre finalice con la letra 'k'
5. Usuarios cuyo nombre no incluya las letras 'ch'
6. Usuarios cuyo nombre solo incluya las letras 'ch'

### **Ejercicio 2: Subconsultas SQL** (Página 31)
Trabajar con las tablas GAMER combinando consultas y subconsultas que cumplan con:
1. Juegos jugados por jugador
2. Condicionales en el nombre de los usuarios
3. Integración de HAVING
4. Funciones de agregación y GROUP BY

### **Ejercicio 3: Funciones Escalares** (Página 51)
Ejecutar las siguientes funciones:
1. Concatenar tu nombre completo (respetando los espacios)
2. Convertir tu nombre completo a minúsculas, luego a mayúsculas
3. Dividir tu año de nacimiento por tu día y mes (ej: 1975 / 2103)
4. Convertir en un entero absoluto el resultado anterior
5. Calcular los días que pasaron desde tu nacimiento hasta hoy
6. Averiguar qué día de semana era cuando naciste

---

## **Resumen Pedagógico de la Unidad**
Esta unidad desarrolla habilidades progresivas en SQL:
1. **UNION** → Combinar datos de múltiples fuentes
2. **LIKE** → Búsqueda flexible y eficiente
3. **Subconsultas** → Análisis de datos en múltiples niveles
4. **Funciones escalares** → Transformación y manipulación de datos
5. **DDL** → Diseño y mantenimiento de estructuras de base de datos
