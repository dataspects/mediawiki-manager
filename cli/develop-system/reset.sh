#!/bin/bash

./cli/manage-system/stop.sh

sudo rm -rf \
    mediawiki_root \
    restic_data \
    mysql_data

./cli/install-system/install-system.sh