-- Análisis del esquema legacy — TechStore
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

-- Contexto

-- La base techstore_legacy tiene una sola tabla (ventas_completas)
-- que mezcla vendedores, clientes, productos y ventas.
-- Este documento identifica las violaciones de diseño antes
-- de empezar a normalizar.

-- 1. Violaciones de 1FN (multi-valores en una celda)

-- Columna     | Problema
-- ------------|----------------------------------------------
-- productos   | Múltiples valores separados por comas
--             |   (ej. "Laptop Pro,Mouse Inalámbrico")
-- categorias  | Múltiples valores separados por comas
-- precios     | Múltiples valores separados por comas
-- cantidades  | Múltiples valores separados por comas
-- descuentos  | Múltiples valores separados por comas

-- Test de la violación:
-- Una query como la siguiente NO funciona como se espera:

--   SELECT * FROM ventas_completas WHERE productos = 'Mouse Inalámbrico';

-- Devuelve 0 filas porque la celda completa contiene
-- "Laptop Pro,Mouse Inalámbrico", no solo "Mouse Inalámbrico".
-- Habría que usar LIKE '%Mouse Inalámbrico%', lo cual es frágil,
-- lento y no escala.

-- 2. Dependencias transitivas (A → B → C)

-- Cadena                                                  | Problema
-- ---------------------------------------------------------|----------------------------------------------
-- vendedor_email → vendedor_departamento → vendedor_depto_jefe | El jefe depende del departamento,
--                                                            |   no del vendedor directamente
-- cliente_ciudad → cliente_estado → cliente_pais           | El país depende del estado,
--                                                            |   no del cliente directamente
-- producto → categoria (al dividir por venta)              | La categoría depende del producto,
--                                                            |   no de la venta

-- 3. Anomalías reales que sufre esta base

-- Anomalía de actualización

-- Si Ana García cambia su email, hay que actualizar N filas
-- (todas las ventas que ella hizo). Si se olvida una fila,
-- la base queda inconsistente.

--   UPDATE ventas_completas
--   SET vendedor_email = 'ana.garcia@techstore.com'
--   WHERE vendedor_nombre = 'Ana García';
--   -- afecta N filas en lugar de 1

-- Anomalía de inserción

-- No se puede registrar un nuevo departamento que aún no tiene
-- vendedores asignados. La única forma de crear una fila con
-- datos de departamento es a través de una venta.

--   -- No existe forma de hacer esto sin inventar una venta falsa:
--   -- INSERT INTO ventas_completas (..., vendedor_departamento, ...)
--   -- VALUES (..., 'Marketing', ...);  -- requiere datos de venta que no existen

-- Anomalía de eliminación

-- Si se borra la única venta de "María González", se pierde a
-- María por completo — la base ya no tiene forma de saber que
-- esa clienta existe.

--   DELETE FROM ventas_completas WHERE cliente_nombre = 'María González';
--   -- María desaparece de la base entera, no solo su venta

-- Redundancia masiva

-- "Carlos López" como jefe de Ventas se repite en cada fila de
-- Ana y Pedro. "México" se repite en cada fila de cliente mexicano.
-- El mismo dato queda escrito muchas veces en lugar de una sola.

--   SELECT vendedor_depto_jefe, COUNT(*)
--   FROM ventas_completas
--   GROUP BY vendedor_depto_jefe;
--   -- 'Carlos López' aparece en las 3 filas

-- Conclusión

-- La tabla ventas_completas viola 1FN (multi-valores), y aunque
-- se dividiera en 1FN seguiría teniendo dependencias parciales (2FN)
-- y transitivas (3FN) sin resolver.