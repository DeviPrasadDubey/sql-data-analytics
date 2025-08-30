/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================

Purpose:
    - To calculate important business measures that summarize overall performance.
    - To generate aggregated values such as total sales, total orders, and averages.
    - To prepare a consolidated view of key business insights.

Key SQL Functions Applied:
    - COUNT() : Returns the number of records.
    - SUM()   : Returns the total of numeric values.
    - AVG()   : Returns the average of numeric values.

Tables Involved:
    - gold.fact_sales
    - gold.dim_products
    - gold.dim_customers
===============================================================================
*/

-- Total Sales
select sum(sales_amount) as total_sales
from gold.fact_sales;

-- Total Quantity of Items Sold
select sum(quantity) as total_quantiy
from gold.fact_sales;


-- Average Selling Price
select avg(price) as avg_price
from gold.fact_sales;

-- Total Number of Orders (with duplicates and distinct)
select count(order_number) as total_orders
from gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- Total Number of Products
select count(product_key) as total_products
from gold.fact_sales;

-- Total Number of Customers
select count(customer_key) as total_customers from 
gold.dim_customers;

-- Total Customers Who Have Placed Orders
select count(distinct(customer_key)) as total_customers
from gold.fact_sales;


-- Consolidated Report of All Key Metrics
-- Generating  a Report that shows all key metrics of the business.
select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Total Quantity', sum(quantity) from gold.fact_sales
union all
select 'Average Price', avg(price) as avg_price from gold.fact_sales
union all 
select 'Total Nr. Orders', count(distinct order_number) as total_orders from gold.fact_sales
union all
select 'Total Nr. Products', count(product_name) from gold.dim_products
union all
select 'Total Nr. Customers', count(customer_key) from gold.dim_customers;
