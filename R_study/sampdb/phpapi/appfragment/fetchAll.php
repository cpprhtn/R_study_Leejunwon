<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_1_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
$rows = $sth->fetchAll ();
foreach ($rows as $row)
  printf ("%s %s\n", $row[1], $row[0]);
#@ _FRAGMENT_1_

#@ _FRAGMENT_2_
$sth = $dbh->query ("SELECT last_name, first_name FROM president");
$first_names = $sth->fetchAll (PDO::FETCH_COLUMN, 1);
print (join (", ", $first_names) . "\n");
#@ _FRAGMENT_2_

$dbh = NULL;  # close connection
?>
