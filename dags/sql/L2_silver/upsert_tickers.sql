INSERT INTO silver.tickers (
    ticker
)

SELECT DISTINCT
    b.ticker
FROM bronze.stock_prices b
WHERE b.ticker IS NOT NULL
ON CONFLICT (ticker) DO NOTHING;
