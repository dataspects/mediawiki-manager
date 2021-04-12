#!/bin/bash

source ./cli/lib/utils.sh

source ./envs/my-new-system.env

podman container stop mwm-deployment-pod-0-mediawiki-safemode
podman container start mwm-deployment-pod-0-mediawiki

source ./cli/lib/waitForMariaDB.sh
runMWUpdatePHP