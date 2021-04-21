#!/bin/bash

# CreateCampEMWCon2021: Check general permissions

setPermissionsOnSystemInstanceRoot () {

    dir=$SYSTEM_INSTANCE_ROOT/logs
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    dir=$MEDIAWIKI_ROOT/w
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    dir=$MEDIAWIKI_ROOT/snapshots
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    writeToSystemLog "Permissions set on $SYSTEM_INSTANCE_ROOT"
}