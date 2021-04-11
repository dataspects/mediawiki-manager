#!/bin/bash

source ./cli/lib/utils.sh
source ./cli/manage-extensions/utils.sh

getExtensionJSON
printf "\nMWStake Certified Extensions Catalog"
printf "\n====================================\n"
printf "$CATALOGUE_URL\n\n"
printf "\n<EXTNAME>\n---------\n"
echo $catalogueJSON | jq '.[]' | jq -r '.name'
printf "\n====================================\n\n"
printf "To enable <EXTNAME> run  : ./cli/manage-extensions/enable-extension.sh <EXTNAME>\n"
printf "To disable <EXTNAME> run : ./cli/manage-extensions/disable-extension.sh <EXTNAME>\n"
printf "\n"