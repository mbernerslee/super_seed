#!/usr/bin/env bash

my_dir="$(dirname "$0")"
source "$my_dir/pretty_wrapper_functions.sh"

# Check if PGDATABASE environment variable is set
if [ -z "$PGDATABASE" ]; then
  echo_error "PGDATABASE environment variable is not set"
  exit 1
else
 echo_info "using PGDATABASE=$PGDATABASE"
fi

TRUNCATE_CMD=$(psql -t -c "
  SELECT 'TRUNCATE TABLE ' || string_agg(tablename, ', ') || ';'
  FROM pg_tables WHERE schemaname = 'public';
")

run_and_log "psql -c \"$TRUNCATE_CMD\""
