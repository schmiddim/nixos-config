#!/usr/bin/env sh
WS="9:web"

if swaymsg -t get_workspaces | jq -e '.[] | select(.name=="'"$WS"'")' >/dev/null 2>&1; then
  swaymsg workspace "$WS"
  exit 0
fi

swaymsg workspace "$WS"
swaymsg split horizontal
swaymsg exec 'google-chrome-stable --new-window https://www.notion.so/'
sleep 0.2
swaymsg focus right
swaymsg exec 'google-chrome-stable --new-window https://chat.openai.com/'