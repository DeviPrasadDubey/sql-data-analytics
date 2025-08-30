/*
===============================================================================
customer report
===============================================================================
purpose:
    - this report consolidates key customer metrics and behaviors

highlights:
    1. gathers essential fields such as names, ages, and transaction details.
    2. segments customers into categories (vip, regular, new) and age groups.
    3. aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. calculates valuable kpis:
       - recency (months since last order)
       - average order value
       - average monthly spend
===============================================================================
*/



/* ------------------------------------------------------------------------------
1. Base Query: Retrieves cores columns from tables
*/ ------------------------------------------------------------------------------

Create view gold.report_customers as
	With base_query as(
		select
			order_number, product_key, order_date, sales_amount, quantity,
			dc.customer_key, customer_number,
			concat(first_name,' ', last_name) customer_name,
			datediff(year,birthdate, getdate()) age
		from 
		gold.fact_sales sf
		left join gold.dim_customers dc
		on dc.customer_key = sf.customer_key
		where order_date is not NULL
	),
	customer_aggregation as (
		Select 
			customer_key,
			customer_number,
			customer_name,
			age,
			count(distinct order_number) as total_orders,
			sum(sales_amount) as total_sales,
			sum(quantity) total_quantity,
			count(distinct product_key) as total_products,
			max(order_date) as last_order_date,
			datediff(month, min(order_date), max(order_date)) as lifespan
		from base_query
		group by
			customer_key,
			customer_number,
			customer_name,
			age
	)
	Select
		customer_key,
		customer_number,
		customer_name,
		age,
		Case 
			when age < 20 then 'under 20'
			when age between 20 and 29  then '20-29'
			when age between 30 and 39  then '20-29'
			when age between 40 and 49  then '20-29'
			when age between 50 and 59 then '50-59'
			Else '60 and Above'
		end as age_group,
		Case
			when lifespan >= 12 and total_sales>5000 then 'VIP'
			when lifespan >= 12 and total_sales>5000 then 'Regular'
			Else 'New'
		end as customer_segment,
		last_order_date,
		datediff(month, last_order_date, GETDATE())  as recency,
		total_orders,
		total_sales,
		total_quantity,
		total_products,
		lifespan,
		Case
			When total_orders = 0 then 0
			Else total_sales/total_orders  
		end avg_order_value, -- Average order value
		Case
			When lifespan = 0 then total_sales
			Else total_sales/lifespan  
		end avg_monthly_spend	
	from customer_aggregation


-- To check data of the view.
select * from gold.report_customers;
