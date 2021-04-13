#!/bin/bash

source ./envs/my-new-system.env

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
    "restic \
        --repo /var/www/html/restic-repo \
        --password-file /var/www/restic_password \
            snapshots"