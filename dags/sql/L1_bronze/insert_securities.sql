INSERT INTO bronze.stock_prices (
    ticker,
    trade_date,
    open_price,
    close_price,
    high_price,
    low_price,
    date_updated
)
SELECT
    ticker,
    date              AS trade_date,
    open              AS open_price,
    close             AS close_price,
    high              AS high_price,
    low               AS low_price,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.stage_stock_prices
ON CONFLICT (ticker, trade_date) DO NOTHING;
