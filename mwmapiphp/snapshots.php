<?php

class Snapshots {

    function __construct($logger) {
        $this->logger = $logger;
        $this->mysqlHost = "mysql";
        $this->databaseName = "mediawiki";
        $this->mysqlUser = "mediawiki";
        $this->mysqlPassword = "wgdbpassword";
        $this->mysqlDumpFileName = "backup.sql";
    }

    public function snapshotCatalogue() {
        exec("restic --repo /var/www/html/snapshots snapshots", $output, $retval);
        return $output;
    }

    public function takeSnapshot() {
        $this->mysqldump();
        // FIXME!
        $this->logger->write("Taking snapshot...");
        exec("restic --repo /var/www/html/snapshots backup $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w", $output, $retval);
        // exec("chgrp -R www-data /var/www/html/snapshots && chmod -R 770 /var/www/html/snapshots", $output, $retval);
        return $this->logger->write("Snapshot taken...");;
    }

    private function mysqldump() {
        exec("mysqldump -h ".escapeshellarg($this->mysqlHost)." -u ".escapeshellarg($this->mysqlUser)." -p".escapeshellarg($this->mysqlPassword)." ".escapeshellarg($this->databaseName)." > $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/".escapeshellarg($this->mysqlDumpFileName), $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $output;
    }
}