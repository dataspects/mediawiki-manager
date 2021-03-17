#!/bin/bash

source ./cli/lib/utils.sh

./cli/manage-system/stop.sh

podman pod rm mwm

sudo rm -rf \
    mediawiki_root/* \
    restic-backup-repository/* \
    mariadb_data/*

mkdir --parent mediawiki_root/w/images

./cli/install-system/install-system.sh