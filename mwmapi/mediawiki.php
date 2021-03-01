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

    public function runMaintenanceJobsPHP() {
        $this->logger->write("Running maintenance/runJobs.php...");
        exec("cd /var/www/html/w && php maintenance/runJobs.php", $output, $retval);
        $this->logger->write("Ran maintenance/runJobs.php");
    }

    public function runExtensionsSemanticMediaWikiMaintenanceRebuildDataPHP() {
        $this->logger->write("Running extensions/SemanticMediaWiki/maintenance/rebuildData.php...");
        exec("cd /var/www/html/w/extensions/SemanticMediaWiki && php maintenance/rebuildData.php", $output, $retval);
        $this->logger->write("Ran extensions/SemanticMediaWiki/maintenance/rebuildData.php...");
    }

    public function extensionsByMWAPI() {
        return $this->siteInfo()["extensions"];
    }

    public function generalSiteInfo() {
        return $this->siteInfo()["general"];
    }

    public function installedApps() {
        $results = $this->askargs("Subcategory of::Ontology");
        return $results["query"]["results"];
    }

    public function injectContent($fullPageName, $wikitext) {
        $editToken = $this->editToken();
        $ch = $this->ch();
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=edit&format=json");
        curl_setopt($ch,CURLOPT_POST,true);
        curl_setopt($ch,CURLOPT_POSTFIELDS, array(
            "title" => $fullPageName,
            "text" => $wikitext,
            "token" => $editToken
        ));
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output;
    }

    private function askargs($conditions) {
        $ch = $this->ch();
        $conditions = curl_escape($ch, $conditions);
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=askargs&conditions=".$conditions."&format=json");
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output;
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

    private function editToken() {
        $ch = $this->ch();
        curl_setopt($ch, CURLOPT_URL, $this->apiURL."?action=query&meta=tokens&type=csrf&format=json");
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output["query"]["tokens"]["csrftoken"];
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