#!/usr/bin/perl
# show_member.pl - quick display of Historical League member entries

# Usage: show_member [ member_number | last_name ]

# last_name can be a SQL pattern

use strict;
use warnings;
use DBI;

@ARGV or die "Usage: show_member [ member_number | last_name ]\n";

# host, user, password are assumed to come from option file

my $dsn = "DBI:mysql:sampdb;mysql_read_default_group=client";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);

#@ _MAIN_BODY_
my $count = 0;  # number of entries printed so far
my @label = (); # column label array
my $label_wid = 0;

while (@ARGV)   # run query for each argument on command line
{
  my $arg = shift (@ARGV);

  # default is a pattern search by last name...
  my $clause = "last_name LIKE " . $dbh->quote ($arg);
  # ...but do an ID search instead if argument is numeric
  $clause = "member_id = " . $dbh->quote ($arg) if $arg =~ /^\d+$/;

  # issue query
  my $sth = $dbh->prepare (qq{
              SELECT * FROM member
              WHERE $clause
              ORDER BY last_name, first_name
            });
  $sth->execute ();

  # get column names to use for labels and
  # determine max column name width for formatting
  # (but do this only the first time through the loop)
  if ($label_wid == 0)
  {
    @label = @{$sth->{NAME}};
    foreach my $label (@label)
    {
      $label_wid = length ($label) if $label_wid < length ($label);
    }
  }

  # read and display query result
  my $matches = 0;
  while (my @ary = $sth->fetchrow_array ())
  {
    # print newline before 2nd and subsequent entries
    print "\n" if ++$count > 1;
    foreach (my $i = 0; $i < $sth->{NUM_OF_FIELDS}; $i++)
    {
      # print label
      printf "%-*s", $label_wid+1, $label[$i] . ":";
      # print value, if there is one
      print " ", $ary[$i] if defined ($ary[$i]);
      print "\n";
    }
    ++$matches;
  }
  print "\nNo match was found for \"$arg\"\n" if $matches == 0;
}
#@ _MAIN_BODY_

$dbh->disconnect ();
