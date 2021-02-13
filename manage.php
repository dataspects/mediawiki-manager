<?php

$extsDir = getcwd().'/extensions/';
$exts = array_diff(scandir($extsDir), array('..', '.'));

$chkbxs = array();
foreach($exts as $ext) {
    if(is_dir($extsDir.$ext)) {
        $chkbxs[] = "
            <input type='checkbox' id='$ext' name='$ext' value='$ext' checked='checked'>
            <label for='$ext'>$ext</label>
        ";
    }
}

echo "<h1>Simple MWStake MediaWiki Manager</h1>";
echo "<form action='manage.php' method='post'><table cellspacing='50'>";
echo "<tr><th>Step 1: Enable/disable extensions</th><th>Step 2: Apply selection</th></tr>";
echo "<tr>";
echo "<td>".implode('<br/>', $chkbxs)."</td>";
echo "<td style='vertical-align:top;'><input type='submit' value='Apply selection'></td>";
echo "</tr>";
echo "</table></form>";