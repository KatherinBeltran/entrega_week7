-- Migración de datos: de techstore_legacy a techstore_3fn
-- Orden: catálogos primero, luego personas, luego transacciones
-- (respeta las dependencias de foreign keys)
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

USE techstore_3fn;

-- 1. Catálogos primero
INSERT INTO paises (nombre) VALUES ('México');

INSERT INTO estados (nombre, pais_id) VALUES
    ('Ciudad de México', 1),
    ('Jalisco', 1);

INSERT INTO ciudades (nombre, estado_id) VALUES
    ('CDMX', 1),
    ('Guadalajara', 2);

INSERT INTO departamentos (nombre, jefe) VALUES ('Ventas', 'Carlos López');

INSERT INTO categorias (nombre) VALUES
    ('Computadoras'), ('Periféricos'), ('Accesorios');

INSERT INTO productos (nombre, categoria_id, precio) VALUES
    ('Laptop Pro',        1, 1299.99),
    ('Mouse Inalámbrico', 2,   45.99),
    ('Teclado Mecánico',  2,  189.99),
    ('Monitor 4K',        2,  599.99),
    ('Cable HDMI',        3,   19.99);

-- 2. Personas
INSERT INTO vendedores (nombre, email, departamento_id) VALUES
    ('Ana García',     'ana@techstore.com',   1),
    ('Pedro Martínez', 'pedro@techstore.com', 1);

INSERT INTO clientes (nombre, email, telefono, ciudad_id) VALUES
    ('Juan Pérez',     'juan@email.com',  '555-0100', 1),
    ('María González', 'maria@email.com', '555-0200', 2);

-- 3. Transacciones
INSERT INTO ventas (venta_id, fecha_venta, vendedor_id, cliente_id) VALUES
    (1, '2024-01-15', 1, 1),  -- Ana → Juan
    (2, '2024-01-16', 1, 2),  -- Ana → María
    (3, '2024-01-17', 2, 1);  -- Pedro → Juan

INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_venta, descuento) VALUES
    (1, 1, 1, 1299.99, 0.10),
    (1, 2, 2,   45.99, 0.05),
    (2, 3, 1,  189.99, 0.15),
    (3, 4, 1,  599.99, 0.20),
    (3, 5, 3,   19.99, 0.00);

-- Verificación rápida: contar filas migradas
SELECT 'paises' AS tabla, COUNT(*) AS filas FROM paises
UNION ALL SELECT 'estados', COUNT(*) FROM estados
UNION ALL SELECT 'ciudades', COUNT(*) FROM ciudades
UNION ALL SELECT 'departamentos', COUNT(*) FROM departamentos
UNION ALL SELECT 'categorias', COUNT(*) FROM categorias
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'vendedores', COUNT(*) FROM vendedores
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'venta_items', COUNT(*) FROM venta_items;