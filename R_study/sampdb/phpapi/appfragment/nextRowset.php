<?php
require_once "sampdb_pdo.php";

$dbh = sampdb_connect ();

#@ _FRAGMENT_
$sth = $dbh->query ("SELECT last_name, first_name FROM president LIMIT 5;
                     SELECT 1, 2, 3;
                     SHOW TABLES");
do
{
  $rowset = $sth->fetchAll (PDO::FETCH_NUM);
  if ($rowset)
  {
    $count = 0;
    foreach ($rowset as $row)
    {
      for ($i = 0; $i < sizeof ($row); $i++)
        print ($row[$i] . ($i < sizeof ($row) - 1 ? "," : "\n"));
      $count++;
    }
    printf ("Number of rows returned: %d\n\n", $count);
  }
} while ($sth->nextRowset ());
#@ _FRAGMENT_

$dbh = NULL;  # close connection
?>
