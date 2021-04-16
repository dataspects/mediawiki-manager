#!/bin/bash

source ./cli/lib/runInContainerOnly.sh

printf "\n\033[0;32mMWM Config\033[0m"
printf "\n====================\n"
php ./cli/config-db/view-mwm-config.php
printf "\n====================\n\n"