
       --QUESTION ONE
       ---Which product has the highest price? Only return a single row. 
SELECT TOP 1
    products.product_name,
    products.price
FROM
    products
ORDER BY
    products.price DESC;

	   --QUESTION TWO
      ---Which customer has made the most orders?
SELECT TOP 1
    customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name) AS customer_name,
    COUNT(orders.order_id) AS order_count
FROM
    customers
JOIN
    orders ON customers.customer_id = orders.customer_id
GROUP BY
    customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name)
ORDER BY
    order_count DESC;

	    --QUESTION THREE
      ---What’s the total revenue per product?
SELECT
    products.product_id,
    products.product_name,
    SUM(order_items.quantity * products.price) AS total_revenue
FROM
    products
JOIN
    order_items ON products.product_id = order_items.product_id
GROUP BY
    products.product_id,
    products.product_name;

          --QUESTION FOUR
       ---Find the day with the highest revenue.
SELECT TOP 1
    orders.order_date,
    SUM(order_items.quantity * products.price) AS total_revenue
FROM
    orders
JOIN
    order_items ON orders.order_id = order_items.order_id
JOIN
    products ON order_items.product_id = products.product_id
GROUP BY
    orders.order_date
ORDER BY
    total_revenue DESC;

	       --QUESTION FIVE
        ---Find the first order (by date) for each customer.
SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name) AS customer_name,
    first_order.order_date AS first_order_date
FROM
    customers
JOIN
(SELECT customer_id, 
        MIN(order_date) AS order_date
FROM
     orders
GROUP BY
     customer_id
    ) AS first_order ON customers.customer_id = first_order.customer_id
JOIN
    orders ON first_order.customer_id = orders.customer_id
AND first_order.order_date = orders.order_date;

	        --QUESTION SIX
          ---Find the top 3 customers who have ordered the most distinct products.
SELECT TOP 3
    customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name) AS customer_name,
    COUNT(DISTINCT order_items.product_id) AS distinct_product_count
FROM
    customers
JOIN
    orders ON customers.customer_id = orders.customer_id
JOIN
    order_items ON orders.order_id = order_items.order_id
GROUP BY
    customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name)
ORDER BY
    distinct_product_count DESC;

	              --QUESTION SEVEN
                ---Which product has been bought the least in terms of quantity?
SELECT TOP 1
    products.product_id,
    products.product_name,
    MIN(order_items.quantity) AS minimum_quantity
FROM
    products
JOIN
    order_items ON products.product_id = order_items.product_id
GROUP BY
    products.product_id,
    products.product_name
ORDER BY
    minimum_quantity ASC;

	         --QUESTION EIGHT
           ---What is the median order total?
WITH ordered_totals AS (
    SELECT
        orders.order_id,
        SUM(order_items.quantity * products.price) AS order_total,
        ROW_NUMBER() OVER (ORDER BY SUM(order_items.quantity * products.price)) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM
        orders
    JOIN
        order_items ON orders.order_id = order_items.order_id
    JOIN
        products ON order_items.product_id = products.product_id
    GROUP BY
        orders.order_id
)
SELECT
    AVG(order_total) AS median_order_total
FROM
    ordered_totals
WHERE
    row_num IN ((total_rows + 1) / 2, (total_rows + 2) / 2);

	      ---QUESTION NINE
          ---For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’
SELECT
    orders.order_id,
    SUM(order_items.quantity * products.price) AS total,
    CASE
        WHEN SUM(order_items.quantity * products.price) > 300 THEN 'Expensive'
        WHEN SUM(order_items.quantity * products.price) > 100 THEN 'Affordable'
        ELSE 'Cheap'
    END AS affordability
FROM
    orders
JOIN
    order_items ON orders.order_id = order_items.order_id
JOIN
    products ON order_items.product_id = products.product_id
GROUP BY
    orders.order_id;

           --QUESTION TEN 
         ---Find customers who have ordered the product with the highest price.
SELECT    
	customers.customer_id,
    CONCAT(customers.first_name, ',', customers.last_name) AS customer_name
FROM
    customers
JOIN
    orders ON customers.customer_id = orders.customer_id
JOIN
    order_items ON orders.order_id = order_items.order_id
JOIN
    products ON order_items.product_id = products.product_id
JOIN
    (  SELECT
            MAX(price) AS max_price
       FROM
            products
     ) AS max_price_table ON products.price = max_price_table.max_price;   
    


