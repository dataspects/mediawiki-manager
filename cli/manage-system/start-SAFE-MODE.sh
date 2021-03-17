#!/bin/bash

# MWM Feature:
#
# The dataspects MediaWiki Docker images in itself provide a working MediaWiki System setup if
# operated by the means of MWM.
#
# This means that here is an EPHEMERAL working MediaWiki System setup if the mediawiki service
# in docker-compose.yml is deprived of all ./mediawiki_root/w/* volumes.

# REFACTOR!

# source ./cli/lib/utils.sh
# source ./cli/lib/permissions.sh

# source ./envs/my-new-system.env

# ./cli/manage-system/stop.sh

# echo "Turn on MWMSafeMode"

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
#     sed "s/${dockerDirectives[$dd]}/#${dockerDirectives[$dd]}/g" docker-compose.yml.bak > docker-compose.yml
# done

# podman-compose --env-file ./envs/my-new-system.env up -d

# source ./cli/lib/waitForMariaDB.sh
# runMWUpdatePHP