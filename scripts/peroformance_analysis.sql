/*
===============================================================================
performance analysis (year-over-year, month-over-month)
===============================================================================
purpose:
    - It is the process of comparing the current value to a target value to compare the performance of a specific category.
    - It helps in measuring success and compare performance.
    - to measure the performance of products, customers, or regions over time.
    - for benchmarking and identifying high-performing entities.
    - to track yearly trends and growth.

sql functions used:
    - lag(): accesses data from previous rows.
    - avg() over(): computes average values within partitions.
    - case: defines conditional logic for trend analysis.

Formla: Current[Measure] - Target[Measure]

===============================================================================
*/

/*
Analyze the yearly performance of products by comparing thier
sales to both the average sales performance and the previous year's sales.
*/
With yearly_product_sales as(
select
	dp.product_name,
	year(fs.order_date) as order_year,
	sum(fs.sales_amount) as Current_sales
from 
gold.fact_sales fs
left join gold.dim_products dp
on dp.product_key = fs.product_key
where order_date is NOT NULL
group by year(fs.order_date), dp.product_name
)
Select
	product_name,
	order_year,
	current_sales,
	avg(current_sales) over ( partition by product_name) avg_sales,
	current_sales - avg(current_sales) over ( partition by product_name) as diff_avg,
	Case 
		When current_sales - avg(current_sales) over ( partition by product_name) > 0 THEN 'Above Average'
		When current_sales - avg(current_sales) over ( partition by product_name) < 0 THEN 'Below Average'
		Else 'AVERAGE'
	END avg_change,
	-- Year-over-year Analysis
	LAG(current_sales) over(partition by product_name order by order_year) py_sales,
	current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_py,
	Case 
		When current_sales -  lag(current_sales) over(partition by product_name order by order_year) > 0 THEN 'Increase'
		When current_sales -  lag(current_sales) over(partition by product_name order by order_year) < 0 THEN 'Decrease'
		Else 'No Change'
END py_change
from yearly_product_sales
order by product_name, order_year;


/*
Task 2:- Analyze yearly performance of products by comparing their
sales to category average and previous year's sales.
*/
with yearly_category_sales as(
	select
		category,
		product_name,
		year(fs.order_date) as order_year,
		sum(fs.sales_amount) as current_sales
	from gold.fact_sales fs
	left join gold.dim_products dp
	on dp.product_key = fs.product_key
	where fs.order_date is not null
	group by
		dp.category, dp.product_name, year(fs.order_date)
)
select
	product_name,
	category,
	order_year,
	current_sales,
	avg(current_sales) over(partition by category) as avg_category_sales,
	current_sales - Avg(current_sales) over(partition by category) as diff_category_avg,
	case
		when current_sales - Avg(current_sales) over(partition by category) > 0 then 'Above Average'
		when current_sales - Avg(current_sales) over(partition by category) < 0 then 'Below Average'
		Else 'Average'
	end as category_performance,
	lag(current_sales) over(partition by product_name order by order_year) as py_sales,
	current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_py,
	case
		When current_sales - lag( current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
		When current_sales - lag( current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
		else 'No Change'
	end as py_change
from yearly_category_sales
order by category, product_name, order_year;
