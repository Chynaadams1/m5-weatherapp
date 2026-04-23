-- ML Features Table
-- Created: Week 11
-- Owner: Chyna Adams
-- Adds lag features (1, 7, 14, 28 days) and rolling averages (7, 28 days)
-- to support machine learning forecasting model

SET search_path TO m5_warehouse;

CREATE TABLE ml_features_daily AS
SELECT
    f.item_id, f.store_id, f.d,
    dd.date, dd.month, dd.year, dd.wm_yr_wk, dd.weekday, dd.event_name_1,
    f.units_sold,
    LAG(f.units_sold, 1)  OVER (PARTITION BY f.item_id, f.store_id ORDER BY f.d) AS lag_1,
    LAG(f.units_sold, 7)  OVER (PARTITION BY f.item_id, f.store_id ORDER BY f.d) AS lag_7,
    LAG(f.units_sold, 14) OVER (PARTITION BY f.item_id, f.store_id ORDER BY f.d) AS lag_14,
    LAG(f.units_sold, 28) OVER (PARTITION BY f.item_id, f.store_id ORDER BY f.d) AS lag_28,
    AVG(f.units_sold) OVER (
        PARTITION BY f.item_id, f.store_id ORDER BY f.d
        ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS rolling_avg_7,
    AVG(f.units_sold) OVER (
        PARTITION BY f.item_id, f.store_id ORDER BY f.d
        ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING) AS rolling_avg_28
FROM fact_sales_daily f
JOIN dim_date dd ON dd.d = f.d;

CREATE INDEX idx_ml_features ON ml_features_daily (item_id, store_id, d);
