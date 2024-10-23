CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2, 1)
);

/*Feature Engineering */

SELECT time,
(CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" 
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
) AS time_of_day
FROM salesdatawalmart.sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" 
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);

/*day_name*/

select date,
dayname(date) AS day_name
from sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = dayname(date);

/* month_name*/

select date,
monthname(date) AS day_name
from sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

/* EXPLORATORY DATA ANALYSIS(EDA) */
/*-----------------------------------------------Generic-------------------------------------------------------------------------------*/

/* How many unique cities does data have? */

select distinct city
from sales;

/* Which city does each branch correspond to */

select distinct city,
branch
from sales;

/*--------------------------------------------Product----------------------------------------------------------------------------------*/

/*How many unique product lines does the data have*/

select count(distinct product_line)
from sales;

/*what is most common payment method*/

select payment_method,
count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

/*what is most selling product line*/

select product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

/*what is total revenue by month */

select month_name as month, sum(total) AS total_revenue
from sales
group by month_name
order by total_revenue desc;

/*What month has the largest COGS*/

select month_name as month, sum(cogs) AS total_cogs
from sales
group by month_name
order by total_cogs desc;

/*what product line had the largest revenue*/

select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

/*what city had the largest revenue*/

select branch, city, sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

/*what product line had the largest VAT*/

select product_line, AVG(VAT) as avg_VAT
from sales
group by product_line
order by avg_VAT desc;

/*Which branch sold more products than average products sold*/

select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select AVG(quantity) from sales);

/*what is most common product line by gender*/

select product_line, gender, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

/*What is average rating of each product line*/

select product_line, Round(AVG(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

/*Fetch each product line and add column saying 'Good" if greater than average sales or else it's 'bad' */

select avg(quantity) as avg_quantity
from sales;

select product_line, avg(quantity) as avg_quantity
from sales
group by product_line;

select product_line, avg(quantity),
(case
when avg(quantity) > 5.4995 then "Good"
else "Bad"
End) AS remark
from sales
group by product_line;

/*------------------------------------Customer--------------------------------------------------------------------------------*/

/*How many unique customer types does the data have */

select distinct(customer_type) 
from sales;

/*How many unique payment methods does data have */

select distinct(payment_method) 
from sales;

/*what is the most common customer type */

select customer_type, count(*) as count
from sales
group by customer_type
order by count desc;

/*Which customer type buys the most */

select customer_type, Round(sum(total), 2) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

/*What is gender of most of the customers */

select gender, count(*) as gender_count
from sales
group by gender
order by gender_count desc;

/* What is gender distribution by branch */

select branch, gender, count(*) as gender_count
from sales
group by branch, gender
order by gender_count desc;

/*which time of day do customers give the most ratings */

select time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

/*which time of day do customers give the most ratings per branch */

select branch, time_of_day, avg(rating) as avg_rating
from sales
group by branch, time_of_day
order by avg_rating desc;

/*which day of the week has the best avg rating */

select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

/*Number of sales made in each time of the day per weekday */

SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

/*which customer type brings the most revenue*/

select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

/* which city has largest VAT percent */

select city, round(avg(VAT), 2) as avg_VAT
from sales
group by city
order by avg_VAT desc;

/* which customer type pays the most in VAT */

select customer_type, round(avg(VAT), 2) as avg_VAT
from sales
group by customer_type
order by avg_VAT desc;

