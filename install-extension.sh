#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

echo -n "Enter extension name to install: "
read EXTENSION_NAME

if [[ $EXTENSION_NAME =~ \/ ]]; then
  sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php composer.phar require $EXTENSION_NAME"
  EXTNAME=$(sed -r 's/[a-z]+\/(.*)/\1/g' <<<$EXTENSION_NAME)
  EXTNAME_CC=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<$EXTNAME)
else
  EXTNAME_CC=$EXTENSION_NAME
fi

git clone https://github.com/wikimedia/mediawiki-extensions-$EXTNAME_CC.git $MEDIAWIKI_ROOT_FOLDER/w/extensions/$EXTNAME_CC

if ! grep -c "wfLoadExtension( '$EXTNAME_CC' );" $MEDIAWIKI_ROOT_FOLDER/w/LocalSettings.php; then
    echo "wfLoadExtension( '$EXTNAME_CC' );">> $MEDIAWIKI_ROOT_FOLDER/w/LocalSettings.php
fi

sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
    "cd w && php maintenance/update.php"