/*
==================================================================================
Customer Report
==================================================================================

Purpose:
	- This report consolidates key customers metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product names, category, subcategory, and cost.
	2. Segments products by revenue to identify High-preformers, Mid-Range, or Low-performers.
	3. Aggregate product-level metrices:
		- Total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in month)
	4. Calcualtes valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue.
==================================================================================
*/




Create view gold.report_products as
	With base_query as(
	/* ------------------------------------------------------------------------------
	1. Base Query: Retrieves cores columns from fact_sales and dim_products
	*/ ------------------------------------------------------------------------------

		select
			sf.order_number, sf.order_date, sf.customer_key,
			sf.sales_amount, sf.quantity,
			dp.product_key, dp.product_name,
			dp.category, dp.subcategory, dp.cost
		from 
		gold.fact_sales sf
		left join gold.dim_products dp
		on dp.product_key = sf.product_key
		where order_date is not NULL -- Only consider valid Sales dates.
	),
	product_aggregation as (
	/* ------------------------------------------------------------------------------
	2. Product Aggregation: Summarizes key metrices at the product level.
	*/ ------------------------------------------------------------------------------
		Select 
			product_key,
			product_name,
			category,
			subcategory,
			cost,
			datediff(month, min(order_date), max(order_date)) as lifespan,
			max(order_date) as last_sale_date,
			count(distinct order_number) as total_orders,
			count(distinct customer_key) as total_customers,
			sum(sales_amount) as total_sales,
			sum(quantity) total_quantity,
			round(AVG(cast(sales_amount as float) / NULLIF(quantity, 0)), 1) as avg_selling_price
		from base_query
		group by
			product_key,
			product_name,
			category,
			subcategory,
			cost
	)
	/* ------------------------------------------------------------------------------
	1. Final Query: Combines all product results intp on output.
	*/ ------------------------------------------------------------------------------
	Select
			product_key,
			product_name,
			category,
			subcategory,
			cost,
			last_sale_date,
			Datediff(month, last_sale_date, GETDATE()) as receny_in_months,
		Case 
			when total_sales > 50000 then 'High-Performer'
			when total_sales >= 10000 then 'Mid-Performer'
			Else 'Low-Performer'
		end as Product_segment,
		lifespan,
		total_orders,
		total_sales,
		total_quantity,
		total_customers,
		avg_selling_price,
		Case
			When total_orders = 0 then 0
			Else total_sales/total_orders  
		end avg_order_revenue, -- Average order Revenue (AOR)
		Case
			When lifespan = 0 then total_sales
			Else total_sales/lifespan  
		end avg_monthly_revenue	-- Average Monthly Revenue

	from product_aggregation




Select * from gold.report_products;
