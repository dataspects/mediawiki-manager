#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

source ./cli/lib/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    getPageData "$filename"
    source ./cli/manage-content/mediawiki-inject.sh
done

podman exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php maintenance/runJobs.php && php extensions/SemanticMediaWiki/maintenance/rebuildData.php"