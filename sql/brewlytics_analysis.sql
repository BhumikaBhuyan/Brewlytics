-- ============================================================
-- BREWLYTICS - COFFEE SHOP SALES ANALYSIS
-- Master SQL Analysis Script
-- ============================================================


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS brewlytics;

USE brewlytics;


-- ============================================================
-- 2. TABLE SETUP
-- ============================================================

CREATE TABLE IF NOT EXISTS coffee_shop_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(50),
    product_id INT,
    unit_price DECIMAL(10,2),
    product_category VARCHAR(50),
    product_type VARCHAR(100),
    product_detail VARCHAR(150)
);


-- ============================================================
-- 3. DATA VALIDATION
-- ============================================================

-- Check available tables
SHOW TABLES;


-- Check table structure
DESCRIBE coffee_shop_sales;


-- Preview the data
SELECT *
FROM coffee_shop_sales
LIMIT 10;


-- Total number of rows
SELECT
    COUNT(*) AS total_rows
FROM coffee_shop_sales;


-- Check missing transaction dates
SELECT
    COUNT(*) AS missing_date_rows,
    SUM(transaction_qty) AS missing_date_items,
    SUM(transaction_qty * unit_price) AS missing_date_revenue
FROM coffee_shop_sales
WHERE transaction_date IS NULL;


-- Check data completeness
SELECT
    COUNT(*) AS total_rows,
    SUM(transaction_qty) AS total_items,
    SUM(
        CASE
            WHEN transaction_date IS NOT NULL
            THEN transaction_qty
            ELSE 0
        END
    ) AS dated_items,
    COUNT(transaction_qty) AS non_null_quantity_rows,
    COUNT(*) - COUNT(transaction_qty) AS null_quantity_rows
FROM coffee_shop_sales;


-- ============================================================
-- 4. OVERALL BUSINESS KPIs
-- ============================================================

-- Overall business KPIs
SELECT
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS total_items_sold,
    SUM(transaction_qty * unit_price) AS total_revenue,
    ROUND(
        AVG(transaction_qty * unit_price),
        2
    ) AS average_transaction_value,
    ROUND(
        AVG(transaction_qty),
        2
    ) AS average_items_per_transaction
FROM coffee_shop_sales;


-- ============================================================
-- 5. PRODUCT CATEGORY ANALYSIS
-- ============================================================

-- Items sold by product category
SELECT
    product_category,
    SUM(transaction_qty) AS total_items_sold
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY total_items_sold DESC;


-- Revenue by product category
SELECT
    product_category,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- Average items per transaction by category
SELECT
    product_category,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(
        SUM(transaction_qty) / COUNT(*),
        2
    ) AS avg_items_per_transaction
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY avg_items_per_transaction DESC;


-- Revenue contribution by category
WITH category_revenue AS (
    SELECT
        product_category,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY product_category
)
SELECT
    product_category,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_percentage
FROM category_revenue
ORDER BY revenue DESC;


-- ============================================================
-- 6. STORE PERFORMANCE
-- ============================================================

-- Store performance comparison
SELECT
    store_location,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue,
    ROUND(
        SUM(transaction_qty * unit_price) / COUNT(*),
        2
    ) AS avg_transaction_value
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY revenue DESC;


-- Store revenue contribution
WITH store_revenue AS (
    SELECT
        store_location,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY store_location
)
SELECT
    store_location,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_percentage
FROM store_revenue
ORDER BY revenue DESC;


-- ============================================================
-- 7. PRODUCT PERFORMANCE
-- ============================================================

-- Top 10 products by quantity sold
SELECT
    product_detail,
    product_category,
    SUM(transaction_qty) AS total_items_sold,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_detail, product_category
ORDER BY total_items_sold DESC
LIMIT 10;


-- Top 10 products by revenue
SELECT
    product_detail,
    product_category,
    SUM(transaction_qty) AS total_items_sold,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_detail, product_category
ORDER BY total_revenue DESC
LIMIT 10;


