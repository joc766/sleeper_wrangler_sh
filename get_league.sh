#!/bin/bash

league_id="1120774194318479360"

league_file="leagues.csv"
user_file="users.csv"
teams_file="teams.csv"

while [ "$league_id" != "null" ]; do
    ## LEAGUE
    league_response=$(curl -s https://api.sleeper.app/v1/league/$league_id)
    echo "$league_response" | jq -r '[.league_id, .season, .previous_league_id, .name, .draft_id] | @csv' >> "$league_file"

    ## USER
    league_users_response=$(curl -s https://api.sleeper.app/v1/league/$league_id/users)
    echo "$league_users_response" | jq -r '.[].user_id' | while read -r user_id;
    do
        user_response=$(curl -s https://api.sleeper.app/v1/user/$user_id)
        echo "$user_response" | jq -r '[.user_id, .username, .display_name] | @csv'  >> "$user_file"
    done

    ## TEAM TODO WIP
    # for time being, ignore team name as username is more important for tracking stats anyway
    rosters_response=$(curl -s https://api.sleeper.app/v1/league/$league_id/rosters)
    echo "$rosters_response" | jq -r '.[]' | while read -r roster_data;
    do
        echo "$roster_data"
    done


    ## MATCHUP


    # repeat for each league recursively

    league_id=$(echo $league_response | jq -r '.previous_league_id')

    if [ "$league_id" == "null" ]; then
        break
    fi
done

sort -u "$user_file" -o "$user_file"