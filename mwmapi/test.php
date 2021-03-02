<?php

class Test {

    function __construct($appCatalogue, $extensionCatalogue, $generalSiteInfo, $mediawiki, $snapshots, $system, $logger) {
        $this->appCatalogue = $appCatalogue;
        $this->extensionCatalogue = $extensionCatalogue; $this->generalSiteInfo = $generalSiteInfo;
        $this->mediawiki = $mediawiki;
        $this->snapshots = $snapshots;
        $this->system = $system;
        $this->logger = $logger;
    }

    public function runTest() {
        // Snapshots
        $this->snapshots->takeSnapshot();
        // Upgrade
        $this->system->upgradeNow();
        // Extensions management
        $extension = new Extension("LabeledSectionTransclusion", $this->extensionCatalogue, $this->generalSiteInfo, $this->mediawiki, $this->logger);
        $extension->enable();
        // Apps management
        $app = new App("dataspects/dataspectsSystemCoreOntology", $this->appCatalogue, $this->generalSiteInfo, $this->mediawiki, $this->logger);
        $app->enable();
        return $this->logger->write("Ran test");
    }

}

// error_log("_______________________________________".$mediaWikiVersion."_______________________________________");