INSERT INTO bronze.accounts (
    client_id,
    type,
    owner,
    annual_management_fee,
    custodian,
    current_balance,
    account_opened,
    uuid,
    securities,
    date_updated
)
SELECT
    client_id,
    type,
    owner,
    annual_management_fee,
    custodian,
    current_balance,
    account_opened,
    uuid,
    securities,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.stage_accounts;
