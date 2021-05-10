#!/bin/bash
# Public MWMBashScript: Start MWM System.

source ./envs/my-new-system.env
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/utils.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/config-db/lib.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/logging/lib.sh

$CONTAINER_COMMAND pod start $POD
$CONTAINER_COMMAND container start $POD-mediawiki
compileMWMLocalSettings
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/waitForMariaDB.sh