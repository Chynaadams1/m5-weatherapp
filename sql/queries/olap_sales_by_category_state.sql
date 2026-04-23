-- OLAP Query 1: Total units sold by category and state
-- Chyna Adams - Week 10
SELECT 
    di.cat_id,
    ds.state_id,
    SUM(f.units_sold) AS total_units_sold,
    ROUND(AVG(f.units_sold), 2) AS avg_daily_units
FROM m5_warehouse.fact_sales_daily f
JOIN m5_warehouse.dim_item di ON di.item_id = f.item_id
JOIN m5_warehouse.dim_store ds ON ds.store_id = f.store_id
GROUP BY di.cat_id, ds.state_id
ORDER BY total_units_sold DESC;
