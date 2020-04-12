<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

$stmt1 = "DELETE FROM member WHERE member_id = 149";
$stmt2 = "DELETE FROM member WHERE member_id = 150";

#@ _FRAGMENT_
try
{
  $dbh->beginTransaction ();  # start transaction
  $dbh->exec ($stmt1);        # execute statements
  $dbh->exec ($stmt2);
  $dbh->commit ();            # commit if successful
}
catch (PDOException $e)
{
  # roll back if unsuccessful, but use empty
  # exception handler to catch rollback failure
  print ($e->getMessage () . "\n");
  try
  {
    $dbh->rollback ();
  }
  catch (PDOException $e) { }
}
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
