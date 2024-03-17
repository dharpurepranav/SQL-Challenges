----------- Questions -------------

-- 1. How many transactions were completed during each marketing campaign?
SELECT m.campaign_name, COUNT(t.transaction_id) AS total_transactions 
FROM marketing_campaigns m
JOIN transactions t ON t.purchase_date BETWEEN m.start_date AND m.end_date
GROUP BY campaign_name;
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Which product had the highest sales quantity?
SELECT s.product_name, SUM(t.quantity) AS sales_quantity
FROM sustainable_clothing s
JOIN transactions t ON s.product_id = t.product_id
GROUP BY product_name
ORDER BY sales_quantity DESC LIMIT 1;
---------------------------------------------------------------------------------------------------------------------------------------------
-- 3. What is the total revenue generated from each marketing campaign?
SELECT campaign_name, CONCAT('$','',ROUND(SUM(t.quantity*s.price))) AS "revenue of each compaign"
FROM sustainable_clothing s
INNER JOIN transactions t ON t.product_id=c.product_id
JOIN marketing_campaigns m ON t.purchase_date BETWEEN m.start_date AND m.end_date
GROUP BY campaign_name
ORDER BY "revenue of each compaign" DESC;
---------------------------------------------------------------------------------------------------------------------------------------------
-- 4. What is the top-selling product category based on the total revenue generated?
SELECT category, CONCAT('$','',ROUND(SUM(t.quantity*s.price))) AS "revenue of each category"
FROM sustainable_clothing s
LEFT JOIN transactions t ON t.product_id = s.product_id
GROUP BY category
ORDER BY "revenue of each category" DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Which products had a higher quantity sold compared to the average quantity sold?
SELECT product_name, SUM(quantity) AS "quantity sold", AVG(quantity) AS "avg quantity"
FROM sustainable_clothing c
LEFT JOIN transactions t ON t.product_id=c.product_id
GROUP BY product_name
HAVING SUM(quantity) > AVG(quantity);
------------------------------------------------------------------------------------------------------------------------------------------
-- 6. What is the average revenue generated per day during the marketing campaigns?
SELECT purchase_date, ROUND(AVG(c.price*t.quantity),2) AS "average revenue generated"
FROM transactions t
JOIN sustainable_clothing c ON t.product_id=c.product_id
JOIN marketing_campaigns m ON t.purchase_date BETWEEN m.start_date AND m.end_date
GROUP BY purchase_date
ORDER BY "average revenue generated" DESC;
--------------------------------------------------------------------------------------------------------------------------------------------
-- 7. What is the percentage contribution of each product to the total revenue?
WITH cte_total_revenue AS (
SELECT SUM(t.quantity*c.price) AS total_revenue
FROM sustainable_clothing c
JOIN transactions t ON t.product_id=c.product_id),

cte_total_product_revenue AS (select product_name,
SUM(t.quantity*c.price) AS total_product_revenue
FROM sustainable_clothing c
JOIN transactions t ON t.product_id=c.product_id 
GROUP BY product_name)

SELECT product_name,
ROUND((total_product_revenue*100)/total_revenue) AS "% of revenue contribution by each product"
FROM cte_total_product_revenue, cte_total_revenue 
ORDER BY "% of revenue contribution by each product" DESC;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 8. Compare the average quantity sold during marketing campaigns to outside the marketing campaigns
WITH campaign_quantity AS (SELECT AVG(quantity) AS average_campaign_quantity_sold
FROM transactions t
JOIN marketing_campaigns m on t.purchase_date BETWEEN m.start_date AND m.end_date),

total_quantity AS (
SELECT AVG(quantity) AS average_quantity_sold
FROM transactions)

SELECT average_quantity_sold , average_campaign_quantity_sold,
(average_quantity_sold - average_campaign_quantity_sold) AS Difference_in_quantity_sold_during_and_outside_campaign
FROM total_quantity, campaign_quantity;
---------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Compare the revenue generated by products inside the marketing campaigns to outside the campaigns
WITH campaign_revenue AS (SELECT SUM(t.quantity*s.price) AS campaign_revenue_generated
FROM transactions t
JOIN sustainable_clothing s ON t.product_id=s.product_id
JOIN marketing_campaigns m ON t.purchase_date BETWEEN m.start_date AND m.end_date),

total_revenue AS (
SELECT SUM(t.quantity*s.price) AS total_revenue_generated
FROM transactions t
JOIN sustainable_clothing s ON t.product_id=s.product_id)

SELECT ROUND(total_revenue_generated,2) AS revenue_inside, ROUND(campaign_revenue_generated,2) AS revenue_outside,
ROUND((total_revenue_generated - campaign_revenue_generated),2) AS Difference_in_revenue
FROM total_revenue, campaign_revenue;
--------------------------------------------------------------------------------------------------------------------------------------------
-- 10. Rank the products by their average daily quantity sold
WITH cte_avgq AS (SELECT product_name, AVG(quantity) AS average_quantity_sold
FROM transactions t
JOIN sustainable_clothing c ON c.product_id=t.product_id
GROUP BY product_name)

SELECT product_name, ROUND(average_quantity_sold,2) AS avg_daily_quantity_sold,
DENSE_RANK() OVER(ORDER BY average_quantity_sold) AS rank_of_products_by_average_quantity_sold
FROM cte_avgq;
-------------------------------------------------------------------------------------------------------------------------------------