#!/bin/bash

source ./envs/my-new-system.env

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

printf "\nMWM System Snapshots"
printf "\n====================\n"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
    "restic \
        --repo /var/www/html/snapshots \
        --password-file /var/www/restic_password \
            snapshots"
printf "\n====================\n\n"
printf "To restore <ID> run : ./cli/system-snapshots/restore-restic-snapshot.sh <ID>\n"
printf "\n"

