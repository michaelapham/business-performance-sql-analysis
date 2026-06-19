-- ================================================
-- SUPERSTORE BUSINESS PERFORMANCE ANALYSIS
-- Tool: MySQL
-- Dataset: Superstore Sales Dataset (Kaggle)
-- ================================================

-- ================================================
-- SECTION 04: BUSINESS PERFORMANCE ANALYSIS
-- Purpose: Answer core business questions to
-- identify profitability drivers, discount
-- policy impact, underperforming segments,
-- and regional growth opportunities across
-- the Superstore portfolio.
-- All queries run on superstore_clean.
-- ================================================


-- ================================================
-- QUESTION 1: Which product categories are most
-- and least profitable?
-- ================================================

USE superstore_sales;

SELECT
    category,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct
FROM superstore_clean
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- Finding: Technology leads with a 17.4% profit margin, closely followed by
-- Office Supplies at 17.0%. Furniture is a significant outlier — despite
-- generating $742K in revenue (comparable to the other two categories),
-- it produces only a 2.49% margin. This is not a low-volume problem; it is
-- a structural pricing issue concentrated in specific
-- subcategories. Furniture requires targeted intervention, not a category-
-- wide sales push.


-- ================================================
-- QUESTION 2: Which sub-categories are
-- losing money?
-- ================================================

SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct
FROM superstore_clean
GROUP BY category, sub_category
ORDER BY total_profit ASC;

-- Finding: Three subcategories produced negative total profit over the
-- four-year period:
--   - Tables (Furniture):    -$17,725.59  /  -8.6% margin
--   - Bookcases (Furniture): -$3,472.56   /  -4.5% margin
--   - Supplies (Office):     -$1,188.99   /  -3.2% margin
--
-- Tables are the primary driver of Furniture's margin collapse. At -8.6%,
-- every dollar of Tables revenue costs the business $0.09 net. This is not
-- a recoverable situation through volume growth — it worsens at scale.
-- Bookcases and Supplies show less severe but still chronic losses,
-- likely attributable to over-discounting and insufficient pricing floors.


-- ================================================
-- QUESTION 2B: Rank subcategories within each
-- category by profit contribution
-- (Window Function: RANK + PARTITION BY)
-- ================================================

SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2)                                                AS total_sales,
    ROUND(SUM(profit), 2)                                               AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)                         AS profit_margin_pct,
    RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC)      AS rank_in_category
FROM superstore_clean
GROUP BY category, sub_category
ORDER BY category, rank_in_category;

-- Finding: Within the Furniture category, Chairs and Storage are the only
-- subcategories carrying positive margin, partially offsetting the losses
-- from Tables and Bookcases. Technology's top performers (Copiers, Phones,
-- Accessories) all rank with strong positive margins — there is no hidden
-- loss leader within Tech. Office Supplies shows uniform positive performance
-- with the single exception of Supplies. This ranking view clarifies that
-- Furniture's problem is subcategory-specific, not category-wide, and that
-- surgical product-line decisions (not a category exit) are warranted.


-- ================================================
-- QUESTION 3: Which regions generate the most
-- sales vs. most profit? Are they the same?
-- ================================================

SELECT
    region,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct,
    COUNT(DISTINCT order_id)                        AS total_orders
FROM superstore_clean
GROUP BY region
ORDER BY total_profit DESC;

-- Finding: The West region leads in both total sales ($725K) and total
-- profit ($108K), making it the only region where volume and margin
-- reinforce each other. The East produces strong profit on lower sales
-- volume, indicating better pricing discipline or a more favorable product
-- mix. Central is the clearest underperformer — moderate order volume but
-- the weakest profit margin of all four regions, suggesting discount
-- overuse or a high concentration of low-margin products (notably Furniture).


-- ================================================
-- QUESTION 3B: Rank states by profit within
-- each region, with national rank overlay
-- (Window Function: Dual RANK + PARTITION BY)
-- ================================================

SELECT
    region,
    state,
    ROUND(SUM(sales), 2)                                                AS total_sales,
    ROUND(SUM(profit), 2)                                               AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)                         AS profit_margin_pct,
    RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC)        AS rank_in_region,
    RANK() OVER (ORDER BY SUM(profit) DESC)                            AS national_rank
FROM superstore_clean
GROUP BY region, state
ORDER BY region, rank_in_region;

