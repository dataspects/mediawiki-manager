<?php

class App {

    function __construct($name, $appCatalogue, $generalSiteInfo, $mediawiki, $logger) {
        # $name is user input!
        $this->unsafeName = $name;
        $this->appCatalogue = $appCatalogue;
        $this->generalSiteInfo = $generalSiteInfo;
        $this->mediawiki = $mediawiki;
        $this->logger = $logger;
        # FIXME: safe now?
        # FIXME: Ok not to escapeshellcmd as of now?
        
    }

    private function getAppProfileByName() {
        foreach($this->appCatalogue->appCatalogue() as $appProfile) {
            if($appProfile["name"] == $this->unsafeName) {
                $this->name = $appProfile["name"];
                return $appProfile;
            }
        }
        return null;
    }

    public function enable() {
        $this->ep = $this->getAppProfileByName();
        if($this->ep == null) {
            return $this->logger->write("App ".$this->name." unknown");
        }
        return "";
    }

    public function disable() {
        return "";
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");