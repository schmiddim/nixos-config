#!/usr/bin/env bash
# Starts presentation in background (browser opens automatically)

PRESENTATION_DIR="$HOME/code/presentation"

if [[ ! -d "$PRESENTATION_DIR" ]]; then
  notify-send -t 5000 "Presentation" "Directory $PRESENTATION_DIR not found" --urgency=critical
  exit 1
fi

cd "$PRESENTATION_DIR" || exit 1

# Start in background, redirect all output to /dev/null
nohup npm run serve > /dev/null 2>&1 &

notify-send -t 5000 "Presentation" "Server starting... Browser will open shortly"
