#!/bin/bash
source ./cli/lib/utils.sh

viewStatusReport() {
    clear;
    printf "\n\e[1mStep $1: View status report...\e[0m"
    promptToContinue
    ./report-status.sh
    promptToContinue
}

clear
printf "\n\e[1mWelcome to the EMWCon-Spring-2021-Demo!\e[0m"
promptToContinue

viewStatusReport 1

clear
printf "\n\e[1mStep 2: Install LabeledSectionTransclusion - https://dserver:4443/wiki/Special:Version\e[0m"
promptToContinue
./cli/manage-extensions/enable-extension.sh LabeledSectionTransclusion
promptToContinue

viewStatusReport 3

clear
printf "\n\e[1mStep 4: Install SemanticScribunto - https://dserver:4443/wiki/Special:Version\e[0m"
promptToContinue
./cli/manage-extensions/enable-extension.sh SemanticScribunto
promptToContinue

viewStatusReport 5

clear
printf "\n\e[1mStep 6: Inject pages from local source - https://github.com/dataspects/mediawiki-manager/tree/main/WikiPageContents\e[0m"
promptToContinue
source ./cli/manage-content/inject-local-WikiPageContents.sh
promptToContinue

clear
printf "\n\e[1mStep 7: Inject https://www.mediawiki.org/wiki/Help:Editing_pages\e[0m"
promptToContinue
source ./cli/manage-content/inject-manage-page-from-mediawiki.org.sh
promptToContinue

clear
printf "\n\e[1mStep 8: Inject https://github.com/dataspects/dataspectsSystemCoreOntology\e[0m"
promptToContinue
source ./cli/manage-content/inject-ontology-WikiPageContents.sh
promptToContinue