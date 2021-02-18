#!/bin/bash

source ./CanastaInstanceSettings.env

####################################

requiredFiles=( "docker-compose.yml" "$CURRENT_CANASTA_ARCHIVE" )
for file in "${requiredFiles[@]}"
do
  if [ ! -e "$file" ]; then
    echo "$file is missing!"
    exit 1
  fi
done

echo "Run docker-compose..."
sudo -S docker-compose --env-file ./CanastaInstanceSettings.env down \
  && sudo -S docker-compose --env-file ./CanastaInstanceSettings.env up -d \
  && sudo -S chown -R $CANASTA_INSTANCE_ROOT_OWNER:www-data mediawiki_root
sleep 1

echo "Extract..."
mkdir --parents $MEDIAWIKI_ROOT_FOLDER/w
tar -xzf $CANASTA_INSTANCE_ROOT/$CURRENT_CANASTA_ARCHIVE -C $MEDIAWIKI_ROOT_FOLDER/w
sleep 1

echo "Ensure permissions..."
sudo chown -R www-data $MEDIAWIKI_ROOT_FOLDER/w/images
sleep 1

echo "Set domain name..."
sed -i "s/^\$wgServer.*;/\$wgServer = 'https:\/\/$CANASTA_DOMAIN_NAME';/g" mediawiki_root/w/LocalSettings.php
sleep 1

echo "Set database password..."
sed -i "s/^\$wgDBpassword.*;/\$wgDBpassword = '$WG_DB_PASSWORD';/g" mediawiki_root/w/LocalSettings.php
sleep 1

echo "Set database server..."
sed -i "s/^\$wgDBserver.*;/\$wgDBserver = '$MYSQL_HOST';/g" mediawiki_root/w/LocalSettings.php
sleep 1

# FIXME: Wait for MariaDB to be ready...

echo "Create database and user..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$WG_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%'; \""
sleep 1

echo "Import database..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  mediawiki < /var/www/html/w/db.sql"
sleep 1

echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php'

echo "Create restic backup repository"
sudo docker pull restic/restic
sudo docker run \
  --env-file ./CanastaInstanceSettings.env \
  --volume $CANASTA_INSTANCE_ROOT/$RESTIC_REPOSITORY:/$RESTIC_REPOSITORY \
  restic/restic \
  --verbose init

sudo docker run \
  --env-file ./CanastaInstanceSettings.env \
  --volume $CANASTA_INSTANCE_ROOT/$RESTIC_REPOSITORY:/$RESTIC_REPOSITORY \
  restic/restic \
  --verbose snapshots

echo "Copy manage.php"
cp manage.php $MEDIAWIKI_ROOT_FOLDER/w/

echo "Inject contents..."
source ./inject-local-WikiPageContents.sh
source ./inject-manage-page-from-mediawiki.org.sh