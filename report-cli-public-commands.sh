#!/bin/bash

clear;

FLAGS="--recursive \
    --after-context=1 \
    --color=always \
    --exclude=report-cli-public-commands.sh \
    --exclude-dir=develop-system \
    --exclude-dir=mediawiki_root \
    --exclude-dir=mariadb_data \
    --exclude-dir=currentresources \
    --exclude-dir=.git"

egrep $FLAGS "# Public MWMBashCommand"