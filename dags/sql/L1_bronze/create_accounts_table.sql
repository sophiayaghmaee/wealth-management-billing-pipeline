-- Create accounts table
CREATE TABLE IF NOT EXISTS bronze.accounts (
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    client_id INT NOT NULL,
    type TEXT NOT NULL,
    owner TEXT NOT NULL,
    annual_management_fee NUMERIC(5, 5) NOT NULL,
    custodian TEXT NOT NULL,
    current_balance NUMERIC(15, 2) NOT NULL,
    account_opened DATE NOT NULL,
    uuid UUID NOT NULL UNIQUE,
    securities JSON NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL
);

-- Clear existing data and reset identity sequence
-- Note: TRUNCATE faster than DELETE
TRUNCATE bronze.accounts RESTART IDENTITY;
