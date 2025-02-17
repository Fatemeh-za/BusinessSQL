# Data-Analytics-SQL

This repository contains SQL scripts for automating database maintenance tasks and performing sales analysis on the Northwind database. It includes triggers, stored procedures, SQL Server Agent jobs, views, and analytical queries.

## Features

### Database Maintenance Automation

- **Prevent Unauthorized Deletions:**
  - Implements a trigger (`PreventOrderDeletion`) to prevent accidental or unauthorized deletions from the `Orders` table.
  
- **Low Stock Alerts:**
  - A stored procedure (`LowStockAlert`) that checks for products with stock levels below their reorder threshold and logs alerts.
  
- **Automated Job for Low Stock Alerts:**
  - A SQL Server Agent job (`LowStockAlertJob`) that executes the `LowStockAlert` procedure daily to monitor inventory levels.

### Sales Data Aggregation & Analysis

- **Sales Summary View (`SalesSummary`):**
  - Precomputes sales metrics by joining multiple tables to enhance query performance.

- **Monthly Sales Trends:**
  - Aggregates sales data per category and computes monthly revenue.

- **Top Revenue-Generating Customers:**
  - Identifies the top 10 customers based on total revenue.

- **Customer Purchase Frequency Analysis:**
  - Computes the average time between purchases for each customer to analyze buying behavior.

## SQL Scripts Included

- **customer_behavior_analysis.sql**  
  Analyzes customer behavior patterns and purchasing trends.

- **employee_performance.sql**  
  Assesses employee performance based on sales data and customer interactions.

- **inventory_management.sql**  
  Provides insights into inventory levels, low-stock products, and stock trends.

- **maintenance_automation.sql**  
  Contains triggers, stored procedures, and SQL Server Agent job definitions for database maintenance.

## Setup Instructions

### Prerequisites

- SQL Server installed and running
- Northwind database loaded
- SQL Server Agent enabled (for scheduled jobs)

### Installation Steps

1. Execute `maintenance_automation.sql` in the Northwind database:

   ```sql
   USE Northwind;
   GO
   -- Run the SQL script to create triggers, procedures, and jobs


2. Verify SQL Server Agent is enabled (for automation features):

   ```sql
   EXEC sp_configure 'show advanced options', 1;
   RECONFIGURE;
   EXEC sp_configure 'Agent XPs', 1;
   RECONFIGURE;

3. Execute SalesAnalysis.sql as needed to run the sales analysis queries.

Usage

  Automated Low Stock Alerts:
  The job runs daily and inserts low-stock notifications into the InventoryAlerts table.

  Prevent Order Deletions:
  Any attempt to delete orders will be blocked with an error message.

  Sales Reports:
  Use the provided queries to extract insights into sales trends, top customers, and purchase frequencies.
