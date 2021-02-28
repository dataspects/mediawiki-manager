<?php

class MediaWiki {

    function __construct($logger) {
        $this->logger = $logger;
        $this->username = "Admin";
        $this->password = "123adminpass456";
        $this->apiURL = "https://localhost/w/api.php";
        $this->wikiLogin();
    }

    public function runMaintenanceUpdatePHP() {
        $this->logger->write("Running maintenance/update.php...");
        exec("cd /var/www/html/w && php maintenance/update.php --quick", $output, $retval);
        $this->logger->write("Ran maintenance/update.php");
    }

    public function extensionsByMWAPI() {
        return $this->siteInfo()["extensions"];
    }

    public function generalSiteInfo() {
        return $this->siteInfo()["general"];
    }

    private function siteInfo() {
        $siProps = array(
            "general",
            "extensions",
            "skins"
        );
        $ch = $this->ch();
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=query&meta=siteinfo&siprop=".join($siProps, "|")."&format=json");
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output["query"];
    }

    private function wikiLogin() {
        $loginToken = $this->loginToken();
        $ch = $this->ch();
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=clientlogin&format=json");
        curl_setopt($ch,CURLOPT_POST,true);
        curl_setopt($ch,CURLOPT_POSTFIELDS, array(
            "username" => $this->username,
            "password" => $this->password,
            "logintoken" => $loginToken,
            "loginreturnurl" => $this->apiURL
        ));
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output;
    }

    private function loginToken() {
        $ch = $this->ch();
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=query&meta=tokens&type=login&format=json");
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output["query"]["tokens"]["logintoken"];
    }

    private function ch() {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies.txt');
        curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies.txt');
        return $ch;
    }

}