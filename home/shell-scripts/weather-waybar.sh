#!/usr/bin/env bash
set -euo pipefail

# wttr.in auto-detects location via client IP; cache to avoid rate limits.
cache_dir="${XDG_CACHE_HOME:-"$HOME/.cache"}/waybar"
cache_file="${cache_dir}/weather.json"
cache_ttl=600

mkdir -p "${cache_dir}"

validate_json() {
  jq -e '.' >/dev/null 2>&1
}

fetch_weather() {
  local now mtime response

  if [[ -f "${cache_file}" ]]; then
    now="$(date +%s)"
    mtime="$(date -r "${cache_file}" +%s)"
    if (( now - mtime < cache_ttl )) && validate_json <"${cache_file}"; then
      cat "${cache_file}"
      return 0
    fi
  fi

  # wttr.in returns JSON when asked for ?format=j1
  if response="$(curl -fsS --max-time 4 "https://wttr.in?format=j1" 2>/dev/null)"; then
    if validate_json <<<"${response}"; then
      printf '%s\n' "${response}" > "${cache_file}"
      printf '%s\n' "${response}"
      return 0
    fi
  fi

  [[ -f "${cache_file}" ]] && cat "${cache_file}"
}

condition_icon() {
  local condition="${1,,}"
  case "${condition}" in
    *thunder*|*storm*) echo "" ;;
    *snow*|*sleet*|*blizzard*) echo "󰖘" ;;
    *rain*|*shower*|*drizzle*) echo "󰖗" ;;
    *mist*|*fog*|*haze*) echo "󰖑" ;;
    *cloud*|*overcast*) echo "" ;;
    *sunny*|*clear*) echo "" ;;
    *) echo "󰖐" ;;
  esac
}

weather_json="$(fetch_weather || true)"

if [[ -z "${weather_json}" ]] || ! validate_json <<<"${weather_json}"; then
  jq -c -n --arg text "--" --arg tooltip "Weather unavailable" '{"text":$text,"tooltip":$tooltip,"class":"offline","icon":"󰖐"}'
  exit 0
fi

temp="$(printf '%s' "${weather_json}" | jq -r '.current_condition[0].temp_C // empty' 2>/dev/null)"
feels_like="$(printf '%s' "${weather_json}" | jq -r '.current_condition[0].FeelsLikeC // empty' 2>/dev/null)"
condition="$(printf '%s' "${weather_json}" | jq -r '.current_condition[0].weatherDesc[0].value // empty' 2>/dev/null)"
humidity="$(printf '%s' "${weather_json}" | jq -r '.current_condition[0].humidity // empty' 2>/dev/null)"
location="$(printf '%s' "${weather_json}" | jq -r '.nearest_area[0].areaName[0].value // empty' 2>/dev/null)"

if [[ -z "${temp}" || -z "${condition}" ]]; then
  jq -c -n --arg text "--" --arg tooltip "Weather unavailable" '{"text":$text,"tooltip":$tooltip,"class":"offline","icon":"󰖐"}'
  exit 0
fi

icon="$(condition_icon "${condition}")"
class="$(sed 's/ /-/g' <<<"${condition,,}")"

tooltip_lines=()
[[ -n "${location}" ]] && tooltip_lines+=("${location}")
tooltip_lines+=("${condition}")
[[ -n "${feels_like}" ]] && tooltip_lines+=("Feels like ${feels_like}°C")
[[ -n "${humidity}" ]] && tooltip_lines+=("Humidity ${humidity}%")

tooltip="$(printf '%s\n' "${tooltip_lines[@]}")"

jq -c -n \
  --arg text "${temp}°C" \
  --arg tooltip "${tooltip}" \
  --arg class "${class}" \
  --arg icon "${icon}" \
  '{"text":$text,"tooltip":$tooltip,"class":$class,"icon":$icon}'
