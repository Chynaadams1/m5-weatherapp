DROP TABLE IF EXISTS m5_warehouse.ml_features_daily;

CREATE TABLE m5_warehouse.ml_features_daily AS
WITH sales AS (
    SELECT
        f.item_id,
        f.store_id,
        f.d,
        f.units_sold
    FROM m5_warehouse.fact_sales_daily f
)
SELECT
    s.item_id,
    s.store_id,
    s.d,
    s.units_sold,

    LAG(s.units_sold, 1)  OVER w AS lag_1,
    LAG(s.units_sold, 7)  OVER w AS lag_7,
    LAG(s.units_sold, 14) OVER w AS lag_14,
    LAG(s.units_sold, 28) OVER w AS lag_28,

    AVG(s.units_sold) OVER (
        PARTITION BY s.item_id, s.store_id
        ORDER BY s.d
        ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
    ) AS rolling_avg_7,

    AVG(s.units_sold) OVER (
        PARTITION BY s.item_id, s.store_id
        ORDER BY s.d
        ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
    ) AS rolling_avg_28

FROM sales s
WINDOW w AS (PARTITION BY s.item_id, s.store_id ORDER BY s.d);