#!/usr/bin/env bash
# Startet die Präsentation im Hintergrund (Browser öffnet sich automatisch)

PRESENTATION_DIR="$HOME/code/presentation"

if [[ ! -d "$PRESENTATION_DIR" ]]; then
  notify-send "Präsentation" "Verzeichnis $PRESENTATION_DIR nicht gefunden" --urgency=critical
  exit 1
fi

cd "$PRESENTATION_DIR" || exit 1

# Starte im Hintergrund, redirect all output to /dev/null
nohup npm run serve > /dev/null 2>&1 &

notify-send "Präsentation" "Server startet... Browser öffnet sich gleich"
