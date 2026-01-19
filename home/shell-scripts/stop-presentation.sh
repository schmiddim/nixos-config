#!/usr/bin/env bash
# Stops all presentation processes

pkill -f "npm run serve" || true
pkill -f "npm run dev" || true
pkill -f "live-server" || true

notify-send -t 5000 "Presentation" "Server stopped"
