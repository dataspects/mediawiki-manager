#!/bin/bash
# Public MWMBashScript: Check the usage of distinct MWM CLI-level directives (scripts, functions, PHP).

strs=(
    "runMWUpdatePHP"
    "runSMWRebuildData"
    "waitForMariaDB"
    "podman pod"
    "./cli/system-snapshots/take-restic-snapshot.sh"
    "addToMWMSQLite.php"
    "removeFromMWMSQLite.php"
    "updateMWMLocalSettings.php"
    "composer.phar"
)

clear;
if [[ $1 == "" ]]
then
    CONTEXT=0
else
    CONTEXT=$1
fi
FLAGS="--line-number \
    --recursive \
    --color=always \
    --ignore-case \
    --context=$CONTEXT \
    --exclude-dir=develop-system \
    --exclude-dir=mediawiki_root \
    --exclude-dir=mariadb_data \
    --exclude-dir=currentresources \
    --exclude-dir=.git"

for s in "${strs[@]}"
do
    printf "\n\n\n=== '$s' found in ===\n"
    egrep $FLAGS "$s";
done