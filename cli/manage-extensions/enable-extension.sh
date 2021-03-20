#!/bin/bash

# FIXME: handle multiple system setups
source ./envs/my-new-system.env
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html

EXTNAME=$1

# Load data
getExtensionData $EXTNAME
installationAspects=`getExtensionDataByKey "installation-aspects" "$extensionData"`
localSettings=`getExtensionDataByKey "localsettings" "$installationAspects"`

# Backup
backupfile=$MYLOCALSETTINGSFILE.bak.`date +"%Y-%m-%d_%H-%M-%S"`
cp $MYLOCALSETTINGSFILE $backupfile

# Sed
echo $localSettings | jq -r '.[]' | while read lsLine
do
    sed -i "s/#\{1,\}$lsLine/$lsLine/g" $MYLOCALSETTINGSFILE
done

# runMWUpdatePHP