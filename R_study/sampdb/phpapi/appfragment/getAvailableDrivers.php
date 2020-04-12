<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_1_
$drivers = $dbh->getAvailableDrivers ();
printf ("Number of drivers available: %d\n", count ($drivers));
print ("Driver names: " . join (" ", $drivers) . "\n");
#@ _FRAGMENT_1_
#@ _FRAGMENT_2_
$drivers = PDO::getAvailableDrivers ();
#@ _FRAGMENT_2_
printf ("Number of drivers available: %d\n", count ($drivers));
print ("Driver names: " . join (" ", $drivers) . "\n");

$dbh = NULL;  # close connection
?>
