#!/bin/bash

source ./cli/lib/utils.sh

source ./envs/my-new-system.env

podman pod start $POD
podman container stop $MWCsafemode
podman container start $MWCnormal

source ./cli/lib/waitForMariaDB.sh
runMWUpdatePHP