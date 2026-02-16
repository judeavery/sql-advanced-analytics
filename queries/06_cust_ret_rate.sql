SET search_path TO retail;

WITH monthly_customers AS (
    SELECT 
        DATE_TRUNC('month', o.order_ts)::date AS month,
        o.customer_id
    FROM orders o
    GROUP BY month, o.customer_id
),
retention AS (
    SELECT 
        m1.month,
        COUNT(DISTINCT m1.customer_id) AS customers_this_month,
        COUNT(DISTINCT m2.customer_id) AS retained_customers
    FROM monthly_customers m1
    LEFT JOIN monthly_customers m2
        ON m1.customer_id = m2.customer_id
        AND m2.month = m1.month + INTERVAL '1 month'
    GROUP BY m1.month
)
SELECT *,
    ROUND(
        retained_customers::numeric / NULLIF(customers_this_month, 0), 
        2
    ) AS retention_rate
FROM retention
ORDER BY month;
