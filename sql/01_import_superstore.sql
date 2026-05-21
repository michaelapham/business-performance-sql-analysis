CREATE DATABASE superstore_sales;
USE superstore_sales;

-- ================================================
-- SUPERSTORE BUSINESS PERFORMANCE ANALYSIS
-- Tool: MySQL
-- Dataset: Superstore Sales Dataset (Kaggle)
-- ================================================

-- ================================================
-- SECTION 01: DATA IMPORTING
-- Purpose: Import raw original csv, with all TEXT type
-- and verify no data loss.
-- ================================================

-- 1.1 Create a new table, superstore_raw, with snake_case
-- columns and all TEXT types.
CREATE TABLE superstore_raw (
    row_id TEXT,
    order_id TEXT,
    order_date TEXT,
    ship_date TEXT,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales TEXT,
    quantity TEXT,
    discount TEXT,
    profit TEXT
);


-- 1.2 Rename original raw csv to "superstore.csv", and copy it into
-- MySQL file path. Then load the data into superstore_raw.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore.csv'
INTO TABLE superstore_raw
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 1.3 Verify table imported
SELECT * 
FROM superstore_raw
LIMIT 10;

-- Finding: Import seems to have been a success so far.


-- 1.4 Check number of rows of superstore_raw. Should equal original 9994 rows.
SELECT COUNT(*)
FROM superstore_raw;

-- Finding: superstore_raw contains all original 9994 rows.


-- 1.5 View all columns and types.
DESCRIBE superstore_raw;

-- Finding: All snake_case columns, all TEXT types and nullable.


-- 1.6 Verify number of columns in superstore_raw vs original superstore table (21).
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'superstore_raw';

-- Finding: Raw and original table number of columns match (21).


-- 1.7 Check that all discounts are between 0 and 1.
SELECT DISTINCT discount 
FROM superstore_raw 
ORDER BY discount;

-- Finding: All discounts between 0 and 1 (0, 0.8).


-- 1.8 Verify no empty rows were introduced during import.
SELECT COUNT(*)
FROM superstore_raw
WHERE order_id IS NULL 
   OR order_date IS NULL 
   OR Sales IS NULL;

-- Finding: 0 null values in key columns. Import is clean.



