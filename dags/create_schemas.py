# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG


CONN_ID = "postgres_default"

# Task: Single Run (no schedule needed)
with DAG(
    dag_id="create_schemas",
    description="Create schemas in db, following Medallion architecture (bronze, silver, gold)",
    start_date=datetime(2025, 9, 1),
    schedule=None,
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql"],
    tags=["schemas"],
) as dag:

    # Create schemas (if not exists)
    create_schemas = SQLExecuteQueryOperator(
        task_id="create_schemas",
        conn_id=CONN_ID,
        sql="create_schemas.sql",
        split_statements=True,
    )
