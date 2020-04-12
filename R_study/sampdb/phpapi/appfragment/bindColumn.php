<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
$sth->bindColumn ("last_name", $l_name); # specify column by name
$sth->bindColumn (2, $f_name);           # specify column by position
while ($sth->fetch (PDO::FETCH_BOUND))
  printf ("%s %s\n", $f_name, $l_name);
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
