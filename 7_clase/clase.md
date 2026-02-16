## Importación y Gestión de Datos

*El documento aborda dos grandes temas:*

### 1. Importación y exportación de datos en MySQL
- Se explica cómo llevar datos desde una planilla de cálculo (ej. Excel) a una base de datos MySQL utilizando el asistente de MySQL Workbench.
- **Formato CSV**: se exporta la planilla como CSV (valores separados por comas) y luego se importa mediante el asistente, donde se pueden configurar opciones como:
  - Importar a tabla existente o crear nueva.
  - Eliminar datos previos o conservarlos.
  - Ajustar codificación (recomendado UTF-8).
  - Verificar coincidencia de columnas mediante vista previa.
- También se menciona la posibilidad de exportar datos desde MySQL a formato JSON.
- Se hace referencia al comando `LOAD DATA LOCAL INFILE` para importación por consola.

### 2. Integridad referencial y acciones en cascada
- Se retoma el concepto de integridad referencial (claves foráneas) y se profundiza en las acciones que pueden definirse para las operaciones `DELETE` y `UPDATE`:
  - **ON DELETE CASCADE**: al eliminar un registro de la tabla padre, se eliminan automáticamente todos los registros hijos que lo referencian.
  - **ON DELETE RESTRICT / NO ACTION**: impide la eliminación si existen registros hijos. En MySQL son equivalentes, aunque difieren en el momento de evaluación.
  - **ON DELETE SET NULL**: al eliminar el padre, la columna de clave foránea en los hijos se establece a NULL.
- Se presenta un ejemplo práctico con las tablas `PAIS` (padre) y `PERSONAS` (hija) para ilustrar el comportamiento de `CASCADE`.
- Se plantean cuestiones avanzadas: ¿cómo manejar cambios de nombre de país o divisiones geopolíticas? Esto lleva a pensar en el diseño de bases de datos y el uso de `ON UPDATE CASCADE` o estrategias alternativas (tablas históricas, etc.).

---

## Ejercicios y ejemplos del material

### Ejercicios prácticos

1. **Pregunta inicial (pág. 6)**:  
   *"¿Qué opciones de formato de archivos para importar o exportar datos conoces?"*  
   (Responder por chat de Zoom, reflexión grupal.)

2. **Práctica SQL: inserción de datos (pág. 14-15) – Duración 15 minutos**  
   - Generar un archivo `.CSV` con al menos **3 registros** para cargar en la tabla `productos`.  
   - Si no se generó la tabla, usar el código `CREATE` de la diapositiva 12 (no incluida en este PDF, pero se refiere a material de clase).  
   - Importar el archivo CSV agregando los registros creados.  
   - Investigar en MySQL Workbench cómo **exportar** el contenido de la misma tabla a un archivo en formato `.JSON`.

3. **Actividad colaborativa: Integridad referencial (pág. 16) – Duración 10 minutos**  
   Dinámica grupal basada en acuerdos de participación (apertura, escucha activa, etc.). No se especifica una tarea concreta, sino un espacio de reflexión y diálogo.

4. **Pregunta de reflexión (pág. 28)**:  
   *"¿Cómo debemos resolver la nacionalidad de personas cuyo país cambia de nombre? ¿Y cuando un país se divide, como sucedió con Serbia y Montenegro en 2006?"*  
   (Responder por chat de Zoom, debate conceptual.)

5. **Práctica SQL: on delete - on update (pág. 29) – Duración 20 minutos**  
   Practicar los procesos de `ON DELETE` y `ON UPDATE` (probablemente implementar diferentes acciones en claves foráneas, usando las tablas `PAIS` y `PERSONAS` u otras similares).

### Ejemplos de código SQL

- **Creación de tabla y clave foránea con CASCADE** (pág. 22):
  ```sql
  ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PAIS
  FOREIGN KEY (pais_id) REFERENCES PAIS(pais_id) ON DELETE CASCADE;
  ```

- **Inserción de datos de ejemplo** (pág. 23):
  ```sql
  INSERT INTO PAIS (pais_id, nombre_pais) VALUES
    (1, 'España'), (2, 'Italia'), (3, 'Argentina'), (4, 'Albania'), (5, 'Brasil');
  INSERT INTO PERSONAS (persona_id, nombre_completo, pais_id) VALUES
    (1, 'Fernando Omar', 3), (2, 'Julián Conte', 3), (3, 'Nicolás Mariano', 1),
    (4, 'Laura Grisel', 2), (5, 'Constantino Pascual', 4);
  ```

- **Eliminación en cascada** (pág. 25):
  ```sql
  DELETE FROM PAIS WHERE pais_id = 3;
  ```
  Resultado: se borra Argentina y las personas con `pais_id=3`.

- **Ejemplo de RESTRICT** (no se muestra código completo, pero se menciona su uso).

Estos ejemplos y ejercicios permiten al alumno aplicar los conceptos de importación de datos y gestión de integridad referencial en situaciones reales.