#!/bin/bash
# Public MWMBashCommand
#

clear;
./cli/system-snapshots/view-restic-snapshots.sh
./cli/config-db/view-mwm-config.sh
./cli/manage-extensions/show-extension-catalogue.sh
./cli/manage-system/show-composerLocalJSON.sh