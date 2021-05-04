#!/bin/bash
# Public MWMBashScript: Inject objects from GitHub <ONTOLOGY_URL>.

source ./envs/my-new-system.env
source ./cli/lib/utils.sh

# Ask user
echo -n "Enter full GitHub clone URL, e.g. 'https://github.com/dataspects/dataspectsSystemCoreOntology.git': "
read ONTOLOGY_URL

./cli/system-snapshots/take-restic-snapshot.sh BeforeGitHubOntologyContentsInjection

# Clone
mkdir -p ontologies
ONTOLOGY_NAME=`basename $ONTOLOGY_URL .git`
git clone $ONTOLOGY_URL ontologies/$ONTOLOGY_NAME

# Log in to MW
source ./cli/lib/mediawiki-login-for-edit.sh

# Inject
for filename in ontologies/$ONTOLOGY_NAME/objects/*; do
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

runMWRunJobsPHP
runSMWRebuildData