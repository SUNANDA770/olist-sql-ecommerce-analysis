/*Question 1 SQL Concepts:
- Aggregate Functions (COUNT)
Business Question:
How many customers are in the dataset?*/

SELECT COUNT(*) AS total_customers
FROM customers;

/*Business Insight:
- The dataset contains 99,441 customers.
Business Action:
- Use this as the baseline for customer growth and retention analysis.*/

/*Question 2 
SQL Concepts:
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
What is the distribution of order statuses? */

SELECT order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*Business Insight:
- Delivered orders represent the majority of all orders.
- Canceled and unavailable orders indicate operational issues.
Business Action:
- Investigate reasons for canceled and unavailable orders.
- Improve fulfillment processes to increase delivered orders.*/

/*Question 3
SQL Concepts:
- Aggregate Functions (MIN, MAX)
Business Question:
What is the date range of orders in the dataset? */

SELECT MIN(order_purchase_timestamp) AS first_order,
MAX(order_purchase_timestamp) AS last_order
FROM orders;

/*Business Insight:
- The dataset covers orders from the first recorded purchase to the last recorded purchase.
- This defines the time period available for analysis.
Business Action:
- Use this date range for trend and seasonal analysis.
- Ensure future reports compare data within the same timeframe.*/

/*Question 4
SQL Concepts:
- COUNT(DISTINCT)
Business Question:
How many unique cities and states do customers come from?*/

SELECT COUNT(DISTINCT customer_city) AS total_cities,
COUNT(DISTINCT customer_state) AS total_states
FROM customers;

/*Business Insight:
- Customers are distributed across multiple cities and states.
- This indicates the marketplace has a broad geographic reach.
Business Action:
- Identify regions with low customer presence for marketing opportunities.
- Focus expansion efforts on high-potential locations.*/

/* Question 5
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which product categories receive the highest number of delivered orders?
*/

SELECT t.product_category_name_english AS product_category,
COUNT(DISTINCT oi.order_id) AS total_delivered_orders
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
ORDER BY total_delivered_orders DESC;

/* Business Insight:
- A small number of product categories contribute the highest volume of completed sales.
- These categories represent the marketplace's strongest customer demand and are key revenue drivers.
- Consistently high-performing categories indicate products that customers repeatedly purchase.
Business Action:
- Maintain higher inventory levels for top-performing categories to prevent stockouts.
- Prioritize these categories in marketing campaigns and promotional activities.
- Analyze low-performing categories to identify opportunities for pricing, assortment, or product strategy improvements.
*/

/* Question 6
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which payment methods are used most frequently for delivered orders? */

SELECT op.payment_type,COUNT(*) AS total_payments
FROM order_payments op
JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY total_payments DESC;

/* Business Insight:
- Most completed purchases are concentrated within a few payment methods, reflecting customers' preferred payment choices.
- Understanding payment preferences helps optimize the checkout experience and improve transaction success rates.
- Payment method trends can also support negotiations with payment providers and future payment strategy.
Business Action:
- Ensure the most frequently used payment methods remain reliable and readily available.
- Offer targeted promotions with preferred payment methods to increase completed purchases.
- Monitor payment method usage regularly to identify changing customer preferences and optimize payment offerings */

/* Question 7
SQL Concepts:
- INNER JOIN
- GROUP BY
- Aggregate Functions (AVG)
- ORDER BY
Business Question:
What is the average customer review score for each order status? */

SELECT o.order_status,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS average_review_score
FROM orders o
JOIN order_reviews r
ON o.order_id = r.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;

/* Business Insight:
- Customer satisfaction varies across different order statuses, highlighting the impact of the order fulfillment process on customer experience.
- Delivered orders typically achieve higher review scores, while canceled or problematic orders tend to receive lower ratings.
- Monitoring review scores by order status helps identify operational issues that directly affect customer satisfaction.
Business Action:
- Investigate order statuses with lower review scores to identify process bottlenecks.
- Improve order fulfillment, communication, and customer support to enhance customer experience.
- Track average review scores by order status as a key service quality KPI */

/* Question 8
SQL Concepts:
- INNER JOIN
- AVG()
- GROUP BY
- ORDER BY
Business Question:
Which customer states have the highest average review score for delivered orders? */

SELECT c.customer_state,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS average_review_score
FROM order_reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY average_review_score DESC;

