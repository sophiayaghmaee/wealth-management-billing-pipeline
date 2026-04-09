# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG
from airflow.utils.task_group import TaskGroup


CONN_ID = "postgres_default"

# Independent Tables: no FK references
independent_tables = ["account_types", "clients", "custodians", "tickers"]

# Dependent Tables: FK references
dependent_tables = ["accounts", "account_securities", "tickers_daily"]


def create_table_task_group(group_id, tables):
    with TaskGroup(group_id) as group:
        previous_task = None
        for table in tables:
            task = SQLExecuteQueryOperator(
                task_id=f"create_{table}_table",
                conn_id=CONN_ID,
                sql=f"create_{table}_table.sql",
            )
            if previous_task:
                previous_task >> task
            previous_task = task
    return group


with DAG(
    dag_id="dag_silver_create_tables",
    description="Create tables in silver layer (normalized, constraints enforced)",
    start_date=datetime(2025, 9, 1),
    schedule=None,
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L2_silver"],
    tags=["silver", "create tables"],
) as dag:

    # Create Task Groups
    independent_task_group = create_table_task_group(
        "independent_tables", independent_tables
    )
    dependent_task_group = create_table_task_group("dependent_tables", dependent_tables)

# Chain Groups
independent_task_group >> dependent_task_group
