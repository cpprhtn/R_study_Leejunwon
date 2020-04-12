<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
while ($row = $sth->fetchObject ())
  printf ("%s %s\n", $row->first_name, $row->last_name);
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
