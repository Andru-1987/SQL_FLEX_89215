## Clase 3 -> Subconsultas & DDL

* [_Material de clase_](https://docs.google.com/presentation/d/1sEJj0T3u-4-DvFYFwYO25pjEI_Uc579GxWDzi31V37g/edit?slide=id.p1#slide=id.p1)



## Resumen del material On Demand
1. UNION – Combinar conjuntos de resultados
2. Tipos de Datos – Los elementos fundamentales de SQL
3. Subconsultas – Consultas dentro de consultas
4. LIKE – Búsqueda con patrones de texto
5. DDL – El lenguaje de definición de bases de datos

---

## 1. UNION: Combinador de Resultados
**Analogía:** Imagina dos listas de estudiantes (una de mañana, otra de tarde). UNION las une en una sola lista, eliminando nombres repetidos; UNION ALL los mantiene todos.

### Concepto Clave:
```sql
-- Ejemplo Visual
SELECT nombre FROM estudiantes_matutinos
UNION
SELECT nombre FROM estudiantes_vespertinos;
```

**Reglas Fundamentales:**
- Mismo número y tipo de columnas en ambos SELECT
- UNION = Sin duplicados (proceso más lento)
- UNION ALL = Con duplicados (proceso más rápido)

**Tip:**  Pensarlo como "sumar tablas verticalmente" en contraste con JOIN que es "unir tablas horizontalmente".

---

## 2. Tipos de Datos: Selección Apropiada
**Analogía:** Elegir entre diferentes contenedores: pequeño (CHAR), ajustable (VARCHAR), o grande (TEXT).

### Guía Rápida de Selección:
| Tipo | Uso Principal | Ejemplo Práctico |
|------|---------------|------------------|
| INT | Números enteros | Cantidad: 15 unidades |
| DECIMAL | Valores monetarios, medidas | Precio: $19.99 |
| VARCHAR(100) | Texto de longitud variable | Nombre: "María González" |
| DATE | Solo fechas | Fecha nacimiento: 1995-03-15 |
| DATETIME | Fecha + hora exacta | Registro: 2024-01-20 14:30:00 |

**Error Común:** Utilizar VARCHAR(255) para todos los campos de texto, lo que desperdicia espacio y afecta el rendimiento.

---

## 3. Subconsultas: Consultas Anidadas
**Definición Simple:** Una consulta utilizada dentro de otra consulta.
```sql
-- Ejemplo: "Empleados que ganan más que el promedio"
SELECT nombre, salario 
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados);
```

### Dos Categorías Principales:
1. **Correlacionadas:** Dependen de la consulta exterior
2. **No Correlacionadas:** Se ejecutan independientemente una vez

**Enfoque Pedagógico:** Iniciar con el operador IN por su mayor intuición:
```sql
-- "Productos vendidos en enero"
SELECT * FROM productos 
WHERE id IN (SELECT producto_id FROM ventas WHERE mes = 'Enero');
```

---

## 4. LIKE: Búsqueda por Patrones
**Analogía:** Similar al uso de comodines en búsqueda de archivos del sistema operativo.

| Comodín | Función | Ejemplo | Coincidencia |
|---------|---------|---------|--------------|
| % | Cualquier secuencia (0 o más caracteres) | 'Mar%' | María, Marcos |
| _ | Exactamente un carácter (cualquiera) | '_aña' | Caña, Maña |

**Consideración de Rendimiento:**
```sql
-- OPTIMO (usa índices): LIKE 'Juan%'
-- INEFICIENTE (escaneo completo): LIKE '%Juan%'
```

**Ejemplo:** Buscar correos electrónicos por dominio:
```sql
SELECT email FROM usuarios WHERE email LIKE '%@gmail.com';
-- Resultado: ana@gmail.com, pedro@gmail.com
```

---

## 5. DDL: Lenguaje de Definición de Datos
**Metáfora:** Si la base de datos fuera un edificio:
- CREATE = Construir una nueva habitación
- ALTER = Modificar una habitación existente
- DROP = Demoler una habitación (operación crítica)

### Los Tres Comandos Fundamentales:
```sql
-- 1. CREAR (estructura inicial)
CREATE TABLE Estudiantes (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- 2. MODIFICAR (cambiar estructura)
ALTER TABLE Estudiantes ADD COLUMN email VARCHAR(100);

-- 3. ELIMINAR (remover completamente)
DROP TABLE Estudiantes; -- OPERACION IRREVERSIBLE
```

**Principio de Seguridad:**
"Nunca ejecutar DROP en entorno de producción sin backup previo. Es equivalente a eliminar permanentemente un documento crítico."


## Glosario de Términos Esenciales
| Término | Definición Concisa |
|---------|-------------------|
| UNION | Combinar resultados de múltiples consultas verticalmente |
| Subconsulta | Consulta anidada dentro de otra consulta principal |
| DDL | Lenguaje para definir estructuras de base de datos |
| LIKE | Operador para búsqueda de patrones en cadenas de texto |
| Tipo de dato | Especificación de cómo se almacena y trata cada información |

