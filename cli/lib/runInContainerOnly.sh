#!/bin/bash

if [ "`ls /home`" != "" ]
then
    source ./cli/lib/utils.sh

    printf "INFO: \x1b[31mredirecting run command to \033[1mpodman exec mwm-mediawiki `dirname $0`/`basename $0` "$1""
    source ./envs/my-new-system.env
    promptToContinue
    podman exec $APACHE_CONTAINER_NAME /bin/bash -c "`dirname $0`/`basename $0` $1"
    exit
fi