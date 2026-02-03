-- schema/create_tables.sql
-- SQL Business Analytics Project (PostgreSQL)
-- Creates a simple retail / e-commerce schema with clean PK/FK relationships.

BEGIN;


CREATE SCHEMA IF NOT EXISTS retail;
SET search_path TO retail;

-- 1) Customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id      BIGSERIAL PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    email            VARCHAR(255) UNIQUE NOT NULL,
    phone            VARCHAR(25),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2) Products
CREATE TABLE IF NOT EXISTS products (
    product_id       BIGSERIAL PRIMARY KEY,
    product_name     VARCHAR(150) NOT NULL,
    category         VARCHAR(80) NOT NULL,
    unit_price       NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3) Orders (one customer can have many orders)
CREATE TABLE IF NOT EXISTS orders (
    order_id         BIGSERIAL PRIMARY KEY,
    customer_id      BIGINT NOT NULL REFERENCES customers(customer_id),
    order_ts         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status           VARCHAR(20) NOT NULL DEFAULT 'placed'
                     CHECK (status IN ('placed','paid','shipped','delivered','cancelled','refunded'))
);

-- 4) Order items (one order can have many items; each item is a product)
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id    BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id       BIGINT NOT NULL REFERENCES products(product_id),
    quantity         INTEGER NOT NULL CHECK (quantity > 0),
    unit_price       NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),

    -- helps prevent duplicate product lines for same order
    UNIQUE (order_id, product_id)
);

-- 5) Payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id       BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_ts       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    method           VARCHAR(30) NOT NULL
                     CHECK (method IN ('credit_card','debit_card','gift_card','paypal','apple_pay','cash')),
    amount           NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    payment_status   VARCHAR(20) NOT NULL DEFAULT 'completed'
                     CHECK (payment_status IN ('completed','failed','refunded'))
);

-- Helpful indexes 
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_ts ON orders(order_ts);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

COMMIT;
