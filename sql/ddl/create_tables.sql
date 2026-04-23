-- =============================================================================
-- CSDP 431 | M5 Forecasting Data Warehouse
-- File:    sql/ddl/create_tables.sql
-- Author:  Person 2
-- Week:    7
-- =============================================================================

-- Schema Setup
CREATE SCHEMA IF NOT EXISTS m5_warehouse;
SET search_path TO m5_warehouse, public;

-- =============================================================================
-- STAGING TABLES
-- =============================================================================

DROP TABLE IF EXISTS stg_calendar    CASCADE;
DROP TABLE IF EXISTS stg_sell_prices CASCADE;

CREATE TABLE stg_calendar (
    date         TEXT,
    wm_yr_wk     TEXT,
    weekday      TEXT,
    wday         TEXT,
    month        TEXT,
    year         TEXT,
    d            TEXT,
    event_name_1 TEXT,
    event_type_1 TEXT,
    event_name_2 TEXT,
    event_type_2 TEXT,
    snap_CA      TEXT,
    snap_TX      TEXT,
    snap_WI      TEXT
);

CREATE TABLE stg_sell_prices (
    store_id   TEXT,
    item_id    TEXT,
    wm_yr_wk   TEXT,
    sell_price TEXT
);

-- =============================================================================
-- DIMENSION TABLES
-- =============================================================================

DROP TABLE IF EXISTS dim_date  CASCADE;
DROP TABLE IF EXISTS dim_item  CASCADE;
DROP TABLE IF EXISTS dim_store CASCADE;

CREATE TABLE dim_date (
    d            VARCHAR(10) NOT NULL,
    date         DATE        NOT NULL,
    wm_yr_wk     INT         NOT NULL,
    weekday      VARCHAR(10) NOT NULL,
    wday         SMALLINT    NOT NULL,
    month        SMALLINT    NOT NULL,
    year         SMALLINT    NOT NULL,
    event_name_1 VARCHAR(100),
    event_type_1 VARCHAR(50),
    event_name_2 VARCHAR(100),
    event_type_2 VARCHAR(50),
    snap_CA      BOOLEAN NOT NULL DEFAULT FALSE,
    snap_TX      BOOLEAN NOT NULL DEFAULT FALSE,
    snap_WI      BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_dim_date PRIMARY KEY (d)
);

CREATE INDEX idx_dim_date_date     ON dim_date (date);
CREATE INDEX idx_dim_date_wm_yr_wk ON dim_date (wm_yr_wk);

CREATE TABLE dim_item (
    item_id VARCHAR(50) NOT NULL,
    dept_id VARCHAR(50) NOT NULL,
    cat_id  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_dim_item PRIMARY KEY (item_id)
);

CREATE INDEX idx_dim_item_dept ON dim_item (dept_id);
CREATE INDEX idx_dim_item_cat  ON dim_item (cat_id);

CREATE TABLE dim_store (
    store_id VARCHAR(20) NOT NULL,
    state_id VARCHAR(5)  NOT NULL,
    CONSTRAINT pk_dim_store PRIMARY KEY (store_id)
);

CREATE INDEX idx_dim_store_state ON dim_store (state_id);

-- =============================================================================
-- FACT TABLES
-- =============================================================================

DROP TABLE IF EXISTS fact_sales_daily  CASCADE;
DROP TABLE IF EXISTS fact_price_weekly CASCADE;

CREATE TABLE fact_sales_daily (
    item_id    VARCHAR(50) NOT NULL,
    store_id   VARCHAR(20) NOT NULL,
    d          VARCHAR(10) NOT NULL,
    units_sold SMALLINT    NOT NULL CHECK (units_sold >= 0),
    CONSTRAINT pk_fact_sales_daily PRIMARY KEY (item_id, store_id, d),
    CONSTRAINT fk_sales_item  FOREIGN KEY (item_id)  REFERENCES dim_item  (item_id),
    CONSTRAINT fk_sales_store FOREIGN KEY (store_id) REFERENCES dim_store (store_id),
    CONSTRAINT fk_sales_date  FOREIGN KEY (d)        REFERENCES dim_date  (d)
);

CREATE INDEX idx_fact_sales_store_item_d ON fact_sales_daily (store_id, item_id, d);
CREATE INDEX idx_fact_sales_d            ON fact_sales_daily (d);

CREATE TABLE fact_price_weekly (
    item_id    VARCHAR(50)   NOT NULL,
    store_id   VARCHAR(20)   NOT NULL,
    wm_yr_wk   INT           NOT NULL,
    sell_price NUMERIC(10,2) NOT NULL CHECK (sell_price > 0),
    CONSTRAINT pk_fact_price_weekly PRIMARY KEY (item_id, store_id, wm_yr_wk),
    CONSTRAINT fk_price_item  FOREIGN KEY (item_id)  REFERENCES dim_item  (item_id),
    CONSTRAINT fk_price_store FOREIGN KEY (store_id) REFERENCES dim_store (store_id)
);

CREATE INDEX idx_fact_price_item_store_wk ON fact_price_weekly (item_id, store_id, wm_yr_wk);
CREATE INDEX idx_fact_price_wm_yr_wk      ON fact_price_weekly (wm_yr_wk);

-- =============================================================================
-- ETL LOAD LOG
-- =============================================================================

DROP TABLE IF EXISTS etl_load_log CASCADE;

CREATE TABLE etl_load_log (
    log_id      SERIAL       PRIMARY KEY,
    table_name  VARCHAR(100) NOT NULL,
    load_stage  VARCHAR(20)  NOT NULL,
    rows_loaded INT,
    load_status VARCHAR(20)  NOT NULL DEFAULT 'success',
    notes       TEXT,
    loaded_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
