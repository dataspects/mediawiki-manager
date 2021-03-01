<?php

class AppCatalogue {

    function __construct() {

    }

    public function appCatalogue() {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_URL, "https://raw.githubusercontent.com/dataspects/mediawiki-manager/main/catalogues/apps.json");
        $appCatalogue = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $appCatalogue;
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");