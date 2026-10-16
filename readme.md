# RetailEdge SQL Practice Project

This project was created as part of my own learning journey with SQL. I used it to practice core database concepts, explore how data relationships work, and build confidence with real-world business-style queries.

The idea was simple: use a small retail dataset to learn how to think in SQL and how to turn raw data into useful insights.

## Why I built this project

I used RetailEdge to practice and understand:

- writing queries to explore and filter data
- joining related tables together
- using aggregate functions like `SUM`, `AVG`, `COUNT`, and `MAX`
- grouping and summarizing results
- filtering grouped data with `HAVING`
- improving my understanding of window functions and ranking

This project helped me move from writing basic SQL statements to thinking more analytically about what questions the data can answer.

## Project structure

- `schema.sql` – creates the database and populates it with sample retail data
- `Part_1_queries.sql` – foundational SQL queries for practicing joins, aggregations, and filtering
- `Part_2_queries.sql` – advanced analytics using window functions to rank orders and customers, compare consecutive order values, and calculate order-over-order percentage growth
- `readme.md` – project summary and learning notes

## Database overview

The database contains three main tables used to model a small retail business.

### `products`

Stores product information.

| Column           | Type           | Description               |
| ---------------- | -------------- | ------------------------- |
| `product_id`     | `INT`          | Unique product identifier |
| `name`           | `VARCHAR(100)` | Product name              |
| `category`       | `VARCHAR(50)`  | Product category          |
| `unit_price`     | `DECIMAL(8,2)` | Price per unit            |
| `stock_quantity` | `INT`          | Available stock           |

### `customers`

Stores customer details.

| Column            | Type           | Description                                      |
| ----------------- | -------------- | ------------------------------------------------ |
| `customer_id`     | `INT`          | Unique customer ID                               |
| `name`            | `VARCHAR(100)` | Customer name                                    |
| `region`          | `VARCHAR(50)`  | Customer region                                  |
| `membership_tier` | `VARCHAR(20)`  | Membership level such as Gold, Silver, or Bronze |

### `orders`

Stores each order entry.

| Column        | Type           | Description                     |
| ------------- | -------------- | ------------------------------- |
| `order_id`    | `INT`          | Unique order ID                 |
| `customer_id` | `INT`          | Related customer                |
| `product_id`  | `INT`          | Related product                 |
| `quantity`    | `INT`          | Units purchased                 |
| `unit_price`  | `DECIMAL(8,2)` | Unit price at the time of order |
| `discount`    | `DECIMAL(4,2)` | Discount applied                |
| `order_date`  | `DATE`         | Date the order was placed       |

## Relationship between tables

- One customer can place many orders
- One product can appear in many orders
- Each order belongs to one customer and one product

This structure helped me practice key relational database concepts, especially joins and foreign key relationships.

## How to run it

1. Open MySQL or MariaDB.
2. Connect to your database server.
3. Run the script in `schema.sql` to create the database and insert the sample data.
4. Run the queries in `Part_1_queries.sql` to practice core SQL.
5. Run the queries in `Part_2_queries.sql` to explore ranking, order-value comparisons, and growth analysis.

## Skills I practiced with this project

This project was useful for learning:

- `CREATE TABLE` and database setup
- `INSERT INTO` for adding records
- `SELECT` statements for reading data
- `JOIN` statements to connect tables
- `GROUP BY` for grouping records
- aggregate functions such as `SUM`, `AVG`, `COUNT`, and `MAX`
- `HAVING` to filter grouped results
- window functions like `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, and `LAG()`
- common table expressions (CTEs) to organize multi-step analytical queries
- order-over-order percentage growth calculations, including handling missing or zero previous values
- interpreting business data and making sense of results

## Questions this dataset helps answer

Using this project, I was able to practice questions like:

- What is the total revenue generated?
- What is the average discount applied?
- Which category had the highest quantity sold?
- Which customers placed the most orders?
- Who were the biggest spenders?
- Which orders have the highest value within each product category?
- How does each order's value compare with the previous order?
- What is the percentage change in order value from one order to the next?

## Example SQL query

```sql
SELECT
    p.category AS product_category,
    SUM(o.quantity) AS total_quantity_sold
FROM retailedge.orders o
JOIN retailedge.products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity_sold DESC;
```

This kind of query was one of the first examples that helped me understand how data from different tables can be combined to answer a business question.

## Learning reflection

This project was not just about writing SQL correctly; it was about learning how to reason with data. It taught me how to ask questions, test assumptions, read results carefully, and understand the story behind the numbers.

That is why this repository matters to me: it represents a practical step in learning SQL through a real, small, and manageable dataset.

## Final note

RetailEdge is a personal learning project that helped me build confidence in SQL, especially around data modeling, joins, aggregations, and analytical thinking. It is a simple database, but it was a meaningful part of my learning process.

I hope this project can also help others who are starting out and want a clear, hands-on way to practice SQL concepts.
