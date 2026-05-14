#!/usr/bin/env bash

branch=$(git branch --show-current 2>/dev/null)
if [[ -z "$branch" ]]; then
  echo "Kein git repo"
  exit 1
fi

run=$(gh run list --branch "$branch" --limit 1 --json databaseId,status,conclusion,displayTitle,workflowName --jq '.[0]')
id=$(echo "$run" | jq -r '.databaseId')
status=$(echo "$run" | jq -r 'if .conclusion == "" then .status else .conclusion end')
title=$(echo "$run" | jq -r '.displayTitle')
workflow=$(echo "$run" | jq -r '.workflowName')

echo "[$workflow] $title"

if [[ "$status" == "in_progress" || "$status" == "queued" ]]; then
  echo "läuft noch – watching..."
  gh run watch "$id"
  status=$(gh run view "$id" --json conclusion --jq '.conclusion')
fi

echo "→ $status"

if [[ "$status" == "failure" ]]; then
  gh run view "$id" --log-failed
fi