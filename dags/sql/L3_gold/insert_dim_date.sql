-- Note: Leveraged AI here
INSERT INTO gold.D0_date (
    SK_date_id,
    date,
    year,
    month,
    day,
    day_of_week,
    day_name,
    week_of_year,
    quarter,
    year_quarter,
    is_weekend,
    date_updated
)
SELECT
    TO_CHAR(datum, 'YYYYMMDD')::INT AS SK_date_id,
    datum::DATE                                                             AS date,
    EXTRACT(YEAR FROM datum)::INT                                           AS year,
    EXTRACT(MONTH FROM datum)::INT                                          AS month,
    EXTRACT(DAY FROM datum)::INT                                            AS day,
    EXTRACT(ISODOW FROM datum)::INT                                         AS day_of_week,
    TO_CHAR(datum, 'Day')                                                   AS day_name,
    EXTRACT(WEEK FROM datum)::INT                                           AS week_of_year,
    EXTRACT(QUARTER FROM datum)::INT                                        AS quarter,
    TO_CHAR(datum, 'YYYY-"Q"Q')                                             AS year_quarter,
    CASE WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend,
    CURRENT_TIMESTAMP                                                       AS date_updated
FROM generate_series('2000-01-01'::DATE, '2050-12-31'::DATE, '1 day'::INTERVAL) AS datum
WHERE NOT EXISTS (
    SELECT 1 FROM gold.D0_date
);