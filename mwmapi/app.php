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
        $this->cloneLocation = "/var/www/html/cloneLocation";
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
        $this->ap = $this->getAppProfileByName();
        if($this->ap == null) {
            return $this->logger->write("App ".$this->name." unknown");
        }
        $this->logger->write("Trying to enable ".$this->ap["name"]."...");
        $this->cloneRepository();
        return "";
    }

    public function disable() {
        return "";
    }

    private function cloneRepository() {
        exec("git clone ".$this->ap["installation-aspects"]["repository"]." /var/www/html/w/".$this->cloneLocation."/".$this->name, $output, $retval);
        if($retval <> 0) {
            $this->logger->write($this->ap["installation-aspects"]["repository"]." already cloned");
        } else {
            $this->logger->write("Successfully cloned ".$this->ap["installation-aspects"]["repository"]);
        }
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");