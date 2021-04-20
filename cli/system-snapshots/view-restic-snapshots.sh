#!/bin/bash
# Public MWMBashCommand
#

source ./cli/lib/runInContainerOnly.sh

printf "\n\033[0;32m\e[1mMWM System Snapshots\033[0m"
printf "\n====================\n"
restic \
    --repo /var/www/html/snapshots \
    --password-file /var/www/restic_password \
        snapshots
printf "\n====================\n\n"
printf "To take a snapshot run : ./cli/system-snapshots/take-restic-snapshot.sh <TAG>\n"
printf "To restore <ID> run : ./cli/system-snapshots/restore-restic-snapshot.sh <ID>\n"
printf "\n"

