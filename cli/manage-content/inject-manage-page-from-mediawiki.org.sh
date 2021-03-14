#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

WIKIAPI=https://www.mediawiki.org/w/api.php
TITLE=Project_Canasta/Infrastructure_development
SECTION=1
source ./cli/manage-content/mediawiki-get-wikitext-from-api.sh

source ./cli/lib/mediawiki-login-for-edit.sh
PAGENAME="Manage this MediaWiki instance"
source ./cli/manage-content/mediawiki-inject.sh