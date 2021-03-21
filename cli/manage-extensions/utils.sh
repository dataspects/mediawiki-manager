#!/bin/bash

CATALOGUE_URL=https://raw.githubusercontent.com/dataspects/mediawiki-manager/main/catalogues/extensions.json

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/

backupLocalSettingsPHP () {
    cp mediawiki_root/w/LocalSettings.php mediawiki_root/w/LocalSettings.php.bak
}

getExtensionJSON () {
    catalogueJSON=$(curl -S \
        $OPTION_INSECURE \
        --silent \
        --retry 2 \
        --retry-delay 5\
        --user-agent "Curl Shell Script" \
        --keepalive-time 60 \
        --header "Accept-Language: en-us" \
        --header "Connection: keep-alive" \
        --compressed \
        --request "GET" "${CATALOGUE_URL}")
}

getExtensionNames () {
    getExtensionJSON
    extensionNamesString=`echo $catalogueJSON | jq '.[]' | jq -r '.name'`
}

getExtensionData () {
    getExtensionNames
    extNamesArray=($(echo $extensionNamesString | tr " " "\n"))
    i=0
    for name in "${extNamesArray[@]}"
    do
        if [[ "$name" == "$1" ]]
        then
            extensionData=`echo $catalogueJSON | jq .[$i]`
        fi
        i=$((i+1))
    done
}

getExtensionDataByKey () {
    DATA=`echo $2 | jq -r '."'$1'"'`
    DATAKEYS=`echo $aspect | jq 'keys'`
    if [ "$DATA" == "null" ]
    then
        echo null
    else
        echo "$DATA"
    fi
}