#!/bin/bash
# Public MWMBashScript: Check which PHP directives are currently added to LocalSettings.php.

source ./cli/lib/runInContainerOnly.sh

printf "\n\033[0;32m\e[1mMWM Config\033[0m"
printf "\n====================\n"
php ./cli/config-db/view-mwm-config.php
printf "\n====================\n\n"