-- Create D1_clients table
CREATE TABLE IF NOT EXISTS gold.D1_clients (
    SK_client_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    client_id INT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    address TEXT NOT NULL,
    client_since DATE NOT NULL,
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE(client_id)
);
