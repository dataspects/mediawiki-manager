#!/bin/bash

# Consider moving to Dockerfile https://cweiske.de/tagebuch/docker-mysql-available.htm

maxcounter=45
counter=1

echo "Waiting for MariaDB..."

while ! podman exec $APACHE_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD -e \"show databases;\"" > /dev/null 2>&1; do
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        >&2 echo "We have been waiting for MySQL too long already; failing."
        exit 1
    fi;
    echo "...still waiting..."
done

echo "Ready: MariaDB"