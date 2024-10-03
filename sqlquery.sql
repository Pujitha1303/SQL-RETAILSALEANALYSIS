SELECT *FROM RETAIL_SALES;

SELECT 
   COUNT(*) 
FROM RETAIL_SALES;

SELECT * FROM RETAIL_SALES 
WHERE customer_id is null;

DELETE FROM RETAIL_SALES 
WHERE transactions_id is  null
OR 
sale_date is null
or
sale_time is null
or
gender is null
or 
	category is null
or
quantity is null
or 
	cogs is null
or 
	total_sale is null 
or price_per_unit is null

-- DATA EXPLORATION 

-- How many sales are there ?
SELECT count(*) as total_sale from retail_sales;

-- how many unique customers ? 
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

-- how many unique categories we have ?
SELECT DISTINCT CATEGORY FROM retail_sales;

--- DATA ANALYSIS

-- 1. Write a sql query to retrive all the columns for sales made on '2022-11-05'
SELECT * from retail_sales 
where sale_date='2022-11-05';


--2. Write a sql query to retrive all the transactions where the country is 'clothing' and the quantity sold is more than 4 in the month of nov-2022
SELECT * from 
	retail_sales 
where category='Clothing' AND quantity >=4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- calculate the total-sale for each category.
SELECT category , sum(total_sale) as cateorysumsale,
	sum(quantity) as quantitysold,
	count(transactions_id) as ordercount
	from retail_sales 
    GROUP BY category

-- average age of customers who purchased items from 'Beauty' category

SELECT AVG(age) as averageage from retail_sales where category='Beauty';

-- all transactions where total-sale is greter than 1000.

SELECT * from retail_sales where total_sale>1000

-- find the total number of transactions(transaction_id) made by each gender in each category.

SELECT category, gender ,
	COUNT(*) as totaltransactions
 FROM retail_sales
 GROUP BY category,
          gender 
ORDER BY 1 ;


-- write a sql query to calcualte the average sale for each month. Find out the best selling month in each year 
SELECT * from 
(SELECT 
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rankorder
	FROM RETAIL_SALES
	GROUP BY YEAR, MONTH ) as t1
	where rankorder=1;

-- write a sql query to find the top 5 customers based on the highest total sales 
SELECT customer_id, sum(total_sale) from retail_sales
	group by customer_id 
	order by 2 desc 
	limit 5 ;

-- write a sql query to find numbre of unique of customers who purchased items for each category

SELECT category, count(distinct customer_id) 
 from retail_sales 
group by 1;

-- write a sql query to create each shift and number of orders(Example Morning <=12, Afternoon Between 12&17 , Eveneing>17)
-- here as we dont have a column of shifts , we need to create it based on the hours and then calculate the number of orders based on the shift category

WITH hourly_sale as 
(SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
	FROM retail_sales)
	SELECT shift, count(*) from hourly_sale group by shift;

SELECT shift, count(*) from 
(SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
	FROM retail_sales) as t1
  GROUP BY shift;

