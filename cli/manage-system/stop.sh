#!/bin/bash

source ./cli/lib/utils.sh

podman pod stop $POD

if [[ $? == 0 ]]
then
    printf "\x1b[32mSUCCESS\033[0m: stopped pod $POD\n"
else
    printf "Pod $POD not found, so not stopped. Continuing...\n"
fi