# Wealth Management Quarterly Billing Pipeline

An end-to-end data engineering pipeline that calculates quarterly management fee billing for wealth management clients. Built with Apache Airflow, PostgreSQL, and Docker, following a medallion architecture (bronze → silver → gold).

## Overview

Financial advisors charge clients an annual management fee (typically 0.75%–1.00%) on their assets under management. Each quarter, billing is calculated as:

```
Quarterly Fee = Average Daily Balance (Q) × (Annual Fee Rate / 4)
```

This pipeline ingests account, client, and daily security price data, transforms it through three layers, and outputs a per-account quarterly billing report.

**Example:**
- Client with $150,000 Q2 average balance at 0.75% → **$281.25 billed**
- Client with $700,000 Q2 average balance at 0.85% → **$1,487.50 billed**

## Architecture

```
Accounts API (JSON)  ──┐
Clients CSV          ──┼──► Bronze (raw) ──► Silver (normalized) ──► Gold (star schema) ──► quarterly_billing_output.csv
Securities CSVs      ──┘
```

### Layers

| Layer | Description |
|---|---|
| **Bronze** | Raw ingestion — data loaded as-is with staging tables |
| **Silver** | Normalized — FK constraints, deduplication, typed columns |
| **Gold** | Star schema — denormalized dimensions + fact table, views for reporting |

## DAGs

| DAG | Schedule | Description |
|---|---|---|
| `create_schemas` | One-time | Creates bronze, silver, gold schemas |
| `dag_bronze_load_accounts` | Daily | Ingests account data from REST API |
| `dag_bronze_load_clients` | Daily | Ingests client data from CSV |
| `dag_bronze_load_securities` | Daily | Ingests daily stock prices from CSVs (dynamic task mapping) |
| `dag_silver_create_tables` | One-time | Creates normalized silver tables |
| `dag_silver_upsert_tables` | Daily | Transforms and upserts bronze → silver |
| `dag_gold_create_tables` | One-time | Creates star schema dimension and fact tables |
| `dag_gold_upsert_tables` | Daily | Populates gold layer, calculates daily balances |

## Data Sources

- **Accounts** — REST API endpoint returning JSON (100 clients, ~500 accounts across account types: brokerage, IRA, 401k, trusts, etc.)
- **Clients** — `dags/data/clients.csv`
- **Security Prices** — Daily OHLC CSVs for 8 tickers: `AAPL`, `GME`, `MSFT`, `NVDA`, `OILK`, `SPY`, `VOO`, `VTI`

## Tech Stack

- **Orchestration:** Apache Airflow 3.0
- **Database:** PostgreSQL
- **Containerization:** Docker Compose
- **Languages:** Python, SQL
- **Key Airflow features used:** Dynamic task mapping, task groups, SQLExecuteQueryOperator, template searchpath

## Getting Started

### Prerequisites
- Docker Desktop

### Setup

1. Clone the repo and navigate to the project directory.

2. Create your `.env` file:
   ```bash
   cp .env.example .env
   ```

3. Initialize Airflow:
   ```bash
   docker compose up airflow-init
   ```

4. Start all services:
   ```bash
   docker-compose up
   ```

5. Register the Postgres connection — either option works:

   **Option A** — import from the included `CONNECTIONS.json`:
   ```bash
   ./airflow.sh connections import CONNECTIONS.json
   ```

   **Option B** — add manually:
   ```bash
   ./airflow.sh connections add postgres_default --conn-uri "postgresql://airflow:airflow@postgres/airflow" --conn-extra '{"sslmode": "prefer"}' || true
   ```

6. Access the Airflow UI at [http://localhost:8080](http://localhost:8080) (username: `airflow`, password: `airflow`)
7. Access pgAdmin at [http://localhost:8081](http://localhost:8081)

### Running the Pipeline

Run DAGs in this order:
1. `create_schemas`
2. `dag_silver_create_tables`
3. `dag_gold_create_tables`
4. Then trigger the bronze/silver/gold daily DAGs

## Output

`quarterly_billing_output.csv` — Q2 2025 billing report (970 rows):

```
year_quarter, client_id, client_name, account_id, account_type, annual_management_fee, quarter_avg_daily_balance, billing_fees_collected
```
