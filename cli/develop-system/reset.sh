#!/bin/bash

source ./cli/lib/utils.sh

./cli/manage-system/stop.sh

podman pod rm mwm
if [[ $? == 0 ]]
then
    echo "SUCCESS: removed pod mwm"
else
    echo "Pod mwm not found, so not removing. Continuing..."
fi

#FIXME: Why sudo?
sudo rm -rf \
    mediawiki_root \
    restic-backup-repository \
    mariadb_data \
    cloneLocation

./cli/install-system/install-system.sh