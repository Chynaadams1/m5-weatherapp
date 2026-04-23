-- OLAP Query 2: Monthly sales trends by year
-- Chyna Adams - Week 10
SELECT 
    dd.year,
    dd.month,
    SUM(f.units_sold) AS total_units_sold,
    ROUND(AVG(f.units_sold), 2) AS avg_daily_units,
    COUNT(DISTINCT f.item_id) AS unique_items_sold
FROM m5_warehouse.fact_sales_daily f
JOIN m5_warehouse.dim_date dd ON dd.d = f.d
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;
