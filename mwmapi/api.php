<?php

require_once "./overview.php";
require_once "./extension.php";
require_once "./app.php";
require_once "./snapshots.php";
require_once "./upgrades.php";
require_once "./mediawiki.php";
require_once "./system.php";
require_once "./extensionCatalogue.php";
require_once "./appCatalogue.php";
require_once "./logger.php";
require_once "./test.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: false");
header('Content-Type: application/json');
  
$action = isset($_GET['action']) ? $_GET['action'] : die();

$logger = new Logger();
$overview = new Overview();
$snapshots = new Snapshots($logger);
$upgrades = new Upgrades();
$mediawiki = new MediaWiki($logger);
$system = new System($mediawiki, $logger);

$extensionCatalogue = new ExtensionCatalogue($mediawiki);
$appCatalogue = new AppCatalogue();

$generalSiteInfo = $mediawiki->generalSiteInfo();
if(is_null($generalSiteInfo)) {
    $response = array(
        "status" => "MediaWiki API error"
    );
    http_response_code(404);    
}

switch($action) {
    case "overview":        
        $response = array(
            "extensionsInDirectory" => $overview->extensionsInDirectory(),
            "wfLoadExtensions" => $overview->wfLoadExtensions(),
            "composerjsonReq" => $overview->composerjsonReq()
        );
        http_response_code(200);
        break;
    case "manageExtension":
        $mode = isset($_GET['mode']) ? $_GET['mode'] : die();
        $extensionName = isset($_GET['extensionName']) ? $_GET['extensionName'] : die();
        $extension = new Extension($extensionName, $extensionCatalogue, $generalSiteInfo, $mediawiki, $logger);
        switch($mode) {
            case "enable":
                $response = array(
                    "status" => $extension->enable()
                );
                break;
            case "disable":
                $response = array(
                    "status" => $extension->disable()
                );
                break;
        }
        http_response_code(200);
        break;
    case "manageApp":
        $mode = isset($_GET['mode']) ? $_GET['mode'] : die();
        $appName = isset($_GET['appName']) ? $_GET['appName'] : die();
        $app = new App($appName, $appCatalogue, $generalSiteInfo, $mediawiki, $logger);
        switch($mode) {
            case "enable":
                $response = array(
                    "status" => $app->enable()
                );
                break;
            case "disable":
                $response = array(
                    "status" => $app->disable()
                );
                break;
        }
        http_response_code(200);
        break;
    case "extensionCatalogue":        
        $response = array(
            "extensionCatalogue" => $extensionCatalogue->extensionCatalogue($generalSiteInfo),
            "status" => $logger->write("Extension catalogue loaded")
        );
        break;
    case "appCatalogue":
        $response = array(
            "appCatalogue" => $appCatalogue->appCatalogue(),
            "status" => $logger->write("App catalogue loaded")
        );
        break;
    case "installedApps":
        $response = array(
            "installedApps" => $mediawiki->installedApps(),
            "status" => $logger->write("Installed apps loaded")
        );
        break;
    case "upgradesCatalogue":
        $response = array(
            "upgradesCatalogue" => $upgrades->upgradesCatalogue(),
            "status" => $logger->write("Upgrade catalogue loaded")
        );
        break;
    case "snapshotCatalogue":
        $response = array(
            "snapshotCatalogue" => $snapshots->snapshotCatalogue(),
            "status" => $logger->write("Snapshot catalogue loaded")
        );
        break;
    case "takeSnapshot":
        $response = array(
            "status" => $snapshots->takeSnapshot()
        );
        break;
    case "extensionsByMWAPI":
        $response = array(
            "extensionsByMWAPI" => $mediawiki->extensionsByMWAPI(),
            "status" => $logger->write("Extensions by MediaWiki API loaded")
        );
        break;
    case "generalSiteInfo":
        $response = array(
            "generalSiteInfo" => $generalSiteInfo,
            "status" => $logger->write("MediaWiki info loaded")
        );
        break;
    case "upgradeNow":
        $response = array(
            "status" => $system->upgradeNow()
        );
        break;
    case "viewLog":
        $response = $logger->viewLog();
        break;
    case "runTest":
        $logger->write("Running test");
        $test = new Test($extensionCatalogue, $generalSiteInfo, $mediawiki, $snapshots, $system, $logger);
        $response = array(
            "status" => $test->runTest()
        );
        break;
    default:
        $response = array();
        http_response_code(404);
}

echo json_encode($response);