<?php

require_once "./overview.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: false");
header('Content-Type: application/json');
  
$mode = isset($_GET['mode']) ? $_GET['mode'] : die();

$overview = new Overview();

http_response_code(200);
echo json_encode(
    array(
        "extensionsInDirectory" => $overview->extensionsInDirectory(),
        "wfLoadExtensions" => $overview->wfLoadExtensions(),
        "composerjsonReq" => $overview->composerjsonReq(),
        "mode"=> $mode
    )
);