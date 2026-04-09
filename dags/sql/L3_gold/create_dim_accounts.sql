-- Create D1_accounts table
CREATE TABLE IF NOT EXISTS gold.D1_accounts (
    SK_account_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    account_id INT NOT NULL,
    date_account_opened DATE NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE(account_id)
);
