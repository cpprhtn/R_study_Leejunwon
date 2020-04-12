<html>
<head>
<title>U.S. Historical League</title>
</head>
<body bgcolor="white">
<h2>U.S. Historical League</h2>
<p>Welcome to the U.S. Historical League Web Site.</p>
<?php
# USHL home page

try
{
#@ _DB_CONNECT_
  $dbh = new PDO("mysql:host=localhost;dbname=sampdb", "sampadm", "secret");
#@ _DB_CONNECT_
#@ _ENABLE_EXCEPTIONS_
  $dbh->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
#@ _ENABLE_EXCEPTIONS_
#@ _PROCESS_QUERY_
  $sth = $dbh->query ("SELECT COUNT(*) FROM member");
  $count = $sth->fetchColumn (0);
  print ("<p>The League currently has $count members.</p>");
#@ _PROCESS_QUERY_
  $dbh = NULL;  # close connection
}
catch (PDOException $e) { } # empty handler (catch but ignore errors)
?>
</body>
</html>
