import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
from pathlib import Path
from pandas import isna
import numpy as np
from datetime import datetime, timedelta

start_date = datetime(2023, 1, 1)
end_date = start_date + timedelta(days=30)

date_range_days = (end_date - start_date).days

BASE_DIR = Path(__file__).resolve().parent
CSV_PATH = BASE_DIR.parent / "data" / "raw" /"transactions.csv"

DB_CONFIG = {
    "host": "localhost",
    "dbname": "retail_analytics",
    "user": "analytics_user",
    "password": "analytics_pass",
    "port": 5432,
}

EXPECTED_COLUMNS = {
    "CustomerID",
    "ProductID",
    "Quantity",
    "Price",
    "TransactionDate",
    "PaymentMethod",
    "StoreLocation",
    "ProductCategory",
    "DiscountApplied(%)",
    "TotalAmount",
}

def main():
    df = pd.read_csv(CSV_PATH)

    missing_cols = EXPECTED_COLUMNS - set(df.columns)
    if missing_cols:
        raise ValueError(f"Missing columns in CSV: {missing_cols}")
    
    df = df.rename(columns={
    "CustomerID": "customer_id",
    "ProductID": "product_id",
    "Quantity": "quantity",
    "Price": "unit_price",
    "TransactionDate": "transaction_timestamp",
    "PaymentMethod": "payment_method",
    "StoreLocation": "store_location",
    "ProductCategory": "product_category",
    "DiscountApplied(%)": "discount_percent",
    "TotalAmount": "total_amount",
})

    df["transaction_timestamp"] = pd.to_datetime(
        df["transaction_timestamp"],
        format="%m/%d/%Y",
        errors="raise"
    )

    records = [
        (
            row.customer_id,
            row.product_id,
            row.quantity,
            row.unit_price,
            None if isna(row.transaction_timestamp) else row.transaction_timestamp,
            row.payment_method,
            row.store_location,
            row.product_category,
            row.discount_percent,
            row.total_amount,
            CSV_PATH.name,
        )
        for row in df.itertuples(index=False)
    ]

    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()

    insert_sql = """
        INSERT INTO raw_transactions (
            customer_id,
            product_id,
            quantity,
            unit_price,
            transaction_timestamp,
            payment_method,
            store_location,
            product_category,
            discount_percent,
            total_amount,
            source_file
        ) VALUES %s
    """

    execute_values(cursor, insert_sql, records, page_size=1000)
    conn.commit()

    cursor.close()
    conn.close()

    print(f"Inserted {len(records)} records into raw_transactions table.")

if __name__ == "__main__":
    main()
