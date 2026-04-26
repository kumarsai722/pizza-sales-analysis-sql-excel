select * from pizza_sales;

copy pizza_sales_db
FROM 'C:\pg_admin_folder\pizza_sales_csv.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE pizza_sales_db (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(100),
    order_date DATE,
    order_time TIME,
	quantity INT,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
	pizza_name varchar(250)
);

drop table pizza_sales_db ;

select * from pizza_sales_db;

--TOTAL SALES
select sum(total_price) as total_revenue from pizza_sales_db;

--TOTAL ORDERS
select count(distinct order_id) total_orders from pizza_sales_db;

--AVERAGE ORDER VALUE

select round(sum(total_price)/count(distinct order_id),2) from pizza_sales_db;



--TOTAL PIZZAS SOLD

select sum(quantity) as total_pizzas from pizza_sales_db;

--AVERAGE PIZZAS PER ORDER

select count(distinct pizza_id)/count(distinct order_id) 
as average_pizzas_per_orders 
from pizza_sales_db;

select cast(cast(sum(quantity) as decimal(10,2))/ cast(count(distinct order_id) as decimal(10,2))as decimal(10,2)) 
as average_pizzas_per_orders 
from pizza_sales_db;

-------------------------------------------------------
-------------------------------------------------------
--1) Daily Trend for total_orders

select to_char(order_date,'Day')as weekday,count(distinct order_id) from 
pizza_sales_db group by weekday
order by weekday  asc; 

SELECT TRIM(TO_CHAR(order_date, 'Day')) AS weekday,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_db
GROUP BY weekday, EXTRACT(DOW FROM order_date)
ORDER BY EXTRACT(DOW FROM order_date);

--2)HOURLY TREND

select to_char(order_time,'HH24')as time,count(distinct order_id) from 
pizza_sales_db group by time
order by time;


SELECT EXTRACT(HOUR FROM order_time) AS hour,
       COUNT(DISTINCT order_id)
FROM pizza_sales_db
GROUP BY hour
ORDER BY hour;

select extract(HOUR FROM order_time) as hour,
count(distinct order_id) from pizza_sales_db
group by hour
order by hour;

select to_char(order_time,'HH12') as time,
count(distinct order_id) from pizza_sales_db
group by  time 
order by time; 

_______________________________

--3)PERCENTAGE OF SALES BY PIZZA CATEGORY
select * from pizza_sales_db 

select distinct pizza_category from pizza_sales_db

select  distinct pizza_category,
(sum(total_price)*100/ (select sum(total_price) from pizza_sales_db))::numeric(10,2) as perc_As_sales
from pizza_sales_db
where extract(month from order_date)=1
group by pizza_category
order by  perc_As_sales;

select  distinct pizza_category,
(sum(total_price)*100/ (select sum(total_price) from pizza_sales_db))::numeric(10,2) as perc_As_sales
from pizza_sales_db
where extract(year from order_date)=2015
group by pizza_category
order by  perc_As_sales;

select  distinct order_date from pizza_sales_db

_______________________________________________________

--4)PERCENTAGE OF SALES BY PIZZA SIZE

select * from pizza_sales_db

select pizza_size,sum(total_price),
(sum(total_price)*100/(select sum(total_price) from pizza_sales_db))::numeric(10,2)
from pizza_sales_db
where extract(quarter from order_date)=1
group by  pizza_size

----------------------------------------------
--5)TOTAL PIZZAS SOLD BY CATEGORY...

select pizza_category,sum(total_price) from
pizza_sales_db
group by pizza_category

-----------------------------------------
--6)TOP 5 BEST pizza selling BY TOTAL PIZZAS SOLD

select * from pizza_sales_db;

select  distinct pizza_name,sum(quantity) total_pizzas
from pizza_sales_db
group by pizza_name
order by  total_pizzas desc
limit 5;

---------------------------------
-- 7) BOOTOM 5 WORST SELLING PIZZAS

select  distinct pizza_name,sum(quantity) total_pizzas
from pizza_sales_db

group by pizza_name
order by  total_pizzas asc
limit 5;
