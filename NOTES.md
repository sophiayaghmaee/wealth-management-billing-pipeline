# Project Notes

## Approach

Designed the pipeline around a medallion architecture to keep raw data intact at the bronze layer while progressively cleaning and modeling data through silver and gold.

**Bronze** uses staging tables as a buffer before inserting into the main raw tables — this makes reruns safe and gives a place to inspect data before it propagates downstream.

**Silver** enforces FK constraints and uses `ON CONFLICT` upserts throughout, making daily runs idempotent.

**Gold** uses a star schema with a date dimension (D0), client/account/ticker dimensions (D1), and a grain-level fact table (`F_balance_ticker_daily`) at client × account × date × ticker. Two views sit on top:
- `V_balance_daily` — aggregated by account/day
- `V_balance_quarterly` — average daily balance and computed fees by quarter

Daily balance is calculated as:
```
avg_price = (open + close) / 2
daily_balance = shares × avg_price
```

Quarterly fee is calculated as:
```
billing_fee = quarter_avg_daily_balance × (annual_management_fee / 4)
```

## Design Decisions

- **Dynamic task mapping** used in `dag_bronze_load_securities` to parallelize ingestion across all ticker CSVs at runtime — cleaner than hardcoding one task per file.
- **Resource pool** (`pool_insert_securities`) configured in the Airflow UI to throttle parallel DB writes during securities staging.
- **Upsert order** in silver matters — account_types, clients, custodians, and tickers are loaded before accounts and account_securities to satisfy FK constraints.
- **Database:** For local development, bronze/silver/gold schemas share the same PostgreSQL instance as Airflow's internal metadata database — separated by schema, not by server. In production this would point to a dedicated data warehouse (e.g. Snowflake), keeping orchestration infrastructure separate from the data warehouse.

## Local Setup

- Airflow UI: http://localhost:8080/dags
- pgAdmin: http://localhost:8081/browser/

Register the Postgres connection:
```bash
./airflow.sh connections add postgres_default --conn-uri "postgresql://airflow:airflow@postgres/airflow" --conn-extra '{"sslmode": "prefer"}' || true
```

Register the `pool_insert_securities` pool in the Airflow UI (Admin → Pools) before running the securities DAG.

## References

- https://airflow.apache.org/docs/apache-airflow/stable/tutorial/fundamentals.html
- https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/dynamic-task-mapping.html
- https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/params.html
- https://airflow.apache.org/docs/apache-airflow/stable/best-practices.html
- https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html
- https://airflow.apache.org/docs/apache-airflow-providers-common-sql/stable/operators.html
- https://airflow.apache.org/docs/apache-airflow/2.8.2/_api/airflow/operators/python/index.html#airflow.operators.python.PythonOperator
- https://www.postgresql.org/docs/9.4/functions-json.html
