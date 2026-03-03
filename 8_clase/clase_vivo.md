### **Funciones y Stored Procedures**

#### **Ejercicio 1: Creación de una Función Personalizada (Práctica Guiada)**

*   **Objetivo:** Crear una función que calcule la cantidad de litros de pintura necesarios para pintar una pared.
*   **Consigna:**
    1.  Crea una función llamada `calcular_litros_de_pintura` que reciba tres parámetros de tipo `INT`:
        *   `largo`: El largo de la pared en metros.
        *   `alto`: El alto de la pared en metros.
        *   `total_manos`: La cantidad de manos de pintura a aplicar.
    2.  La función debe retornar un valor de tipo `FLOAT`.
    3.  Dentro de la función, define una variable `litro_x_m2` y asígnale el valor `0.10`, que representa los litros necesarios por metro cuadrado.
    4.  Calcula el resultado multiplicando: `(largo * alto) * total_manos * litro_x_m2`.
    5.  Guarda el resultado en una variable llamada `resultado` y retórnalo.
    6.  Una vez creada, prueba la función con la siguiente consulta:
        ```sql
        SELECT calcular_litros_de_pintura(22, 5, 3) AS total_pintura;
        ```

---

#### **Ejercicio 2: Práctica de Funciones SQL (Ejercicio para el Alumno - 15 min)**

*   **Objetivo:** Crear una función que consulte datos de una tabla existente.
*   **Contexto:** Base de datos `Gamers`, tabla `game` (que contiene columnas como `id_game` y `name`).
*   **Consigna:**
    1.  Crea una nueva función en la base de datos `GAMERS` llamada `get_game()`.
    2.  La función debe recibir un parámetro de entrada llamado `id_game`.
    3.  La función debe retornar el nombre del videojuego (`name`) que corresponde al `id_game` recibido.
    4.  Luego, crea una consulta del tipo `SELECT` que utilice la función para obtener el nombre del videojuego con un `id_game` específico.

---

#### **Ejercicio 3: Creación de un Stored Procedure Simple (Práctica Guiada)**

*   **Objetivo:** Crear un procedimiento almacenado que liste todos los registros de una tabla.
*   **Contexto:** Base de datos `gamers`, tabla `game`.
*   **Consigna:**
    1.  Crea un Stored Procedure llamado `sp_get_games`.
    2.  El procedimiento no debe recibir ningún parámetro.
    3.  Su única acción debe ser ejecutar una consulta `SELECT` que muestre todas las columnas de la tabla `game`.
    4.  Una vez creado, invoca el procedimiento desde una ventana de script usando la sentencia `CALL`.
        ```sql
        CALL sp_get_games();
        ```

---

#### **Ejercicio 4: Stored Procedure con `PREPARE` y `EXECUTE` (Práctica Guiada)**

*   **Objetivo:** Crear un procedimiento que ordene los resultados de forma dinámica.
*   **Contexto:** Base de datos `gamers`, tabla `game`.
*   **Consigna:**
    1.  Crea un Stored Procedure llamado `sp_get_games_order`.
    2.  Debe recibir un parámetro de entrada `IN field CHAR(20)` que indicará el nombre de la columna por la cual ordenar los resultados.
    3.  La lógica del procedimiento debe:
        *   Verificar si el parámetro `field` no está vacío.
        *   Si no está vacío, construir una variable `@game_order` que contenga la cadena `'ORDER BY '` seguida del nombre del campo.
        *   Si está vacío, establecer `@game_order` como una cadena vacía.
        *   Construir una variable `@clausula` que contenga la consulta `'SELECT * FROM game '` concatenada con `@game_order`.
        *   Usar `PREPARE` para preparar la sentencia SQL almacenada en `@clausula`.
        *   Ejecutar la sentencia con `EXECUTE`.
        *   Liberar los recursos con `DEALLOCATE PREPARE`.
    4.  Prueba el procedimiento llamándolo con diferentes nombres de columna, por ejemplo:
        ```sql
        CALL sp_get_games_order('name');
        CALL sp_get_games_order('id_game');
        ```

---

#### **Ejercicio 5: Actividad en Clase - S.P. de Inserción de Registros (Ejercicio para el Alumno - 15 min)**

*   **Objetivo:** Crear un Stored Procedure que inserte un nuevo registro y maneje un posible error.
*   **Consigna:**
    Crea un Stored Procedure que inserte datos en una tabla. La tabla y su estructura quedan a tu elección (puede ser una tabla simple de productos, categorías, etc., creada previamente).
    1.  El procedimiento debe recibir un parámetro del tipo `CHAR(xx)` (elige una longitud adecuada, por ejemplo, `CHAR(50)`). Este parámetro será el valor a insertar.
    2.  Debe insertar dicho parámetro como un nuevo registro en la tabla.
    3.  Después de la inserción, debe ejecutar un `SELECT` sobre la tabla, ordenando los registros de forma descendente por la columna de ID, para poder ver el registro insertado en primer lugar.
    4.  Si el parámetro `CHAR()` recibido es igual a una cadena vacía (`''`), el procedimiento no debe realizar la inserción y debe devolver un mensaje de error que diga: `'ERROR: no se pudo crear el producto indicado'`.