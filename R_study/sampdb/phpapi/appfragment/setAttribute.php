<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

# _DBH_FRAGMENT_
$dbh->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING);
$dbh->setAttribute (PDO::ATTR_AUTOCOMMIT, true);
# _DBH_FRAGMENT_

$dbh = NULL;
?>
