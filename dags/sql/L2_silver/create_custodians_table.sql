-- Create custodians table
CREATE TABLE IF NOT EXISTS silver.custodians (
    custodian_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    custodian TEXT NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE (custodian) -- UNIQUE constraint
);
