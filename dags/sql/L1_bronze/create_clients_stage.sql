-- Create clients staging table
CREATE TABLE IF NOT EXISTS bronze.stage_clients (
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    client_id INT NOT NULL,
    title TEXT,
    address TEXT NOT NULL,
    uuid UUID NOT NULL UNIQUE,
    client_since DATE NOT NULL,
    UNIQUE (client_id) -- UNIQUE constraint
);

-- Clear existing data; TRUNCATE faster than DELETE
TRUNCATE bronze.stage_clients;
