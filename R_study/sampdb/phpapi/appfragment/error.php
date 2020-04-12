<?php
require_once "sampdb_pdo.php";

# Connect but do not enable exceptions because this code uses
# method return values, not exceptions, to determine method
# failure.

$dbh = sampdb_connect ();
$dbh->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT);

$stmt = "SELECT * FROM no_such_table";
# _DBH_ERROR_METHODS_
if (!($sth = $dbh->query ($stmt)))
{
  print ("The statement failed.\n");
  print ("errorCode: " . $dbh->errorCode () . "\n");
  print ("errorInfo: " . join (", ", $dbh->errorInfo ()) . "\n");
}
# _DBH_ERROR_METHODS_
# This statement results in a syntax error when executed
if (!($sth = $dbh->prepare ("INSERT INTO member")))
{
  print ("Could not prepare statement.\n");
  print ("errorCode: " . $dbh->errorCode () . "\n");
  print ("errorInfo: " . join (", ", $dbh->errorInfo ()) . "\n");
}
else
# _STH_ERROR_METHODS_
if (!$sth->execute ())
{
  print ("Could not execute statement.\n");
  print ("errorCode: " . $sth->errorCode () . "\n");
  print ("errorInfo: " . join (", ", $sth->errorInfo ()) . "\n");
}
# _STH_ERROR_METHODS_
$dbh = NULL;
?>
