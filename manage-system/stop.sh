#!/bin/bash
# Public MWMBashScript: Stop MWM System.

source ./envs/my-new-system.env
source $MEDIAWIKI_CLI/lib/utils.sh

$CONTAINER_COMMAND pod stop $POD

if [[ $? == 0 ]]
then
    printf "\x1b[32mSUCCESS\033[0m: stopped pod $POD\n"
else
    printf "Pod $POD not found, so not stopped. Continuing...\n"
fi