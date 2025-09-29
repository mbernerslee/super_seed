#!/usr/bin/env bash

my_dir="$(dirname "$0")"
source "$my_dir/../../scripts/pretty_wrapper_functions.sh"

export MIX_ENV=${MIX_ENV:-dev}

# infer the db name from MIX_ENV but only if PGDATABASE is not set
case "$MIX_ENV" in
  dev)
    export PGDATABASE=client_test_app_dev
    ;;
  test)
    export PGDATABASE=client_test_app_test
    ;;
  prod)
    echo "I refuse to run in prod"
    exit 1
    ;;
  *)
    echo "Unknown environment: $MIX_ENV"
    exit 1
    ;;
esac

echo_info "using PGDATABASE=$PGDATABASE, inferred from MIX_ENV=$MIX_ENV"

TRUNCATE_CMD=$(psql -t -c "
  SELECT 'TRUNCATE TABLE ' || string_agg(tablename, ', ') || ';'
  FROM pg_tables WHERE schemaname = 'public';
")

run_and_log "psql -c \"$TRUNCATE_CMD\""
