# mediawiki-manager

This repository represents the development workbench for [MWStake MediaWiki Manager](https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager).

***It is not meant to be used in production (yet)!***

![DSMWM screenshot](images/mwmscreenshot.png)
![DSMWM screenshot](images/mwstakeextensionstore.png)

## Install

1. `user@server:~$ git clone https://github.com/dataspects/mediawiki-manager.git`
2. `user@server:~$ cd mediawiki-manager`
3. Configure `~/mediawiki-manager/envs/my-new-system.env`
4. `user@server:~/mediawiki-manager$ ./cli/install-system/install-system.sh`

## View
1. The wiki is now accessible on localhost
2. Install lynx to view the wiki from the command line

## Operate

*Note: MediaWiki Manager uses a Apache/PHP setup based on this [Dockerfile](https://github.com/dataspects/dataspectsSystemBuilder/blob/master/docker-images/mediawiki/Dockerfile).*

`user@server:~/mediawiki-manager$ sudo docker-compose --env-file ./envs/my-new-system.env up -d`

## Manage system

See shell scripts under `mediawiki-manager/cli/manage-system`.

<!-- ### Extensions

...

### Content

* `mediawiki-manager/cli/inject-local-WikiPageContents`: inject content from `WikiPageContents/`
* `mediawiki-manager/cli/inject-ontology-WikiPageContents.sh`: inject content from ontology repositories, e.g. https://github.com/dataspects/dataspectsSystemCoreOntology


## Switch (Upgrade)

...

### Check what has changed

![Check MW config diffs](images/check-mw-config-diffs.png)

## Snapshooting (Backup/Restore)

MediaWiki Canasta uses https://restic.net.

The installer creates a restic repository at `~/mediawiki-manager/$RESTIC_REPOSITORY` protected by `$RESTIC_PASSWORD`.

**TAKE snapshot**

Currently this snapshoots `$MEDIAWIKI_ROOT` into `~/mediawiki-manager/$RESTIC_REPOSITORY`.

`user@server:~/mediawiki-manager$ ./take-restic-snapshot.sh`

**VIEW snapshots**

`user@server:~/mediawiki-manager$ ./view-restic-snapshots.sh`

**RESTORE snapshot**

`user@server:~/mediawiki-manager$ ./restore-restic-snapshot.sh`

Currently this restores the latest snapshot into `~/mediawiki-manager/$RESTIC_RESTORE_FOLDER`.

## MWM Factory

* See https://github.com/dataspects/mwmui.
* Docker images are built by https://github.com/dataspects/dataspectsSystemBuilder.
### Develop MWM UI

1. `user@workstation:~/mwmui$ gatsby develop -H 0.0.0.0`
2. `user@workstation:~/mediawiki-manager$ cp mwmapi/* mediawiki_root/api/` for all changes in `mwmapi/`

### Locally test production MWM UI

* `user@workstation:~/mwmui$ gatsby build --prefix-paths && cp -r public/* ../mediawiki-manager/mediawiki_root/ui`

### Deploy production MWM UI

1. `user@workstation:~/mwmui$ gatsby build --prefix-paths && cp -r public/* ../mediawiki-manager/mwmui`
2. `user@workstation:~/mediawiki-manager$ # git commit ...`

## TODOs

* Handle trailing slashes present or not -->