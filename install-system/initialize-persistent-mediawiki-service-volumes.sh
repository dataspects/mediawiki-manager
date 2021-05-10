#!/bin/bash

$CONTAINER_COMMAND container stop temp-mediawiki

MWM_MEDIAWIKI_CONTAINER_ID=$($CONTAINER_COMMAND run \
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
  # "/var/www/html/w/extensions"
  # "/var/www/html/w/skins"
  # "/var/www/html/w/vendor" # FIXME
  "/var/www/html/w/images"
)
for vol in "${vols[@]}"
do
  echo "$CONTAINER_COMMAND cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w..."
  $CONTAINER_COMMAND cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w
  if [[ $? == 0 ]]
  then
      echo "SUCCESS: copied $vol"
  else
      echo "ERROR: copying $vol. Exiting."
      exit
  fi
done

$CONTAINER_COMMAND stop $MWM_MEDIAWIKI_CONTAINER_ID > /dev/null
if [[ $? == 0 ]]
  then
      echo "SUCCESS: stopped $MWM_MEDIAWIKI_CONTAINER_ID"
  else
      echo "ERROR: stopping $MWM_MEDIAWIKI_CONTAINER_ID. Exiting."
      exit
  fi

# CreateCampEMWCon2021: Check general permissions
chmod -R 777 $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w

echo "SUCCESS: Initialized persistent mediawiki service volumes"