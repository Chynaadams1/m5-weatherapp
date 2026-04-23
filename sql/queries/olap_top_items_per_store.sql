-- OLAP Query 4: Top selling items per store
-- Chyna Adams - Week 10
SELECT 
    f.store_id,
    f.item_id,
    di.cat_id,
    SUM(f.units_sold) AS total_units_sold
FROM m5_warehouse.fact_sales_daily f
JOIN m5_warehouse.dim_item di ON di.item_id = f.item_id
GROUP BY f.store_id, f.item_id, di.cat_id
ORDER BY f.store_id, total_units_sold DESC
LIMIT 50;
