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

-- 1.1 Verify table imported
SELECT * 
FROM superstore_raw
LIMIT 10;

-- Finding: Original table imported, with TEXT types.


-- 1.2 Check number of rows of superstore_raw. Should equal original 9994 rows.
SELECT COUNT(*)
FROM superstore_raw;

-- Finding: superstore_raw contains all original 9994 rows.


-- 1.3 View all columns and types.
DESCRIBE superstore_raw;

-- Finding: All original columns, all TEXT types.


-- 1.4 Verify number of columns in superstore_raw vs original superstore table (21).
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'superstore_raw';

-- Finding: Raw and original table number of columns match (21).


-- 1.5 Verify no empty rows were introduced during import.
SELECT COUNT(*)
FROM superstore_raw
WHERE `Order ID` IS NULL 
   OR `Order Date` IS NULL 
   OR Sales IS NULL;

-- Finding: 0 null values in key columns. Import is clean.



