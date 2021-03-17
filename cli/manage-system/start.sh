#!/bin/bash

source ./envs/my-new-system.env

# REFACTOR!
# echo "Ensure MWMSafeMode is turned off..."
# dockerDirectives=(
#     "- \.\/mediawiki_root\/w\/LocalSettings\.php:\/var\/www\/html\/w\/LocalSettings\.php"
#     "- \.\/mediawiki_root\/w\/extensions:\/var\/www\/html\/w\/extensions"
#     "- \.\/mediawiki_root\/w\/skins:\/var\/www\/html\/w\/skins"
#     "- \.\/mediawiki_root\/w\/vendor:\/var\/www\/html\/w\/vendor"
#     "- \.\/mediawiki_root\/w\/composer.json:\/var\/www\/html\/w\/composer.json"
# )

# for dd in ${!dockerDirectives[@]}
# do
#     cp docker-compose.yml docker-compose.yml.bak
#     sed -E "s/#{1,}${dockerDirectives[$dd]}/${dockerDirectives[$dd]}/g" docker-compose.yml.bak > docker-compose.yml
# done

podman pod start mwm

source ./cli/lib/waitForMariaDB.sh