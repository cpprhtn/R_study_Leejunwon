#!/usr/bin/perl
#@ _COMMENT_
# dump_members.pl - dump Historical League membership list
#@ _COMMENT_

#@ _USE_
use strict;
use warnings;
use DBI;
#@ _USE_

#@ _VARDECL_
# data source name, username, password, connection attributes
my $dsn = "DBI:mysql:sampdb:localhost";
my $user_name = "sampadm";
my $password = "secret";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
#@ _VARDECL_

#@ _CONNECT_
# connect to database
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs);
#@ _CONNECT_

#@ _ISSUE_QUERY_
# issue query
my $sth = $dbh->prepare ("SELECT last_name, first_name, suffix, email,"
        . " street, city, state, zip, phone FROM member ORDER BY last_name");
$sth->execute ();
#@ _ISSUE_QUERY_

#@ _FETCH_LOOP_
# read and display query result
while (my @ary = $sth->fetchrow_array ())
{
  print join ("\t", @ary), "\n";
}
$sth->finish ();
#@ _FETCH_LOOP_

#@ _TERMINATE_
$dbh->disconnect ();
#@ _TERMINATE_
