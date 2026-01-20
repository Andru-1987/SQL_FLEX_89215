* [_Material de clase_](https://docs.google.com/presentation/d/1sEJj0T3u-4-DvFYFwYO25pjEI_Uc579GxWDzi31V37g/edit?slide=id.p1#slide=id.p1)


## **RESUMEN COMPLETO - TEMAS SQL**

### **1. UNION en SQL**
- **Propósito**: Combinar resultados de múltiples consultas SELECT en un único conjunto.
- **Requisitos**:
  - Mismo número de columnas en todas las consultas.
  - Tipos de datos compatibles en columnas correspondientes.
  - Mismo orden de columnas (recomendado: mismos nombres).
- **Variantes**:
  - `UNION`: Elimina duplicados.
  - `UNION ALL`: Incluye duplicados (más rápido).
- **Ordenamiento**: `ORDER BY` se aplica al resultado final.

---

### **2. Tipos de Datos en SQL**
| Categoría           | Tipos Comunes                          | Uso Principal                          |
|---------------------|----------------------------------------|----------------------------------------|
| **Numéricos**       | INT, DECIMAL, FLOAT                    | Enteros, decimales precisos, cálculos científicos |
| **Texto**           | CHAR, VARCHAR, TEXT                    | Textos de longitud fija/variable, contenido largo |
| **Fecha/Hora**      | DATE, TIME, DATETIME                   | Almacenar fechas, horas o ambos        |
| **Otros**           | BOOLEAN, BINARY                        | Valores lógicos, datos binarios        |

**Consideraciones clave**:
- Elegir tipo adecuado optimiza almacenamiento y rendimiento.
- Verificar tipos disponibles según motor de base de datos (MySQL, SQL Server, etc.).

---

### **3. Subconsultas (Subqueries)**
- **Definición**: Consulta dentro de otra consulta.
- **Usos comunes**:
  - Filtrar resultados con `WHERE` (ej: `WHERE salario > (SELECT AVG(salario)...)`).
  - Como columna derivada en `SELECT`.
  - Con operadores `IN`, `EXISTS`, `ANY/ALL`.
- **Tipos**:
  - **Correlacionadas**: Referencian columnas de la consulta externa.
  - **Anidadas**: Subconsultas dentro de subconsultas.

---

### **4. Operador LIKE**
- **Propósito**: Búsqueda de patrones en cadenas de texto.
- **Comodines**:
  - `%`: Cualquier número de caracteres.
  - `_`: Un único carácter.
- **Ejemplos**:
  - `LIKE 'Al%'`: Empieza con "Al".
  - `LIKE '%libro%'`: Contiene "libro".
  - `LIKE '_a%@dominio.com'`: Patrón específico en email.
- **Nota**: `%` al inicio puede afectar rendimiento (evita uso de índices).

---

### **5. DDL (Lenguaje de Definición de Datos)**
- **Sentencias principales**:
  - `CREATE`: Crear objetos (tablas, vistas, índices).
    ```sql
    CREATE TABLE Empleados (
      id INT PRIMARY KEY,
      nombre VARCHAR(100)
    );
    ```
  - `ALTER`: Modificar estructura.
    ```sql
    ALTER TABLE Empleados ADD email VARCHAR(255);
    ```
  - `DROP`: Eliminar objetos.
    ```sql
    DROP TABLE Empleados;
    ```
- **Consideraciones**:
  - Cambios son **permanentes** (usar con precaución).
  - Controlar permisos de ejecución.
  - Probar en entorno de desarrollo antes de producción.

---

### **6. Estructura del Curso (Unidades 0-12)**
**Temario principal**:
- **Unidades 0-2**: Introducción, bases relacionales, sentencias SQL básicas.
- **Unidades 3-6**: Subconsultas, DDL, objetos SQL, vistas, DML (manipulación de datos).
- **Unidades 7-10**: Importación de datos, procedimientos almacenados, triggers, transacciones.
- **Unidades 11-12**: Datawarehouse, Business Intelligence, IA con Azure SQL.

**Clases prácticas**: Semanales (ej: 20:30-22:30 hs), con grabaciones disponibles.

---

## **CONSEJOS PRÁCTICOS**
1. **Compatibilidad**: Verificar sintaxis específica del motor de base de datos.
2. **Rendimiento**:
   - Evitar `LIKE '%patrón'` en grandes volúmenes.
   - Usar `UNION ALL` si no necesitas eliminar duplicados.
3. **DDL**: Realizar backups antes de ejecutar `ALTER` o `DROP`.

---

**Palabras clave**: `UNION`, `tipos de datos`, `subconsultas`, `LIKE`, `DDL`, `CREATE`, `ALTER`, `DROP`, `patrones`, `rendimiento`.