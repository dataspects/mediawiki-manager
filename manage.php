<?php

$extsDir = getcwd().'/extensions/';
$exts = array_diff(scandir($extsDir), array('..', '.'));

///////////////////////////////////////////////////////////////////////////////

$chkbxs = array();
foreach($exts as $ext) {
    if(is_dir($extsDir.$ext)) {
        $chkbxs[] = $ext;
    }
}

///////////////////////////////////////////////////////////////////////////////

$localSettingsString = file_get_contents('LocalSettings.php');
$localSettingsArray = explode("\n", $localSettingsString);

///////////////////////////////////////////////////////////////////////////////

$wfLEs = array();
foreach($localSettingsArray as $lsline) {
    preg_match('/#?wfLoadExtension.*;/', $lsline, $matches, PREG_OFFSET_CAPTURE);
    if($matches[0]) {
        $wfLEs[] = $matches[0][0];
    };
}
sort($wfLEs);

///////////////////////////////////////////////////////////////////////////////


$composerjson = file_get_contents('composer.json');
$composerjsonArray = json_decode($composerjson, true);
$composerjsonReq = array();
foreach($composerjsonArray["require"] as $ext => $version) {
    $composerjsonReq[] = $ext;
}
sort($composerjsonReq);

///////////////////////////////////////////////////////////////////////////////

echo "<h1>Simple MWStake MediaWiki Manager</h1>";
echo "<form action='manage.php' method='post'><table cellspacing='50' width='100%'>";
echo "<tr>";
echo "<td colspan='3'>
        <a href='https://packagist.org/explore/?type=mediawiki-extension'>Browse <b>packagist.org/explore/?type=mediawiki-extension</b></a>
        
        <h2>Enable/disable existing extensions</h2>
        <code style='white-space: pre;'>
        mediawiki-manager$ <b><a href='https://github.com/dataspects/mediawiki-manager/blob/main/enable-extension.sh'>./enable-extension.sh</a></b>
        Enter extension name to install: <b>jeroen/mediawiki-github</b>
        &lt;ENTER&gt;
        </code>
        <code style='white-space: pre;'>
        mediawiki-manager$ <b><a href='https://github.com/dataspects/mediawiki-manager/blob/main/disable-extension.sh'>./disable-extension.sh</a></b>
        Enter extension name to remove: <b>jeroen/mediawiki-github</b>
        &lt;ENTER&gt;
        </code>
      </td>";      
echo "</tr>";     
echo "<tr>
        <th>Directories in extensions/</th>
        <th>wfLoadExtension entries in LocalSettings.php</th>
        <th>Required in composer.json</th>
     </tr>";
echo "<tr>";
echo "<td style='vertical-align:top;'>".implode('<br/>', $chkbxs)."</td>";
echo "<td style='vertical-align:top;'>".implode('<br/>', $wfLEs)."</td>";
echo "<td style='vertical-align:top;'>".implode('<br/>', $composerjsonReq)."</td>";
echo "</tr>";
echo "</table></form>";