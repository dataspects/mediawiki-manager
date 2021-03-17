#!/bin/bash

# This script is used in the context of https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager#ALcontainerization:_Docker

MWM_MEDIAWIKI_CONTAINER_ID=$(podman run \
  --restart=no \
  --detach \
  --rm=true \
  dataspects/mediawiki:1.35.0-2103040820)
declare -a vols=(
  "/var/www/html/w/LocalSettings.php"
  "/var/www/html/w/extensions"
  "/var/www/html/w/skins"
  "/var/www/html/w/vendor"
  "/var/www/html/w/composer.json"
)
for vol in "${vols[@]}"
do
  podman cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $MEDIAWIKI_ROOT/w
done
podman stop $MWM_MEDIAWIKI_CONTAINER_ID

# FIXME
sudo chmod -R 777 $MEDIAWIKI_ROOT/w

echo "Initialized persistent mediawiki service volumes"