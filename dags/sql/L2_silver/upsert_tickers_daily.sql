INSERT INTO silver.tickers_daily (
    ticker_id,
    trade_date,
    open_price,
    close_price,
    high_price,
    low_price,
    date_updated
)

SELECT
    s.ticker_id,
    b.trade_date,
    b.open_price,
    b.close_price,
    b.high_price,
    b.low_price,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.stock_prices b
JOIN silver.tickers s
    ON b.ticker = s.ticker
ON CONFLICT (ticker_id, trade_date)
DO UPDATE SET
    open_price = EXCLUDED.open_price,
    close_price = EXCLUDED.close_price,
    high_price = EXCLUDED.high_price,
    low_price = EXCLUDED.low_price,
    date_updated = CURRENT_TIMESTAMP;
