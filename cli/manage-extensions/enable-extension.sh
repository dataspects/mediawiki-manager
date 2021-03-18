#!/bin/bash

# FIXME: handle multiple system setups
source ./envs/my-new-system.env
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

getExtensionName

backupLocalSettingsPHP
sed -i "s/^#wfLoadExtension( '$EXTNAME_CC' );/wfLoadExtension( '$EXTNAME_CC' );/g" mediawiki_root/w/LocalSettings.php

runMWUpdatePHP