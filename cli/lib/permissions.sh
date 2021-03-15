#!/bin/bash



setPermissionsOnSystemInstanceRoot () {

    dir=$SYSTEM_INSTANCE_ROOT/logs
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        sudo chmod -R 770 $dir
    fi

    dir=$MEDIAWIKI_ROOT/w
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        sudo chmod -R 770 $dir
    fi

    dir=$MEDIAWIKI_ROOT/restic-backup-repository
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        sudo chmod -R 770 $dir
    fi

    dir=$MEDIAWIKI_ROOT/cloneLocation
    if [ -d $dir ]
    then
        sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data $dir
        sudo chmod -R 770 $dir
    fi

    writeToSystemLog "Permissions set on $SYSTEM_INSTANCE_ROOT"
}