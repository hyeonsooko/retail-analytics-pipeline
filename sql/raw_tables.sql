DROP TABLE IF EXISTS raw_transactions;

CREATE TABLE raw_transactions (
    customer_id           TEXT,
    product_id            TEXT,
    quantity              INT,
    unit_price            NUMERIC(10,2),
    transaction_timestamp TIMESTAMP,
    payment_method        TEXT,
    store_location        TEXT,
    product_category      TEXT,
    discount_percent      NUMERIC(5,2),
    total_amount          NUMERIC(12,2),
    source_file           TEXT,
    ingestion_timestamp   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
