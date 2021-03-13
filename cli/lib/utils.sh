#!/bin/bash

OPTION_INSECURE=--insecure
cookie_jar="wikicj"
folder="/tmp"

getPageData () {
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $1)
    WIKITEXT=`cat "$1"`
}

initializeSystemLog () {
    touch ./logs/system.log
}

writeToSystemLog () {
    # TODO: fix timestamp
    echo $(date "+%Y-%m-%d") $1>> ./logs/system.log
}