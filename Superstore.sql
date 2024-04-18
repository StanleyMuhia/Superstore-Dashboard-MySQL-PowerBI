SELECT *
FROM store;

DESCRIBE store;

SET sql_safe_updates = 0;

UPDATE store
SET order_date = str_to_date(order_date, "%Y-%m/%d");

UPDATE store
SET ship_date = str_to_date(ship_date, '%Y-%m-%d');

ALTER TABLE store
ADD COLUMN lead_days INT;

UPDATE store
SET lead_days = datediff(SHIP_DATE, ORDER_DATE);

SELECT *
FROM store
WHERE lead_days = 0;

ALTER TABLE store
ADD COLUMN year INT;

UPDATE store
SET year = YEAR(order_date);

SELECT min(year),
	   max(year)
FROM store;

-- 1. What is the total sales between 2014 and 2017?
SELECT 
    year, SUM(sales) AS Total_sales
FROM
    store
GROUP BY year
ORDER BY year;

-- 2. Which states has the most sales?
SELECT 
    state, SUM(sales) AS Total_sales
FROM
    store
GROUP BY state;

-- 3. Which category has the most sales?
SELECT 
    category, SUM(sales) AS Total_sales
FROM
    store
GROUP BY category
ORDER BY SUM(sales);

-- 4. What is the average lead time for each shipping mode?
SELECT 
    ship_mode, ROUND(AVG(lead_days), 0) AS avg_lead
FROM
    store
GROUP BY ship_mode
ORDER BY AVG(lead_days);

-- 5. Which category has the best profit margin per product after discount?
SELECT 
    category, AVG(profit_margin) AS avg_profit_margin
FROM
    (SELECT 
        product_id,
            category,
            SUM(profit) / SUM(quantity) AS profit_margin
    FROM
        store
    GROUP BY product_id , category) AS subquery
GROUP BY category
ORDER BY avg_profit_margin DESC;

-- 6. What is the total profit recorded?
SELECT ROUND(sum(profit), 2) AS total_profit
FROM store;

-- 7. Which shipping mode enjoys most discount?
SELECT ship_mode, SUM(discount)
FROM store
GROUP BY ship_mode;

-- 8. Identify the top 3 customers in each category with most purchases
WITH cte1 AS (
	SELECT customer_id, customer_name, segment, ROUND(SUM(sales),2) AS sales_total,
RANK() OVER(PARTITION BY segment ORDER BY ROUND(SUM(sales),2) DESC) AS rnk
FROM store
GROUP BY customer_id, customer_name, segment
)
SELECT customer_id, customer_name, segment, sales_total
FROM cte1
WHERE rnk < 4;

-- 9. Which customer segments has most sales?
SELECT 
    segment, SUM(sales) AS Total_sales, SUM(profit) AS Total_profit
FROM
    store
GROUP BY segment
ORDER BY SUM(sales);

-- 10. Which products are commonly purchased together?
SELECT od1.sub_category AS subcategory1,
       od2.sub_category AS subcategory2,
       COUNT(*) AS frequency
FROM store od1
JOIN store od2 ON od1.order_id = od2.order_id AND od1.product_id != od2.product_id
WHERE od1.sub_category < od2.sub_category
GROUP BY subcategory1, subcategory2
ORDER BY frequency DESC
LIMIT 20;

-- 11. What is the total number of orders made?
SELECT COUNT(distinct order_id) AS orders_count
FROM store;

-- 12. Does mode of shipment have any significance in terms of sales?
SELECT ship_mode, year, SUM(sales) AS Total_sales
FROM store
GROUP BY ship_mode, year;

-- 13. What is the total profit by each category?
SELECT category, SUM(profit) AS total_profit
FROM store
GROUP BY category;
