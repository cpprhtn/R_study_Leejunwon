#!/usr/bin/perl
# dump_members2.pl - dump Historical League membership list

use strict;
use warnings;
use DBI;

# data source name, username, password, connection attributes
my $dsn = "DBI:mysql:sampdb:localhost";
my $user_name = "sampadm";
my $password = "secret";
my %conn_attrs = (RaiseError => 0, PrintError => 0, AutoCommit => 1);

# connect to database
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs)
            or bail_out ("Cannot connect to database");

# issue query
my $sth = $dbh->prepare ("SELECT last_name, first_name, suffix, email,"
        . " street, city, state, zip, phone FROM member ORDER BY last_name")
          or bail_out ("Cannot prepare query");
$sth->execute ()
  or bail_out ("Cannot execute query");

# read and display query result
while (my @ary = $sth->fetchrow_array ())
{
  print join ("\t", @ary), "\n";
}
!$DBI::err
  or bail_out ("Error during retrieval");

$dbh->disconnect ()
  or bail_out ("Cannot disconnect from database");

# bail_out() subroutine - print error code and string, then exit

sub bail_out
{
my $message = shift;

  die "$message\nError $DBI::err ($DBI::errstr)\n";
}
