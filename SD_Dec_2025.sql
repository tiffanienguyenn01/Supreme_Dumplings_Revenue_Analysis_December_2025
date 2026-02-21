/* Supreme Dumplings Revenue Analysis December 2025 */

CREATE DATABASE IF NOT EXISTS sd_dec_2025;
USE sd_dec_2025;

-- Create Staging Tables (prevent loading errors)

CREATE TABLE stg_orders_dec (
	order_no VARCHAR(50),
    time_opened VARCHAR(50),
    guests_count VARCHAR(30),
    server VARCHAR(120),
    discount_amount VARCHAR(20),
    amount VARCHAR(20),
    tax VARCHAR(20),
    tips VARCHAR(20)
);

CREATE TABLE stg_menu_dec (
	menu_item VARCHAR(300),
    menu_group VARCHAR(100),
    menu VARCHAR(100),
    item_qty VARCHAR(50),
    gross_amount VARCHAR(50),
    net_amount VARCHAR(50),
    num_orders VARCHAR(50)
);

CREATE TABLE stg_labor_dec (
	regular_hours VARCHAR(50),
    overtime_hours VARCHAR(50),
    total_hours VARCHAR(50),
    regular_cost VARCHAR(50),
    overtime_cost VARCHAR(50),
    total_cost VARCHAR(50),
    job_title VARCHAR(50)
);
 -- Data Overview
 
SELECT * FROM stg_orders_dec;
SELECT * FROM stg_menu_dec;
SELECT * FROM stg_labor_dec;

-- Build Clean Tables

CREATE TABLE clean_orders_dec AS
SELECT
  CAST(order_no AS UNSIGNED) AS order_no,
  STR_TO_DATE(time_opened, '%m/%d/%y %h:%i %p') AS opened_ts,
  DATE(STR_TO_DATE(time_opened, '%m/%d/%y %h:%i %p')) AS order_date,
  HOUR(STR_TO_DATE(time_opened, '%m/%d/%y %h:%i %p')) AS order_hour,
  DAYNAME(STR_TO_DATE(time_opened, '%m/%d/%y %h:%i %p')) AS weekday,

  CAST(guests_count AS UNSIGNED) AS guests,
  server,

  CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(12,2)) AS net_sales,
  CAST(REPLACE(REPLACE(discount_amount, '$', ''), ',', '') AS DECIMAL(12,2)) AS discount_amount,
  CAST(REPLACE(REPLACE(tax, '$', ''), ',', '') AS DECIMAL(12,2)) AS tax,
  CAST(REPLACE(REPLACE(tips, '$', ''), ',', '') AS DECIMAL(12,2)) AS tips,

  (CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(12,2)) +
   CAST(REPLACE(REPLACE(discount_amount, '$', ''), ',', '') AS DECIMAL(12,2))) AS gross_sales,

  CASE
    WHEN CAST(REPLACE(REPLACE(discount_amount, '$', ''), ',', '') AS DECIMAL(12,2)) > 0 THEN 1
    ELSE 0
  END AS has_discount,

  CASE
    WHEN CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(12,2)) > 0
     AND CAST(REPLACE(REPLACE(tips, '$', ''), ',', '') AS DECIMAL(12,2)) >= 0
    THEN CAST(REPLACE(REPLACE(tips, '$', ''), ',', '') AS DECIMAL(12,2))
       / CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(12,2))
    ELSE NULL
  END AS tips_pct
FROM stg_orders_dec;

SELECT * FROM clean_orders_dec;

DROP TABLE IF EXISTS clean_menu_dec;
CREATE TABLE clean_menu_dec AS 
SELECT 
	menu_item,
    menu_group,
    menu,
    CAST(REPLACE(item_qty, ',', '') AS UNSIGNED) AS item_qty,
    CAST(REPLACE(REPLACE(gross_amount, '$', ''), ',', '') AS DECIMAL(14,2)) AS gross_amount,
    CAST(REPLACE(REPLACE(net_amount, '$', ''), ',', '') AS DECIMAL(14,2)) AS net_amount,
    CAST(REPLACE(num_orders, ',', '') AS UNSIGNED) AS num_orders
FROM stg_menu_dec;

SELECT * FROM clean_menu_dec;

