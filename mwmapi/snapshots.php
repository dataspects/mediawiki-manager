<?php

class Snapshots {

    function __construct() {
        $this->mysqlHost = "mysql";
        $this->databaseName = "mediawiki";
        $this->mysqlUser = "mediawiki";
        $this->mysqlPassword = "wgdbpassword";
        $this->mysqlDumpFileName = "backup.sql";
    }

    public function snapshotCatalogue() {
        exec("restic --repo /var/www/html/restic-repo snapshots", $output, $retval);
        return $output;
    }

    public function takeSnapshot() {
        $output1 = $this->mysqldump();
        // FIXME!
        exec("restic --repo /var/www/html/restic-repo backup /var/www/html/w", $output, $retval);
        exec("chgrp -R www-data /var/www/html/restic-repo && chmod -R 770 /var/www/html/restic-repo", $output, $retval);
        return $output1;
    }

    private function mysqldump() {
        exec("mysqldump -h ".$this->mysqlHost." -u ".$this->mysqlUser." -p".$this->mysqlPassword." ".$this->databaseName." > /var/www/html/w/".$this->mysqlDumpFileName, $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $output;
    }
}