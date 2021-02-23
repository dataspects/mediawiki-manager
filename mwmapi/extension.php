<?php

class Extension {

    function __construct($name, $overview) {
        $this->name = $name;
        $this->extensionProfile($overview);
    }

    public function enable() {
        if(array_key_exists("composer", $this->ep)) {
            // By composer
            exec("cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar require ".$this->ep["composer"], $output, $retval);
        } elseif(array_key_exists("repository", $this->ep)) {
            // From repository
            exec("git clone ".$this->ep["repository"]." /var/www/html/w/extensions/".$this->name, $output1, $retval);
            if($retval <> 0) {
                // TBD: If we reenable, should we check for updates?
            }
        }
        // LocalSettings.php directives?
        if(array_key_exists("localsettings", $this->ep)) {
            foreach($this->ep["localsettings"] as $ls) {
                // Try to uncomment
                exec("sed -i \"s/^#".$ls."/".$ls."/g\" /var/www/html/w/LocalSettings.php", $output, $retval);
                // Check if line is present
                exec("grep -c \"".$ls."\" /var/www/html/w/LocalSettings.php", $output, $retval);
                if($output[0] == 0) {
                    // Add line if necessary
                    exec("echo \"".$ls."\">> /var/www/html/w/LocalSettings.php", $output, $retval);
                }
            }
        }
        exec("cd /var/www/html/w && php maintenance/update.php --quick", $output, $retval);
        return $retval;
    }

    public function disable() {
        if(array_key_exists("composer", $this->ep)) {
            // By composer
            exec("cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar remove --no-update ".$this->ep["composer"], $output, $retval);
        } elseif(array_key_exists("repository", $this->ep)) {
            // TBD: Remove extensions/repository?
        }
        // LocalSettings.php directives?
        if(array_key_exists("localsettings", $this->ep)) {
            foreach($this->ep["localsettings"] as $ls) {
                exec("sed -i \"s/^".$ls."/#".$ls."/g\" /var/www/html/w/LocalSettings.php", $output, $retval);
            }
        }
        exec("cd /var/www/html/w && php maintenance/update.php --quick", $output, $retval);
        return $retval;
    }

    private function extensionProfile($overview) {
        $this->ep = $overview->extensionCatalogue()[$this->name];
    }

}