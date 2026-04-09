COPY bronze.stage_stock_prices (
    row,
    ticker,
    date,
    open,
    close,
    high,
    low
)
FROM '{{ params.filepath }}'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
