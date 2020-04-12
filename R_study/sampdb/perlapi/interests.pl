#!/usr/bin/perl
# interests.pl - find USHL members with a given interest by searching the
# interests field of the member table

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
@ARGV or die "Usage: interests.pl keyword\n";
search_members (shift (@ARGV)) while @ARGV;
#@ _MAIN_BODY_

$dbh->disconnect ();

#@ _SEARCH_MEMBERS_
sub search_members
{
my $interest = shift;

  print "Search results for keyword: $interest\n\n";
  my $sth = $dbh->prepare (qq{
              SELECT * FROM member WHERE interests LIKE ?
              ORDER BY last_name, first_name
            });
  # look for string anywhere in interest field
  $sth->execute ("%" . $interest . "%");
  my $count = 0;
  while (my $hash_ref = $sth->fetchrow_hashref ())
  {
    format_entry ($hash_ref);
    ++$count;
  }
  print "Number of matching entries: $count\n\n";
}
#@ _SEARCH_MEMBERS_

sub format_entry
{
my $entry_ref = shift;

  printf "Name: %s\n", format_name ($entry_ref);
  my $address = "";
  $address .= $entry_ref->{street} if $entry_ref->{street};
  $address .= ", " . $entry_ref->{city} if $entry_ref->{city};
  $address .= ", " . $entry_ref->{state} if $entry_ref->{state};
  $address .= " " . $entry_ref->{zip} if $entry_ref->{zip};
  print "Address: $address\n" if $address;
  print "Telephone: $entry_ref->{phone}\n" if $entry_ref->{phone};
  print "Email: $entry_ref->{email}\n" if $entry_ref->{email};
  print "Interests: $entry_ref->{interests}\n"
              if $entry_ref->{interests};
  print "\n";
}

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
