INSERT INTO bronze.stage_accounts (
    type,
    owner,
    client_id,
    annual_management_fee,
    custodian,
    current_balance,
    account_opened,
    uuid,
    securities
)
SELECT
    type,
    owner,
    client_id,
    annual_management_fee / 100,
    custodian,
    current_balance,
    account_opened,
    uuid,
    securities
FROM jsonb_to_recordset('{{ ti.xcom_pull(task_ids="get_account_data") }}'::jsonb) -- convert string from XCom into JSONB
AS t(
    type TEXT,
    owner TEXT,
    client_id INT,
    annual_management_fee NUMERIC,
    custodian TEXT,
    current_balance NUMERIC,
    account_opened DATE,
    uuid UUID,
    securities JSON
);
