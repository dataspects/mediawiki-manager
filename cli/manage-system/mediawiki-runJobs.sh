#!/bin/bash
source ./cli/lib/runInContainerOnly.sh=false

source ./cli/lib/utils.sh


source ./envs/my-new-system.env

podman exec $APACHE_CONTAINER_NAME /bin/bash -c "cd w && php maintenance/runJobs.php"