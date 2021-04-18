#!/bin/bash

# Public MWMBashFunction
promptToContinue () {
    printf "\n\n\e[2mDim"
    read -p "Continue? (y/n)" -n 1 -r
    printf "\e[0m"
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        printf "\n"
        exit 1
    fi
    printf "\n"
}

# CURL utils
OPTION_INSECURE=--insecure
cookie_jar="wikicj"
folder="/tmp"

getPageData () {
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $1)
    WIKITEXT=`cat "$1"`
}

# Public MWMBashFunction
runMWUpdatePHP () {
    if [ "`ls /home`" != "" ]
    then
        podman exec $APACHE_CONTAINER_NAME /bin/bash -c "cd w; php maintenance/update.php --quick"
    else
        cd w; php maintenance/update.php --quick
    fi
}

# Public MWMBashFunction
runSMWRebuildData () {
    if [ "`ls /home`" != "" ]
    then
        podman exec $APACHE_CONTAINER_NAME /bin/bash -c "cd w; php extensions/SemanticMediaWiki/maintenance/rebuildData.php"
    else
        cd w; php extensions/SemanticMediaWiki/maintenance/rebuildData.php
    fi
}