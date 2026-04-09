INSERT INTO gold.D1_accounts (
    account_id,
    date_account_opened,
    date_updated
)

SELECT
    account_id,
    date_account_opened,
    CURRENT_TIMESTAMP AS date_updated
FROM silver.accounts
ON CONFLICT (account_id) DO NOTHING;
