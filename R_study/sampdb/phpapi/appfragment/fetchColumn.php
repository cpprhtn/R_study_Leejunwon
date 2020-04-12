<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->query ("SELECT COUNT(*) FROM member");
printf ("Number of members: %d\n", $sth->fetchColumn (0));
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
