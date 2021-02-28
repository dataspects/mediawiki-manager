<?php

class System {

    function __construct($mediawiki, $logger) {
        $this->logger = $logger;
        $this->newVersionURL = "https://www.dropbox.com/s/zncf0q288um5gic/mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz";
        $this->newVersion = "mediawiki-root-w-folder-1.35.1-3.2.2.tar.gz";
        $this->mediawiki = $mediawiki;
    }

    public function upgradeNow() {
        $output = $this->downloadNew();
        $output = $this->backupExistingW();
        $output = $this->extractNew();
        $output = $this->copyCustomFiles();
        $this->mediawiki->runMaintenanceUpdatePHP();
        return $this->logger->write("Upgraded to ".$this->newVersion);
    }

    private function downloadNew() {
        $this->logger->write("Trying to wget ".$this->newVersionURL."...");
        exec("wget -c --output-document ../".$this->newVersion." ".$this->newVersionURL, $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        $this->logger->write("Successfully to wgot ;) ".$this->newVersionURL);
        return $output;
    }

    private function backupExistingW() {
        $this->logger->write("Backing up current version...");
        exec("mkdir --parents ../existing_version", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        exec("mv ../w/* ../existing_version", $output, $retval);
        if ($retval <> 0) {
            return $output;
        }
        return $this->logger->write("Successfully backed up current version");
    }

    private function extractNew() {
        $this->logger->write("Trying to extract ".$this->newVersion."...");
        exec("tar -xzf ../".$this->newVersion." -C ../w", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $this->logger->write("Successfully extracted ".$this->newVersion);
    }

    private function copyCustomFiles() {
        $customFiles = array(
            "../existing_version/LocalSettings.php",
            "../existing_version/AfterSettings.php",
            "../existing_version/images"
        );
        $this->logger->write("Trying to copy ".join($customFiles, " ")."...");
        exec("cp -r ".join($customFiles, " ")." ../w/", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        exec("chown -R www-data ../w/images", $output, $retval);
        if ($retval <> 0) {
            return $retval;
        }
        return $this->logger->write("Successfully copied ".join($customFiles, " "));
    }

}