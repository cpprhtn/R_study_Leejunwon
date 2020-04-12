#!/usr/bin/perl
#@ _TITLE_
# db_browse.pl - Enable sampdb database browsing over the Web
#@ _TITLE_

# Be aware that installing this script has the potential for
# creating a security risk.  Be sure you understand the
# discussion of this issue as described in Chapter 8.

#@ _PREAMBLE_
use strict;
use warnings;
use DBI;
use CGI qw (:standard escapeHTML escape);
#@ _PREAMBLE_

use Cwd;
# option file that should contain connection parameters for UNIX
my $option_file = "/usr/local/apache/conf/sampdb.cnf";
my $option_drive_root;
# override file location for Windows
if ($^O =~ /^MSWin/i || $^O =~ /^dos/)
{
  $option_drive_root = "C:/";
  $option_file = "/Apache/conf/sampdb.cnf";
}

# construct data source and connect to server (under Windows, save
# current working directory first, change location to option file
# drive, connect, and restore current directory)
my $orig_dir;
if (defined ($option_drive_root))
{
  $orig_dir = cwd ();
  chdir ($option_drive_root)
    or die "Cannot chdir to $option_drive_root: $!\n";
}
my $dsn = "DBI:mysql:sampdb;mysql_read_default_file=$option_file";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);
if (defined ($option_drive_root))
{
  chdir ($orig_dir)
    or die "Cannot chdir to $orig_dir: $!\n";
}

#@ _MAIN_BODY_
my $db_name = "sampdb";

# put out initial part of page
my $title = "$db_name Database Browser";
print header ();
print start_html (-title => $title, -bgcolor => "white");
print h1 ($title);

# parameters to look for in URL
my $tbl_name = param ("tbl_name");
my $sort_col = param ("sort_col");

# If $tbl_name has no value, display a clickable list of tables.
# Otherwise, display contents of the given table.  $sort_col, if
# set, indicates which column to sort by.

if (!defined ($tbl_name))
{
  display_table_names ($dbh, $db_name)
}
else
{
  display_table_contents ($dbh, $db_name, $tbl_name, $sort_col);
}

print end_html ();
#@ _MAIN_BODY_

$dbh->disconnect ();

#@ _DISPLAY_TABLE_NAMES_
sub display_table_names
{
my ($dbh, $db_name) = @_;

  print p ("Select a table by clicking on its name:");

  # retrieve reference to single-column array of table names
  my $sth = $dbh->prepare (qq{
              SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
              WHERE TABLE_SCHEMA = ? ORDER BY TABLE_NAME
            });
  $sth->execute ($db_name);

  # Construct a bullet list using the ul() (unordered list) and
  # li() (list item) functions.  Each item is a hyperlink that
  # re-invokes the script to display a particular table.
  my @item;
  while (my ($tbl_name) = $sth->fetchrow_array ())
  {
    my $url = sprintf ("%s?tbl_name=%s", url (), escape ($tbl_name));
    my $link = a ({-href => $url}, escapeHTML ($tbl_name));
    push (@item, li ($link));
  }
  print ul (@item);
}
#@ _DISPLAY_TABLE_NAMES_

#@ _DISPLAY_TABLE_CONTENTS_
sub display_table_contents
{
my ($dbh, $db_name, $tbl_name, $sort_col) = @_;
my $sort_clause = "";
my @rows;
my @cells;

  # if sort column is specified, use it to sort the results
  if (defined ($sort_col))
  {
    $sort_clause = " ORDER BY " . $dbh->quote_identifier ($sort_col);
  }

  # present a link that returns user to table list page
  print p (a ({-href => url ()}, "Show Table List"));

  print p (strong ("Contents of $tbl_name table:"));

  my $sth = $dbh->prepare (
              "SELECT * FROM "
            . $dbh->quote_identifier ($db_name, $tbl_name)
            . "$sort_clause LIMIT 200"
            );
  $sth->execute ();

  # Use the names of the columns in the database table as the
  # headings in an HTML table.  Make each name a hyperlink that
  # causes the script to be reinvoked to redisplay the table,
  # sorted by the named column.

  foreach my $col_name (@{$sth->{NAME}})
  {
    my $url = sprintf ("%s?tbl_name=%s;sort_col=%s",
                       url (),
                       escape ($tbl_name),
                       escape ($col_name));
    my $link = a ({-href => $url}, escapeHTML ($col_name));
    push (@cells, th ($link));
  }
  push (@rows, Tr (@cells));

  # display table rows
  while (my @ary = $sth->fetchrow_array ())
  {
    @cells = ();
    foreach my $val (@ary)
    {
      # display value if non-empty, else display non-breaking space
      if (defined ($val) && $val ne "")
      {
        $val = escapeHTML ($val);
      }
      else
      {
        $val = "&nbsp;";
      }
      push (@cells, td ($val));
    }
    push (@rows, Tr (@cells));
  }

  # display table with a border
  print table ({-border => "1"}, @rows);
}
#@ _DISPLAY_TABLE_CONTENTS_
