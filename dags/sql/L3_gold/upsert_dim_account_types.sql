INSERT INTO gold.D1_account_types (
    account_type_id,
    account_type,
    date_updated
)

SELECT
    account_type_id,
    account_type,
    CURRENT_TIMESTAMP AS date_updated
FROM silver.account_types
ON CONFLICT (account_type_id) DO NOTHING;
