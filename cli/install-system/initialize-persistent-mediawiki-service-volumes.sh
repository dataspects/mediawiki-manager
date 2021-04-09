#!/bin/bash

# This script is used in the context of https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager#ALcontainerization:_Docker
MWM_MEDIAWIKI_CONTAINER_ID=$(podman run \
  --restart=no \
  --detach \
  --rm=true \
  --name=mediawiki \
  docker.io/dataspects/mediawiki:1.35.0-2103211629)

declare -a vols=(
  "/var/www/html/w/LocalSettings.php"
  "/var/www/html/w/extensions"
  "/var/www/html/w/skins"
  "/var/www/html/w/vendor"
  "/var/www/html/w/composer.json"
  "/var/www/html/w/images"
)
for vol in "${vols[@]}"
do
  podman cp $MWM_MEDIAWIKI_CONTAINER_ID:$vol $MEDIAWIKI_ROOT/w
done
podman stop $MWM_MEDIAWIKI_CONTAINER_ID

# FIXME
sudo chmod -R 777 $MEDIAWIKI_ROOT/w

echo "Initialized persistent mediawiki service volumes"

# Error: error copying "/home/dserver/.local/share/containers/storage/overlay/ead5bfe664051c7acb19766503d4a7486469612dcf1df96588e1a765dcb4e56b/merged/var/www/html/w/vendor"
# to "/home/dserver/mediawiki-manager/mediawiki_root/w":
# Error processing tar file(exit status 1):
# symlink ../doctrine/dbal/bin/doctrine-dbal /bin/doctrine-dbal: operation not permitted