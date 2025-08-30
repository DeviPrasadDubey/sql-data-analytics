/*
===============================================================================
Dimensions Exploration (Practice Notes)
===============================================================================

Purpose:
    - I want to explore the structure of dimension tables.
    - Identifying the unique vlaue (or categories) in each dimension.
    - Recognizing how data might be grouped or segmented, which is useful for late anlaysis.

What I learned:
    - DISTINCT helps me to remove duplicates and only see unique values.
    - ORDER BY helps me to sort the output in a readable way.

SQL Functions Practiced:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- 1. xplore all the Unique countries from which customers come.
select
distinct country 
from gold.dim_customers;


-- 2. Unique categories, subcategories, and product names (the major Divisions)
Select 
Distinct Category,
subcategory,
product_name
from gold.dim_products
order by 1,2,3;
