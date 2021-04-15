#!/bin/bash

# This script is used in the context of https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager#ALcontainerization:_Docker

source ./envs/my-new-system.env

podman container stop temp-mediawiki

MWM_MEDIAWIKI_CONTAINER_ID=$(podman run \
  --restart=no \
  --detach \
  --rm=true \
  --name=temp-mediawiki \
  $MEDIAWIKI_IMAGE)
if [[ $? == 0 ]]
then
    echo "SUCCESS: obtained container id."
else
    echo "ERROR: obtaining container id. Exiting."
    exit
fi

declare -a vols=(
  "/var/www/html/w/extensions"
  "/var/www/html/w/skins"
  "/var/www/html/w/vendor"
  "/var/www/html/w/composer.json"
  "/var/www/html/w/images"
)
for vol in "${vols[@]}"
do
  podman cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $MEDIAWIKI_ROOT/w
  if [[ $? == 0 ]]
  then
      echo "SUCCESS: copied $vol"
  else
      echo "ERROR: copying $vol. Exiting."
      exit
  fi
done

podman stop $MWM_MEDIAWIKI_CONTAINER_ID > /dev/null
if [[ $? == 0 ]]
  then
      echo "SUCCESS: stopped $MWM_MEDIAWIKI_CONTAINER_ID"
  else
      echo "ERROR: stopping $MWM_MEDIAWIKI_CONTAINER_ID. Exiting."
      exit
  fi

# FIXME
chmod -R 777 $MEDIAWIKI_ROOT/w

echo "SUCCESS: Initialized persistent mediawiki service volumes"