/* Business Insight:
- Customer satisfaction varies across different states, indicating regional differences in the overall customer experience.
- States with consistently higher review scores may reflect stronger logistics performance, product availability, or customer service quality.
- Identifying lower-rated states helps prioritize operational improvements where customer experience is weakest.
Business Action:
- Investigate the operational factors contributing to lower review scores in underperforming states.
- Replicate successful fulfillment and customer service practices from high-performing states.
- Track state-level review scores regularly to measure the impact of service improvement initiatives */

/* Question 9
SQL Concepts:
- Aggregate Functions (SUM)
- INNER JOIN
- ROUND()
Business Question:
What is the total revenue generated from delivered orders? */

SELECT ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered';

/* Business Insight:
- Total revenue from delivered orders represents the actual income generated by successfully completed sales.
- This KPI serves as a foundation for evaluating overall business performance and measuring revenue growth over time.
- Tracking only delivered orders ensures revenue reflects completed transactions rather than canceled or pending orders.
Business Action:
- Monitor total revenue regularly to evaluate business growth and sales performance.
- Focus on improving the delivery success rate to maximize realized revenue.
- Compare revenue trends across different time periods to support strategic planning and forecasting */

/* Question 10
SQL Concepts:
- Common Table Expression (CTE)
- Aggregate Functions (AVG)
- Aggregate Functions (SUM)
- ROUND()
Business Question:
What is the Average Order Value (AOV) for delivered orders? */

WITH order_summary AS (
SELECT
o.order_id,
SUM(op.payment_value) AS order_value
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id
)

SELECT
ROUND(AVG(order_value)::NUMERIC, 2) AS average_order_value
FROM order_summary;

/* Business Insight:
- Average Order Value (AOV) measures the average revenue generated from each completed order.
- A higher AOV indicates customers are spending more per purchase, directly contributing to revenue growth.
- Monitoring AOV alongside total revenue helps distinguish whether business growth is driven by more orders or higher customer spending.
Business Action:
- Increase AOV by implementing product bundles, cross-selling, and upselling strategies.
- Offer free shipping thresholds or volume discounts to encourage higher-value purchases.
- Monitor AOV regularly to evaluate the effectiveness of pricing, promotions, and merchandising strategies */

/* Question 11
SQL Concepts:
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which customer states have the highest number of registered customers? */

SELECT customer_state,COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

/* Business Insight:
- Customer distribution is concentrated in a few states, indicating stronger market penetration in those regions.
- States with a larger customer base represent important markets for revenue generation and customer retention.
- Understanding geographic customer distribution supports regional business planning and market expansion.
Business Action:
- Prioritize marketing and customer retention initiatives in states with the largest customer base.
- Identify states with low customer penetration and evaluate opportunities for targeted acquisition campaigns.
- Use geographic customer distribution to support regional expansion and resource allocation decisions */

/* Question 12
SQL Concepts:
- GROUP BY
- ORDER BY
- LIMIT
- Aggregate Functions (COUNT)
Business Question:
Which cities have the highest number of registered customers? */

SELECT customer_city,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

/* Business Insight:
- A small number of cities account for a significant share of the customer base, indicating strong market concentration.
- These cities represent the company's largest customer markets and offer the greatest opportunity for customer retention and revenue growth.
- Understanding customer concentration helps prioritize regional business strategies and resource allocation.
Business Action:
- Focus customer retention and marketing campaigns on the largest customer markets.
- Expand acquisition efforts in cities with growth potential but relatively low customer penetration.
- Use city-level customer distribution to support decisions on logistics, regional promotions, and future business expansion */


/* Question 13
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which product categories have sold the highest number of items? */

SELECT t.product_category_name_english AS product_category,
COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY total_items_sold DESC;

/* Business Insight:
- A small number of product categories account for the highest sales volume, making them the marketplace's strongest-performing categories.
- High-performing categories reflect consistent customer demand and contribute significantly to overall sales.
- Focusing on delivered orders provides an accurate view of products that successfully generated revenue.
Business Action:
- Maintain sufficient inventory for top-selling categories to reduce stockout risk.
- Prioritize high-performing categories in promotional campaigns and seasonal marketing.
- Review low-performing categories to identify opportunities for assortment optimization, pricing improvements, or product discontinuation */

/* Question 14
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which sellers have fulfilled the highest number of delivered orders? */

SELECT s.seller_id,
COUNT(DISTINCT oi.order_id) AS total_delivered_orders
FROM seller s
JOIN order_items oi
ON s.seller_id = oi.seller_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY total_delivered_orders DESC;

