#!/usr/bin/env bash
set -euo pipefail

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

# Send notification with progress bar
notify_volume() {
  local action="${1:-}"
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
    notify_volume "up"
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    notify_volume "down"
    ;;
  toggle)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    notify_volume "toggle"
    ;;
  *)
    notify_volume
    ;;
esac
