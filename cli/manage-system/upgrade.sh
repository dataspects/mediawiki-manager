#!/bin/bash

# MWMBashScript: restart MWM System

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh
source ./envs/my-new-system.env

./cli/system-snapshots/take-restic-snapshot.sh Upgrade

./cli/manage-system/stop.sh
podman pod rm mwm-deployment-pod-0

MEDIAWIKI_IMAGE=docker.io/dataspects/mediawiki:1.35.1-2104141705
envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
podman play kube mediawiki-manager.yml

./cli/system-snapshots/restore-restic-snapshot.sh latest

runMWUpdatePHP