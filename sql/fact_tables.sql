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
