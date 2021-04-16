#!/bin/bash

strs=(
    "runMWUpdatePHP"
    "runSMWRebuildData"
    "waitForMariaDB"
    "podman pod"
    "./cli/system-snapshots/take-restic-snapshot.sh"
    "addToMWMSQLite.php"
    "removeFromMWMSQLite.php"
    "updateMWMLocalSettings.php"
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
    --exclude-dir=.git"

for s in "${strs[@]}"
do
    printf "\n\n\n=== '$s' found in ===\n"
    egrep $FLAGS "$s";
done