DROP TABLE IF EXISTS clean_labor_dec;
CREATE TABLE clean_labor_dec AS
SELECT
  TRIM(job_title) AS job_title,
  CAST(REPLACE(regular_hours, ',', '') AS DECIMAL(10,2)) AS regular_hours,
  CAST(REPLACE(overtime_hours, ',', '') AS DECIMAL(10,2)) AS overtime_hours,
  CAST(REPLACE(total_hours, ',', '') AS DECIMAL(10,2)) AS total_hours,
  CAST(REPLACE(REPLACE(regular_cost,'$',''),',','') AS DECIMAL(14,2)) AS regular_cost,
  CAST(REPLACE(REPLACE(overtime_cost,'$',''),',','') AS DECIMAL(14,2)) AS overtime_cost,
  CAST(REPLACE(REPLACE(total_cost,'$',''),',','') AS DECIMAL(14,2)) AS total_cost
FROM stg_labor_dec;

SELECT * FROM clean_labor_dec;

-- Daily KPIs

DROP VIEW IF EXISTS daily_kpis_dec;
CREATE VIEW daily_kpis_dec AS
SELECT
	order_date,
    weekday,
    COUNT(*) AS orders,
    SUM(guests) AS total_guests,
    SUM(net_sales) AS revenue,
    AVG(net_sales) AS aov,
    SUM(discount_amount) AS discounts,
    CASE WHEN SUM(net_sales) > 0 THEN SUM(tips)/SUM(net_sales) 
    END AS tip_pct,
    CASE WHEN SUM(gross_sales) > 0 THEN SUM(discount_amount)/SUM(gross_sales) 
    END AS discount_pct
FROM clean_orders_dec
GROUP BY order_date, weekday
ORDER BY order_date;

SELECT * FROM daily_kpis_dec;

-- Server KPIs

CREATE TABLE server_summary_dec AS
SELECT
  server,
  COUNT(*) AS orders,
  SUM(net_sales) AS revenue,
  AVG(net_sales) AS aov,

  CASE
    WHEN SUM(net_sales) > 0 THEN SUM(tips) / SUM(net_sales)
    ELSE NULL
  END AS tips_pct,

  CASE
    WHEN SUM(gross_sales) > 0 THEN SUM(discount_amount) / SUM(gross_sales)
    ELSE NULL
  END AS discount_rate
FROM clean_orders_dec
GROUP BY server;

SELECT * 
FROM server_summary_dec
ORDER BY tips_pct DESC;

/* Observations/Insights:
- Servers who handle more table drive the majority of total revenue.
Operational efficiency an dtable allocation significantly impact sales performance. 
	- Felix Phan: $29,588 (455 orders)
	- John Mann: $26,259 (384 orders)
	- Chris Chau: $22,910 (348 orders)
- High average order value servers increase revenue quality, not just quantity.
	- Madelaine Nguyen: $74.36
	- Hannah khong: $74.28
	- Helen Nguyen: $73.25
	- Thomas Cao: $71.95
- Excessive discounting reduces 
- Customers tip more when they spend more
	- Thomas Cao: 19.17%
	- John Mann: 18.92%
	- Anthony Le: 18.64%
- Top Overall Performers
	- John Mann: High revenue and strong tip %
	- Thomas Cao: High average order value and strong tip %
*/

-- Peak Hours

SELECT 
	order_hour,
	COUNT(*) AS orders,
    SUM(net_sales) AS revenue, 
    AVG(net_sales) AS aov
FROM clean_orders_dec
GROUP BY order_hour
ORDER BY revenue DESC;

/* Observations/Insights:
- Lunch hours have high order volume but lower spending per order.
- Dinner hours generate the highest revenue and spending per customer.
- Dinner customers are more likely to order high-value items, drinks, and add-ons.
*/

-- Best Days

SELECT
	order_date,
    weekday,
	SUM(net_sales) AS revenue
FROM clean_orders_dec
GROUP BY order_date, weekday
ORDER BY revenue DESC
LIMIT 5;

-- Revenue by Day of Week

WITH weekday_weekly AS (
  SELECT
    weekday,
    YEAR(order_date) AS year,
    WEEK(order_date) AS week_num,
    SUM(net_sales) AS weekly_revenue,
    COUNT(*) AS weekly_orders
  FROM clean_orders_dec
  GROUP BY weekday, YEAR(order_date), WEEK(order_date)
)

SELECT
  weekday,
  SUM(weekly_orders) AS total_orders,
  ROUND(SUM(weekly_revenue), 2) AS total_revenue,
  ROUND(AVG(weekly_revenue), 2) AS avg_sales_per_weekday,
  ROUND(AVG(weekly_revenue / weekly_orders), 2) AS avg_order_value
