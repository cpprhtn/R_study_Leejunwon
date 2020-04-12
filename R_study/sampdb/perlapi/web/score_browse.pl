#!/usr/bin/perl
# score_browse.pl - browse grade-keeping project test and quiz scores

use strict;
use warnings;
use DBI;
use CGI qw(:standard escapeHTML escape);

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
# put out initial part of page
my $title = "Grade-Keeping Project -- Score Browser";
print header ();
print start_html (-title => $title, -bgcolor => "white");
print h1 ($title);

# parameter that tells us which grade event to display scores for
my $event_id = param ("event_id");

# if $event_id has no value, display the event list.
# otherwise display the scores for the given event.
if (!defined ($event_id))
{
  display_events ($dbh)
}
else
{
  display_scores ($dbh, $event_id);
}

print end_html ();
#@ _MAIN_BODY_

$dbh->disconnect ();

#@ _DISPLAY_EVENTS_
sub display_events
{
my $dbh = shift;
my @rows;
my @cells;

  print p ("Select an event by clicking on its number:");

  # get list of events
  my $sth = $dbh->prepare (qq{
              SELECT event_id, date, category
              FROM grade_event
              ORDER BY event_id
            });
  $sth->execute ();

  # use column names for table column headings
  for (my $i = 0; $i < $sth->{NUM_OF_FIELDS}; $i++)
  {
    push (@cells, th (escapeHTML ($sth->{NAME}->[$i])));
  }
  push (@rows, Tr (@cells));

  # display information for each event as a row in a table
  while (my ($event_id, $date, $category) = $sth->fetchrow_array ())
  {
    @cells = ();
    # display event ID as a hyperlink that reinvokes the script
    # to show the event's scores
    my $url = sprintf ("%s?event_id=%d", url (), $event_id);
    my $link = a ({-href => $url}, escapeHTML ($event_id));
    push (@cells, td ($link));
    # display event date and category
    push (@cells, td (escapeHTML ($date)));
    push (@cells, td (escapeHTML ($category)));
    push (@rows, Tr (@cells));
  }

  # display table with a border
  print table ({-border => "1"}, @rows);
}
#@ _DISPLAY_EVENTS_

#@ _DISPLAY_SCORES_
sub display_scores
{
my ($dbh, $event_id) = @_;
my @rows;
my @cells;

  # Generate a link to the script that does not include any event_id
  # parameter.  If the user selects this link, the script displays
  # the event list.
  print p (a ({-href => url ()}, "Show Event List"));

  # select scores for the given event
  my $sth = $dbh->prepare (qq{
              SELECT
                student.name,
                grade_event.date,
                score.score,
                grade_event.category
              FROM
                student INNER JOIN score INNER JOIN grade_event
              ON
                student.student_id = score.student_id
                AND score.event_id = grade_event.event_id
              WHERE
                grade_event.event_id = ?
              ORDER BY
                grade_event.date ASC,
                grade_event.category ASC,
                score.score DESC
  });
  $sth->execute ($event_id);  # bind event ID to placeholder in query

  print p (strong ("Scores for grade event $event_id"));

  # use column names for table column headings
  for (my $i = 0; $i < $sth->{NUM_OF_FIELDS}; $i++)
  {
    push (@cells, th (escapeHTML ($sth->{NAME}->[$i])));
  }
  push (@rows, Tr (@cells));

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
#@ _DISPLAY_SCORES_
