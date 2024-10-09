#!/bin/bash

league_id="1120774194318479360"

output_file="leagues.csv"

while [ "$league_id" != "null" ]; do
    response=$(curl -s https://api.sleeper.app/v1/league/$league_id)
    echo "$response" | jq -r '[.league_id, .season, .previous_league_id, .name, .draft_id] | @csv' >> "$output_file"
    league_id=$(echo $response | jq -r '.previous_league_id')

    if [ "$league_id" == "null" ]; then
        break
    fi
done