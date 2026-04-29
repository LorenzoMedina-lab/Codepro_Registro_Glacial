-- 1. Maestros
CREATE TABLE public.customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email LIKE '%@%'),
    phone VARCHAR(50),
    city VARCHAR(100),
    segment VARCHAR(50),
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    CONSTRAINT chk_customer_time CHECK (deleted_at IS NULL OR deleted_at >= created_at)
);

CREATE TABLE public.products (
    product_id INTEGER PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    brand VARCHAR(100),
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    unit_cost NUMERIC(12, 2) NOT NULL CHECK (unit_cost >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_margin CHECK (unit_price >= unit_cost)
);

-- 2. Transacciones
CREATE TABLE public.orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES public.customers(customer_id),
    order_datetime TIMESTAMP NOT NULL,
    channel VARCHAR(50),
    currency VARCHAR(3) NOT NULL,
    current_status VARCHAR(50) NOT NULL,
    order_total NUMERIC(15, 2) NOT NULL CHECK (order_total >= 0)
);

CREATE TABLE public.order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES public.orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES public.products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12, 2) NOT NULL,
    discount_rate NUMERIC(5, 4) DEFAULT 0,
    line_total NUMERIC(15, 2) NOT NULL
);

CREATE TABLE public.payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES public.orders(order_id),
    payment_datetime TIMESTAMP NOT NULL,
    method VARCHAR(50),
    payment_status VARCHAR(50) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL,
    CONSTRAINT chk_pay_time CHECK (payment_datetime >= '2020-01-01')
);

-- 3. Trazabilidad
CREATE TABLE public.order_status_history (
    status_history_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES public.orders(order_id),
    status VARCHAR(50) NOT NULL,
    changed_at TIMESTAMP NOT NULL,
    changed_by VARCHAR(100)
);

CREATE TABLE public.order_audit (
    audit_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES public.orders(order_id),
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP NOT NULL,
    changed_by VARCHAR(100)
);