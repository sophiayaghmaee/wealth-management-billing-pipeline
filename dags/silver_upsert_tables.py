# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG
from airflow.utils.task_group import TaskGroup


CONN_ID = "postgres_default"

# Tables to upsert
# Note: upsert order matters because of FK constraints
upsert_tables = [
    "account_types",
    "clients",
    "custodians",
    "tickers",
    "accounts",
    "account_securities",
    "tickers_daily",
]


with DAG(
    dag_id="dag_silver_upsert_tables",
    description="Upsert data into tables in silver layer (normalized, constraints enforced)",
    start_date=datetime(2025, 9, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L2_silver"],
    tags=["silver", "create tables"],
) as dag:

    # Create TaskGroup for upserting tables
    with TaskGroup("upsert_tables"):
        previous_task = None
        for table in upsert_tables:
            task = SQLExecuteQueryOperator(
                task_id=f"upsert_{table}_table",
                conn_id=CONN_ID,
                sql=f"upsert_{table}.sql",
            )
            if previous_task:
                previous_task >> task
            previous_task = task
