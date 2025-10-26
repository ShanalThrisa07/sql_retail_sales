--SQL Retail Sales Analysis
CREATE DATABASE sql_pro;

--Create table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales
             (
             transactions_id INT PRIMARY KEY,
             sales_date DATE,
             sale_time TIME ,
             customer_id INT,
             gender VARCHAR(15),
             age INT,
             category VARCHAR(15),
             quantity INT,
             price_per_unit FLOAT,
             cogs FLOAT,
             total_sale FLOAT
			 );

SELECT * FROM sales;

SELECT COUNT(*) FROM sales;

--
SELECT * FROM sales
WHERE transactions_id IS NULL;

--
SELECT * FROM sales
WHERE 
sales_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantity IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL ;

--Data Cleaning
DELETE FROM sales
WHERE 
sales_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantity IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL ;

--Data Exploration

--how many sales we have
SELECT COUNT(*) AS total_sales FROM sales;

--how many customer do we have
SELECT COUNT(DISTINCT customer_id) as total_sales FROM sales;

SELECT DISTINCT category as total_sales FROM sales;

--Data Analysis

--write a query to retrive all columns for sales made on '2022-11-05'
SELECT * FROM sales
WHERE sales_date = '2022-11-05';

--write a query to retrive all transaction where the category is clothing and clothing sold is more than 4 in the month of nov-2022
SELECT * FROM sales
WHERE category = 'Clothing' AND quantity >= 4 AND TO_CHAR(sales_date, 'yyyy-MM') = '2022-11';

--write a query to calculate total sales for each category
SELECT  category , SUM(total_sale) AS net_sale, COUNT(*) AS total_orders FROM sales
GROUP BY 1;

--write a query to find the average age of customer who purchase items from the beauty category
SELECT AVG(age) as avg_age FROM sales
WHERE category ='Beauty' ;

--Write a query to find all transactions where total_sale is greater than 1000
SELECT * FROM sales
WHERE total_sale > 1000
 
--write a query to find the total number of transcations made by each gender in each category
SELECT category , gender , count(*) as total_trans FROM sales 
GROUP by category , gender 
ORDER BY 1;

--write a sql query to calculate the average sale for each month. find out best selling month in each year
SELECT * FROM 
(
SELECT
EXTRACT(YEAR FROM sales_date) as year,
EXTRACT(MONTH FROM sales_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC)
FROM sales
GROUP BY 1,2) AS t1
WHERE RANK = 1 ;

--write a query to find the top 5 customers based on the heighest total sales
SELECT customer_id, SUM(total_sale) as total_sales FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--write a query to find the number of unique customers who purchased items from each category.
SELECT category, count(DISTINCT customer_id) uni_customers FROM sales
GROUP BY 1 ;

--write  a query to create each shift and number of orders (Example morning <= 12, AAternoon Between 12 & 17, Evening >= 17)
WITH hourly_sales AS
(
SELECT *, 
    CASE 
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
FROM sales)
SELECT shift, COUNT(*) AS total_orders FROM hourly_sales
GROUP BY shift;

--END



