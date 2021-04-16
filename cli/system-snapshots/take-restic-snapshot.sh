#!/bin/bash

source ./envs/my-new-system.env

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

CONTAINER_INTERNAL_PATH_TO_SNAPSHOT=/var/www/html/currentresources

######
# STEP 1: Dump content database
printf "MWM snapshot: Trying to mysqldump mediawiki...\n"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  $DATABASE_NAME > $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT/db.sql"
printf "MWM snapshot: mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
printf "MWM snapshot: Trying to copy folders and files...\n"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "cp -r \
    /var/www/html/w/composer.json \
    /var/www/html/w/extensions \
    /var/www/html/w/skins \
    /var/www/html/w/images \
    /var/www/html/w/vendor \
    /var/www/html/mwmconfigdb.sqlite \
    /etc/apache2/sites-available \
    $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT
  "
printf "MWM snapshot: mysqldump mediawiki completed.\n"

######
# STEP 3: Run restic backup
printf "MWM snapshot: Trying to run restic backup...\n"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "restic \
    --password-file /var/www/restic_password \
    --repo /var/www/html/snapshots \
      backup $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT"
printf "MWM snapshot: Completed running restic backup.\n"