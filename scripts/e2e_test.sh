#!/usr/bin/env bash
set -e

TOTAL_START_TIME=$(date +%s.%N)

my_dir="$(dirname "$0")"
source "$my_dir/pretty_wrapper_functions.sh"

# Start the application and run a command
export MIX_ENV=e2e_test
export PGDATABASE=super_seed_e2e_test

run_and_log "mix deps.get"
run_and_log "mix compile"
run_and_log "mix ecto.clean"

run_and_log "mix run -e \":ok = SuperSeed.run(:farms)\""

set +e

assert() {
  query=$1
  grep_for=$2

  psql -t -c "$query" | grep -q "$grep_for"

  if [[ $? -eq 0 ]]; then
    echo "$query successfully returned $grep_for"
  else
    echo "$query did not return the expected $grep_for"
    exit 1
  fi
}

run_and_log "assert \"SELECT name FROM farms;\" \"Sunrise Valley\""
run_and_log "assert \"SELECT COUNT(*) FROM animals;\" \"4\""

TOTAL_END_TIME=$(date +%s.%N)
TOTAL_DURATION=$(calculate_duration "$TOTAL_START_TIME" "$TOTAL_END_TIME")
echo_success_lines "$(checkmark) E2E tests passed in ${TOTAL_DURATION}"
