#!/bin/bash
source ./envs/my-new-system.env
source ./cli/lib/utils.sh

# FIXME: handle multiple system setups

initializeSQLiteDB

##################
# SOURCE CLI LIB #
##################

source ./cli/lib/permissions.sh

##############
# INITIALIZE #
##############

initializeSystemLog

###########
# GENERAL #
###########

ensurePodmanIsInstalled

mkdir --parent \
  mediawiki_root/w/images \
  mediawiki_root/w/LocalSettingsPHPBACKUP \
  restic-backup-repository \
  cloneLocation \
  mariadb_data
echo "SUCCESS: Initialized host folders"

### >>>
# MWM Concept: initialize persistent mediawiki service volumes
source ./cli/install-system/initialize-persistent-mediawiki-service-volumes.sh
# <<<


envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
podman play kube mediawiki-manager.yml
podman container stop $MWCsafemode

setPermissionsOnSystemInstanceRoot

#############
# MEDIAWIKI #
#############
echo "Initialize mwmLocalSettings.php..."
mwmls="mwmLocalSettings.php"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "touch $mwmls && source ./cli/lib/utils.sh && addToLocalSettings '\$mwmls = \"../$mwmls\"; if(file_exists(\$mwmls)) {require_once(\$mwmls); } else { echo \"ERROR: MWM include not loaded.\"; }'"

echo "Set domain name..."
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "source ./cli/lib/utils.sh && addToLocalSettings '\$wgServer = \"https://$SYSTEM_DOMAIN_NAME:4443\";'"

echo "Configure database access..."
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "source ./cli/lib/utils.sh && addToLocalSettings '\$wgDBpassword = \"$WG_DB_PASSWORD\";'"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "source ./cli/lib/utils.sh && addToLocalSettings '\$wgDBserver = \"$MYSQL_HOST\";'"

podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "source ./cli/lib/utils.sh && removeFromLocalSettings \"/\$wgSiteNotice = ['|\\\"]================ MWM Safe Mode ================['|\\\"];/d\""
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "source ./cli/lib/utils.sh && removeFromLocalSettings \"/\$wgReadOnly = true;/d\""  

# setPermissionsOnSystemInstanceRoot

source ./cli/lib/waitForMariaDB.sh

echo "Create database and user..."
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$WG_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;\""

echo "Import database..."
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  mediawiki < /var/www/html/w/db.sql"

runMWUpdatePHP

###############################
# Done installing core system #
###############################

echo "Inject contents..."
source ./cli/manage-content/inject-local-WikiPageContents.sh
source ./cli/manage-content/inject-manage-page-from-mediawiki.org.sh

##########
# RESTIC #
##########

echo "Initialize restic backup repository"
podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "restic --password-file /var/www/restic_password --verbose init --repo /var/www/html/restic-repo"

### >>>
# MWM Concept: take initial snapshot and view snapshots
source ./cli/system-snapshots/take-restic-snapshot.sh
source ./cli/system-snapshots/view-restic-snapshots.sh
# <<<

# setPermissionsOnSystemInstanceRoot