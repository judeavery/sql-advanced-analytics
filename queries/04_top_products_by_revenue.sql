SET search_path TO retail;

SELECT
  pr.product_id,
  pr.product_name,
  pr.category,
  SUM(oi.quantity) AS units_sold,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products pr
JOIN order_items oi
  ON oi.product_id = pr.product_id
JOIN orders o
  ON o.order_id = oi.order_id
JOIN payments p
  ON p.order_id = o.order_id
WHERE p.payment_status = 'completed'
GROUP BY
  pr.product_id,
  pr.product_name,
  pr.category
ORDER BY revenue DESC
LIMIT 10;
