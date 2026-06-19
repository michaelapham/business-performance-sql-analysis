# Superstore Retail — Business Performance Analysis 🏬
 
## The Challenge
 
You've just been handed four years of retail sales data for a national superstore chain
and a single mandate from the VP of Merchandising:
 
> *"We're bleeding margin somewhere and I need to know where. We've got solid sales
> numbers on the surface — but when I look at the bottom line, something isn't adding up.
> I need to know which categories are actually profitable, where our discounting strategy
> is backfiring, and which regions we should be doubling down on versus pulling back.
> We have the Q2 business review in two weeks. Don't give me a data dump — give me
> answers I can act on."*
 
Four years of transactions. 9,994 orders. 21 columns. Three product categories.
Four geographic regions. A discount structure that nobody had analyzed end-to-end.
 
This is that analysis.
 
---
 
## 📊 The Data
 
**Source:** [Superstore Sales Dataset — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
 
| Attribute | Detail |
|---|---|
| **Size** | 9,994 orders across 21 columns |
| **Coverage** | January 2014 – December 2017 (4 full years) |
| **Scope** | Orders, customers, products, regions, discounts, profit |
 
**Key fields used in analysis:**
- `Sales`, `Profit`, `Discount` — revenue and margin mechanics
- `Category`, `Sub-Category` — product hierarchy
- `Region`, `State` — geographic performance
- `Segment` — Consumer, Corporate, Home Office
- `Order Date`, `Ship Date` — time-series and fulfillment analysis
---
 
## 🎯 Business Questions Answered
 
### 💰 VP of Merchandising
*"Which categories and subcategories are actually profitable — and which ones are quietly destroying margin?"*
 
1. What is total revenue, profit, and profit margin by product category?
2. Which subcategories are generating negative profit — and by how much?
3. How does discount depth correlate with profitability across subcategories?
4. Which subcategories have the worst profit-per-dollar-of-sales ratio?
### 🗺️ Regional VP
*"I know the West is strong — but I need to understand why the Central region underperforms despite similar order volume."*
 
1. What is sales vs. profit performance by region?
2. Which states are in the top 5 and bottom 5 by total profit?
3. Are there states with high sales volume but chronically negative profit?
4. How does discounting behavior differ across regions?
### 🛍️ Customer Strategy Lead
*"Which customer segments are worth investing in — and are we discounting our way into unprofitable relationships?"*
 
1. Which customer segments (Consumer, Corporate, Home Office) generate the most revenue and profit?
2. Are certain segments more discount-reliant than others?
3. What is the average order value and average profit per order by segment?
4. How has segment-level revenue trended year-over-year?
### 📉 Finance Director
*"I need a clear picture of how our discount policy is impacting the bottom line — what's the financial cost of aggressive discounting?"*
 
1. At what discount threshold does overall profit turn negative?
2. What is the estimated revenue and profit impact of eliminating discounts above 30%?
3. How many orders — and what percentage of total revenue — are being sold at a loss?
---
 
## 🔍 Key Findings & Recommendations
 
### 1. Furniture Is a Structural Margin Problem, Not a Volume Problem
 
**Finding:** Furniture generated $742K in revenue across 2,121 orders (2014–2017) — comparable to both Technology and Office Supplies in absolute sales. However, it produced only a **2.49% profit margin**, versus **17.4% for Technology** and **17.0% for Office Supplies**. This is not a low-volume category being dragged by fixed costs — it is a category generating substantial revenue at near-breakeven economics.
 
Drilling deeper into subcategories reveals where the damage concentrates:
- **Tables**: -$17,725.59 total profit on $207K in sales — a **-8.6% margin**, meaning every dollar of Table revenue costs the business $0.09 net
- **Bookcases**: -$3,472.56 total profit — dragged by high discount rates and freight costs relative to unit price
- **Chairs and Furnishings** carry thin but positive margins, masking the full category loss
**Recommendation:** Immediately suspend or restructure the Tables product line. At -8.6% margin over four years and across all regions, Tables are not a turnaround candidate — they are a structural drag. For Bookcases, implement a minimum discount floor of 15% and test price elasticity before further promotional investment. The Furniture category should not be evaluated on revenue alone; any performance review must weight margin-adjusted contribution.
 
---
 
### 2. Discounting Above 30% Is a Financially Indefensible Practice
 
**Finding:** Profit turns negative at the **30% discount threshold** and accelerates into severe loss at higher discount levels:
 
| Discount Level | Avg Profit Margin |
|---|---|
| 0% | ~18–20% (positive) |
| 20% | ~8–10% (thin but positive) |
| 30% | ~0% (breakeven) |
| 40% | ~-15% (loss) |
| 50% | **-35.71%** |
| 60% | **-89.46%** |
| 70% | **-98.66%** |
| 80% | **-180.03%** |
 
The 50–80% discount band does not generate goodwill, clear inventory efficiently, or build customer LTV — it converts revenue into a net cash outflow. Orders discounted at 50%+ represent an operational cost masquerading as a sale.
 
**Recommendation:** Implement a hard cap on customer-facing discounts at 30%. Any promotional event requiring 40%+ discounts should require VP-level approval with a documented inventory clearance justification. The business should model the profit recovery of eliminating 40%+ discounts: based on current data, this would likely recover **$30K–$50K in annual profit** with minimal impact on order volume, as heavy discounting attracts price-sensitive buyers unlikely to convert at full margin anyway.
 
---
 
### 3. The West Region Dominates — But Central Is the Real Problem
 
**Finding:** The West region leads in both total sales and total profit, driven by California (#1 state by profit, ~$76K) and Washington (#3). The East region benefits from New York (#2 by profit) and Virginia (#5), producing strong margin efficiency.
 
Central, however, tells a different story. Despite moderate order volume, Central produces the **weakest profit margin of all four regions** — and is the home of **Texas, the single worst-performing state in the portfolio** by total profit (negative). Texas generates meaningful sales volume but chronic negative profit, likely due to a combination of aggressive local discounting and a high concentration of Furniture orders.
 
**Recommendation:** Conduct a Texas-specific discount audit. If Central's margin underperformance is driven by a small number of high-discount, high-volume accounts, a targeted pricing correction could recover regional margin without sacrificing sales velocity. The West's success should be studied as a pricing and product-mix benchmark — understanding whether the West's performance is structural (market maturity, higher-income customer base) or behavioral (less discounting, better product mix) determines whether it is replicable.
 
---
 
### 4. The Top 5 / Bottom 5 State Divergence Signals Pricing Discipline Gaps
 
**Finding:**
 
| Rank | Top States by Profit | Bottom States by Profit |
|---|---|---|
| 1 | California | Texas |
| 2 | New York | Ohio |
| 3 | Washington | Pennsylvania |
| 4 | Michigan | Illinois |
| 5 | Virginia | North Carolina |
 
The bottom five states are not low-revenue markets — Ohio, Pennsylvania, and Illinois all generate substantial order volumes. Their profit underperformance points to discount-driven margin erosion rather than demand weakness.
 
**Recommendation:** Segment discount authorization by geography. High-performing states (CA, NY, WA) appear to convert well at lower discount rates; bottom-performing states may have field sales or account management teams authorizing discounts beyond HQ policy. A standardized discount approval workflow by region would reduce the variance between top and bottom state performance.
 
---
 
### 5. Technology is the Portfolio's Margin Engine — Protect and Grow It
 
**Finding:** Technology produced the highest profit margin (17.4%) and strong absolute profit, driven by subcategories like Copiers and Phones. Unlike Furniture, Technology's margin holds even at moderate discount levels, suggesting stronger pricing power and lower price elasticity among buyers.
 
**Recommendation:** Technology should receive preferential treatment in promotional planning — it can sustain discounts up to 20% without meaningful margin damage, making it the appropriate category for loyalty-building promotions. Conversely, it should never be bundled with Furniture in cross-sell promotions that require deep blanket discounting.
 
---
 
## 📁 Repository Structure
 
```
business-performance-sql-analysis/
│
├── data/
│   └── superstore.csv               ← Source dataset (Kaggle)
│
├── sql/
│   ├── 01_create_import.sql         ← Database setup and data ingestion
│   ├── 02_data_cleaning.sql         ← Type standardization, NULL handling
│   ├── 03_business_insights.sql     ← Core analysis queries
│   └── 04_advanced_analysis.sql     ← Window functions, CTEs, discount impact
│
├── dashboard/
│   └── superstore_dashboard_preview.png  ← Power BI dashboard
│
└── README.md
```
 
---
 
## 🛠️ SQL Skills Demonstrated
 
- **Data ingestion & cleaning**: Bulk import via `LOAD DATA INFILE` with `CHARACTER SET latin1`; standardized date formats, handled NULL profit values, validated row counts post-import
- **Aggregation & grouping**: Multi-dimensional `GROUP BY` across category, subcategory, region, state, segment, and discount tier
- **Profitability calculations**: Derived `profit_margin %` as `(SUM(profit) / SUM(sales)) * 100` to compare category economics rather than absolute profit
- **Window functions**: `RANK() OVER (PARTITION BY region ORDER BY profit DESC)` for within-region state rankings; `SUM() OVER (ORDER BY order_date)` for running revenue totals; `LAG()` for YoY growth comparisons
- **CTEs**: Structured multi-step discount impact analysis using chained CTEs to isolate order-level, category-level, and threshold-level profit behavior
- **Conditional aggregation**: `SUM(CASE WHEN discount >= 0.3 THEN profit ELSE 0 END)` to quantify profit leakage from high-discount orders specifically
- **Subqueries**: Correlated subqueries for ranking subcategories within each category by profit contribution
- **Trend analysis**: Year-over-year revenue and profit growth by segment and category using `YEAR(order_date)` partitioning

## Dashboard Preview

![Superstore Business Performance Dashboard](dashboard/superstore_dashboard_preview.png)

## How to Reproduce
1. Download the dataset from  
   `kaggle.com/datasets/vivek468/superstore-dataset-final`
2. Run scripts in order:  
   01 → 02 → 03 → 04
3. Open `dashboard/05_dashboard_superstore.pbix` in Power BI

**Note:** Use `LOAD DATA INFILE` with `CHARACTER SET latin1` for import. The MySQL Table Data Import Wizard causes column misalignment and corrupts certain column values.


## Limitations 🛑
 
- **Single-retailer dataset**: Findings reflect one fictional retailer's operations. Margin benchmarks, discount thresholds, and regional patterns are not generalizable to the broader retail industry without external validation.
- **No cost-of-goods data**: Profit figures are pre-calculated in the dataset. Unit cost structures, freight variances, and return economics are not available at the order-item level — margin analysis operates on reported profit rather than a reconstructed P&L.
- **No customer ID linkage**: The dataset does not include persistent customer identifiers across orders, preventing true cohort analysis, customer lifetime value modeling, or repeat purchase rate calculations.
- **Static 4-year window**: Analysis covers 2014–2017. Conclusions about discounting behavior and category performance reflect a specific competitive and macroeconomic environment and may not hold under current conditions.
---
 
## 💡 Potential Extensions
 
- **Customer LTV modeling**: If customer identifiers were available, RFM segmentation and cohort retention analysis would be the natural next layer
- **Forecast modeling**: With four years of monthly data, a time-series model (moving average or regression) could project 2018 revenue by category or region
- **Price elasticity analysis**: A regression of discount level against order volume by subcategory would test whether high discounting actually drives volume or simply destroys margin without demand response
---


## Author
### Michael Pham
📫 **LinkedIn:** https://www.linkedin.com/in/michaelapham99/  
💻 **GitHub:** https://github.com/michaelapham/  
