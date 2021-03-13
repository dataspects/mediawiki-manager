#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./scripts/utils.sh

WIKIAPI=https://www.mediawiki.org/w/api.php
TITLE=Project_Canasta/Infrastructure_development
SECTION=1
source ./scripts/mediawiki-get-wikitext-from-api.sh

source ./scripts/mediawiki-login-for-edit.sh
PAGENAME="Manage this MediaWiki instance"
source ./scripts/mediawiki-inject.sh