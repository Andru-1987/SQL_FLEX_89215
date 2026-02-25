CREATE DATABASE importacion_data;
USE importacion_data;

CREATE TABLE jugadores_importacion(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    dob  DATE,
    posicion VARCHAR(100),
    pie_habil VARCHAR(100) DEFAULT "diestro",
    valoracion DECIMAL(12,2)
);

CREATE TABLE clubes_importacion(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(200),
    fecha_fundacion DATE,
    socios INT,
    patrocinar_ppal VARCHAR(20)
);




CREATE TABLE pais (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200)
);


CREATE TABLE ciudad(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(200),
    pais_ref INT
);


ALTER TABLE ciudad
	ADD CONSTRAINT fk_pais_ciudad 
	FOREIGN KEY(pais_ref) REFERENCES pais(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Insertar 20 países
INSERT INTO pais (nombre) VALUES
('España'),
('México'),
('Argentina'),
('Colombia'),
('Perú'),
('Chile'),
('Venezuela'),
('Ecuador'),
('Bolivia'),
('Paraguay'),
('Uruguay'),
('Brasil'),
('Estados Unidos'),
('Canadá'),
('Reino Unido'),
('Francia'),
('Italia'),
('Alemania'),
('Japón'),
('Australia');


-- Insertar ciudades (entre 2 y 4 por país)
INSERT INTO ciudad (nombre, pais_ref) VALUES
-- España (4 ciudades)
('Madrid', 1),
('Barcelona', 1),
('Valencia', 1),
('Sevilla', 1),

-- México (4 ciudades)
('Ciudad de México', 2),
('Guadalajara', 2),
('Monterrey', 2),
('Cancún', 2),

-- Argentina (4 ciudades)
('Buenos Aires', 3),
('Córdoba', 3),
('Rosario', 3),
('Mendoza', 3),

-- Colombia (4 ciudades)
('Bogotá', 4),
('Medellín', 4),
('Cali', 4),
('Barranquilla', 4),

-- Perú (4 ciudades)
('Lima', 5),
('Arequipa', 5),
('Cusco', 5),
('Trujillo', 5),

-- Chile (4 ciudades)
('Santiago', 6),
('Valparaíso', 6),
('Concepción', 6),
('La Serena', 6),

-- Venezuela (3 ciudades)
('Caracas', 7),
('Maracaibo', 7),
('Valencia', 7),

-- Ecuador (3 ciudades)
('Quito', 8),
('Guayaquil', 8),
('Cuenca', 8),

-- Bolivia (3 ciudades)
('La Paz', 9),
('Santa Cruz', 9),
('Cochabamba', 9),

-- Paraguay (3 ciudades)
('Asunción', 10),
('Ciudad del Este', 10),
('Encarnación', 10),

-- Uruguay (3 ciudades)
('Montevideo', 11),
('Punta del Este', 11),
('Colonia del Sacramento', 11),

-- Brasil (4 ciudades)
('Brasilia', 12),
('São Paulo', 12),
('Río de Janeiro', 12),
('Salvador', 12),

-- Estados Unidos (4 ciudades)
('Nueva York', 13),
('Los Ángeles', 13),
('Chicago', 13),
('Miami', 13),

-- Canadá (3 ciudades)
('Toronto', 14),
('Vancouver', 14),
('Montreal', 14),

-- Reino Unido (3 ciudades)
('Londres', 15),
('Manchester', 15),
('Edimburgo', 15),

-- Francia (3 ciudades)
('París', 16),
('Lyon', 16),
('Marsella', 16),

-- Italia (3 ciudades)
('Roma', 17),
('Milán', 17),
('Nápoles', 17),

-- Alemania (3 ciudades)
('Berlín', 18),
('Múnich', 18),
('Hamburgo', 18),

-- Japón (3 ciudades)
('Tokio', 19),
('Osaka', 19),
('Kioto', 19),

-- Australia (3 ciudades)
('Sídney', 19),
('Melbourne', 19),
('Brisbane', 19);



-- las ciudades con los paises


SELECT 
	p.nombre,
    c.nombre,
    p.id
FROM importacion_data.pais AS p
RIGHT JOIN importacion_data.ciudad AS c ON c.pais_ref = p.id ;

DELETE FROM importacion_data.pais 
WHERE nombre LIKE 'Alemania';

UPDATE importacion_data.pais
	SET id  = 40
WHERE nombre LIKE '%Jap%';





CREATE TABLE proveedor (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cuit VARCHAR(20) UNIQUE,
    nombre VARCHAR(200)
);


CREATE TABLE facturas_internas_producto(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre_producto VARCHAR(200),
    valor DECIMAL(10,2) DEFAULT 10000.00,
    id_proveedor INT
);


ALTER TABLE facturas_internas_producto
	ADD CONSTRAINT fk_facturas_internas_producto 
	FOREIGN KEY(id_proveedor) REFERENCES proveedor(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
    
    
    -- Insertar 5 proveedores de ejemplo
INSERT INTO proveedor (cuit, nombre) VALUES
('30-12345678-9', 'Distribuidora del Centro S.A.'),
('30-87654321-0', 'Importadora del Norte S.R.L.'),
('33-45678901-2', 'Tecnología Global S.A.'),
('30-98765432-1', 'Alimentos Frescos S.H.'),
('33-56789012-3', 'Materiales y Suministros S.A.');

-- Insertar 10 facturas internas de productos
INSERT INTO facturas_internas_producto (nombre_producto, valor, id_proveedor) VALUES
-- Factura 1: Notebooks (proveedor 3 - Tecnología Global)
('Notebook Dell Inspiron 15', 850000.00, 3),

-- Factura 2: Productos de limpieza (proveedor 4 - Alimentos Frescos)
('Detergente Ultra 5L', 12500.00, 4),

-- Factura 3: Artículos de librería (proveedor 5 - Materiales y Suministros)
('Resma de papel A4 x 500 hojas', 8500.00, 5),

-- Factura 4: Electrónica (proveedor 2 - Importadora del Norte)
('Smart TV 50" 4K', 450000.00, 2),

-- Factura 5: Alimentos no perecederos (proveedor 4 - Alimentos Frescos)
('Aceite de girasol 1.5L', 3500.00, 4),

-- Factura 6: Periféricos de computadora (proveedor 3 - Tecnología Global)
('Mouse inalámbrico Logitech', 12500.00, 3),

-- Factura 7: Bebidas (proveedor 1 - Distribuidora del Centro)
('Agua mineral sin gas 2L', 1800.00, 1),

-- Factura 8: Electrodomésticos (proveedor 2 - Importadora del Norte)
('Heladera con freezer 320L', 650000.00, 2),

-- Factura 9: Productos de higiene personal (proveedor 4 - Alimentos Frescos)
('Jabón de tocador x 3 unidades', 2400.00, 4),

-- Factura 10: Herramientas (proveedor 5 - Materiales y Suministros)
('Taladro inalámbrico 18V', 125000.00, 5);


DELETE FROM importacion_data.proveedor
WHERE nombre LIKE 'Importadora%';

UPDATE importacion_data.proveedor
	SET id = 20
    -- , cuit = '30-12345678-9'
WHERE nombre LIKE 'Importadora%';


SELECT * FROM importacion_data.facturas_internas_producto;



CREATE TABLE modelo_ml(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50)
);


CREATE TABLE modelo_ml_logs(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	descripcion TEXT,
    fecha_creacion DATETIME,
    id_modelo INT
);


ALTER TABLE modelo_ml_logs
	ADD CONSTRAINT fk_modelo_ml_logs
	FOREIGN KEY(id_modelo) REFERENCES modelo_ml(id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;



-- Insertar 4 modelos de machine learning
INSERT INTO modelo_ml (nombre) VALUES
('Clasificador de Textos BERT'),
('Detector de Fraudes XGBoost'),
('Recomendador de Productos ALS'),
('Segmentador de Clientes K-Means');

-- Insertar 10 logs para cada modelo (40 registros en total)

-- Logs para modelo 1: Clasificador de Textos BERT
INSERT INTO modelo_ml_logs (descripcion, fecha_creacion, id_modelo) VALUES
('Inicio de entrenamiento del modelo BERT', '2025-01-10 09:30:00', 1),
('Carga de dataset de entrenamiento (50,000 textos)', '2025-01-10 09:35:00', 1),
('Época 1/5 completada - Loss: 0.423', '2025-01-10 10:15:00', 1),
('Época 2/5 completada - Loss: 0.287', '2025-01-10 10:55:00', 1),
('Época 3/5 completada - Loss: 0.198', '2025-01-10 11:35:00', 1),
('Época 4/5 completada - Loss: 0.145', '2025-01-10 12:15:00', 1),
('Época 5/5 completada - Loss: 0.112', '2025-01-10 12:55:00', 1),
('Validación completada - Accuracy: 94.5%', '2025-01-10 13:05:00', 1),
('Modelo guardado en producción', '2025-01-10 13:10:00', 1),
('Predicción en lote procesada (10,000 textos)', '2025-01-10 14:30:00', 1),

-- Logs para modelo 2: Detector de Fraudes XGBoost
('Inicio de entrenamiento XGBoost', '2025-02-05 11:00:00', 2),
('Carga de transacciones históricas (1.2M registros)', '2025-02-05 11:10:00', 2),
('Preprocesamiento de datos completado', '2025-02-05 11:30:00', 2),
('Entrenamiento con 500 árboles', '2025-02-05 12:00:00', 2),
('Validación cruzada fold 1/5 - AUC: 0.89', '2025-02-05 12:30:00', 2),
('Validación cruzada fold 2/5 - AUC: 0.91', '2025-02-05 13:00:00', 2),
('Validación cruzada fold 3/5 - AUC: 0.88', '2025-02-05 13:30:00', 2),
('Validación cruzada fold 4/5 - AUC: 0.92', '2025-02-05 14:00:00', 2),
('Validación cruzada fold 5/5 - AUC: 0.90', '2025-02-05 14:30:00', 2),
('Modelo desplegado en API de detección', '2025-02-05 15:00:00', 2),

-- Logs para modelo 3: Recomendador de Productos ALS
('Inicio entrenamiento ALS', '2025-03-12 08:00:00', 3),
('Carga matriz usuario-producto (500k interacciones)', '2025-03-12 08:20:00', 3),
('Factorización con 20 factores latentes', '2025-03-12 09:00:00', 3),
('Iteración 5/50 completada', '2025-03-12 09:15:00', 3),
('Iteración 10/50 completada', '2025-03-12 09:30:00', 3),
('Iteración 25/50 completada', '2025-03-12 10:00:00', 3),
('Iteración 50/50 completada', '2025-03-12 10:45:00', 3),
('Cálculo de recomendaciones batch', '2025-03-12 11:00:00', 3),
('Precisión@10 en test: 0.42', '2025-03-12 11:30:00', 3),
('Recomendaciones actualizadas en producción', '2025-03-12 12:00:00', 3),

-- Logs para modelo 4: Segmentador de Clientes K-Means
('Inicio segmentación RFM', '2025-04-20 10:00:00', 4),
('Carga datos clientes (150k registros)', '2025-04-20 10:15:00', 4),
('Normalización de variables', '2025-04-20 10:30:00', 4),
('Cálculo método del codo para k óptimo', '2025-04-20 11:00:00', 4),
('Seleccionado k=5 segmentos', '2025-04-20 11:30:00', 4),
('Entrenamiento K-Means iniciado', '2025-04-20 11:45:00', 4),
('Convergencia alcanzada en 12 iteraciones', '2025-04-20 12:15:00', 4),
('Asignación de clusters completada', '2025-04-20 12:30:00', 4),
('Análisis de perfiles de segmentos', '2025-04-20 13:00:00', 4),
('Segmentos exportados a CRM', '2025-04-20 13:30:00', 4);

SELECT * FROM importacion_data.modelo_ml_logs;

DELETE FROM importacion_data.modelo_ml
WHERE id != 4;

