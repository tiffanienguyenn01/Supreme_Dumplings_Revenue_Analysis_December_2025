# Restaurant Performance Analysis - Supreme Dumplings (December 2025-January 2026)

## Executive Summary
This project analyzes Sumpreme Dumplings's December and January sales and customer behavior using SQL, Python, and Tableau to identify key revenue drives, evaluate promotional effectiveness, and forecast future sales. SQL was used to clean and aggregate transactional, menu, and labor data, while Python performed statistical tetsing and Random Forest Regression for predictive modeling. An A/B test revealed that discounted orders generate significantly higher average order value, confirming the effectiveness of promotions in increasing customer spending. The Random Forest Model achieved strong predictive performance (R-squared = 0.945, MAE = $436), acuurately forecasting daily sales based on customer traffic, order volume, and operational factors. These insights enable management to optimize promotions, imporve staffing and inventory planning, and support data-driven operational and financial decision-making.

## Business Problems
As a new restaurant, Supreme Dumplings lacks sufficient historical benchmarks and predictive insights to accurately forecast customer demand, evaluate the effectiveness of discounts, and allocate staffing and inventory efficiently. Without data-driven analysis, management faces uncertainty in determining when peak demand will occur, how promotions influence customer spending, and how to align labor and operational resources with actual sales patterns. This creates a risk of overstaffing, underutilizing resources, or implementing ineffective promotional strategies, ultimately impacting operational efficiency, cost control, and revenue growth.

## Methodology
- Used **SQL and Python** to clean and aggregate transaction, menu, and labor data, and calculat key metrics such as revenue, average order value (AOV), customer traffic, and operational performance.
- Performed **A/B Testing and Random Forest Regression in Python** to evaluate the impact of discounts on customer spending and forecast daily sales based on demand and operational factors.
- Build **Tableau dashboards** to visualize revenue trends, peak demand periods, and performance drivers, supporting data-driven decisions on staffing, promotions, and inventory planning.

## Tools and Technologies
- SQL: Data cleaning, aggregation, CTEs, window functions
- Python: pandas, NumPy, matplotlib, scikit-learn, statistical testing, Random Forest regression
- Tableau: Interactive dashboards, calculated fields, trend visualization
- Machine Learning: Sales forecasting using Random Forest regression
- Statistical Analysis: A/B testing and hypothesis testing

## Key Skills Demonstrated
- Data cleaning and transformation
Exploratory data analysis (EDA)
Hypothesis testing and A/B testing
Machine learning and predictive modeling
Data visualization and dashboard development
Business insight generation and decision support

![Restaurant Performance Analysis Dashboard - Supreme Dumplings](Overview.png)

## Results
- A/B testing showed that discounted orders generated significantly higher customer spending, with AOV increasing from $28.92 to $33.31 (p < 0.001).
- The Random Forest model achieved strong predictive performance with R-squared = 0.945 and MAE = $436, accurately forecasting daily sales.
- Revenue was primarily driven by weekends, dinner hours, and high customer traffic periods.
- Core menu items and peak demand periods contributed disproportionately to total revenue.

## Business Impact
This analysis enables management to:
- Forecast daily sales accurately for improved staffing and inventory planning
- Implement data-driven promotional strategies to increase customer spending
- Optimize labor allocation based on predicted demand
- Improve operational efficiency and reduce resource waste
- Support proactive, data-driven business decision-making

