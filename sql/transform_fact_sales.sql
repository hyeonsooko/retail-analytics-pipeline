CREATE TABLE IF NOT EXISTS fact_sales (
    sales_id SERIAL PRIMARY KEY,
    date_id DATE REFERENCES dim_date(date_id),
    customer_id TEXT REFERENCES dim_customer(customer_id),
    product_id TEXT REFERENCES dim_product(product_id),
    store_location TEXT,
    payment_method TEXT,
    quantity INT,
    gross_amount NUMERIC(12,2),
    discount_amount NUMERIC(12,2),
    net_amount NUMERIC(12,2)
);
INSERT INTO fact_sales (
    date_id,
    customer_id,
    product_id,
    store_location,
    payment_method,
    quantity,
    gross_amount,
    discount_amount,
    net_amount
)
SELECT
    DATE(transaction_timestamp) AS date_id,
    customer_id,
    product_id,
    store_location,
    payment_method,
    quantity,
    quantity * unit_price AS gross_amount,
    (quantity * unit_price) * (COALESCE(discount_percent, 0) / 100) AS discount_amount,
    (quantity * unit_price) -
        ((quantity * unit_price) * (COALESCE(discount_percent, 0) / 100)) AS net_amount
FROM raw_transactions
