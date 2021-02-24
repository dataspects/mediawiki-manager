<?php

class Overview {

    function __construct() {

        $localSettingsString = file_get_contents(getcwd().'/../w/LocalSettings.php');
        $this->localSettingsArray = explode("\n", $localSettingsString);

        $composerjson = file_get_contents(getcwd().'/../w/composer.json');
        $this->composerjsonArray = json_decode($composerjson, true);

    }

    public function extensionsInDirectory() {
        $extsDir = getcwd().'/../w/extensions/';
        return array_diff(scandir($extsDir), array('..', '.'));
    }

    public function wfLoadExtensions() {
        $wfLEs = array();
        foreach($this->localSettingsArray as $lsline) {
            preg_match('/#?wfLoadExtension.*;/', $lsline, $matches);
            if(count($matches) > 0) {
                $wfLEs[] = $matches[0];
            };
        }
        sort($wfLEs);
        return $wfLEs;
    }

    public function composerjsonReq() {
        $composerjsonReq = array();
        foreach($this->composerjsonArray["require"] as $ext => $version) {
            $composerjsonReq[] = $ext;
        }
        sort($composerjsonReq);
        return $composerjsonReq;
    }

    public function extensionCatalogue() {
        $extensionsjson = file_get_contents(getcwd().'/extensions.json');
        $jd = json_decode($extensionsjson, true);
        ksort($jd);
        return $jd;
    }

    public function appCatalogue() {
        $appsjson = file_get_contents(getcwd().'/apps.json');
        $jd = json_decode($appsjson, true);
        ksort($jd);
        return $jd;
    }

    public function wikiInfo() {
        return $this->wikiLogin();
    }

    private function wikiLogin() {
        $loginToken = $this->loginToken();
        $username = "Admin";
        $password = "123adminpass456";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://localhost/w/api.php?action=clientlogin&format=json");
        curl_setopt($ch,CURLOPT_POST,true);
        curl_setopt($ch,CURLOPT_POSTFIELDS, array(
            "username" => $username,
            "password" => $password,
            "logintoken" => $loginToken,
            "loginreturnurl" => "https://localhost/w"
        ));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies.txt');
        curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies.txt');
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output;
    }

    private function loginToken() {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://localhost/w/api.php?action=query&meta=tokens&type=login&format=json");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_COOKIEJAR, '/tmp/cookies.txt');
        curl_setopt($ch, CURLOPT_COOKIEFILE, '/tmp/cookies.txt');
        $output = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $output["query"]["tokens"]["logintoken"];
    }

}