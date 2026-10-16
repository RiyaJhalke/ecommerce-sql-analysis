-- E-Commerce SQL Analysis: Customer Analysis

USE olist_ecommerce;

-- customer analysis (This query will reveal top 10 customers 
-- by delivered product spending.)
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spending
FROM customers c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC
LIMIT 10;


-- Identify repeat customers
-- (One-Time Customers: Customers with one delivered order.
-- Repeat Customers: Customers with more than one delivered order.)
SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        c.customer_unique_id,
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customers c
    JOIN orders_clean o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_summary
GROUP BY customer_type;

-- Calculate the repeat customer rate (This calculates the 
-- rate using the number of unique customers with at least 
-- one delivered order as the denominator.)
SELECT
    COUNT(*) AS total_customers,
    SUM(order_count > 1) AS repeat_customers,
    ROUND(
        100.0 * SUM(order_count > 1) / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders_clean o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_orders;


-- Customer spending segments
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders_clean o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
customer_segments AS (
    SELECT
        customer_unique_id,
        total_spending,
        CASE
            WHEN total_spending >= 1000
                THEN 'High Value'
            WHEN total_spending >= 200
                THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_spending
)
SELECT
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spending), 2) AS segment_revenue,
    ROUND(AVG(total_spending), 2) AS average_spending
FROM customer_segments
GROUP BY customer_segment
ORDER BY segment_revenue DESC;