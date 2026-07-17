-- Fase 4: eliminar dependencias parciales en venta_items
-- Análisis: la PK de venta_items es (venta_id, producto).
--   categoria depende solo de producto, no de la PK completa.
--   precio    depende solo de producto, no de (venta_id, producto).
-- Solución: sacar categoria y precio a una tabla productos.
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

DROP DATABASE IF EXISTS techstore_2fn;
CREATE DATABASE techstore_2fn;
USE techstore_2fn;

-- ventas igual que en 1FN
CREATE TABLE ventas (
    venta_id INT PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATE,
    vendedor_nombre VARCHAR(100),
    vendedor_email VARCHAR(100),
    vendedor_departamento VARCHAR(50),
    vendedor_depto_jefe VARCHAR(100),
    cliente_nombre VARCHAR(100),
    cliente_email VARCHAR(100),
    cliente_telefono VARCHAR(20),
    cliente_ciudad VARCHAR(50),
    cliente_estado VARCHAR(50),
    cliente_pais VARCHAR(50)
);

-- NUEVA: productos
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10,2)
);

-- venta_items pierde categoria y precio (ahora viven en productos)
CREATE TABLE venta_items (
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT,
    descuento DECIMAL(5,2),
    PRIMARY KEY (venta_id, producto_id),
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- Cargar productos únicos
INSERT INTO productos (nombre, categoria, precio) VALUES
    ('Laptop Pro',         'Computadoras', 1299.99),
    ('Mouse Inalámbrico',  'Periféricos',    45.99),
    ('Teclado Mecánico',   'Periféricos',   189.99),
    ('Monitor 4K',         'Periféricos',   599.99),
    ('Cable HDMI',         'Accesorios',     19.99);

-- Cargar ventas (igual que en 1FN)
INSERT INTO ventas SELECT * FROM techstore_1fn.ventas;

-- Cargar venta_items con producto_id (no producto string)
INSERT INTO venta_items (venta_id, producto_id, cantidad, descuento) VALUES
    (1, 1, 1, 0.10),  -- venta 1, Laptop Pro
    (1, 2, 2, 0.05),  -- venta 1, Mouse
    (2, 3, 1, 0.15),  -- venta 2, Teclado
    (3, 4, 1, 0.20),  -- venta 3, Monitor
    (3, 5, 3, 0.00);  -- venta 3, Cable

-- Mejora 2FN:
-- "Periféricos" ya no se repite en cada item — vive una sola vez en productos.
-- Cambiar el precio del Mouse Inalámbrico = 1 UPDATE.

-- Lo que aún falta:
-- "Ana García" sigue duplicada en ventas, "México" sigue duplicada en ventas.
-- 3FN ataca eso.