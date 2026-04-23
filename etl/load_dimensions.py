import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

conn = psycopg2.connect(dbname="m5_warehouse", user="chyna")
cur = conn.cursor()

sales = pd.read_csv(
    "raw/sales_train_validation.csv",
    usecols=["item_id", "dept_id", "cat_id", "store_id", "state_id"]
)

# dim_item
dim_item = sales[["item_id", "dept_id", "cat_id"]].drop_duplicates()
execute_values(
    cur,
    """
    INSERT INTO m5_warehouse.dim_item (item_id, dept_id, cat_id)
    VALUES %s
    ON CONFLICT (item_id) DO NOTHING
    """,
    [tuple(x) for x in dim_item.to_numpy()]
)

# dim_store
dim_store = sales[["store_id", "state_id"]].drop_duplicates()
execute_values(
    cur,
    """
    INSERT INTO m5_warehouse.dim_store (store_id, state_id)
    VALUES %s
    ON CONFLICT (store_id) DO NOTHING
    """,
    [tuple(x) for x in dim_store.to_numpy()]
)

# dim_date
cal = pd.read_csv("raw/calendar.csv")

date_cols = [
    "d", "date", "wm_yr_wk", "weekday", "wday", "month", "year",
    "event_name_1", "event_type_1", "event_name_2", "event_type_2",
    "snap_CA", "snap_TX", "snap_WI"
]

dim_date = cal[date_cols].copy()

for col in ["event_name_1", "event_type_1", "event_name_2", "event_type_2"]:
    dim_date[col] = dim_date[col].fillna("None")

for col in ["snap_CA", "snap_TX", "snap_WI"]:
    dim_date[col] = dim_date[col].astype(bool)

for col in ["event_name_1", "event_type_1", "event_name_2", "event_type_2"]:
    dim_date[col] = dim_date[col].fillna("None")

execute_values(
    cur,
    """
    INSERT INTO m5_warehouse.dim_date (
        d, date, wm_yr_wk, weekday, wday, month, year,
        event_name_1, event_type_1, event_name_2, event_type_2,
        snap_CA, snap_TX, snap_WI
    )
    VALUES %s
    ON CONFLICT (d) DO NOTHING
    """,
    [tuple(x) for x in dim_date.to_numpy()]
)

conn.commit()
cur.close()
conn.close()

print("Loaded dim_item, dim_store, dim_date")