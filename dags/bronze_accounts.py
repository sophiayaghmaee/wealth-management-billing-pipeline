# python packages
from datetime import datetime, timedelta

from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG

# local imports
from utils.load import loadAccounts

CONN_ID = "postgres_default"

with DAG(
    dag_id="dag_bronze_load_accounts",
    description="Loads accounts from API endpoint",
    start_date=datetime(2025, 9, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L1_bronze"],
    tags=["bronze", "load", "accounts"],
) as dag:

    # 1. Create accounts table:
    create_accounts_table = SQLExecuteQueryOperator(
        task_id="create_raw_accounts_table",
        conn_id=CONN_ID,
        sql="create_accounts_table.sql",
        split_statements=True,
    )

    # 2. Create accounts staging table:
    create_accounts_stage = SQLExecuteQueryOperator(
        task_id="create_raw_accounts_stage",
        conn_id=CONN_ID,
        sql="create_accounts_stage.sql",
        split_statements=True,
    )

    # 3. Get account data
    get_account_data = PythonOperator(
        task_id="get_account_data",
        python_callable=loadAccounts().get_account_data,
    )

    # 4. Insert accounts into staging table
    insert_accounts_stage = SQLExecuteQueryOperator(
        task_id="insert_raw_accounts_stage",
        conn_id=CONN_ID,
        sql="insert_stage_accounts.sql",
    )

    # 5. Insert data from staging table into table
    insert_accounts = SQLExecuteQueryOperator(
        task_id="insert_raw_accounts",
        conn_id=CONN_ID,
        sql="insert_accounts.sql",
    )

(
    create_accounts_table
    >> create_accounts_stage
    >> get_account_data
    >> insert_accounts_stage
    >> insert_accounts
)
