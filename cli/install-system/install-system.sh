#!/bin/bash

# TODO: foreach systems
source ./envs/my-new-system.env

##################
# SOURCE CLI LIB #
##################

source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

##############
# INITIALIZE #
##############

initializeSystemLog

################################
# DOWNLOAD SYSTEM CORE ARCHIVE #
################################

# TODO: handle already downloaded
# wget -c $SYSTEM_CORE_ARCHIVE
writeToSystemLog "Downloaded: $SYSTEM_CORE_ARCHIVE"

###########
# GENERAL #
###########

# Initialize MediaWiki script path
mkdir --parents $MEDIAWIKI_ROOT/w
writeToSystemLog "Initialized: $MEDIAWIKI_ROOT"

#############
# MEDIAWIKI #
#############

echo "Extracting $SYSTEM_CORE_ARCHIVE..."
tar -xzf $(basename $SYSTEM_INSTANCE_ROOT/$SYSTEM_CORE_ARCHIVE) -C $MEDIAWIKI_ROOT/w
writeToSystemLog "Extracted: $SYSTEM_CORE_ARCHIVE"
sleep 1

setPermissionsOnSystemInstanceRoot

echo "Set domain name..."
addToLocalSettings "\$wgServer = 'https://$SYSTEM_DOMAIN_NAME';"

echo "Configure database access..."
addToLocalSettings "\$wgDBpassword = '$WG_DB_PASSWORD';"
addToLocalSettings "\$wgDBserver = '$MYSQL_HOST';"

echo "Run docker-compose..."
./cli/manage-system/stop.sh
./cli/manage-system/start.sh
writeToSystemLog "Ran docker-compose..."

setPermissionsOnSystemInstanceRoot

source ./cli/lib/waitForMariaDB.sh
exit

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
sudo chown -R $SYSTEM_INSTANCE_ROOT_OWNER:www-data restic_data
sudo chmod -R 770 restic_data
sleep 1

###########
# MWM API #
###########

echo "Install mwm API"
cp -r mwmapi/* $MEDIAWIKI_ROOT/api/

##########
# MWM UI #
##########

echo "Install mwm UI"
cp -r mwmui/* $MEDIAWIKI_ROOT/ui/

######################
# GIT CLONE LOCATION #
######################

echo "Install clone location"
sudo chgrp www-data $MEDIAWIKI_ROOT/cloneLocation/
sudo chmod 777 $MEDIAWIKI_ROOT/cloneLocation/

setPermissionsOnSystemInstanceRoot