/* Business Insight:
- A relatively small group of sellers fulfills a large share of completed orders, indicating that marketplace activity is concentrated among top-performing sellers.
- High-performing sellers play a significant role in maintaining customer satisfaction through successful order fulfillment.
- Identifying these sellers helps evaluate seller performance and marketplace efficiency.
Business Action:
- Recognize and retain top-performing sellers through incentive programs and strategic partnerships.
- Analyze the operational practices of high-performing sellers and share best practices with lower-performing sellers.
- Monitor seller performance regularly to identify emerging top sellers and provide support to underperforming sellers */

/* Question 15
SQL Concepts:
- Common Table Expression (CTE)
- INNER JOIN
- SUM()
- GROUP BY
- ORDER BY
Business Question:
Which sellers have generated the highest revenue from delivered orders? */

WITH order_revenue AS (
SELECT order_id,
SUM(payment_value) AS order_revenue
FROM order_payments
GROUP BY order_id
),
item_count AS (
SELECT order_id,
COUNT(*) AS items_per_order
FROM order_items
GROUP BY order_id
)

SELECT s.seller_id,
ROUND(SUM(orv.order_revenue / ic.items_per_order)::NUMERIC, 2) AS total_revenue
FROM seller s
JOIN order_items oi
ON s.seller_id = oi.seller_id
JOIN order_revenue orv
ON oi.order_id = orv.order_id
JOIN item_count ic
ON oi.order_id = ic.order_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id
ORDER BY total_revenue DESC;

/* Business Insight:
- Revenue is concentrated among a relatively small number of sellers, indicating that top-performing sellers contribute significantly to marketplace revenue.
- Evaluating seller revenue helps identify strategic partners who consistently generate high business value.
- Revenue-based performance provides a more comprehensive measure of seller contribution than order count alone.
Business Action:
- Strengthen partnerships with high-revenue sellers through exclusive programs and performance incentives.
- Analyze the product mix and selling strategies of top sellers to identify best practices that can be shared across the marketplace.
- Monitor seller revenue trends regularly to identify growth opportunities and proactively support declining seller performance */

/* Question 16
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (AVG)
Business Question:
Which product categories have the highest average customer review score? */

SELECT t.product_category_name_english AS product_category,
ROUND(AVG(r.review_score)::NUMERIC, 2) AS average_review_score
FROM order_reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY average_review_score DESC;

/* Business Insight:
- Customer satisfaction varies across product categories, highlighting differences in product quality, customer expectations, and overall buying experience.
- Categories with consistently higher review scores demonstrate stronger customer satisfaction and may encourage repeat purchases and positive word-of-mouth.
- Analyzing review scores by category helps identify products that strengthen or weaken the overall customer experience.
Business Action:
- Promote highly rated product categories in marketing campaigns to leverage customer trust.
- Investigate categories with lower average review scores by analyzing product quality, seller performance, and customer feedback.
- Monitor category-level review scores regularly to evaluate the impact of quality improvement initiatives */

/* Question 17
SQL Concepts:
- DATE_TRUNC()
- SUM()
- GROUP BY
- ORDER BY
Business Question:
How did monthly revenue from delivered orders change over time? */

SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS monthly_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

/* Business Insight:
- Monthly revenue trends reveal periods of business growth, seasonal demand, and potential sales declines.
- Identifying revenue patterns helps evaluate the effectiveness of promotions, pricing strategies, and overall business performance.
- Monitoring revenue over time enables proactive decision-making and better financial planning.
Business Action:
- Increase inventory and marketing investment before historically high-revenue months to maximize sales.
- Investigate months with declining revenue to identify operational issues or changes in customer demand.
- Use monthly revenue trends to improve sales forecasting, budgeting, and business planning */

/* Question 18
SQL Concepts:
- Common Table Expression (CTE)
- INNER JOIN
- AVG()
- GROUP BY
- ORDER BY
Business Question:
Which product categories have the highest Average Order Value (AOV)? */

WITH order_value AS (
SELECT order_id,
SUM(payment_value) AS total_order_value
FROM order_payments
GROUP BY order_id
),
items_per_order AS (
SELECT order_id,
COUNT(*) AS total_items
FROM order_items
GROUP BY order_id
)

SELECT t.product_category_name_english AS product_category,
ROUND(AVG(ov.total_order_value / ipo.total_items)::NUMERIC, 2) AS average_order_value
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
JOIN order_value ov
ON oi.order_id = ov.order_id
JOIN items_per_order ipo
ON oi.order_id = ipo.order_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY average_order_value DESC;

