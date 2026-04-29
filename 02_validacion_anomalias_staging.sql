-- Demostrar la Corrupción de la Auditoría --
-- Si intento migrar esta tabla a mi modelo final la base de datos lo abortaria porque el valor que tenia que ser numero es una letra --
SELECT 
    audit_id AS identificador_de_auditoria,
    field_name, 
    old_value, 
    new_value,
    changed_at
FROM staging.order_audit
WHERE field_name = 'order_total'
LIMIT 10;

-- Demostrar la Falla Matemática (Descuentos Ignorados) --
-- Los descuentos no fueron aplicados al cliente, fueron omitidos--
SELECT 
    order_item_id, 
    quantity, 
    unit_price, 
    discount_rate,
    line_total AS total_segun_csv,
    (quantity::NUMERIC * unit_price::NUMERIC) AS total_sin_descuento,
    (quantity::NUMERIC * unit_price::NUMERIC * (1 - discount_rate::NUMERIC)) AS total_real_esperado
FROM staging.order_items
WHERE discount_rate::NUMERIC > 0
  AND line_total::NUMERIC = (quantity::NUMERIC * unit_price::NUMERIC)
LIMIT 10;

-- Demostrar la Fragmentación de Identidad (Duplicados de Clientes) --
-- Se encuentran clientes con el mismo nombre pero diferente numero de ID--
SELECT 
    c1.customer_id AS id_registro_1, 
    c1.full_name AS cliente, 
    c1.email AS email_1, 
    c2.customer_id AS id_registro_2, 
    c2.email AS email_2
FROM staging.customers c1
JOIN staging.customers c2 ON c1.full_name = c2.full_name
WHERE c1.customer_id < c2.customer_id 
ORDER BY c1.full_name
LIMIT 100;
-- 
SELECT 
    o.order_id, 
    o.current_status AS estado_logistico, 
    p.payment_id,
    p.payment_status AS estado_financiero
FROM staging.orders o
JOIN staging.payments p ON o.order_id = p.order_id
WHERE o.current_status IN ('shipped', 'delivered') 
  AND p.payment_status IN ('rejected', 'failed', 'pending')
LIMIT 10;
-- Ordenes que no tienen ningun producto asociado -- 
SELECT 
    o.order_id, 
    o.order_datetime, 
    o.order_total, 
    o.current_status
FROM staging.orders o
LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
WHERE oi.order_item_id IS NULL;
-- Pedidos con costo 0 --
SELECT 
    order_id, 
    customer_id, 
    order_datetime, 
    order_total
FROM staging.orders
WHERE order_total::NUMERIC = 0;