SET search_path TO retail;

SELECT 
    p.payment_method,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    COUNT(DISTINCT p.order_id) AS total_orders
FROM payments p
WHERE p.payment_status = 'completed'
GROUP BY p.payment_method
ORDER BY total_revenue DESC;
