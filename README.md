# ecommerce-sql-analysis
SQL-based e-commerce sales and customer behavior analysis using MySQL, covering revenue trends, product performance, customer segmentation, and advanced SQL queries.

# E-Commerce Sales and Customer Behavior Analysis Using SQL

## Project Overview

This project analyzes e-commerce sales and customer behavior using **MySQL** and the Brazilian E-Commerce Public Dataset by Olist. The objective is to extract meaningful business insights from transactional data using SQL, focusing on revenue trends, product performance, order fulfillment, and customer purchasing patterns.

The project demonstrates practical SQL skills, including data cleaning, multi-table joins, aggregations, Common Table Expressions (CTEs), subqueries, and window functions.

## Objectives

- Analyze overall payment value and monthly revenue trends.
- Calculate average order value and examine order status distribution.
- Identify top-performing product categories and products by revenue.
- Analyze customer spending patterns and repeat purchasing behavior.
- Segment customers based on their spending.

## Dataset

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** [Kaggle – Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains anonymized e-commerce transactions from Brazil, covering approximately 100,000 orders placed between 2016 and 2018.

### Dataset Download Instructions

The raw CSV files are not included in this repository.

1. Open the [Olist dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Sign in to your Kaggle account.
3. Click **Download** to download the dataset ZIP file.
4. Extract the ZIP file on your computer.
5. Import the required CSV files into MySQL Workbench, following the database setup instructions below.

### Files Used

- `olist_customers_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_products_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_sellers_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `product_category_name_translation.csv`

## Tools and Technologies

- **Database:** MySQL
- **SQL Environment:** MySQL Workbench
- **Version Control:** Git and GitHub

## Database Setup

### 1. Create the Database

Create a database in MySQL Workbench:

```sql
CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;
```

### 2. Import the Dataset

Download and extract the CSV files from Kaggle. Import the required files into the `olist_ecommerce` database using the MySQL Workbench Table Data Import Wizard.

For files containing missing numeric values, use staging tables with text columns before converting the data into appropriate types.

### 3. Data Cleaning

The project uses staging tables to preserve the imported source data and separate cleaned tables for analysis.

Data preparation includes:
- Identifying missing values.
- Converting empty strings to `NULL` where appropriate.
- Converting numeric strings into numeric data types.
- Converting timestamp strings into date/time values.
- Validating record counts and relationships between tables.

## SQL Analysis and Business Questions

### 1. Sales Analysis
- What is the total recorded payment value?
- How does payment value change month over month?
- What is the average payment value per order?
- What is the distribution of orders by status?

### 2. Product Analysis
- Which product categories generate the highest revenue?
- Which individual products have the highest sales value?
- How can product categories be ranked using window functions?

### 3. Customer Analysis
- Who are the highest-spending customers?
- What proportion of customers make repeat purchases?
- How do customers differ across spending segments?

## Key Findings

The following findings were observed in the current analysis:

- **Total recorded payment value:** Approximately R$16.01 million.
- **Average payment value per order:** Approximately R$160.99.
- **Delivered orders:** 96,478 orders, representing 97.02% of all recorded orders.
- **Top product category:** Health and beauty, with approximately R$1.23 million in product revenue from delivered orders.
- **Repeat customers:** 2,801 customers, approximately 3.00% of the 93,358 customers with at least one delivered order.
- **Customer segmentation:** Customers were grouped into low-, medium-, and high-spending segments using project-defined spending thresholds.

These findings are descriptive and based on the imported dataset. Payment value and product revenue are different metrics, and the analysis distinguishes between them.

## Repository Structure

```text
ecommerce-sql-analysis/
│
├── README.md
└── sql/
    ├── 01_data_validation.sql
    ├── 02_data_cleaning.sql
    ├── 03_sales_analysis.sql
    ├── 04_product_analysis.sql
    ├── 05_customer_analysis.sql
```

The SQL scripts will contain the queries used for data validation, cleaning, sales analysis, product analysis, customer analysis, and advanced SQL exercises.

## Skills Demonstrated

- Relational database concepts
- Data cleaning and validation
- SQL joins and aggregations
- CTEs and subqueries
- Window functions
- Revenue and customer behavior analysis
- Business insight generation

## Limitations

- The dataset covers a historical period and may not represent current e-commerce behavior.
- Missing values and the review import warning require validation before finalizing all findings.
- Customer spending thresholds are defined for this project and are not official business classifications.
- Revenue calculations based on product prices exclude freight charges, while payment totals may include other order-related amounts.

## Conclusion

This project demonstrates how SQL can be used to transform raw e-commerce transaction data into structured analysis and actionable business observations. It combines data preparation, exploratory analysis, and advanced querying to investigate sales performance, product categories, and customer purchasing behavior.
