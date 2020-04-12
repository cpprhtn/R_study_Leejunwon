<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$dbh->exec ("INSERT INTO grade_event (date, category)
             VALUES('2012-11-01','T')");
printf ("New grade_event ID: %d\n", $dbh->lastInsertId ());
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
