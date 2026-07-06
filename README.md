# FIFA 2026 World Cup — Dockerized dbt Pipeline with CI/CD

## What This Project Does
End-to-end analytics engineering pipeline for FIFA 2026 World Cup host city and match data — from raw CSV seeds through a tested dbt transformation layer, containerized and automatically run on every push.

## Business Questions Answered
- Which stadiums have the largest capacity, and where are they?
- How is the tournament distributed across regions (West/Central/East)?
- What's the travel footprint for teams and fans across host cities?
- How do stadium details change over time? (capacity change tracking via snapshots)

## Pipeline Architecture
```
seeds (fifa_2026_host_cities.csv, fifa_2026_matches.csv)
        │  dbt seed → Snowflake RAW schema
        ▼
stg_host_cities.sql / stg_matches.sql      (staging views — typed, trimmed)
        │
        ▼
mart_match_results.sql        (incremental, unique_key=match_id)
mart_matches_by_region.sql    (region classification via get_region() macro)
mart_stadium_capacity.sql     (ranked by capacity)
mart_travel_footprint.sql     (surrogate key via dbt_utils, matches-per-city)
        │
        ▼
stadium_snapshot (SCD Type 2 — tracks stadium_capacity changes over time)
        │
        ▼
Docker container ──▶ GitHub Actions CI: dbt deps → dbt run → dbt test on every push
```

## Tech Stack
- **dbt Core** (`dbt-snowflake` 1.11.5) — staging, incremental models, snapshots, macros, tests, docs, exposures
- **Snowflake** — cloud data warehouse (RAW → ANALYTICS → SNAPSHOTS schemas)
- **dbt_utils** package — surrogate key generation
- **Docker** — `python:3.11-slim` base, containerized pipeline runner
- **GitHub Actions** — CI/CD, runs `dbt run` + `dbt test` on every push to `main`, credentials injected via repo secrets (no hardcoded credentials anywhere in the project)

## Data Quality
dbt tests across the analytics marts (`models/analytics/schema.yml`):
- `not_null` + `unique` on `match_id` (mart_match_results, mart_travel_footprint)
- `not_null` + `unique` on `stadium_name` (mart_stadium_capacity)
- `not_null` + `unique` + `accepted_values` on `region` (mart_matches_by_region — West/Central/East)

## Project Structure
```
fifa26-dbt/
├── seeds/                              # raw CSVs loaded into Snowflake RAW schema
├── models/
│   ├── staging/                        # stg_host_cities, stg_matches
│   └── analytics/                      # 4 marts: match_results, matches_by_region,
│                                        #   stadium_capacity, travel_footprint
├── snapshots/                          # SCD Type 2 — stadium_capacity change tracking
├── macros/                             # get_region() — longitude-based region classifier
├── models/exposures.yml                # tournament dashboard exposure
├── Dockerfile                          # containerized pipeline
└── .github/workflows/dbt_run.yml       # CI: dbt deps + run + test on every push
```

## How to Run

**Locally:**
```bash
dbt deps
dbt seed
dbt run
dbt test
dbt docs generate && dbt docs serve
```

**Containerized:**
```bash
docker build -t fifa26-dbt .
docker run --env-file .env fifa26-dbt
```

Requires Snowflake credentials as environment variables (see `profiles.yml`): `DBT_SNOWFLAKE_ACCOUNT`, `DBT_SNOWFLAKE_USER`, `DBT_SNOWFLAKE_PASSWORD`, `DBT_SNOWFLAKE_DATABASE`, `DBT_SNOWFLAKE_WAREHOUSE`, `DBT_SNOWFLAKE_ROLE`, `DBT_SNOWFLAKE_SCHEMA`.

## CI/CD
Every push to `main` triggers `.github/workflows/dbt_run.yml`, which installs `dbt-snowflake`, then runs `dbt deps`, `dbt run`, and `dbt test` against Snowflake using credentials stored as GitHub Actions secrets.

## Data Source
FIFA 2026 World Cup host cities and match schedule (public tournament data).
