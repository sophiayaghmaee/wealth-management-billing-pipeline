-- Create account_types table
CREATE TABLE IF NOT EXISTS silver.account_types (
    account_type_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    account_type TEXT NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (account_type) -- UNIQUE constraint
);
