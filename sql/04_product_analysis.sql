-- E-Commerce SQL Analysis: Product Analysis

USE olist_ecommerce;

-- Highest revenue product categories 
-- (This query finds the top 10 categories by product revenue for delivered orders.)
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.order_item_id IS NOT NULL) AS items_sold,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
JOIN products_clean p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation_staging t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY product_revenue DESC
LIMIT 10;

-- Find top 10 individual products (identifies individual
-- products with highest total sales value)
SELECT
    p.product_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    COUNT(*) AS order_item_records,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
JOIN products_clean p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation_staging t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY p.product_id, product_category
ORDER BY product_revenue DESC
LIMIT 10;

-- Rank product categories using DENSE_RANK()
WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS product_category,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
    JOIN orders_clean o
        ON oi.order_id = o.order_id
    JOIN products_clean p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation_staging t
        ON p.product_category_name =
           t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY product_category
),
category_ranking AS (
    SELECT
        product_category,
        revenue,
        DENSE_RANK() OVER (
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM category_sales
)
SELECT
    revenue_rank,
    product_category,
    revenue
FROM category_ranking
ORDER BY revenue_rank
LIMIT 10;