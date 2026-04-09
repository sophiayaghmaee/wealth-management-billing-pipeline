INSERT INTO silver.clients (
    client_id,
    first_name,
    last_name,
    address,
    client_since,
    date_updated
)

SELECT
    client_id,
    first_name,
    last_name,
    address,
    client_since,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.clients
ON CONFLICT (client_id)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    address = EXCLUDED.address,
    client_since = EXCLUDED.client_since,
    date_updated = CURRENT_TIMESTAMP;
