-- Grain: Account, Quarter (YYYY-Q#)

CREATE OR REPLACE VIEW gold.V_balance_quarterly AS (
    SELECT
        year_quarter,
        client_id,
        client_name,
        account_id,
        account_type,
        MAX(annual_management_fee)                          AS annual_management_fee,
        AVG(daily_balance)                                  AS quarter_avg_daily_balance,
        AVG(daily_balance) * (MAX(annual_management_fee)/4) AS billing_fees_collected
    FROM gold.V_balance_daily
    GROUP BY 
        year_quarter,
        client_id,
        client_name,
        account_id,
        account_type
);
