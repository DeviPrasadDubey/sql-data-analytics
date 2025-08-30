/*
===============================================================================
part-to-whole analysis
===============================================================================
purpose:
    - It is use to find the proportion to a part relative to the whole.
    - It analyzew how an individual part is performing compared to the overall, allowing us to undestand which category has the greatest impact on the business.
    - to compare performance or metrics across dimensions or time periods.
    - to evaluate differences between categories.
    - useful for a/b testing or regional comparisons.

sql functions used:
    - sum(), avg(): aggregates values for comparison.
    - window functions: sum() over() for total calculations.

Formula:- ([Measure] / Total[Measure]) * 100 By [Dimension]
===============================================================================
*/


/*
Task1: Which categories contribute the most to oveall sales?
*/
with category_sales as(
select 
	category,
	sum(sales_amount) as total_sales
from gold.fact_sales sf
left join gold.dim_products dp
on dp.product_key = sf.product_key
group by category
)
select 
	category,
	total_sales,
	sum(total_sales) over() overall_sales,
	Concat(Round((cast(total_sales as float) / sum(total_sales) over()) * 100,3), '%') as perc_of_total_sales
from category_sales
order by total_sales desc;



/* 
Task 2: Which subcategory contribute(top 1) the most in each category to oveall sales?
*/

with Subcategory_sales as(
select 
	category,
	subcategory,
	sum(sales_amount) as Subcat_sales
from gold.fact_sales sf
left join gold.dim_products dp
on dp.product_key = sf.product_key
group by category, subcategory
),
RankedSubcategory as(
	Select
		category,
		subcategory,
		Subcat_sales,
		Sum(subcat_sales) over ( partition by category) as Category_total,
		Rank() over (partition by category order by Subcat_sales desc) as subcat_rank
	from Subcategory_sales
)
select
	category,
	subcategory,
	Subcat_sales,
	Category_total,
	Concat(cast((Subcat_sales * 100.0/category_total) as decimal(5,2)), '%') as percentage_share
from RankedSubcategory
where subcat_rank = 1
order by Subcat_sales Desc;



/*
Task 3:Which Country Contributes the most to overall sales (with percentage)?
*/
with Country_sales as ( 
	select 
		country,
		sum(sales_amount) as Country_total,
		sum(sum(sales_amount)) over () as Overall_total,
		Rank() over (order by sum(sales_amount) desc) as Country_rank
	from gold.fact_sales sf
	left join gold.dim_customers dc
	on dc.customer_key = sf.customer_key
	where country != 'n/a'
	group by country
)
Select top 3
	country,
	Country_total,
	overall_total,
	country_rank
from country_sales;



/*
Task 4:Which product line contributes the most to overall sales?
*/
Select 
	product_line,
	sum(sales_amount) as Line_sales,
	(select sum(sales_amount) from gold.fact_sales) as overall_total,
	cast (sum(sales_amount)* 100.0 / (select sum(sales_amount) from gold.fact_sales)as decimal(5,2)) as percentage_share
from gold.fact_sales sf
left join gold.dim_products dp
on sf.product_key = dp.product_key
group by product_line
having sum(sf.sales_amount) = (
	select max(line_totals.total_sales)
	from (
		select dp2.product_line,
			sum(sf2.sales_amount) as total_sales
			from gold.fact_sales sf2
			left join gold.dim_products dp2
			on sf2.product_key = dp2.product_key
			group by dp2.product_line
		) line_totals
	);


/*
Task 5:- Top product line with most contributions.
*/
with product_line_sales as(
select
	product_line,
	sum(sales_amount) as line_sales,
	sum(sum(sales_amount)) over() as overall_total,
	rank() over ( order by sum(sales_amount) desc) as line_rank
	from gold.fact_sales sf
	left join gold.dim_products dp
	on sf.product_key = dp.product_key
	group by product_line
)
select 
product_line,
line_sales,
overall_total,
line_rank,
concat(cast((line_sales *100.0 / overall_total) as decimal(5,2)), '%') as percentage_share
from product_line_sales;
