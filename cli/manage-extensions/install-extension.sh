#!/bin/bash
runInContainerOnly=true

# FIXME: handle multiple system setups
source ./envs/my-new-system.env
source ./cli/manage-extensions/utils.sh
source ./cli/lib/utils.sh
source ./cli/lib/permissions.sh

getExtensionName

git clone https://github.com/wikimedia/mediawiki-extensions-$EXTNAME_CC.git $MEDIAWIKI_ROOT/w/extensions/$EXTNAME_CC

if ! grep -c "wfLoadExtension( '$EXTNAME_CC' );" $MEDIAWIKI_ROOT/w/LocalSettings.php; then
    echo "wfLoadExtension( '$EXTNAME_CC' );">> $MEDIAWIKI_ROOT/w/LocalSettings.php
fi

runMWUpdatePHP