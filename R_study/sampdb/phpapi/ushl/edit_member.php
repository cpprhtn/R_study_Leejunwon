<?php
#@ _OUTLINE_PART_1_
# edit_member.php - Edit U.S. Historical League member entries over the Web

require_once "sampdb_pdo.php";

# Define action constants
define ("SHOW_INITIAL_PAGE", 0);
define ("DISPLAY_ENTRY", 1);
define ("UPDATE_ENTRY", 2);
#@ _OUTLINE_PART_1_

# Display a login form to solicit the member's ID and password

#@ _SOLICIT_MEMBER_ID_
function display_login_page ()
{
  printf ("<form method=\"post\" action=\"%s?action=%d\">\n",
          script_name (),
          DISPLAY_ENTRY);
  print ("Enter your membership ID number and password,\n");
  print ("then select Submit.\n<br /><br />\n");
  print ("<table>\n");
  print ("<tr>");
  print ("<td>Member ID</td><td>");
  text_field ("member_id", "", 10);
  print ("</td></tr>");
  print ("<tr>");
  print ("<td>Password</td><td>");
  password_field ("password", "", 10);
  print ("</td></tr>");
  print ("</table>\n");
  submit_button ("button", "Submit");
  print "</form>\n";
}
#@ _SOLICIT_MEMBER_ID_

# Display a column of a member entry.  $label is the visible label
# displayed to the user.  $row is the array containing the member
# entry.  $col_name is the name of a column in the entry.  $editable
# should be true if the user is permitted to change the column value.
# (The value is displayed as non-editable text otherwise.) $editable
# is optional; if missing, it defaults to true.  Field names are
# constructed using row[col_name] format so that when the form is
# submitted, values can be accessed using a $row array rather than a
# bunch of individual variables.

#@ _DISPLAY_COLUMN_
function display_column ($label, $row, $col_name, $editable = TRUE)
{
  print ("<tr>\n");
  print ("<td>" . htmlspecialchars ($label) . "</td>\n");
  print ("<td>");
  if ($editable)  # display as editable field
    text_field ("row[$col_name]", $row[$col_name], 80);
  else            # display as read-only text
    print (htmlspecialchars ($row[$col_name]));
  print ("</td>\n");
  print ("</tr>\n");
}
#@ _DISPLAY_COLUMN_

#@ _CHECK_PASS_
function check_pass ($dbh, $id, $pass)
{
  $stmt = "SELECT password FROM member_pass WHERE member_id = ?";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ($id));
  # TRUE if a password was found and it matches
  return (($row = $sth->fetch ()) && $row["password"] == $pass);
}
#@ _CHECK_PASS_

# Determine whether the client supplied the correct password for
# a member entry.  If so, display the entry for editing.

#@ _DISPLAY_ENTRY_
function display_entry ($dbh)
{
  # Get script parameters; trim whitespace from the ID, but not
  # from the password, because the password must match exactly.

  $member_id = trim (script_param ("member_id"));
  $password = script_param ("password");

  if (empty ($member_id))
    die ("No member ID was specified\n");
  if (!ctype_digit ($member_id))                # must look like integer
    die ("Invalid member ID was specified (must be an integer)\n");
  if (empty ($password))
    die ("No password was specified\n");
  if (check_pass ($dbh, $member_id, $password)) # regular member
    $admin = FALSE;
  else if (check_pass ($dbh, 0, $password))     # administrator
    $admin = TRUE;
  else
    die ("Invalid password\n");

  $stmt = "SELECT
             last_name, first_name, suffix, email, street, city,
             state, zip, phone, interests, member_id, expiration
           FROM member WHERE member_id = ?
           ORDER BY last_name";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ($member_id));

  if (!($row = $sth->fetch ()))
    die ("No user with member_id = $member_id was found\n");

  printf ("<form method=\"post\" action=\"%s?action=%d\">\n",
          script_name (),
          UPDATE_ENTRY);

  # Add member ID and password as hidden values so that next invocation
  # of script can tell which record the form corresponds to and so that
  # the user need not re-enter the password.

  hidden_field ("member_id", $member_id);
  hidden_field ("password", $password);

  # Format results of statement for editing

  print ("<table>\n");

  # Display member ID as static text

  display_column ("Member ID", $row, "member_id", FALSE);

  # $admin is true if the user provided the administrative password,
  # false otherwise. Administrative users can edit the expiration
  # date, regular users cannot.

  display_column ("Expiration", $row, "expiration", $admin);

  # Display other values as editable text

  display_column ("Last name", $row, "last_name");
  display_column ("First name", $row, "first_name");
  display_column ("Suffix", $row, "suffix");
  display_column ("Email", $row, "email");
  display_column ("Street", $row, "street");
  display_column ("City", $row, "city");
  display_column ("State", $row, "state");
  display_column ("Zip", $row, "zip");
  display_column ("Phone", $row, "phone");
  display_column ("Interests", $row, "interests");

  print ("</table>\n");

  submit_button ("button", "Submit");
  print "</form>\n";

}
#@ _DISPLAY_ENTRY_

