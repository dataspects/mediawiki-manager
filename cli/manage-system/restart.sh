#!/bin/bash

# MWMBashScript: restart MWM System

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

source ./envs/my-new-system.env

./cli/manage-system/stop.sh
./cli/manage-system/start.sh