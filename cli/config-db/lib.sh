#!/bin/bash

mwmLocalSettings="mwmLocalSettings.php"

initializeSQLiteDB() {
    DB=mwmconfigdb.sqlite
    sqlite3 $DB "CREATE TABLE IF NOT EXISTS extensions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name text,
        localsettingsdirectives text
    );"
    writeToSystemLog "$DB initialized"
}

initializeMWMLocalSettings() {
    podman exec $APACHE_CONTAINER_NAME /bin/bash -c "touch $mwmLocalSettings"
    writeToSystemLog "$DB initialized"
}

compileMWMLocalSettings() {
    podman exec $APACHE_CONTAINER_NAME /bin/bash -c "php ./cli/lib/updateMWMLocalSettings.php"
    writeToSystemLog "Recompiled $mwmLocalSettings"
}