-- Finding: California (West, national rank #1) and New York (East, national
-- rank #2) are the clear anchor states for their respective regions.
-- Texas ranks last nationally despite being one of the larger sales markets
-- in Central — confirming that Central's margin problem is not evenly
-- distributed but concentrated in a few high-volume, high-discount states.
-- Michigan and Virginia show strong national profit ranks despite lower
-- absolute sales volume, indicating above-average pricing efficiency in
-- those markets.


-- ================================================
-- QUESTION 4: Which states are the top 5 and
-- bottom 5 by total profit?
-- ================================================

-- Top 5 states by profit
SELECT
    state,
    ROUND(SUM(sales), 2)    AS total_sales,
    ROUND(SUM(profit), 2)   AS total_profit
FROM superstore_clean
GROUP BY state
ORDER BY total_profit DESC
LIMIT 5;

-- Finding: The top 5 states by total profit are:
--   1) California  — $76,381.60
--   2) New York    — $74,038.64
--   3) Washington  — $33,402.65
--   4) Michigan    — $24,463.19
--   5) Virginia    — $18,597.96
--
-- California's profit nearly matches New York despite generating 47% more
-- in sales revenue. This margin compression in California warrants a discount
-- audit — the state may be converting volume through promotional pricing
-- that is suppressing what should be proportionally higher profit.


-- Bottom 5 states by profit
SELECT
    state,
    ROUND(SUM(sales), 2)    AS total_sales,
    ROUND(SUM(profit), 2)   AS total_profit
FROM superstore_clean
GROUP BY state
ORDER BY total_profit ASC
LIMIT 5;

-- Finding: The bottom 5 states by total profit are:
--   1) Texas         — significant negative profit
--   2) Ohio          — negative profit
--   3) Pennsylvania  — negative profit
--   4) Illinois      — negative profit
--   5) North Carolina
--
-- Critically, these are not low-revenue markets — Ohio, Pennsylvania, and
-- Illinois all generate meaningful order volumes. Their negative profitability
-- points to systemic discount overuse or a disproportionate mix of
-- loss-making subcategories (Tables, Bookcases) rather than demand weakness.
-- These states are selling their way into losses.


-- ================================================
-- QUESTION 4B: Identify states with high sales
-- volume but negative profit
-- (High-risk accounts — loss at scale)
-- ================================================

SELECT
    state,
    region,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct,
    COUNT(DISTINCT order_id)                        AS total_orders
FROM superstore_clean
GROUP BY state, region
HAVING total_profit < 0
ORDER BY total_sales DESC;

-- Finding: States with negative profit AND high sales volume represent the
-- highest-risk accounts in the portfolio — the business is actively scaling
-- losses in these markets. Texas is the most critical case: substantial
-- sales volume paired with negative profit suggests established discounting
-- behavior that has not been corrected over four years. Each incremental
-- order in these states at current pricing and product mix deepens the loss.


-- ================================================
-- QUESTION 5: Which customer segment drives
-- the most revenue and profit?
-- ================================================

SELECT
    segment,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct,
    COUNT(DISTINCT customer_id)                     AS unique_customers,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM superstore_clean
GROUP BY segment
ORDER BY total_profit DESC;

-- Finding: The Consumer segment leads in total profit ($134K) and order
-- volume but operates at a lower margin than Corporate. Corporate customers
-- generate fewer orders but at a meaningfully higher average order value,
-- suggesting a more efficient revenue profile. Home Office is the smallest
-- segment by both revenue and profit but maintains a comparable margin to
-- Consumer, indicating that its underperformance is a scale issue rather
-- than a pricing or product-mix problem. From a resource allocation
-- standpoint, Corporate accounts represent the highest margin-per-
-- customer profile and merit prioritized sales attention.


-- ================================================
-- QUESTION 5B: Year-over-year revenue and profit
-- growth by customer segment
-- (Window Function: LAG for YoY growth)
-- ================================================

WITH yearly_segment AS (
    SELECT
        YEAR(order_date)                            AS order_year,
        segment,
        ROUND(SUM(sales), 2)                        AS total_sales,
        ROUND(SUM(profit), 2)                       AS total_profit
    FROM superstore_clean
    GROUP BY order_year, segment
)
SELECT
    order_year,
    segment,
    total_sales,
    total_profit,
    LAG(total_sales)  OVER (PARTITION BY segment ORDER BY order_year) AS prior_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (PARTITION BY segment ORDER BY order_year))
        / LAG(total_sales) OVER (PARTITION BY segment ORDER BY order_year) * 100,
    2)                                                                 AS yoy_sales_growth_pct,
    ROUND(
        (total_profit - LAG(total_profit) OVER (PARTITION BY segment ORDER BY order_year))
        / ABS(LAG(total_profit) OVER (PARTITION BY segment ORDER BY order_year)) * 100,
    2)                                                                 AS yoy_profit_growth_pct
