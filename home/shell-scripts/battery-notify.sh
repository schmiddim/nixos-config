#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-"$HOME/.cache"}"
state_file="${cache_dir}/battery-notify.state"

mkdir -p "${cache_dir}"

get_battery_device() {
  upower -e | rg -m1 battery || true
}

get_battery_info() {
  local device="${1}"
  upower -i "${device}"
}

while true; do
  device="$(get_battery_device)"
  if [[ -z "${device}" ]]; then
    sleep 60
    continue
  fi

  info="$(get_battery_info "${device}")"
  state="$(printf '%s\n' "${info}" | rg "^\\s*state:" | awk '{print $2}')"
  percentage_raw="$(printf '%s\n' "${info}" | rg "^\\s*percentage:" | awk '{print $2}')"
  percentage="${percentage_raw%%%}"

  if [[ "${state}" != "discharging" ]]; then
    rm -f "${state_file}"
    sleep 60
    continue
  fi

  last_state=""
  if [[ -f "${state_file}" ]]; then
    last_state="$(cat "${state_file}")"
  fi

  if [[ "${percentage}" -le 10 && "${last_state}" != "low" ]]; then
    notify-send -u critical "Battery low (${percentage}%)" "Please plug in the charger."
    echo "low" > "${state_file}"
  elif [[ "${percentage}" -gt 10 && -n "${last_state}" ]]; then
    rm -f "${state_file}"
  fi

  sleep 60
done
