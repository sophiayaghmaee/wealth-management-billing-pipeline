-- Create F_daily_balance table
CREATE TABLE IF NOT EXISTS gold.F_balance_ticker_daily (
    SK_client_id INT NOT NULL REFERENCES gold.D1_clients (SK_client_id), -- FK,
    SK_account_id INT NOT NULL REFERENCES gold.D1_accounts (SK_account_id), -- FK,
    SK_date_id INT NOT NULL REFERENCES gold.D0_date (SK_date_id), -- FK,
    SK_account_type_id INT NOT NULL REFERENCES gold.D1_account_types (SK_account_type_id), -- FK,
    SK_ticker_id INT NOT NULL REFERENCES gold.D1_tickers (SK_ticker_id), -- FK,
    annual_management_fee NUMERIC(5, 5) NOT NULL,
    shares INT NOT NULL,
    avg_price NUMERIC(15, 2) NOT NULL,
    daily_balance NUMERIC(15, 2) NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    PRIMARY KEY (SK_client_id, SK_account_id, SK_date_id, SK_account_type_id, SK_ticker_id)
);
