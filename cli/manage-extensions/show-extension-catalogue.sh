#!/bin/bash

source ./cli/lib/utils.sh
source ./cli/manage-extensions/utils.sh

getExtensionJSON
echo $catalogueJSON | jq