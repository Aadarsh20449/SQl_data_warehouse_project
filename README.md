# SQl_data_warehouse_project

Build a data warehouse in SQL Server using the Medallion Architecture, then perform exploratory data analysis (EDA) on the data.
Table of Contents
Project Overview
Architecture: Medallion Layers
Data Sources & Dataset
Implementation Steps
Folder / File Structure
Technologies & Tools
Exploratory Data Analysis (EDA) Summary
How to Run

Project Overview
This project demonstrates how to build a data warehouse on Microsoft SQL Server using the Medallion (“bronze-silver-gold”) architecture.
Ingest raw data into the bronze layer.
Apply transformations, cleaning, deduplication into the silver layer.
Aggregate and model business-ready tables in the gold layer.
Finally, perform EDA on the gold tables to derive insights.
The goal is to structure data ingestion and transformation in a layered manner to support analytics, reporting, and data quality.
Architecture: Medallion Layers
Bronze: Raw data as ingested (minimal transformation).
Silver: Cleaned and conformed data, business-friendly.
Gold: Aggregated, optimized for analytics and reporting.
This layered approach ensures data quality, traceability, and separation of concerns.
Data Sources & Dataset
The project uses datasets stored in the datasets/ folder (e.g., CSV or other format).
These data files act as the raw source for ingestion into the bronze layer.
Example data might include customer, sales, product, or other domain tables (adjust according to your actual dataset).

The raw data is then ingested into SQL Server tables in the bronze layer.
Further transformations produce silver and gold tables.
Implementation Steps
Create database and schemas: Set up schemas for bronze, silver and gold layers.
Ingest raw data to bronze: Load source files into staging / bronze tables.
Transform to silver: Clean data (fix nulls, remove duplicates, standardize formats), enforce business rules.
Model gold layer: Build analytic tables and aggregates, e.g., fact tables, dimension tables, star/snowflake schem
Verify data quality: Run checks between layers (counts, key constraints, referential integrity).
Run EDA: Use SQL queries or export to a tool (CSV/Excel/Python) to explore the gold layer — e.g., trends, distributions, correlations.
Document results: Summarize insights, highlight business-relevant findings.

Folder / File Structure
/datasets              -- raw source data files  
/docs                  -- documentation, diagrams, data dictionaries  
/scripts               -- SQL scripts for each layer, data loads, transformations  
/tests                 -- data quality / unit test scripts  
README.md              -- this file  

You may have sub-folders in scripts/ like bronze/, silver/, gold/ to separate layer‐specific SQL.
Technologies & Tools
Microsoft SQL Server (T-SQL) for data warehouse implementation.
Bulk data loads or INSERT/SELECT statements for ingestion.
SQL stored procedures or scripts for transformations.
(Optional) A data analysis tool such as Excel, Power BI, Python (Pandas) for EDA.
Version control via Git and GitHub (this repository).

Exploratory Data Analysis (EDA) Summary
After building the gold-layer tables, we explored key business metrics and trends:
Distribution of sales/transactions by time period (e.g., monthly/quarterly)
Top products/customers by revenue
Trends in customer acquisition, retention, repeat purchases
Correlation between product categories and revenue growth
Data quality insights: missing values, outliers, unusual patterns
Key findings (sample):

Revenue grew consistently in Q2 and Q3, with product category “X” driving 40% of growth.
A small segment of customers (top 10%) accounted for 60% of sales.
Some records in silver layer had missing region codes and required manual correction.
Visualizations (if exported) include bar charts of top products, line charts of time series, histograms of repeat purchase counts.
These insights demonstrate how a properly built gold layer supports meaningful business analytics and decision-making.

How to Run
Clone the repository:
git clone https://github.com/Aadarsh20449/SQl_data_warehouse_project.git  

Open SQL Server, create a new database (e.g., DW_Project).
Run the scripts in scripts/bronze/ to set up bronze layer and load raw data.
Run the scripts in scripts/silver/ to transform into the silver layer.
Run the scripts in scripts/gold/ to build analytic tables in the gold layer.

(Optional) Export gold tables to your analysis tool and explore via EDA scripts or queries.

Review docs/ for diagrams, data dictionary, and any additional notes.
