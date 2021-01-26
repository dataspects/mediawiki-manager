# mediawiki-canasta
## Install

1. `user@server:~$ git clone https://github.com/dataspects/mediawiki-canasta.git`
2. `user@server:~$ cd mediawiki-canasta`
3. `user@server:~/mediawiki-canasta$`
4. Download MediaWiki Canasta archives into `~/mediawiki-canasta`:
    * https://www.dropbox.com/s/zncf0q288um5gic/mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz
    * https://www.dropbox.com/s/p5r2qsar1q0u4i3/mediawiki-root-w-folder-1.35.0-3.2.1.tar.gz
    * ...
5. Configure `~/mediawiki-canasta/CanastaInstanceSettings.env`
6. `user@server:~/mediawiki-canasta$ ./install-canasta-version.sh`

## Operate

**START the MediaWiki Canasta instance**

`user@server:~/mediawiki-canasta$ sudo docker-compose --env-file ./CanastaInstanceSettings.env up -d`

**STOP the MediaWiki Canasta instance**

`user@server:~/mediawiki-canasta$ sudo docker-compose --env-file ./CanastaInstanceSettings.env down`

## Switch (Upgrade)

1. Edit `~/mediawiki-canasta/CanastaInstanceSettings.env`:
    * CURRENT_CANASTA_ARCHIVE=`mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz`
2. `user@server:~/mediawiki-canasta$ ./switch-canasta-version.sh`