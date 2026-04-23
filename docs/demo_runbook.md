# Demo Runbook — Week 13 Final Presentation

## Overview
During Weeks 12 and 13, we extended the project from a completed data warehouse into a full forecasting pipeline. This includes feature engineering, model predictions, validation, and performance evaluation.

This demo shows that the system works end-to-end:
data warehouse → feature engineering → predictions → evaluation → analytics queries

---

## Step 1 — Build Feature Table

Run:
02_ml_features_daily.sql

This step:
- Creates ml_features_daily
- Adds lag features (lag_1, lag_7, lag_14, lag_28)
- Adds rolling averages (rolling_avg_7, rolling_avg_28)
- Ensures all features use only past data (no leakage)

---

## Step 2 — Create Predictions Table

Run:
03_predictions_daily.sql

This step:
- Creates predictions_daily table
- Stores both baseline and ML predictions
- Uses model_name to distinguish models

---

## Step 3 — Add Indexes

Run:
01_create_indexes.sql

This step:
- Improves performance on large datasets
- Speeds up joins and queries
- Prevents full-table scans across millions of rows

---

## Step 4 — Update Statistics

Run:
ANALYZE fact_sales_daily;
ANALYZE fact_price_weekly;
ANALYZE ml_features_daily;
ANALYZE predictions_daily;

This step:
- Updates PostgreSQL query planner
- Ensures indexes are used efficiently

---

## Step 5 — Run Validation Checks

Run:
04_validation_checks.sql

This step confirms:
- No unexpected NULL values
- No duplicate (item_id, store_id, d)
- No orphan keys
- No data leakage in lag features
- Correct train/validation split

---

## Step 6 — Load Predictions

Insert:
- Baseline predictions (seasonal_naive)
- ML predictions (xgboost)

This step ensures:
- Both models exist in predictions_daily
- Dates align correctly
- No duplicate rows

---

## Step 7 — Compare Models

Run:
06_baseline_vs_ml.sql

This step:
- Calculates MAE and RMSE
- Compares baseline vs ML model
- Confirms ML model improves performance

---

## Step 8 — Breakdown Analysis

Run:
07_breakdown_by_category.sql

This step:
- Compares model performance by category
- Identifies where ML performs best

---

## Step 9 — Live Demo Queries (REQUIRED)

### OLAP Query
Run:
08_olap_monthly_by_state.sql

Shows:
- Sales and revenue by month and state

---

### Forecast Query (Top 100 Demand)

Run:
05_top100_predicted_demand.sql

Shows:
- Top 100 predicted item-store pairs
- Uses ML model predictions

---

## Summary

This demo confirms that:

- The warehouse supports large-scale analytics
- Feature engineering is correct and validated
- Predictions are stored and queryable
- ML model outperforms baseline
- The system works end-to-end