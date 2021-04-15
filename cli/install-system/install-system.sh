#!/bin/bash
source ./envs/my-new-system.env
source ./cli/config-db/lib.sh
source ./cli/logging/lib.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

source ./cli/check-and-complete-environment.sh
initializeSystemLog
initializeSQLiteDB

mkdir --parent \
  mediawiki_root/w/images \
  mediawiki_root/w/LocalSettingsPHPBACKUP \
  mediawiki_root/mwmSQLiteBACKUP \
  restic-backup-repository \
  cloneLocation \
  mariadb_data
writeToSystemLog "Initialized hostPath folders"

### >>>
# MWM Concept: initialize persistent mediawiki service volumes
source ./cli/install-system/initialize-persistent-mediawiki-service-volumes.sh
# <<<

touch $MEDIAWIKI_ROOT/mwmLocalSettings.php
envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
podman play kube mediawiki-manager.yml

setPermissionsOnSystemInstanceRoot

initializeMWMLocalSettings

podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
"php ./cli/lib/addToMWMSQLite.php \"ls\" \"
\\\$wgServer = 'https://$SYSTEM_DOMAIN_NAME:4443';
\\\$wgDBpassword = '$WG_DB_PASSWORD';
\\\$wgDBserver = '$MYSQL_HOST';
\""

compileMWMLocalSettings

setPermissionsOnSystemInstanceRoot

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