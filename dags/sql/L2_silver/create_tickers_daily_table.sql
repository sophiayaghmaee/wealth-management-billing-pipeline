-- Create tickers_daily table
CREATE TABLE IF NOT EXISTS silver.tickers_daily (
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    ticker_id INT NOT NULL REFERENCES silver.tickers (ticker_id), -- FK
    trade_date DATE NOT NULL,
    open_price DOUBLE PRECISION,
    close_price DOUBLE PRECISION,
    high_price DOUBLE PRECISION,
    low_price DOUBLE PRECISION,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE (ticker_id, trade_date) -- composite UNIQUE constraint
);
