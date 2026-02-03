SET search_path to retail;

SELECT 
  DATE_TRUNCATE('month', o.order_ts)::date AS month, -- DATE_TRUNCATE isolates the month from the order timestamps columnn and then the timestamp is casted to a date 
  ROUND(SUM(p.amount),2) AS revenue
FROM orders o
JOIN payments p
  ON p.order_id = o.order_id
WHERE p.payment_status = 'completed'
GROUP BY 1
ORDER BY 1;
