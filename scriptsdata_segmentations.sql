/*
===============================================================================
data segmentation analysis
===============================================================================
purpose:
    - to group data into meaningful categories for targeted insights.
    - for customer segmentation, product categorization, or regional analysis.
    - Group up the data based on specific range.
    - It helps in understanding the correlation between two measures.

sql functions used:
    - case: defines custom segmentation logic.
    - group by: groups data into segments.

Formula: [Measure] by [Measure]
===============================================================================
*/


/*Task 1:- Segment products into costs ranges and 
count how many products fall into each segment.
*/
With product_Segments as (
Select
product_key,
product_name,
cost,
case
	when cost < 100 Then 'Below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	Else 'Above 1000'
End cost_range
from gold.dim_products
)
select
cost_range,
count(product_key) as total_products
from product_segments
group by cost_range
order by total_products desc;


/*
Task 2 :- Group customers into three segments based on their spending behavior.
1. VIP: At least 12 months o history and spending more than 5000
2. Regulare: At least 12 months of history but spending 5000 or less.
4. New: Lifespan less then 12 months.
and find the total number of customers by each group.
*/
with customer_spending as (
select
dc.customer_key,
sum(fs.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
datediff(month, min(Order_date), max(order_date))as lifespan
from gold.fact_sales fs
left join gold.dim_customers dc
on dc.customer_key = fs.customer_key
group by dc.customer_key
)
select
customer_segment,
count(customer_key) as total_customers
from (
select
customer_key,
case
	when lifespan >= 12 and total_spending > 5000 then 'VIP'
	when lifespan >= 12 and total_spending <= 5000 then 'Regular'
	Else 'New'
end customer_segment
from customer_spending
) t 
group by customer_segment
order by total_customers desc;



/*
Task3: Segment Products inot cost ranges and
count how many products fall into each segment
*/
With product_cost as (
select 
product_id,
product_name,
cost,
case
	when cost < 100 then 'Low-cost'
	when cost between 100 and 500 then 'Mid-cost'
	else 'High-Cost'
end as cost_segment
from gold.dim_products
)
select 
cost_segment,
count(*) as product_count
from product_cost
group by cost_segment
order by product_count desc;


/* 
Task 4:- Segment customers into age groups and 
count how many fall in each age segment.
*/
with customer_age as(
select
customer_key,
datediff(year, birthdate, getdate()) as age
from gold.dim_customers
)

select 
case
	when age < 25 then 'Youth'
	when age between 25 and 50 then 'Adult'
	when age between 41 and 60 then 'Middle-Aged'
	Else 'Senior'
end as age_group,
count(*) as total_customers
from customer_age
group by
	case
	when age < 25 then 'Youth'
	when age between 25 and 50 then 'Adult'
	when age between 41 and 60 then 'Middle-Aged'
	Else 'Senior'
end
order by total_customers desc;


/* 
Task 5:- Segment sales into tiers based on Sales Amount and 
count how many orders fall into each tier.
*/
with sales_segment as (
select
order_number,
sales_amount,
case
	when sales_amount < 500 then 'Low-Sales'
	When sales_amount Between 500 and 2000 then 'Mid-Sales'
	Else 'High-Sales'
end as Sales_tier
from gold.fact_sales
)
Select
sales_tier,
count(*) as order_count
from sales_segment
group by sales_tier
order by order_count desc
