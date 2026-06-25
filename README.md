# M5 Demand Forecasting — Data Warehouse & ML Pipeline

A capstone data engineering and machine learning project built for CSDP 431 (Data Warehousing & Decision Support) at the University of Maryland Eastern Shore. The goal was to predict daily unit sales 28 days in advance at the item-store level using the Kaggle M5 Forecasting dataset.

---

## Project Overview

Retailers lose significant revenue from overstock and stockouts. This project addresses that problem by building a full end-to-end forecasting pipeline — from raw Kaggle data to a production-ready PostgreSQL data warehouse and a trained XGBoost model — that gives retailers the ability to make smarter decisions about restocking, pricing, and distribution.

**Key results:**
- Loaded **58,327,370 rows** into `fact_sales_daily`
- XGBoost MAE: **1.0010** | RMSE: **1.9755**
- Baseline MAE: **1.1912** | RMSE: **2.5743**

---

## Tech Stack

| Layer | Tools |
|---|---|
| Database | PostgreSQL (schema: `m5_warehouse`, port: 5433) |
| ETL | Python, pandas `.melt()` for wide-to-long unpivoting |
| Modeling | Python, XGBoost, time-based cross-validation |
| Schema Design | Star schema (3 dimensions, 2 fact tables) |
| Docs | draw.io ERD, Markdown, PowerPoint |

---

## Data Sources (Kaggle M5 Forecasting)

| File | Description |
|---|---|
| `calendar.csv` | One row per day — dates, weekdays, events, SNAP indicators |
| `sell_prices.csv` | Weekly item prices per store |
| `sales_train_validation.csv` | Historical daily sales in wide format (1,919 day columns) |
| `sales_train_evaluation.csv` | Extended dataset used for final model evaluation |
| `sample_submission.csv` | Required output format — 28-day forecast per item-store |

---

## Warehouse Design

The warehouse follows a **star schema** stored in the `m5_warehouse` PostgreSQL schema.

### Dimension Tables
- **`dim_date`** — date, weekday, month, year, event flags, SNAP indicators
- **`dim_item`** — item ID, department, category
- **`dim_store`** — store ID, state

### Fact Tables
- **`fact_sales_daily`** — grain: item × store × day | tracks daily units sold
- **`fact_price_weekly`** — grain: item × store × week | tracks weekly sell price

### Staging Tables
- `stg_calendar`, `stg_sell_prices` — raw data landing zone before transformation

An ETL load log (`etl_load_log`) tracks every load stage, row count, and status.

---

## ETL Process

The sales dataset arrives in wide format with one row per item-store and 1,919 daily columns (`d_1` to `d_1919`). Loading it required:

1. **Chunked unpivoting** — processed 100 rows at a time using `pandas.melt()` to convert wide → long format without running out of memory
2. **Dimension loading** — `etl/load_dimensions.py` handles `dim_date`, `dim_item`, `dim_store`
3. **Fact loading** — `etl/load_fact_sales.py` loads the unpivoted sales rows into `fact_sales_daily`

Full load result: **58,327,370 rows** in `fact_sales_daily`.

---

## Modeling & Results

Features engineered from the warehouse included lag values and rolling averages. A baseline model was implemented first, followed by an XGBoost model evaluated using time-based validation.

| Model | MAE | RMSE |
|---|---|---|
| Baseline | 1.1912 | 2.5743 |
| **XGBoost** | **1.0010** | **1.9755** |

XGBoost reduced MAE by ~16% and RMSE by ~23% over the baseline.

---

## Repo Structure

```
m5-weatherapp-main/
├── docs/
│   ├── data_dictionary_draft.md
│   ├── data_quality_report.md
│   ├── demo_runbook.md
│   └── m5_star_schema.drawio.png
├── etl/
│   ├── load_dimensions.py
│   └── load_fact_sales.py
├── sql/
│   ├── ddl/
│   │   ├── create_tables.sql
│   │   └── create_ml_features.sql
│   ├── queries/
│   │   ├── olap_monthly_sales_trends.sql
│   │   ├── olap_price_vs_sales.sql
│   │   ├── olap_sales_by_category_state.sql
│   │   └── olap_top_items_per_store.sql
│   └── 02_ml_features_daily.sql
└── README.md
```

---

## Team

| Role | Responsibilities |
|---|---|
| **Warehouse Design & SQL Lead** | Star schema design, DDL scripts, ERD, OLAP queries |
| **Data Acquisition & Profiling Lead** | Dataset download, profiling report, file manifest, ETL scripting |

---

*CSDP 431 — Data Warehousing & Decision Support | University of Maryland Eastern Shore | Spring 2026*
Initially validated with first 500 items before scaling to full load.
Full load completed: 58,327,370 rows in fact_sales_daily.

