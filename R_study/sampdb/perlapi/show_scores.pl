#!/usr/bin/perl
# show_scores.pl - show Grade-Keeping Project scores for a given date

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

# check for a command-line argument, perform rudimentary format check
@ARGV == 1 or die "No date given\n";
$ARGV[0] =~ /^\d+\D\d+\D\d+$/ or die "Malformed date: $ARGV[0]\n";

# construct data source
my $dsn = "DBI:mysql:sampdb";
$dsn .= ";host=$host_name" if $host_name;
$dsn .= ";port=$port_num" if $port_num;
$dsn .= ";mysql_socket=$socket_name" if $socket_name;
$dsn .= ";mysql_read_default_group=client";

# connect to server
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs);

my $sth = $dbh->prepare (qq{
            SELECT
              student.name, grade_event.date, score.score, grade_event.category
            FROM
              student INNER JOIN score INNER JOIN grade_event
            WHERE
              student.student_id = score.student_id
              AND score.event_id = grade_event.event_id
              AND grade_event.date = ?
            ORDER BY
              grade_event.date ASC, grade_event.category ASC, score.score DESC
          });
$sth->execute ($ARGV[0]);

# print heading and the scores
printf "%-12s  %10s  %5s  %4s\n", "Name", "Date", "Score", "Type";
while (my $hash_ref = $sth->fetchrow_hashref ())
{
  printf "%-12s  %10s  %5s  %4s\n",
         $hash_ref->{name},
         $hash_ref->{date},
         $hash_ref->{score},
         $hash_ref->{category};
}

$dbh->disconnect ();