#@ _UPDATE_ENTRY_
function update_entry ($dbh)
{
  # Get script parameters; trim whitespace from the ID, but not
  # from the password, because the password must match exactly,
  # or from the row, because it is an array.

  $member_id = trim (script_param ("member_id"));
  $password = script_param ("password");
  $row = script_param ("row");

  if (empty ($member_id))
    die ("No member ID was specified\n");
  if (!ctype_digit ($member_id))            # must look like integer
    die ("Invalid member ID was specified (must be an integer)\n");
  if (!check_pass ($dbh, $member_id, $password)
      && !check_pass ($dbh, 0, $password))
    die ("Invalid password\n");

  # Examine the metadata for the member table to determine whether
  # each column permits NULL values. (Make sure nullability is
  # retrieved in uppercase.)

  $stmt = "SELECT COLUMN_NAME, UPPER(IS_NULLABLE)
           FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ("sampdb", "member"));
  $nullable = array ();
  while ($info = $sth->fetch ())
    $nullable[$info[0]] = ($info[1] == "YES");

  # Iterate through each field in the form, using the values to
  # construct an UPDATE statement that contains placeholders, and
  # the array of data values to bind to the placeholders.

  $stmt = "UPDATE member ";
  $delim = "SET";
  $params = array ();
  foreach ($row as $col_name => $val)
  {
    $stmt .= "$delim $col_name=?";
    $delim = ",";
    # If a form value is empty, update the corresponding column value
    # with NULL if the column is nullable.  This prevents trying to
    # put an empty string into the expiration date column when it
    # should be NULL, for example.
    $val = trim ($val);
    if (empty ($val))
    {
      if ($nullable[$col_name])
        $params[] = NULL; # enter NULL
      else
        $params[] = "";   # enter empty string
    }
    else
      $params[] = $val;
  }
  $stmt .= " WHERE member_id = ?";
  $params[] = $member_id;

  $sth = $dbh->prepare ($stmt);
  $sth->execute ($params);
  printf ("<br /><a href=\"%s\">Edit another member record</a>\n",
          script_name ());
}
#@ _UPDATE_ENTRY_

#@ _OUTLINE_PART_2_
$title = "U.S. Historical League -- Member Editing Form";
html_begin ($title, $title);

$dbh = sampdb_connect ();

# Determine what action to perform (the default if
# none is specified is to present the initial page)

$action = script_param ("action");
if (is_null ($action))
  $action = SHOW_INITIAL_PAGE;

switch ($action)
{
case SHOW_INITIAL_PAGE:   # present initial page
  display_login_page ();
  break;
case DISPLAY_ENTRY:       # display entry for editing
  display_entry ($dbh);
  break;
case UPDATE_ENTRY:        # store updated entry in database
  update_entry ($dbh);
  break;
default:
  die ("Unknown action code ($action)\n");
}

$dbh = NULL;  # close connection

html_end ();
#@ _OUTLINE_PART_2_
?>
