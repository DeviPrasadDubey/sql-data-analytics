/*
===============================================================================
Database Exploration (Practice Notes)
===============================================================================

Why I am doing this:
    - I want to see all the tables that are present in my database.
    - I also want to know which schema they belong to.
    - Next, I want to check the columns of a particular table 
      (for example: dim_customers).

What I learned:
    - INFORMATION_SCHEMA.TABLES gives me the list of tables with their schema.
    - INFORMATION_SCHEMA.COLUMNS gives me the column names and details
      like data type, if it allows NULLs, and length (for string columns).

===============================================================================
*/

-- 1. See all the tables in the database
SELECT 
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE 
FROM INFORMATION_SCHEMA.TABLES;

-- 2. Check columns of a specific table (example: dim_customers)
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
