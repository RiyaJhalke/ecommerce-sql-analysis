-- E-Commerce SQL Analysis: Data Cleaning
-- Creates clean tables from staging tables without modifying the staging data.
-- Run once. If a clean table already exists, inspect it before re-running.

USE olist_ecommerce;

-- Products: convert blank numeric strings to NULL and numeric strings to numbers.
CREATE TABLE products_clean AS
SELECT
    product_id,
    NULLIF(TRIM(product_category_name), '') AS product_category_name,
    CAST(NULLIF(TRIM(product_name_lenght), '') AS UNSIGNED) AS product_name_length,
    CAST(NULLIF(TRIM(product_description_lenght), '') AS UNSIGNED) AS product_description_length,
    CAST(NULLIF(TRIM(product_photos_qty), '') AS UNSIGNED) AS product_photos_qty,
    CAST(NULLIF(TRIM(product_weight_g), '') AS UNSIGNED) AS product_weight_g,
    CAST(NULLIF(TRIM(product_length_cm), '') AS UNSIGNED) AS product_length_cm,
    CAST(NULLIF(TRIM(product_height_cm), '') AS UNSIGNED) AS product_height_cm,
    CAST(NULLIF(TRIM(product_width_cm), '') AS UNSIGNED) AS product_width_cm
FROM products_staging;

-- Orders: convert timestamp strings to DATETIME; blanks become NULL.
CREATE TABLE orders_clean AS
SELECT
    order_id,
    customer_id,
    order_status,
    STR_TO_DATE(NULLIF(TRIM(order_purchase_timestamp), ''), '%Y-%m-%d %H:%i:%s') AS order_purchase_timestamp,
    STR_TO_DATE(NULLIF(TRIM(order_approved_at), ''), '%Y-%m-%d %H:%i:%s') AS order_approved_at,
    STR_TO_DATE(NULLIF(TRIM(order_delivered_carrier_date), ''), '%Y-%m-%d %H:%i:%s') AS order_delivered_carrier_date,
    STR_TO_DATE(NULLIF(TRIM(order_delivered_customer_date), ''), '%Y-%m-%d %H:%i:%s') AS order_delivered_customer_date,
    STR_TO_DATE(NULLIF(TRIM(order_estimated_delivery_date), ''), '%Y-%m-%d %H:%i:%s') AS order_estimated_delivery_date
FROM orders_staging;

-- Payments: convert numeric strings and preserve blanks as NULL.
CREATE TABLE order_payments_clean AS
SELECT
    TRIM(order_id) AS order_id,
    CAST(NULLIF(TRIM(payment_sequential), '') AS UNSIGNED) AS payment_sequential,
    NULLIF(TRIM(payment_type), '') AS payment_type,
    CAST(NULLIF(TRIM(payment_installments), '') AS UNSIGNED) AS payment_installments,
    CAST(NULLIF(TRIM(payment_value), '') AS DECIMAL(12,2)) AS payment_value
FROM order_payments_staging;
