/*
===============================================================================
magnitude analysis
===============================================================================

purpose:
    - to measure and compare values across different dimensions.
    - to understand how data is distributed by categories like country, gender, or product.
    - to evaluate revenue, cost, and sales patterns.

key sql concepts:
    - aggregate functions: sum(), count(), avg()
    - group by: groups data by chosen columns.
    - order by: sorts results for better readability.

tables used:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales
===============================================================================
*/

-- total customers by country
select
    country,
    count(customer_key) as total_customers
from gold.dim_customers
group by country
order by total_customers desc;

-- total customers by gender
select
    gender,
    count(customer_key) as total_customers
from gold.dim_customers
group by gender
order by total_customers desc;

-- total products by category
select
    category,
    count(product_key) as total_products
from gold.dim_products
group by category
order by total_products desc;

-- average product cost by category
select
    category,
    avg(cost) as avg_cost
from gold.dim_products
group by category
order by avg_cost desc;

-- total revenue by product category
select
    p.category,
    sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
    on p.product_key = f.product_key
group by p.category
order by total_revenue desc;

-- total revenue by customer
select
    c.customer_key,
    c.first_name,
    c.last_name,
    sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
    on c.customer_key = f.customer_key
group by 
    c.customer_key,
    c.first_name,
    c.last_name
order by total_revenue desc;

-- distribution of sold items by country
select
    c.country,
    sum(f.quantity) as total_sold_items
from gold.fact_sales f
left join gold.dim_customers c
    on c.customer_key = f.customer_key
group by c.country
order by total_sold_items desc;
