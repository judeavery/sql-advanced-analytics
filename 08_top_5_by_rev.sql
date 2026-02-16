SET search_path TO retail;

WITH customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(p.amount) AS total_revenue
    FROM orders o
    JOIN payments p ON p.order_id = o.order_id
    WHERE p.payment_status = 'completed'
    GROUP BY o.customer_id
)
SELECT *,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank
LIMIT 5;
