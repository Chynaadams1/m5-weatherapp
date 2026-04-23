import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="m5_warehouse",
    user="chyna"
)
cur = conn.cursor()

print("Starting sales unpivot and load...")

chunk_size = 100
total_rows = 0
chunk_num = 0

reader = pd.read_csv(
    "/Users/chyna/Downloads/m5-weatherapp-main/raw/sales_train_validation.csv",
    chunksize=chunk_size
)

for chunk in reader:
    chunk_num += 1

    id_cols = ["item_id", "store_id"]
    day_cols = [c for c in chunk.columns if c.startswith("d_")]

    long = chunk[id_cols + day_cols].melt(
        id_vars=id_cols,
        var_name="d",
        value_name="units_sold"
    )

    rows = [
        (row["item_id"], row["store_id"], row["d"], int(row["units_sold"]))
        for _, row in long.iterrows()
    ]

    execute_values(
        cur,
        """
        INSERT INTO m5_warehouse.fact_sales_daily (item_id, store_id, d, units_sold)
        VALUES %s
        ON CONFLICT DO NOTHING
        """,
        rows
    )

    conn.commit()
    total_rows += len(rows)
    print(f"Chunk {chunk_num} done — {total_rows:,} rows loaded so far")

cur.close()
conn.close()
print(f"\nDone! Total rows loaded: {total_rows:,}")