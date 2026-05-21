-- ================================================
-- SUPERSTORE BUSINESS PERFORMANCE ANALYSIS
-- Tool: MySQL
-- Dataset: Superstore Sales Dataset (Kaggle)
-- ================================================

-- ================================================
-- SECTION 03: DATA CLEANING
-- Purpose: Create superstore_clean from superstore_raw with
-- snake_case column names, proper types, standardized values,
-- handled empty/null cases, removing duplicates.
-- ================================================

-- 3.1 Create superstore_clean from superstore_raw
-- to fix column names and data types
CREATE TABLE superstore_clean AS
SELECT
	TRIM(row_id) AS row_id,
    TRIM(order_id) AS order_id,
    STR_TO_DATE(order_date, '%m/%d/%Y') AS order_date,
    STR_TO_DATE(ship_date, '%m/%d/%Y') AS ship_date,
    TRIM(ship_mode) AS ship_mode,
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(segment) AS segment,
    TRIM(country) AS country,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(postal_code) AS postal_code,
    TRIM(region) AS region,
    TRIM(product_id) AS product_id,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    TRIM(product_name) AS product_name,
    CAST(sales AS DECIMAL(10,2)) AS sales,
    CAST(quantity AS UNSIGNED) AS quantity,
    CAST(discount AS DECIMAL(5,2)) AS discount,
    CAST(profit AS DECIMAL(10,2)) AS profit
FROM superstore_raw;

-- Note: LOAD DATA INFILE with CHARACTER SET latin1
-- resolved the previous column misalignment that
-- corrupted several columns (quantity, sales, discount)
-- during the original Table Data Import Wizard attempt.


-- 3.2 Verify row count matches superstore_raw.
-- Should equal 9994.
SELECT COUNT(*) AS total_rows
FROM superstore_clean;

-- Finding: All 9994 rows preserved through cleaning.


-- 3.3 Verify column types converted correctly
DESCRIBE superstore_clean;

-- Finding: Dates now DATE type, numeric fields DECIMAL
-- or UNSIGNED INT, all text fields TEXT.


-- 3.4 Verify date conversion worked correctly
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM superstore_clean;

-- Finding: Earliest order is now "2014-01-03"
-- and latest order is now "2017-12-30."
-- Dates now parse correctly as DATE type,
-- resolving the TEXT sorting issue.


-- 3.5 Verify no data loss on numeric conversions
SELECT
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount
FROM superstore_clean;

-- Finding: Numeric ranges match findings from 02_exploration
-- which signals no data loss during type casting.


-- 3.6 Spot check a few rows to visually confirm
-- that cleaning looks correct
SELECT *
FROM superstore_clean
LIMIT 20;

-- Finding: snake_case column names,
-- dates display as YYYY-MM-DD format,
-- numeric fields display as decimals or integers,
-- TRIM() applied to text fields.

