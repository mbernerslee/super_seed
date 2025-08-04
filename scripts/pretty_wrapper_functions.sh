RESET="\033[0m"
GREEN="\033[38;2;166;218;149m"
TEAL="\033[38;2;139;213;202m"
RED="\033[38;2;237;135;150m"

INFO_COLOUR=$TEAL
SUCCESS_COLOUR=$GREEN
FAILURE_COLOUR=$RED

echo_success() {
  echo -e "${SUCCESS_COLOUR}$@${RESET}"
}

echo_info() {
  echo -e "${INFO_COLOUR}$@${RESET}"
}

echo_failure() {
  echo -e "${FAILURE_COLOUR}$@${RESET}"
}

echo_success_lines() {
  echo_success "$(printf '%.0s─' {1..60})"
  echo_success "$@"
  echo_success "$(printf '%.0s─' {1..60})"
}

calculate_duration() {
  local start_time="$1"
  local end_time="$2"

  duration=$(echo "$end_time - $start_time" | bc)

  # Pretty format the duration
  if (( $(echo "$duration >= 60" | bc -l) )); then
    # More than 1 minute
    minutes=$(echo "$duration / 60" | bc)
    seconds=$(echo "$duration % 60" | bc)
    duration_str="${minutes}m${seconds}s"
  elif (( $(echo "$duration >= 1" | bc -l) )); then
    # More than 1 second
    duration_str=$(printf "%.1fs" "$duration")
  else
    # Less than 1 second
    milliseconds=$(echo "$duration * 1000" | bc)
    duration_str=$(printf "%.0fms" "$milliseconds")
  fi

  echo "$duration_str"
}

checkmark() {
  echo "✓"
}

cross() {
  echo "✗"
}

run_and_log() {
  echo_info "$(printf '%.0s─' {1..60})"
  echo_info "$@"
  echo_info "$(printf '%.0s─' {1..60})"

  start_time=$(date +%s.%N)
  eval "$@"
  exit_code=$?
  end_time=$(date +%s.%N)

  duration_str=$(calculate_duration "$start_time" "$end_time")

  if [[ $exit_code -eq 0 ]]; then
    echo_success "✓ completed in ${duration_str}"
  else
    echo_failure "✗ failed with exit code $exit_code after ${duration_str}"
    exit $exit_code
  fi

  return $exit_code
}
