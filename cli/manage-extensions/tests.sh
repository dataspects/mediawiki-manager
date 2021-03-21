#!/bin/bash
runInContainerOnly=false
source ./cli/lib/utils.sh
source ./envs/my-new-system.env

specialVersionLink () {
    printf "Check https://$SYSTEM_DOMAIN_NAME:4443/wiki/Special:Version"
}

###############
# New extension
ext="LabeledSectionTransclusion"
./cli/manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue

./cli/manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

####################
# Existing extension
ext="Mermaid"
./cli/manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

./cli/manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue