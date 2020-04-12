<?php
#@ _OUTLINE_PART_1_
# score_entry.php - Score Entry script for grade-keeping project

require_once "sampdb_pdo.php";

# define action constants
define ("SHOW_INITIAL_PAGE", 0);
define ("SOLICIT_EVENT", 1);
define ("ADD_EVENT", 2);
define ("DISPLAY_SCORES", 3);
define ("ENTER_SCORES", 4);
#@ _OUTLINE_PART_1_

#@ _DISPLAY_CELL_
# Display a cell of an HTML table.  $tag is the tag name ("th" or "td"
# for a header or data cell), $value is the value to display, and
# $encode should be true or false, indicating whether or not to perform
# HTML-encoding of the value before displaying it.  $encode is optional,
# and is true by default.

function display_cell ($tag, $value, $encode = TRUE)
{
  if (strlen ($value) == 0) # is the value empty/unset?
    $value = "&nbsp;";
  else if ($encode) # perform HTML-encoding if requested
    $value = htmlspecialchars ($value);
  print ("<$tag>$value</$tag>\n");
}
#@ _DISPLAY_CELL_

# Display a list of the existing grade events.  User can select any
# of them to add or edit scores for that event.  There is also a "new
# event" link for creating a new event.

#@ _DISPLAY_EVENTS_
function display_events ($dbh)
{
  print ("Select an event by clicking on its number, or select\n");
  print ("New Event to create a new grade event:<br /><br />\n");
  print ("<table border=\"1\">\n");

  # Print a row of table column headers

  print ("<tr>\n");
  display_cell ("th", "Event ID");
  display_cell ("th", "Date");
  display_cell ("th", "Category");
  print ("</tr>\n");

  # Present list of events.  Associate each event ID
  # with a link that shows the scores for the event.

  $stmt = "SELECT event_id, date, category
           FROM grade_event ORDER BY event_id";
  $sth = $dbh->query ($stmt);

  while ($row = $sth->fetch ())
  {
    print ("<tr>\n");
    $url = sprintf ("%s?action=%d&event_id=%d",
                    script_name (),
                    DISPLAY_SCORES,
                    $row["event_id"]);
    display_cell ("td",
                  "<a href=\"$url\">"
                    . $row["event_id"]
                    . "</a>",
                  FALSE);
    display_cell ("td", $row["date"]);
    display_cell ("td", $row["category"]);
    print ("</tr>\n");
  }

  # Add one more link for creating a new event

  print ("<tr align=\"center\">\n");
  $url = sprintf ("%s?action=%d",
                  script_name (),
                  SOLICIT_EVENT);
  display_cell ("td colspan=\"3\"",
                "<a href=\"$url\">Create New Event</a>",
                FALSE);
  print ("</tr>\n");

  print ("</table>\n");
}
#@ _DISPLAY_EVENTS_

# Present form to solicit information for new event

#@ _SOLICIT_EVENT_INFO_
function solicit_event_info ()
{
  printf ("<form method=\"post\" action=\"%s?action=%d\">\n",
          script_name (),
          ADD_EVENT);
  print ("Enter information for new grade event:<br /><br />\n");
  print ("Date: ");
  print ("<input type=\"text\" name=\"date\" value=\"\" size=\"10\" />\n");
  print ("<br />\n");
  print ("Category: ");
  print ("<input type=\"radio\" name=\"category\" value=\"T\"");
  print (" checked=\"checked\" />Test\n");
  print ("<input type=\"radio\" name=\"category\" value=\"Q\" />Quiz\n");
  print ("<br /><br />\n");
  print ("<input type=\"submit\" name=\"submit\" value=\"Submit\" />\n");
  print ("</form>\n");
}
#@ _SOLICIT_EVENT_INFO_

# Add new event to event table

#@ _ADD_NEW_EVENT_
function add_new_event ($dbh)
{
  $date = script_param ("date");          # get date and event category
  $category = script_param ("category");  # entered by user

  if (empty ($date))  # make sure a date was entered, and in ISO 8601 format
    die ("No date specified\n");
  if (!preg_match ('/^\d{4}\D\d{1,2}\D\d{1,2}$/', $date))
    die ("Please enter the date in ISO 8601 format (CCYY-MM-DD)\n");
  if ($category != "T" && $category != "Q")
    die ("Bad event category\n");

  $stmt = "INSERT INTO grade_event (date,category) VALUES(?,?)";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ($date, $category));
}
#@ _ADD_NEW_EVENT_

# Display all scores for a given event, sorted by student name.
# Names are displayed as static text, scores as editable fields.

#@ _DISPLAY_SCORES_
function display_scores ($dbh)
{
  # Get event ID number, which must look like an integer
  $event_id = script_param ("event_id");
  if (!ctype_digit ($event_id))
    die ("Bad event ID\n");

  # Select scores for the given event
  $stmt = "
    SELECT
      student.student_id, student.name, grade_event.date,
      score.score AS score, grade_event.category
    FROM student
      INNER JOIN grade_event
      LEFT JOIN score ON student.student_id = score.student_id
                      AND grade_event.event_id = score.event_id
    WHERE grade_event.event_id = ?
    ORDER BY student.name";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ($event_id));

  # Fetch the rows into an array so we know how many there are
  $rows = $sth->fetchAll ();
  if (count ($rows) == 0)
    die ("No information was found for the selected event\n");

  printf ("<form method=\"post\" action=\"%s?action=%d&event_id=%d\">\n",
          script_name (),
          ENTER_SCORES,
          $event_id);

  # Print scores as an HTML table

  for ($row_num = 0; $row_num < count ($rows); $row_num++)
  {
    $row = $rows[$row_num];
    # Print event info and table heading preceding the first row
    if ($row_num == 0)
    {
      printf ("Event ID: %d, Event date: %s, Event category: %s\n",
              $event_id,
              $row["date"],
              $row["category"]);
      print ("<br /><br />\n");
      print ("<table border=\"1\">\n");
      print ("<tr>\n");
      display_cell ("th", "Name");
      display_cell ("th", "Score");
      print "</tr>\n";
    }
    print ("<tr>\n");
    display_cell ("td", $row["name"]);
    $col_val = sprintf ("<input type=\"text\" name=\"score[%d]\"",
                        $row["student_id"]);
    $col_val .= sprintf (" value=\"%d\" size=\"5\" /><br />\n",
                         $row["score"]);
    display_cell ("td", $col_val, FALSE);
    print ("</tr>\n");
  }

  print ("</table>\n");
  print ("<br />\n");
  print ("<input type=\"submit\" name=\"submit\" value=\"Submit\" />\n");
  print "</form>\n";
}
#@ _DISPLAY_SCORES_

#@ _ENTER_SCORES_
function enter_scores ($dbh)
{
  # Get event ID number and array of scores for the event

  $event_id = script_param ("event_id");
#@ _GET_SCORE_PARAM_
  $score = script_param ("score");
#@ _GET_SCORE_PARAM_

  if (!ctype_digit ($event_id)) # must look like integer
    die ("Bad event ID\n");

  # Prepare the statements that are executed repeatedly
  $sth_del = $dbh->prepare ("DELETE FROM score
                             WHERE event_id = ? AND student_id = ?");
  $sth_repl = $dbh->prepare ("REPLACE INTO score
                              (event_id,student_id,score)
                              VALUES(?,?,?)");

  # Enter scores within a transaction
  try
  {
    $dbh->beginTransaction ();

    $blank_count = 0;
    $nonblank_count = 0;
    foreach ($score as $student_id => $new_score)
    {
      $new_score = trim ($new_score);
      if (empty ($new_score))
      {
        # If no score is provided for student in the form, delete any
        # score the student may have had in the database previously
        ++$blank_count;
        $sth = $sth_del;
        $params = array ($event_id, $student_id);
      }
      else if (ctype_digit ($new_score)) # must look like integer
      {
        # If a score is provided, replace any score that
        # might already be present in the database
        ++$nonblank_count;
        $sth = $sth_repl;
        $params = array ($event_id, $student_id, $new_score);
      }
      else
      {
        throw new PDOException ("invalid score: $new_score");
      }
      $sth->execute ($params);
    }
    # Transaction succeeded, commit it
    $dbh->commit ();
    printf ("Number of scores entered: %d<br />\n", $nonblank_count);
    printf ("Number of scores missing: %d<br />\n", $blank_count);
  }
  catch (PDOException $e)
  {
    printf ("Score entry failed: %s<br />\n",
            htmlspecialchars ($e->getMessage ()));
   # Roll back, but use empty exception handler to catch rollback failure
   try
   {
     $dbh->rollback ();
   }
   catch (PDOException $e) { }
  }
  print ("<br />\n");
}
#@ _ENTER_SCORES_

#@ _OUTLINE_PART_2_
$title = "Grade-Keeping Project -- Score Entry";
html_begin ($title, $title);

$dbh = sampdb_connect ();

# Determine what action to perform (the default is to
# present the initial page if no action is specified)

#@ _GET_ACTION_PARAM_
$action = script_param ("action");
#@ _GET_ACTION_PARAM_
if (is_null ($action))
  $action = SHOW_INITIAL_PAGE;

switch ($action)
{
case SHOW_INITIAL_PAGE:   # present initial page
  display_events ($dbh);
  break;
case SOLICIT_EVENT:       # ask for new event information
  solicit_event_info ();
  break;
case ADD_EVENT:           # add new event to database
  add_new_event ($dbh);
  display_events ($dbh);
  break;
case DISPLAY_SCORES:      # display scores for selected event
  display_scores ($dbh);
  break;
case ENTER_SCORES:        # enter new or edited scores
  enter_scores ($dbh);
  display_events ($dbh);
  break;
default:
  die ("Unknown action code ($action)\n");
}

$dbh = NULL;  # close connection

html_end ();
#@ _OUTLINE_PART_2_
?>
