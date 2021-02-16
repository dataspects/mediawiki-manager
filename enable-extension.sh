#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

echo -n "Enter extension name to enable: "
read EXTENSION_NAME

if [[ $EXTENSION_NAME =~ \/ ]]; then
  sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php composer.phar require $EXTENSION_NAME"
  EXTNAME=$(sed -r 's/[a-z]+\/(.*)/\1/g' <<<$EXTENSION_NAME)
  EXTNAME_CC=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<$EXTNAME)
else
  EXTNAME_CC=$EXTENSION_NAME
fi

sed -i "s/^#wfLoadExtension( '$EXTNAME_CC' );/wfLoadExtension( '$EXTNAME_CC' );/g" mediawiki_root/w/LocalSettings.php

sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php maintenance/update.php"