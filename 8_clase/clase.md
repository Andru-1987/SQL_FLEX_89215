### **Resumen de Conceptos Avanzados de SQL: Funciones y Procedimientos**

Una vez que dominas las consultas básicas, el siguiente paso es aprender a encapsular la lógica de negocio directamente en el servidor de la base de datos. Esto se logra mediante **Funciones Personalizadas** y **Procedimientos Almacenados (Stored Procedures)** . Ambos son bloques de código SQL que se guardan en el servidor para ser ejecutados cuando sea necesario, pero con propósitos ligeramente diferentes.

---

### **1. Funciones Personalizadas (User-Defined Functions)**

#### **Definición y Concepto**
Una función personalizada es un bloque de código SQL que realiza una tarea específica y **devuelve un solo valor**. A diferencia de las funciones integradas de SQL (como `COUNT` o `AVG`), estas son creadas por el usuario para satisfacer necesidades de negocio muy concretas.

#### **¿Por qué usarlas? (Beneficios Clave)**
1.  **Modularidad y Reutilización:** Permiten encapsular lógica compleja en un solo lugar para ser reutilizada en múltiples consultas, evitando duplicar código.
2.  **Mantenimiento Simplificado:** Si la lógica de negocio cambia (ej. una nueva fórmula de cálculo de impuestos), solo se modifica la función, y todos los procesos que la llaman se actualizan automáticamente.
3.  **Mejora del Rendimiento:** Al procesar los datos directamente en el servidor, se reduce la cantidad de información transferida entre la base de datos y la aplicación cliente.
4.  **Seguridad:** Actúan como una capa de abstracción, permitiendo a los usuarios acceder a datos procesados sin tener acceso directo a las tablas subyacentes.

#### **Sintaxis General**
La estructura para crear una función sigue un patrón definido:

```sql
DELIMITER //

CREATE FUNCTION nombre_funcion (parametro1 TIPO_DATO, parametro2 TIPO_DATO)
RETURNS TIPO_DATO_DEL_RETORNO
[DETERMINISTIC | NOT DETERMINISTIC]
[CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA]
BEGIN
    DECLARE nombre_variable TIPO_DATO;
    -- Lógica de procesamiento...
    SET nombre_variable = expresion;
    RETURN nombre_variable;
END; //

DELIMITER ;
```

*   **`DELIMITER //`**: Cambia el delimitador temporalmente para que el motor de base de datos no interprete el `;` dentro de la función como el final del comando `CREATE`.
*   **`RETURNS`**: Especifica el tipo de dato del valor que la función devolverá.
*   **`BEGIN ... END`**: Delimita el cuerpo de la función, donde reside la lógica.
*   **`DECLARE`**: Se usa para declarar variables locales que solo existirán dentro de la función.
*   **`RETURN`**: Es obligatorio. Define el valor que la función envía de vuelta. Una función siempre retorna un único valor.

---

### **2. Procedimientos Almacenados (Stored Procedures)**

#### **Definición y Concepto**
Un procedimiento almacenado es un conjunto de instrucciones SQL (una o muchas) que se almacenan en la base de datos para realizar una tarea específica. A diferencia de las funciones, los procedimientos **no están obligados a retornar un valor** y pueden realizar acciones más complejas como modificar datos (`INSERT`, `UPDATE`, `DELETE`) o ejecutar transacciones.

#### **Estructura Básica**

```sql
DELIMITER //

CREATE PROCEDURE nombre_procedimiento (
    [IN | OUT | INOUT] nombre_parametro TIPO_DATO
)
BEGIN
    -- Lógica del procedimiento
    -- Puede incluir SELECTs, INSERTs, UPDATES, DELETEs, etc.
END; //

DELIMITER ;
```

*   **`IN`**: Parámetro de entrada. El procedimiento recibe un valor, pero no lo devuelve modificado.
*   **`OUT`**: Parámetro de salida. El procedimiento asigna un valor a este parámetro para devolverlo al entorno que lo llamó.
*   **`INOUT`**: Parámetro de entrada/salida. Recibe un valor y puede devolver otro distinto.

#### **Tipos de Procedimientos**
*   **Básicos:** No utilizan parámetros. Ideales para tareas rutinarias como limpieza de datos o generación de reportes fijos.
*   **Con parámetros `IN`:** Reciben datos para personalizar su ejecución (ej. "buscar un cliente por su ID").
*   **Con parámetros `OUT` o `INOUT`:** Devuelven resultados al usuario o a otros procedimientos (ej. "calcular el total de ventas y devolverlo").

#### **Uso de Estructuras de Control**
Los procedimientos almacenados ganan gran potencia al incluir estructuras de control propias de la programación:
*   **Variables:** Se declaran con `DECLARE` y se les asigna valor con `SET` para almacenar resultados intermedios.
*   **Condicionales (`IF...THEN...ELSE`):** Permiten ejecutar diferentes bloques de código según se cumplan o no ciertas condiciones, haciendo el procedimiento "inteligente" y adaptable.
    ```sql
    IF total_ventas > 1000 THEN
        SET categoria = 'Premium';
    ELSE
        SET categoria = 'Regular';
    END IF;
    ```

---

### **3. Comparativa Clave: Función vs. Procedimiento**

Para una clase inicial, es fundamental entender cuándo usar cada uno.

| Característica | Función Personalizada | Procedimiento Almacenado (Stored Procedure) |
| :--- | :--- | :--- |
| **Propósito** | Calcular y retornar un valor. | Realizar una tarea o proceso. |
| **Retorno** | **Obligatorio.** Siempre retorna un solo valor. | **Opcional.** Puede retornar 0, 1 o múltiples valores mediante parámetros `OUT`. |
| **Uso en Consultas** | Se puede llamar directamente dentro de un `SELECT`. | No se puede llamar dentro de un `SELECT`. Se ejecuta con `CALL`. |
| **Modificación de Datos** | Generalmente no se recomienda modificar datos (no `INSERT`/`UPDATE`/`DELETE`). | Sí, puede y suele modificar datos. |
| **Ejemplo de Uso** | `SELECT nombre, calcular_edad(fecha_nac) FROM usuarios;` | `CALL actualizar_inventario(producto_id, cantidad);` |

### **Conclusión**
Tanto las funciones como los procedimientos almacenados son herramientas esenciales para llevar el desarrollo de bases de datos a un nivel profesional. Permiten crear código más eficiente, seguro y fácil de mantener al centralizar la lógica de negocio directamente en el servidor de datos.