# Restaurant Performance Analysis - Supreme Dumplings (December 2025-January 2026)


## Executive Summary

This project analyzes Supreme Dumplings's December and January sales and customer behavior using SQL, Python, and Tableau to identify key revenue drivers, evaluate promotional effectiveness, and forecast future sales. SQL was used to clean and aggregate transactional, menu, and labor data, while Python performed statistical testing and Random Forest Regression for predictive modeling.

An A/B test revealed that discounted orders generate significantly higher average order value, confirming the effectiveness of promotions in increasing customer spending. The Random Forest model achieved strong predictive performance (R-squared = 0.945, MAE = $436), accurately forecasting daily sales based on customer traffic, order volume, and operational factors. These insights enable management to optimize promotions, improve staffing and inventory planning, and support data-driven operational and financial decision-making.

## Business Problem

As a new restaurant, Supreme Dumplings lacks sufficient historical benchmarks and predictive insights to accurately forecast customer demand, evaluate the effectiveness of discounts, and allocate staffing and inventory efficiently. Without data-driven analysis, management faces uncertainty in determining when peak demand will occur, how promotions influence customer spending, and how to align labor and operational resources with actual sales patterns. This creates a risk of overstaffing, underutilizing resources, or implementing ineffective promotional strategies, ultimately impacting operational efficiency, cost control, and revenue growth.

## Methodology

Used **SQL and Python** to clean and aggregate transaction, menu, and labor data, and calculate key metrics such as revenue, average order value (AOV), customer traffic, and operational performance.

Performed **A/B testing and Random Forest Regression in Python** to evaluate the impact of discounts on customer spending and forecast daily sales based on demand and operational factors.

Built **Tableau dashboards** to visualize revenue trends, peak demand periods, and performance drivers, supporting data-driven decisions on staffing, promotions, and inventory planning.

## Skills

- **SQL:** Data cleaning, aggregation, CTEs, window functions
- **Python:** pandas, NumPy, matplotlib, scikit-learn, statistical testing, Random Forest regression
- **Machine Learning:** Sales forecasting using Random Forest regression
- **Statistical Analysis:** A/B testing and hypothesis testing
- **Tableau:** Interactive dashboards, calculated fields, trend visualization

## Analysis Architecture

```
Transaction, Menu & Labor Data → SQL Cleaning & Aggregation → Python Modeling
                              → A/B Testing + Random Forest → Tableau Dashboard (Interactive)
```

## Tools & Technologies

| Layer | Tool | Purpose |
|---|---|---|
| Data Engineering | SQL | Cleaning, aggregation, CTEs, window functions |
| Statistical Analysis | Python — SciPy | A/B testing, hypothesis testing |
| Predictive Modeling | Python — scikit-learn | Random Forest regression, sales forecasting |
| Data Manipulation | Python — pandas, NumPy | Preprocessing, feature engineering, EDA |
| Dashboard | Tableau | Interactive dashboards, calculated fields, trend visualization |

## Dashboard

[View Dashboard](https://public.tableau.com/app/profile/thu.nguyen6411/viz/RestaurantPerformanceAnalysisDashboard/Overview)

## Results and Business Recommendations

**Results:** A/B testing showed that discounted orders generated significantly higher customer spending, with average order value increasing from $28.92 to $33.31 (p < 0.001). The Random Forest model achieved strong predictive performance with R-squared = 0.945 and MAE = $436, accurately forecasting daily sales. Revenue was primarily driven by weekends, dinner hours, and high customer traffic periods. Core menu items and peak demand periods contributed disproportionately to total revenue.

**Business Recommendations:** Management should expand targeted discount promotions during off-peak periods to lift average order value without eroding peak-hour margins. Staffing schedules should be aligned to the model's predicted demand to reduce overstaffing costs. Inventory planning should prioritize core high-revenue menu items, and promotional budgets should be concentrated around weekend dinner periods where ROI is highest.

## Key Skills Demonstrated

- Data cleaning and transformation
- Exploratory data analysis (EDA)
- Hypothesis testing and A/B testing
- Machine learning and predictive modeling
- Data visualization and dashboard development
- Business insight generation and decision support

## Business Impact

This analysis enables management to:

- Forecast daily sales accurately for improved staffing and inventory planning
- Implement data-driven promotional strategies to increase customer spending
- Optimize labor allocation based on predicted demand
- Improve operational efficiency and reduce resource waste
- Support proactive, data-driven business decision-making
