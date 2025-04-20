--DATABASE EXPLORATION 
--explore all tables in a databse
select * from INFORMATION_SCHEMA.tables

--explore all columns
select * from INFORMATION_SCHEMA.COLUMNS

--DIMENSION EXPLORATION
select distinct country from gold.dim_customers

select 
distinct
category,subcategory,product_name
from gold.dim_products
order by 1,2,3

--DATE EXPLORATION
--find min and max date
select 
min(order_date),
max(order_date),
datediff(month,min(order_date),max(order_date)) as range
from gold.fact_sales
--find the youngest and oldest customer
select 
min(birthdate),
datediff(year,min(birthdate),getdate()),
max(birthdate),
datediff(year,max(birthdate),getdate())
from gold.dim_customers

--MEASURE EXPLORATION
--1)find the total sales
select sum(sales_amount) from gold.fact_sales
--2)how many items are sold
select sum(quantity) from gold.fact_sales
--3)find the average selling price
select avg(price) from gold.fact_sales
--4)total no of orders
select count(distinct order_number) from gold.fact_sales
--5)total no of products
select count(distinct product_key) from gold.dim_products
--6)total no of customers
select count(distinct customer_key) from gold.dim_customers
--7)total no od customers placed an order
select count(distinct customer_key) from gold.fact_sales

--report that shows all key metrics of our business
select 'Total Sales' as measure_name,sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Total Quantity' as measure_name,sum(quantity) as measure_value from gold.fact_sales
union all
select 'Average Price' as measure_name,avg(price) as measure_value from gold.fact_sales
union all
select 'Total Orders' as measure_name,count(distinct order_number) as measure_value from gold.fact_sales
union all
select 'Total Customers' as measure_name,count(distinct customer_key) as measure_value from gold.dim_customers
union all
select 'Total Products' as measure_name,count(distinct product_key) as measure_value from gold.dim_products
union all 
select 'Total Customers Placed Order' as measure_name,
count(distinct customer_key) as measure_value from gold.fact_sales

--MAGNITUDE ANALYSIS
--total number od customers by country
select 
country,count(distinct customer_key) as cnt 
from gold.dim_customers
group by country
order by cnt desc

--total customers by gender
select 
gender,count(distinct customer_key) as cnt 
from gold.dim_customers
group by gender
order by cnt desc

--total products by category
select 
category,count(distinct product_key) as cnt 
from gold.dim_products
group by category
order by cnt desc

--average cost in each category
select 
category,avg(cost) as avg_cost 
from gold.dim_products
group by category
order by avg_cost desc

--total revenue generated for each category
select 
dp.category,
sum(fs.sales_amount) as revenue
from gold.dim_products as dp
right join gold.fact_sales fs
on dp.product_key=fs.product_key
group by dp.category
order by revenue desc

--total revenue generated for each customer
select 
dp.customer_key,dp.first_name,dp.last_name,
sum(fs.sales_amount) as revenue
from gold.dim_customers as dp
right join gold.fact_sales fs
on dp.customer_key=fs.customer_key
group by dp.customer_key,dp.first_name,dp.last_name 
order by revenue desc

--distribution for sold items across countries
select 
dp.country,
sum(fs.quantity) as sold_items
from gold.dim_customers as dp
right join gold.fact_sales fs
on dp.customer_key=fs.customer_key
group by dp.country
order by sold_items desc

--which 5 products generate high revenue
select top 5
p.product_name,
sum(sales_amount) as revenue
from gold.fact_sales as s
join gold.dim_products as p
on p.product_key=s.product_key
group by p.product_name
order by revenue desc

--bottom 5 products in terms of revenue
select top 5
p.product_name,
sum(sales_amount) as revenue
from gold.fact_sales as s
join gold.dim_products as p
on p.product_key=s.product_key
group by p.product_name
order by revenue asc

--using rank
select 
sub.product_name,sub.revenue
from (
select 
p.product_name,
sum(sales_amount) as revenue,
row_number() over(order by sum(sales_amount) desc) as rank
from gold.fact_sales as s
left join gold.dim_products as p
on p.product_key=s.product_key
group by p.product_name
) as sub
where sub.rank<=5


select 
sub.product_name,sub.revenue
from (
select 
p.product_name,
sum(sales_amount) as revenue,
row_number() over(order by sum(sales_amount) asc) as rank
from gold.fact_sales as s
left join gold.dim_products as p
on p.product_key=s.product_key
group by p.product_name
) as sub
where sub.rank<=5
