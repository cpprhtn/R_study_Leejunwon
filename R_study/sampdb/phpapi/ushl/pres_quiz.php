<?php
#@ _OUTLINE_PART_1_
# pres_quiz.php - script to quiz user on presidential birthplaces

require_once "sampdb_pdo.php";
#@ _OUTLINE_PART_1_

#@ _DISPLAY_FORM_
function display_form ($name, $place, $choices)
{
  printf ("<form method=\"post\" action=\"%s\">\n", script_name ());
  hidden_field ("name", $name);
  hidden_field ("place", $place);
  hidden_field ("choices", implode ("#", $choices));
  printf ("Where was %s born?<br /><br />\n", htmlspecialchars ($name));
  for ($i = 0; $i < 5; $i++)
  {
    radio_button ("response", $choices[$i], $choices[$i], FALSE);
    print ("<br />\n");
  }
  print ("<br />\n");
  submit_button ("submit", "Submit");
  print ("</form>\n");
}
#@ _DISPLAY_FORM_

#@ _SETUP_QUIZ_
function present_question ($dbh)
{
  # Issue statement to pick a president and get birthplace
  $stmt = "SELECT CONCAT(first_name, ' ', last_name) AS name,
           CONCAT(city, ', ', state) AS place
           FROM president ORDER BY RAND() LIMIT 1";
  $sth = $dbh->query ($stmt);
  $row = $sth->fetch ();
  $name = $row["name"];
  $place = $row["place"];

  # Construct the set of birthplace choices to present.
  # Set up the $choices array containing five birthplaces, one
  # of which is the correct response.
  $stmt = "SELECT DISTINCT CONCAT(city, ', ', state) AS place
           FROM president ORDER BY RAND() LIMIT 5";
  $sth = $dbh->query ($stmt);
  $choices[] = $place;  # initialize array with correct choice
  while (count ($choices) < 5 && $row = $sth->fetch ())
  {
    if ($row["place"] != $place)
      $choices[] = $row["place"]; # add another incorrect choice
  }
  # Randomize choices, display form
  shuffle ($choices);
  display_form ($name, $place, $choices);
}
#@ _SETUP_QUIZ_

# No validity checking is required for the parameters used by
# check_response(). We're not storing them into the database, we're
# just looking at them, and perhaps using them to create a new
# Web page.

#@ _CHECK_RESPONSE_
function check_response ($dbh)
{
  $name = script_param ("name");
  $place = script_param ("place");
  $choices = script_param ("choices");
  $response = script_param ("response");

  # Is the user's response the correct birthplace?

  if ($response == $place)
  {
    print ("That is correct!<br />\n");
    printf ("%s was born in %s.<br />\n",
            htmlspecialchars ($name),
            htmlspecialchars ($place));
    print ("Try the next question:<br /><br />\n");
    present_question($dbh);
  }
  else
  {
    printf ("\"%s\" is not correct.  Please try again.<br /><br />\n",
            htmlspecialchars ($response));
    $choices = explode ("#", $choices);
    display_form ($name, $place, $choices);
  }
}
#@ _CHECK_RESPONSE_

#@ _OUTLINE_PART_2_
$title = "U.S. President Quiz";
html_begin ($title, $title);

$dbh = sampdb_connect ();

#@ _TEST_RESPONSE_
$response = script_param ("response");
if (is_null ($response))   # invoked for first time
  present_question ($dbh);
else                       # user submitted response to form
  check_response ($dbh);
#@ _TEST_RESPONSE_

$dbh = NULL;  # close connection

html_end ();
#@ _OUTLINE_PART_2_
?>
