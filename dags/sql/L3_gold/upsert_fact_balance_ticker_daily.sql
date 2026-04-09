-- Grain: Client, Account, Ticker, Day

INSERT INTO gold.F_balance_ticker_daily (
    SK_client_id,
    SK_account_id,
    SK_date_id,
    SK_account_type_id,
    SK_ticker_id,
    annual_management_fee,
    shares,
    avg_price,
    daily_balance,
    date_updated
)
SELECT
    g1.SK_client_id,
    g2.SK_account_id,
    g3.SK_date_id,
    g4.SK_account_type_id,
    g5.SK_ticker_id,
	s1.annual_management_fee,
    s2.shares,
    (s3.open_price + s3.close_price)/2               AS avg_price, -- use avg price since trade buy/sell time unknown
    s2.shares * ((s3.open_price + s3.close_price))/2 AS daily_balance,
    CURRENT_TIMESTAMP AS date_updated
FROM silver.accounts s1
JOIN silver.account_securities s2
    ON s1.account_id = s2.account_id
JOIN gold.D1_clients g1
    ON s1.client_id = g1.client_id
JOIN gold.D1_accounts g2
    ON s1.account_id = g2.account_id
JOIN gold.D0_date g3
	ON s1.date_account_opened <= g3.date  -- ensures dates start from account open
	AND g3.date <= CURRENT_TIMESTAMP
JOIN gold.D1_account_types g4
    ON s1.account_type_id = g4.account_type_id
JOIN gold.D1_tickers g5
	ON s2.ticker_id = g5.ticker_id
JOIN silver.tickers_daily s3
	ON g5.ticker_id = s3.ticker_id
	AND g3.date = s3.trade_date
ON CONFLICT (SK_client_id, SK_account_id, SK_date_id, SK_account_type_id, SK_ticker_id)
DO UPDATE SET
    annual_management_fee = EXCLUDED.annual_management_fee,
    shares = EXCLUDED.shares,
    daily_balance = EXCLUDED.daily_balance,
    date_updated = EXCLUDED.date_updated;
