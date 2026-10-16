-- Calculating total revenue (gives the total recorded payment value across all payment records)
USE olist_ecommerce;

SELECT
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments_clean;


-- Analyzing monthly revenue (Which months had the highest 
-- and lowest revenue? Are there noticeable seasonal patterns?)
SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp, '%Y-%m'
    ) AS order_month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM orders_clean o
JOIN order_payments_clean p
    ON o.order_id = p.order_id
GROUP BY
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- Calculate average order value (calculates the average
-- payment total per order, rather than averaging individual payment records.)
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS order_total
    FROM order_payments_clean
    GROUP BY order_id
) AS order_totals;


-- Analyze order status (tells what percentage of orders were
-- delivered, cancelled, shipped, or had another status.)
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders_clean),
        2
    ) AS percentage_of_orders
FROM orders_clean
GROUP BY order_status
ORDER BY total_orders DESC;


-- Analyze month-over-month revenue growth using LAG()
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(
            o.order_purchase_timestamp, '%Y-%m'
        ) AS order_month,
        SUM(p.payment_value) AS revenue
    FROM orders_clean o
    JOIN order_payments_clean p
        ON o.order_id = p.order_id
    GROUP BY DATE_FORMAT(
        o.order_purchase_timestamp, '%Y-%m'
    )
),
revenue_comparison AS (
    SELECT
        order_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    order_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        * 100.0 / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM revenue_comparison
ORDER BY order_month;

-- A positive percentage means revenue increased; 
-- a negative percentage means it decreased. The 
-- first month will have NULL growth because there 
-- is no previous month for comparison.