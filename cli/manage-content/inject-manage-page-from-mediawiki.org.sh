#!/bin/bash
# Public MWMBashScript: Inject <TITLE>s from <WIKIAPI> BY <SECTION>s.

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

# ./cli/system-snapshots/take-restic-snapshot.sh BeforeMWOrgContentsInjection

WIKIAPI=https://www.mediawiki.org/w/api.php
TITLE="Help:Editing_pages"
SECTION=1
source ./cli/manage-content/mediawiki-get-wikitext-from-api.sh

source ./cli/lib/mediawiki-login-for-edit.sh
PAGENAME="Help:Editing pages"
source ./cli/manage-content/mediawiki-inject.sh

runMWRunJobsPHP
runSMWRebuildData