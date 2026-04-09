INSERT INTO silver.account_securities (
    account_id,
    ticker_id,
    shares,
    value_amount,
    date_updated
)

WITH account_tickers AS (
    SELECT
        id                          AS account_id,
        col ->> 'ticker'            AS ticker,
        (col ->> 'shares')::int     AS shares, 
        (col ->> 'value')::numeric  AS value_amount 
    FROM bronze.accounts
    CROSS JOIN LATERAL json_array_elements(securities) col
)

SELECT
    b.account_id,
    s.ticker_id,
    b.shares,
    b.value_amount,
    CURRENT_TIMESTAMP AS date_updated
FROM account_tickers b
JOIN silver.tickers s ON b.ticker = s.ticker 
ON CONFLICT (account_id, ticker_id)
DO UPDATE SET
    shares = EXCLUDED.shares,
    value_amount = EXCLUDED.value_amount,
    date_updated = CURRENT_TIMESTAMP;
