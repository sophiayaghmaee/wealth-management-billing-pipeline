# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG
from airflow.utils.task_group import TaskGroup


CONN_ID = "postgres_default"

# Create Dimension Tables: star schema
create_dim_tables = ["account_types", "accounts", "clients", "date", "tickers"]

# fact Tables: star schema
create_fact_tables = ["balance_ticker_daily"]


def create_table_task_group(group_id, tables):
    with TaskGroup(group_id) as group:
        previous_task = None
        for table in tables:
            task = SQLExecuteQueryOperator(
                task_id=f"create_{group_id.split("_")[1]}_{table}_table",
                conn_id=CONN_ID,
                sql=f"create_{group_id.split("_")[1]}_{table}.sql",
            )
            if previous_task:
                previous_task >> task
            previous_task = task
    return group


with DAG(
    dag_id="dag_gold_create_tables",
    description="Create tables in gold layer (denormalized, constraints enforced)",
    start_date=datetime(2025, 9, 1),
    schedule=None,
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L3_gold"],
    tags=["gold", "create tables"],
) as dag:

    # Create Task Groups
    create_dim_task_group = create_table_task_group(
        "create_dim_tables", create_dim_tables
    )
    create_fact_task_group = create_table_task_group(
        "create_fact_tables", create_fact_tables
    )

# Chain Groups
create_dim_task_group >> create_fact_task_group