/* Business Insight:
- Product categories with a higher Average Order Value contribute more revenue per customer purchase.
- High-AOV categories often represent premium products or products commonly purchased together.
- Understanding category-level AOV helps identify opportunities to increase overall revenue without relying solely on higher order volumes.
Business Action:
- Promote high-AOV categories through premium marketing campaigns and personalized product recommendations.
- Bundle complementary products with lower-AOV categories to encourage larger basket sizes.
- Monitor category-level AOV regularly to evaluate pricing strategies, promotional effectiveness, and product mix optimization */

/* Question 19
SQL Concepts:
- INNER JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions (SUM)
Business Question: Who are the Top 10 customers by total spending? */

SELECT c.customer_unique_id,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

/* Business Insight:
- A small percentage of customers contribute a disproportionately large share of total revenue, making them the marketplace's most valuable customers.
- High-spending customers have a greater impact on business growth and customer lifetime value than occasional buyers.
- Identifying these customers helps prioritize retention strategies and maximize long-term profitability.
Business Action:
- Develop VIP loyalty programs and exclusive rewards for top-spending customers to improve retention.
- Offer personalized product recommendations and early access to promotions for high-value customers.
- Monitor spending patterns regularly to identify emerging high-value customers and reduce the risk of customer churn*/

/* Question 20
SQL Concepts:
- INNER JOIN
- GROUP BY
- Aggregate Functions (COUNT)
- HAVING
- ORDER BY
Business Question:
Which customers have placed more than one delivered order? */

SELECT c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

/* Business Insight:
- Repeat customers represent the marketplace's most loyal customer segment and contribute significantly to long-term revenue.
- Customers who return to make multiple purchases generally have a higher Customer Lifetime Value (CLV) than one-time buyers.
- Tracking repeat customers provides a direct measure of customer retention and overall business health.
Business Action:
- Develop loyalty programs and personalized offers to encourage one-time customers to make repeat purchases.
- Analyze purchasing behavior of repeat customers to identify products and categories that drive customer loyalty.
- Monitor the repeat customer rate regularly as a key customer retention KPI */

/* Question 21
SQL Concepts:
- INNER JOIN
- DATE_PART()
- AVG()
- ROUND()
- GROUP BY
- ORDER BY
Business Question:
Which customer states have the highest average delivery time? */

SELECT c.customer_state,
ROUND(AVG(DATE_PART('day',o.order_delivered_customer_date - o.order_purchase_timestamp))::NUMERIC,2) AS average_delivery_days
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;

/* Business Insight:
- Delivery performance varies across customer states, indicating differences in logistics efficiency and transportation networks.
- States with longer average delivery times may experience lower customer satisfaction and a higher risk of delayed deliveries.
- Monitoring regional delivery performance helps identify operational bottlenecks and opportunities to improve the customer experience.
Business Action:
- Investigate states with the highest delivery times to identify logistics and fulfillment bottlenecks.
- Optimize warehouse allocation, shipping routes, and courier partnerships in underperforming regions.
- Track average delivery time by state as a key operational KPI to improve service quality and customer satisfaction*/

/* Question 22
SQL Concepts:
- INNER JOIN
- GROUP BY
- Aggregate Functions (AVG)
- ROUND()
- ORDER BY
Business Question:
Which payment methods have the highest average payment value? */

SELECT op.payment_type,
ROUND(AVG(op.payment_value)::NUMERIC, 2) AS average_payment_value
FROM order_payments op
JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY op.payment_type
ORDER BY average_payment_value DESC;

/* Business Insight:
- Average transaction value differs across payment methods, indicating that customers may prefer different payment options for purchases of varying value.
- Payment methods with higher average payment values contribute more revenue per transaction and can influence overall sales performance.
- Understanding payment behavior helps optimize payment strategy and improve the customer checkout experience.
Business Action:
- Promote payment methods associated with higher-value purchases through targeted incentives or partnerships.
- Ensure high-performing payment methods remain reliable to reduce checkout abandonment.
- Monitor payment trends regularly to identify changing customer preferences and optimize payment offerings */

/* Question 23
SQL Concepts:
- Common Table Expression (CTE)
- INNER JOIN
- GROUP BY
- COUNT(DISTINCT)
- ORDER BY
Business Question:
Which customer states have the highest number of repeat customers? */

WITH repeat_customers AS (
SELECT
c.customer_unique_id
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
)

SELECT c.customer_state,
COUNT(DISTINCT c.customer_unique_id) AS repeat_customers
FROM repeat_customers rc
JOIN customers c
ON rc.customer_unique_id = c.customer_unique_id
GROUP BY c.customer_state
ORDER BY repeat_customers DESC;

