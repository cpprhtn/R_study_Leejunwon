<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->prepare ("INSERT INTO absence (student_id, date)
                       VALUES (:id, :date)");
$sth->bindParam (":id", $student_id);
$sth->bindParam (":date", $date);
$student_id = 7;
$date = "2012-10-01";
$sth->execute ();
$student_id = 18;
$date = "2012-10-03";
$sth->execute ();
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
