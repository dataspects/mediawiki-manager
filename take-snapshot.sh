#!/bin/bash

source ./CanastaInstanceSettings.env

MEDIAWIKI_ROOT_FOLDER=$CANASTA_INSTANCE_ROOT/mediawiki_root

APACHE_CONTAINER_NAME=mediawiki_canasta
MYSQL_HOST=127.0.0.1
DATABASE_NAME=mediawiki
MYSQL_USER=mediawiki

######
# STEP 1: Dump database
printf "MediaWiki Canasta snapshot: Trying to mysqldump mediawiki...\n"
sudo docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  $DATABASE_NAME > /var/www/html/w/db.sql"
printf "MediaWiki Canasta snapshot: mysqldump mediawiki completed.\n"

######
# STEP 2: Run restic backup
printf "MediaWiki Canasta snapshot: Trying to run restic backup...\n"
sudo docker run \
    --env-file ./CanastaInstanceSettings.env \
    restic/restic \
    -r restic-backup-repository \
    --verbose backup $MEDIAWIKI_ROOT_FOLDER/w/
printf "MediaWiki Canasta snapshot: Completed running restic backup.\n"