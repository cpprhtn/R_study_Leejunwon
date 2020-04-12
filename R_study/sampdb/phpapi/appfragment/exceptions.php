<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_1_
$dbh->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
#@ _FRAGMENT_1_

#@ _FRAGMENT_2_
try
{
  $sth = $dbh->query ("SELECT * FROM no_such_table");
}
catch (PDOException $e)
{
  print ("getCode value: " . $e->getCode() . "\n");
  print ("getMessage value: " . $e->getMessage() . "\n");
}
#@ _FRAGMENT_2_
$dbh = NULL;
?>
