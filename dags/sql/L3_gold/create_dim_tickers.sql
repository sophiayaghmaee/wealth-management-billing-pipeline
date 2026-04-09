-- Create D1_tickers table
CREATE TABLE IF NOT EXISTS gold.D1_tickers (
    SK_ticker_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    ticker_id INT NOT NULL,
    ticker TEXT NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE(ticker_id)
);
