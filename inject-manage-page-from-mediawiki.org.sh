#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

source ./scripts/utils.sh

WIKIAPI=https://www.mediawiki.org/w/api.php
TITLE=Project_Canasta/Infrastructure_solution
SECTION=5
source ./scripts/mediawiki-get-wikitext-from-api.sh

source ./scripts/mediawiki-login-for-edit.sh
PAGENAME="Manage this MediaWiki instance"
source ./scripts/mediawiki-inject.sh