#!/bin/bash

./stop.sh

echo "Turn on MWMSafeMode"

dockerDirectives=(
    "- \.\/mediawiki_root\/w\/LocalSettings\.php:\/var\/www\/html\/w\/LocalSettings\.php"
    "- \.\/mediawiki_root\/w\/extensions:\/var\/www\/html\/w\/extensions"
)

for dd in ${!dockerDirectives[@]}
do
    sed -i "s/${dockerDirectives[$dd]}/#${dockerDirectives[$dd]}/g" docker-compose.yml
done

sudo docker-compose --env-file ./CanastaInstanceSettings.env up -d