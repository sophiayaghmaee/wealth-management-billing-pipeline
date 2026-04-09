INSERT INTO gold.D1_tickers (
    ticker_id,
    ticker,
    date_updated
)

SELECT DISTINCT
    ticker_id,
    ticker,
    CURRENT_TIMESTAMP AS date_updated
FROM silver.tickers
ON CONFLICT (ticker_id)
DO UPDATE SET
    ticker = EXCLUDED.ticker,
    date_updated = EXCLUDED.date_updated;
