--create dim_customers view
--check the primary have duplicates or not
--fisrt take master table and join with dim tables
--rename the 
if object_id('gold.dim_customers','V') is not null
   drop view gold.dim_customers
go
create view gold.dim_customers as 
	select 
	row_number() over(order by ci.cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	ci.cst_marital_status as marital_status,
	case  
	   when ci.cst_gndr!='n/a' then cst_gndr
	   else isnull(ca.gen,'n/a')
	end as gender,
	ci.cst_create_date as create_date,
	ca.bdate as birthdate,
	la.cntry as country
from silver.crm_cust_info as ci
	left join silver.erp_cust_az12 as ca
	on     ci.cst_key=ca.cid
	left join silver.erp_loc_a101 as la
	on     la.cid=ci.cst_key
go


if object_id('gold.dim_products','V') is not null
   drop view gold.dim_products
go
--create dim_products view
create view gold.dim_products as 
select 
	--surrogate key
	ROW_NUMBER() over(order by pn.prd_id) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance as maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info as pn
	left join silver.erp_px_cat_g1v2 as pc
	on   pc.id=pn.cat_id
	where pn.prd_end_dt is null --filter all historical date
go


if object_id('gold.fact_sales','V') is not null
   drop view gold.fact_sales
go
--create fact sales
create view gold.fact_sales as 
select 
	sd.sls_ord_num as order_number,
	pr.product_key,--surrogate key
	cu.customer_key, --surrogate key
	sd.sls_cust_id,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price
from silver.crm_sales_details as sd
	left join gold.dim_products as pr
	on pr.product_number=sd.sls_prd_key
	left join gold.dim_customers as cu
	on cu.customer_id=sd.sls_cust_id
go