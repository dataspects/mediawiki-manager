#!/bin/bash

source ./_secrets.sh

index () {
    fullFilePath=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
    echo "Indexing $fullFilePath..."
    ./dsrepository-cli \
        --key $MWM_KEY \
        --id $MWM_ID \
        --dir /home/lex/mediawiki-manager/ \
        --single-file $fullFilePath \
        --url $DATASPECTS_API_URL
}

EXCLUDE=(
    '\.git'
    '\.gitignore'
    'mediawiki_root'
    'logs'
    'mysql_data'
    'restic-backup-repository'
    'wikicj'
    'docker-compose.yml.bak'
    '_secrets.sh'
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
            lastFile=$FILE
            index $FILE
        else
            lastFile=""
        fi
    done

