#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.

clear;
./cli/config-db/view-mwm-config.sh
./cli/manage-system/show-composerLocalJSON.sh
./cli/system-snapshots/view-restic-snapshots.sh
./cli/manage-extensions/show-extension-catalogue.sh
# ./report-podman.sh