-- Top-selling product in each store
WITH product_sales AS (
    SELECT
        store_location,
        product_detail,
        product_category,
        SUM(transaction_qty) AS items_sold,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY
        store_location,
        product_detail,
        product_category
),
ranked_products AS (
    SELECT
        store_location,
        product_detail,
        product_category,
        items_sold,
        revenue,
        RANK() OVER (
            PARTITION BY store_location
            ORDER BY items_sold DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    store_location,
    product_detail,
    product_category,
    items_sold,
    ROUND(revenue, 2) AS revenue
FROM ranked_products
WHERE product_rank = 1
ORDER BY store_location;


-- ============================================================
-- 8. MONTHLY ANALYSIS
-- ============================================================

-- Monthly revenue, transactions and items
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(
        SUM(transaction_qty * unit_price),
        2
    ) AS revenue
FROM coffee_shop_sales
GROUP BY month
ORDER BY month;


-- Monthly revenue growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS month,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY month)
        )
        /
        LAG(revenue) OVER (ORDER BY month)
        * 100,
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY month;


-- Cumulative revenue trend
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS month,
        SUM(transaction_qty * unit_price) AS monthly_revenue
    FROM coffee_shop_sales
    GROUP BY month
)
SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY month
        ),
        2
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;


-- Average items per transaction by month
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(
        SUM(transaction_qty) / COUNT(*),
        2
    ) AS avg_items_per_transaction
FROM coffee_shop_sales
GROUP BY month
ORDER BY month;


-- Store monthly revenue
SELECT
    store_location,
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(transaction_qty) AS items_sold,
    ROUND(
        SUM(transaction_qty * unit_price),
        2
    ) AS revenue
FROM coffee_shop_sales
GROUP BY
    store_location,
    month
ORDER BY
    month,
    revenue DESC;


-- ============================================================
-- 9. TIME-BASED ANALYSIS
-- ============================================================

-- Sales by hour
SELECT
    HOUR(transaction_time) AS hour,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY HOUR(transaction_time)
ORDER BY hour;


-- Sales by day of week
SELECT
    DAYNAME(transaction_date) AS day_name,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY
    DAYOFWEEK(transaction_date),
    DAYNAME(transaction_date)
ORDER BY DAYOFWEEK(transaction_date);


-- Weekday vs weekend performance
SELECT
    CASE
        WHEN DAYOFWEEK(transaction_date) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    ROUND(
        SUM(transaction_qty * unit_price),
        2
    ) AS revenue,
    ROUND(
        SUM(transaction_qty * unit_price) / COUNT(*),
        2
    ) AS avg_transaction_value
FROM coffee_shop_sales
GROUP BY day_type
ORDER BY revenue DESC;


-- Busiest sales periods
SELECT
    DAYNAME(transaction_date) AS day_name,
    HOUR(transaction_time) AS hour,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY
    DAYOFWEEK(transaction_date),
    DAYNAME(transaction_date),
    HOUR(transaction_time)
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 10. STORE + CATEGORY ANALYSIS
-- ============================================================

-- Store and product category performance
SELECT
    store_location,
    product_category,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY
    store_location,
    product_category
ORDER BY
    store_location,
    revenue DESC;


-- ============================================================
-- 11. STORE + PRODUCT ANALYSIS
-- ============================================================

-- Product performance by store
SELECT
    store_location,
    product_detail,
    product_category,
    SUM(transaction_qty) AS items_sold,
    SUM(transaction_qty * unit_price) AS revenue
FROM coffee_shop_sales
GROUP BY
    store_location,
    product_detail,
    product_category
ORDER BY
    store_location,
    items_sold DESC;


-- ============================================================
-- 12. ADVANCED BUSINESS ANALYSIS
-- ============================================================

-- Best-selling product in each store by revenue
WITH product_sales AS (
    SELECT
        store_location,
        product_detail,
        product_category,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY
        store_location,
        product_detail,
        product_category
),
ranked_products AS (
    SELECT
        store_location,
        product_detail,
        product_category,
        revenue,
        RANK() OVER (
            PARTITION BY store_location
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM product_sales
)
SELECT
    store_location,
    product_detail,
    product_category,
    ROUND(revenue, 2) AS revenue
FROM ranked_products
WHERE revenue_rank = 1
ORDER BY store_location;


-- ============================================================
-- END OF BREWLYTICS SQL ANALYSIS
-- ============================================================