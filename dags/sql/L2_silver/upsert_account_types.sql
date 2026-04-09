INSERT INTO silver.account_types (
    account_type
)

SELECT DISTINCT
    b.type AS account_type
FROM bronze.accounts b
WHERE b.type IS NOT NULL
ON CONFLICT (account_type) DO NOTHING;
