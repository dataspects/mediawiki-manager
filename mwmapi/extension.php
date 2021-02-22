<?php

class Extension {

    function __construct($name) {
        $this->name = $name;
    }

    public function enable() {
        return system("sed -i \"s/^#wfLoadExtension( '".$this->name."' );/wfLoadExtension( '".$this->name."' );/g\" /var/www/html/w/LocalSettings.php");
    }

    public function disable() {
        return system("sed -i \"s/^wfLoadExtension( '".$this->name."' );/#wfLoadExtension( '".$this->name."' );/g\" /var/www/html/w/LocalSettings.php");
    }

}