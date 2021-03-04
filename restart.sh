#!/bin/bash

source ./CanastaInstanceSettings.env

./stop.sh
./start.sh

# FIXME: Wait for MariaDB to be ready...
sleep 10

echo "Update..."
sudo -S docker exec $APACHE_CONTAINER_NAME /bin/bash -c \
  'cd w; php maintenance/update.php --quick'