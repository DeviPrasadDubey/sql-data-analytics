/*
===============================================================================
cumulative analysis
===============================================================================
purpose:
    - to calculate running totals or moving averages for key metrics.
    - to track performance over time cumulatively.
    - useful for growth analysis or identifying long-term trends.
    - It helps to understand whether our business is growing or declining.
    - Aggregate the data progressively over time.

sql functions used:
    - window functions: sum() over(), avg() over()

Formula: [Cumulative Measure] By [Date Dimension]
===============================================================================
*/

/* 
Task 1:- Calculate the total sales per month and the running total of sales over time
and moving average price of sales over time.
*/
select
	order_date,
	total_sales,
	sum(total_sales) over ( partition by order_date Order by order_date) as running_total_sales,
	avg(avg_price) over (order by order_date) as moving_average_price
from
(
select
	datetrunc(month, order_date) as order_date,
	sum(sales_amount) as total_sales,
	avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
)t 



/*
Task 2:- Calculate monthly total quantity sold,
running total of quantity over time, 
and moving average of order value per month.
*/
Select
	order_month,
	total_quantity,
	sum(total_quantity) over (order by order_month) as running_total_quantity,
	avg(avg_order_value) over( order by order_month rows between 2 preceding and current row) as moving_avg_order_value
from(
select
	datetrunc(month, order_date) as order_month,
	sum(quantity) as total_quantity,
	avg(sales_amount) as avg_order_value
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
) t
order by order_month;



/*
Task 3:- Compute cumulative sales per product category 
over months and rank categories by cumulative sales each month.
*/
with category_cumulative as(
Select
	datetrunc(month, order_date) as order_month,
	p.category,
	sum(sales_amount) as total_sales,
	sum(sum(sales_amount)) over (partition by category order by datetrunc(month,order_date)) as cumulative_sales
from gold.fact_sales s
join gold.dim_products p 
on s.product_key = p.product_key
where s.order_date IS NOT NULL
    group by datetrunc(month, s.order_date), p.category	
)
Select
	order_month,
	category,
	total_sales,
	cumulative_sales,
	Rank() over ( partition by order_month order by cumulative_sales desc) as category_rank
from category_cumulative
order by order_month, category_rank;

