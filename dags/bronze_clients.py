# python packages
from datetime import datetime, timedelta

from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG

CONN_ID = "postgres_default"

with DAG(
    dag_id="dag_bronze_load_clients",
    description="Loads clients from CSV in folder: dags/data",
    start_date=datetime(2025, 9, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L1_bronze"],
    tags=["bronze", "load", "clients"],
) as dag:

    # 1. Create clients table:
    create_clients_table = SQLExecuteQueryOperator(
        task_id="create_raw_clients_table",
        conn_id=CONN_ID,
        sql="create_clients_table.sql",
        split_statements=True,
    )

    # 2. Create clients staging table:
    create_clients_stage = SQLExecuteQueryOperator(
        task_id="create_raw_clients_stage",
        conn_id=CONN_ID,
        sql="create_clients_stage.sql",
        split_statements=True,
    )

    # 3. Insert clients into staging table
    insert_clients_stage = SQLExecuteQueryOperator(
        task_id="insert_raw_clients_stage",
        conn_id=CONN_ID,
        sql="insert_stage_clients.sql",
        params={"filepath": "/opt/airflow/dags/data/clients.csv"},
    )

    # 4. Insert data from staging table into table
    insert_clients = SQLExecuteQueryOperator(
        task_id="insert_raw_clients",
        conn_id=CONN_ID,
        sql="insert_clients.sql",
    )

create_clients_table >> create_clients_stage >> insert_clients_stage >> insert_clients
