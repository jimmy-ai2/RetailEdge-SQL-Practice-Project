-- ==============================================================================
-- RetailEdge E-Commerce Data Analysis & Business Metrics
-- ==============================================================================

USE retailedge;

-- ------------------------------------------------------------------------------
-- Section 1: Baseline Overall Aggregates
-- ------------------------------------------------------------------------------

-- Task 1: Total Revenue Generated Across All Orders
SELECT
    ROUND(SUM(quantity * unit_price * (1 - COALESCE(discount, 0))), 2) AS total_revenue
FROM orders;

-- Task 2: Average Discount Applied Across All Orders
SELECT
    ROUND(AVG(COALESCE(discount, 0)), 4) AS average_discount
FROM orders;

-- Task 3: Largest Single Order Quantity Recorded
SELECT
    MAX(quantity) AS max_quantity
FROM orders;

-- Task 4: Total Number of Orders Placed
SELECT
    COUNT(order_id) AS total_orders
FROM orders;


-- ------------------------------------------------------------------------------
-- Section 2: Category and Customer Level Breakdowns
-- ------------------------------------------------------------------------------

-- Task 5: Total Quantity Sold Per Product Category
SELECT
    p.category AS product_category,
    SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity_sold DESC;

-- Task 6: Average Unit Price Per Category
SELECT
    category AS product_category,
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM products
GROUP BY category
ORDER BY average_unit_price DESC;

-- Task 7: Order Count Per Customer (Ranked)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders_placed
FROM orders
GROUP BY customer_id
ORDER BY total_orders_placed DESC;


-- ------------------------------------------------------------------------------
-- Section 3: Multi-Column Grouping & Group Filtering (HAVING)
-- ------------------------------------------------------------------------------

-- Task 8: Total Quantity Sold and Revenue by Product Category and Discount Rate
SELECT
    p.category AS product_category,
    COALESCE(o.discount, 0.00) AS discount_rate,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_quantity_sold,
    ROUND(SUM(o.quantity * o.unit_price * (1 - COALESCE(o.discount, 0))), 2) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.category,
    o.discount
ORDER BY
    p.category ASC,
    o.discount ASC;

-- Task 9: Categories with Total Quantity Sold Greater Than 10
SELECT
    p.category AS product_category,
    SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
-- Filter groups to include categories where aggregate quantity exceeds 10
HAVING SUM(o.quantity) > 10
ORDER BY total_quantity_sold DESC;

-- Task 10: Customers Who Have Placed More Than 2 Orders
SELECT
    customer_id,
    COUNT(order_id) AS total_orders_placed
FROM orders
GROUP BY customer_id
-- Filter groups to include customers who have placed strictly more than 2 orders
HAVING COUNT(order_id) > 2
ORDER BY total_orders_placed DESC;