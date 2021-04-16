<?php

$db = new SQLite3('mwmconfigdb.sqlite');
$stmt = $db->prepare('SELECT localsettingsdirectives FROM extensions');
$result = $stmt->execute();

$mwmLocalSettingsString = "";
while($res = $result->fetchArray(SQLITE3_ASSOC)){
    $mwmLocalSettingsString .= trim($res["localsettingsdirectives"])."\n";
}

$mwmLS = fopen("mwmLocalSettings.php", "w");
fwrite($mwmLS, "<?php\n".$mwmLocalSettingsString);
fclose($mwmLS);