/*
===============================================================================
Date Range Exploration
===============================================================================

Purpose:
    - To analyze the temporal boundaries of the dataset.
    - Identify the first and last order dates to understand sales coverage.
    - Determine the youngest and oldest customers for demographic insights.

Key SQL Functions Applied:
    - MIN()  : Retrieve the earliest value in a column.
    - MAX()  : Retrieve the latest value in a column.
    - DATEDIFF() : Calculate the difference between two dates.

Tables Involved:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Retrieving the date of the first and last order and How many years of sales are available?
Select 
	min(order_date) as first_order_date, 
	max(order_date) as last_order_date,
	datediff(month, min(order_date), max(order_date)) as order_range_months
from gold.fact_sales;

-- Retrieving the youngest and oldest customer
Select 
	min(birthdate) as oldest_birthdate,
	datediff(year, min(birthdate), getdate()) as oldest_age,
	max(birthdate) as youngest_birthdate,
	datediff(year, max(birthdate), getdate()) as youngest_age
from gold.dim_customers;

