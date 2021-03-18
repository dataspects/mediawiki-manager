#!/bin/bash

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

getExtensionNames () {
    catalogue=`cat catalogues/extensions.json`
    extensionNamesString=`echo $catalogue | jq '.[]' | jq -r '.name'`
}

getExtensionData () {
    getExtensionNames
    extNamesArray=($(echo $extensionNamesString | tr " " "\n"))
    i=0
    for name in "${extNamesArray[@]}"
    do
        if [[ "$name" == "$1" ]]
        then
            extensionData=`echo $catalogue | jq .[$i]`
        fi
        i=$((i+1))
    done
}