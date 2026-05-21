-- ================================================
-- SUPERSTORE BUSINESS PERFORMANCE ANALYSIS
-- Tool: MySQL
-- Dataset: Superstore Sales Dataset (Kaggle)
-- ================================================

-- ================================================
-- SECTION 04: BUSINESS PERFORMANCE ANALYSIS
-- Purpose: Answer seven core business questions
-- to identify profitability drivers,
-- underperforming segments, and growth
-- opportunities across the superstore portfolio.
-- All queries run on superstore_clean.
-- ================================================


-- ================================================
-- QUESTION 1: Which product categories are most
-- and least profitable?
-- ================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- Finding: Technology has the highest profit margin
-- percentage with a 17.4% profit margin.
-- Office Supplies 17.0% profit margin.
-- Furniture significantly underperforms at 2.49%
-- despite similar sales volume to other categories.
-- Should investigate Furniture and its sub-categories further.


-- ================================================
-- QUESTION 2: Which sub-categories are
-- losing money?
-- ================================================

SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY category, sub_category
ORDER BY total_profit ASC;

-- Finding: Furniture (Tables) shows significant NEGATIVE
-- total profit of -$17,725.59. Tables are the primary
-- reason for Furniture underperforming.
-- Furniture (Bookcases) shows NEGATIVE
-- total profit of -$3,472.56.
-- Office Supplies (Supplies) also shows slight NEGATIVE
-- total profit of -$1,188.99.


-- ================================================
-- QUESTION 3: Which regions generate the most
-- sales vs. most profit? Are they the same?
-- ================================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY region
ORDER BY total_profit DESC;

-- Finding: West had highest total sales (725,457.93)
-- AND highest total profit ($108,418.79).


-- ================================================
-- QUESTION 4: Which states are the top 5 and
-- bottom 5 by total profit?
-- ================================================

-- Top 5 states by profit
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_clean
GROUP BY state
ORDER BY total_profit DESC
LIMIT 5;

-- Finding: The TOP 5 states by total profit are
-- 1) California
-- 2) New York
-- 3) Washington
-- 4) Michigan
-- 5) Virginia

-- Note: California has 47.2% MORE sales than New York,
-- BUT VERY SIMILAR total profit ($76,381.60 VS $74,038.64).
-- May be worth investigating for discounting and/or product cost.

-- Bottom 5 states by profit
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_clean
GROUP BY state
ORDER BY total_profit ASC
LIMIT 5;

-- Finding: The BOTTOM 5 states by total profit are
-- 1) Texas
-- 2) Ohio
-- 3) Pennsylvania
-- 4) Illinois
-- 5) North Carolina


-- ================================================
-- QUESTION 5: Which customer segment drives
-- the most revenue and profit?
-- ================================================

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore_clean
GROUP BY segment
ORDER BY total_profit DESC;

-- Finding: Consumer had most total profit at $134,119.33.


-- ================================================
-- QUESTION 6: Is discounting hurting
-- profitability?
-- ================================================

SELECT
    CASE
        WHEN discount = 0 THEN '0 - No Discount'
        WHEN discount <= 0.10 THEN '1 - Up to 10%'
        WHEN discount <= 0.20 THEN '2 - Up to 20%'
        WHEN discount <= 0.30 THEN '3 - Up to 30%'
        WHEN discount <= 0.40 THEN '4 - Up to 40%'
        WHEN discount <= 0.50 THEN '5 - Up to 50%'
        WHEN discount <= 0.60 THEN '6 - Up to 60%'
        WHEN discount <= 0.70 THEN '7 - Up to 70%'
        WHEN discount <= 0.80 THEN '8 - Up to 80%'
        ELSE '9 - Over 80%'
    END AS discount_tier,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY discount_tier
ORDER BY discount_tier;


-- Finding: Profit margins begin turning NEGATIVE
-- going from 20% discount to 30% or above discount.
-- Significant profit margin losses from
-- 50% discount (-35.71% profit margin) to 60% discount (-89.46% profit margin)
-- and
-- 70% discount (-98.66% profit margin) to 80% discount (-180.03% profit margin).


-- ================================================
-- Question 7: Do sales and profit performance
-- improve year over year?
-- ================================================

SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY order_year
ORDER BY order_year ASC;

-- Finding: Total sales AND total profits
-- have been rising year over year
-- from 2014 to 2017.