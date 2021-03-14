#!/bin/bash

source ./envs/my-new-system.env

####################################

source ./cli/lib/utils.sh

echo -n "Enter ontology name to inject: "
read ONTOLOGY_NAME

git clone https://github.com/dataspects/$ONTOLOGY_NAME.git

source ./cli/manage-content/mediawiki-login-for-edit.sh

for filename in $ONTOLOGY_NAME/objects/*; do
    if [[ -d $filename ]]; then
        NAMESPACE=$(sed -r 's/.*\/(.*)/\1/g' <<< $filename)
        for filename2 in $filename/*; do
            getPageData "$filename2"
            PAGENAME=$NAMESPACE:$PAGENAME
            source ./cli/manage-content/mediawiki-inject.sh
        done
    else
        getPageData "$filename"
        source ./cli/manage-content/mediawiki-inject.sh
    fi    
done

sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php maintenance/runJobs.php && php extensions/SemanticMediaWiki/maintenance/rebuildData.php"