/* Business Insight:
- States with a higher number of repeat customers demonstrate stronger customer loyalty and retention.
- A large repeat customer base indicates that customers are satisfied with their purchasing experience and continue to buy from the marketplace.
- Comparing repeat customers across states helps identify regions with the strongest long-term customer relationships.
Business Action:
- Study the marketing strategies and customer experience in high-performing states and replicate successful practices in other regions.
- Launch targeted retention campaigns in states with fewer repeat customers to encourage additional purchases.
- Monitor repeat customer growth by state as a key customer retention and loyalty KPI */

/* Question 24
SQL Concepts:
- EXTRACT()
- GROUP BY
- ORDER BY
- Aggregate Functions (COUNT)
Business Question:
Which day of the week receives the highest number of delivered orders? */

SELECT
EXTRACT(DOW FROM o.order_purchase_timestamp) AS day_of_week,
COUNT(*) AS total_orders
FROM orders o
WHERE o.order_status = 'delivered'
GROUP BY day_of_week
ORDER BY total_orders DESC;

/* Business Insight:
- Customer purchasing behavior varies throughout the week, with certain days consistently generating higher order volumes.
- Identifying peak ordering days helps understand customer buying patterns and operational workload.
- Weekly demand patterns support better inventory planning, staffing, and promotional scheduling.
Business Action:
- Schedule marketing campaigns and promotional offers before or during peak ordering days to maximize sales.
- Allocate additional warehouse, logistics, and customer support resources on high-demand days.
- Monitor weekly order trends regularly to optimize inventory replenishment and workforce planning */

/* Question 25
SQL Concepts:
- Common Table Expression (CTE)
- CASE
- COUNT()
- GROUP BY
- ORDER BY
Business Question:
How can customers be classified based on the number of delivered orders they have placed? */

WITH customer_orders AS (
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
)

SELECT
CASE
WHEN total_orders = 1 THEN 'One-Time Customer'
WHEN total_orders BETWEEN 2 AND 5 THEN 'Repeat Customer'
ELSE 'Loyal Customer'
END AS customer_type,
COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;

/* Business Insight:
- Most customers place only one delivered order, while a smaller segment returns to make multiple purchases.
- Loyal customers represent the highest-value customer segment because they purchase more frequently and contribute more to long-term revenue.
- Customer segmentation based on purchase frequency provides a foundation for retention and loyalty strategies.
Business Action:
- Encourage one-time customers to make a second purchase through personalized follow-up campaigns and first-repeat purchase incentives.
- Reward repeat and loyal customers with exclusive benefits, loyalty programs, and personalized recommendations.
- Monitor customer segment distribution regularly to evaluate the effectiveness of customer retention initiatives */

/* Question 26
SQL Concepts:
- Common Table Expression (CTE)
- EXTRACT()
- GROUP BY
- Aggregate Functions (SUM)
- ORDER BY
Business Question:
What is the monthly revenue trend from delivered orders? */

WITH monthly_revenue AS (
SELECT
EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY year, month
)

SELECT year,month,total_revenue
FROM monthly_revenue
ORDER BY year, month;

/* Business Insight:
- Monthly revenue trends highlight periods of business growth, seasonal demand, and potential sales slowdowns.
- Consistent revenue growth indicates healthy business performance, while significant fluctuations may signal seasonal effects or operational changes.
- Tracking monthly revenue provides valuable insight for forecasting and strategic decision-making.
Business Action:
- Increase inventory and marketing investment ahead of historically high-revenue months.
- Investigate months with declining revenue to identify operational issues or changes in customer demand.
- Use monthly revenue trends to improve sales forecasting, budgeting, and long-term business planning */

/* Question 27
SQL Concepts:
- Common Table Expression (CTE)
- Window Function (LAG)
- SUM()
- GROUP BY
- ORDER BY
Business Question:
How did monthly revenue from delivered orders change compared to the previous month? */

WITH monthly_revenue AS (
SELECT
DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
)

SELECT month,total_revenue,
LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue,
ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY month))::NUMERIC,2) AS revenue_change
FROM monthly_revenue
ORDER BY month;

/* Business Insight:
- Month-over-month revenue analysis highlights periods of business growth and decline, making it easier to identify changing sales patterns.
- Significant revenue increases may reflect successful promotions, seasonal demand, or business expansion, while declines may indicate operational or market challenges.
- Monitoring revenue changes over time supports proactive business planning and performance evaluation.
Business Action:
- Investigate months with significant revenue declines to identify operational, pricing, or demand-related issues.
- Replicate marketing campaigns and business strategies that contributed to strong revenue growth.
- Use month-over-month revenue trends to improve forecasting, budgeting, and executive decision-making */

