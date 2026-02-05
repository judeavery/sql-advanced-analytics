SET search_path TO retail;

WITH customer_orders AS (
  SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS completed_orders
  FROM orders o
  JOIN payments p
    ON p.order_id = o.order_id
  WHERE p.payment_status = 'completed'
  GROUP BY o.customer_id
),
labeled AS (
  SELECT
    CASE
      WHEN completed_orders = 1 THEN 'one_time'
      ELSE 'repeat'
    END AS customer_type
  FROM customer_orders
)
SELECT
  customer_type,
  COUNT(*) AS num_customers
FROM labeled
GROUP BY customer_type
ORDER BY customer_type;
