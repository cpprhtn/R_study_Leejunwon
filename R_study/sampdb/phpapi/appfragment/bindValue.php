<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->prepare ("INSERT INTO absence (student_id, date)
                       VALUES (?, ?)");
$sth->bindValue (1, 7);
$sth->bindValue (2, "2012-10-01");
$sth->execute ();
$sth->bindValue (1, 18);
$sth->bindValue (2, "2012-10-03");
$sth->execute ();
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
