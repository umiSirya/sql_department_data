-- QUERIES
-- Customer Queries
USE department;

SELECT * FROM customers;

SELECT first_name, email FROM customers;

SELECT COUNT(*) FROM customers AS number_of_customers;

SELECT customer_id, COUNT(*) AS order_count
FROM order_table
GROUP BY customer_id
HAVING order_count > 1;

SELECT * FROM products;

SELECT first_name, last_name FROM customers WHERE last_name LIKE'D%';

SELECT MAX(PRICE) FROM products;

SELECT COUNT(product_id) AS total_number_of_products FROM products ;

SELECT * FROM products WHERE price < 40;

SELECT p.product_id, p.product_name 
FROM products p
LEFT JOIN order_items o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

--  Order Queries

SELECT * FROM order_table;

SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id
ORDER BY total_items DESC LIMIT 1;

SELECT COUNT(order_id) AS total_items_ordered FROM order_items;

SELECT * FROM order_table WHERE order_date BETWEEN '2023-05-02' AND '2023-05-12';

SELECT * FROM order_table WHERE order_id = 9;

-- Order Item Queries
SELECT o.order_id, p.product_name, p.price
FROM order_items o
JOIN products p on o.product_id = p.product_id
ORDER BY p.price DESC;

SELECT SUM(o.quantity) AS total_quantity_sold
FROM order_items o
JOIN products p ON o.product_id = p.product_id
WHERE product_name = 'Product D';

SELECT p.product_name, COUNT(oi.order_id) AS times_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

SELECT product_id, SUM(quantity) AS total_quantity_ordered
FROM order_items
GROUP BY product_id
HAVING total_quantity_ordered >5;

SELECT o.order_id, o.order_date
FROM order_table o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id = 3;

--  Revenue Queries
SELECT p.product_name, SUM(oi.quantity * p.price) AS total_revenue 
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY product_name;

SELECT o.order_date, p.product_name, SUM(oi.quantity * p.price) AS daily_revenue
FROM order_table o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_date, p.product_name
ORDER BY daily_revenue DESC
LIMIT 1;

SELECT AVG(total_revenue) AS average_revenue_per_order
FROM (
    SELECT o.order_id, SUM(oi.quantity * p.price) AS total_revenue
    FROM order_table o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS order_revenue;

SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN order_table o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 1;

-- Aggregation and Grouping Queries
SELECT * FROM order_items; 
SELECT order_id, SUM(quantity) AS total_items_sold FROM order_items GROUP BY  order_id;

SELECT AVG(price) AS average_price_ FROM products;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN order_items oi ON oi.order_id = oi.order_id
JOIN order_table o ON c.customer_id =  o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT p.product_id, p.product_name, MAX(oi.quantity) AS max_quantity_ordered
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT CASE
WHEN price BETWEEN 0 AND 10 THEN '0-10'
WHEN price BETWEEN 11 AND 20 THEN '11-20'
WHEN price BETWEEN 21 AND 30 THEN '21-30'
WHEN price BETWEEN 31 AND 40 THEN '31-40'
WHEN price BETWEEN 41 AND 50 THEN '41-50'
ELSE 'ABOVE 50'
END AS price_range,
COUNT(*) AS product_count
FROM products
GROUP BY price_range;

--  Advanced Queries
SELECT c.customer_id, c.first_name, c.last_name, MIN(o.order_date) AS first_order_date
FROM customers c
JOIN order_table o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name, p.product_name, p.price
FROM customers c
JOIN order_table o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.price > 50;

SELECT p.product_id, p.product_name, COUNT(oi.order_id) AS total_orders
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(oi.order_id) > 1;

SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN order_table o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT * FROM order_table WHERE order_date >= CURDATE() - INTERVAL 30 DAY;
