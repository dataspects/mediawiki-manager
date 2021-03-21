#!/bin/bash

source ./cli/lib/utils.sh
source ./cli/manage-extensions/utils.sh

getExtensionJSON
printf "\nMWStake Certified Extensions Catalog"
printf "\n====================================\n"
printf "$CATALOGUE_URL\n\n"
echo $catalogueJSON | jq '.[]' | jq '.name'
printf "\n====================================\n"