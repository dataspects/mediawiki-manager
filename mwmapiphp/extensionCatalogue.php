<?php

class ExtensionCatalogue {

    function __construct($mediawiki) {

        $localSettingsString = file_get_contents(getcwd().'/../w/LocalSettings.php');
        $this->localSettingsArray = explode("\n", $localSettingsString);

        $composerjson = file_get_contents(getcwd().'/../w/composer.local.json');
        $this->composerjsonArray = json_decode($composerjson, true);

        $this->extensionsByMWAPI = $mediawiki->extensionsByMWAPI();

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

    

    private function compileExtensionCatalogue($extensionCatalogue, $generalSiteInfo) {
        $mediaWikiVersion = $this->mediaWikiVersion($generalSiteInfo);
        $phpVersion = $generalSiteInfo["phpversion"];
        $ec = array();
        foreach ($extensionCatalogue as $extension) {
            $extension["requires"] = array();
            $extension["requires"] = array_merge($extension["requires"], $this->requiresMWUpdate($extension, $mediaWikiVersion));
            $extension["requires"] = array_merge($extension["requires"], $this->requiresPHPUpdate($extension, $phpVersion));
            $extension["isInstalled"] = $this->extensionIsInstalled($extension);
            $ec[] = $extension;
        }
        return $ec;
    }

    private function extensionIsInstalled($extension) {
        foreach($this->extensionsByMWAPI as $ebmwapi) {
            if($ebmwapi["name"] == $extension["name"]) {
                return array(
                    "version" => $ebmwapi["version"],
                    "url" => $ebmwapi["url"]
                );
            }
        }
        return array(
        
        );
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