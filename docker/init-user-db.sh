#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA capital AUTHORIZATION postgres;
    CREATE ROLE app_capital_design_ingestion;
    CREATE ROLE app_capital_design_api;
    CREATE ROLE team_all;
EOSQL
