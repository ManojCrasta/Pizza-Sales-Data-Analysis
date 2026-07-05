CREATE TABLE pizza_sales (
    pizza_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    pizza_name_id VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    pizza_size VARCHAR(5) NOT NULL,
    pizza_category VARCHAR(50) NOT NULL,
    pizza_ingredients VARCHAR(200) NOT NULL,
    pizza_name VARCHAR(100) NOT NULL
);

COPY pizza_sales
FROM 'D:/Data Analytics Projects/Pizza Analysis/pizza_sales.csv'
DELIMITER ','
CSV HEADER;

select * from pizza_sales

--Total Revenue
select SUM(total_price) as total_revenue
from pizza_sales;

-- Average Order Value
select SUM(total_price)/Count(distinct(order_id)) as average_order_value
from pizza_sales;

--Total Pizza Sold
select Count(pizza_id) as total_pizza_sold
from pizza_sales;

--Total Orders Placed
select count(distinct(order_id)) as total_orders
from pizza_sales;

--Average Pizzas sold per order
select Cast(Cast(SUM(quantity) as decimal (10,2))/count(distinct(order_id)) as Decimal (10,2)) as average_pizza_per_order
from pizza_sales;


--Charts Requirement
--Daily trend for order
Select TO_CHAR(order_date, 'Day') as order_day, Count(distinct(order_id)) as Total_Orders
from pizza_sales
group by TO_CHAR(order_date, 'Day')
order by MIN(order_date)

--Hourly trend
Select To_Char(order_time, 'HH24:00') as hour_slot,
Count(distinct(order_id)) as Total_Order
from pizza_sales
group by To_Char(order_time, 'HH24:00')
order by MIN(order_time)

-- Percentage of Sales by pizza category
SELECT 
    pizza_category,
    SUM(total_price) AS revenue,
    Round(SUM(total_price)*100 / SUM(SUM(total_price)) over(),
	2) as PCT
FROM pizza_sales
where TO_CHAR(order_date, 'MM') = '02'
GROUP BY pizza_category
ORDER BY revenue DESC;

-- For all above queries if we want to get the values for a partcular month we can add Where clause
-- TO_CHAR(order_date, 'MM') = '01'

-- Percentage of Sales by pizza size
SELECT 
    pizza_size,
    SUM(total_price) AS revenue,
    Round(SUM(total_price)*100 / SUM(SUM(total_price)) over(),
	2) as PCT
FROM pizza_sales
where TO_CHAR(order_date, 'MM') = '02'
GROUP BY pizza_size
ORDER BY revenue DESC;


-- total pizza sold by pizza category
Select 
	pizza_category,
	SUM(quantity) as pizza_sold
from pizza_sales
group by pizza_category


-- Top 5 Best pizza sold
Select 
	pizza_name as Pizza_Name,
	count(quantity) as Pizza_Sold
from pizza_sales
group by pizza_name
order by Pizza_Sold desc
limit 5

-- Top 5 worst pizza sold
Select 
	pizza_name as Pizza_Name,
	count(quantity) as Pizza_Sold
from pizza_sales
group by pizza_name
order by Pizza_Sold asc
limit 5