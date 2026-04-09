-- Create account_securities table
-- Note: date not included as a column because trades are not modeled in exercise
CREATE TABLE IF NOT EXISTS silver.account_securities (
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    account_id INT NOT NULL REFERENCES silver.accounts (account_id), -- FK
    ticker_id INT NOT NULL REFERENCES silver.tickers (ticker_id), -- FK
    shares INT NOT NULL,
    value_amount NUMERIC(15, 2) NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE (account_id, ticker_id) -- UNIQUE constraint
);
