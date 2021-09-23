#!/bin/bash
# Public MWMBashScript: Check out pods, containers and images.

CONTAINER_COMMAND=podman

printf "\n\033[0;32m\e[1mPods\033[0m"
printf "\n====================================\n"
$CONTAINER_COMMAND pod ls

printf "\n\033[0;32m\e[1mContainers\033[0m"
printf "\n====================================\n"
$CONTAINER_COMMAND container ls -a --pod

printf "\n\033[0;32m\e[1mImages\033[0m"
printf "\n====================================\n"
$CONTAINER_COMMAND image ls -a

printf "\n"