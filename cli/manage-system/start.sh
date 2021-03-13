#!/bin/bash

source ./envs/my-new-system.env

echo "Turn off MWMSafeMode"

dockerDirectives=(
    "- \.\/mediawiki_root\/w\/LocalSettings\.php:\/var\/www\/html\/w\/LocalSettings\.php"
    "- \.\/mediawiki_root\/w\/extensions:\/var\/www\/html\/w\/extensions"
    "- \.\/mediawiki_root\/w\/skins:\/var\/www\/html\/w\/skins"
    "- \.\/mediawiki_root\/w\/vendor:\/var\/www\/html\/w\/vendor"
)

for dd in ${!dockerDirectives[@]}
do
    cp docker-compose.yml docker-compose.yml.bak
    sed "s/#${dockerDirectives[$dd]}/${dockerDirectives[$dd]}/g" docker-compose.yml.bak > docker-compose.yml
done

sudo docker-compose --env-file ./envs/my-new-system.env up -d