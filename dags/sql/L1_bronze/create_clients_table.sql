-- Create clients table
CREATE TABLE IF NOT EXISTS bronze.clients (
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    client_id INT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    title TEXT,
    address TEXT NOT NULL,
    uuid UUID NOT NULL UNIQUE,
    client_since DATE NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE (client_id) -- UNIQUE constraint
);

-- Clear existing data and reset identity sequence
-- Note: TRUNCATE faster than DELETE
TRUNCATE bronze.clients RESTART IDENTITY;
