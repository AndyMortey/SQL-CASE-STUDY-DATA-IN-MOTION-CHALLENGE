
SELECT 
    orders.order_id,
    CONCAT(customers.first_name, ',', customers.last_name) AS customer_name,
    customers.email,
    orders.order_date,
    order_items.quantity,
    products.product_name,
    products.price,
    SUM(order_items.quantity * products.price) AS revenue 
FROM 
    orders
JOIN 
    customers ON orders.customer_id = customers.customer_id
JOIN 
    order_items ON orders.order_id = order_items.order_id
JOIN 
    products ON order_items.product_id = products.product_id
GROUP BY
    orders.order_id,
    CONCAT(customers.first_name, ',', customers.last_name),
    customers.email,
    orders.order_date,
    order_items.quantity,
    products.product_name,
    products.price;












