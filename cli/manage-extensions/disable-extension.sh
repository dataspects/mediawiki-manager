#!/bin/bash

# FIXME: handle multiple system setups
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html

EXTNAME=$1

MYLOCALSETTINGSFILE=/var/www/html/w/LocalSettings.php

# Load data
getExtensionData $EXTNAME
installationAspects=`getExtensionDataByKey "installation-aspects" "$extensionData"`
localSettings=`getExtensionDataByKey "localsettings" "$installationAspects"`

# Backup
backupfile=$MYLOCALSETTINGSFILE.bak.`date +"%Y-%m-%d_%H-%M-%S"`

# Sed
echo $localSettings | jq -r '.[]' | while read lsLine
do
    cp $MYLOCALSETTINGSFILE $backupfile
    sed "s/$lsLine/#$lsLine/g" $backupfile > $MYLOCALSETTINGSFILE
done

# runMWUpdatePHP