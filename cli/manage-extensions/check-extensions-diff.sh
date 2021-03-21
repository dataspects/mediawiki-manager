#!/bin/bash

source ./cli/lib/utils.sh

printf "Comparing mediawiki_root/w/extensions/ <<<>>> existing_version/extensions/\n\n"
diff --brief \
 mediawiki_root/w/extensions/ \
 existing_version/extensions/ \
 | grep --color=auto Only

printf "\nComparing:\tmediawiki_root/w/composer.json/\t\tAGAINST\t\texisting_version/composer.json\n\n"
diff --side-by-side --suppress-common-lines \
    mediawiki_root/w/composer.json existing_version/composer.json