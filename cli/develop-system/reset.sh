#!/bin/bash

source ./cli/lib/utils.sh

./cli/manage-system/stop.sh

sudo rm -rf \
    mediawiki_root \
    restic-backup-repository \
    mysql_data

./cli/install-system/install-system.sh