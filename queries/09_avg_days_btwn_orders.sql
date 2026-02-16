SET search_path TO retail;

WITH ordered_dates AS (
    SELECT 
        customer_id,
        order_ts,
        LAG(order_ts) OVER (
            PARTITION BY customer_id 
            ORDER BY order_ts
        ) AS previous_order
    FROM orders
)
SELECT 
    customer_id,
    ROUND(AVG(order_ts - previous_order), 2) AS avg_days_between_orders
FROM ordered_dates
WHERE previous_order IS NOT NULL
GROUP BY customer_id
ORDER BY avg_days_between_orders;
