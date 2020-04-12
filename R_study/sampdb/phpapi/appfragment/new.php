<?php
#@ _FRAGMENT_1_
try
{
  $dbh = new PDO("mysql:host=localhost;dbname=sampdb", "sampadm", "secret");
}
catch (PDOException $e)
{
  die ($e->getMessage () . "\n");
}
#@ _FRAGMENT_1_
#@ _FRAGMENT_2_
$dbh = NULL;
#@ _FRAGMENT_2_
?>
