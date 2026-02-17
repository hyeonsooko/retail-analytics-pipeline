# retail-analytics-pipeline

1\. Project Overview
--------------------

This project implements an end-to-end retail analytics pipeline that ingests raw transactional data, transforms it into an analytics-ready star schema, and delivers executive KPIs through a Power BI dashboard.

The focus of this project is not visualization alone, but:

*   Data modeling (fact + dimension design)
*   Incremental ETL workflows
*   Data quality validation
*   Query performance optimization
*   Business-aligned KPI reporting

2\. Architecture
----------------

### Data Flow
Raw CSV

   ↓
   
Python Ingestion Script

   ↓
   
PostgreSQL (raw staging layer)

   ↓
   
SQL Transformations

   ↓
   
Star Schema (fact_sales + dimensions)

   ↓
   
Power BI (ODBC connection)


### Tech Stack

*   PostgreSQL (Docker)    
*   Python (pandas, psycopg2)  
*   SQL   
*   Power BI Desktop 
*   ODBC Driver (PostgreSQL)

3\. Dataset
-----------

Dataset: Retail Transaction Dataset (~100k rows)

Contains:

*   Transaction timestamp
*   Customer identifier 
*   Product identifier
*   Product category 
*   Quantity
*   Unit price
*   Discount
*   Payment method
*   Store location

4\. Data Model
--------------

### Fact Table

**fact\_sales**

Grain:

> One row per product-line transaction record.

Key fields:

*   date\_id
*   customer\_id
*   product\_id   
*   store\_location    
*   payment\_method    
*   quantity    
*   gross\_amount    
*   discount\_amount    
*   net\_amount    

### Dimension Tables

**dim\_date**

*   date\_id    
*   day    
*   month    
*   year    
*   day\_of\_week    

**dim\_product**

*   product\_id    
*   product\_category    

**dim\_customer**

*   customer\_id    
*   first\_purchase\_date    
*   total\_orders    

### Why Star Schema?

*   Optimized for BI query performance    
*   Clear separation of descriptive attributes    
*   Simplified joins for reporting tools    
*   Supports scalable fact table growth


<img width="1024" height="702" alt="Screenshot 2026-02-17 111924" src="https://github.com/user-attachments/assets/c5078051-b02d-4f02-b7c1-76f94bcc3897" />

5\. ETL Workflow
----------------

### Step 1 – Ingestion

*   Raw CSV loaded via Python    
*   Schema validated    
*   Data inserted into raw\_transactions    
*   Ingestion logged    

### Step 2 – Transformation

*   Derived financial metrics:    
    *   gross\_amount        
    *   discount\_amount        
    *   net\_amount
        
*   Populated dimension tables using DISTINCT + aggregations    
*   Loaded fact\_sales table    

### Step 3 – Incremental Loading

*   etl\_run\_control table tracks last processed timestamp    
*   Fact table loads only new records    
*   Prevents duplicate ingestion    

6\. Data Quality Strategy
-------------------------

Implemented validation checks:

*   quantity > 0    
*   Non-null required keys    
*   Discount null handling    
*   Error logging into etl\_error\_log    

Invalid records are logged rather than silently dropped.

This ensures auditability and reliability.

7\. Performance Optimization
----------------------------

Applied indexing strategy:

*   Index on fact\_sales(date\_id)    
*   Index on fact\_sales(customer\_id)    
*   Index on fact\_sales(product\_id)    

Validated performance using EXPLAIN ANALYZE.

Incremental load design reduces full-table scans.

8\. Business KPIs
-----------------

Power BI Executive Dashboard includes:

*   Total Sales    
*   Revenue per Customer    
*   Average Line Value    
*   Total Quantity Sold    
*   Sales Trend Over Time    
*   Sales by Product Category    
*   Sales by Payment Method    

Interactive filtering:

*   Date range    
*   Product category    
*   Store location

<img width="1120" height="671" alt="Screenshot 2026-02-17 115937" src="https://github.com/user-attachments/assets/badae049-25bb-4eb0-accd-13442c05c213" />

9\. Key Engineering Decisions
-----------------------------

*   Preserved raw layer for traceability
*   Avoided cleaning data in staging
*   Defined explicit grain for fact table
*   Used append-only fact loading
*   Separated transformation logic from ingestion
    

10\. Future Improvements
------------------------

*   Orchestration with Airflow    
*   dbt transformation layer    
*   Partitioned fact table    
*   DirectQuery mode for real-time BI    
*   CI/CD integration

