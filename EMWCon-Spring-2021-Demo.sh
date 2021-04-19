#!/bin/bash
source ./cli/lib/utils.sh

clear
printf "\n\e[1mWelcome to the EMWCon-Spring-2021-Demo!\e[0m"
promptToContinue

viewStatusReport 1

clear
printf "\n\e[1mStep 2: Install LabeledSectionTransclusion - https://dserver:4443/wiki/Special:Version\e[0m"
printf "\n\n\t\e[4m./cli/manage-extensions/enable-extension.sh LabeledSectionTransclusion\e[0m\n"
promptToContinue
./cli/manage-extensions/enable-extension.sh LabeledSectionTransclusion
promptToContinue

clear
printf "\n\e[1mStep 3: Install SemanticScribunto - https://dserver:4443/wiki/Special:Version\e[0m"
printf "\n\n\t\e[4m./cli/manage-extensions/enable-extension.sh SemanticScribunto\e[0m\n"
promptToContinue
./cli/manage-extensions/enable-extension.sh SemanticScribunto
promptToContinue

clear
printf "\n\e[1mStep 4: Inject pages from local source - https://github.com/dataspects/mediawiki-manager/tree/main/WikiPageContents\e[0m"
printf "\n\n\t\e[4m./cli/manage-content/inject-local-WikiPageContents.sh\e[0m\n"
promptToContinue
source ./cli/manage-content/inject-local-WikiPageContents.sh
promptToContinue

clear
printf "\n\e[1mStep 5: Inject https://www.mediawiki.org/wiki/Help:Editing_pages\e[0m"
printf "\n\n\t\e[4m./cli/manage-content/inject-manage-page-from-mediawiki.org.sh\e[0m\n"
promptToContinue
source ./cli/manage-content/inject-manage-page-from-mediawiki.org.sh
promptToContinue

clear
printf "\n\e[1mStep 6: Inject https://github.com/dataspects/dataspectsSystemCoreOntology\e[0m"
printf "\n\n\t\e[4m./cli/manage-content/inject-ontology-WikiPageContents.sh\e[0m\n"
promptToContinue
source ./cli/manage-content/inject-ontology-WikiPageContents.sh
promptToContinue