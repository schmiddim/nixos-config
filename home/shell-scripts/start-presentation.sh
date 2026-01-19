#!/usr/bin/env bash
# Startet die Präsentation via make serve im ~/code/presentation Verzeichnis

PRESENTATION_DIR="$HOME/code/presentation"

if [[ ! -d "$PRESENTATION_DIR" ]]; then
  notify-send "Präsentation" "Verzeichnis $PRESENTATION_DIR nicht gefunden" --urgency=critical
  exit 1
fi

cd "$PRESENTATION_DIR" || exit 1
exec make serve
