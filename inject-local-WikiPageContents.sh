#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

source ./scripts/utils.sh

source ./scripts/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    getPageData "$filename"
    source ./scripts/mediawiki-inject.sh
done