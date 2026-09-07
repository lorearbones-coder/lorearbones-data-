-- PRE-ENTREGA 5 - CONSULTAS CON JOINS
-- Base de datos: Ventas_Tech_DB

-- NOTA:
-- El esquema utilizado en M3 está compuesto por las tablas
-- clientes, productos, categorias y ventas.
-- Estas tablas no contienen las columnas segmento, region ni canal.
-- Por este motivo, dichas columnas no pueden obtenerse de los datos
-- reales disponibles en la base de datos.

-- CONSULTA 1 - INNER JOIN
-- Combinamos ventas, clientes, productos y categorias
-- para obtener una vista enriquecida de las ventas.

SELECT
    v.fecha_venta,
    c.nombre AS cliente,
    NULL AS segmento,
    NULL AS region,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta,
    NULL AS canal
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;


-- CONSULTA 2 - CLIENTES SIN VENTAS
-- Buscamos clientes que no tienen ninguna venta registrada.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- Buscamos productos que no tienen ninguna venta registrada.

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;


-- CONSULTA 4 - CONSOLIDADO POR CANAL
-- La base de datos no contiene una columna canal ni una tabla
-- de sucursales o tiendas que permita identificar el canal real
-- de cada venta.
-- Por este motivo, para resolver la consigna se utiliza como
-- criterio de clasificación la ciudad del cliente, que sí es
-- un dato real disponible en la tabla clientes.
-- Criterio utilizado:
-- Buenos Aires y Córdoba = Online.
-- Resto de las ciudades = Presencial.
-- Esta clasificación es solamente para fines del ejercicio
-- y no representa el canal real de la venta.

SELECT
    canal,
    SUM(total_venta) AS total_por_canal
FROM (
    SELECT
        v.cantidad * v.precio_unitario AS total_venta,
        CASE
            WHEN c.ciudad IN ('Buenos Aires', 'Córdoba')
                THEN 'Online'
            ELSE 'Presencial'
        END AS canal
    FROM ventas v
    INNER JOIN clientes c
        ON v.id_cliente = c.id_cliente
) AS ventas_canal
GROUP BY canal;