-- Create stock_prices staging table
CREATE TABLE IF NOT EXISTS bronze.stage_stock_prices (
    row INT NOT NULL,
    ticker TEXT NOT NULL,
    date DATE NOT NULL,
    open DOUBLE PRECISION,
    close DOUBLE PRECISION,
    high DOUBLE PRECISION,
    low DOUBLE PRECISION,
    UNIQUE (ticker, date) -- composite UNIQUE constraint
);

-- Clear existing data; TRUNCATE faster than DELETE
TRUNCATE bronze.stage_stock_prices;
