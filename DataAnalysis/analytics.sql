--date is day level aggregation we need month or year 
--CHANGE OVER TIME TRENDS
--group by year
select 
year(order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date)

--group by month
select 
month(order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by month(order_date)
order by month(order_date)

--group by year and month
select 
year(order_date),month(order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)

--instead of 2 functions year and month use datetrunc
select 
datetrunc(year,order_date),
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
order by datetrunc(year,order_date)

--CUMMULATIVE ANALYSIS
--calculate total sales per month and running total sales
select
order_month,
total_sales,
--window function for running total
sum(total_sales) over(order by order_month) as running_total_sales,
avg_price,
avg(avg_price) over(order by order_month) as running_avg_price
from (
select
datetrunc(year,order_date) as order_month,
sum(sales_amount) as total_sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
) as sub

--PERFOMANCE ANALYSIS
--analyse the yearly perfomance with products by comparing
--each each prod sale to average sale and prev year sale
with yearly_product_sales as (
select 
datetrunc(year,f.order_date) as order_year,
d.product_name,
sum(f.sales_amount) as current_sales
from gold.fact_sales as f
left join  gold.dim_products as d
on f.product_key=d.product_key
where f.order_date is not null
group by d.product_name,datetrunc(year,f.order_date)
)
select 
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales-avg(current_sales) over(partition by product_name) as diff_avg,
case 
  when current_sales-avg(current_sales) over(partition by product_name)>0 then 'Above avg'
  when current_sales-avg(current_sales) over(partition by product_name)<0 then 'Below avg'
  else 'avg' 
end as avg_diff,
--year over year analysis
lag(current_sales) over(partition by product_name order by order_year) as previous_sales,
current_sales-lag(current_sales) over(partition by product_name order by order_year) as diff_py,
case 
   when lag(current_sales) over(partition by product_name order by order_year)>0 then 'incrrease'
   when lag(current_sales) over(partition by product_name order by order_year)<0 then 'decrease'
   else 'no change'
end as prev_diff
from yearly_product_sales
order by product_name,order_year

--PART TO WHOLE ANALYSIS (proportion)
with sales_by_category as (
select 
d.category,
sum(f.sales_amount) as total_sales
from gold.fact_sales as f
left join gold.dim_products as d
on d.product_key=f.product_key
group by d.category
)
select 
category,
total_sales,
sum(total_sales) over() as total,
concat(round(cast(total_sales as float)/sum(total_sales) over()*100,2),'%') as pct
from sales_by_category
order by total_sales desc

--DATA SEGMENTATION
--segment products into cost ranges and 
--count how many products fall into each segment
with product_segments as (
select 
product_key,
product_name,
cost,
case 
   when cost<100 then 'Below 100'
   when cost between 100 and 500 then '100-500'
   when cost between 500 and 1000 then '500-1000'
   else 'Above 1000'
end as cost_range
from gold.dim_products
)
select 
cost_range,
count(distinct product_key) as total_products
from product_segments
group by cost_range
go
--group customets into three segments based on their spending behaviour
--VIP:with atleast 12 months of history and spending more than 5000
--regular:atleast 12 months and spending less than 5000
--new:less than 12 months span
--find total no of customers by each group

with helper_cte as (
select 
d.customer_id,
min(f.order_date) as first_order,
max(f.order_date) as last_order,
datediff(month,min(f.order_date),max(f.order_date)) as gap,
sum(f.sales_amount) as spend
from gold.fact_sales as f
left join gold.dim_customers as d
on d.customer_key=f.customer_key
group by d.customer_id
),
categorised_cte as (
select 
customer_id,
case 
   when gap>=12 and spend>5000 then 'VIP'
   when gap>=12 AND spend<=5000 then 'Regular'
   else 'New'
end as category
from helper_cte
)
select 
category,
count(distinct customer_id) as cnt
from categorised_cte
group by category
order by count(distinct customer_id) desc
go


create view gold.report_customers as
--REPORTING
--base query
with base_query as (
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name,' ',c.last_name) as customer_name,
datediff(year,c.birthdate,getdate()) as age,
c.birthdate
from gold.fact_sales as f
left join gold.dim_customers as c
on c.customer_key=f.customer_key
where f.order_date is not null
),
customer_aggregation as (
--aggregate customer level metrics
select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as last_order_date,
datediff(month,min(order_date),max(order_date)) as gap
from base_query
group by customer_key,customer_number,customer_name,age
)
--final query
select
customer_key,
customer_number,
customer_name,
age,
case 
  when age<20 then 'Under 20'
  when age between 20 and 29 then '20-29'
  when age between 30 and 39 then '30-39'
  when age between 40 and 49 then '40-49'
  else 'Above 50'
end as age_group,
case 
   when gap>=12 and total_sales>5000 then 'VIP'
   when gap>=12 AND total_sales<=5000 then 'Regular'
   else 'New'
end as customer_segment,
last_order_date,
datediff(month,last_order_date,getdate()) as recency,
total_orders,
total_sales,
total_quantity,
total_products,
gap,
--average order value (AVO)
case
   when total_orders=0 then 0
   else (total_sales/total_orders)
end as avg_order_value,
--compute average monthly spend
case
   when gap=0 then 0
   else (total_sales/gap)
end as avg_monthly_spend
from customer_aggregation

