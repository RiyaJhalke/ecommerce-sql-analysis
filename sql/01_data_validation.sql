-- E-Commerce SQL Analysis: Data Validation
-- Database: olist_ecommerce
-- Run after importing the raw datasets.
-- Review row counts and investigate any import warnings before final reporting.

USE olist_ecommerce;

-- 1. Confirm which tables exist
SHOW TABLES;

-- 2. Check key table row counts
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'orders_staging', COUNT(*) FROM orders_staging
UNION ALL
SELECT 'products_staging', COUNT(*) FROM products_staging
UNION ALL
SELECT 'order_payments_staging', COUNT(*) FROM order_payments_staging
UNION ALL
SELECT 'sellers_staging', COUNT(*) FROM sellers_staging
UNION ALL
SELECT 'order_reviews_staging', COUNT(*) FROM order_reviews_staging
UNION ALL
SELECT 'category_translation_staging', COUNT(*) FROM category_translation_staging;

-- 3. Check duplicate order IDs
SELECT order_id, COUNT(*) AS occurrences
FROM orders_staging
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 4. Check orders without a matching customer
SELECT COUNT(*) AS unmatched_orders
FROM orders_staging o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 5. Check duplicate customer IDs
SELECT customer_id, COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 6. Check missing values in product metadata (staging columns are text)
SELECT
    SUM(NULLIF(TRIM(product_name_lenght), '') IS NULL) AS missing_name_length,
    SUM(NULLIF(TRIM(product_description_lenght), '') IS NULL) AS missing_description_length,
    SUM(NULLIF(TRIM(product_photos_qty), '') IS NULL) AS missing_photo_count,
    SUM(NULLIF(TRIM(product_weight_g), '') IS NULL) AS missing_weight
FROM products_staging;

-- 7. Check review staging table for missing identifiers
SELECT
    SUM(review_id IS NULL OR TRIM(review_id) = '') AS missing_review_ids,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_ids
FROM order_reviews_staging;

-- 8. Check orders whose order items do not match a known order
SELECT COUNT(*) AS order_items_without_order
FROM order_items oi
LEFT JOIN orders_staging o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