/* Question 28
SQL Concepts:
- Window Function (SUM() OVER)
- Common Table Expression (CTE)
- EXTRACT()
- GROUP BY
- Aggregate Functions (SUM)
Business Question:
What is the running total of monthly revenue from delivered orders? */

WITH monthly_revenue AS (
SELECT
EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY year, month
)

SELECT year,month,
total_revenue,
SUM(total_revenue) OVER (ORDER BY year, month) AS running_total_revenue
FROM monthly_revenue
ORDER BY year, month;

/* Business Insight:
- Running revenue shows cumulative business growth over time.
- It highlights long-term sales performance and growth trends.
Business Action:
- Compare cumulative revenue against business targets.
- Use the trend to support forecasting and strategic planning.
- Monitor long-term business growth.*/

/* Question 29
SQL Concepts:
- Window Function (RANK)
- Aggregate Functions (SUM)
- INNER JOIN
- GROUP BY
- ORDER BY
Business Question:
Who are the Top 10 customers by total spending?*/

SELECT c.customer_unique_id,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_spent,
RANK() OVER (ORDER BY SUM(op.payment_value) DESC) AS customer_rank
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY customer_rank
LIMIT 10;

/* Business Insight:
- A small group of customers contributes a significant share of total revenue.
- High-value customers are critical for long-term business growth.
Business Action:
- Reward top-spending customers through loyalty programs.
- Offer personalized promotions to improve retention.
- Monitor high-value customers to reduce churn */

/* Question 30
SQL Concepts:
- Window Function (ROW_NUMBER)
- INNER JOIN
- GROUP BY
- Aggregate Functions (COUNT)
Business Question:
What is the best-selling product in each product category? */

WITH product_sales AS (
SELECT t.product_category_name_english AS product_category,
p.product_id,
COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category,
p.product_id
)

SELECT product_category,product_id,
total_items_sold
FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY total_items_sold DESC) AS row_num
FROM product_sales
) ranked_products
WHERE row_num = 1
ORDER BY product_category;

/* Business Insight:
- Each product category has a product that consistently drives the highest sales.
- Best-selling products indicate customer demand within each category.
Business Action:
- Maintain inventory for best-selling products.
- Feature top products in marketing campaigns.
- Analyze why these products outperform others*/

/* Question 31
SQL Concepts:
- CASE
- Aggregate Functions (COUNT)
- Conditional Aggregation
- ROUND()
Business Question:
What percentage of orders are delivered, canceled, and unavailable? */

SELECT ROUND((COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) * 100.0 / COUNT(*))::NUMERIC,2) AS delivered_percentage,
ROUND((COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) * 100.0 / COUNT(*))::NUMERIC,2) AS canceled_percentage,
ROUND((COUNT(CASE WHEN order_status = 'unavailable' THEN 1 END) * 100.0 / COUNT(*))::NUMERIC,2) AS unavailable_percentage
FROM orders;

/* Business Insight:
- Most orders are successfully delivered.
- Canceled and unavailable orders highlight operational inefficiencies.
Business Action:
- Reduce cancellations through better inventory planning.
- Improve fulfillment processes to minimize unavailable orders.
- Monitor order status percentages as an operational KPI */

/* Question 32
SQL Concepts:
- Subquery
- GROUP BY
- Aggregate Functions (COUNT)
- HAVING
- ORDER BY
Business Question:
Which product categories have sold more items than the average product category? */

SELECT t.product_category_name_english AS product_category,
COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
HAVING COUNT(*) > (
SELECT AVG(category_sales)
FROM (
SELECT COUNT(*) AS category_sales
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
) avg_category_sales
)
ORDER BY total_items_sold DESC;

/* Business Insight:
- A few product categories outperform the marketplace average in sales volume.
- These categories are the primary drivers of product demand.
Business Action:
- Prioritize inventory for above-average categories.
- Increase marketing investment in high-performing categories.
- Review low-performing categories for improvement opportunities */

/* Question 33
SQL Concepts:
- Common Table Expression (CTE)
- SUM()
- Window Function (SUM() OVER)
- GROUP BY
- ORDER BY
Business Question:
Which product categories contribute the highest percentage of total revenue?*/

