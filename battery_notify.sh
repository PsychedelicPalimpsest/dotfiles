#!/bin/bash

set -euo pipefail

LOCKFILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/battery-notify.lock"
exec 9>"$LOCKFILE"
flock -n 9 || exit 0

BATTERY_PATH=$(upower -e | grep -m1 '/battery_')
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/battery-notify.state"
THRESHOLDS=(25 10 5 2)

read_battery() {
  local info pct state
  info=$(upower -i "$BATTERY_PATH")
  pct=$(awk '/percentage/ { gsub(/%/, "", $2); print $2; exit }' <<<"$info")
  state=$(awk -F: '/^[[:space:]]+state:/ { gsub(/^[[:space:]]+/, "", $2); print $2; exit }' <<<"$info")
  printf '%s %s\n' "$pct" "$state"
}

was_notified() {
  grep -qx "$1" "$STATE_FILE" 2>/dev/null
}

mark_notified() {
  echo "$1" >>"$STATE_FILE"
}

clear_notified() {
  : >"$STATE_FILE"
}

notify_low() {
  local pct=$1
  local urgency=normal
  ((pct <= 5)) && urgency=critical
  dunstify -u "$urgency" "Battery Low" "${pct}% remaining"
}

check_battery() {
  local pct state
  read -r pct state < <(read_battery)

  case "$state" in
  charging | fully-charged | pending-charge)
    clear_notified
    return
    ;;
  discharging) ;;
  *)
    return
    ;;
  esac

  local t notified=false
  for t in "${THRESHOLDS[@]}"; do
    if ((pct <= t)) && ! was_notified "$t"; then
      if ! $notified; then
        notify_low "$pct"
        notified=true
      fi
      mark_notified "$t"
    fi
  done
}

check_battery

upower --monitor | while read -r line; do
  [[ "$line" == *"device changed"* ]] || continue
  check_battery
done
