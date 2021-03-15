#!/bin/bash

MWM_MEDIAWIKI_CONTAINER_ID=$(sudo docker run \
  --detach \
  dataspects/mediawiki:1.35.0-2103040820)
declare -a vols=(
  "var/www/html/w/LocalSettings.php"
  "var/www/html/w/extensions"
  "var/www/html/w/skins"
  "var/www/html/w/vendor"
  "var/www/html/w/composer.json"
)
for vol in "${vols[@]}"
do
  sudo docker cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $MEDIAWIKI_ROOT/w
done
echo "Initialized persistent mediawiki service volumes"