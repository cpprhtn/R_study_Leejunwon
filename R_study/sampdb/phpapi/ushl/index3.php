<?php
# USHL home page - version 3

require_once "sampdb_pdo.php";

$title = "U.S. Historical League";
html_begin ($title, $title);
?>

<p>Welcome to the U.S. Historical League Web Site.</p>

<?php
try
{
  $dbh = sampdb_connect ();
  $sth = $dbh->query ("SELECT COUNT(*) FROM member");
  $count = $sth->fetchColumn (0);
  print ("<p>The League currently has $count members.</p>");
  $dbh = NULL;  # close connection
}
catch (PDOException $e) { } # empty handler (catch but ignore errors)

html_end ();
?>
