INSERT INTO bronze.clients (
    client_id,
    first_name,
    last_name,
    title,
    address,
    uuid,
    client_since,
    date_updated
)
SELECT
    client_id,
    first_name,
    last_name,
    title,
    address,
    uuid,
    client_since,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.stage_clients;
