#!/bin/bash

# FIXME: handle multiple system setups
source ./envs/my-new-system.env
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/

getExtensionNames
echo $extensionNamesString

getExtensionData "PageForms"
echo $extensionData | jq '.categories'

exit


getExtensionName

# If applicable, uncomment wfLoadExtension
backupLocalSettingsPHP
sed -i "s/^wfLoadExtension( '$EXTNAME_CC' );/#wfLoadExtension( '$EXTNAME_CC' );/g" mediawiki_root/w/LocalSettings.php

runMWUpdatePHP