<html>
<head>
<title>U.S. Historical League</title>
</head>
<body bgcolor="white">
<h2>U.S. Historical League</h2>
<p>Welcome to the U.S. Historical League Web Site.</p>
<?php
# USHL home page - version 2

require_once "sampdb_pdo.php";

try
{
#@ _DB_CONNECT_
  $dbh = sampdb_connect ();
#@ _DB_CONNECT_
  $sth = $dbh->query ("SELECT COUNT(*) FROM member");
  $count = $sth->fetchColumn (0);
  print ("<p>The League currently has $count members.</p>");
  $dbh = NULL;  # close connection
}
catch (PDOException $e) { } # empty handler (catch but ignore errors)
?>
</body>
</html>
