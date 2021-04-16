#!/bin/bash

source ./cli/lib/utils.sh

printf "Comparing mediawiki_root/w/extensions/ <<<>>> existing_version/extensions/\n\n"
diff --brief \
 mediawiki_root/w/extensions/ \
 existing_version/extensions/ \
 | grep --color=auto Only

printf "\nComparing:\tmediawiki_root/w/composer.local.json/\t\tAGAINST\t\texisting_version/composer.local.json\n\n"
diff --side-by-side --suppress-common-lines \
    mediawiki_root/w/composer.local.json existing_version/composer.local.json