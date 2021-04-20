#!/bin/bash
# Public MWMBashCommand
#

printf "\n\033[0;32m\e[1mPods\033[0m"
printf "\n====================================\n"
podman pod ls

printf "\n\033[0;32m\e[1mContainers\033[0m"
printf "\n====================================\n"
podman container ls -a --pod

printf "\n\033[0;32m\e[1mImages\033[0m"
printf "\n====================================\n"
podman image ls -a

printf "\n"