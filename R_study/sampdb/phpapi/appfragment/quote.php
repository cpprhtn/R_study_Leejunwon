<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$quoted_val1 = $dbh->quote (13);
$quoted_val2 = $dbh->quote ("it's a string");
#@ _FRAGMENT_
print ("Quoted value 1: $quoted_val1\n");
print ("Quoted value 2: $quoted_val2\n");

$dbh = NULL;  # close connection
?>
