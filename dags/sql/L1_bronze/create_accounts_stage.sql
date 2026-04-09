-- Create accounts staging table
CREATE TABLE IF NOT EXISTS bronze.stage_accounts (
    type TEXT NOT NULL,
    owner TEXT NOT NULL,
    client_id INT NOT NULL,
    annual_management_fee NUMERIC(5, 5) NOT NULL,
    custodian TEXT NOT NULL,
    current_balance NUMERIC(15, 2) NOT NULL,
    account_opened DATE NOT NULL,
    uuid UUID NOT NULL UNIQUE,
    securities JSON NOT NULL
);

-- Clear existing data; TRUNCATE faster than DELETE
TRUNCATE bronze.stage_accounts;
