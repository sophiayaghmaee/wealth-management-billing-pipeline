COPY bronze.stage_clients (
    first_name,
    last_name,
    client_id,
    title,
    address,
    uuid,
    client_since
)
FROM '{{ params.filepath }}'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
