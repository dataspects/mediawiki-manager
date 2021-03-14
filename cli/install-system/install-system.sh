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

###########
# GENERAL #
###########

# Initialize MediaWiki script path
mkdir --parents $MEDIAWIKI_ROOT/w
writeToSystemLog "Initialized: $MEDIAWIKI_ROOT"

##########
# DOCKER #
##########

MWM_MEDIAWIKI_CONTAINER_ID=$(sudo docker run \
  --detach \
  dataspects/mediawiki:1.35.0-2103040820)
declare -a vols=(
  "var/www/html/w/LocalSettings.php"
  "var/www/html/w/extensions"
  "var/www/html/w/skins"
  "var/www/html/w/vendor"
)
for vol in "${vols[@]}"
do
  sudo docker cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $MEDIAWIKI_ROOT/w
done
sudo docker stop $MWM_MEDIAWIKI_CONTAINER_ID
setPermissionsOnSystemInstanceRoot

##################
# DOCKER COMPOSE #
##################

echo "Run docker-compose..."
./cli/manage-system/stop.sh
./cli/manage-system/start.sh
writeToSystemLog "Ran docker-compose..."

#############
# MEDIAWIKI #
#############

echo "Set domain name..."
addToLocalSettings "\$wgServer = 'https://$SYSTEM_DOMAIN_NAME';"

echo "Configure database access..."
addToLocalSettings "\$wgDBpassword = '$WG_DB_PASSWORD';"
addToLocalSettings "\$wgDBserver = '$MYSQL_HOST';"



setPermissionsOnSystemInstanceRoot

source ./cli/lib/waitForMariaDB.sh

echo "Create database and user..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$WG_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;\""

echo "Import database..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  mediawiki < /var/www/html/w/db.sql"

echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php --quick'

###############################
# Done installing core system #
###############################

promptToContinue

echo "Inject contents..."
source ./cli/manage-content/inject-local-WikiPageContents.sh
source ./cli/manage-content/inject-manage-page-from-mediawiki.org.sh

##########
# RESTIC #
##########

echo "Initialize restic backup repository"
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "restic --password-file /var/www/restic_password --verbose init --repo /var/www/html/restic-repo"

##########
# MWM UI #
##########

echo "Install mwm UI"
cp -r ui/* $MEDIAWIKI_ROOT/ui/

setPermissionsOnSystemInstanceRoot