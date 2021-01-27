# mediawiki-canasta
## Install

1. `user@server:~$ git clone https://github.com/dataspects/mediawiki-canasta.git`
2. `user@server:~$ cd mediawiki-canasta`
3. `user@server:~/mediawiki-canasta$`
4. Download MediaWiki Canasta archives into `~/mediawiki-canasta`:
    * `user@server:~/mediawiki-canasta$ wget -c https://www.dropbox.com/s/p5r2qsar1q0u4i3/mediawiki-root-w-folder-1.35.0-3.2.1.tar.gz`
    * `user@server:~/mediawiki-canasta$ wget -c https://www.dropbox.com/s/zncf0q288um5gic/mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz`
    * ...
5. Configure `~/mediawiki-canasta/CanastaInstanceSettings.env`
    * CANASTA_INSTANCE_ROOT to the mediawiki-canasta directory (e.g. `/home/ubuntu/mediawiki-canasta`)
    * CANASTA_INSTANCE_ROOT_OWNER to the correct user (e.g. `ubuntu`)
    * MARIADB_ROOT_PASSWORD a new root password if required
    * WG_DB_PASSWORD to a new db password if required
6. `user@server:~/mediawiki-canasta$ ./install-canasta-version.sh`

## View
1. The wiki is now accessible on localhost
2. Install lynx to view the wiki from the command line

## Operate

*Note: MediaWiki Canasta runs on an Apache/PHP setup based on this [Dockerfile](https://github.com/dataspects/dataspectsSystemBuilder/blob/master/docker-images/php-apache/Dockerfile).*

**START the MediaWiki Canasta instance**

`user@server:~/mediawiki-canasta$ sudo docker-compose --env-file ./CanastaInstanceSettings.env up -d`

**STOP the MediaWiki Canasta instance**

`user@server:~/mediawiki-canasta$ sudo docker-compose --env-file ./CanastaInstanceSettings.env down`

## Switch (Upgrade)

1. Edit `~/mediawiki-canasta/switch-canasta-version.sh`:
    * NEW_CANASTA_ARCHIVE=`mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz`
2. `user@server:~/mediawiki-canasta$ ./switch-canasta-version.sh`

## Backup/Restore

Under construction
