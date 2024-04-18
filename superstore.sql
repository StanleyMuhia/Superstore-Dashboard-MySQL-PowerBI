SELECT *
FROM superstore

-- Set datestyle for the current session
SET datestyle = 'ISO, MDY'

ALTER TABLE superstore
ALTER COLUMN order_date TYPE date USING order_date::date,
ALTER COLUMN ship_date TYPE date USING order_date::date

-- total profit
select concat(round(sum(profit),2), ' million') as total_profit
from superstore

SELECT ship_mode, ROUND(SUM(sales),2) AS total_sales
FROM superstore
GROUP BY ship_mode
ORDER BY 2 DESC

SELECT segment, ROUND(SUM(sales),2) AS total_sales,
     ROUND(SUM(profit),2) AS total_profit
FROM superstore
GROUP BY segment
ORDER BY 2 DESC

select count(product_id) as no_discount
from superstore
where discount = 0

select cust_name, round(sum(sales),2) as sales_total
from superstore
group by cust_name
order by 2 desc
limit 10

with cte1 as (
	select cust_name, segment, round(sum(sales),2) as sales_total,
rank() over(partition by segment order by round(sum(sales),2) desc) as rnk
from superstore
group by cust_name, segment
)
select cust_name, segment, sales_total
from cte1
where rnk < 4

select  extract(year from order_date) as order_year, round(sum(sales),2) as sales_total, round(sum(profit),2) as profit_total
from superstore
group by extract(year from order_date)
order by 1 

select cust_name, count(product_id) as no_of_products, round(sum(sales),2) as total_sales
from superstore
group by cust_name
order by 3 desc
