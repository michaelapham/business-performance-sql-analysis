-- ================================================
-- SUPERSTORE BUSINESS PERFORMANCE ANALYSIS
-- Tool: MySQL
-- Dataset: Superstore Sales Dataset (Kaggle)
-- ================================================

-- ================================================
-- SECTION 02: DATA EXPLORATION
-- Purpose: Understand the structure, contents, 
-- and quality of the dataset before cleaning and analysis
-- ================================================


-- 2.1 Preview the first 10 rows and table data types
-- to understand the structure and available fields
SELECT * 
FROM superstore_raw
LIMIT 10;

-- Finding: Dataset contains 21 columns covering order details,
-- customer info, product categories, and financial metrics
-- (sales, quantity, discount, profit) across U.S. regions.

-- 2.2 Check distinct product categories
SELECT DISTINCT Category
FROM superstore_raw;

-- Finding: Three categories — Furniture, 
-- Office Supplies, Technology.


-- 2.3 Check distinct regions
SELECT DISTINCT Region
FROM superstore_raw;

-- Finding: Four regions — South, West,
-- Central, East


-- 2.4 Check distinct customer segments
SELECT DISTINCT Segment
FROM superstore_raw;

-- Finding: Three segments — Consumer, 
-- Corporate, Home Office.


-- 2.5 Check distinct ship modes
SELECT DISTINCT `Ship Mode`
FROM superstore_raw;

-- Finding: Four ship modes — Second Class,
-- Standard Class, First Class, Same Day


-- 2.6 Check date range of dataset
SELECT 
    MIN(`Order Date`) AS earliest_order,
    MAX(`Order Date`) AS latest_order
FROM superstore_raw;

-- Finding: Date ranges from 1-2017 to 9-2017, which
-- is not correct. Due to dates stored as TEXT in raw table.
-- Accurate date parsing handled in 03_cleaning.


-- 2.7 Check for duplicate Order IDs
SELECT 
    `Order ID`, COUNT(*) AS cnt
FROM superstore_raw
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- Finding: Multiple rows per Order ID, which is expected
-- since one order can contain multiple products.


-- 2.8 Check for NULL or empty values 
-- across all key columns
SELECT
	SUM(`Order ID` IS NULL OR `Order ID` = '')
		AS order_id_null,
    SUM(`Customer Name` IS NULL OR `Customer Name` = '')
		AS customer_name_null,
    SUM(`Category` IS NULL OR `Category` = '')
		AS category_null,
    SUM(`Region` IS NULL OR `Region` = '')
		AS region_null,
    SUM(`Sales` IS NULL OR `Sales` = '')
		AS sales_null,
    SUM(`Profit` IS NULL OR `Profit` = '')
		AS profit_null
FROM superstore_raw;

-- Finding: No NULL or empty values across key columns.


-- 2.9 Check sales and profit value ranges
SELECT
    MIN(CAST(Sales AS DECIMAL(10,2))) AS min_sales,
    MAX(CAST(Sales AS DECIMAL(10,2))) AS max_sales,
    ROUND(AVG(CAST(Sales AS DECIMAL(10,2))), 2) 
        AS avg_sales,
    MIN(CAST(Profit AS DECIMAL(10,2))) AS min_profit,
    MAX(CAST(Profit AS DECIMAL(10,2))) AS max_profit,
    ROUND(AVG(CAST(Profit AS DECIMAL(10,2))), 2) 
        AS avg_profit
FROM superstore_raw;

-- Finding: 229.39 average sales (0, 22638.48) with an
-- average profit of $28.59 (-$6599.98, $8399.98).
-- Note: Negative profit values likely indicate
-- orders sold at a loss. Flagged for 
-- analysis in 04_analysis.


-- 2.9 Check distribution of orders by region
SELECT 
    Region, COUNT(*) AS order_count
FROM superstore_raw
GROUP BY Region
ORDER BY order_count DESC;

-- Finding: West had the most orders at 3203 orders,
-- East had 2848 orders,
-- Central had 2323 orders,
-- and South had the fewest orders at 1620 orders.


-- 2.10 Check distribution of orders by category
SELECT 
    Category, COUNT(*) AS order_count
FROM superstore_raw
GROUP BY Category
ORDER BY order_count DESC;

-- Finding: Office supplies had most orders at 6026 orders,
-- Furniture had 2121 orders.
-- Technology had fewest orders at 1847 orders.


-- 2.11 Check discount value range
SELECT
    MIN(CAST(Discount AS DECIMAL(4,2))) 
        AS min_discount,
    MAX(CAST(Discount AS DECIMAL(4,2))) 
        AS max_discount,
    ROUND(AVG(CAST(Discount AS DECIMAL(4,2))), 2) 
        AS avg_discount,
    COUNT(DISTINCT Discount) AS distinct_discount_values
FROM superstore_raw;

-- Finding: Discounts range from 0-99.99% discounts, with
-- an average of 33% discount.
-- Data quality note: Discount imported as TEXT.
-- Will be cast to DECIMAL in 03_cleaning.
