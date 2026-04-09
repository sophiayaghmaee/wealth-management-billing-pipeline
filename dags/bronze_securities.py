# python packages
from datetime import datetime, timedelta

from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sdk import DAG

# local imports
from utils.load import loadSecurities

CONN_ID = "postgres_default"

with DAG(
    dag_id="dag_bronze_load_securities",
    description="Loads daily stock prices from CSVs in folder: dags/data/securities",
    start_date=datetime(2025, 9, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "depends_on_past": False,
        "retries": 0,
        "retry_delay": timedelta(minutes=1),
    },
    template_searchpath=["/opt/airflow/dags/sql/L1_bronze"],
    tags=["bronze", "load", "securities"],
) as dag:

    # 1. Create securities table:
    create_securities_table = SQLExecuteQueryOperator(
        task_id="create_raw_securities_table",
        conn_id=CONN_ID,
        sql="create_securities_table.sql",
        split_statements=True,
    )

    # 2. Create securities staging table:
    create_securities_stage = SQLExecuteQueryOperator(
        task_id="create_raw_securities_stage",
        conn_id=CONN_ID,
        sql="create_securities_stage.sql",
        split_statements=True,
    )

    # 3. Get file names
    get_file_names = PythonOperator(
        task_id="get_file_names",
        python_callable=loadSecurities().list_files,
    )

    # 4. Insert securities into staging table
    # Dynamic task mapping to create multiple instances of a task at runtime
    insert_securities_stage = SQLExecuteQueryOperator.partial(
        task_id="insert_raw_securities_stage",
        conn_id=CONN_ID,
        sql="insert_stage_securities.sql",
        pool="pool_insert_securities",
    ).expand(params=get_file_names.output)

    # 5. Insert data from staging table into table
    insert_securities = SQLExecuteQueryOperator(
        task_id="insert_raw_securities",
        conn_id=CONN_ID,
        sql="insert_securities.sql",
    )

(
    create_securities_table
    >> create_securities_stage
    >> get_file_names
    >> insert_securities_stage
    >> insert_securities
)
