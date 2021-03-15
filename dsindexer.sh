#!/bin/bash

EXCLUDE=(
    '\.git'
    '\.gitignore'
    'mediawiki_root'
    'logs'
    'mysql_data'
    'restic-backup-repository'
    'wikicj'
    'docker-compose.yml.bak'
)

EXL=$(IFS='|' ; echo "${EXCLUDE[*]}")
echo "Excluding $EXL..."

inotifywait \
    --monitor \
    --event modify \
    --event move \
    --event create \
    --format '%w%f' \
    --exclude $EXL \
    --recursive \
    . \
    | while read FILE
    do
        # FIXME: handle double reporting
        if [ "$lastFile" != "$FILE" ]
        then
            echo "Indexing $FILE..."
            lastFile=$FILE
        else
            lastFile=""
        fi
    done