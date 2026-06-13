FROM python:3.11-slim

RUN pip install dbt-snowflake==1.11.5

WORKDIR /usr/app

COPY . .

ENV DBT_PROFILES_DIR=/usr/app

CMD ["dbt", "run"]
