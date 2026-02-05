SET search_path TO retail;

WITH order_totals AS (
  SELECT
    o.order_id,
    DATE_TRUNC('month', o.order_ts)::date AS month,
    SUM(oi.quantity * oi.unit_price) AS order_total
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  JOIN payments p
    ON p.order_id = o.order_id
  WHERE p.payment_status = 'completed'
  GROUP BY o.order_id, DATE_TRUNC('month', o.order_ts)::date
)
SELECT
  month,
  ROUND(AVG(order_total), 2) AS avg_order_value,
  COUNT(*) AS num_orders
FROM order_totals
GROUP BY month
ORDER BY month;
