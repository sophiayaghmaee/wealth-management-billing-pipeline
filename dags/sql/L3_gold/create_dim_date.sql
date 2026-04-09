-- Create D0_date table
CREATE TABLE IF NOT EXISTS gold.D0_date (
    SK_date_id INT PRIMARY KEY, -- e.g., 20230903 for Sept 3, 2025
    date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(9) NOT NULL,
    week_of_year INT NOT NULL,
    quarter INT NOT NULL,
    year_quarter VARCHAR(9) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN NOT NULL DEFAULT FALSE, -- TODO: update later
    date_inserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP NOT NULL,
    UNIQUE(date)
);
