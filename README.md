# SQL Data Analytics — Portfolio Repository

Welcome! This is my SQL Data Analytics project where I designed, structured, and executed SQL-based analyses on business datasets.
The project demonstrates my ability to:

create and manage datasets in SQL Server

Build analytical SQL queries for business insights

Create structured reports such as magnitude, cumulative, segmentation, and customer-level analysis

Apply advanced SQL concepts like window functions, date functions, and conditional segmentation

- `datasets/` — sample data files you can load into SQL Server
- `scripts/` — production-ready SQL scripts grouped by analytical theme

> Tip: run the scripts in the order shown below (from exploration → analysis → reporting) for the smoothest experience.

---

## 🗂 Repository Structure

```
sql-data-analytics/
├─ datasets/
│  └─ <csv files>
├─ scripts/
│  ├─ 00_database_exploration.sql
│  ├─ 01_dimensions_exploration.sql
│  ├─ 02_date_range_exploration.sql
│  ├─ 03_measures_exploration.sql
│  ├─ 04_magnitude_analysis.sql
│  ├─ 05_ranking_analysis.sql
│  ├─ 06_change_over_time.sql
│  ├─ 07_cumulative_analysis.sql
│  ├─ 08_performance_yoy_mom.sql
│  ├─ 09_part_to_whole.sql
│  ├─ 10_data_segmentation.sql
│  ├─ 11_customer_report.sql
│  └─ other helper scripts
└─ README.md
```

> File names in `scripts/` reflect the **themes** already used throughout this repo (database exploration, magnitude analysis, ranking, cumulative, segmentation, customer report, etc.). Adjust numbering to match your actual files if needed.

---

## 🚀 Quickstart

### 1) Clone the repo
```bash
git clone https://github.com/DeviPrasadDubey/sql-data-analytics.git
cd sql-data-analytics
```

### 2) Create a database & schemas in SQL Server
Open **SSMS** and run:
```sql
create database datawarehouse;
go

use datawarehouse;
go

-- optional schemas (if you use gold/silver/bronze)
create schema bronze;
create schema silver;
create schema gold;
```

### 3) Load datasets
Use **SSMS → database → tasks → import flat file** (or BULK INSERT) to load files from `datasets/` into tables. Example for CSV:

```sql
-- example bulk insert (edit path, table and options)
bulk insert gold.dim_customers
from 'C:\path\to\datasets\dim_customers.csv'
with (
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '0x0a',
    tablock
);
```

> If your tables live under `gold.` (e.g., `gold.dim_products`, `gold.fact_sales`), keep that schema prefix in all queries.

### 4) Run the scripts
Execute the `.sql` files from `scripts/` in this order:

1. `00_database_exploration.sql` — list tables, columns, data types
2. `01_dimensions_exploration.sql` — unique values by dimension (countries, categories, products)
3. `02_date_range_exploration.sql` — min/max dates, data coverage, age ranges
4. `03_measures_exploration.sql` — totals, counts, averages, KPI rollups
5. `04_magnitude_analysis.sql` — group-by summaries (by country, gender, category, etc.)
6. `05_ranking_analysis.sql` — top/least performers with window functions
7. `06_change_over_time.sql` — monthly/quarterly trends and seasonality
8. `07_cumulative_analysis.sql` — running totals, moving averages
9. `08_performance_yoy_mom.sql` — yoy/mom changes with `lag()` windows
10. `09_part_to_whole.sql` — contribution analytics with shares/percent of total
11. `10_data_segmentation.sql` — customer/product/region segmentation with `case`
12. `11_customer_report.sql` — consolidated customer-level KPIs (recency, aov, avg monthly spend, lifespan)

> All queries are written in **lowercase** (style choice) and target **sql server** syntax.

---

📊 Key Analyses & Insights

✔ Magnitude Analysis → Overall customers, products, sales, revenue
✔ Ranking → Best/worst performing products & customers
✔ Change Over Time → Month-on-month, seasonality, growth trends
✔ Cumulative → Running totals, moving averages
✔ Performance (YoY/MoM) → Benchmarking across periods
✔ Part-to-Whole → Regional/category contributions to sales
✔ Segmentation → Age groups, customer tiers (VIP, Regular, New)
✔ Customer Report → Recency, AOV, monthly spend, lifespan


## 📊 KPI Dictionary (used across scripts)

- **total_sales** — `sum(sales_amount)`  
- **total_quantity** — `sum(order_quantity)` (or `sum(quantity)`, depending on your column name)  
- **total_orders** — `count(distinct order_number)`  
- **avg_price** — `avg(price)`  
- **avg_order_value (aov)** — `total_sales / total_orders`  
- **recency_months** — months since last order (`datediff(month, last_order_date, getdate())`)  
- **lifespan_months** — months between first and last order (`datediff(month, first_order_date, last_order_date) + 1`)  
- **avg_monthly_spend** — `total_sales / lifespan_months`  

> Align column names (e.g., `order_quantity` vs `quantity`) with your actual dataset.

---

## 🧱 Data Model

Simple star schema:

- `gold.dim_customers(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, birthdate)`
- `gold.dim_products(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, start_date)`
- `gold.fact_sales(order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price)`

---

## ✅ Reproducibility Notes

- Scripts are **idempotent** and read-only (analytics only).  
- Works on **sql server 2019+** and **ssms**.  
- All queries are written with **lowercase keywords** for consistency.  
- If a script expects `gold.` schema but your tables are in `dbo.`, either create the `gold` schema or remove the prefix.

---

## 🧪 How to validate your setup

After loading the data, try a few quick checks:

```sql
-- sanity checks
select top 5 * from gold.dim_customers;
select top 5 * from gold.dim_products;
select top 5 * from gold.fact_sales;

-- row counts
select 'dim_customers' as table_name, count(*) as rows from gold.dim_customers
union all
select 'dim_products', count(*) from gold.dim_products
union all
select 'fact_sales', count(*) from gold.fact_sales;
```

---

## 🙌 Contributing / Issues

- Feel free to open issues or PRs for improvements, performance tweaks, or additional analysis scripts.
- Suggested additions: churn flags, rfm scoring, cohort analysis, seasonality decomposition.

---

## 📄 License

If you plan to reuse code or data publicly, add a `LICENSE` (e.g., MIT).

---
## 🎯 Purpose of Project

This project was built as part of my data analytics portfolio to:

- Strengthen SQL query-writing skills

- Demonstrate business-focused analytics with SQL

- Build a portfolio-ready repository for Data Analyst roles

- Explore customer, product, and sales insights end-to-end

## 🚀 Future Enhancements

- Connect SQL outputs to Power BI dashboards

- Add RFM scoring & churn prediction

- Build ETL pipeline for automated refresh


## ✉️ Contact

- Author: **Devi Prasad Dubey**
- Repo: `sql-data-analytics`

---

> This README is tailored to the current structure and themes of this repository (datasets/ and scripts/). Update file names in the *Repository Structure* and *Run the scripts* sections if they differ from your exact filenames.
