-- ==============================================================================
-- RetailEdge Advanced Analytics: Window Functions & Growth Metrics
-- ==============================================================================

USE retailedge;

-- ------------------------------------------------------------------------------
-- Query 1: Rank Orders Within Each Category (Top-Ranked Order Value)
-- ------------------------------------------------------------------------------

WITH RankedCategoryOrders AS (
    SELECT
        p.category AS product_category,
        o.order_id,
        o.customer_id,
        ROUND(o.quantity * o.unit_price * (1 - COALESCE(o.discount, 0)), 2) AS total_order_value,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY (o.quantity * o.unit_price * (1 - COALESCE(o.discount, 0))) DESC
        ) AS category_order_rank
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
)
SELECT
    product_category,
    order_id,
    customer_id,
    total_order_value,
    category_order_rank
FROM RankedCategoryOrders
ORDER BY
    product_category ASC,
    category_order_rank ASC;


-- ------------------------------------------------------------------------------
-- Query 2: Customer Spend Leaderboard (Ranked Customer Total Spend)
-- ------------------------------------------------------------------------------

SELECT
    customer_id,
    ROUND(SUM(quantity * unit_price * (1 - COALESCE(discount, 0))), 2) AS total_spend,
    RANK() OVER (
        ORDER BY SUM(quantity * unit_price * (1 - COALESCE(discount, 0))) DESC
    ) AS spend_rank,
    DENSE_RANK() OVER (
        ORDER BY SUM(quantity * unit_price * (1 - COALESCE(discount, 0))) DESC
    ) AS dense_spend_rank
FROM orders
GROUP BY customer_id
ORDER BY spend_rank ASC;


-- ------------------------------------------------------------------------------
-- Query 3: Order Value Trajectory (Comparing Current to Previous Order)
-- ------------------------------------------------------------------------------

SELECT
    order_id,
    customer_id,
    order_date,
    ROUND(quantity * unit_price * (1 - COALESCE(discount, 0)), 2) AS order_value,
    ROUND(
        LAG(quantity * unit_price * (1 - COALESCE(discount, 0))) OVER (
            ORDER BY order_date ASC, order_id ASC
        ), 2
    ) AS previous_order_value
FROM orders
ORDER BY
    order_date ASC,
    order_id ASC;


-- ------------------------------------------------------------------------------
-- Query 4: Order-over-Order Percentage Growth Rate
-- ------------------------------------------------------------------------------

WITH OrderValues AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        ROUND(quantity * unit_price * (1 - COALESCE(discount, 0)), 2) AS order_value,
        ROUND(
            LAG(quantity * unit_price * (1 - COALESCE(discount, 0))) OVER (
                ORDER BY order_date ASC, order_id ASC
            ), 2
        ) AS previous_order_value
    FROM orders
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_value,
    previous_order_value,
    -- Safely calculate percentage change; returns NULL when previous value is 0 or NULL
    ROUND(
        ((order_value - previous_order_value) / NULLIF(previous_order_value, 0)) * 100,
        2
    ) AS percentage_change
FROM OrderValues
ORDER BY
    order_date ASC,
    order_id ASC;