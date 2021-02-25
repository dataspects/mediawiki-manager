<?php

class System {

    function __construct() {
        $this->newVersionURL = "https://www.dropbox.com/s/zncf0q288um5gic/mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz";
        $this->newVersion = "mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz";
    }

    public function upgradeNow() {
        $output = $this->downloadNew();
        $output = $this->backupExistingW();
        $output = $this->extractNew();
        $output = $this->copyCustomFiles();
        exec("cd /var/www/html/w && php maintenance/update.php --quick", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return "Upgraded to ".$this->newVersion;
    }

    private function downloadNew() {
        exec("wget -c --output-document ../".$this->newVersion." ".$this->newVersionURL, $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $output;
    }

    private function backupExistingW() {
        exec("mkdir --parents ../existing_version", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        exec("mv ../w/* ../existing_version", $output, $retval);
        if ($retval <> 0) {
            return $output;
        }
        return "Done";
    }

    private function extractNew() {
        exec("tar -xzf ../".$this->newVersion." -C ../w", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return "Done";
    }

    private function copyCustomFiles() {
        $customFiles = array(
            "../existing_version/LocalSettings.php",
            "../existing_version/AfterSettings.php",
            "../existing_version/images"
        );
        exec("cp -r ".join($customFiles, " ")." ../w/", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        exec("chown -R www-data ../w/images", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $output;
    }

}