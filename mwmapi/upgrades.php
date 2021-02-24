<?php

class Upgrades {

    function __construct() {
        
    }

    public function upgradesCatalogue() {
        $upgradesjson = file_get_contents(getcwd().'/versions.json');
        $jd = json_decode($upgradesjson, true);
        return $jd;
    }

}