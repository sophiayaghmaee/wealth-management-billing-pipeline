-- Create accounts table
CREATE TABLE IF NOT EXISTS silver.accounts (
    account_id INT PRIMARY KEY,
    account_type_id INT NOT NULL REFERENCES silver.account_types (account_type_id), -- FK
    client_id INT NOT NULL REFERENCES silver.clients (client_id), -- FK
    custodian_id INT NOT NULL REFERENCES silver.custodians (custodian_id), -- FK
    annual_management_fee NUMERIC(5, 5) NOT NULL,
    current_balance NUMERIC(15, 2) NOT NULL,
    date_account_opened DATE NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL
);
