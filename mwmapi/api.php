<?php

require_once "./overview.php";
require_once "./extension.php";
require_once "./snapshots.php";
require_once "./upgrades.php";
require_once "./mediawiki.php";
require_once "./system.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: false");
header('Content-Type: application/json');
  
$action = isset($_GET['action']) ? $_GET['action'] : die();

$overview = new Overview();
$snapshots = new Snapshots();
$upgrades = new Upgrades();
$mediawiki = new MediaWiki();
$system = new System();

$generalSiteInfo = $mediawiki->generalSiteInfo();

switch($action) {
    case "overview":        
        $response = array(
            "extensionsInDirectory" => $overview->extensionsInDirectory(),
            "wfLoadExtensions" => $overview->wfLoadExtensions(),
            "composerjsonReq" => $overview->composerjsonReq()
        );
        http_response_code(200);
        break;
    case "enableDisableExtension":
        $mode = isset($_GET['mode']) ? $_GET['mode'] : die();
        $extensionName = isset($_GET['extensionName']) ? $_GET['extensionName'] : die();
        $extension = new Extension($extensionName, $overview);
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
    case "extensionCatalogue":
        $response = array(
            "extensionCatalogue" => $overview->extensionCatalogue($generalSiteInfo),
            "status" => "Extension catalogue loaded"
        );
        break;
    case "appCatalogue":
        $response = array(
            "appCatalogue" => $overview->appCatalogue(),
            "status" => "App catalogue loaded"
        );
        break;
    case "upgradesCatalogue":
        $response = array(
            "upgradesCatalogue" => $upgrades->upgradesCatalogue(),
            "status" => "Upgrade catalogue loaded"
        );
        break;
    case "snapshotCatalogue":
        $response = array(
            "snapshotCatalogue" => $snapshots->snapshotCatalogue(),
            "status" => "Snapshot catalogue loaded"
        );
        break;
    case "takeSnapshot":
        $snapshots->takeSnapshot();
        $response = array(
            "status" => "Snapshot taken"
        );
        break;
    case "extensionsByMWAPI":
        $response = array(
            "extensionsByMWAPI" => $mediawiki->extensionsByMWAPI(),
            "status" => "Extensions by MediaWiki API loaded"
        );
        break;
    case "generalSiteInfo":
        $response = array(
            "generalSiteInfo" => $generalSiteInfo,
            "status" => "MediaWiki info loaded"
        );
        break;
    case "upgradeNow":
        $response = array(
            "status" => $system->upgradeNow()
        );
        break;
    default:
        $response = array();
        http_response_code(404);
}

echo json_encode($response);