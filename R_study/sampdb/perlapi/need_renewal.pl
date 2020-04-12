#!/usr/bin/perl
# need_renewal.pl - find Historical League members that need to renew
# their memberships soon.  Default value for "soon" is 30 days.  A
# different value may be specified on the command line.

# Specifying a value of 0 finds those memberships that have already expired.

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

#@ _MAIN_BODY_
# use default cutoff of 30 days...
my $cutoff = 30;
# ...but reset if a numeric argument is given on the command line
$cutoff = shift (@ARGV) if @ARGV && $ARGV[0] =~ /^\d+$/;

# inform user what cutoff the script is using
warn "Using cutoff of $cutoff days\n";

my $sth = $dbh->prepare (qq{
            SELECT
              member_id, email, last_name, first_name, expiration,
              TO_DAYS(expiration) - TO_DAYS(CURDATE()) AS days
            FROM member
            WHERE expiration < DATE_ADD(CURDATE(), INTERVAL ? DAY)
            ORDER BY expiration, last_name, first_name
          });
$sth->execute ($cutoff);  # pass cutoff as placeholder value

while (my $entry_ref = $sth->fetchrow_hashref ())
{
  # convert undef values to empty strings for printing
  foreach my $key (keys (%{$entry_ref}))
  {
    $entry_ref->{$key} = "" if !defined ($entry_ref->{$key});
  }
  print join ("\t",
              $entry_ref->{member_id},
              $entry_ref->{email},
              $entry_ref->{last_name},
              $entry_ref->{first_name},
              $entry_ref->{expiration},
              $entry_ref->{days} . " days"),
        "\n";
}
#@ _MAIN_BODY_

$dbh->disconnect ();
