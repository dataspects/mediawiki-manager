#!/bin/bash

CURRENT_CANASTA_ARCHIVE=mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz

####################################

CANASTA_INSTANCE_ROOT=/home/dserver # No trailing / !
MEDIAWIKI_ROOT_FOLDER=$CANASTA_INSTANCE_ROOT/mediawiki_root
APACHE_CONTAINER_NAME=mediawiki_canasta

requiredFiles=( "$CURRENT_CANASTA_ARCHIVE" )
for file in "${requiredFiles[@]}"
do
  if [ ! -e "$file" ]; then
    echo "$file is missing!"
    exit 1
  fi
done

echo "Backup existing w/"
mkdir --parents existing_version
sudo mv $MEDIAWIKI_ROOT_FOLDER/w/* existing_version

echo "Extract..."
tar -xzf $CURRENT_CANASTA_ARCHIVE -C $MEDIAWIKI_ROOT_FOLDER/w
sleep 5

echo "Copy..."
cp -r existing_version/LocalSettings.php existing_version/images $MEDIAWIKI_ROOT_FOLDER/w/

echo "Ensure permissions..."
sudo chown -R www-data $MEDIAWIKI_ROOT_FOLDER/w/images

echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php'

echo "Done switching to $CURRENT_CANASTA_ARCHIVE"