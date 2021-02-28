<?php

class Extension {

    function __construct($name, $extensionCatalogue, $generalSiteInfo, $logger) {
        $this->configFile = "".$this->configFile."";
        $this->name = $name;
        $this->generalSiteInfo = $generalSiteInfo;
        $this->extensionCatalogue = $extensionCatalogue;        
        $this->ep = $this->getExtensionProfileByName();
        $this->logger = $logger;
    }

    private function getExtensionProfileByName() {
        foreach($this->extensionCatalogue->extensionCatalogue($this->generalSiteInfo) as $extensionProfile) {
            if($extensionProfile["name"] == $this->name) {
                return $extensionProfile;
            }
        }
    }

    public function enable() {
        $this->logger->write("Trying to enable ".$this->ep["name"]."...");
        if(array_key_exists("composer", $this->ep["installation-aspects"])) {
            // By composer
            exec("cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar require ".$this->ep["installation-aspects"]["composer"], $output, $retval);
        } elseif(array_key_exists("repository", $this->ep["installation-aspects"])) {
            // From repository
            $this->logger->write("Trying to clone ".$this->ep["installation-aspects"]["repository"]."...");
            exec("git clone ".$this->ep["installation-aspects"]["repository"]." /var/www/html/w/extensions/".$this->name, $output1, $retval);
            $this->logger->write("Successfully cloned ".$this->ep["installation-aspects"]["repository"]);
            if($retval <> 0) {
                // TBD: If we reenable, should we check for updates?
            }
        }
        // ".$this->configFile." directives?
        if(array_key_exists("localsettings", $this->ep["installation-aspects"])) {
            foreach($this->ep["installation-aspects"]["localsettings"] as $ls) {
                // Try to uncomment
                exec("sed -i \"s/^#".$ls."/".$ls."/g\" /var/www/html/w/".$this->configFile."", $output, $retval);
                // Check if line is present
                exec("grep -c \"".$ls."\" /var/www/html/w/".$this->configFile."", $output, $retval);
                if($output[0] == 0) {
                    // Add line if necessary
                    exec("echo \"".$ls."\">> /var/www/html/w/".$this->configFile."", $output, $retval);
                }
                $this->logger->write("Ensured existence of line \"$ls\" in ".$this->configFile);
            }
        }
        $this->runMaintenanceUpdatePHP();
        return $this->logger->write("Extension ".$this->name." enabled...");
    }

    private function runMaintenanceUpdatePHP() {
        exec("cd /var/www/html/w && php maintenance/update.php --quick", $output, $retval);
        $this->logger->write("Ran maintenance/update.php");
    }

    public function disable() {
        if(array_key_exists("composer", $this->ep)) {
            // By composer
            exec("cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar remove --no-update ".$this->ep["composer"], $output, $retval);
        } elseif(array_key_exists("repository", $this->ep)) {
            // TBD: Remove extensions/repository?
        }
        // ".$this->configFile." directives?
        if(array_key_exists("localsettings", $this->ep)) {
            foreach($this->ep["localsettings"] as $ls) {
                exec("sed -i \"s/^".$ls."/#".$ls."/g\" /var/www/html/w/".$this->configFile."", $output, $retval);
            }
        }
        $this->runMaintenanceUpdatePHP();
        return $this->logger->write("Extension ".$this->name." disabled...");
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");