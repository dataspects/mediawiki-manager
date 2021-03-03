#!/bin/bash

sudo rm -rf \
    mediawiki_root \
    restic_data \
    mysql_data

./install-canasta-version.sh