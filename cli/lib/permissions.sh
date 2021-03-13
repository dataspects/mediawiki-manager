#!/bin/bash

setPermissionsOnSystemInstanceRoot () {
    sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $SYSTEM_INSTANCE_ROOT/logs
    sudo chmod -R 770 $SYSTEM_INSTANCE_ROOT/logs

    sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $MEDIAWIKI_ROOT/w
    sudo chmod -R 770 $MEDIAWIKI_ROOT/w
    
    writeToSystemLog "Permissions set on $SYSTEM_INSTANCE_ROOT"
}