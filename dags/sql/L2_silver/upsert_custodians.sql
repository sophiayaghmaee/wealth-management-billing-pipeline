INSERT INTO silver.custodians (
    custodian,
    date_updated
)

SELECT DISTINCT
    b.custodian,
    CURRENT_TIMESTAMP AS date_updated
FROM bronze.accounts b
WHERE b.custodian IS NOT NULL
ON CONFLICT (custodian) DO NOTHING;