FROM yearly_segment
ORDER BY segment, order_year;

-- Finding: All three segments show compounding revenue growth from 2015
-- to 2017. Consumer growth is the most consistent. Corporate shows the
-- sharpest profit growth rate in the final year, suggesting either improved
-- product mix, reduced discounting, or larger deal sizes in 2017 — a trend
-- worth monitoring as an early signal of Corporate segment maturation.


-- ================================================
-- QUESTION 6: Is discounting hurting
-- profitability?
-- ================================================

SELECT
    CASE
        WHEN discount = 0           THEN '0 - No Discount'
        WHEN discount <= 0.10       THEN '1 - Up to 10%'
        WHEN discount <= 0.20       THEN '2 - Up to 20%'
        WHEN discount <= 0.30       THEN '3 - Up to 30%'
        WHEN discount <= 0.40       THEN '4 - Up to 40%'
        WHEN discount <= 0.50       THEN '5 - Up to 50%'
        WHEN discount <= 0.60       THEN '6 - Up to 60%'
        WHEN discount <= 0.70       THEN '7 - Up to 70%'
        WHEN discount <= 0.80       THEN '8 - Up to 80%'
        ELSE                             '9 - Over 80%'
    END                                                             AS discount_tier,
    COUNT(*)                                                        AS order_count,
    ROUND(SUM(sales), 2)                                           AS total_sales,
    ROUND(SUM(profit), 2)                                          AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)                    AS profit_margin_pct
FROM superstore_clean
GROUP BY discount_tier
ORDER BY discount_tier;

-- Finding: Profit margin turns negative between the 20% and 30% discount
-- tiers, establishing 30% as the effective breakeven threshold. Beyond
-- this point, losses accelerate nonlinearly:
--   50% discount:  -35.71% margin
--   60% discount:  -89.46% margin
--   70% discount:  -98.66% margin
--   80% discount: -180.03% margin
-- At 80% discount, the business spends $1.80 in cost for every $1.00
-- recovered in revenue. These are not promotional sales — they are
-- operationally funded transfers to customers.


-- ================================================
-- QUESTION 6B: Quantify total profit leakage
-- from orders discounted above 30%
-- (CTE + Conditional Aggregation)
-- ================================================

WITH baseline AS (
    -- Estimate what profit would have been at 0% discount
    -- using the average no-discount margin as a proxy
    SELECT ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS no_discount_margin_pct
    FROM superstore_clean
    WHERE discount = 0
),
loss_orders AS (
    SELECT
        CASE
            WHEN discount <= 0.30 THEN 'At or Below 30% (Breakeven Zone)'
            WHEN discount <= 0.50 THEN '31-50% (Loss Territory)'
            ELSE                       '50%+ (Severe Loss)'
        END                                                         AS discount_band,
        COUNT(*)                                                    AS order_count,
        ROUND(SUM(sales), 2)                                        AS total_sales,
        ROUND(SUM(profit), 2)                                       AS total_profit,
        ROUND((SUM(profit) / SUM(sales)) * 100, 2)                 AS actual_margin_pct
    FROM superstore_clean
    GROUP BY discount_band
)
SELECT
    lo.discount_band,
    lo.order_count,
    lo.total_sales,
    lo.total_profit,
    lo.actual_margin_pct,
    -- Profit that would have been generated at the no-discount margin rate
    ROUND(lo.total_sales * (b.no_discount_margin_pct / 100), 2)    AS estimated_full_margin_profit,
    -- The gap between what was earned and what could have been earned
    ROUND(
        (lo.total_sales * (b.no_discount_margin_pct / 100)) - lo.total_profit,
    2)                                                              AS profit_leakage
FROM loss_orders lo
CROSS JOIN baseline b
ORDER BY lo.discount_band;

-- Finding: This query isolates the financial cost of the discount policy
-- by comparing actual profit in each discount band against what those same
-- orders would have generated at the average no-discount margin rate.
-- The resulting profit_leakage column represents the incremental value
-- destroyed by discounting — a concrete number to present to leadership
-- when making the case for a discount policy overhaul.


-- ================================================
-- QUESTION 6C: Which subcategories account for
-- the most orders sold at a loss?
-- (Profit Leakage by Product)
-- ================================================

SELECT
    category,
    sub_category,
    COUNT(*)                                                        AS loss_order_count,
    ROUND(SUM(sales), 2)                                           AS revenue_from_loss_orders,
    ROUND(SUM(profit), 2)                                          AS total_loss,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
    2)                                                             AS pct_of_all_loss_orders
