# E-Commerce ELT Analytics Pipeline (Snowflake + dbt)

![dbt](https://img.shields.io/badge/dbt-1.13.0-orange?logo=dbt)
![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-29B5E8?logo=snowflake)
![SQL](https://img.shields.io/badge/Language-SQL-blue)
![Data Quality](https://img.shields.io/badge/Tests-14%2F14%20Passed-brightgreen)

An ELT data pipeline built with **Snowflake** as the data warehouse and **dbt (Data Build Tool)** for transformation, data quality testing, deduplication, and analytics documentation.

---

## Architecture & Data Flow

This project follows the **Medallion Architecture** (Raw $\rightarrow$ Staging $\rightarrow$ Marts) to clean raw e-commerce data and organize it into business-ready analytical data marts.

<img width="1600" height="688" alt="image" src="https://github.com/user-attachments/assets/932c96c4-cbb4-4c34-8ea6-3b638e17bfe4" />
