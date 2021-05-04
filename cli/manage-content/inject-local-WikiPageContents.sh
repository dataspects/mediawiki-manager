#!/bin/bash
# Public MWMBashScript: Inject <PageName>.wikitext files from local ./WikiPageContents directory.

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

# ./cli/system-snapshots/take-restic-snapshot.sh BeforeLocalContentsInjection

source ./cli/lib/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    getPageData "$filename"
    source ./cli/manage-content/mediawiki-inject.sh
done

runMWRunJobsPHP
runSMWRebuildData