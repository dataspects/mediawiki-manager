#!/bin/bash
# Public MWMBashScript: CAUTION: Remove everything except container images and reset entire system.
#

source ./envs/my-new-system.env
source $MEDIAWIKI_CLI/lib/utils.sh

$MEDIAWIKI_CLI/manage-system/stop.sh

$CONTAINER_COMMAND pod rm mwm-deployment-pod-0
if [[ $? == 0 ]]
then
    echo "SUCCESS: removed pod mwm"
else
    echo "Pod mwm not found, so not removing. Continuing..."
fi

#FIXME: Why sudo?
sudo rm -rf \
    system_root \
    snapshots \
    mariadb_data \
    mwmconfigdb.sqlite

$MEDIAWIKI_CLI/install-system/install-system-Ubuntu-20.04.sh