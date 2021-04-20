#!/bin/bash
# Public MWMBashCommand
#

source ./envs/my-new-system.env

printf "\n\033[0;32m\e[1mcomposer.local.json\033[0m"
printf "\n====================================\n"
jq . $MEDIAWIKI_ROOT/w/composer.local.json
printf "\n"