FROM weekday_weekly
GROUP BY weekday
ORDER BY avg_sales_per_weekday DESC;

/* Observations/Insights:
- Weekend (Friday-Sunday) is the strongest revenue period,
generating significantly higher sales compared to weekdays.
- Saturday along generates 48% more revenue than Thursday
and 28% more revenue than Monday.
- Sunday generates slightly lower orders but higher average order value,
showing that spending quality also matters.
- Customers spend more per visit on weekends, likely due to social dining and larger group sizes.
*/

-- Top Sold Food Items

SELECT
	menu,
	menu_item,
    menu_group,
    item_qty,
    net_amount
FROM clean_menu_dec
WHERE menu = ('Food')
ORDER BY net_amount DESC
LIMIT 10;

/* Observations/Insights:
- Supreme Pork XLB and Mini Pan-Fried Dumplings generate the most revenue,
which more than $20k for each of the two menu items.
- Pork Chop Fried Rice comes in third place which generates medium revenue.
*/

-- Least Sold Food Items

SELECT
	menu,
    menu_item,
    menu_group,
    item_qty,
    net_amount
FROM clean_menu_dec
WHERE menu = ('food')
ORDER BY item_qty 
LIMIT 10;

/* Observations/Insights:
- These items contribute minimally to total revenue and have weak market performance.
- Desserts may have limited customer demand.
- Customers prefer core signature items rather than secondary appetizer or vegetable dishes
*/

-- Menu Engineering (Stars, Flow Horses, Puzzles, Dogs)

WITH item_stats AS (
	SELECT 
    menu,
    menu_item,
    SUM(item_qty) AS unit_sold,
    SUM(net_amount) AS revenue
FROM clean_menu_dec
GROUP BY menu, menu_item
),
benchmark AS (
	SELECT
	AVG(unit_sold) AS avg_unit,
    AVG(revenue) AS avg_rev
FROM item_stats
)
SELECT
  s.menu,
  s.menu_item,
  s.unit_sold,
  ROUND(s.revenue,2) AS revenue,
  CASE
    WHEN s.unit_sold >= b.avg_unit AND s.revenue >= b.avg_rev THEN 'Star'
    WHEN s.unit_sold >= b.avg_unit AND s.revenue <  b.avg_rev THEN 'Plowhorse'
    WHEN s.unit_sold <  b.avg_unit AND s.revenue >= b.avg_rev THEN 'Puzzle'
    ELSE 'Dog'
  END AS menu_category
FROM item_stats s
CROSS JOIN benchmark b
WHERE s.menu = 'Food'
ORDER BY revenue DESC;

/* Observations/Insights:
- Stars: primary revenue driver (most valuable items), these items are both popular and highly
profitable
- Plow Horses: Hot & Sour Soup and Spicy Beef Bun, these items sell frequently but generate lower revenue
per item, which customers like them, but profit potential could be improved.
- Puzzles: Black Truffle & Vegetable Fried Rice, this item has strong revenue potential but low sale
volume, which customers don't order them often, but they are profitable.
- Dogs: low popularity and low revenue (worst performers), these items contribute almost nothing
to revenue but still require inventory, labor, and menu space.
*/

-- Drinks Drive Revenue

SELECT 
    menu_group,
    SUM(net_amount) AS revenue,
    ROUND(SUM(net_amount) * 100.0 /
        (SELECT SUM(net_amount)
         FROM clean_menu_dec
         WHERE menu = 'Drinks'), 2) AS revenue_percent
FROM clean_menu_dec
WHERE menu = 'Drinks'
GROUP BY menu_group
ORDER BY revenue DESC;

/* Observations/Insights:
- Cocktails take roughly 35% of the total drinks revenue, which indicates that customers tend to order
more cocktails than other available drinks.
- Alcohol sales account for 48% of total drink revenue, indicating that alcoholic beverages represent a major
revenue driver within the beverage category. There is a balance sold drinks between NA beverages and Alcohol beverages.
*/

-- Labor Cost By Role

SELECT
	job_title,
    SUM(total_hours) AS total_hours,
    SUM(total_cost) AS total_cost, 
    SUM(total_cost)/SUM(total_hours) AS cost_per_hour
FROM clean_labor_dec
GROUP BY job_title
ORDER BY total_cost DESC;

/* Observations/Insights:
- BOH line cooks account for the majority of labor cost, contributing over $105K, which
is significantly higher than all other positions.
- FOH roles are extremely cost-efficient and help improve operational flow without
significantly increasing labor cost.
*/
