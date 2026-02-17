CREATE TABLE IF NOT EXISTS etl_error_log (
    error_id SERIAL PRIMARY KEY,
    error_type TEXT,
    error_description TEXT,
    row_data JSONB,
    error_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);