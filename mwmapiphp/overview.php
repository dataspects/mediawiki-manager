<?php

class Overview {

    function __construct() {

        $localSettingsString = file_get_contents(getcwd().'/../w/LocalSettings.php');
        $this->localSettingsArray = explode("\n", $localSettingsString);

        $composerjson = file_get_contents(getcwd().'/../w/composer.local.json');
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

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");