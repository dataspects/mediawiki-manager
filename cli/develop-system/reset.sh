#!/bin/bash

source ./cli/lib/utils.sh

./cli/manage-system/stop.sh

sudo rm -rf \
    mediawiki_root/* \
    restic-backup-repository/* \
    mariadb_data/*

mkdir --parent mediawiki_root/w/images

./cli/install-system/install-system.sh