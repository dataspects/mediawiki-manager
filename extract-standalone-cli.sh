#!/bin/bash

mkdir -p ../standalonecli/cli/lib \
    ../standalonecli/cli/manage-content

cp cli/manage-content/inject-ontology-WikiPageContents.sh \
    cli/manage-content/mediawiki-inject.sh \
    ../standalonecli/cli/manage-content/
cp -r cli/lib/* ../standalonecli/cli/lib

cp -r envs ../standalonecli/

echo "MWM Standalone CLI ready at ../standalonecli"