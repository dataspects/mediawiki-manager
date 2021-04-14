<?php
$name  = $argv[1];
$localsettingsdirectives = $argv[2];
$db = new SQLite3('mwm.sqlite');

$stmt = $db->prepare('INSERT INTO extensions (name, localsettingsdirectives) VALUES ( :name, :localsettingsdirectives)');
$stmt->bindValue(':name', $name, SQLITE3_TEXT);
$stmt->bindValue(':localsettingsdirectives', $localsettingsdirectives, SQLITE3_TEXT);

$stmt->execute();