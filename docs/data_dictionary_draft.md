This section summarizes the structure of each raw dataset file used in the M5 Forecasting.
The warehouse design will depend on accurate relationships between sales, prices, and calendar data, so understanding the structure of each file is essential.

This warehouse will depend on accurate relationships between sales, prices, and calendar data.

Calendar.csv
Grain: One row per day (d)

This table provides calendar-related information for each date in the dataset. It connects daily sales to real-world calendar attributes such as weekday, month, year, events, and SNAP program indicators.

Important Columns:

date — Actual calendar date

d — Day identifier (e.g., d_1, d_2, ...)

wm_yr_wk — Week identifier (used to join with price data)

weekday — Name of the day (Monday, Tuesday, etc.)

month — Month number

year — Year

event_name_1, event_type_1 — Special events (if applicable)

snap_CA, snap_TX, snap_WI — SNAP program indicators by state

Purpose in Warehouse:
This file will be used to build the dim_date dimension table.

sell_prices.csv
Grain: One row per item × store × week

This dataset contains the weekly selling price for each item in each store. Unlike the sales data, prices are recorded at the weekly level rather than daily. Because of this, we will need to join prices to daily sales using the wm_yr_wk field from the calendar table. 

Important Columns:

store_id – Store identifier

item_id – Item identifier

wm_yr_wk – Week identifier (used to align with calendar data)

sell_price – Weekly selling price of the item


sales_train_validation.csv
Grain: One row per item × store (wide format)

This dataset contains the historical daily unit sales for each item in each store. Unlike a traditional transactional table, the daily sales are stored in a wide format, meaning each day is represented as a separate column (d_1, d_2, ..., d_1913).

Because of this structure, the table will need to be transformed (unpivoted) into a long format before it can be loaded into the warehouse and used for modeling.

Important Columns:

item_id – Unique identifier for each product

dept_id – Department identifier

cat_id – Category identifier

store_id – Store identifier

state_id – State identifier

d_1 to d_1913 – Daily unit sales values

Purpose in Warehouse:
This file will be transformed into the fact_sales_daily fact table with the grain:

item_id × store_id × date

The wide daily columns will be unpivoted so that each row represents one item, one store, and one specific day with a corresponding units_sold value.



sales_train_evaluation.csv
Grain: One row per item × store (wide format)

This dataset has the same structure as sales_train_validation.csv, but it extends further into the forecast period. It is primarily used for final model evaluation and submission comparison in the competition setting.

Like the validation dataset, daily sales are stored in a wide format (d_1 to later day columns), which means it must also be unpivoted into a long format before being used in the warehouse.

Important Columns:

item_id – Unique identifier for each product

dept_id – Department identifier

cat_id – Category identifier

store_id – Store identifier

state_id – State identifier

Daily columns (d_1 onward) – Daily unit sales values

Purpose in Warehouse:
This file can be used for extended evaluation and testing. If included in the warehouse, it would follow the same transformation process as the validation dataset and load into fact_sales_daily.

sample_submission.csv
Grain: One row per item × store forecast

This dataset provides the required format for forecast submission. It includes identifiers for each item-store combination along with placeholder columns for the 28-day forecast horizon.

Important Columns:

id – Item-store identifier

F1 to F28 – Forecasted daily unit sales for the 28-day horizon

Purpose in Warehouse / Modeling:
This file defines the required output format for predictions. While it is not used in warehouse construction, it guides how final model predictions should be structured.





Purpose in Warehouse:
This file will be used to build the fact_price_weekly fact table. It will later be joined with dim_date (via wm_yr_wk) and with item/store dimensions for modeling and analytics.

## Unpivot Strategy — Week 9

### Approach
Used Python pandas `.melt()` to convert sales data from wide to long format.

### Why pandas melt?
- sales_train_validation.csv has 1,919 day columns (d_1 to d_1919)
- Each row needs to become multiple rows (one per day)
- pandas melt() handles this efficiently

### Chunked Loading
- Processed 100 rows at a time to avoid memory issues
- Script: etl/load_fact_sales.py

### Output Schema
| Column | Type | Description |
|---|---|---|
| item_id | VARCHAR(50) | Product identifier |
| store_id | VARCHAR(20) | Store identifier |
| d | VARCHAR(10) | Day identifier (d_1 to d_1969) |
| units_sold | SMALLINT | Daily units sold (≥ 0) |
