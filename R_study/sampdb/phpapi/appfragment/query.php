<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_1_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
while ($row = $sth->fetch ())
  printf ("%s %s\n", $row[1], $row[0]);
#@ _FRAGMENT_1_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
#@ _FRAGMENT_2_
foreach ($sth as $row)
  printf ("%s %s\n", $row[1], $row[0]);
#@ _FRAGMENT_2_

$dbh = NULL;  # close connection
?>