WITH order_revenue AS (
SELECT order_id,
SUM(payment_value) AS total_order_revenue
FROM order_payments
GROUP BY order_id
),
item_count AS (
SELECT order_id,
COUNT(*) AS total_items
FROM order_items
GROUP BY order_id
),
category_revenue AS (
SELECT
t.product_category_name_english AS product_category,
SUM(orv.total_order_revenue / ic.total_items) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
JOIN order_revenue orv
ON oi.order_id = orv.order_id
JOIN item_count ic
ON oi.order_id = ic.order_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
)

SELECT product_category,
ROUND(revenue::NUMERIC, 2) AS revenue,
ROUND((revenue * 100.0 / SUM(revenue) OVER ())::NUMERIC, 2) AS revenue_percentage
FROM category_revenue
ORDER BY revenue DESC;

/* Business Insight:
- Revenue is concentrated in a small number of product categories.
- High-revenue categories have the greatest impact on business performance.
Business Action:
- Invest more in high-revenue categories.
- Optimize pricing and promotions for low-performing categories.
- Monitor category revenue contribution regularly */

/* Question 34
SQL Concepts:
- Common Table Expression (CTE)
- CASE
- Aggregate Functions (SUM)
- GROUP BY
Business Question:
How can customers be segmented based on their total spending? */

WITH customer_spending AS (
SELECT
c.customer_unique_id,
SUM(op.payment_value) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
)

SELECT
CASE
WHEN total_spent < 100 THEN 'Bronze'
WHEN total_spent BETWEEN 100 AND 500 THEN 'Silver'
WHEN total_spent BETWEEN 500 AND 1000 THEN 'Gold'
ELSE 'Platinum'
END AS customer_segment,
COUNT(*) AS total_customers
FROM customer_spending
GROUP BY customer_segment
ORDER BY total_customers DESC;

/* Business Insight:
- Customer spending is concentrated across distinct value segments.
- High-value customers contribute significantly more revenue than lower-spending customers.
Business Action:
- Reward Gold and Platinum customers with exclusive benefits.
- Encourage Bronze and Silver customers to increase spending through targeted offers.
- Monitor customer segment distribution regularly */

/* Question 35
SQL Concepts:
- Common Table Expression (CTE)
- Window Function (NTILE)
- Aggregate Functions (SUM)
- INNER JOIN
- ORDER BY
Business Question:
How can customers be divided into four spending groups based on their total spending? */

WITH customer_spending AS (
SELECT c.customer_unique_id,
SUM(op.payment_value) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
)

SELECT customer_unique_id,
ROUND(total_spent::NUMERIC, 2) AS total_spent,
NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile
FROM customer_spending
ORDER BY total_spent DESC;

/* Business Insight:
- Customers are grouped into four spending tiers based on total spending.
- The highest quartile contains the marketplace's most valuable customers.
Business Action:
- Prioritize retention efforts for the highest spending quartile.
- Create targeted campaigns for lower spending quartiles.
- Use spending quartiles for personalized marketing */

/* Question 36
SQL Concepts:
- Common Table Expression (CTE)
- MAX()
- SUM()
- COUNT()
- Date Arithmetic
- CROSS JOIN
Business Question:
How can customers be segmented using RFM (Recency, Frequency, Monetary) Analysis? */

WITH analysis_date AS (
SELECT
MAX(order_purchase_timestamp)::DATE AS max_purchase_date
FROM orders
),
rfm AS (
SELECT c.customer_unique_id,
MAX(o.order_purchase_timestamp)::DATE AS last_order_date,
COUNT(o.order_id) AS frequency,
SUM(op.payment_value) AS monetary
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
)

SELECT r.customer_unique_id,(a.max_purchase_date - r.last_order_date) AS recency,r.frequency,
ROUND(r.monetary::NUMERIC, 2) AS monetary
FROM rfm r
CROSS JOIN analysis_date a
ORDER BY monetary DESC;

/* Business Insight:
- RFM identifies customers based on purchase recency, frequency, and spending.
- Customers with low recency, high frequency, and high monetary value are the most valuable.
Business Action:
- Reward high-value customers through loyalty programs.
- Re-engage inactive customers with targeted campaigns.
- Use RFM segments for personalized marketing */

/* Question 37
SQL Concepts:
- Common Table Expression (CTE)
- Aggregate Functions (COUNT)
- Aggregate Functions (SUM)
- Aggregate Functions (AVG)
- ROUND()
Business Question:
What are the key business KPIs for delivered orders? */

