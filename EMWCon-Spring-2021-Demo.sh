#!/bin/bash
source ./cli/lib/utils.sh

clear
printf "\n\e[1mEMWCon-Spring-2021-Demo\e[0m"
promptToContinue

clear;
./report-status.sh
promptToContinue

clear
printf "\n\e[1mInstall LabeledSectionTransclusion - https://dserver:4443/wiki/Special:Version\e[0m"
promptToContinue
./cli/manage-extensions/enable-extension.sh LabeledSectionTransclusion
promptToContinue

clear
printf "\n\e[1mInstall SemanticScribunto - https://dserver:4443/wiki/Special:Version\e[0m"
promptToContinue
./cli/manage-extensions/enable-extension.sh SemanticScribunto
promptToContinue

clear;
./report-status.sh
promptToContinue

clear
printf "\n\e[1mInject new Main Page from local file\e[0m"
promptToContinue
source ./cli/manage-content/inject-local-WikiPageContents.sh
promptToContinue

clear
printf "\n\e[1mInject https://www.mediawiki.org/wiki/Help:Editing_pages\e[0m"
promptToContinue
source ./cli/manage-content/inject-manage-page-from-mediawiki.org.sh
promptToContinue

clear
source ./cli/manage-content/inject-ontology-WikiPageContents.sh
promptToContinue