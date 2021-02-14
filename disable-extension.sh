#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

echo -n "Enter extension name to remove: "
read EXTENSION_NAME

# Check if the EXTENSION_NAME is of format abc/xyz
if [[ $EXTENSION_NAME =~ \/ ]]; then
  # If yes, then it refers to packagist
  sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php composer.phar remove --no-update $EXTENSION_NAME"
  EXTNAME=$(sed -r 's/[a-z]+\/(.*)/\1/g' <<<$EXTENSION_NAME)
  EXTNAME_CC=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<$EXTNAME)
else
  # If no, then it seems to be manually managed
  EXTNAME_CC=$EXTENSION_NAME  
fi

# If applicable, uncomment wfLoadExtension
sed -i "s/^wfLoadExtension( '$EXTNAME_CC' );/#wfLoadExtension( '$EXTNAME_CC' );/g" mediawiki_root/w/LocalSettings.php

sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php maintenance/update.php"