FROM superstore_clean
WHERE profit < 0
GROUP BY category, sub_category
ORDER BY total_loss ASC;

-- Finding: This view isolates which subcategories are generating the most
-- individual loss transactions — not just the largest aggregate loss. A
-- subcategory with many small-loss orders is a systemic pricing problem
-- (likely a discount policy gap). A subcategory with few but large losses
-- points to one-off deep-discount exceptions that require authorization
-- controls. Understanding which pattern applies is critical to designing
-- the right corrective action.


-- ================================================
-- QUESTION 7: Do sales and profit performance
-- improve year over year?
-- ================================================

SELECT
    YEAR(order_date)                                AS order_year,
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2)     AS profit_margin_pct
FROM superstore_clean
GROUP BY order_year
ORDER BY order_year ASC;

-- Finding: Total profit grew consistently from 2014 to 2017. Notably,
-- total sales dipped from 2014 to 2015 while profit increased — a signal
-- of improved margin discipline or a favorable shift in product mix during
-- that period, not simply volume-driven growth. From 2015 onward, both
-- sales and profit scaled together, indicating that the business found a
-- sustainable growth pattern. However, sustained margin improvement is
-- not confirmed: profit margin % remains in a narrow band across all four
-- years, suggesting that volume growth — not pricing improvement — is the
-- primary driver of absolute profit gains.


-- ================================================
-- QUESTION 7B: Running cumulative revenue total
-- by year (Window Function: SUM OVER)
-- ================================================

WITH yearly_totals AS (
    SELECT
        YEAR(order_date)            AS order_year,
        ROUND(SUM(sales), 2)        AS annual_sales,
        ROUND(SUM(profit), 2)       AS annual_profit
    FROM superstore_clean
    GROUP BY order_year
)
SELECT
    order_year,
    annual_sales,
    annual_profit,
    SUM(annual_sales)  OVER (ORDER BY order_year)   AS cumulative_sales,
    SUM(annual_profit) OVER (ORDER BY order_year)   AS cumulative_profit,
    ROUND(
        (annual_sales - LAG(annual_sales) OVER (ORDER BY order_year))
        / LAG(annual_sales) OVER (ORDER BY order_year) * 100,
    2)                                              AS yoy_sales_growth_pct,
    ROUND(
        (annual_profit - LAG(annual_profit) OVER (ORDER BY order_year))
        / LAG(annual_profit) OVER (ORDER BY order_year) * 100,
    2)                                              AS yoy_profit_growth_pct
FROM yearly_totals
ORDER BY order_year;

-- Finding: Cumulative revenue and profit provide context that annual
-- snapshots obscure. The 2015 sales dip reads as a blip in isolation,
-- but against the cumulative curve it is negligible. More importantly,
-- the YoY growth columns confirm that profit growth outpaced sales growth
-- in 2015 (efficiency gain) but reverted to roughly matching sales growth
-- in 2016-2017 — meaning the business grew but did not structurally improve
-- its margin rate. A true margin improvement story would require profit
-- growth to consistently outpace sales growth.


-- ================================================
-- QUESTION 8: What is the discount behavior
-- profile by category — which categories are
-- most exposed to deep discounting?
-- (Discount Risk by Category)
-- ================================================

SELECT
    category,
    sub_category,
    COUNT(*)                                                            AS total_orders,
    ROUND(AVG(discount) * 100, 2)                                      AS avg_discount_pct,
    SUM(CASE WHEN discount > 0.30 THEN 1 ELSE 0 END)                  AS orders_above_30pct,
    ROUND(
        SUM(CASE WHEN discount > 0.30 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
    2)                                                                 AS pct_orders_above_30pct,
    ROUND(SUM(CASE WHEN discount > 0.30 THEN profit ELSE 0 END), 2)   AS profit_from_high_discount_orders
FROM superstore_clean
GROUP BY category, sub_category
ORDER BY pct_orders_above_30pct DESC;

-- Finding: This query pinpoints which subcategories have the highest
-- *rate* of orders exceeding the 30% profitability threshold — not just
-- the largest absolute loss. A subcategory with 40% of its orders above
-- 30% discount has a structural pricing problem baked into its sales
-- motion. Subcategories where deep discounting is rare but the losses
-- are outsized point to exception handling failures. Both scenarios
-- require different interventions: the former needs a pricing floor
-- policy, the latter needs an approval workflow for outlier discounts.
