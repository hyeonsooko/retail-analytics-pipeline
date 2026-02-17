INSERT INTO dim_date (date_id, day, month, year, day_of_week)
SELECT DISTINCT
    DATE(transaction_timestamp),
    EXTRACT(DAY FROM transaction_timestamp),
    EXTRACT(MONTH FROM transaction_timestamp),
    EXTRACT(YEAR FROM transaction_timestamp),
    TO_CHAR(transaction_timestamp, 'Day')
FROM raw_transactions
WHERE transaction_timestamp IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

INSERT INTO dim_product (product_id, product_category)
SELECT DISTINCT
    product_id,
    product_category
FROM raw_transactions
WHERE product_id IS NOT NULL
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO dim_customer (customer_id, first_purchase_date, total_orders)
SELECT
    customer_id,
    MIN(DATE(transaction_timestamp)) AS first_purchase_date,
    COUNT(DISTINCT transaction_timestamp) AS total_orders
FROM raw_transactions
WHERE customer_id IS NOT NULL
  AND transaction_timestamp IS NOT NULL
GROUP BY customer_id
ON CONFLICT (customer_id) DO NOTHING;
