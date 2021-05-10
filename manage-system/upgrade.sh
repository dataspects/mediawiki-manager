#!/bin/bash
# Public MWMBashScript: Upgrade MWM System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags

source $MEDIAWIKI_CLI/lib/utils.sh
source $MEDIAWIKI_CLI/lib/permissions.sh
source ./envs/my-new-system.env

echo -n "Enter MEDIAWIKI_IMAGE, e.g. 'docker.io/dataspects/mediawiki:1.35.1-2104141705': "
read MEDIAWIKI_IMAGE

$MEDIAWIKI_CLI/system-snapshots/take-restic-snapshot.sh BeforeUpgrade

$MEDIAWIKI_CLI/manage-system/stop.sh
$CONTAINER_COMMAND pod rm mwm-deployment-pod-0

envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
$CONTAINER_COMMAND play kube mediawiki-manager.yml

$MEDIAWIKI_CLI/system-snapshots/restore-restic-snapshot.sh latest

source $MEDIAWIKI_CLI/lib/waitForMariaDB.sh

source ./envs/my-new-system.env
$CONTAINER_COMMAND exec $APACHE_CONTAINER_NAME /bin/bash -c "cd $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w && COMPOSER_HOME=$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w php composer.phar update"

runMWUpdatePHP