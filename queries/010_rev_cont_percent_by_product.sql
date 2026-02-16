SET search_path TO retail;

WITH product_revenue AS (
    SELECT 
        pr.product_id,
        pr.product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products pr ON pr.product_id = oi.product_id
    GROUP BY pr.product_id, pr.product_name
)
SELECT 
    *,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_percentage
FROM product_revenue
ORDER BY revenue DESC;
