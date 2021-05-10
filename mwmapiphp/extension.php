<?php

class Extension {

    function __construct($name, $extensionCatalogue, $generalSiteInfo, $mediawiki, $logger) {
        # $name is user input!
        $this->unsafeName = $name;
        $this->extensionCatalogue = $extensionCatalogue;
        $this->generalSiteInfo = $generalSiteInfo;
        $this->mediawiki = $mediawiki;
        $this->logger = $logger;
        # FIXME: safe now?
        # FIXME: Ok not to escapeshellcmd as of now?
        $this->configFile = "$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/LocalSettings.php";
        $this->configFileBAK = "$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/LocalSettings.php.bak";
    }

    private function getExtensionProfileByName() {
        foreach($this->extensionCatalogue->extensionCatalogue($this->generalSiteInfo) as $extensionProfile) {
            if($extensionProfile["name"] == $this->unsafeName) {
                $this->name = $extensionProfile["name"];
                return $extensionProfile;
            }
        }
        return null;
    }

    public function enable() {
        $this->ep = $this->getExtensionProfileByName();
        if($this->ep == null) {
            return $this->logger->write("Extension ".$this->name." unknown");
        }
        $this->logger->write("Trying to enable ".$this->ep["name"]."...");
        if(array_key_exists("composer", $this->ep["installation-aspects"])) {
            // By composer
            exec("cd $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w && COMPOSER_HOME=$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w php composer.phar require ".$this->ep["installation-aspects"]["composer"], $output, $retval);
            if($retval <> 0) {
                $this->logger->write("Composer retval ".$retval."...");
            }
        } elseif(array_key_exists("repository", $this->ep["installation-aspects"])) {
            // From repository
            $this->logger->write("Trying to clone ".$this->ep["installation-aspects"]["repository"]."...");
            exec("git clone ".$this->ep["installation-aspects"]["repository"]." $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/extensions/".$this->name, $output, $retval);
            if($retval <> 0) {
                $this->logger->write($this->ep["installation-aspects"]["repository"]." already cloned");
            } else {
                $this->logger->write("Successfully cloned ".$this->ep["installation-aspects"]["repository"]);
            }
        } else {
            $this->logger->write("No useful installation aspects found for ".$this->ep["name"]);
        }
        // ".$this->configFile." directives?
        if(array_key_exists("localsettings", $this->ep["installation-aspects"])) {
            foreach($this->ep["installation-aspects"]["localsettings"] as $ls) {
                $this->logger->write("Checking ".$this->configFile." for line \"$ls\"...");
                // FIXME: Ok not to escapeshellcmd here?
                exec("grep \"^#".$ls."$\" ".$this->configFile, $output, $retval);
                if($retval == 0) {
                    // Uncomment line
                    $this->sedLocalSettings("s/^#".$ls."/".$ls."/g");
                } else {
                    // Add line
                    exec("echo \"".$ls."\">> ".$this->configFile, $output, $retval);
                }
                $this->logger->write("Ensured existence of line \"$ls\" in ".$this->configFile);
            }
        }
        $this->mediawiki->runMaintenanceUpdatePHP();
        return $this->logger->write("Extension ".$this->name." enabled...");
    }

    

    public function disable() {
        $this->logger->write("Trying to disable ".$this->ep["name"]."...");
        $this->ep = $this->getExtensionProfileByName();
        if($this->ep == null) {
            $this->logger->write("Extension ".$this->name." unknown");
        }
        if(array_key_exists("composer", $this->ep["installation-aspects"])) {
            // By composer
            $this->logger->write("Running composer...");
            exec("cd $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w && COMPOSER_HOME=$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w php composer.phar remove ".$this->ep["installation-aspects"]["composer"], $output, $retval);
            if($retval <> 0) {
                $this->logger->write("Composer retval ".$retval."...");
            }
            $this->logger->write("Ran composer...");
        } elseif(array_key_exists("repository", $this->ep["installation-aspects"])) {
            // TBD: Remove extensions/repository?
        }
        // ".$this->configFile." directives?
        if(array_key_exists("localsettings", $this->ep["installation-aspects"])) {
            foreach($this->ep["installation-aspects"]["localsettings"] as $ls) {
                $this->sedLocalSettings("s/^".$ls."/#".$ls."/g");
            }
        }
        $this->mediawiki->runMaintenanceUpdatePHP();
        return $this->logger->write("Extension ".$this->name." disabled");
    }

    private function sedLocalSettings($sedArg) {
        $this->logger->write("Sedding LocalSettings.php...");
        // Backup LocalSettings.php before sedding...
        exec("cp ".$this->configFile." ".$this->configFileBAK);
        // ...and then sed
        exec("sed \"".$sedArg."\" ".$this->configFileBAK." > ".$this->configFile, $output, $retval);
        if($retval <> 0) {
            $this->logger->write("sed retval ".$retval."...");
        }
        $this->logger->write("Backed up and sedded LocalSettings.php");
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");