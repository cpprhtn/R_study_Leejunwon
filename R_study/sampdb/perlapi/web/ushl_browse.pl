#!/usr/bin/perl
# ushl_browse.pl - browse USHL membership by searching the
# interests column of the member table

use strict;
use warnings;
use DBI;
use CGI qw(:standard);

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

#@ _MAIN_BODY_1_
my $title = "U.S. Historical League Interest Search";
print header ();
print start_html (-title => $title, -bgcolor => "white");
print h1 ($title);

# parameter to look for
my $keyword = param ("keyword");

# Display a keyword entry form.  In addition, if $keyword is defined,
# search for and display a list of members who have that interest.

print start_form (-method => "post");
print p ("Enter a keyword to search for:");
print textfield (-name => "keyword", -value => "", -size => 40);
print submit (-name => "button", -value => "Search");
print end_form ();

# connect to server and run a search if a keyword was specified
if (defined ($keyword) && $keyword !~ /^\s*$/)
#@ _MAIN_BODY_1_
{
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
#@ _MAIN_BODY_2_
  search_members ($dbh, $keyword);
#@ _MAIN_BODY_2_
  $dbh->disconnect ();
#@ _MAIN_BODY_3_
}
#@ _MAIN_BODY_3_

print end_html ();

#@ _SEARCH_MEMBERS_
sub search_members
{
my ($dbh, $interest) = @_;

  print p ("Search results for keyword: " . escapeHTML ($interest));
  my $sth = $dbh->prepare (qq{
              SELECT * FROM member WHERE interests LIKE ?
              ORDER BY last_name, first_name
            });
  # look for string anywhere in interest field
  $sth->execute ("%" . $interest . "%");
  my $count = 0;
  while (my $ref = $sth->fetchrow_hashref ())
  {
    html_format_entry ($ref);
    ++$count;
  }
  print p ("Number of matching entries: $count");
}
#@ _SEARCH_MEMBERS_

sub format_name
{
my $entry_ref = shift;

  my $name = $entry_ref->{first_name} . " " . $entry_ref->{last_name};
  if (defined ($entry_ref->{suffix}))     # there is a name suffix
  {
    # no comma for suffixes of I, II, III, etc.
    $name .= "," unless $entry_ref->{suffix} =~ /^[IVX]+$/;
    $name .= " " . $entry_ref->{suffix}
  }
  return ($name);
}

#@ _HTML_FORMAT_ENTRY_
sub html_format_entry
{
my $entry_ref = shift;

  # encode characters that are special in HTML
  foreach my $key (keys (%{$entry_ref}))
  {
    next unless defined ($entry_ref->{$key});
    $entry_ref->{$key} = escapeHTML ($entry_ref->{$key});
  }
  print strong ("Name: " . format_name ($entry_ref)), br ();
  my $address = "";
  $address .= $entry_ref->{street}
                if defined ($entry_ref->{street});
  $address .= ", " . $entry_ref->{city}
                if defined ($entry_ref->{city});
  $address .= ", " . $entry_ref->{state}
                if defined ($entry_ref->{state});
  $address .= " " . $entry_ref->{zip}
                if defined ($entry_ref->{zip});
  print "Address: $address", br ()
                if $address ne "";
  print "Telephone: $entry_ref->{phone}", br ()
                if defined ($entry_ref->{phone});
  print "Email: $entry_ref->{email}", br ()
                if defined ($entry_ref->{email});
  print "Interests: $entry_ref->{interests}", br ()
                if defined ($entry_ref->{interests});
  print br ();
}
#@ _HTML_FORMAT_ENTRY_
