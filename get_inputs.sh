#!/bin/bash

DAY_UNAVAILABLE_MESSAGE="Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available."

function session_cookie() {
    echo "session=${AOC_SESSION:-}"
}

function path_to_input() {
    day=$1
    root_dir="$(git rev-parse --show-toplevel)"
    echo "$root_dir/Sources/$YEAR/Inputs/day$(printf "%02d" "$day").txt"
}

YEAR="${1:-}"
if [ -z "${YEAR:-}" ]; then
    echo "please provide a year to fetch for"
    exit 1
fi

DAYS=( "${@:2}" )
if [ ${#DAYS[@]} -eq 0 ]; then
    DAYS=( {1..25} )
fi

downloaded=0
for day in "${DAYS[@]}"; do
    path="$(path_to_input "$day")"
    if [ -f "$path" ]; then
        continue
    fi

    curl \
        --cookie "$(session_cookie)" \
        -o "$path" \
        "https://adventofcode.com/$YEAR/day/$day/input" || {
        echo "error while fetching"
        exit 1
    }
    if [[ $(< "$path") == "$DAY_UNAVAILABLE_MESSAGE" ]]; then
        echo "day $day is unavailable at this time. aborting..."
        rm "$path"
        exit 0
    fi
    truncate -s -1 "$path"
    downloaded=$((downloaded + 1))
done

echo "downloaded $downloaded files!"
