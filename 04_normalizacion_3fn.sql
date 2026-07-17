-- Fase 5: eliminar TODAS las dependencias transitivas
-- Análisis:
--   vendedor → departamento → jefe   ⇒ tablas vendedores y departamentos
--   ciudad   → estado       → país   ⇒ tablas ciudades, estados, paises
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

DROP DATABASE IF EXISTS techstore_3fn;
CREATE DATABASE techstore_3fn;
USE techstore_3fn;

-- Catálogos de geografía (3 niveles)

CREATE TABLE paises (
    pais_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE estados (
    estado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    pais_id INT NOT NULL,
    FOREIGN KEY (pais_id) REFERENCES paises(pais_id),
    UNIQUE (nombre, pais_id)
);

CREATE TABLE ciudades (
    ciudad_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    estado_id INT NOT NULL,
    FOREIGN KEY (estado_id) REFERENCES estados(estado_id),
    UNIQUE (nombre, estado_id)
);

-- Organización

CREATE TABLE departamentos (
    departamento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    jefe VARCHAR(100)
);

CREATE TABLE vendedores (
    vendedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    departamento_id INT NOT NULL,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(departamento_id)
);

CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    ciudad_id INT,
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(ciudad_id)
);

-- Catálogo de productos

CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    categoria_id INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- Transacciones

CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    vendedor_id INT NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(vendedor_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE venta_items (
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,  -- guardamos el precio AL MOMENTO de la venta
    descuento DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (venta_id, producto_id),
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- Nota de diseño: precio_venta en venta_items

-- ¿Por qué guardamos el precio en venta_items además de en productos?
-- Porque el precio en `productos` es el ACTUAL.
-- El precio en `venta_items` es el que pagó el cliente en ese momento.
-- Si sube el precio del producto, no queremos que las ventas históricas
-- se "actualicen automáticamente" — eso falsearía reportes pasados.
-- Es una excepción a la normalización pura por razón de negocio.