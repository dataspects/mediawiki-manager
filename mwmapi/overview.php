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
}