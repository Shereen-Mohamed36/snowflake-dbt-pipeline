# E-Commerce ELT Analytics Pipeline 

![dbt](https://img.shields.io/badge/dbt-1.13.0-orange?logo=dbt)
![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-29B5E8?logo=snowflake)
![SQL](https://img.shields.io/badge/Language-SQL-blue)
![Data Quality](https://img.shields.io/badge/Tests-14%2F14%20Passed-brightgreen)

An ELT data pipeline built with **Snowflake** as the data warehouse and **dbt (Data Build Tool)** for transformation, data quality testing, deduplication, and analytics documentation.

---

## Overview

The pipeline processes raw e-commerce CSV datasets (`customers`, `products`, `orders`) loaded into Snowflake's `RAW` schema, then uses dbt to:
- Standardize column names, data types, and order status values.
- Deduplicate orders and filter out invalid foreign key references.
- Join datasets to calculate order-level revenue and aggregate customer and category metrics.
- Enforce data quality using automated dbt tests.

## Data Pipeline Structure
This project follows the **Medallion Architecture** (Raw $\rightarrow$ Staging $\rightarrow$ Marts) to clean raw e-commerce data and organize it into business-ready analytical data marts.

The architecture is divided into three logical layers:

1. **`RAW` Schema (Snowflake):** Raw ingestion layer containing `customers`, `products`, and `orders` tables.
2. **`STAGING` Schema (dbt):** Cleansed and standardized views (`stg_customers`, `stg_products`, `stg_orders`). Deduplicates order rows using window functions and filters out orphaned records.
3. **`MARTS` Schema (dbt):**
   - `fct_orders`: Fact table at the order grain with joined customer/product details and calculated revenue.
   - `mart_customer_summary`: Aggregates completed order counts and total spending per customer.
   - `mart_category_sales`: Aggregates completed order counts and total revenue per product category.
     
<img width="1600" height="688" alt="image" src="https://github.com/user-attachments/assets/fea6ee89-aa82-40da-bcf5-e11d544762a1" />

## Project Structure

```text
ecommerce_dbt/
├── models/
│   ├── staging/
│   │   ├── schema.yml
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   └── stg_orders.sql
│   └── marts/
│       ├── schema.yml
│       ├── fct_orders.sql
│       ├── mart_customer_summary.sql
│       └── mart_category_sales.sql
├── tests/
│   └── assert_completed_revenue_is_non_negative.sql
├── dbt_project.yml
└── README.md
```

## Business Rules & Data Quality

- **Revenue Calculation:** Computed as `quantity * price`.
- **Status Handling:** Pending and cancelled orders remain in `fct_orders` for order tracking, but are excluded from spending and sales totals in `mart_customer_summary` and `mart_category_sales`.
- **Deduplication:** Orders are deduplicated on `order_id` by selecting the most recent entry based on `order_date`.
- **Testing (14 Tests Passed):**
  - Primary key `unique` and `not_null` tests on IDs across models.
  - Foreign key `relationships` checks on `customer_id` and `product_id`.
  - `accepted_values` constraint on `order_status` (`completed`, `pending`, `cancelled`).
  - Custom SQL test (`assert_completed_revenue_is_non_negative.sql`) to verify no completed order has negative revenue.

## Prerequisites & Database Setup

Before running the dbt project, ensure you have:

1. **A Snowflake Account:** Set up a database named `ECOMMERCE_DB`.
2. **Raw Schemas & Data Loaded:** Create the `RAW` schema and load the source CSV files (`customers.csv`, `products.csv`, `orders.csv`) into their respective tables (`CUSTOMERS`, `PRODUCTS`, `ORDERS`).
3. **dbt Schemas:** Ensure `STAGING` and `MARTS` schemas exist (or let dbt create them via profile permissions).

## Running the Project

1. **Install dependencies:**
   ```bash
   pip install dbt-snowflake
   ```

   2. **Set up connection profile:**
   Configure connection details in `~/.dbt/profiles.yml`:
   ```yaml
   ecommerce_dbt:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: <YOUR_SNOWFLAKE_ACCOUNT>
         user: <YOUR_USER>
         password: <YOUR_PASSWORD>
         role: ACCOUNTADMIN
         warehouse: COMPUTE_WH
         database: ECOMMERCE_DB
         schema: STAGING
         threads: 4

**Execute pipeline and tests:**
```bash
dbt run
dbt test
```
**Generate documentation & lineage:**
```bash
dbt docs generate
dbt docs serve
```
