-- OLAP Query 3: End-to-end join — sales + calendar + prices
-- Chyna Adams - Week 10
SELECT 
    f.item_id,
    f.store_id,
    dd.date,
    dd.wm_yr_wk,
    dd.event_name_1,
    f.units_sold,
    p.sell_price
FROM m5_warehouse.fact_sales_daily f
JOIN m5_warehouse.dim_date dd ON dd.d = f.d
JOIN m5_warehouse.fact_price_weekly p 
    ON p.item_id = f.item_id 
    AND p.store_id = f.store_id 
    AND p.wm_yr_wk = dd.wm_yr_wk
WHERE dd.event_name_1 IS NOT NULL
LIMIT 20;
