#!/usr/bin/env bash

while gh run list --status failure --limit 100 --json databaseId --jq '.[].databaseId' | grep -q .; do
  gh run list --status failure --limit 100 --json databaseId --jq '.[].databaseId' \
    | xargs -I {} gh run delete {}
done