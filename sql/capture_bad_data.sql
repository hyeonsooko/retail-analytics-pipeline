INSERT INTO etl_error_log (error_type, error_description, row_data)
SELECT
    'INVALID_QUANTITY',
    'Quantity <= 0',
    to_jsonb(r)
FROM raw_transactions r
WHERE quantity <= 0;

INSERT INTO etl_error_log (error_type, error_description, row_data)
SELECT
    'MISSING_KEY',
    'Missing customer_id or product_id',
    to_jsonb(r)
FROM raw_transactions r
WHERE customer_id IS NULL OR product_id IS NULL;