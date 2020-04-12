<?php
#@ _COMMENT_
# sampdb_pdo.php - common functions for sampdb PDO-based PHP scripts
#@ _COMMENT_

#@ _SAMPDB_CONNECT_
# Function that uses our top-secret username and password to connect
# to the MySQL server to use the sampdb database. It also enables
# exceptions for errors that occur for subsequent PDO calls.
# Return value is the database handle produced by new PDO().

function sampdb_connect ()
{
  $dbh = new PDO("mysql:host=localhost;dbname=sampdb",
                 "sampadm", "secret");
  $dbh->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  return ($dbh);
}
#@ _SAMPDB_CONNECT_

# Put out initial HTML tags for page.  $title and $header, if
# present, are assumed to have any special characters properly
# encoded.

#@ _HTML_BEGIN_
function html_begin ($title, $header)
{
  print ("<html>\n");
  print ("<head>\n");
  if ($title != "")
    print ("<title>$title</title>\n");
  print ("</head>\n");
  print ("<body bgcolor=\"white\">\n");
  if ($header != "")
    print ("<h2>$header</h2>\n");
}
#@ _HTML_BEGIN_

# put out final HTML tags for page.

#@ _HTML_END_
function html_end ()
{
  print ("</body>\n");
  print ("</html>\n");
}
#@ _HTML_END_

# Generate Web form elements.  Arguments that become part of the
# content of the element are automatically HTML-encoded.

# Print hidden field

#@ _HIDDEN_FIELD_
function hidden_field ($name, $value)
{
  printf ("<input type=\"%s\" name=\"%s\" value=\"%s\" />\n",
          "hidden",
          htmlspecialchars ($name),
          htmlspecialchars ($value));
}
#@ _HIDDEN_FIELD_

# Print editable text entry field

#@ _TEXT_FIELD_
function text_field ($name, $value, $size)
{
  printf ("<input type=\"%s\" name=\"%s\" value=\"%s\" size=\"%s\" />\n",
          "text",
          htmlspecialchars ($name),
          htmlspecialchars ($value),
          htmlspecialchars ($size));
}
#@ _TEXT_FIELD_

# Print password entry field

function password_field ($name, $value, $size)
{
  printf ("<input type=\"%s\" name=\"%s\" value=\"%s\" size=\"%s\" />\n",
          "password",
          htmlspecialchars ($name),
          htmlspecialchars ($value),
          htmlspecialchars ($size));
}

# Print radio button.  $checked should be true if the box should be
# selected by default.

#@ _RADIO_BUTTON_
function radio_button ($name, $value, $label, $checked)
{
  printf ("<input type=\"%s\" name=\"%s\" value=\"%s\"%s />%s\n",
          "radio",
          htmlspecialchars ($name),
          htmlspecialchars ($value),
          ($checked ? " checked=\"checked\"" : ""),
          htmlspecialchars ($label));
}
#@ _RADIO_BUTTON_

# Print form submission button

#@ _SUBMIT_BUTTON_
function submit_button ($name, $value)
{
  printf ("<input type=\"%s\" name=\"%s\" value=\"%s\" />\n",
          "submit",
          htmlspecialchars ($name),
          htmlspecialchars ($value));
}
#@ _SUBMIT_BUTTON_

# script_param() extracts an input parameter from the script execution
# environment.
# If extra backslashes were added due to magic_quotes_gpc being
# enabled, it strips them using the remove_backslashes() function.
# track_vars is assumed to be enabled, but nothing is assumed about
# magic_quotes_gpc, and the function does not require register_globals to
# be enabled.

# remove_backslashes() takes into account whether the value is a scalar or
# an array.  It is recursive in case you create a form that takes advantage
# of the ability to created nested input parameters in PHP 4 and up.

#@ _REMOVE_BACKSLASHES_
function remove_backslashes ($val)
{
  if (is_array ($val))
  {
    foreach ($val as $k => $v)
      $val[$k] = remove_backslashes ($v);
  }
  else if (!is_null ($val))
    $val = stripslashes ($val);
  return ($val);
}
#@ _REMOVE_BACKSLASHES_

#@ _SCRIPT_PARAM_
function script_param ($name)
{
  $val = NULL;
  if (isset ($_GET[$name]))
    $val = $_GET[$name];
  else if (isset ($_POST[$name]))
    $val = $_POST[$name];
  if (get_magic_quotes_gpc ())
    $val = remove_backslashes ($val);
  return ($val);
}
#@ _SCRIPT_PARAM_

# Return the pathname of the current script.

#@ _SCRIPT_NAME_
function script_name ()
{
  return ($_SERVER["SCRIPT_NAME"]);
}
#@ _SCRIPT_NAME_

?>
