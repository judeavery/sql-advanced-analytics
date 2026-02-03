-- Goal: Calculate customer lifetime value and return the top customers by total revenue, sorted by highest revenue

SET search_path TO retail;

SELECT
c.customer_id,
c.first_name,
c.last_name,
ROUND(SUM(p.amount), 2) AS total_revenue,
COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON p.order_id = o.order_id
WHERE p.payment_status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC;
