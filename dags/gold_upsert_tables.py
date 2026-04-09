# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG
from airflow.utils.task_group import TaskGroup


CONN_ID = "postgres_default"

# Upsert Dimension Tables: star schema
upsert_dim_tables = ["account_types", "accounts", "clients", "tickers"]

# Upsert fact Tables: star schema
upsert_fact_tables = ["balance_ticker_daily"]


def upsert_table_task_group(group_id, tables):
    with TaskGroup(group_id) as group:
        previous_task = None
        for table in tables:
            task = SQLExecuteQueryOperator(
                task_id=f"upsert_{group_id.split("_")[1]}_{table}_table",
                conn_id=CONN_ID,
                sql=f"upsert_{group_id.split("_")[1]}_{table}.sql",
            )
            if previous_task:
                previous_task >> task
            previous_task = task
    return group


with DAG(
    dag_id="dag_gold_upsert_tables",
    description="Upsert data into gold layer tables (denormalized, constraints enforced)",
    start_date=datetime(2025, 9, 1),
    schedule=None,
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L3_gold"],
    tags=["gold", "upsert tables"],
) as dag:

    # Truncate; Insert data into D0_date dimension table
    insert_dim_date = SQLExecuteQueryOperator(
        task_id=f"insert_dim_date",
        conn_id=CONN_ID,
        sql=f"insert_dim_date.sql",
    )
    
    # Upsert Task Groups
    upsert_dim_task_group = upsert_table_task_group(
        "upsert_dim_tables", upsert_dim_tables
    )
    upsert_fact_task_group = upsert_table_task_group(
        "upsert_fact_tables", upsert_fact_tables
    )

# Chain Groups
insert_dim_date >> upsert_dim_task_group >> upsert_fact_task_group
