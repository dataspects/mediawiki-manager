#!/bin/bash
# Public MWMBashScript: Show extensions featured in $CATALOGUE_URL.

source ./cli/lib/utils.sh
source ./cli/manage-extensions/utils.sh

getExtensionJSON
printf "\n\033[0;32m\e[1mMWStake Certified Extensions Catalog\033[0m"
printf "\n====================================\n"
printf "$CATALOGUE_URL\n\n"
printf "\n<EXTNAME>\n---------\n"
echo $catalogueJSON | jq '.[]' | jq -r '.name'
printf "\n====================================\n\n"
printf "To enable <EXTNAME> run  : ./cli/manage-extensions/enable-extension.sh <EXTNAME>\n"
printf "To disable <EXTNAME> run : ./cli/manage-extensions/disable-extension.sh <EXTNAME>\n"
printf "\n"