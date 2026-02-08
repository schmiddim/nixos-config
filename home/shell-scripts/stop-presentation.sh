#!/usr/bin/env bash

# Cleanup Resources Stop port forwarding
kubectl delete teapots.kitchen.kitchen.example.com my-teapot
kubectl delete waters.kitchen.kitchen.example.com h20
kubectl delete tealeaves.kitchen.kitchen.example.com earl-grey
pkill -f k8s-port-forward.sh

# Stops all presentation processes
pkill -f "npm run serve" || true
pkill -f "npm run dev" || true
pkill -f "live-server" || true

notify-send -t 5000 "Presentation" "Server stopped"
