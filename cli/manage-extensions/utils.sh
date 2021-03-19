#!/bin/bash

CATALOGUE_URL=https://raw.githubusercontent.com/dataspects/mediawiki-manager/main/catalogues/extensions.json

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/

getExtensionName () {
    # Check if the EXTENSION_NAME is of format abc/xyz
    if [[ $EXTENSION_NAME =~ \/ ]]; then
    # If yes, then it refers to packagist
    podman exec $APACHE_CONTAINER_NAME bash -c \
        "cd w && php composer.phar remove --no-update $EXTENSION_NAME"
    EXTNAME=$(sed -r 's/[a-z]+\/(.*)/\1/g' <<<$EXTENSION_NAME)
    EXTNAME_CC=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<$EXTNAME)
    else
    # If no, then it seems to be manually managed
    EXTNAME_CC=$EXTENSION_NAME
    fi
}

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
    DATA=`echo $aspect | jq '."'$1'"'`
    DATAKEYS=`echo $aspect | jq 'keys'`
    if [ "$DATA" == "null" ]
    then
        echo "'$1' not found for '$EXTNAME' in $DATAKEYS"
    else
        echo "$DATA"
    fi
}