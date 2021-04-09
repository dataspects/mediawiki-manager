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

# Public MWMBashFunction
ensurePodmanIsInstalled () {
    if ! podman_loc="$(type -p "podman")" || [[ -z $podman_loc ]]; then
        echo "podman is missing. Install now?"
        promptToContinue
        . /etc/os-release
        echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
        curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add -
        sudo apt-get update
        sudo apt-get -y upgrade
        sudo apt-get -y install podman
    fi
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
    sed -e '$a\' $CONTAINERINTERNALLSFILEBACKUP > $CONTAINERINTERNALLSFILE
    # Add line to end of file
    echo $1>> $CONTAINERINTERNALLSFILE
    # writeToSystemLog "Added to LocalSettings.php: $1"
}

# Public MWMBashFunction
removeFromLocalSettings () {
    backupLocalSettingsPHP
    sed "$1" $CONTAINERINTERNALLSFILEBACKUP > $CONTAINERINTERNALLSFILE
    # writeToSystemLog "Removed from LocalSettings.php: $1"
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
    sleep 1
    date=`date +"%Y-%m-%d_%H-%M-%S"`
    CONTAINERINTERNALLSFILE=/var/www/html/w/LocalSettings.php
    CONTAINERINTERNALLSFILEBACKUP=/var/www/html/w/LocalSettingsPHPBACKUP/LocalSettings.php.bak.$date
    cp $CONTAINERINTERNALLSFILE $CONTAINERINTERNALLSFILEBACKUP
}