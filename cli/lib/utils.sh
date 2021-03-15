#!/bin/bash

OPTION_INSECURE=--insecure
cookie_jar="wikicj"
folder="/tmp"

getPageData () {
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $1)
    WIKITEXT=`cat "$1"`
}

initializeSystemLog () {
    mkdir --parents logs
    rm ./logs/system.log
    touch ./logs/system.log
}

writeToSystemLog () {
    # TODO: fix timestamp
    echo $(date "+%Y-%m-%d") $1>> ./logs/system.log
}

# Public MWMBashFunction
addToLocalSettings () {
    backupLocalSettingsPHP
    # Ensure new line at end of file
    sed -e '$a\' mediawiki_root/w/LocalSettings.php.bak > mediawiki_root/w/LocalSettings.php
    backupLocalSettingsPHP
    # Add line to end of file
    echo $1>> mediawiki_root/w/LocalSettings.php
    writeToSystemLog "Added to LocalSettings.php: $1"
}

# Public MWMBashFunction
removeFromLocalSettings () {
    backupLocalSettingsPHP
    sed "$1" mediawiki_root/w/LocalSettings.php.bak > mediawiki_root/w/LocalSettings.php
    writeToSystemLog "Removed from LocalSettings.php: $1"
}

# Public MWMBashFunction
runMWUpdatePHP () {
    sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
        'cd w; php maintenance/update.php --quick'
}

# Private MWMBashFunction
backupLocalSettingsPHP () {
    cp mediawiki_root/w/LocalSettings.php mediawiki_root/w/LocalSettings.php.bak
}

# Private MWMBashFunction
promptToContinue () {
    read -p "Continue? (y/n)" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}