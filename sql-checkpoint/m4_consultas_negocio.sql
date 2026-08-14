--Consultas de negocio--
USE Ventas_Tech_DB;
--CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL--
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);
-- CONSULTA 2 - RANKING DE PRODUCTOS--
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
--CONSULTA 3 - CLIENTES RECURRENTES--
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;
--CONSULTA 4 - MESES POR ENCIMA/DEBAJO DEL PROMEDIO--
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado,
        AVG(SUM(cantidad * precio_unitario)) OVER () AS promedio_mensual
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS resumen_mensual;
--HALLAZGOS DEL ANÁLISIS--
--1. En marzo se registraron 10 pedidos, con una facturación total de $6.444 y un ticket promedio de $644,40--
--2. El producto 1 lideró la facturación con $3.600, mientras que el producto 2 fue el que más unidades vendió, con 13 unidades--
--3. Los 5 clientes realizaron más de un pedido. El cliente 1 fue el que más gastó, con un total de $2.640--