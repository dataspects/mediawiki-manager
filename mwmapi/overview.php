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

    public function extensionCatalogue($generalSiteInfo) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
        curl_setopt($ch, CURLOPT_URL, "https://raw.githubusercontent.com/dataspects/mediawiki-manager/main/catalogues/extensions.json");
        $extensionCatalogue = json_decode(curl_exec($ch), true);
        curl_close($ch);
        return $this->compileExtensionCatalogue($extensionCatalogue, $generalSiteInfo);
    }

    public function appCatalogue() {
        $appsjson = file_get_contents(getcwd().'/apps.json');
        $jd = json_decode($appsjson, true);
        ksort($jd);
        return $jd;
    }

    private function compileExtensionCatalogue($extensionCatalogue, $generalSiteInfo) {
        $mediaWikiVersion = $this->mediaWikiVersion($generalSiteInfo);
        $phpVersion = $generalSiteInfo["phpversion"];
        $ec = array();
        foreach ($extensionCatalogue as $extension) {
            $extension["requires"] = array();
            $extension["requires"] = array_merge($extension["requires"], $this->requiresMWUpdate($extension, $mediaWikiVersion));
            $extension["requires"] = array_merge($extension["requires"], $this->requiresPHPUpdate($extension, $phpVersion));
            $ec[] = $extension;
        }
        return $ec;
    }

    private function mediaWikiVersion($generalSiteInfo) {
        preg_match("/\d+\.\d+\.\d+/", $generalSiteInfo["generator"], $matches);
        return $matches[0];
    }

    private function requiresMWUpdate($extension, $mediaWikiVersion) {
        //LEX2102271141
        if(isset($extension["installation-aspects"]["requires"])) {
            return array("mediawiki-core" => array("version"=>"1.33"));
        }
        return array();
    }

    private function requiresPHPUpdate($extension, $phpVersion) {
        //LEX2102271141
        if(isset($extension["installation-aspects"]["requires"])) {
            return array("php" => array("version"=>"7.0"));
        }
        return array();
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");