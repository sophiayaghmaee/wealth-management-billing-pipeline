-- Create D1_account_types table
CREATE TABLE IF NOT EXISTS gold.D1_account_types (
    SK_account_type_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    account_type_id INT NOT NULL,
    account_type TEXT NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE(account_type_id)
);
