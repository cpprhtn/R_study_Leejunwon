#!/usr/bin/perl
# transaction.pl - demonstrate DBI's transaction abstraction

use strict;
use warnings;
use DBI;

# parse connection parameters from command line if given

use Getopt::Long;
$Getopt::Long::ignorecase = 0; # options are case sensitive
$Getopt::Long::bundling = 1;   # -uname = -u name, not -u -n -a -m -e

# default parameters - all undefined initially
my ($host_name, $password, $port_num, $socket_name, $user_name);

GetOptions (
  # =i means an integer value is required after option
  # =s means a string value is required after option
  "host|h=s"      => \$host_name,
  "password|p=s"  => \$password,
  "port|P=i"      => \$port_num,
  "socket|S=s"    => \$socket_name,
  "user|u=s"      => \$user_name
) or exit (1);

# construct data source
my $dsn = "DBI:mysql:sampdb";
$dsn .= ";host=$host_name" if $host_name;
$dsn .= ";port=$port_num" if $port_num;
$dsn .= ";mysql_socket=$socket_name" if $socket_name;
$dsn .= ";mysql_read_default_group=client";

# connect to server
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs);

#@ _TRANSACTION_
my $orig_re = $dbh->{RaiseError}; # save error-handling attributes
my $orig_pe = $dbh->{PrintError};
my $orig_ac = $dbh->{AutoCommit}; # save auto-commit mode

$dbh->{RaiseError} = 1;           # cause errors to raise exceptions
$dbh->{PrintError} = 0;           # but suppress error messages
$dbh->{AutoCommit} = 0;           # don't commit until we say so

eval
{
  # issue the statements that are part of the transaction
  my $sth = $dbh->prepare (qq{
              UPDATE score SET score = ?
              WHERE event_id = ? AND student_id = ?
            });
  $sth->execute (13, 5, 8);
  $sth->execute (18, 5, 9);
  $dbh->commit();                 # commit the transaction
};
if ($@)                           # did the transaction fail?
{
  print "A transaction error occurred: $@\n";
  # roll back, but use eval to trap rollback failure
  eval { $dbh->rollback (); }
}

$dbh->{AutoCommit} = $orig_ac;    # restore auto-commit mode
$dbh->{RaiseError} = $orig_re;    # restore error-handling attributes
$dbh->{PrintError} = $orig_pe;
#@ _TRANSACTION_

$dbh->disconnect ();
