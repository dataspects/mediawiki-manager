#!/bin/bash
# Public MWMBashScript: Upgrade MWM System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh
source ./envs/my-new-system.env

echo -n "Enter MEDIAWIKI_IMAGE, e.g. 'docker.io/dataspects/mediawiki:1.35.1-2104141705': "
read MEDIAWIKI_IMAGE

./cli/system-snapshots/take-restic-snapshot.sh BeforeUpgrade

./cli/manage-system/stop.sh
podman pod rm mwm-deployment-pod-0

envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
podman play kube mediawiki-manager.yml

./cli/system-snapshots/restore-restic-snapshot.sh latest

source ./cli/lib/waitForMariaDB.sh

source ./envs/my-new-system.env
podman exec $APACHE_CONTAINER_NAME /bin/bash -c "cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar update"

runMWUpdatePHP