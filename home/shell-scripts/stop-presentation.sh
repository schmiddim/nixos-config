#!/usr/bin/env bash
# Stoppt alle Präsentations-Prozesse

pkill -f "npm run serve" || true
pkill -f "npm run dev" || true
pkill -f "live-server" || true

notify-send "Präsentation" "Server gestoppt"
