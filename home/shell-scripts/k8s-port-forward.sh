#!/bin/bash

SERVICE_NAME="${1:-my-teapot-svc}"
LOCAL_PORT="${2:-8082}"

cleanup() {
    echo ""
    echo "Stopping port-forward..."
    kill $PF_PID 2>/dev/null
    wait $PF_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM


(
    while true; do 
        kubectl port-forward "svc/${SERVICE_NAME}" "${LOCAL_PORT}:80" 2>/dev/null
        sleep 1
    done
) &

PF_PID=$!

echo "Port-forward running: localhost:${LOCAL_PORT} -> svc/${SERVICE_NAME}:80"
echo "Press Ctrl+C to stop"
echo ""

wait $PF_PID
