Business Context: 

The M5 Weather App will help companies improve operational efficiencies, manage invenotry, and reduce waste. This will be established by prediciting daily unit sales 28 days in advance at the item-store level. This way retailers are able to make smarter decisions about restocking, pricing, and distrubtion of products. By having accurate forecasting this will help prevent overstock. The goal of this project is to build a data warehouse and forecasting pipeline. That will suport real-world business decisions using historical sales, calendar events, and pricing data. 



Project Success Criteria:

For this project, success means more than just building a model that runs. A successful outcome will include a well-designed data warehouse, a reproducible ETL process, and a forecasting model that performs well using a proper time-based validation approach.

From a technical standpoint, we want to ensure that:

The warehouse follows a clear star schema design.

Data can be loaded and validated consistently.

Forecasting models are evaluated fairly using appropriate error metrics.

The entire pipeline is documented and reproducible from raw data to final predictions.

Ultimately, a “good” project will demonstrate accuracy, organization, and the ability to support analytical queries and machine learning feature generation from the warehouse.


Project Plan Timeline
Week 5 – Understanding the Problem & Getting Organized
This week we focused on fully understanding what the M5 forecasting problem is asking. The goal is to predict 28 days of daily unit sales at the item–store level, so we made sure we understood the business impact behind that (inventory planning, reducing overstock, and improving decision-making).

We also set up our private GitHub repository and created the required folder structure. In addition, we drafted the data dictionary to better understand the structure, grain, and join keys of each dataset before moving into implementation.

Week 6 – Data Acquisition & Warehouse Design
In Week 6, we will download the required Kaggle datasets and document the download process for reproducibility.

We will perform initial data profiling, including checking row counts, identifying missing values, and verifying join keys.

We will also design our star schema (dim_date, dim_item, dim_store, fact_sales_daily, and fact_price_weekly) and create an ERD to clearly visualize table relationships and grain definitions. Initial SQL table definitions will also be drafted.

Week 7 – Building the Foundation
This week will focus on creating staging tables in PostgreSQL and loading the calendar and pricing datasets. We will then build the dimension tables and begin validating data integrity.

Week 8 – Transforming Sales Data
Because the sales dataset is in wide format, we will unpivot it into a long format so that each row represents one item, one store, and one specific day. This will allow us to properly build the fact_sales_daily table and align it with the rest of the warehouse.

Weeks 9–12 – Modeling & Evaluation
During these weeks, we will engineer features (lags and rolling averages), implement a baseline forecasting model, and then develop at least one machine learning model. We will evaluate performance using time-based validation and compare results using appropriate error metrics.

Week 13 – Final Review & Presentation






Team Role Assignment – Week 6
To ensure equal contribution and clear accountability, Week 6 responsibilities are divided as follows:

Data Acquisition & Profiling Lead
Responsibilities:

Download the M5 dataset from Kaggle and document the acquisition method

Add raw/ to .gitignore and create a file manifest

Perform initial data profiling (row counts, missing values, join key validation)

Document findings in docs/profiling_report.md

Deliverables:

File manifest

Profiling report

Updated README documentation

Warehouse Design & ERD Lead
Responsibilities:

Finalize star schema design

Define grain for fact tables

Create ERD diagram

Draft initial SQL DDL scripts (tables, primary keys, foreign keys, indexes)

Document design decisions

Deliverables:

ERD diagram in docs/

Initial DDL script in sql/ddl/

Design explanation in README





The final week will focus on polishing the warehouse, validating reproducibility, preparing our live demo, and finalizing documentation.


## Week 9 — ETL Load Note
Initially validated with first 500 items before scaling to full load.
Full load completed: 58,327,370 rows in fact_sales_daily.

