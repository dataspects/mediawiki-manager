#!/bin/bash

# Configure ########################

SYSTEM_ROOT_FOLDER=/home/lex/mediawiki-canasta # No trailing / !
SYSTEM_ROOT_FOLDER_OWNER=lex

####################################

MEDIAWIKI_CANASTA_ARCHIVE=mediawiki-root-w-folder-1.35.0-3.2.1.tar.gz
MEDIAWIKI_ROOT_FOLDER=$SYSTEM_ROOT_FOLDER/mediawiki_root

APACHE_CONTAINER_NAME=mediawiki_canasta
MYSQL_HOST=127.0.0.1
DATABASE_NAME=mediawiki
MYSQL_USER=mediawiki
MYSQL_USER_PASSWORD=mediawikipass
MYSQL_ROOT_PASSWORD=mysqlpassword

requiredFiles=( "docker-compose.yml" "$MEDIAWIKI_CANASTA_ARCHIVE" )
for file in "${requiredFiles[@]}"
do
  if [ ! -e "$file" ]; then
    echo "$file is missing!"
    exit 1
  fi
done

echo "Run docker-compose..."
sudo -S docker-compose down \
  && sudo -S docker-compose up -d \
  && sudo -S chown -R $SYSTEM_ROOT_FOLDER_OWNER:www-data mediawiki_root
sleep 5
echo "Extract..."
mkdir --parents $MEDIAWIKI_ROOT_FOLDER/w
tar -xzf $SYSTEM_ROOT_FOLDER/$MEDIAWIKI_CANASTA_ARCHIVE -C $MEDIAWIKI_ROOT_FOLDER/w
sleep 5
echo "Ensure permissions..."
sudo chown -R www-data $MEDIAWIKI_ROOT_FOLDER/w/images
sleep 5
echo "Create database and user..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'$MYSQL_HOST' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'$MYSQL_HOST'; \""
echo "Import database..."
sudo -S docker exec $APACHE_CONTAINER_NAME bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD \
  mediawiki < /var/www/html/w/db.sql"
echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php'

echo "http://localhost:80"