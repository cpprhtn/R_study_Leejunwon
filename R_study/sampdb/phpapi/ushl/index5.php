<?php
# USHL home page - version 5

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
?>

<p>
You can view the directory of members <a href="dump_members.php">here</a>.
</p>
<p>
Edit your membership entry <a href="edit_member.php">here</a>
(USHL members only).
</p>
<p>
Test your knowledge of presidential birthplaces by taking this
<a href="pres_quiz.php">quiz</a>!
</p>

<?php
html_end ();
?>
