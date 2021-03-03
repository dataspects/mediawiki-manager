#!/bin/bash

source ./CanastaInstanceSettings.env

###########
# GENERAL #
###########

mkdir --parents $MEDIAWIKI_ROOT_FOLDER/w
echo "Initialized log">> $MEDIAWIKI_ROOT_FOLDER/dsmwm.log
sudo chgrp www-data $MEDIAWIKI_ROOT_FOLDER/dsmwm.log
sudo chmod 777 $MEDIAWIKI_ROOT_FOLDER/dsmwm.log

############
# RESTIC 1 #
############

cp conf/restic_password $MEDIAWIKI_ROOT_FOLDER/

#############
# MEDIAWIKI #
#############

echo "Extract..."
tar -xzf $CANASTA_INSTANCE_ROOT/$CURRENT_CANASTA_ARCHIVE -C $MEDIAWIKI_ROOT_FOLDER/w
sleep 1

echo "Ensure permissions..."
sudo chown -R $CANASTA_INSTANCE_ROOT_OWNER:www-data $MEDIAWIKI_ROOT_FOLDER
sudo chmod -R 770 $MEDIAWIKI_ROOT_FOLDER
sleep 1

echo "Set domain name..."
echo "\$wgServer = 'https://$CANASTA_DOMAIN_NAME';">> mediawiki_root/w/LocalSettings.php
sleep 1

echo "Set database password..."
echo "\$wgDBpassword = '$WG_DB_PASSWORD';">> mediawiki_root/w/LocalSettings.php
sleep 1

echo "Set database server..."
echo "\$wgDBserver = '$MYSQL_HOST';">> mediawiki_root/w/LocalSettings.php
sleep 1

echo "Run docker-compose..."
sudo -S docker-compose --env-file ./CanastaInstanceSettings.env down \
  && sudo -S docker-compose --env-file ./CanastaInstanceSettings.env up -d \
  && sudo -S chown -R $CANASTA_INSTANCE_ROOT_OWNER:www-data mediawiki_root
sleep 1

# FIXME: Wait for MariaDB to be ready...
sleep 10

echo "Create database and user..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$WG_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;\""
sleep 1

echo "Import database..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  mediawiki < /var/www/html/w/db.sql"
sleep 1

echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php --quick'

echo "Inject contents..."
source ./inject-local-WikiPageContents.sh
source ./inject-manage-page-from-mediawiki.org.sh

############
# RESTIC 2 #
############

echo "Initialize restic backup repository"
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "restic --password-file restic_password --verbose init --repo /var/www/html/restic-repo"

echo "Ensure permissions..."
sudo chown -R $CANASTA_INSTANCE_ROOT_OWNER:www-data restic_data
sudo chmod -R 770 restic_data
sleep 1

###########
# MWM API #
###########

echo "Install mwm API"
cp -r mwmapi/* $MEDIAWIKI_ROOT_FOLDER/api/

##########
# MWM UI #
##########

echo "Install mwm UI"
cp -r mwmui/* $MEDIAWIKI_ROOT_FOLDER/ui/

######################
# GIT CLONE LOCATION #
######################

echo "Install clone location"
sudo chgrp www-data $MEDIAWIKI_ROOT_FOLDER/cloneLocation/
sudo chmod 777 $MEDIAWIKI_ROOT_FOLDER/cloneLocation/


