# MWStake MediaWiki Manager (MWM)

This repository represents the development workbench for [MWStake MediaWiki Manager](https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager).

***It is not meant to be used in production (yet)!***

## System Requirements

* **Ubuntu 20.04**
* *Other Linux distros pending*
* *Windows pending*
* *Mac pending*

The installer will take care of everything else.

## Installation

1. `user@server:~$ git clone https://github.com/dataspects/mediawiki-manager.git`
2. `user@server:~$ cd mediawiki-manager`
3. Configure $ENV
4. `user@server:~/mediawiki-manager$ ENVmwman=my-system.env ENVmwcli=../mediawiki-cli/my-system.env ./install-system/install-system-Ubuntu-20.04.sh`

## Features

The current set and state of features can be discovered at `./report-cli-public-commands.sh`.

## Development

1. Run ./initdev.sh on development machine (dm).
2. cd mediawiki-cli
3. ./report-status.sh
4. If dm=dataspectsSystemBuilder, visit https://localhost:4443