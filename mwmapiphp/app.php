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
        $this->injectOntology();
        $this->mediawiki->runMaintenanceJobsPHP();
        $this->mediawiki->runExtensionsSemanticMediaWikiMaintenanceRebuildDataPHP();
        return $this->logger->write("App ".$this->name." enabled...");
    }

    public function disable() {
        return "";
    }

    private function injectOntology() {
        foreach(glob($this->cloneLocation."/".$this->name."/objects/*") as $item) {
            if(is_dir($item)) {
                $namespace = basename($item);
                foreach(glob($item."/*") as $item2) {
                    $pageName = basename($item2, ".wikitext");
                    $wikitext = file_get_contents($item2);
                    $this->mediawiki->injectContent($namespace.":".$pageName, $wikitext);
                }
            } else {
                $pageName = basename($item, ".wikitext");
                $wikitext = file_get_contents($item);
                $this->mediawiki->injectContent($pageName, $wikitext);
            }
        }
    }

    private function cloneRepository() {
        exec("git clone ".escapeshellarg($this->ap["installation-aspects"]["repository"])." ".escapeshellarg($this->cloneLocation."/".$this->name), $output, $retval);
        if($retval <> 0) {
            $this->logger->write($this->ap["installation-aspects"]["repository"]." already cloned");
        } else {
            $this->logger->write("Successfully cloned ".$this->ap["installation-aspects"]["repository"]);
        }
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");