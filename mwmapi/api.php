<?php

require_once "./overview.php";
require_once "./extension.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: false");
header('Content-Type: application/json');
  
$action = isset($_GET['action']) ? $_GET['action'] : die();

$overview = new Overview();

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
            "extensionCatalogue" => $overview->extensionCatalogue()
        );
        break;
    default:
        $response = array();
        http_response_code(404);
}

echo json_encode($response);