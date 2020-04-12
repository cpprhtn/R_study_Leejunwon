<?php
# dump_members2.php - dump U.S. Historical League membership as HTML table
# with live links for email addresses

require_once "sampdb_pdo.php";

$title = "U.S. Historical League Member List";
html_begin ($title, $title);

$dbh = sampdb_connect ();

# issue statement
$stmt = "SELECT last_name, first_name, suffix, email,"
      . " street, city, state, zip, phone FROM member ORDER BY last_name";
$sth = $dbh->query ($stmt);

print ("<table>\n");          # begin table
# read results of statement, then clean up
#@ _ROW_PRINT_LOOP_
while ($row = $sth->fetch (PDO::FETCH_NUM))
{
  print ("<tr>\n");           # begin table row
  for ($i = 0; $i < $sth->columnCount (); $i++)
  {
    print ("<td>");
    # escape any special characters and print table cell;
    # email is in column 4 (index 3) of result
    if ($i == 3 && $row[$i] != "")
    {
      printf ("<a href=\"mailto:%s\">%s</a>",
              $row[$i],
              htmlspecialchars ($row[$i]));
    }
    else
    {
      print (htmlspecialchars ($row[$i]));
    }
    print ("</td>\n");
  }
  print ("</tr>\n");          # end table row
}
#@ _ROW_PRINT_LOOP_
print ("</table>\n");         # end table

$dbh = NULL;  # close connection

html_end ();
?>
