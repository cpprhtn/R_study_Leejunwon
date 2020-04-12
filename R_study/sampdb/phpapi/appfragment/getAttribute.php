<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

# _DBH_FRAGMENT_
printf ("Driver name: %s\n",
        $dbh->getAttribute (PDO::ATTR_DRIVER_NAME));
printf ("Server info: %s\n",
        $dbh->getAttribute (PDO::ATTR_SERVER_INFO));
printf ("Server version: %s\n",
        $dbh->getAttribute (PDO::ATTR_SERVER_VERSION));
# _DBH_FRAGMENT_

$dbh = NULL;
?>
