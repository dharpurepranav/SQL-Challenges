-- 1]Which product has the highest price? Only return a single row.
SELECT product_name, price FROM products
WHERE price = (SELECT MAX(price) from products);
 -----------------------------------------------------------------------------------------------------------------------------
 -- 2]Which customer has made the most orders?
SELECT customers.first_name, customers.last_name, COUNT(orders.order_id) AS order_count FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.first_name, customers.last_name
ORDER BY order_count DESC
LIMIT 4;
-----------------------------------------------------------------------------------------------------------------------------------
-- 3]What’s the total revenue per product?
SELECT product_name, SUM(products.price * order_items.quantity) AS total_revenue FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY product_name
ORDER BY total_revenue ASC;
-----------------------------------------------------------------------------------------------------------------------------------------
-- 4]Find the day with the highest revenue.
SELECT  ord.order_date,  SUM(pro.price * items.quantity) AS total_revenue FROM products pro
JOIN order_items items ON pro.product_id = items.product_id
JOIN orders ord ON items.order_id = ord.order_id
GROUP BY ord.order_date
ORDER BY total_revenue DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------------
-- 5]Find the first order (by date) for each customer.
SELECT  cus.first_name, cus.last_name, min(ord.order_date) first_order FROM customers cus
JOIN orders ord ON cus.customer_id = ord.customer_id
GROUP  BY cus.first_name, cus.last_name, ord.order_date
ORDER BY first_order;
-----------------------------------------------------------------------------------------------------------------------------
-- 6]Find the top 3 customers who have ordered the most distinct products
SELECT cus.first_name, cus.last_name, COUNT(DISTINCT product_name) AS unique_product, product_name FROM customers cus
JOIN orders ON cus.customer_id = orders.customer_id
JOIN order_items items ON orders.order_id = items.order_id
JOIN products ON products.product_id = items.product_id
GROUP BY cus.first_name, cus.last_name
ORDER BY unique_product DESC LIMIT 3;
-----------------------------------------------------------------------------------------------------------------------------------
-- 7]Which product has been bought the least in terms of quantity?
SELECT products.product_id, SUM(order_items.quantity) as quantity FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id
ORDER BY quantity LIMIT 6;
----------------------------------------------------------------------------------------------------------------------------------------
-- 8]What is the median order total?
SELECT ROUND(AVG(total),2) AS median_order_total FROM(
SELECT ord.order_id, SUM(prod.price * items.quantity) AS total FROM orders ord
JOIN order_items items ON ord.order_id = items.order_id
JOIN products prod ON items.product_id = prod.product_id
GROUP BY ord.order_id) result
---------------------------------------------------------------------------------------------------------------------------------------------
-- 9]For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
SELECT items.order_id, SUM(prod.price * items.quantity) AS revenue,
CASE
   WHEN SUM(prod.price * items.quantity) > 300 THEN 'Expensive'
   WHEN SUM(prod.price * items.quantity) > 100 THEN 'Affordable'
   ELSE 'Cheap'
END AS price_bucket
FROM products prod
JOIN order_items items ON items.product_id = prod.product_id
GROUP BY items.order_id;
--------------------------------------------------------------------------------------------------------------------------------------------
-- 10]Find customers who have ordered the product with the highest price.
SELECT CONCAT(cus.first_name, ' ', cus.last_name) AS full_name, prod.product_name, prod.price FROM customers cus 
JOIN orders ord ON cus.customer_id = ord.customer_id
JOIN order_items items ON items.order_id = ord.order_id
JOIN products prod ON items.product_id = prod.product_id
WHERE prod.price = (SELECT MAX(prod.price) FROM products)
ORDER BY prod.price DESC LIMIT 3;
 
