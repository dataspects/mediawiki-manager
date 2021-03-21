#!/bin/bash
runInContainerOnly=true

# FIXME: handle multiple system setups
source ./cli/lib/utils.sh
source ./cli/manage-extensions/utils.sh
source ./cli/lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html

EXTNAME=$1

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
backupLocalSettingsPHP
if [ $cInstrFound ]
then
    echo "Running composer..."
    cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar require $composer
    echo "Ran composer"
fi
if [ $rInstrFound ]
then
    echo "Running repository"
    git clone $repository w/extensions/$EXTNAME
fi
if [ $lsInstrFound ]
then
    echo "Running localsettings"
    # Backup
    backupfile=$CONTAINERINTERNALLSFILE.bak.`date +"%Y-%m-%d_%H-%M-%S"`
    # Sed
    echo $localSettings | jq -r '.[]' | while read lsLine
    do
        cp $CONTAINERINTERNALLSFILE $backupfile
        grep "^#$lsLine$" $CONTAINERINTERNALLSFILE
        if [[ $? == 0 ]]
        then
            sed "s/#\{1,\}$lsLine/$lsLine/g" $backupfile > $CONTAINERINTERNALLSFILE
        else
            addToLocalSettings "$lsLine"
        fi
    done
fi
###

runMWUpdatePHP