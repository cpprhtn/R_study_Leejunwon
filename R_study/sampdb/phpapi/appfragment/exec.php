<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$count = $dbh->exec ("DELETE FROM member WHERE member_id = 149");
printf ("Number of rows deleted: %d\n", $count);
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
