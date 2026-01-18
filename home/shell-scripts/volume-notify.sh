#!/usr/bin/env bash
set -euo pipefail

# Debounce cache: store timestamp of last notification
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
debounce_file="${cache_dir}/.volume_notify_debounce"
debounce_interval=500  # milliseconds - only show notification every 500ms

mkdir -p "${cache_dir}"

# Get volume information from wpctl
get_volume_info() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@
}

# Extract volume percentage (0.0 to 1.0)
get_volume_percent() {
  get_volume_info | awk '{print int($2 * 100)}'
}

# Check if muted
is_muted() {
  get_volume_info | grep -q MUTED && echo "1" || echo "0"
}

# Check if we should show notification (debounce)
should_notify() {
  local now=$(date +%s%N | cut -b1-13)  # milliseconds since epoch
  local last_notify=0
  
  if [[ -f "$debounce_file" ]]; then
    last_notify=$(cat "$debounce_file" 2>/dev/null || echo 0)
  fi
  
  local elapsed=$((now - last_notify))
  
  if [[ $elapsed -ge $debounce_interval ]]; then
    echo "$now" > "$debounce_file"
    return 0  # OK to notify
  fi
  
  return 1  # Skip notification
}

# Send notification with progress bar
notify_volume() {
  local volume=$(get_volume_percent)
  local muted=$(is_muted)
  
  if [[ "$muted" == "1" ]]; then
    notify-send -u normal -t 1500 "🔇 Volume" "Muted"
  else
    notify-send -u normal \
      -h int:value:"${volume}" \
      -t 1500 \
      "🔊 Volume" \
      "${volume}%"
  fi
}

# Main logic
case "${1:-}" in
  up)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    should_notify && notify_volume
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    should_notify && notify_volume
    ;;
  toggle)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    notify_volume  # Always show mute/unmute immediately
    ;;
  *)
    should_notify && notify_volume
    ;;
esac
