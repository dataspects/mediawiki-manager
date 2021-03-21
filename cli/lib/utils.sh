#!/bin/bash

# Public MWMBashFunction
promptToContinue () {
    printf "\033[0m\n"
    read -p "Continue? (y/n)" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    printf "\n"
}

#######################
# CHECK IF IN CONTAINER
if [[ $runInContainerOnly == "true" ]] && [ "`ls /home`" != "" ]
then
    printf "INFO: \x1b[31mredirecting run command to \033[1mpodman exec mwm-mediawiki `dirname $0`/`basename $0` "$1""
    promptToContinue
    podman exec mwm-mediawiki /bin/bash -c "`dirname $0`/`basename $0` $1"
    exit
fi
#######################

# CURL utils
OPTION_INSECURE=--insecure
cookie_jar="wikicj"
folder="/tmp"

getPageData () {
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $1)
    WIKITEXT=`cat "$1"`
}

# Public MWMBashFunction
initializeSystemLog () {
    mkdir --parents logs
    rm ./logs/system.log
    touch ./logs/system.log
}

# Public MWMBashFunction
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




# Private MWMBashFunction
backupLocalSettingsPHP () {
    cp mediawiki_root/w/LocalSettings.php mediawiki_root/w/LocalSettings.php.bak
}