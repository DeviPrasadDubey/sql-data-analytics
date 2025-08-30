/*
===============================================================================
change over time analysis
===============================================================================
purpose:
    - to track trends, growth, and changes in key metrics over time.
    - for time-series analysis and identifying seasonality.
    - to measure growth or decline over specific periods.

sql functions used:
    - date functions: datepart(), datetrunc(), format()
    - aggregate functions: sum(), count(), avg()

Formula:- [Measure] by [Date Dimenison]
===============================================================================
*/


/*
Task 1:- Analyze Sales Performance Over Time.
Total Sales by Year.
Total Sales by Month.
*/
Select
	Year(order_date) as order_year,
	Month(order_date) as order_month,
	sum(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not NULL
group by Year(order_date), Month(order_date)
order by Year(order_date), Month(order_date);



Select
	Format(order_date, 'yyyy-MMM') as order_date,
	sum(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not NULL
group by Format(order_date, 'yyyy-MMM')
order by Format(order_date, 'yyyy-MMM');


/* 
Task 2:- Compare Year-over-Year (YoY) Growth in Sales.
Show total sales per year and calculate YoY growth percentage.
*/
With yearly_sales as (
	select
		datepart(year, order_date) as order_year,
		sum(sales_amount) as total_sales
	from gold.fact_sales
	where order_date is not null
	group by datepart(year, order_date)
)
Select
	order_year,
	total_sales,
	lag(total_sales) over (Order by order_year) as prev_year_sales,
	cast(round (
	((total_sales - lag(total_sales) over (order by order_year)) * 100.0) /
	Nullif (lag(total_sales) over (order by order_year),0), 2) as decimal(10,2)) as yoy_growth_percent
from yearly_sales
order by order_year;


/* 
Task 3:- Identify Peak Sales Months for Each Year.
Find which month in every year had the highest sales and its percentage share of that year's sales.
*/
With monthly_sales as(
select
	datepart(year,order_date) as order_year,
	datepart(month, order_date) as order_month,
	sum(sales_amount) as total_sales
	from gold.fact_sales
	where order_date is not null
	group by 
		datepart(year,order_date), datepart(month, order_date)
)
select
	m.order_year,
	m.order_month,
	m.total_sales,
	cast(round(m.total_sales * 100.0 / y.year_total, 2) As DECIMAL(5,2)) as pct_of_year_sales
from monthly_sales as m
join (
	select order_year, max(total_sales) as max_sales, sum(total_sales) as year_total
	from monthly_sales
	group by order_year
) y
on m.order_year = y.order_year
and m.total_sales = y.max_sales
order by m.order_year;



/* 
Task 4:- Track Customer Retention Over Time.
Count how many customers placed orders in consecutive years.
*/
With yearly_customers as(
	select 
		datepart(year, order_date) as order_year,
		customer_key
	from gold.fact_sales
	where order_date is not NULL
	group by datepart (year, order_date), customer_key
)
select
	this_year.order_year as year,
	count(distinct this_year.customer_key) as customer_this_year,
	count(distinct case 
					when prev_year.customer_key is not null then this_year.customer_key end) as retained_customers
from yearly_customers this_year
left join yearly_customers prev_year
on this_year.customer_key = prev_year.customer_key
and this_year.order_year= prev_year.order_year+1
group by this_year.order_year;


