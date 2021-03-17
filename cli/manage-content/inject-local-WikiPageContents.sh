#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

source ./cli/lib/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    getPageData "$filename"
    source ./cli/manage-content/mediawiki-inject.sh
done

runMWUpdatePHP
runSMWRebuildData