WITH order_summary AS (
SELECT o.order_id,
c.customer_unique_id,
SUM(op.payment_value) AS order_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id,c.customer_unique_id
)

SELECT COUNT(order_id) AS total_orders,
COUNT(DISTINCT customer_unique_id) AS total_customers,
ROUND(SUM(order_value)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(order_value)::NUMERIC, 2) AS average_order_value
FROM order_summary;

/* Business Insight:
- Revenue, orders, and AOV provide a snapshot of overall business performance.
- These KPIs help measure sales growth and customer purchasing behavior.
Business Action:
- Monitor KPIs through an executive dashboard.
- Track KPI trends to support business decisions.
- Investigate significant changes in performance */

/* Question 38
SQL Concepts:
- Common Table Expression (CTE)
- Window Function (DENSE_RANK)
- Aggregate Functions (SUM)
- GROUP BY
- ORDER BY
Business Question:
Which customer states generated the highest total revenue? */

WITH state_revenue AS (
SELECT c.customer_state,
ROUND(SUM(op.payment_value)::NUMERIC, 2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
)

SELECT customer_state,total_revenue,
DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM state_revenue
ORDER BY revenue_rank;

/* Business Insight:
- Revenue contribution varies significantly across customer states.
- High-revenue states represent the marketplace's strongest regional markets.
Business Action:
- Prioritize marketing and customer retention in high-revenue states.
- Identify growth opportunities in lower-performing states.
- Monitor regional revenue trends regularly */

/* Question 39
SQL Concepts:
- Common Table Expression (CTE)
- ROW_NUMBER()
- SUM()
- GROUP BY
- PARTITION BY
- ORDER BY
Business Question:
Which product category generated the highest revenue in each customer state? */

WITH category_revenue AS (
SELECT c.customer_state,
t.product_category_name_english AS product_category,
SUM(oi.price) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation t
ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state,product_category)

SELECT customer_state,product_category,
ROUND(total_revenue::NUMERIC, 2) AS total_revenue
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY customer_state ORDER BY total_revenue DESC) AS row_num
FROM category_revenue
) ranked_categories
WHERE row_num = 1
ORDER BY customer_state;

/* Business Insight:
- Customer preferences vary across states based on revenue contribution.
- Identifying the top-performing category helps understand regional demand.
Business Action:
- Prioritize inventory for the highest-revenue category in each state.
- Run region-specific marketing campaigns.
- Monitor category performance across states regularly */

/* Question 40

SQL Concepts:
- Common Table Expression (CTE)
- Window Function (ROW_NUMBER)
- Aggregate Functions (COUNT)
- PARTITION BY
- ORDER BY
Business Question:
Which seller fulfilled the highest number of delivered orders in each state? */

WITH seller_orders AS (
SELECT
s.seller_state,
oi.seller_id,
COUNT(DISTINCT oi.order_id) AS total_orders
FROM seller s
JOIN order_items oi
ON s.seller_id = oi.seller_id
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state,
oi.seller_id
)

SELECT seller_state,seller_id,
total_orders
FROM (
SELECT *,ROW_NUMBER() OVER (
PARTITION BY seller_state
ORDER BY total_orders DESC
) AS row_num
FROM seller_orders
) ranked_sellers
WHERE row_num = 1
ORDER BY seller_state;

/* Business Insight:
- Each state has a seller leading in completed order fulfillment.
- Top-performing sellers drive regional marketplace performance.
Business Action:
- Reward top-performing sellers with incentive programs.
- Share best practices with lower-performing sellers.
- Monitor seller performance across states regularly */

/* Question 41
SQL Concepts:
- Common Table Expression (CTE)
- Aggregate Functions (COUNT)
- Aggregate Functions (SUM)
- Aggregate Functions (AVG)
- ROUND()
Business Question:
How can an executive dashboard summarize the overall performance of the marketplace? */

WITH order_summary AS (
SELECT
o.order_id,
c.customer_unique_id,
SUM(op.payment_value) AS order_value
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id,c.customer_unique_id
)

SELECT
COUNT(order_id) AS total_orders,
COUNT(DISTINCT customer_unique_id) AS total_customers,
ROUND(SUM(order_value)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(order_value)::NUMERIC, 2) AS average_order_value
FROM order_summary;

/* Business Insight:
- Executive KPIs provide a clear overview of marketplace performance.
- Revenue, customers, orders, and AOV are key indicators of business growth.
Business Action:
- Monitor KPIs through an executive dashboard.
- Track KPI trends to support strategic decisions.
- Review KPI changes regularly to improve business performance */
