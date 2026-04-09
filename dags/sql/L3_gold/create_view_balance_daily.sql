-- Grain: Account, Day

CREATE OR REPLACE VIEW gold.V_balance_daily AS (
    SELECT
        c.client_id,
        a.account_id,
        d.year_quarter,
        d.date,
        c.first_name || ' ' || c.last_name AS client_name,
        ac.account_type,
        MAX(annual_management_fee)         AS annual_management_fee,
        SUM(daily_balance)                 AS daily_balance
    FROM gold.F_balance_ticker_daily t
    JOIN gold.D1_clients c ON t.SK_client_id = c.SK_client_id
    JOIN gold.D1_accounts a ON t.SK_account_id = a.SK_account_id
    JOIN gold.D0_date d ON t.SK_date_id = d.SK_date_id
    JOIN gold.D1_account_types ac ON t.SK_account_type_id = ac.SK_account_type_id
    GROUP BY 
        c.client_id,
        a.account_id,
        d.year_quarter,
        d.date,
        c.first_name || ' ' || c.last_name,
        ac.account_type
);
