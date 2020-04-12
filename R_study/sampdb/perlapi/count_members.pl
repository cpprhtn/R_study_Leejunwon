#!/usr/bin/perl
# count_members.pl - display count of Historical League membership

use strict;
use warnings;
use DBI;

# data source name, username, password, connection attributes
my $dsn = "DBI:mysql:sampdb:localhost";
my $user_name = "sampadm";
my $password = "secret";
my %conn_attrs = ( RaiseError => 1, PrintError => 0, AutoCommit => 1 );

# connect to database
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs);

#@ _PROCESS_QUERY_
# issue query
my $sth = $dbh->prepare ("SELECT COUNT(*) FROM member");
$sth->execute ();

# read and display query result
my $count = $sth->fetchrow_array ();
$sth->finish ();
$count = "can't tell" if !defined ($count);
print "$count\n";
#@ _PROCESS_QUERY_

$dbh->disconnect ();
