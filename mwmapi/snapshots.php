<?php

class Snapshots {

    function __construct() {
        
    }

    public function snapshotCatalogue() {
        exec("restic --repo /var/www/html/restic-repo snapshots", $output, $retval);
        return $output;
    }

    public function takeSnapshot() {
        // FIXME!
        exec("restic --repo /var/www/html/restic-repo backup /var/www/html/w", $output, $retval);
        exec("sudo chown -R lex:www-data /var/www/html/restic-repo && sudo chmod -R 770 /var/www/html/restic-repo", $output1, $retval1);
        return $output;
    }

}