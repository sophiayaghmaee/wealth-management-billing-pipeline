INSERT INTO silver.accounts (
    account_id,
    account_type_id,
    client_id,
    custodian_id,
    annual_management_fee,
    current_balance,
    date_account_opened,
    date_updated
)

SELECT
    b.id                 AS account_id,
    s1.account_type_id,
    s2.client_id,
    s3.custodian_id,
    b.annual_management_fee,
    b.current_balance,
    b.account_opened     AS date_account_opened,
    CURRENT_TIMESTAMP
FROM bronze.accounts b
JOIN silver.account_types s1 ON b.type = s1.account_type
JOIN silver.clients s2 ON b.owner = s2.first_name || ' ' || s2.last_name
JOIN silver.custodians s3 ON b.custodian = s3.custodian
ON CONFLICT (account_id)
DO UPDATE SET
    account_type_id = EXCLUDED.account_type_id,
    client_id = EXCLUDED.client_id,
    custodian_id = EXCLUDED.custodian_id,
    annual_management_fee = EXCLUDED.annual_management_fee,
    current_balance = EXCLUDED.current_balance,
    date_account_opened = EXCLUDED.date_account_opened,
    date_updated = CURRENT_TIMESTAMP;
