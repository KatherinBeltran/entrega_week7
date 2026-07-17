-- Fase 6: demostrar la mejora del diseño 3FN sobre el legacy
-- Nombre: Katherin Beltran
-- Fecha: [16/07/2026]

-- Mismo reporte: "Ventas por categoría"

-- Versión legacy (compleja, frágil):
USE techstore_legacy;

-- Imposible hacerlo limpio: las categorías están en una columna TEXT
-- separada por comas. Habría que parsear la columna `categorias` con
-- SUBSTRING_INDEX y FIND_IN_SET. Es código frágil, lento, y no escala.
SELECT 'Imposible sin parsear strings' AS resultado;

-- Versión 3FN (limpia y mantenible):
USE techstore_3fn;

SELECT
    c.nombre AS categoria,
    SUM(vi.cantidad * vi.precio_venta * (1 - vi.descuento)) AS revenue
FROM categorias c
JOIN productos p    ON c.categoria_id = p.categoria_id
JOIN venta_items vi ON p.producto_id = vi.producto_id
GROUP BY c.categoria_id, c.nombre
ORDER BY revenue DESC;

-- Demostrar que las anomalías están resueltas

USE techstore_3fn;

-- Anomalía de actualización RESUELTA
-- Ana cambia su email: 1 sola fila afectada
UPDATE vendedores SET email = 'ana.garcia@techstore.com' WHERE vendedor_id = 1;
-- Output esperado: "Query OK, 1 row affected"

-- Anomalía de inserción RESUELTA
-- Crear un nuevo departamento sin necesidad de que ya existan ventas
INSERT INTO departamentos (nombre, jefe) VALUES ('Marketing', 'Laura Vega');
-- Funciona sin problemas, no depende de que haya vendedores o ventas

-- Anomalía de eliminación RESUELTA
-- Si borrásemos todas las ventas de María, ella sigue existiendo como cliente
-- (gracias a que cliente vive en su propia tabla, independiente de ventas)
SELECT * FROM clientes WHERE cliente_id = 2;