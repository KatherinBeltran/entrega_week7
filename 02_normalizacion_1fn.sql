-- Fase 3: eliminar los multi-valores
-- Estrategia: dividir en "ventas" (encabezado) y "venta_items" (detalle)
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

DROP DATABASE IF EXISTS techstore_1fn;
CREATE DATABASE techstore_1fn;
USE techstore_1fn;

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

CREATE TABLE venta_items (
    venta_id INT NOT NULL,
    producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    cantidad INT,
    descuento DECIMAL(5,2),
    PRIMARY KEY (venta_id, producto),
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id)
);

-- Migrar datos manualmente (en producción usarías un script)
INSERT INTO ventas (venta_id, fecha_venta, vendedor_nombre, vendedor_email, vendedor_departamento, vendedor_depto_jefe, cliente_nombre, cliente_email, cliente_telefono, cliente_ciudad, cliente_estado, cliente_pais) VALUES
    (1, '2024-01-15', 'Ana García',     'ana@techstore.com',   'Ventas', 'Carlos López', 'Juan Pérez',     'juan@email.com',  '555-0100', 'CDMX',        'Ciudad de México', 'México'),
    (2, '2024-01-16', 'Ana García',     'ana@techstore.com',   'Ventas', 'Carlos López', 'María González', 'maria@email.com', '555-0200', 'Guadalajara', 'Jalisco',          'México'),
    (3, '2024-01-17', 'Pedro Martínez', 'pedro@techstore.com', 'Ventas', 'Carlos López', 'Juan Pérez',     'juan@email.com',  '555-0100', 'CDMX',        'Ciudad de México', 'México');

INSERT INTO venta_items (venta_id, producto, categoria, precio, cantidad, descuento) VALUES
    (1, 'Laptop Pro',         'Computadoras', 1299.99, 1, 0.10),
    (1, 'Mouse Inalámbrico',  'Periféricos',    45.99, 2, 0.05),
    (2, 'Teclado Mecánico',   'Periféricos',   189.99, 1, 0.15),
    (3, 'Monitor 4K',         'Periféricos',   599.99, 1, 0.20),
    (3, 'Cable HDMI',         'Accesorios',     19.99, 3, 0.00);

-- Mejora 1FN:
-- SELECT * FROM venta_items WHERE producto = 'Mouse Inalámbrico' ya funciona.
-- Cada celda tiene un solo valor.

-- Lo que aún no resuelve 1FN:
-- "Ana García" sigue duplicada en filas 1 y 2 de ventas.
-- "Periféricos" sigue duplicada en venta_items.
-- 2FN y 3FN atacan eso.