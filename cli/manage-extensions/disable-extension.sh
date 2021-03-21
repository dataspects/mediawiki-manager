#!/bin/bash
runInContainerOnly=true

# FIXME: handle multiple system setups
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html


EXTNAME=$1

MYLOCALSETTINGSFILE=/var/www/html/w/LocalSettings.php

###
# Collect installation aspects
getExtensionData $EXTNAME
installationAspects=`getExtensionDataByKey "installation-aspects" "$extensionData"`
composer=`getExtensionDataByKey "composer" "$installationAspects"`
repository=`getExtensionDataByKey "repository" "$installationAspects"`
localSettings=`getExtensionDataByKey "localsettings" "$installationAspects"`
if [ "$composer" != "null" ]; then cInstrFound=true; fi
if [ "$repository" != "null" ]; then rInstrFound=true; fi
if [ "$localSettings" != "null" ]; then lsInstrFound=true; fi
###

###
# Check installation aspects
if [ $cInstrFound ] && [ $rInstrFound ]
then
    echo "Problem: Installation aspects for $EXTNAME contain both composer and repository specifications!"
    exit
fi
###

###
# Run installation aspects
if [ $cInstrFound ]
then
    echo "Running composer..."
    cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar remove $composer
    echo "Ran composer"
fi
if [ $rInstrFound ]
then
    echo "Running repository"
fi
if [ $lsInstrFound ]
then
    echo "Running localsettings"
    # Backup
    backupfile=$MYLOCALSETTINGSFILE.bak.`date +"%Y-%m-%d_%H-%M-%S"`
    # Sed
    echo $localSettings | jq -r '.[]' | while read lsLine
    do
        cp $MYLOCALSETTINGSFILE $backupfile
        sed "s/$lsLine/#$lsLine/g" $backupfile > $MYLOCALSETTINGSFILE
    done
fi
###

runMWUpdatePHP