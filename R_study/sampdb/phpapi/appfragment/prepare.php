<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->prepare ("INSERT INTO absence (student_id, date)
                       VALUES (?, ?)");
$sth->execute (array (7, "2012-10-01"));
$sth->execute (array (18, "2012-10-03"));
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
