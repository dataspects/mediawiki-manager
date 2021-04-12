#!/bin/bash
podman pod stop mwm
if [[ $? == 0 ]]
then
    echo "SUCCESS: stopped pod mwm"
else
    echo "Pod mwm not found, so not stopped. Continuing..."
fi