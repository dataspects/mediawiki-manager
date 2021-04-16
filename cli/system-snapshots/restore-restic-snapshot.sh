#!/bin/bash

source ./envs/my-new-system.env

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

SNAPSHOT_ID=$1

######
# STEP 1: Restore
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
    "restic \
        --password-file /var/www/restic_password \
        --repo /var/www/html/snapshots \
            restore $SNAPSHOT_ID \
                --target ./currentresources"

######
# STEP 2: Copy folders and files
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  " 
    cp ./currentresources/var/www/html/currentresources/composer.json /var/www/html/w/composer.json; \
    cp ./currentresources/var/www/html/currentresources/mwmconfigdb.sqlite /var/www/html/mwmconfigdb.sqlite; \
    rm -rf /var/www/html/w/extensions/*;
    cp -r --preserve=links ./currentresources/var/www/html/currentresources/extensions/* /var/www/html/w/extensions/; \
    rm -rf /var/www/html/w/skins/*;
    cp -r --preserve=links ./currentresources/var/www/html/currentresources/skins/* /var/www/html/w/skins/; \
    rm -rf /var/www/html/w/images/*;
    cp -r --preserve=links ./currentresources/var/www/html/currentresources/images/* /var/www/html/w/images/; \
    rm -rf /var/www/html/w/vendor/*;
    cp -r --preserve=links ./currentresources/var/www/html/currentresources/vendor/* /var/www/html/w/vendor/; \
    rm -rf /etc/apache2/sites-available/*;
    cp -r --preserve=links ./currentresources/var/www/html/currentresources/sites-available/* /etc/apache2/sites-available/;
  "

podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  $DATABASE_NAME < ./currentresources/var/www/html/currentresources/db.sql"