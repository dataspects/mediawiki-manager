#!/bin/bash
# Public MWMBashScript: Start MWM System.

source ./envs/my-new-system.env
source ./cli/lib/utils.sh
source ./cli/config-db/lib.sh
source ./cli/logging/lib.sh

podman pod start $POD
podman container start $POD-mediawiki
compileMWMLocalSettings
source ./cli/lib/waitForMariaDB.sh