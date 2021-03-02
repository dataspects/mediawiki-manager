<?php

class Upgrades {

    function __construct() {
        
    }

    public function upgradesCatalogue() {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_URL, "https://raw.githubusercontent.com/dataspects/mediawiki-manager/main/catalogues/versions.json");
        $upgradesCatalogue = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $upgradesCatalogue;
    }

}