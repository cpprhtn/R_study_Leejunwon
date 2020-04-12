<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
$sth->setFetchMode (PDO::FETCH_OBJ);
while ($row = $sth->fetch ())
  printf ("%s %s\n", $row->last_name, $row->first_name);
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
