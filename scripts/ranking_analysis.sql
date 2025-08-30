/*
===============================================================================
ranking analysis
===============================================================================
purpose:
    - to rank items (e.g., products, customers) based on performance or other metrics.
    - to identify top performers or laggards.

sql functions used:
    - window ranking functions: rank(), dense_rank(), row_number(), top
    - clauses: group by, order by
Formul:-
  order the valuesnof dimensions by measures
===============================================================================
*/

-- which 5 products generate the highest revenue? (flexible ranking)
Select * 
from (
	select 
	dp.product_name,
	sum(fs.sales_amount) as total_revenue,
	row_number() over (Order by sum(fs.sales_amount) desc) as rank_products
	from  gold.fact_sales as fs
	left join gold.dim_products dp 
	on fs.product_key = dp.product_key
	group by dp.product_name
)t
where rank_products <= 5

-- top 5 products by revenue in each category using window functions (flexible ranking)
Select * 
from (
	select 
	dp.category,
	sum(fs.sales_amount) as total_revenue,
	row_number() over (Order by sum(fs.sales_amount) desc) as rank_products
	from  gold.fact_sales as fs
	left join gold.dim_products dp 
	on fs.product_key = dp.product_key
	group by dp.category
)t
where rank_products <= 5;

-- top 5 products by revenue in subcategory of each category using window functions (flexible ranking)
Select * 
from (
	select 
		dp.subcategory,
		sum(fs.sales_amount) as total_revenue,
		row_number() over (Order by sum(fs.sales_amount) desc) as rank_products
	from  gold.fact_sales as fs
	left join gold.dim_products dp 
	on fs.product_key = dp.product_key
	group by dp.subcategory
)t
where rank_products <= 5

-- finding 5 worst-perforing product is terms of sales
Select  top 5
	dp.product_name,
	sum(f.sales_amount) as total_revenue
from  gold.fact_sales as f
left join gold.dim_products dp 
on f.product_key = dp.product_key
group by dp.product_name
order by total_revenue ASC;

-- Finding the top 10 Customers who have genrated the highest revenue
Select top 10 
dc.customer_key,
dc.first_name,
dc.last_name,
sum(fs.sales_amount) as total_revenue
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key =  dc.customer_key 
group by 
dc.customer_key,
dc.first_name,
dc.last_name
order by total_revenue Desc;

-- The 3 customers with the fewest orders placed
Select top 3
dc.customer_key,
dc.first_name,
dc.last_name,
count(Distinct Order_number) as total_orders
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key =  dc.customer_key 
group by 
dc.customer_key,
dc.first_name,
dc.last_name
order by total_orders asc;
