#!/bin/bash

# How to handle this component?

source ./_secrets.sh

PWD=`pwd`

index () {
    fullFilePath=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
    echo "Indexing $fullFilePath..."
    ./dsrepository-cli \
        --key $MWM_KEY \
        --id $MWM_ID \
        --dir $PWD \
        --single-file $fullFilePath \
        --url $DATASPECTS_API_URL
}

EXCLUDE=(
    '\.git'
    '\.gitignore'
    'mediawiki_root'
    'logs'
    'mysql_data'
    'snapshots'
    'wikicj'
    'docker-compose.yml.bak'
    '_secrets.sh'
    'repository-cli'
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
        # Some applications report a single event more than once.
        if [ "$lastFile" != "$FILE" ]
        then
            lastFile=$FILE
            index $FILE
        else
            lastFile=""
        fi
    done

